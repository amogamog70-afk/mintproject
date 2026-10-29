return function(App)
 local Players=game:GetService("Players")
 local Lighting=game:GetService("Lighting")
 local PlayerGui=Players.LocalPlayer:WaitForChild("PlayerGui")
 local F={Alive=true,Targets={},Connections={},MarkerNames={},Settings={Smoke=false,Flash=false,Fire=false,Explosions=false,Muzzle=false,Damage=false,Scope=false,EnemyMarkers=false,Pings=false},Stats={Targets=0,Changed=0,Errors=0}}
 App.Removals=F
 local function has(text,fragment)return string.find(text,fragment,1,true)~=nil end
 local function pathOf(instance)
  local names={};local p=instance
  for _=1,14 do
   if not p or p==game then break end
   table.insert(names,string.lower(p.Name));p=p.Parent
  end
  return table.concat(names,"/")
 end
 function F:Classify(instance)
  local visual=instance:IsA("BasePart")or instance:IsA("ParticleEmitter")or instance:IsA("Beam")or instance:IsA("Trail")or instance:IsA("Smoke")or instance:IsA("Fire")or instance:IsA("Light")or instance:IsA("PostEffect")or instance:IsA("Decal")or instance:IsA("Explosion")
  local gui=instance:IsA("GuiObject")or instance:IsA("ScreenGui")or instance:IsA("BillboardGui")
  local sound=instance:IsA("Sound")
  if not visual and not gui and not sound then return nil end
  local path=pathOf(instance)
  if gui then
   if has(path,"/menu/")or has(path,"mintproject")then return nil end
   if has(path,"hurtoverlay")then return "Damage"end
   if has(path,"scopecrosshair")then
    local parent=instance.Parent
    if parent and parent.Name=="ScopeCrosshair"and instance:IsA("ImageLabel")then return "Scope"end
    if has(path,"/scope/imagelabel/scopecrosshair/")or (parent and parent.Name=="ImageLabel"and parent.Parent and parent.Parent.Name=="ScopeCrosshair"and (instance.Name=="D"or instance.Name=="U"or instance.Name=="L"or instance.Name=="R"or instance.Name=="Scope"))then return "Scope"end
    return nil
   end
   if has(path,"enemy_")and has(path,"/holder/holder/independent/")then return "EnemyMarkers"end
   if has(path,"/ping/independent/")or has(path,"ping/independent/")then return "Pings"end
   if has(path,"fullflash/capture/")or has(path,"halfflash/capture/")or has(path,"flashbang")or has(path,"flashed")or has(path,"blinded")or has(path,"blindness")or has(path,"flashoverlay")or has(path,"flashscreen")or has(path,"whitescreen")or (string.lower(instance.Name)=="flash" and has(path,"/hud/"))then return "Flash"end
   return nil
  end
  if sound then
   if has(path,"ringing")or has(path,"flashbangring")then return "Flash"end
   return nil
  end
  if has(path,"/gun/flash")or has(path,"/flash/gun/")or ((has(path,"/flash/")or has(path,"/uflash/"))and (has(path,"/gun/")or has(path,"/camera/")or has(path,"/players/")))then return "Muzzle"end
  if instance:IsA("BasePart")and (has(path,"/destroyable/")or has(path,"/players/"))then return nil end
  if has(path,"smokeup")or has(path,"/smoke/")or string.lower(instance.Name)=="smoke"or instance:HasTag("Smoke")then return "Smoke"end
  if has(path,"molly")or has(path,"molotov")or has(path,"inferno")or has(path,"incendiary")or has(path,"thermite")or has(path,"/fire/")or string.lower(instance.Name)=="fire"or instance:HasTag("MollyFX")then return "Fire"end
  if has(path,"flashbang")or has(path,"flashed")or has(path,"blinded")or has(path,"blindness")or has(path,"flashblur")or (instance:IsA("PostEffect")and string.lower(instance.Name)=="flash")then return "Flash"end
  if instance:IsA("Explosion")or has(path,"explosion")or has(path,"grenadeexplode")then return "Explosions"end
  return nil
 end
 local function properties(instance,category)
  if category=="Scope"and instance:IsA("ImageLabel")and instance.Parent and instance.Parent.Name=="ScopeCrosshair"then return {ImageTransparency=1}end
  if instance:IsA("BasePart")then return {LocalTransparencyModifier=1}end
  if instance:IsA("ParticleEmitter")or instance:IsA("Beam")or instance:IsA("Trail")then return {Enabled=false,Transparency=NumberSequence.new(1)}end
  if instance:IsA("Light")or instance:IsA("PostEffect")or instance:IsA("Smoke")or instance:IsA("Fire")or instance:IsA("ScreenGui")or instance:IsA("BillboardGui")then return {Enabled=false}end
  if instance:IsA("GuiObject")then return {Visible=false}end
  if instance:IsA("Decal")then return {Transparency=1}end
  if instance:IsA("Explosion")then return {Visible=false}end
  if instance:IsA("Sound")then return {Volume=0}end
  return {}
 end
 local function sameValue(a,b)
  if typeof(b)~="NumberSequence"then return a==b end
  if typeof(a)~="NumberSequence"then return false end
  local left,right=a.Keypoints,b.Keypoints
  if #left~=#right then return false end
  for i,key in ipairs(left)do
   local other=right[i]
   if key.Time~=other.Time or key.Value~=other.Value or key.Envelope~=other.Envelope then return false end
  end
  return true
 end
 function F:Restore(record)
  for _,connection in ipairs(record.Connections)do connection:Disconnect()end
  table.clear(record.Connections)
  for property,value in pairs(record.Original)do pcall(function()record.Instance[property]=value end)end
  table.clear(record.Original);record.Active=false
 end
 function F:Apply(record)
  if record.Active then return end
  record.Active=true
  for property,value in pairs(properties(record.Instance,record.Category))do
   local ok,original=pcall(function()return record.Instance[property]end)
   if ok then
    record.Original[property]=original
    local function enforce()
     if not self.Alive or not record.Active or not self.Settings[record.Category]then return end
     local success,err=pcall(function()
      local current=record.Instance[property]
      if not sameValue(current,value)then
       record.Original[property]=current
       record.Instance[property]=value
      end
     end)
     if not success then self.LastError=tostring(err);self.Stats.Errors+=1 end
    end
    table.insert(record.Connections,record.Instance:GetPropertyChangedSignal(property):Connect(enforce))
    enforce()
   end
  end
  if record.Instance:IsA("ParticleEmitter")then pcall(function()record.Instance:Clear()end)end
  self.Stats.Changed+=1
 end
 function F:Consider(instance)
  if not self.Alive or self.Targets[instance]then return end
  local parent=instance.Parent
  if not self.MarkerNames[instance]and instance:IsA("GuiObject")and parent and parent.Name=="Holder"and parent.Parent and parent.Parent.Name=="Holder"and parent.Parent.Parent and parent.Parent.Parent.Name=="Independent"then
   self.MarkerNames[instance]=instance:GetPropertyChangedSignal("Name"):Connect(function()
    self:Forget(instance);self:Consider(instance)
    for _,child in ipairs(instance:GetDescendants())do self:Forget(child);self:Consider(child)end
   end)
  end
  local category=self:Classify(instance)
  if not category then return end
  local record={Instance=instance,Category=category,Original={},Connections={},Active=false}
  self.Targets[instance]=record;self.Stats.Targets+=1
  if self.Settings[category]then self:Apply(record)end
 end
 function F:Forget(instance)
  if self.MarkerNames[instance]then self.MarkerNames[instance]:Disconnect();self.MarkerNames[instance]=nil end
  local record=self.Targets[instance]
  if not record then return end
  if record.Active then self:Restore(record)end
  self.Targets[instance]=nil;self.Stats.Targets-=1
 end
 function F:Set(category,value)
  if not self.Alive then return end
  self.Settings[category]=value==true
  for _,record in pairs(self.Targets)do
   if record.Category==category then
    if value then self:Apply(record)elseif record.Active then self:Restore(record)end
   end
  end
  if category=="Scope"and App.Crosshair then App.Crosshair:Refresh()end
 end
 function F:Watch(root)
  for _,instance in ipairs(root:GetDescendants())do self:Consider(instance)end
  table.insert(self.Connections,root.DescendantAdded:Connect(function(instance)self:Consider(instance)end))
  table.insert(self.Connections,root.DescendantRemoving:Connect(function(instance)self:Forget(instance)end))
 end
 function F:Destroy()
  if not self.Alive then return end
  self.Alive=false
  for _,connection in ipairs(self.Connections)do connection:Disconnect()end
  for _,connection in pairs(self.MarkerNames)do connection:Disconnect()end
  for _,record in pairs(self.Targets)do if record.Active then self:Restore(record)end end
  table.clear(self.Targets);table.clear(self.Connections);table.clear(self.MarkerNames);self.Stats.Targets=0
 end
 if game.GameId==6993600665 then
  F:Watch(workspace);F:Watch(Lighting);F:Watch(PlayerGui)
  local PlayerScripts=Players.LocalPlayer:FindFirstChild("PlayerScripts")
  if PlayerScripts then F:Watch(PlayerScripts)end
  local Collection=game:GetService("CollectionService")
  for _,tag in ipairs({"Smoke","MollyFX"})do
   local function considerTree(instance)
    F:Consider(instance)
    for _,child in ipairs(instance:GetDescendants())do F:Consider(child)end
   end
   table.insert(F.Connections,Collection:GetInstanceAddedSignal(tag):Connect(considerTree))
   for _,instance in ipairs(Collection:GetTagged(tag))do considerTree(instance)end
  end
 end
 local section=App.Tabs.Visuals:AddSection({Name="REMOVALS",Position="left"})
 for _,entry in ipairs({{"Smoke","No smoke"},{"Flash","No flash"},{"Fire","No fire effects"},{"Explosions","No explosion effects"},{"Muzzle","No muzzle flash"},{"Damage","No damage overlay"},{"Scope","No scope overlay"},{"EnemyMarkers","No enemy markers"},{"Pings","No ping markers"}})do
  local category=entry[1]
  section:AddLabel(entry[2]):AddToggle({Default=false,Flag="removals_"..category,Callback=function(value)F:Set(category,value)end})
 end
 local unload=App.Library.Unload
 function App.Library:Unload()F:Destroy();return unload(self)end
 return F
end
