import fs from 'node:fs';
import path from 'node:path';
import {fileURLToPath} from 'node:url';
const root=path.resolve(path.dirname(fileURLToPath(import.meta.url)),'..');
let library=fs.readFileSync(path.join(root,'library/NeverloseCS2/alpaca.upstream.luau'),'utf8');
library=library.replace('while true do task.wait(5.75);','while NeverLose.Alive do task.wait(5.75);');
library=library.replace('if isfile(path) and ConfigLib.SelectedConfig == "Default" then','if NeverLose.Alive and NeverLose.AutoSave ~= false and isfile(path) and ConfigLib.SelectedConfig == "Default" then');
library=library.replace('task.delay(1,function()\n\t\t\tif ConfigLib.SelectedConfig', 'task.delay(1,function()\n\t\t\tif not NeverLose.Alive then return end;\n\t\t\tif ConfigLib.SelectedConfig');
library=library.replace('Window:_InitConfig();','Window.Config = Window:_InitConfig();');
library=library.replace('local SecureSignal;', 'DropdownLib.Root = Dropdown;\n\t\tlocal SecureSignal;\n\t\tDropdownLib.DisconnectInput=function()if SecureSignal then SecureSignal:Disconnect();SecureSignal=nil end end;');
library=library.replace('local ColorPickerLib = {};\n\t\tlocal ColorPicker = Instance.new("Frame")','local ColorPickerLib = {};\n\t\tlocal ColorPicker = Instance.new("Frame")\n\t\tColorPickerLib.Root = ColorPicker;');
library=library.replace('local Window = NeverLose:CreateOptionWindow(Option , ZINdex + 13);','local Window = NeverLose:CreateOptionWindow(Option , ZINdex + 13);\n\t\tWindow.Trigger = Option;');
library=library.replace('if not NeverLose:IsMouseOverFrame(Window.Root) and not NeverLose:IsMouseOverFrame(Option) then','if not NeverLose:IsMouseOverFrame(Window.Root) and not NeverLose:IsMouseOverFrame(Option) and not (NeverLose.UIRepairs and NeverLose.UIRepairs.ActivePicker) then');
const initializeUI=fs.readFileSync(path.join(root,'modules/UIRepairs.luau'),'utf8').replace(/^return\s+/,'');
const initializeESP=fs.readFileSync(path.join(root,'modules/PlayerESP.luau'),'utf8').replace(/^return\s+/,'');
const initializeRemovals=fs.readFileSync(path.join(root,'modules/VisualRemovals.luau'),'utf8').replace(/^return\s+/,'');
const initializeCrosshair=fs.readFileSync(path.join(root,'modules/GameCrosshair.luau'),'utf8').replace(/^return\s+/,'');
const initializeWorld=fs.readFileSync(path.join(root,'modules/WorldVisuals.luau'),'utf8').replace(/^return\s+/,'');
const initializeMovement=fs.readFileSync(path.join(root,'modules/Movement.luau'),'utf8').replace(/^return\s+/,'');
const initializeRecoil=fs.readFileSync(path.join(root,'modules/RecoilControl.luau'),'utf8').replace(/^return\s+/,'');
const skyPresets=fs.readFileSync(path.join(root,'assets/skyboxes/Presets.luau'),'utf8').replace(/^--[^\n]*\n/,'').replace(/^return\s+/,'');
const whiteIcons=fs.readFileSync(path.join(root,'assets/equipment/WhiteIcons.luau'),'utf8').replace(/^return\s+/,'');
const source=`-- MintProject | Neverlose CS2 UI
-- UI: 4lpaca / https://github.com/0zdac/NLCS2UI (MIT)
local ENV=getgenv()
local previous=ENV.MintProjectNeverloseCS2 or ENV.MintProjectNeverlose or ENV.MintProjectUI
local Library=(function()
 local originalGetHui=gethui
 local gethui=function()
  local host=originalGetHui and originalGetHui() or game:GetService("CoreGui")
  while host:IsA("ScreenGui")do host=host.Parent end
  return host
 end
${library}
end)()
Library.UnloadEnabled=true
Library.Alive=true
Library.AutoSave=true
local initializeUI=${initializeUI}
initializeUI(Library)
if previous and previous.Library then pcall(function()previous.Library:Destroy()end)end
local name="Roblox"
pcall(function()name=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)
local configFolder="MintProject/NeverloseCS2-Example"
if not isfolder(configFolder)then makefolder(configFolder)end
if not isfile(configFolder.."/Default") and isfile("MintProject/NeverloseCS2/Default")then
 pcall(function()writefile(configFolder.."/Default",readfile("MintProject/NeverloseCS2/Default"))end)
end
local Window=Library:CreateWindow({Name="Neverlose",Content=name,Logo=Library.GlobalLogo,Size=Library.Scales.Large,ConfigFolder=configFolder,Enable3DRenderer=false,Keybind="RightShift"})
Window:SetAccount({Username=game:GetService("Players").LocalPlayer.DisplayName,Expires="MintProject"})
local App={Library=Library,Window=Window,Tabs={},Connections={},Build="2026.10.29.9",Game={Name=name,PlaceId=game.PlaceId}}
local unloaded=false
local originalUnload=Library.Unload
function Library:Unload()
 if unloaded then return end
 unloaded=true
 self.Alive=false
 for _,connection in ipairs(App.Connections)do connection:Disconnect()end
 table.clear(App.Connections)
 return originalUnload(self)
end
function Library:Destroy()return self:Unload()end
Window:AddTabLabel("GENERAL")
App.Tabs.Main=Window:AddTab({Name="Main",Icon="house"})
Window:AddTabLabel("COMBAT")
App.Tabs.Combat=Window:AddTab({Name="Combat",Icon="crosshairs"})
Window:AddTabLabel("VISUALS")
App.Tabs.ESP=Window:AddTab({Name="ESP",Icon="frame-person-torso"})
App.Tabs.Visuals=Window:AddTab({Name="Visuals",Icon="eye"})
Window:AddTabLabel("MISCELLANEOUS")
App.Tabs.Movement=Window:AddTab({Name="Movement",Icon="person-running"})
App.Tabs.Farm=Window:AddTab({Name="Farm",Icon="backpack"})
App.Tabs.Misc=Window:AddTab({Name="Misc",Icon="grid"})
App.Tabs.Settings=Window:AddTab({Name="Settings",Icon="gear"})
App.Tabs.Example=Window:AddTab({Name="Example",Icon="code"})
local main=App.Tabs.Main:AddSection({Name="MENU",Position="left"})
main:AddButton({Name="Hide menu",Callback=function()Window:ToggleInterface()end})
local settings=App.Tabs.Settings:AddSection({Name="INTERFACE",Position="left"})
settings:AddLabel("Menu size"):AddDropdown({Default="Large",Values={"Default","Large","Small"},Flag="nlcs2_size",Callback=function(value)Window:SetSize(Library.Scales[value] or Library.Scales.Large)end})
settings:AddLabel("Toggle key"):AddKeybind({Default="RightShift",Flag="nlcs2_key",Callback=function(value)Window.Keybind=value end})
settings:AddButton({Name="Unload menu",Callback=function()Library:Destroy()end})
local Notification=Library:CreateNotification()
App.Notification=Notification
local function notify(title,text)
 Notification.new({Title=title,Content=text,Duration=3})
end
local Watermark=Window:Watermark()
App.Watermark=Watermark
App.WatermarkBlocks={
 Brand=Watermark:AddBlock("shield-check","neverlose"),
 User=Watermark:AddBlock("person",game:GetService("Players").LocalPlayer.DisplayName),
 FPS=Watermark:AddBlock("chart-four-vertical-bars","0 FPS"),
 Ping=Watermark:AddBlock("globe-detailed","0MS"),
 Clock=Watermark:AddBlock("clock",os.date("%H:%M:%S")),
}
local watermarkSettings=App.Tabs.Settings:AddSection({Name="WATERMARK",Position="right"})
watermarkSettings:AddLabel("Watermark"):AddToggle({Default=true,Flag="nlcs2_watermark",Callback=function(value)Watermark:SetRender(value)end})
for _,entry in ipairs({{"User","Username"},{"FPS","FPS"},{"Ping","Ping"},{"Clock","Clock"}})do
 local block=App.WatermarkBlocks[entry[1]]
 watermarkSettings:AddLabel(entry[2]):AddToggle({Default=true,Flag="nlcs2_watermark_"..entry[1],Callback=function(value)block:SetVisible(value)end})
end
local demo=App.Tabs.Example:AddSection({Name="MAIN",Position="left"})
demo:AddLabel("Enabled"):AddToggle({Default=false,Flag="RagebotEnabled",Callback=function(value)notify("Example",value and "Enabled" or "Disabled")end})
demo:AddLabel("Hit Chance"):AddSlider({Default=75,Min=0,Max=100,Type="%%",Rounding=0,Nums={[0]="Off",[100]="Max"},Flag="HitChance"})
demo:AddLabel("Target"):AddDropdown({Default="Head",Values={"Head","Torso","Limbs","Auto"},Multi=false,Flag="TargetHitbox"})
demo:AddLabel("Panic Key"):AddKeybind({Default="P",Flag="PanicKey"})
demo:AddLabel("ESP Color"):AddColorPicker({Default=Color3.fromRGB(78,127,252),Flag="ESPColor"})
demo:AddLabel("Webhook URL"):AddTextInput({Default="",Placeholder="URL",Flag="WebhookURL",Size=150})
local advanced=demo:AddLabel("Advanced")
advanced:AddToggle({Default=false,Flag="AdvancedMode"})
local advancedOptions=advanced:AddOption()
advancedOptions:AddLabel("Force Shoot"):AddToggle({Default=false,Flag="ForceShoot"})
advancedOptions:AddLabel("Silent Aim"):AddToggle({Default=true,Flag="SilentAim"})
local controls=App.Tabs.Example:AddSection({Name="OTHER",Position="right"})
controls:AddLabel("Multiple selection"):AddDropdown({Default={Head=true},Values={"Head","Torso","Limbs"},Multi=true,Flag="ExampleMulti"})
controls:AddButton({Name="Test notification",Callback=function()notify("Neverlose","Notification example")end})
Window.UserSettings:AddLabel("Auto Save"):AddToggle({Default=true,Flag="nlcs2_autosave",Callback=function(value)Library.AutoSave=value end})
table.insert(App.Connections,game:GetService("UserInputService").InputBegan:Connect(function(input,processed)
 if processed or not Library.Alive then return end
 local panic=Library.Flags.PanicKey
 if panic and input.KeyCode.Name==panic:GetValue()then Library:Destroy()end
end))
local frameCount,frameTime=0,0
local fps=0
table.insert(App.Connections,game:GetService("RunService").RenderStepped:Connect(function(dt)
 frameCount+=1;frameTime+=dt
 if frameTime>=.5 then fps=math.round(frameCount/frameTime);frameCount=0;frameTime=0 end
end))
task.spawn(function()
 while Library.Alive do
  local identity=getthreadidentity and getthreadidentity()
  if setthreadidentity then setthreadidentity(8)end
  local ok,err=pcall(function()
   App.WatermarkBlocks.FPS:SetText(tostring(fps).." FPS")
   App.WatermarkBlocks.Ping:SetText(tostring(math.round(game:GetService("Players").LocalPlayer:GetNetworkPing()*1000)).."MS")
   App.WatermarkBlocks.Clock:SetText(os.date("%H:%M:%S"))
  end)
  if identity and setthreadidentity then setthreadidentity(identity)end
  if not ok then App.WatermarkError=tostring(err);break end
  task.wait(1)
 end
end)
local initializeESP=${initializeESP}
initializeESP(App,${whiteIcons})
local initializeRemovals=${initializeRemovals}
initializeRemovals(App)
local initializeCrosshair=${initializeCrosshair}
initializeCrosshair(App)
local initializeWorld=${initializeWorld}
initializeWorld(App,${skyPresets})
local initializeMovement=${initializeMovement}
initializeMovement(App)
local initializeRecoil=${initializeRecoil}
initializeRecoil(App)
ENV.MintProjectNeverloseCS2=App
ENV.MintProjectUI=App
Window.Signal:SetValue(true)
return App
`;
const output=path.join(root,'MintProject Neverlose CS2.lua');
fs.writeFileSync(output,source);
fs.mkdirSync(path.join(root,'dist'),{recursive:true});
fs.writeFileSync(path.join(root,'dist/main.luau'),source);
console.log(JSON.stringify({output,bytes:Buffer.byteLength(source)}));
