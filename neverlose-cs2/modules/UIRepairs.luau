return function(Library)
 local UIS=game:GetService("UserInputService")
 local TextService=game:GetService("TextService")
 local S={Alive=true,Connections={},Pickers={},Options={},Sliders={},Drag=nil,ActivePicker=nil,ActiveOption=nil}
 Library.UIRepairs=S
 local function connect(signal,callback)
  local c=signal:Connect(callback);table.insert(S.Connections,c);return c
 end
 local function create(class,parent,props)
  local obj=Instance.new(class)
  for key,value in pairs(props or {})do obj[key]=value end
  obj.Parent=parent;return obj
 end
 local function corner(parent,radius)create("UICorner",parent,{CornerRadius=UDim.new(0,radius or 5)})end
 local function border(parent,color)create("UIStroke",parent,{Thickness=1,Color=color or Color3.fromRGB(48,51,64),Transparency=.25})end
 local function point(input)return Vector2.new(input.Position.X,input.Position.Y)end
 local function mouseDown(input)return input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch end
 local function inside(root,p)
  if not root or not root.Parent then return false end
  local x,y=root.AbsolutePosition,root.AbsoluteSize
  return p.X>=x.X and p.Y>=x.Y and p.X<=x.X+y.X and p.Y<=x.Y+y.Y
 end
 local function place(root,anchor)
  local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280,720)
  local size=root.Size
  local width,height=size.X.Offset,size.Y.Offset
  local origin=anchor.AbsolutePosition
  local x=origin.X+anchor.AbsoluteSize.X+8
  if x+width>viewport.X-8 then x=origin.X-width-8 end
  local y=origin.Y
  root.AnchorPoint=Vector2.zero
  root.Position=UDim2.fromOffset(math.clamp(x,8,math.max(8,viewport.X-width-8)),math.clamp(y,8,math.max(8,viewport.Y-height-8)))
 end
 local function closePopups()
  S.Drag=nil
  if S.ActivePicker then S.ActivePicker.SetRender(false)end
  if S.ActiveOption then S.ActiveOption.Signal:SetValue(false)end
 end
 S.ClosePopups=closePopups
 connect(UIS.InputChanged,function(input)
  if not S.Alive or not S.Drag then return end
  if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then S.Drag.Update(point(input))end
 end)
 connect(UIS.InputEnded,function(input)if mouseDown(input)then S.Drag=nil end end)
 connect(UIS.WindowFocusReleased,function()S.Drag=nil end)
 connect(UIS.InputBegan,function(input)
  if not mouseDown(input)then return end
  local p=point(input)
  if S.ActivePicker and inside(S.ActivePicker.Root,p)then return end
  if S.ActivePicker and not inside(S.ActivePicker.Root,p)and not inside(S.ActivePicker.Anchor,p)then S.ActivePicker.SetRender(false)end
  if S.ActiveOption and not inside(S.ActiveOption.Root,p)and not inside(S.ActiveOption.Anchor,p)then S.ActiveOption.Signal:SetValue(false)end
 end)
 function Library:CreateColorPicker(anchor)
  local z=anchor.ZIndex+130
  local root=create("Frame",nil,{Name="ColorPicker",Size=UDim2.fromOffset(220,254),BackgroundColor3=Color3.fromRGB(20,22,27),BorderSizePixel=0,ZIndex=z,Visible=false})
  corner(root,9);border(root)
  local sv=create("Frame",root,{Name="SaturationValue",Position=UDim2.fromOffset(10,10),Size=UDim2.fromOffset(200,180),BackgroundColor3=Color3.fromRGB(255,0,0),BorderSizePixel=0,ZIndex=z+1})
  corner(sv,4)
  local white=create("Frame",sv,{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=z+2})
  corner(white,4)
  create("UIGradient",white,{Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(1,1)})})
  local black=create("Frame",sv,{Size=UDim2.fromScale(1,1),BackgroundColor3=Color3.new(0,0,0),BorderSizePixel=0,ZIndex=z+3})
  corner(black,4)
  create("UIGradient",black,{Rotation=90,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(1,0)})})
  local marker=create("Frame",sv,{Name="Selection",AnchorPoint=Vector2.new(.5,.5),Size=UDim2.fromOffset(8,8),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=.35,BorderSizePixel=0,ZIndex=z+4})
  corner(marker,4);border(marker,Color3.new(1,1,1))
  local svInput=create("TextButton",sv,{Name="Input",Size=UDim2.fromScale(1,1),Text="",BackgroundTransparency=1,AutoButtonColor=false,ZIndex=z+5})
  local hue=create("Frame",root,{Name="Hue",Position=UDim2.fromOffset(10,202),Size=UDim2.fromOffset(200,10),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=z+1})
  corner(hue,3)
  local stops={};for i=0,6 do table.insert(stops,ColorSequenceKeypoint.new(i/6,Color3.fromHSV(i/6,1,1)))end
  create("UIGradient",hue,{Color=ColorSequence.new(stops)})
  local hueMarker=create("Frame",hue,{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(0,.5),Size=UDim2.fromOffset(3,14),BackgroundColor3=Color3.new(1,1,1),BorderSizePixel=0,ZIndex=z+2})
  border(hueMarker,Color3.new(0,0,0))
  local hueInput=create("TextButton",hue,{Size=UDim2.fromScale(1,1),Text="",BackgroundTransparency=1,AutoButtonColor=false,ZIndex=z+5})
  local hex=create("TextBox",root,{Name="Hex",Position=UDim2.fromOffset(10,222),Size=UDim2.fromOffset(200,23),BackgroundColor3=Color3.fromRGB(29,32,40),BorderSizePixel=0,TextColor3=Color3.fromRGB(232,235,243),Font=Enum.Font.GothamMedium,TextSize=12,Text="#FFFFFF",ClearTextOnFocus=false,ZIndex=z+1})
  corner(hex,4)
  local p={Root=root,Anchor=anchor,H=0,S=0,V=1,Callback=function()end,SV=sv,Hue=hue,Hex=hex}
  function p:Update()
   self.H=math.clamp(self.H,0,1);self.S=math.clamp(self.S,0,1);self.V=math.clamp(self.V,0,1)
   local color=Color3.fromHSV(self.H,self.S,self.V)
   sv.BackgroundColor3=Color3.fromHSV(self.H,1,1)
   marker.Position=UDim2.fromScale(self.S,1-self.V)
   hueMarker.Position=UDim2.fromScale(self.H,.5)
   hex.Text="#"..color:ToHex():upper()
   self.Callback(color)
  end
  function p:SetValue(color)
   if typeof(color)=="string"then
    local clean=color:gsub("#","")
    if not clean:match("^%x%x%x%x%x%x$")then hex.Text="#"..Color3.fromHSV(self.H,self.S,self.V):ToHex():upper();return false end
    color=Color3.fromHex(clean)
   end
   if typeof(color)~="Color3"then return false end
   self.H,self.S,self.V=color:ToHSV();self:Update();return true
  end
  function p:UpdateFromPosition(region,position)
   local surface=region=="Hue" and hue or sv
   local origin,size=surface.AbsolutePosition,surface.AbsoluteSize
   if size.X<=0 or size.Y<=0 then return end
   if region=="Hue"then self.H=math.clamp((position.X-origin.X)/size.X,0,1)
   else self.S=math.clamp((position.X-origin.X)/size.X,0,1);self.V=1-math.clamp((position.Y-origin.Y)/size.Y,0,1)end
   self:Update()
  end
  p.SetRender=function(value)
   if not S.Alive then return end
   if value then
    if S.ActivePicker and S.ActivePicker~=p then S.ActivePicker.SetRender(false)end
    S.ActivePicker=p;root.Parent=Library.ScreenGui;root.Visible=true;place(root,anchor)
   else
    if S.ActivePicker==p then S.ActivePicker=nil;S.Drag=nil end
    root.Visible=false;root.Parent=nil
   end
  end
  for _,entry in ipairs({{svInput,"SV"},{hueInput,"Hue"}})do
   local region=entry[2]
   connect(entry[1].InputBegan,function(input)
    if not mouseDown(input)then return end
    S.Drag={Update=function(pos)p:UpdateFromPosition(region,pos)end}
    p:UpdateFromPosition(region,point(input))
   end)
  end
  connect(hex.FocusLost,function()p:SetValue(hex.Text)end)
  table.insert(S.Pickers,p)
  return p
 end
 function Library:CreateOptionWindow(anchor,zindex)
  local z=(zindex or 9)+10
  local root=create("Frame",nil,{Name="Options",Size=UDim2.fromOffset(220,75),BackgroundColor3=Color3.fromRGB(20,22,27),BackgroundTransparency=.035,BorderSizePixel=0,ZIndex=z,Visible=false})
  corner(root,10)
  create("UIStroke",root,{Thickness=1,Color=Color3.fromRGB(45,48,58),Transparency=.65})
  local shadow=Library:CreateShadow(root)
  local content=create("ScrollingFrame",root,{Name="Content",Size=UDim2.fromScale(1,1),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=2,ScrollBarImageColor3=Color3.fromRGB(85,91,108),CanvasSize=UDim2.new(),AutomaticCanvasSize=Enum.AutomaticSize.Y,ZIndex=z+1})
  content:SetAttribute("CompactOptions",true)
  local list=create("UIListLayout",content,{SortOrder=Enum.SortOrder.LayoutOrder})
  local signal=Library:CreateSignal(false)
  local o={Root=root,Anchor=anchor,Signal=signal}
  local function resize()
   local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280,720)
   local height=list.AbsoluteContentSize.Y
   if height==0 then for _,child in ipairs(content:GetChildren())do if child:IsA("GuiObject")and child.Visible then height+=child.Size.Y.Offset end end end
   root.Size=UDim2.fromOffset(math.min(220,math.max(180,viewport.X-16)),math.clamp(height,30,math.max(30,viewport.Y-16)))
   if root.Parent then place(root,anchor)end
  end
  local function render(value)
   if not S.Alive then return end
   if value then
    if S.ActiveOption and S.ActiveOption~=o then S.ActiveOption.Signal:SetValue(false)end
    if S.ActivePicker then S.ActivePicker.SetRender(false)end
    S.ActiveOption=o;root.Parent=Library.ScreenGui;root.Visible=true;shadow:Render(true);resize()
   else
    if S.ActiveOption==o then S.ActiveOption=nil end
    if S.ActivePicker and S.ActivePicker.Anchor:IsDescendantOf(root)then S.ActivePicker.SetRender(false)end
    shadow:Render(false);root.Visible=false;root.Parent=nil
   end
  end
  connect(list:GetPropertyChangedSignal("AbsoluteContentSize"),resize)
  connect(content.ChildAdded,function()task.defer(resize)end)
  signal:Connect(render)
  local result=Library:RegisiterItem(content,signal)
  result.Root=root;result.Signal=signal;result.Winbdow={Signal=signal,SetRender=render};result.SetRender=render
  table.insert(S.Options,o)
  return result
 end
 local originalHandler=Library.RegisiterHandler
 function Library:RegisiterHandler(handler,signal)
  local h=originalHandler(self,handler,signal)
  local row=handler.Parent
  local label=row:FindFirstChildWhichIsA("TextLabel")
  local layout=handler:FindFirstChildOfClass("UIListLayout")
  local pending=false
  local function refresh()
   pending=false
   if not S.Alive or not handler.Parent or not label then return end
   local width=row.AbsoluteSize.X
   if width<=0 then width=row.Parent and row.Parent.AbsoluteSize.X or 220 end
   if width<=0 then width=220 end
   local controls,total,stacked=0,0,false
   local compact=row.Parent and row.Parent:GetAttribute("CompactOptions")
   for _,child in ipairs(handler:GetChildren())do if child:IsA("GuiObject")then
    if child:GetAttribute("FullWidthSlider")then
     child.Size=compact and UDim2.fromOffset(110,20)or UDim2.new(1,0,0,20)
     if not compact then stacked=true end
    end
    controls+=1;total+=child.Size.X.Offset
   end end
   total+=math.max(0,controls-1)*5
   local textWidth=TextService:GetTextSize(label.Text,label.TextSize,label.Font,Vector2.new(10000,100)).X
   if textWidth+total+34>width then stacked=true end
   label.TextWrapped=false;label.TextTruncate=Enum.TextTruncate.AtEnd
   label.Position=UDim2.fromOffset(11,6)
   if stacked then
    row.Size=UDim2.new(1,0,0,54);label.Size=UDim2.new(1,-22,0,17)
    handler.Position=UDim2.new(1,-11,0,27);handler.Size=UDim2.new(1,-22,0,22)
   else
    row.Size=UDim2.new(1,0,0,30);label.Size=UDim2.new(1,-math.max(22,total+32),0,17)
    handler.Position=UDim2.new(1,-11,0,2);handler.Size=UDim2.fromOffset(total,25)
   end
  end
  local function schedule()if not pending then pending=true;task.defer(refresh)end end
  connect(handler.ChildAdded,schedule);connect(handler.ChildRemoved,schedule);connect(row:GetPropertyChangedSignal("AbsoluteSize"),schedule)
  if layout then connect(layout:GetPropertyChangedSignal("AbsoluteContentSize"),schedule)end
  function h:AddColorPicker(config)
   config=config or {}
   local value=config.Default or Color3.new(1,1,1)
   if typeof(value)=="string"then value=Color3.fromHex(value:gsub("#",""))end
   local swatch=create("TextButton",handler,{Name="Color",Size=UDim2.fromOffset(18,18),Text="",BackgroundColor3=value,BorderSizePixel=0,AutoButtonColor=false,ZIndex=handler.ZIndex+14})
   corner(swatch,4);border(swatch)
   local backend=Library:CreateColorPicker(swatch)
   local c={Root=swatch,Picker=backend}
   backend.Callback=function(color)
    value=color;swatch.BackgroundColor3=color
    if config.Callback then config.Callback(color)end
   end
   backend:SetValue(value)
   function c:GetValue()return value end
   function c:SetValue(color)return backend:SetValue(color)end
   connect(swatch.Activated,function()backend.SetRender(S.ActivePicker~=backend)end)
   signal:Connect(function(visible)
    if not visible and S.ActivePicker==backend then backend.SetRender(false)end
   end)
   if config.Flag then Library.Flags[config.Flag]=c end
   schedule();return c
  end
  function h:AddOption(iconMode)
   local trigger=create("Frame",handler,{Name="OptionsButton",Size=UDim2.fromOffset(20,18),BackgroundColor3=Color3.fromRGB(39,42,52),BackgroundTransparency=1,BorderSizePixel=0,ZIndex=handler.ZIndex+14,LayoutOrder=20})
   corner(trigger,4)
   if iconMode==2 then
    for _,angle in ipairs({-45,45})do create("Frame",trigger,{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset(10,angle<0 and 7 or 11),Size=UDim2.fromOffset(7,2),Rotation=angle,BackgroundColor3=Color3.fromRGB(210,216,230),BorderSizePixel=0,ZIndex=trigger.ZIndex+1})end
   else
    for i=0,2 do
     local dot=create("Frame",trigger,{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromOffset(5+i*5,9),Size=UDim2.fromOffset(3,3),BackgroundColor3=Color3.fromRGB(210,216,230),BorderSizePixel=0,ZIndex=trigger.ZIndex+1})
     corner(dot,2)
    end
   end
   local button=create("TextButton",trigger,{Name="Input",Size=UDim2.fromScale(1,1),Text="",BackgroundTransparency=1,AutoButtonColor=false,ZIndex=trigger.ZIndex+2})
   local option=Library:CreateOptionWindow(trigger,handler.ZIndex+13)
   option.Trigger=trigger
   connect(button.Activated,function()option.Signal:SetValue(not option.Signal:GetValue())end)
   connect(button.MouseEnter,function()trigger.BackgroundTransparency=.4 end)
   connect(button.MouseLeave,function()trigger.BackgroundTransparency=1 end)
   signal:Connect(function(visible)if not visible then option.Signal:SetValue(false)end end)
   schedule();return option
  end
  function h:AddSlider(config)
   config=config or {}
   local min,max=tonumber(config.Min)or 0,tonumber(config.Max)or 100
   if max<min then min,max=max,min end
   local decimals=math.clamp(tonumber(config.Rounding)or 0,0,5)
   local suffix=tostring(config.Type or ""):gsub("%%%%","%%")
   local callback=config.Callback or function()end
   local root=create("Frame",handler,{Name="Slider",Size=UDim2.new(1,0,0,20),BackgroundTransparency=1,ZIndex=handler.ZIndex+13})
   root:SetAttribute("FullWidthSlider",true)
   local input=create("TextBox",root,{Name="Value",AnchorPoint=Vector2.new(1,0),Position=UDim2.fromScale(1,0),Size=UDim2.fromOffset(52,20),BackgroundColor3=Color3.fromRGB(29,32,40),BorderSizePixel=0,TextColor3=Color3.fromRGB(226,230,240),Font=Enum.Font.GothamMedium,TextSize=11,ClearTextOnFocus=false,ZIndex=root.ZIndex+2})
   corner(input,4);border(input)
   local track=create("Frame",root,{Name="Track",Position=UDim2.fromOffset(1,8),Size=UDim2.new(1,-64,0,4),BackgroundColor3=Color3.fromRGB(47,50,62),BorderSizePixel=0,ZIndex=root.ZIndex})
   corner(track,2)
   local fill=create("Frame",track,{Size=UDim2.fromScale(0,1),BackgroundColor3=Library.AccentColor,BorderSizePixel=0,ZIndex=root.ZIndex+1})
   corner(fill,2)
   local knob=create("Frame",fill,{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(1,.5),Size=UDim2.fromOffset(8,8),BackgroundColor3=Color3.fromRGB(234,238,248),BorderSizePixel=0,ZIndex=root.ZIndex+2})
   corner(knob,4)
   local button=create("TextButton",root,{Name="Drag",Size=UDim2.new(1,-60,1,0),Text="",BackgroundTransparency=1,AutoButtonColor=false,ZIndex=root.ZIndex+4})
   local c={Root=root,Input=input,Track=track,Min=min,Max=max,Value=0}
   local function update()
    local value=c.Value
    input.Text=config.Nums and config.Nums[value]or tostring(value)..suffix
    local size=math.max(38,TextService:GetTextSize(input.Text,11,Enum.Font.GothamMedium,Vector2.new(10000,100)).X+14)
    input.Size=UDim2.fromOffset(size,20);track.Size=UDim2.new(1,-size-12,0,4);button.Size=UDim2.new(1,-size-8,1,0)
    fill.Size=UDim2.fromScale(max>min and (value-min)/(max-min)or 0,1)
   end
   function c:GetValue()return self.Value end
   function c:SetValue(value)
    value=tonumber(value)
    if not value or value~=value or value==math.huge or value==-math.huge then update();return false end
    local power=10^decimals
    self.Value=math.clamp(math.floor(value*power+.5)/power,min,max)
    update();callback(self.Value);return true
   end
   function c:UpdateFromPosition(position)
    local width=track.AbsoluteSize.X;if width<=0 then return end
    self:SetValue(min+(max-min)*math.clamp((position.X-track.AbsolutePosition.X)/width,0,1))
   end
   connect(button.InputBegan,function(event)
    if not mouseDown(event)then return end
    S.Drag={Update=function(pos)c:UpdateFromPosition(pos)end};c:UpdateFromPosition(point(event))
   end)
   connect(input.FocusLost,function()
    local value=input.Text:match("[-+]?%d*%.?%d+")
    c:SetValue(value)
   end)
   if config.Flag then Library.Flags[config.Flag]=c end
   c.Value=math.clamp(tonumber(config.Default)or min,min,max);update()
   table.insert(S.Sliders,c);schedule()
   return c
  end
  schedule();return h
 end
 local originalWindow=Library.CreateWindow
 function Library:CreateWindow(config)
  local window=originalWindow(self,config)
  window.Signal:Connect(function(value)if not value then closePopups()end end)
  local addTab=window.AddTab
  function window:AddTab(data)
   local tab=addTab(self,data)
   tab.Signal:Connect(function(value)if not value then closePopups()end end)
   return tab
  end
  return window
 end
 function S:Destroy()
  if not self.Alive then return end
  closePopups();self.Alive=false
  for _,connection in ipairs(self.Connections)do connection:Disconnect()end
  for _,p in ipairs(self.Pickers)do p.Root:Destroy()end
  for _,o in ipairs(self.Options)do o.Root:Destroy()end
  table.clear(self.Connections)
 end
 local unload=Library.Unload
 function Library:Unload()S:Destroy();return unload(self)end
 return S
end
