return function(App)
 local Players=game:GetService("Players")
 local RunService=game:GetService("RunService")
 local UIS=game:GetService("UserInputService")
 local GuiService=game:GetService("GuiService")
 local player=Players.LocalPlayer
 local Variables
 if game.GameId==6993600665 then pcall(function()Variables=require(game.ReplicatedFirst.Variables)end)end
 local M={Alive=true,Focused=true,Connections={},Settings={Bhop=false,AirStrafe=false,HoldSpace=true,AirSpeed=100,Steering=10},Stats={Errors=0,Jumps=0,Steered=0,NativeSpeed=0,SpeedCap=0}}
 App.Movement=M
 local excluded={
  [Enum.HumanoidStateType.Dead]=true,[Enum.HumanoidStateType.Swimming]=true,
  [Enum.HumanoidStateType.Climbing]=true,[Enum.HumanoidStateType.Seated]=true,
  [Enum.HumanoidStateType.Physics]=true,[Enum.HumanoidStateType.PlatformStanding]=true,
  [Enum.HumanoidStateType.Ragdoll]=true,[Enum.HumanoidStateType.FallingDown]=true,
 }
 function M:ComputeAirVelocity(velocity,wish,cap,dt)
  if cap<=0 or dt<=0 then return velocity end
  wish=Vector3.new(wish.X,0,wish.Z)
  if wish.Magnitude<.01 then return velocity end
  local flat=Vector3.new(velocity.X,0,velocity.Z)
  -- Preserve game knockback/boosts; ordinary steering never creates speed above the cap.
  if flat.Magnitude>math.max(cap,self.Stats.NativeSpeed)*1.25 then return velocity end
  local alpha=1-math.exp(-self.Settings.Steering*math.min(dt,.1))
  local steered=flat:Lerp(wish.Unit*cap,alpha)
  if steered.Magnitude>cap then steered=steered.Unit*cap end
  return Vector3.new(steered.X,velocity.Y,steered.Z)
 end
 function M:ReleaseJump()
  if self.JumpHumanoid then pcall(function()self.JumpHumanoid.Jump=false end)end
  self.JumpHumanoid=nil;self.WasGrounded=false;self.LastJump=0
 end
 function M:StepCharacter(humanoid,root,dt,space,now)
  local state=humanoid:GetState()
  if humanoid.Health<=0 or humanoid.Sit or humanoid.PlatformStand or root.Anchored or excluded[state]then return end
  local speed=humanoid.WalkSpeed
  self.Stats.NativeSpeed=speed
  self.Stats.SpeedCap=speed*self.Settings.AirSpeed/100
  if speed<=0 then return end
  local grounded=humanoid.FloorMaterial~=Enum.Material.Air or state==Enum.HumanoidStateType.Landed
  local airborne=not grounded and (state==Enum.HumanoidStateType.Freefall or state==Enum.HumanoidStateType.Jumping)
  local moving=humanoid.MoveDirection.Magnitude>.01
  if not grounded then self.WasGrounded=false end
  local jumpAllowed=humanoid:GetStateEnabled(Enum.HumanoidStateType.Jumping)and (humanoid.UseJumpPower and humanoid.JumpPower>0 or not humanoid.UseJumpPower and humanoid.JumpHeight>0)
  if self.Settings.Bhop and grounded and jumpAllowed and not self.WasGrounded and now-(self.LastJump or 0)>=.1 and (self.Settings.HoldSpace and space or not self.Settings.HoldSpace and moving)then
   humanoid.Jump=true;self.JumpHumanoid=humanoid;self.WasGrounded=true;self.LastJump=now;self.Stats.Jumps+=1
  end
  if self.Settings.AirStrafe and airborne and moving and (not self.Settings.HoldSpace or space)then
   local current=root.AssemblyLinearVelocity
   local nextVelocity=self:ComputeAirVelocity(current,humanoid.MoveDirection,self.Stats.SpeedCap,dt)
   if nextVelocity~=current then root.AssemblyLinearVelocity=nextVelocity;self.Stats.Steered+=1 end
  end
 end
 function M:Step(dt)
  if not self.Alive then return end
  if not self.Focused or UIS:GetFocusedTextBox()or GuiService.MenuIsOpen or App.Window.Signal:GetValue()or player:GetAttribute("Alive")==false then self:ReleaseJump();return end
  if Variables and (Variables.spectator or Variables.nomovement or Variables.climbing or Variables.push and Variables.push>0)then self:ReleaseJump();return end
  local controls=player.PlayerScripts:FindFirstChild("ControlScript")
  local disabled=controls and controls:FindFirstChild("Dis")
  if disabled and disabled.Value then self:ReleaseJump();return end
  local character=player.Character
  local humanoid=character and character:FindFirstChildOfClass("Humanoid")
  local root=character and character:FindFirstChild("HumanoidRootPart")
  if not humanoid or not root then self:ReleaseJump();return end
  if self.Humanoid~=humanoid then self:ReleaseJump();self.Humanoid=humanoid end
  self:StepCharacter(humanoid,root,dt,UIS:IsKeyDown(Enum.KeyCode.Space),os.clock())
 end
 function M:UpdateDriver()
  local active=self.Alive and (self.Settings.Bhop or self.Settings.AirStrafe)
  if active and not self.Driver then
   self.Driver=RunService.PreSimulation:Connect(function(dt)
    local ok,err=pcall(self.Step,self,dt)
    if not ok then self.Stats.Errors+=1;self.LastError=tostring(err);self:ReleaseJump();if self.Driver then self.Driver:Disconnect();self.Driver=nil end end
   end)
  elseif not active and self.Driver then self.Driver:Disconnect();self.Driver=nil;self:ReleaseJump()end
 end
 function M:Set(key,value)
  self.Settings[key]=value
  if key=="Bhop"and not value then self:ReleaseJump()end
  self:UpdateDriver()
 end
 function M:Destroy()
  if not self.Alive then return end
  self.Alive=false;self:UpdateDriver();self:ReleaseJump()
  for _,c in ipairs(self.Connections)do c:Disconnect()end
  table.clear(self.Connections)
 end
 table.insert(M.Connections,UIS.WindowFocusReleased:Connect(function()M.Focused=false;M:ReleaseJump()end))
 table.insert(M.Connections,UIS.WindowFocused:Connect(function()M.Focused=true end))
 table.insert(M.Connections,player.CharacterRemoving:Connect(function()M:ReleaseJump();M.Humanoid=nil end))
 table.insert(M.Connections,App.Window.Signal:Connect(function(visible)if visible then M:ReleaseJump()end end))
 local section=App.Tabs.Movement:AddSection({Name="MOVEMENT",Position="left"})
 local bhop=section:AddLabel("B-hop")
 local bToggle=bhop:AddToggle({Default=false,Flag="movement_bhop",Callback=function(v)M:Set("Bhop",v)end});bToggle.Root.LayoutOrder=10
 local bOptions=bhop:AddOption();bOptions.Trigger.LayoutOrder=20;M.BhopOptions=bOptions
 bOptions:AddLabel("Hold Space"):AddToggle({Default=true,Flag="movement_hold_space",Callback=function(v)M:Set("HoldSpace",v)end})
 local air=section:AddLabel("Air strafe")
 local aToggle=air:AddToggle({Default=false,Flag="movement_air_strafe",Callback=function(v)M:Set("AirStrafe",v)end});aToggle.Root.LayoutOrder=10
 local aOptions=air:AddOption();aOptions.Trigger.LayoutOrder=20;M.AirOptions=aOptions
 aOptions:AddLabel("Speed limit"):AddSlider({Default=100,Min=25,Max=100,Rounding=0,Type="%",Flag="movement_air_speed",Callback=function(v)M:Set("AirSpeed",v)end})
 aOptions:AddLabel("Steering"):AddSlider({Default=10,Min=1,Max=30,Rounding=0,Flag="movement_air_steering",Callback=function(v)M:Set("Steering",v)end})
 local unload=App.Library.Unload
 function App.Library:Unload()M:Destroy();return unload(self)end
 return M
end
