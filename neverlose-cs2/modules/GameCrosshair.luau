return function(App)
 local Players=game:GetService("Players")
 local LocalPlayer=Players.LocalPlayer
 local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")
 local C={Alive=true,Settings={Force=false,Custom=false,Length=8,Width=2,Gap=4,Dot=true,Outline=false,Color=Color3.fromRGB(242,245,250)},Records={},Connections={},TargetConnections={},Strokes={},Stats={Errors=0}}
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
    local fallback=App.Removals and App.Removals.Settings.Scope and scope and scope.Visible
    if self.Settings.Force or fallback then want(frame,"Visible",true)end
    if self.Settings.Force or self.Settings.Custom or fallback then want(self.CustomFrame,"Visible",false)end
    if self.Settings.Custom then
     local s=self.Settings
     local span=2*(s.Length+s.Gap)
     want(frame,"Size",function(native)return UDim2.new(native.X.Scale,span,native.Y.Scale,span)end)
     for _,name in ipairs({"Right","Left","Top","Bottom","Dot"})do
      local part=frame:FindFirstChild(name)
      if part and part:IsA("Frame")then
       want(part,"BackgroundColor3",s.Color)
       if name=="Right"or name=="Left"then want(part,"Size",UDim2.fromOffset(s.Length,s.Width))
       elseif name=="Top"or name=="Bottom"then want(part,"Size",UDim2.fromOffset(s.Width,s.Length))
       else want(part,"Size",UDim2.fromOffset(s.Width,s.Width));want(part,"Visible",s.Dot)end
       if s.Outline and not self.Strokes[part]then
        local stroke=Instance.new("UIStroke")
        stroke.Name="MintProjectCrosshairOutline";stroke.Thickness=1;stroke.Color=Color3.fromRGB(7,9,13);stroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border;stroke.Parent=part
        self.Strokes[part]=stroke
       end
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
   if root then table.insert(self.TargetConnections,root.ChildAdded:Connect(function()task.defer(function()self:Resolve();self:Refresh()end)end))end
  end
  self:Refresh()
 end
 function C:Set(key,value)self.Settings[key]=value;self:Refresh()end
 function C:Destroy()
  if not self.Alive then return end
  self.Alive=false
  for _,connection in ipairs(self.Connections)do connection:Disconnect()end
  for _,connection in ipairs(self.TargetConnections)do connection:Disconnect()end
  local remove={};for instance,record in pairs(self.Records)do for property in pairs(record.Original)do table.insert(remove,{instance,property})end end
  for _,entry in ipairs(remove)do self:Drop(entry[1],entry[2])end
  for _,stroke in pairs(self.Strokes)do stroke:Destroy()end
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
 for _,entry in ipairs({{"Length","Length",1,30,8},{"Width","Width",1,8,2},{"Gap","Gap",0,20,4}})do
  local key=entry[1]
  options:AddLabel(entry[2]):AddSlider({Default=entry[5],Min=entry[3],Max=entry[4],Rounding=0,Flag="crosshair_"..key,Callback=function(v)C:Set(key,v)end})
 end
 options:AddLabel("Center dot"):AddToggle({Default=true,Flag="crosshair_dot",Callback=function(v)C:Set("Dot",v)end})
 options:AddLabel("Outline"):AddToggle({Default=false,Flag="crosshair_outline",Callback=function(v)C:Set("Outline",v)end})
 local unload=App.Library.Unload
 function App.Library:Unload()C:Destroy();return unload(self)end
 return C
end
