return function(App,Presets)
 local Lighting=game:GetService("Lighting")
 local ContentProvider=game:GetService("ContentProvider")
 local W={Alive=true,Records={},Connections={},Cache={},Loading={},Revision=0,Stats={Errors=0,SkyStatus="Off"},Presets=Presets,Settings={Light=false,LightColor=Lighting.ColorShift_Top,Brightness=Lighting.Brightness,Exposure=Lighting.ExposureCompensation,Time=Lighting.ClockTime,Shadows=false,ShadowColor=Lighting.Ambient,GlobalShadows=Lighting.GlobalShadows,Softness=Lighting.ShadowSoftness,Fog=false,FogColor=Lighting.FogColor,FogStart=Lighting.FogStart,FogEnd=Lighting.FogEnd,Density=0,Haze=0,Correction=false,Tint=Color3.new(1,1,1),Contrast=0,Saturation=0,Sky=false,Preset="Aurora",Rotation=0,Stars=3000,Celestial=false}}
 App.World=W
 local Faces={"Bk","Dn","Ft","Lf","Rt","Up"}
 local Source="https://raw.githubusercontent.com/purplesstrat/skyboxes/2198292ca0f7f5a8d224eb14e78d82addc8f390b/"
 local function set(instance,property,value)if instance[property]~=value then instance[property]=value end end
 function W:Drop(instance,property)
  local r=self.Records[instance]
  if not r or r.Original[property]==nil then return end
  r.Connections[property]:Disconnect()
  pcall(function()instance[property]=r.Original[property]end)
  r.Original[property]=nil;r.Wanted[property]=nil;r.Connections[property]=nil
  if not next(r.Original)then self.Records[instance]=nil end
 end
 function W:Override(instance,property,value)
  local r=self.Records[instance]
  if not r then r={Original={},Wanted={},Connections={}};self.Records[instance]=r end
  r.Wanted[property]=value
  if r.Original[property]==nil then
   r.Original[property]=instance[property]
   r.Connections[property]=instance:GetPropertyChangedSignal(property):Connect(function()
    if not self.Alive or r.Applying or r.Wanted[property]==nil then return end
    local ok,err=pcall(function()
     if instance[property]~=r.Wanted[property]then
      r.Original[property]=instance[property]
      r.Applying=true;set(instance,property,r.Wanted[property]);r.Applying=false
     end
    end)
    if not ok then r.Applying=false;self.Stats.Errors+=1;self.LastError=tostring(err)end
   end)
  end
  r.Applying=true;set(instance,property,value);r.Applying=false
 end
 function W:Refresh()
  if not self.Alive or self.Refreshing then return end
  self.Refreshing=true
  local ok,err=pcall(function()
   local s=self.Settings
   local wanted={}
   local function want(instance,property,value)
    wanted[instance]=wanted[instance]or {};wanted[instance][property]=value
   end
   if s.Light then
    want(Lighting,"Brightness",s.Brightness);want(Lighting,"ExposureCompensation",s.Exposure)
    want(Lighting,"ClockTime",s.Time);want(Lighting,"ColorShift_Top",s.LightColor)
   end
   if s.Shadows then
    want(Lighting,"Ambient",s.ShadowColor);want(Lighting,"OutdoorAmbient",s.ShadowColor)
    want(Lighting,"GlobalShadows",s.GlobalShadows);want(Lighting,"ShadowSoftness",s.Softness)
   end
   if s.Fog then
    want(Lighting,"FogColor",s.FogColor)
    want(Lighting,"FogStart",s.FogStart);want(Lighting,"FogEnd",math.max(s.FogStart+1,s.FogEnd))
   end
   local skies=0
   for _,child in ipairs(Lighting:GetChildren())do
    if child:IsA("Atmosphere")and s.Fog then
     want(child,"Density",s.Density);want(child,"Haze",s.Haze);want(child,"Color",s.FogColor)
    elseif child:IsA("Sky")and s.Sky and self.ActiveFaces then
     skies+=1
     for i,face in ipairs(Faces)do want(child,"Skybox"..face,self.ActiveFaces[i])end
     want(child,"CelestialBodiesShown",s.Celestial);want(child,"StarCount",s.Stars)
     want(child,"SkyboxOrientation",Vector3.new(0,s.Rotation,0))
    end
   end
   if s.Sky and self.ActiveFaces and skies==0 then
    local sky=Instance.new("Sky");sky.Name="MintProjectSky";self.OwnSky=sky;sky.Parent=Lighting
    for i,face in ipairs(Faces)do want(sky,"Skybox"..face,self.ActiveFaces[i])end
    want(sky,"CelestialBodiesShown",s.Celestial);want(sky,"StarCount",s.Stars)
    want(sky,"SkyboxOrientation",Vector3.new(0,s.Rotation,0))
   end
   if s.Correction and not self.Effect then
    self.Effect=Instance.new("ColorCorrectionEffect");self.Effect.Name="MintProjectWorldColor";self.Effect.Parent=Lighting
   end
   if self.Effect then
    self.Effect.Enabled=s.Correction;self.Effect.TintColor=s.Tint;self.Effect.Contrast=s.Contrast;self.Effect.Saturation=s.Saturation
   end
   local remove={}
   for instance,r in pairs(self.Records)do for property in pairs(r.Original)do
    if not wanted[instance]or wanted[instance][property]==nil then table.insert(remove,{instance,property})end
   end end
   for _,v in ipairs(remove)do self:Drop(v[1],v[2])end
   for instance,props in pairs(wanted)do for property,value in pairs(props)do self:Override(instance,property,value)end end
   if not s.Sky and self.OwnSky then self.OwnSky:Destroy();self.OwnSky=nil end
  end)
  self.Refreshing=false
  if not ok then self.Stats.Errors+=1;self.LastError=tostring(err)end
 end
 function W:LoadPreset(name)
  self.Revision+=1
  local revision=self.Revision
  if not self.Settings.Sky then self.Stats.SkyStatus="Off";self.ActiveFaces=nil;self:Refresh();return end
  local preset
  for _,v in ipairs(Presets)do if v.Name==name then preset=v;break end end
  if not preset then self.Stats.SkyStatus="Invalid preset";return end
  if self.Cache[name]then self.ActiveFaces=self.Cache[name];self.Stats.SkyStatus="Ready";self:Refresh();return end
  self.Stats.SkyStatus="Loading"
  task.spawn(function()
   -- Share in-flight downloads, and commit all six faces together only for the latest selection.
   while self.Loading[name]and self.Alive and revision==self.Revision do task.wait(.1)end
   if not self.Alive or revision~=self.Revision then return end
   local faces=self.Cache[name]
   local ok,err=true,nil
   if not faces then
    self.Loading[name]=true
    ok,err=pcall(function()
     faces={}
     if preset.Faces then for i,v in ipairs(preset.Faces)do faces[i]=v end
     else
      assert(getcustomasset,"Local skybox textures are unavailable")
      for _,dir in ipairs({"MintProject","MintProject/Skyboxes","MintProject/Skyboxes/v1"})do if not isfolder(dir)then makefolder(dir)end end
      local folder="MintProject/Skyboxes/v1/"..preset.Folder:gsub("[^%w%-]","_")
      if not isfolder(folder)then makefolder(folder)end
      for i,face in ipairs(Faces)do
       local path=folder.."/"..face..".png"
       local valid=isfile(path)and readfile(path):sub(1,8)=="\137PNG\13\10\26\10"
       if not valid then
        local bytes=game:HttpGet(Source..preset.Folder:gsub(" ","%%20").."/sky512_"..face:lower()..".tex")
        assert(bytes:sub(1,8)=="\137PNG\13\10\26\10","Invalid sky texture: "..face)
        writefile(path,bytes)
       end
       faces[i]=getcustomasset(path)
      end
     end
     local failed=false
     ContentProvider:PreloadAsync(faces,function(_,status)if status~=Enum.AssetFetchStatus.Success then failed=true end end)
     assert(not failed,"Sky texture could not be loaded")
     self.Cache[name]=faces
    end)
    self.Loading[name]=nil
   end
   if not self.Alive or revision~=self.Revision then return end
   if ok then self.ActiveFaces=faces;self.Stats.SkyStatus="Ready";self:Refresh()
   else
    self.Stats.Errors+=1;self.Stats.SkyStatus="Failed";self.LastError=tostring(err)
    App.Notification.new({Title="Skybox",Content="Could not load "..name..". Choose another preset or try again.",Duration=4})
   end
  end)
 end
 function W:Set(key,value)
  self.Settings[key]=value
  if key=="Sky"or key=="Preset"then self:LoadPreset(self.Settings.Preset)else self:Refresh()end
 end
 function W:Destroy()
  if not self.Alive then return end
  self.Alive=false;self.Revision+=1
  for _,c in ipairs(self.Connections)do c:Disconnect()end
  local remove={};for instance,r in pairs(self.Records)do for property in pairs(r.Original)do table.insert(remove,{instance,property})end end
  for _,v in ipairs(remove)do self:Drop(v[1],v[2])end
  if self.Effect then self.Effect:Destroy()end
  if self.OwnSky then self.OwnSky:Destroy()end
  table.clear(self.Connections)
 end
 local atmosphere=Lighting:FindFirstChildOfClass("Atmosphere")
 if atmosphere then W.Settings.Density=atmosphere.Density;W.Settings.Haze=atmosphere.Haze end
 local pending=false
 local function schedule(child)
  if not child:IsA("Sky")and not child:IsA("Atmosphere")then return end
  if pending or not W.Alive then return end
  pending=true;task.defer(function()pending=false;W:Refresh()end)
 end
 table.insert(W.Connections,Lighting.ChildAdded:Connect(schedule))
 table.insert(W.Connections,Lighting.ChildRemoved:Connect(function(child)
  if child==W.OwnSky then W.OwnSky=nil end
  schedule(child)
 end))
 local section=App.Tabs.Visuals:AddSection({Name="WORLD",Position="right"})
 W.Options={};W.Rows={}
 local function row(name,key,colorKey)
  local r=section:AddLabel(name)
  local toggle=r:AddToggle({Default=false,Flag="world_"..key,Callback=function(v)W:Set(key,v)end});toggle.Root.LayoutOrder=10
  if colorKey then local picker=r:AddColorPicker({Default=W.Settings[colorKey],Flag="world_"..colorKey,Callback=function(v)W:Set(colorKey,v)end});picker.Root.LayoutOrder=0 end
  local options=r:AddOption();options.Trigger.LayoutOrder=20;W.Options[key]=options;W.Rows[key]=r
  return options
 end
 local function slider(options,name,key,min,max,rounding)
  options:AddLabel(name):AddSlider({Default=W.Settings[key],Min=min,Max=max,Rounding=rounding or 0,Flag="world_"..key,Callback=function(v)W:Set(key,v)end})
 end
 local light=row("World lighting","Light","LightColor")
 slider(light,"Brightness","Brightness",0,10,2);slider(light,"Exposure","Exposure",-3,3,2);slider(light,"Time of day","Time",0,24,2)
 local shadows=row("Shadow color","Shadows","ShadowColor")
 shadows:AddLabel("Cast shadows"):AddToggle({Default=W.Settings.GlobalShadows,Flag="world_GlobalShadows",Callback=function(v)W:Set("GlobalShadows",v)end})
 slider(shadows,"Softness","Softness",0,1,2)
 local sky=row("Custom skybox","Sky")
 local names={};for _,v in ipairs(Presets)do table.insert(names,v.Name)end
 sky:AddLabel("Preset"):AddDropdown({Default=W.Settings.Preset,Values=names,Size=170,Flag="world_Preset",Callback=function(v)W:Set("Preset",v)end})
 slider(sky,"Rotation","Rotation",0,360);slider(sky,"Stars","Stars",0,10000)
 sky:AddLabel("Sun and moon"):AddToggle({Default=false,Flag="world_Celestial",Callback=function(v)W:Set("Celestial",v)end})
 sky:AddButton({Name="Reload skybox",Callback=function()W.Cache[W.Settings.Preset]=nil;W:LoadPreset(W.Settings.Preset)end})
 local fog=row("Custom fog","Fog","FogColor")
 slider(fog,"Start distance","FogStart",0,10000);slider(fog,"End distance","FogEnd",1,10000)
 slider(fog,"Density","Density",0,1,2);slider(fog,"Haze","Haze",0,10,2)
 local correction=row("World tint","Correction","Tint")
 slider(correction,"Contrast","Contrast",-1,1,2);slider(correction,"Saturation","Saturation",-1,1,2)
 local unload=App.Library.Unload
 function App.Library:Unload()W:Destroy();return unload(self)end
 return W
end
