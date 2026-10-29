return function(App)
 local RunService=game:GetService("RunService")
 local R={Alive=true,Enabled=false,Records={},Stats={Springs=0,Errors=0}}
 App.Recoil=R
 local Variables
 if game.GameId==6993600665 then pcall(function()Variables=require(game.ReplicatedFirst.Variables)end)end
 local vectorKeys={value=true,position=true,p=true,velocity=true,v=true,acceleration=true,a=true,target=true,t=true}
 local zero=Vector3.zero
 function R:Drop(spring)
  local record=self.Records[spring]
  if not record then return end
  if getmetatable(spring)==record.Wrapper then
   -- Clear suppressed impulses so disabling does not replay a previous shot.
   record.Original.__newindex(spring,"t",zero)
   record.Original.__newindex(spring,"p",zero)
   record.Original.__newindex(spring,"v",zero)
   setmetatable(spring,record.Original)
  end
  self.Records[spring]=nil;self.Stats.Springs-=1
 end
 function R:Attach(spring)
  if type(spring)~="table"or self.Records[spring]then return end
  local original=getmetatable(spring)
  if type(original)~="table"or type(original.__index)~="function"or type(original.__newindex)~="function"then return end
  local wrapper=table.clone(original)
  wrapper.__index=function(object,key)
   if self.Alive and self.Enabled then
    if vectorKeys[key]then return zero end
    if key=="magnitude"or key=="m"then return 0 end
   end
   return original.__index(object,key)
  end
  wrapper.__newindex=function(object,key,value)
   if self.Alive and self.Enabled and vectorKeys[key]then value=zero end
   return original.__newindex(object,key,value)
  end
  original.__newindex(spring,"t",zero);original.__newindex(spring,"p",zero);original.__newindex(spring,"v",zero)
  setmetatable(spring,wrapper)
  self.Records[spring]={Original=original,Wrapper=wrapper};self.Stats.Springs+=1
 end
 function R:Resolve()
  if not Variables then return end
  local spring=Variables.camRecoilSpring
  local remove={};for old in pairs(self.Records)do if old~=spring then table.insert(remove,old)end end
  for _,old in ipairs(remove)do self:Drop(old)end
  if spring then self:Attach(spring)end
 end
 function R:SetEnabled(value)
  self.Enabled=value==true and self.Alive
  if self.Enabled then
   local ok,err=pcall(self.Resolve,self)
   if not ok then self.Stats.Errors+=1;self.LastError=tostring(err)end
   if not self.Driver then
    local elapsed=0
    self.Driver=RunService.Heartbeat:Connect(function(dt)
     elapsed+=dt;if elapsed<.25 then return end;elapsed=0
     local success,why=pcall(self.Resolve,self)
     if not success then self.Stats.Errors+=1;self.LastError=tostring(why);self:SetEnabled(false)end
    end)
   end
  else
   if self.Driver then self.Driver:Disconnect();self.Driver=nil end
   local remove={};for spring in pairs(self.Records)do table.insert(remove,spring)end
   for _,spring in ipairs(remove)do self:Drop(spring)end
  end
 end
 function R:Destroy()
  if not self.Alive then return end
  self:SetEnabled(false);self.Alive=false
 end
 local section=App.Tabs.Combat:AddSection({Name="WEAPON",Position="left"})
 section:AddLabel("No recoil"):AddToggle({Default=false,Flag="weapon_no_recoil",Callback=function(v)R:SetEnabled(v)end})
 local unload=App.Library.Unload
 function App.Library:Unload()R:Destroy();return unload(self)end
 return R
end
