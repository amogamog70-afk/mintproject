return function(App)
 local Players=game:GetService("Players")
 local RunService=game:GetService("RunService")
 local LocalPlayer=Players.LocalPlayer
 local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")
 local C={Alive=true,GameAngle=0,ScopeAngle=0,Settings={Force=false,Custom=false,Size=100,Transparency=0,Length=8,Width=2,Gap=4,Dot=true,Outline=false,Color=Color3.fromRGB(242,245,250),Spin=false,SpinSpeed=90,ScopeSize=100,ScopeTransparency=0,ScopeLength=180,ScopeGap=6,ScopeSpin=false,ScopeSpinSpeed=90},Records={},Connections={},TargetConnections={},Strokes={},Stats={Errors=0}}
 App.Crosshair=C
 local Variables
 if game.GameId==6993600665 then pcall(function()Variables=require(game.ReplicatedFirst.Variables)end)end
 local function set(instance,property,value)
  if instance[property]~=value then instance[property]=value end
 end
 local function target(record,property)
  local value=record.Wanted[property]
  return type(value)=="function"and value(record.Original[property])or value
 end
 function C:Drop(instance,property)
  local record=self.Records[instance]
  if not record or record.Original[property]==nil then return end
  if record.Connections[property]then record.Connections[property]:Disconnect()end
  local original=record.Original[property]
  if instance==self.Frame and property=="Visible"and Variables then
   original=not (self.Scope and self.Scope.Visible)and not Variables.nocrosshair
  end
  pcall(function()instance[property]=original end)
  record.Original[property]=nil;record.Wanted[property]=nil;record.Connections[property]=nil
  if next(record.Original)==nil then self.Records[instance]=nil end
 end
 function C:Override(instance,property,value)
  if not instance then return end
  local record=self.Records[instance]
  if not record then record={Original={},Wanted={},Connections={}};self.Records[instance]=record end
  record.Wanted[property]=value
  if record.Original[property]==nil then
   record.Original[property]=instance[property]
   record.Connections[property]=instance:GetPropertyChangedSignal(property):Connect(function()
    if not self.Alive or record.Applying or not record.Wanted[property]and record.Wanted[property]~=false then return end
    local ok,err=pcall(function()
     local current=instance[property]
     if current~=target(record,property)then
      record.Original[property]=current
      record.Applying=true;set(instance,property,target(record,property));record.Applying=false
     end
    end)
    if not ok then record.Applying=false;self.Stats.Errors+=1;self.LastError=tostring(err)end
   end)
  end
  record.Applying=true;set(instance,property,target(record,property));record.Applying=false
 end
 function C:ScopeActive()
  return App.Removals and App.Removals.Settings.Scope and self.Scope and self.Scope.Visible or false
 end
 function C:UpdateScopeReticle()
  if not self.Root then return end
  if not self.ScopeReticle or self.ScopeReticle.Parent~=self.Root then
   if self.ScopeReticle then self.ScopeReticle:Destroy()end
   local root=Instance.new("Frame")
   root.Name="MintProjectScopeReticle";root.Size=UDim2.fromOffset(0,0);root.AnchorPoint=Vector2.new(.5,.5);root.BackgroundTransparency=1;root.BorderSizePixel=0;root.ZIndex=100;root.Visible=false;root.Parent=self.Root
   self.ScopeReticle=root;self.ScopeLines={}
   for _,name in ipairs({"Right","Left","Top","Bottom"})do
    local line=Instance.new("Frame")
    line.Name=name;line.BackgroundColor3=Color3.new(1,1,1);line.BorderSizePixel=0;line.ZIndex=101;line.Parent=root
    self.ScopeLines[name]=line
   end
  end
  local scale=self.Settings.ScopeSize/100
  local length=math.max(1,math.floor(self.Settings.ScopeLength*scale+.5))
  local gap=math.floor(self.Settings.ScopeGap*scale+.5)
  local width=math.max(1,math.floor(scale+.5))
  for _,part in pairs(self.ScopeLines)do set(part,"BackgroundTransparency",self.Settings.ScopeTransparency/100)end
  local root=self.ScopeReticle
  set(root,"Position",self.Frame and self.Frame.Position or UDim2.fromScale(.5,.5))
  set(root,"Visible",self:ScopeActive())
  set(root,"Rotation",self.Settings.ScopeSpin and self.Settings.ScopeSpinSpeed>0 and self.ScopeAngle or 0)
  local function line(name,anchor,position,size)
   local part=self.ScopeLines[name]
   set(part,"AnchorPoint",anchor);set(part,"Position",position);set(part,"Size",size)
  end
  line("Right",Vector2.new(0,.5),UDim2.fromOffset(gap,0),UDim2.fromOffset(length,width))
  line("Left",Vector2.new(1,.5),UDim2.fromOffset(-gap,0),UDim2.fromOffset(length,width))
  line("Top",Vector2.new(.5,1),UDim2.fromOffset(0,-gap),UDim2.fromOffset(width,length))
  line("Bottom",Vector2.new(.5,0),UDim2.fromOffset(0,gap),UDim2.fromOffset(width,length))
 end
 function C:UpdateSpin()
  if not self.Alive then return end
  local rootVisible=self.Root and self.Root.Enabled
  local gameSpin=rootVisible and self.Settings.Transparency<100 and self.Settings.Spin and self.Settings.SpinSpeed>0 and (self.Settings.Custom or self.Settings.Force)and self.Frame and self.Frame.Parent and self.Frame.Visible and not self:ScopeActive()
  local scopeSpin=rootVisible and self.Settings.ScopeTransparency<100 and self.Settings.ScopeSpin and self.Settings.ScopeSpinSpeed>0 and self:ScopeActive()
  if (gameSpin or scopeSpin)and not self.SpinConnection then
   self.SpinConnection=RunService.RenderStepped:Connect(function(dt)
    if not self.Alive then return end
    local ok,err=pcall(function()
     if self:ScopeActive()then
      if self.Settings.ScopeSpin and self.Settings.ScopeSpinSpeed>0 then
       self.ScopeAngle=(self.ScopeAngle+dt*self.Settings.ScopeSpinSpeed)%360
       set(self.ScopeReticle,"Rotation",self.ScopeAngle)
      end
     elseif self.Settings.Spin and self.Settings.SpinSpeed>0 and (self.Settings.Custom or self.Settings.Force)and self.Frame and self.Frame.Visible then
      self.GameAngle=(self.GameAngle+dt*self.Settings.SpinSpeed)%360
      self:Override(self.Frame,"Rotation",self.GameAngle)
     end
    end)
    if not ok then self.LastError=tostring(err);self.Stats.Errors+=1;if self.SpinConnection then self.SpinConnection:Disconnect();self.SpinConnection=nil end end
   end)
  elseif not gameSpin and not scopeSpin and self.SpinConnection then
   self.SpinConnection:Disconnect();self.SpinConnection=nil
  end
 end
 function C:Refresh()
  if not self.Alive or self.Refreshing then return end
  self.Refreshing=true
  local ok,err=pcall(function()
   local wanted={}
   local function want(instance,property,value)
    if not instance then return end
    wanted[instance]=wanted[instance]or {};wanted[instance][property]=value
   end
   local frame,scope=self.Frame,self.Scope
   if frame and frame.Parent then
    local scopedReticle=self:ScopeActive()
    if scopedReticle then want(frame,"Visible",false)elseif self.Settings.Force then want(frame,"Visible",true)end
    if self.Settings.Force or self.Settings.Custom or scopedReticle then want(self.CustomFrame,"Visible",false)end
    if self.Settings.Spin and self.Settings.SpinSpeed>0 and (self.Settings.Custom or self.Settings.Force)and not scopedReticle then want(frame,"Rotation",self.GameAngle)end
    if self.Settings.Custom then
     local s=self.Settings
     local scale=s.Size/100
     local length=math.max(1,math.floor(s.Length*scale+.5))
     local width=math.max(1,math.floor(s.Width*scale+.5))
     local gap=math.floor(s.Gap*scale+.5)
     local span=2*(length+gap)
     want(frame,"Size",function(native)return UDim2.new(native.X.Scale*scale,span,native.Y.Scale*scale,span)end)
     for _,name in ipairs({"Right","Left","Top","Bottom","Dot"})do
      local part=frame:FindFirstChild(name)
      if part and part:IsA("Frame")then
       want(part,"BackgroundColor3",s.Color)
       want(part,"BackgroundTransparency",s.Transparency/100)
       if name=="Right"or name=="Left"then want(part,"Size",UDim2.fromOffset(length,width))
       elseif name=="Top"or name=="Bottom"then want(part,"Size",UDim2.fromOffset(width,length))
       else want(part,"Size",UDim2.fromOffset(width,width));want(part,"Visible",s.Dot)end
       if s.Outline and not self.Strokes[part]then
        local stroke=Instance.new("UIStroke")
        stroke.Name="MintProjectCrosshairOutline";stroke.Thickness=1;stroke.Color=Color3.fromRGB(7,9,13);stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;stroke.Parent=part
        self.Strokes[part]=stroke
       end
       if self.Strokes[part]then set(self.Strokes[part],"Transparency",s.Transparency/100)end
      end
     end
    end
   end
   local remove={}
   for instance,record in pairs(self.Records)do
    for property in pairs(record.Original)do
     if not wanted[instance]or wanted[instance][property]==nil then table.insert(remove,{instance,property})end
    end
   end
   for _,entry in ipairs(remove)do self:Drop(entry[1],entry[2])end
   for instance,props in pairs(wanted)do for property,value in pairs(props)do self:Override(instance,property,value)end end
   for part,stroke in pairs(self.Strokes)do
    if not self.Settings.Custom or not self.Settings.Outline or not part.Parent then stroke:Destroy();self.Strokes[part]=nil end
   end
   self:UpdateScopeReticle();self:UpdateSpin()
  end)
  self.Refreshing=false
  if not ok then self.Stats.Errors+=1;self.LastError=tostring(err)end
 end
 function C:Resolve()
  if not self.Alive then return end
  local hud=PlayerGui:FindFirstChild("HUD")
  local root=hud and hud:FindFirstChild("Crosshair")
  local frame=root and root:FindFirstChild("Crosshair")
  local scope=root and root:FindFirstChild("ScopeCrosshair")
  if self.Frame~=frame or self.Scope~=scope then
   for _,connection in ipairs(self.TargetConnections)do connection:Disconnect()end
   table.clear(self.TargetConnections)
   self.Root=root;self.Frame=frame;self.Scope=scope;self.CustomFrame=root and root:FindFirstChild("CustomFrame")
   if scope then table.insert(self.TargetConnections,scope:GetPropertyChangedSignal("Visible"):Connect(function()self:Refresh()end))end
   if frame then table.insert(self.TargetConnections,frame:GetPropertyChangedSignal("Visible"):Connect(function()self:UpdateSpin()end))end
   if root then table.insert(self.TargetConnections,root:GetPropertyChangedSignal("Enabled"):Connect(function()self:UpdateSpin()end))end
   if root then table.insert(self.TargetConnections,root.ChildAdded:Connect(function()task.defer(function()self:Resolve();self:Refresh()end)end))end
  end
  self:Refresh()
 end
 function C:Set(key,value)
  self.Settings[key]=value
  if key=="Spin"and not value then self.GameAngle=0 end
  if key=="ScopeSpin"and not value then self.ScopeAngle=0 end
  self:Refresh()
 end
 function C:Destroy()
  if not self.Alive then return end
  self.Alive=false
  if self.SpinConnection then self.SpinConnection:Disconnect();self.SpinConnection=nil end
  for _,connection in ipairs(self.Connections)do connection:Disconnect()end
  for _,connection in ipairs(self.TargetConnections)do connection:Disconnect()end
  local remove={};for instance,record in pairs(self.Records)do for property in pairs(record.Original)do table.insert(remove,{instance,property})end end
  for _,entry in ipairs(remove)do self:Drop(entry[1],entry[2])end
  for _,stroke in pairs(self.Strokes)do stroke:Destroy()end
  if self.ScopeReticle then self.ScopeReticle:Destroy();self.ScopeReticle=nil end
  table.clear(self.Connections);table.clear(self.TargetConnections);table.clear(self.Strokes)
 end
 C:Resolve()
 if C.Frame then
  local right=C.Frame:FindFirstChild("Right")
  if right then C.Settings.Color=right.BackgroundColor3 end
 end
 local pending=false
 local function schedule()
  if pending or not C.Alive then return end
  pending=true;task.defer(function()pending=false;C:Resolve()end)
 end
 table.insert(C.Connections,PlayerGui.DescendantAdded:Connect(function(instance)
  if instance.Name=="Crosshair"or instance.Name=="ScopeCrosshair"or instance.Name=="CustomFrame"then schedule()end
 end))
 table.insert(C.Connections,LocalPlayer.CharacterAdded:Connect(schedule))
 local section=App.Tabs.Visuals:AddSection({Name="CROSSHAIR",Position="right"})
 section:AddLabel("Force crosshair"):AddToggle({Default=false,Flag="crosshair_force",Callback=function(v)C:Set("Force",v)end})
 local row=section:AddLabel("Game crosshair")
 local toggle=row:AddToggle({Default=false,Flag="crosshair_custom",Callback=function(v)C:Set("Custom",v)end})
 toggle.Root.LayoutOrder=10
 local color=row:AddColorPicker({Default=C.Settings.Color,Flag="crosshair_color",Callback=function(v)C:Set("Color",v)end})
 color.Root.LayoutOrder=0
 local options=row:AddOption();options.Trigger.LayoutOrder=20
 C.Options=options
 options:AddLabel("Size"):AddSlider({Default=100,Min=25,Max=300,Rounding=0,Type="%",Flag="crosshair_size",Callback=function(v)C:Set("Size",v)end})
 options:AddLabel("Transparency"):AddSlider({Default=0,Min=0,Max=100,Rounding=0,Type="%",Flag="crosshair_transparency",Callback=function(v)C:Set("Transparency",v)end})
 for _,entry in ipairs({{"Length","Length",1,30,8},{"Width","Width",1,8,2},{"Gap","Gap",0,20,4}})do
  local key=entry[1]
  options:AddLabel(entry[2]):AddSlider({Default=entry[5],Min=entry[3],Max=entry[4],Rounding=0,Flag="crosshair_"..key,Callback=function(v)C:Set(key,v)end})
 end
 options:AddLabel("Center dot"):AddToggle({Default=true,Flag="crosshair_dot",Callback=function(v)C:Set("Dot",v)end})
 options:AddLabel("Outline"):AddToggle({Default=false,Flag="crosshair_outline",Callback=function(v)C:Set("Outline",v)end})
 options:AddLabel("Spin"):AddToggle({Default=false,Flag="crosshair_spin",Callback=function(v)C:Set("Spin",v)end})
 options:AddLabel("Spin speed"):AddSlider({Default=90,Min=0,Max=360,Rounding=0,Flag="crosshair_spin_speed",Callback=function(v)C:Set("SpinSpeed",v)end})
 local scopeRow=App.Removals.Rows.Scope.Row
 local scopeOptions=scopeRow:AddOption();scopeOptions.Trigger.LayoutOrder=20
 C.ScopeOptions=scopeOptions
 scopeOptions:AddLabel("Size"):AddSlider({Default=100,Min=25,Max=300,Rounding=0,Type="%",Flag="scope_reticle_size",Callback=function(v)C:Set("ScopeSize",v)end})
 scopeOptions:AddLabel("Transparency"):AddSlider({Default=0,Min=0,Max=100,Rounding=0,Type="%",Flag="scope_reticle_transparency",Callback=function(v)C:Set("ScopeTransparency",v)end})
 scopeOptions:AddLabel("Length"):AddSlider({Default=180,Min=10,Max=600,Rounding=0,Flag="scope_reticle_length",Callback=function(v)C:Set("ScopeLength",v)end})
 scopeOptions:AddLabel("Gap"):AddSlider({Default=6,Min=0,Max=100,Rounding=0,Flag="scope_reticle_gap",Callback=function(v)C:Set("ScopeGap",v)end})
 scopeOptions:AddLabel("Spin"):AddToggle({Default=false,Flag="scope_reticle_spin",Callback=function(v)C:Set("ScopeSpin",v)end})
 scopeOptions:AddLabel("Spin speed"):AddSlider({Default=90,Min=0,Max=360,Rounding=0,Flag="scope_reticle_spin_speed",Callback=function(v)C:Set("ScopeSpinSpeed",v)end})
 local unload=App.Library.Unload
 function App.Library:Unload()C:Destroy();return unload(self)end
 return C
end
