return function(App,WhiteIcons)
 local Players=game:GetService("Players")
 local RunService=game:GetService("RunService")
 local LocalPlayer=Players.LocalPlayer
 assert(Drawing and Drawing.new,"Drawing API unavailable")
 local ESP={Alive=true,Enabled=false,Entries={},Connections={},ItemCatalog={},Settings={Box=true,Names=true,Distance=true,Health=true,HealthNumber=true,ItemName=true,ItemIcon=true,TeamCheck=false,MaxDistance=1800,TextSize=13,Color=Color3.fromRGB(225,233,245)},Stats={Visible=0,Tracked=0,Drawings=0,Icons=0,FrameMs=0,Errors=0}}
 App.ESP=ESP
 local Overlay=Instance.new("ScreenGui")
 Overlay.Name="MintProjectEquipmentESP";Overlay.IgnoreGuiInset=true;Overlay.ResetOnSpawn=false;Overlay.DisplayOrder=100
 Overlay.Parent=LocalPlayer:WaitForChild("PlayerGui")
 ESP.Overlay=Overlay
 local whiteAssets={}
 local iconFolder="MintProject/ESP/Icons-v2"
 if not isfolder(iconFolder)then makefolder(iconFolder)end
 for id,payload in pairs(WhiteIcons or {})do
  local ok,asset=pcall(function()
   local file=iconFolder.."/"..id..".png"
   if not isfile(file)then writefile(file,App.Library.Base64Decode(payload))end
   return getcustomasset(file)
  end)
  if ok then whiteAssets[id]=asset else ESP.IconError=tostring(asset)end
 end
 local weapons=game:GetService("ReplicatedStorage"):FindFirstChild("Weapons")
 if weapons then
  for _,weapon in ipairs(weapons:GetChildren())do
   local image=weapon:GetAttribute("Killicon")
   local id=type(image)=="string" and image:match("%d+")
   ESP.ItemCatalog[weapon.Name]={Name=weapon.Name,Image=type(image)=="string" and image or "",WhiteImage=id and whiteAssets[id] or ""}
  end
 end
 local BLACK=Color3.fromRGB(7,9,13)
 local WHITE=Color3.fromRGB(242,245,250)
 local MUTED=Color3.fromRGB(183,196,212)
 ESP.ColorRevision=0
 local colors={NameColor=WHITE,DistanceColor=MUTED,ItemColor=MUTED,IconColor=WHITE,BoxOutlineColor=BLACK,TextOutlineColor=BLACK,IconOutlineColor=BLACK,HealthOutlineColor=BLACK,HealthTrackColor=Color3.fromRGB(28,32,38),HealthHighColor=Color3.fromRGB(113,224,154),HealthMidColor=Color3.fromRGB(244,191,76),HealthLowColor=Color3.fromRGB(237,79,87)}
 for key,value in pairs(colors)do ESP.Settings[key]=value end
 ESP.Settings.HealthGradient=true
 ESP.Settings.HealthWidth=2
 ESP.Settings.OriginalIcons=false
 local BODY={Head=true,Torso=true,UpperTorso=true,LowerTorso=true,["Left Arm"]=true,["Right Arm"]=true,["Left Leg"]=true,["Right Leg"]=true,LeftUpperArm=true,LeftLowerArm=true,LeftHand=true,RightUpperArm=true,RightLowerArm=true,RightHand=true,LeftUpperLeg=true,LeftLowerLeg=true,LeftFoot=true,RightUpperLeg=true,RightLowerLeg=true,RightFoot=true}
 local CORNERS={Vector3.new(-1,-1,-1),Vector3.new(-1,-1,1),Vector3.new(-1,1,-1),Vector3.new(-1,1,1),Vector3.new(1,-1,-1),Vector3.new(1,-1,1),Vector3.new(1,1,-1),Vector3.new(1,1,1)}
 local floor,clamp=math.floor,math.clamp
 local function set(object,key,value)
  if object.Cache[key]~=value then object.Cache[key]=value;object.Draw[key]=value end
 end
 local function make(entry,kind,properties)
  local obj={Draw=Drawing.new(kind),Cache={}}
  table.insert(entry.Objects,obj);ESP.Stats.Drawings+=1
  properties.Visible=false
  for key,value in pairs(properties)do set(obj,key,value)end
  return obj
 end
 local function hide(entry)
  if not entry.Visible then return end
  entry.Visible=false
  for _,object in ipairs(entry.Objects)do set(object,"Visible",false)end
  for _,object in ipairs(entry.GUIObjects)do set(object,"Visible",false)end
 end
 local function show(object,visible)set(object,"Visible",visible)end
 function ESP:HealthColor(ratio)
  local s=self.Settings
  if not s.HealthGradient then return s.HealthHighColor end
  if ratio<=.5 then return s.HealthLowColor:Lerp(s.HealthMidColor,clamp(ratio*2,0,1))end
  return s.HealthMidColor:Lerp(s.HealthHighColor,clamp((ratio-.5)*2,0,1))
 end
 function ESP:IsTeammate(player)
  local own=LocalPlayer:GetAttribute("Team")
  local other=player:GetAttribute("Team")
  if own~=nil and other~=nil then
   return (own=="T" or own=="CT") and own==other
  end
  return LocalPlayer.Team~=nil and player.Team==LocalPlayer.Team
 end
 local function measure(entry)
  local root,character=entry.Root,entry.Character
  if not root or not character then return end
  local low,high=Vector3.new(math.huge,math.huge,math.huge),Vector3.new(-math.huge,-math.huge,-math.huge)
  for _,part in ipairs(character:GetChildren())do
   if part:IsA("BasePart") and BODY[part.Name]then
    local half=part.Size*.5
    local relative=root.CFrame:ToObjectSpace(part.CFrame)
    for _,sign in ipairs(CORNERS)do
     local point=relative:PointToWorldSpace(half*sign)
     low=Vector3.new(math.min(low.X,point.X),math.min(low.Y,point.Y),math.min(low.Z,point.Z))
     high=Vector3.new(math.max(high.X,point.X),math.max(high.Y,point.Y),math.max(high.Z,point.Z))
    end
   end
  end
  if low.X~=math.huge then
   entry.Offset=(low+high)*.5
   local size=high-low
   entry.Half=Vector3.new(clamp(size.X,2,6),clamp(size.Y,3,9),clamp(size.Z,1.5,4))*.5
  end
 end
 local function bindCharacter(entry,character)
  entry.Character=character;entry.Root=nil;entry.Humanoid=nil;entry.SmoothHP=nil;entry.NextResolve=0
  entry.Item=nil;entry.NextItem=0
  hide(entry)
 end
 function ESP:ResolveItem(entry)
  local character=entry.Character
  local name=character and character:GetAttribute("WhatGun")
  local tool
  if character and (type(name)~="string" or name=="")then
   tool=character:FindFirstChildOfClass("Tool")
   name=tool and tool.Name
  end
  if type(name)~="string" or name=="" or name=="None"then return nil end
  local known=self.ItemCatalog[name]
  if known then return known end
  return {Name=name,Image=tool and tool.TextureId or "",WhiteImage=""}
 end
 local function resolve(entry,now)
  if now<entry.NextResolve then return end
  entry.NextResolve=now+.5
  local c=entry.Player.Character
  if c~=entry.Character then bindCharacter(entry,c)end
  if not c then return end
  local root=c:FindFirstChild("HumanoidRootPart")
  local humanoid=c:FindFirstChildOfClass("Humanoid")
  if root~=entry.Root or humanoid~=entry.Humanoid then
   entry.Root=root;entry.Humanoid=humanoid
   if root and humanoid then measure(entry)end
  end
 end
 function ESP:Add(player)
  if player==LocalPlayer or self.Entries[player]then return end
  local e={Player=player,Objects={},GUIObjects={},Connections={},Visible=false,Offset=Vector3.new(0,-.3,0),Half=Vector3.new(2,2.8,1),NextResolve=0,NextText=0,NextItem=0}
  self.Entries[player]=e;self.Stats.Tracked+=1
  e.Outline=make(e,"Square",{Thickness=3,Filled=false,Color=BLACK,Transparency=.94,ZIndex=1})
  e.Box=make(e,"Square",{Thickness=1,Filled=false,Color=self.Settings.Color,Transparency=1,ZIndex=2})
  e.BarBackground=make(e,"Square",{Filled=true,Color=BLACK,Transparency=.95,ZIndex=3})
  e.BarTrack=make(e,"Square",{Filled=true,Color=Color3.fromRGB(33,40,45),Transparency=1,ZIndex=4})
  e.Bar=make(e,"Square",{Filled=true,Color=Color3.fromRGB(113,224,154),Transparency=1,ZIndex=5})
  local font=Drawing.Fonts and Drawing.Fonts.Plex or 2
  e.Name=make(e,"Text",{Text=player.DisplayName,Size=13,Font=font,Center=true,Outline=true,OutlineColor=BLACK,Color=WHITE,Transparency=1,ZIndex=6})
  e.Distance=make(e,"Text",{Text="",Size=12,Font=font,Center=true,Outline=true,OutlineColor=BLACK,Color=MUTED,Transparency=1,ZIndex=6})
  e.HPText=make(e,"Text",{Text="100",Size=12,Font=font,Center=false,Outline=true,OutlineColor=BLACK,Color=WHITE,Transparency=1,ZIndex=6})
  e.ItemText=make(e,"Text",{Text="",Size=12,Font=font,Center=true,Outline=true,OutlineColor=BLACK,Color=MUTED,Transparency=1,ZIndex=6})
  for _,key in ipairs({"IconShadow","Icon"})do
   local image=Instance.new("ImageLabel")
   image.Name=key;image.BackgroundTransparency=1;image.AnchorPoint=Vector2.new(.5,0);image.ScaleType=Enum.ScaleType.Fit
   image.ImageColor3=key=="IconShadow" and BLACK or WHITE
   image.ZIndex=key=="IconShadow" and 1 or 2;image.Visible=false;image.Parent=Overlay
   e[key]={Draw=image,Cache={Visible=false}}
   table.insert(e.GUIObjects,e[key])
  end
  self.Stats.Icons+=1
  bindCharacter(e,player.Character)
  table.insert(e.Connections,player.CharacterAdded:Connect(function(c)bindCharacter(e,c)end))
  table.insert(e.Connections,player.CharacterRemoving:Connect(function(c)if e.Character==c then bindCharacter(e,nil)end end))
  resolve(e,os.clock())
 end
 function ESP:Remove(player)
  local e=self.Entries[player];if not e then return end
  self.Entries[player]=nil;self.Stats.Tracked-=1
  for _,c in ipairs(e.Connections)do c:Disconnect()end
  for _,obj in ipairs(e.Objects)do pcall(function()obj.Draw:Remove()end);self.Stats.Drawings-=1 end
  for _,obj in ipairs(e.GUIObjects)do obj.Draw:Destroy()end
  self.Stats.Icons-=1
  table.clear(e.Objects)
  table.clear(e.GUIObjects)
 end
 function ESP:Render(dt)
  local start=os.clock()
  local camera=workspace.CurrentCamera
  if not camera then for _,e in pairs(self.Entries)do hide(e)end;self.Stats.Visible=0;return end
  local viewport=camera.ViewportSize
  local localCharacter=LocalPlayer.Character
  local localRoot=localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
  local origin=localRoot and localRoot.Position or camera.CFrame.Position
  local now=os.clock();local visible=0
  local settings=self.Settings
  local maxDistanceSquared=settings.MaxDistance*settings.MaxDistance
  for _,e in pairs(self.Entries)do
   resolve(e,now)
   local root,hum=e.Root,e.Humanoid
   if not root or not root.Parent or not hum or hum.Health<=0 or (settings.TeamCheck and self:IsTeammate(e.Player))then hide(e);continue end
   local delta=root.Position-origin
   if delta:Dot(delta)>maxDistanceSquared then hide(e);continue end
   local rootFrame=root.CFrame
   local center=rootFrame:PointToWorldSpace(e.Offset)
   local projected=camera:WorldToViewportPoint(center)
   if projected.Z<.5 then hide(e);continue end
   local radius=e.Half.Magnitude*viewport.Y/(2*math.tan(math.rad(camera.FieldOfView)*.5)*math.max(.1,projected.Z-e.Half.Magnitude))
   if projected.X+radius<0 or projected.X-radius>viewport.X or projected.Y+radius<0 or projected.Y-radius>viewport.Y then hide(e);continue end
   if now>=(e.NextBounds or 0)then e.NextBounds=now+.25;measure(e)end
   -- Project only the body, excluding equipment and accessories.
   local minX,minY,maxX,maxY=math.huge,math.huge,-math.huge,-math.huge
   local near=false
   for _,sign in ipairs(CORNERS)do
    local point=camera:WorldToViewportPoint(rootFrame:PointToWorldSpace(e.Offset+e.Half*sign))
    if point.Z<.1 then near=true;break end
    minX=math.min(minX,point.X);minY=math.min(minY,point.Y)
    maxX=math.max(maxX,point.X);maxY=math.max(maxY,point.Y)
   end
   if near or maxX<0 or minX>viewport.X or maxY<0 or minY>viewport.Y then hide(e);continue end
   local x,y=floor(minX+.5),floor(minY+.5)
   local w,h=floor(maxX+.5)-x,floor(maxY+.5)-y
   if w<2 or h<5 or h>viewport.Y*2 then hide(e);continue end
   e.Visible=true;visible+=1
   local position,size=Vector2.new(x,y),Vector2.new(w,h)
   set(e.Outline,"Position",position);set(e.Outline,"Size",size);show(e.Outline,settings.Box)
   set(e.Box,"Position",position);set(e.Box,"Size",size);show(e.Box,settings.Box)
   set(e.Box,"Color",settings.Color)
   set(e.Outline,"Color",settings.BoxOutlineColor)
   local hp,maxHP=hum.Health,math.max(hum.MaxHealth,1)
   local ratio=clamp(hp/maxHP,0,1)
   e.SmoothHP=(e.SmoothHP or ratio)+(ratio-(e.SmoothHP or ratio))*(1-math.exp(-dt*14))
   if math.abs(e.SmoothHP-ratio)<.001 then e.SmoothHP=ratio end
   local barWidth=settings.HealthWidth
   local barX=x-4-barWidth
   local barHeight=math.max(1,floor(h*e.SmoothHP+.5))
   local barTop=y+h-barHeight
   set(e.BarBackground,"Position",Vector2.new(barX-1,y-1));set(e.BarBackground,"Size",Vector2.new(barWidth+2,h+2))
   set(e.BarTrack,"Position",Vector2.new(barX,y));set(e.BarTrack,"Size",Vector2.new(barWidth,h))
   set(e.Bar,"Position",Vector2.new(barX,barTop));set(e.Bar,"Size",Vector2.new(barWidth,barHeight))
   set(e.BarBackground,"Color",settings.HealthOutlineColor);set(e.BarTrack,"Color",settings.HealthTrackColor)
   if e.LastColorRatio~=e.SmoothHP or e.LastColorRevision~=self.ColorRevision then
    e.LastColorRatio=e.SmoothHP;e.LastColorRevision=self.ColorRevision
    e.HealthColor=self:HealthColor(e.SmoothHP)
    set(e.Bar,"Color",e.HealthColor);set(e.HPText,"Color",e.HealthColor)
   end
   show(e.BarBackground,settings.Health);show(e.BarTrack,settings.Health);show(e.Bar,settings.Health)
   local textSize=settings.TextSize
   local gap=textSize+3
   set(e.Name,"Size",textSize);set(e.Distance,"Size",math.max(10,textSize-1));set(e.HPText,"Size",math.max(10,textSize-1))
   set(e.Name,"Position",Vector2.new(x+w*.5,y-5-textSize))
   set(e.Distance,"Position",Vector2.new(x+w*.5,y+h+4))
   set(e.Name,"Color",settings.NameColor);set(e.Distance,"Color",settings.DistanceColor);set(e.ItemText,"Color",settings.ItemColor)
   set(e.Name,"OutlineColor",settings.TextOutlineColor);set(e.Distance,"OutlineColor",settings.TextOutlineColor)
   set(e.ItemText,"OutlineColor",settings.TextOutlineColor);set(e.HPText,"OutlineColor",settings.TextOutlineColor)
   set(e.Icon,"ImageColor3",settings.OriginalIcons and WHITE or settings.IconColor);set(e.IconShadow,"ImageColor3",settings.IconOutlineColor)
   if now>=e.NextText then
    e.NextText=now+.1
    set(e.Name,"Text",e.Player.DisplayName)
    set(e.Distance,"Text",tostring(floor(delta.Magnitude+.5)).." studs")
    set(e.HPText,"Text",tostring(math.ceil(hp)))
    e.HPTextWidth=e.HPText.Draw.TextBounds.X
   end
   set(e.HPText,"Position",Vector2.new(barX-4-(e.HPTextWidth or 20),clamp(barTop-5,y-5,math.max(y-5,y+h-12))))
   show(e.Name,settings.Names);show(e.Distance,settings.Distance);show(e.HPText,settings.Health and settings.HealthNumber)
   if now>=e.NextItem then
    e.NextItem=now+.15;e.Item=self:ResolveItem(e)
    set(e.ItemText,"Text",e.Item and e.Item.Name or "")
   end
   local iconImage=e.Item and (settings.OriginalIcons and e.Item.Image or e.Item.WhiteImage)or ""
   local shadowImage=e.Item and e.Item.WhiteImage or ""
   set(e.Icon,"Image",iconImage);set(e.IconShadow,"Image",shadowImage)
   local hasItem=e.Item~=nil
   local bottomY=y+h+4+(settings.Distance and gap or 0)
   set(e.ItemText,"Size",math.max(10,textSize-1));set(e.ItemText,"Position",Vector2.new(x+w*.5,bottomY))
   show(e.ItemText,settings.ItemName and hasItem)
   local iconY=bottomY+(settings.ItemName and hasItem and gap or 0)
   local iconWidth=clamp(w*.8,36,64)
   set(e.Icon,"Position",UDim2.fromOffset(x+w*.5,iconY));set(e.Icon,"Size",UDim2.fromOffset(iconWidth,22))
   set(e.IconShadow,"Position",UDim2.fromOffset(x+w*.5,iconY));set(e.IconShadow,"Size",UDim2.fromOffset(iconWidth+2,24))
   local showIcon=settings.ItemIcon and hasItem and iconImage~=""
   show(e.Icon,showIcon);show(e.IconShadow,showIcon and shadowImage~="")
  end
  self.Stats.Visible=visible
  self.Stats.FrameMs=self.Stats.FrameMs*.95+(os.clock()-start)*1000*.05
 end
 function ESP:SetEnabled(value)
  value=value==true and self.Alive
  if self.Enabled==value then return end
  self.Enabled=value
  if self.RenderConnection then self.RenderConnection:Disconnect();self.RenderConnection=nil end
  if value then
   self.RenderConnection=RunService.RenderStepped:Connect(function(dt)
    local ok,err=pcall(self.Render,self,dt)
    if not ok then self.Stats.Errors+=1;self.LastError=tostring(err);self:SetEnabled(false)end
   end)
  else
   for _,e in pairs(self.Entries)do hide(e)end
   self.Stats.Visible=0
  end
 end
 function ESP:Destroy()
  if not self.Alive then return end
  self:SetEnabled(false);self.Alive=false
  for _,c in ipairs(self.Connections)do c:Disconnect()end
  local players={};for p in pairs(self.Entries)do table.insert(players,p)end
  for _,p in ipairs(players)do self:Remove(p)end
  Overlay:Destroy()
 end
 for _,p in ipairs(Players:GetPlayers())do ESP:Add(p)end
 table.insert(ESP.Connections,Players.PlayerAdded:Connect(function(p)ESP:Add(p)end))
 table.insert(ESP.Connections,Players.PlayerRemoving:Connect(function(p)ESP:Remove(p)end))
 local originalUnload=App.Library.Unload
 function App.Library:Unload()ESP:Destroy();return originalUnload(self)end
 local main=App.Tabs.ESP:AddSection({Name="PLAYERS",Position="left"})
 ESP.Rows={}
 for _,key in ipairs({"TextOutlineColor","BoxOutlineColor","HealthMidColor","HealthLowColor","HealthTrackColor","HealthOutlineColor","IconOutlineColor"})do
  App.Library.Flags["player_esp_"..key]={GetValue=function()return ESP.Settings[key]end,SetValue=function(_,value)
   if typeof(value)=="string"then value=Color3.fromHex(value:gsub("#",""))end
   if typeof(value)=="Color3"then ESP.Settings[key]=value;ESP.ColorRevision+=1 end
  end}
 end
 local function row(key,label,colorKey,gear)
  local holder=main:AddLabel(label)
  local control={Row=holder}
  control.Toggle=holder:AddToggle({Default=key=="Enabled" or ESP.Settings[key],Flag=key=="Enabled" and "player_esp_enabled" or "player_esp_"..key,Callback=function(v)
   if key=="Enabled"then ESP:SetEnabled(v)else ESP.Settings[key]=v end
  end})
  control.Toggle.Root.LayoutOrder=10
  if colorKey then
   control.Color=holder:AddColorPicker({Default=ESP.Settings[colorKey],Flag=colorKey=="Color" and "player_esp_color" or "player_esp_"..colorKey,Callback=function(v)ESP.Settings[colorKey]=v;ESP.ColorRevision+=1 end})
   control.Color.Root.LayoutOrder=0
  end
  if gear then control.Options=holder:AddOption();control.Options.Trigger.LayoutOrder=20 end
  ESP.Rows[key]=control
  return control
 end
 local enabled=row("Enabled","Enabled",nil,true)
 ESP.Toggle=enabled.Toggle
 enabled.Options:AddLabel("Text size"):AddSlider({Default=13,Min=11,Max=18,Rounding=0,Flag="player_esp_text",Callback=function(v)ESP.Settings.TextSize=v end})
 enabled.Options:AddLabel("Distance"):AddSlider({Default=1800,Min=100,Max=5000,Rounding=0,Flag="player_esp_range",Callback=function(v)ESP.Settings.MaxDistance=v end})
 row("Box","Box","Color")
 row("Names","Name","NameColor")
 row("Distance","Distance","DistanceColor")
 local health=row("Health","Health bar","HealthHighColor",true)
 health.Options:AddLabel("Thickness"):AddSlider({Default=2,Min=1,Max=5,Rounding=0,Type=" px",Flag="player_esp_hp_width",Callback=function(v)ESP.Settings.HealthWidth=v end})
 health.Options:AddLabel("Gradient"):AddToggle({Default=true,Flag="player_esp_hp_gradient",Callback=function(v)ESP.Settings.HealthGradient=v;ESP.ColorRevision+=1 end})
 health.Options:AddLabel("Health number"):AddToggle({Default=true,Flag="player_esp_HealthNumber",Callback=function(v)ESP.Settings.HealthNumber=v end})
 row("ItemName","Held item","ItemColor")
 local icon=row("ItemIcon","Item icon","IconColor",true)
 icon.Options:AddLabel("Original colors"):AddToggle({Default=false,Flag="player_esp_original_icons",Callback=function(v)ESP.Settings.OriginalIcons=v end})
 row("TeamCheck","Team check")
 ESP:SetEnabled(true)
 return ESP
end
