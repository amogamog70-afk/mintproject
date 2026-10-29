-- MintProject | Neverlose CS2 UI
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
--[[
                          Neverlose.cc UI Library
    Author: 4lpaca
	License: MIT
    Discord: https://arceney.win/discord
    Other-Projects: https://4lpaca.win
]]

do
	local Constant = 'L'..'P'..'H'..'_NO_VIRTUALIZE';
	getfenv()[Constant] = getfenv()[Constant] or function(f) return f end;
end;

cloneref = cloneref or function(i) return i end;
gethui = gethui or get_hidden_gui;
getcustomasset = getcustomasset or getsynasset;
getgenv = getgenv or getfenv;

local LOAD_ENV = LPH_NO_VIRTUALIZE(function()
	if game:GetService('RunService'):IsStudio() then
		local BaseWorkspace = game:GetService("ReplicatedFirst"):FindFirstChild('PRI_WORKSPACE') or Instance.new('Folder',game:GetService("ReplicatedFirst"));

		BaseWorkspace.Name = 'PRI\0.'..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)))..tostring(string.char(math.random(50,120)));

		local __get_path_c = function(path)
			return (string.find(path,'/',1,true) and string.split(path,'/')) or (string.find(path,'\\',1,true) and string.split(path,'\\')) or {path};
		end;

		local __get_path = function(path)
			local main = __get_path_c(path);

			local block = BaseWorkspace;

			for i,v in next , main do
				block = block[v];
			end;

			return block;
		end;

		getgenv().readfile = function(path)
			local path : StringValue = __get_path(path);

			return path.Value;
		end;

		getgenv().isfile = function(path)
			local success , message = pcall(function()
				return __get_path(path);
			end);

			if success and not message:IsA("Folder") then
				return true;
			end;

			return false;
		end;

		getgenv().isfolder = function(path)
			local success , message = pcall(function()
				return __get_path(path);
			end);

			if success and message:IsA("Folder") then
				return true;
			end;

			return false;
		end;

		getgenv().writefile = function(path,content)
			local main = __get_path_c(path);

			local block = BaseWorkspace;

			for i,v in next , main do
				local item = block:FindFirstChild(v);
				if not item then
					local c = Instance.new('StringValue',block);

					c.Name = tostring(v);
					c.Value = content;
				else
					if item:IsA('StringValue') and tostring(item) == v then
						item.Name = tostring(v);
						item.Value = content;
					end;

					block = item;
				end;
			end;
		end;

		getgenv().listfiles = function(path)
			local fold = __get_path(path);
			local pa = {};

			for i,v in next , fold:GetChildren() do
				if v:IsA('StringValue') then
					table.insert(pa,path..'/'..tostring(v));
				end;
			end;

			return pa;
		end;

		getgenv().makefolder = function(path)
			local main = __get_path_c(path);

			local block = BaseWorkspace;

			for i,v in next , main do
				local item = block:FindFirstChild(v);
				if not item then
					local c = Instance.new('Folder',block);

					c.Name = tostring(v);
				else
					block = item;
				end;
			end;
		end;

		getgenv().delfile = function(path)
			local main = __get_path_c(path);

			local block = BaseWorkspace;

			for i,v in next , main do
				local item = block:FindFirstChild(v);
				if item and item:IsA('StringValue') then
					item:Destroy();
				else
					block = item;
				end;
			end;
		end;
	end;
end)

LOAD_ENV();

writefile = writefile or getgenv().writefile;
makefolder = makefolder or getgenv().makefolder;
readfile = readfile or getgenv().readfile;
delfolder = delfolder or getgenv().delfolder;
delfile = delfile or getgenv().delfile;
listfiles = listfiles or getgenv().listfiles;
isfolder = isfolder or getgenv().isfolder;
isfile = isfile or getgenv().isfile;

local NeverLose = {};

NeverLose.BuiltInRegular = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Regular,Enum.FontStyle.Normal);
NeverLose.BuiltInBold = Font.new('rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json',Enum.FontWeight.Bold,Enum.FontStyle.Normal);
NeverLose.GlobalSignals = {};
NeverLose.UnloadEnabled = false;

local cloneref: cloneref = cloneref or function(f) return f end;
local TweenService: TweenService = cloneref(game:GetService('TweenService'));
local UserInputService: UserInputService = cloneref(game:GetService('UserInputService'));
local TextService: TextService = cloneref(game:GetService('TextService'));
local RunService: RunService = cloneref(game:GetService('RunService'));
local Players: Players = cloneref(game:GetService('Players'));
local HttpService: HttpService = cloneref(game:GetService('HttpService'));
local LocalPlayer: Player = Players.LocalPlayer;
local CoreGui: PlayerGui = (gethui and gethui()) or (get_hidden_gui and get_hidden_gui()) or cloneref(game:FindFirstChild('CoreGui')) or cloneref(LocalPlayer.PlayerGui);
local Mouse: Mouse = LocalPlayer:GetMouse();
local CurrentCamera: Camera = cloneref(workspace.CurrentCamera);
local ProtectGui = protect_gui or protectgui or (syn and syn.protect_gui) or function(s) return s; end;
local GlobalWindow = Instance.new('ScreenGui');
local ManualTween = TweenInfo.new(0.1);
local SlowyTween = TweenInfo.new(0.175);
local FastTween = TweenInfo.new(0.05);
local VSlowTween = TweenInfo.new(0.5,Enum.EasingStyle.Quint);
local Encryption = {};

NeverLose.UserProfile = Players:GetUserThumbnailAsync(LocalPlayer.UserId , Enum.ThumbnailType.HeadShot , Enum.ThumbnailSize.Size150x150)
NeverLose.RandomString = LPH_NO_VIRTUALIZE(function()
	return string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4))..string.rep(string.char(math.random(1,7)),math.random(1,4));
end);

ProtectGui(GlobalWindow);

GlobalWindow.Name = NeverLose.RandomString();
GlobalWindow.IgnoreGuiInset = true;
GlobalWindow.ZIndexBehavior = Enum.ZIndexBehavior.Global;
GlobalWindow.ResetOnSpawn = false;
GlobalWindow.Parent = CoreGui;

NeverLose.Scales = {
	Small = UDim2.fromOffset(540,380),
	Mobile = UDim2.fromOffset(640,385),
	Default = UDim2.fromOffset(640 , 480),
	Large = UDim2.fromOffset(800 , 600)
};

NeverLose.IconColor = Color3.fromRGB(255, 255, 255);
NeverLose.ScreenGui = GlobalWindow;
NeverLose.Flags = {};
NeverLose.AccentColor = Color3.fromRGB(78, 127, 252);
NeverLose.MainColor = Color3.fromRGB(8, 8, 13);
NeverLose.RegisiteryColor = {};
NeverLose.NameRegisitry = {};
NeverLose.IsMosueOverOtherFrame = false;
NeverLose.GlobalLogo = "rbxassetid://120358385035996";
NeverLose.ImageColorMapping = "rbxassetid://4155801252";

if getcustomasset then
	local link = "https://github.com/4lpaca-pin/NeverLose/blob/main/assets/%s?raw=true";
	local dir = 'NLAssets';

	if not isfolder(dir) then
		makefolder(dir);
	end;

	pcall(function()
		if not isfile(dir..'/'..'logo.png') then
			local byte = game:HttpGet(string.format(link,'logo.png'));

			writefile(dir..'/'..'logo.png' , byte);
			task.wait();
		end;

		if isfile(dir..'/'..'logo.png') then
			NeverLose.GlobalLogo = getcustomasset(dir..'/'..'logo.png')
		end;
	end);

	pcall(function()
		if not isfile(dir..'/'..'saturation_value_gradient.png') then
			local byte = game:HttpGet(string.format(link,'saturation_value_gradient.png'));

			writefile(dir..'/'..'saturation_value_gradient.png' , byte);
			task.wait();
		end;

		if isfile(dir..'/'..'saturation_value_gradient.png') then
			NeverLose.ImageColorMapping = getcustomasset(dir..'/'..'saturation_value_gradient.png')
		end;
	end);
end;

function NeverLose:AddSignal(RBXSignal)
	if NeverLose.UnloadEnabled then
		table.insert(NeverLose.GlobalSignals,RBXSignal);
	end;

	return RBXSignal;
end;

function NeverLose:AddQuery(ItemRoot: Frame , Name : string)
	table.insert(NeverLose.NameRegisitry , {
		Root = ItemRoot,
		Idx = Name,
	});
end;

function Encryption.new(data: string)
	local bytes = {};
	local encrypt_seed = ((#data + 3782) % 111) + 1;

	string.gsub(data , '.', LPH_NO_VIRTUALIZE(function(dt)
		table.insert(bytes , tostring(dt:byte() + encrypt_seed));
	end));

	local concatbyte = table.concat(bytes,'?');

	table.clear(bytes);

	return "{"..tostring(encrypt_seed + 72667).."}?"..concatbyte;
end;

function Encryption.reverse(data: string)
	local main_data = string.split(data,'?');
	local seed_str = main_data[1]:gsub('{',''):gsub('}','');
	local seed = tonumber(seed_str);

	local ks = {};
	local real_seed = seed - 72667;

	for i,v in next , main_data do
		if i > 1 then
			local fake_byte = tonumber(v);
			table.insert(ks , string.char(fake_byte - real_seed))	
		end;
	end;

	local data = table.concat(ks);

	table.clear(ks);

	return data;
end;

do
	local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';

	NeverLose.Base64Encode = LPH_NO_VIRTUALIZE(function(data)
		return ((data:gsub('.', function(x) 
			local r,b='',x:byte()
			for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
			return r;
		end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
			if (#x < 6) then return '' end
			local c=0
			for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
			return b:sub(c+1,c+1)
		end)..({ '', '==', '=' })[#data%3+1])
	end);

	NeverLose.Base64Decode = LPH_NO_VIRTUALIZE(function(data)
		data = string.gsub(data, '[^'..b..'=]', '')
		return (data:gsub('.', function(x)
			if (x == '=') then return '' end
			local r,f='',(b:find(x)-1)
			for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
			return r;
		end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
			if (#x ~= 8) then return '' end
			local c=0
			for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
			return string.char(c)
		end))
	end);
end;

NeverLose.LoadIcon = LPH_NO_VIRTUALIZE(function()
	NeverLose.RobloxIcon = {
		["3d-cube-arrow-left"] = "3d-cube-arrow-left",
		["amazon"] = "amazon",
		["arm-left"] = "arm-left",
		["arm-right"] = "arm-right",
		["arrow-curl-to-left"] = "arrow-curl-to-left",
		["arrow-curl-to-right"] = "arrow-curl-to-right",
		["arrow-down-to-line"] = "arrow-down-to-line",
		["arrow-large-down"] = "arrow-large-down",
		["arrow-large-left"] = "arrow-large-left",
		["arrow-large-right"] = "arrow-large-right",
		["arrow-large-up"] = "arrow-large-up",
		["arrow-right-from-portrait-rectangle"] = "arrow-right-from-portrait-rectangle",
		["arrow-right-to-portrait-rectangle"] = "arrow-right-to-portrait-rectangle",
		["arrow-rotate-down-dashed"] = "arrow-rotate-down-dashed",
		["arrow-rotate-right"] = "arrow-rotate-right",
		["arrow-rotate-right-dashed"] = "arrow-rotate-right-dashed",
		["arrow-small-down"] = "arrow-small-down",
		["arrow-small-left"] = "arrow-small-left",
		["arrow-small-right"] = "arrow-small-right",
		["arrow-small-up"] = "arrow-small-up",
		["arrow-spin-clockwise"] = "arrow-spin-clockwise",
		["arrow-spin-clockwise-10"] = "arrow-spin-clockwise-10",
		["arrow-spin-clockwise-15"] = "arrow-spin-clockwise-15",
		["arrow-spin-clockwise-30"] = "arrow-spin-clockwise-30",
		["arrow-spin-counter-clockwise-10"] = "arrow-spin-counter-clockwise-10",
		["arrow-spin-counter-clockwise-15"] = "arrow-spin-counter-clockwise-15",
		["arrow-spin-counter-clockwise-30"] = "arrow-spin-counter-clockwise-30",
		["arrow-thick-to-left"] = "arrow-thick-to-left",
		["arrow-thick-to-right"] = "arrow-thick-to-right",
		["arrow-up-from-landscape-rectangle"] = "arrow-up-from-landscape-rectangle",
		["arrow-up-right-from-square"] = "arrow-up-right-from-square",
		["arrow-wide-short-down"] = "arrow-wide-short-down",
		["arrow-wide-short-left"] = "arrow-wide-short-left",
		["arrow-wide-short-right"] = "arrow-wide-short-right",
		["arrow-wide-short-up"] = "arrow-wide-short-up",
		["arrows-small-directional"] = "arrows-small-directional",
		["audio-wave-dotted-line"] = "audio-wave-dotted-line",
		["backpack"] = "backpack",
		["beard"] = "beard",
		["bell"] = "bell",
		["bell-clock"] = "bell-clock",
		["bell-plus"] = "bell-plus",
		["bell-slash"] = "bell-slash",
		["belt"] = "belt",
		["binoculars"] = "binoculars",
		["book-closed"] = "book-closed",
		["bookmark"] = "bookmark",
		["bow-tie"] = "bow-tie",
		["building-store"] = "building-store",
		["bullet-flying"] = "bullet-flying",
		["butterfly-wings"] = "butterfly-wings",
		["calendar"] = "calendar",
		["calendar-plus"] = "calendar-plus",
		["calendar-star"] = "calendar-star",
		["camera-small"] = "camera-small",
		["caret-small-down"] = "caret-small-down",
		["caret-small-left"] = "caret-small-left",
		["caret-small-right"] = "caret-small-right",
		["caret-small-up"] = "caret-small-up",
		["chain-link"] = "chain-link",
		["chart-four-vertical-bars"] = "chart-four-vertical-bars",
		["chart-line"] = "chart-line",
		["chart-pie"] = "chart-pie",
		["chart-scatter-plot"] = "chart-scatter-plot",
		["chart-three-vertical-bars"] = "chart-three-vertical-bars",
		["check"] = "check",
		["check-large"] = "check-large",
		["check-small"] = "check-small",
		["chevron-large-down"] = "chevron-large-down",
		["chevron-large-down-to-line"] = "chevron-large-down-to-line",
		["chevron-large-left"] = "chevron-large-left",
		["chevron-large-left-to-line"] = "chevron-large-left-to-line",
		["chevron-large-right"] = "chevron-large-right",
		["chevron-large-right-to-line"] = "chevron-large-right-to-line",
		["chevron-large-up"] = "chevron-large-up",
		["chevron-large-up-to-line"] = "chevron-large-up-to-line",
		["chevron-small-down"] = "chevron-small-down",
		["chevron-small-down-to-line"] = "chevron-small-down-to-line",
		["chevron-small-left"] = "chevron-small-left",
		["chevron-small-left-to-line"] = "chevron-small-left-to-line",
		["chevron-small-right"] = "chevron-small-right",
		["chevron-small-right-to-line"] = "chevron-small-right-to-line",
		["chevron-small-up"] = "chevron-small-up",
		["chevron-small-up-to-line"] = "chevron-small-up-to-line",
		["circle-check"] = "circle-check",
		["circle-i"] = "circle-i",
		["circle-minus"] = "circle-minus",
		["circle-person"] = "circle-person",
		["circle-person-three-horizontal-bars-wrapping-right"] = "circle-person-three-horizontal-bars-wrapping-right",
		["circle-play"] = "circle-play",
		["circle-plus"] = "circle-plus",
		["circle-question"] = "circle-question",
		["circle-slash"] = "circle-slash",
		["circle-star"] = "circle-star",
		["circle-three-dots-horizontal"] = "circle-three-dots-horizontal",
		["circle-three-dots-vertical"] = "circle-three-dots-vertical",
		["circle-x"] = "circle-x",
		["clock"] = "clock",
		["clock-dashed"] = "clock-dashed",
		["clock-spin-reverse"] = "clock-spin-reverse",
		["clock-spin-reverse-dashed"] = "clock-spin-reverse-dashed",
		["clothes-hanger"] = "clothes-hanger",
		["cloud"] = "cloud",
		["cloud-arrow-down"] = "cloud-arrow-down",
		["code"] = "code",
		["compact-makeup-brush"] = "compact-makeup-brush",
		["compass"] = "compass",
		["controller-with-cog"] = "controller-with-cog",
		["crop"] = "crop",
		["crosshairs"] = "crosshairs",
		["crosshairs-slash"] = "crosshairs-slash",
		["cube-vertexes"] = "cube-vertexes",
		["curved-rectangle-megaphone"] = "curved-rectangle-megaphone",
		["diagonal-line-pattern"] = "diagonal-line-pattern",
		["diagonal-line-pattern-sticker"] = "diagonal-line-pattern-sticker",
		["diamond-simplified"] = "diamond-simplified",
		["discord"] = "discord",
		["disguise-nose-glasses"] = "disguise-nose-glasses",
		["document-circle-slash"] = "document-circle-slash",
		["document-list-heart"] = "document-list-heart",
		["door-open-arrow-to-bottom-right"] = "door-open-arrow-to-bottom-right",
		["dress"] = "dress",
		["dual-arrows-horizontal"] = "dual-arrows-horizontal",
		["dual-arrows-to-corners"] = "dual-arrows-to-corners",
		["dual-arrows-vertical"] = "dual-arrows-vertical",
		["envelope"] = "envelope",
		["eraser"] = "eraser",
		["eye"] = "eye",
		["eye-slash"] = "eye-slash",
		["eye-with-eyeliner"] = "eye-with-eyeliner",
		["eyebrows"] = "eyebrows",
		["eyelashes"] = "eyelashes",
		["face-winking"] = "face-winking",
		["facebook"] = "facebook",
		["file-box"] = "file-box",
		["fingerprint"] = "fingerprint",
		["flag"] = "flag",
		["flame"] = "flame",
		["folder"] = "folder",
		["fountain-pen-nib"] = "fountain-pen-nib",
		["four-bars-horizontal-center-aligned"] = "four-bars-horizontal-center-aligned",
		["four-bars-horizontal-chevron-left"] = "four-bars-horizontal-chevron-left",
		["four-bars-horizontal-chevron-right"] = "four-bars-horizontal-chevron-right",
		["four-bars-horizontal-justified-aligned"] = "four-bars-horizontal-justified-aligned",
		["four-bars-horizontal-left-aligned"] = "four-bars-horizontal-left-aligned",
		["four-bars-horizontal-right-aligned"] = "four-bars-horizontal-right-aligned",
		["frame-bubble-slash"] = "frame-bubble-slash",
		["frame-bubble-soundwave"] = "frame-bubble-soundwave",
		["frame-camera"] = "frame-camera",
		["frame-camera-center"] = "frame-camera-center",
		["frame-collapsed"] = "frame-collapsed",
		["frame-corners"] = "frame-corners",
		["frame-expanded"] = "frame-expanded",
		["frame-face"] = "frame-face",
		["frame-person-torso"] = "frame-person-torso",
		["frame-record"] = "frame-record",
		["frame-single-bar-horizontal"] = "frame-single-bar-horizontal",
		["frame-soundwave"] = "frame-soundwave",
		["frame-video-camera"] = "frame-video-camera",
		["gear"] = "gear",
		["generic-dpad"] = "generic-dpad",
		["gift-box"] = "gift-box",
		["gift-card"] = "gift-card",
		["glasses"] = "glasses",
		["globe-detailed"] = "globe-detailed",
		["globe-simplified"] = "globe-simplified",
		["globe-simplipfied-speech-bubble"] = "globe-simplipfied-speech-bubble",
		["grid"] = "grid",
		["guilded"] = "guilded",
		["hack-week"] = "hack-week",
		["hammer-code"] = "hammer-code",
		["hand-curved-arrow-left"] = "hand-curved-arrow-left",
		["hand-dual-arrows"] = "hand-dual-arrows",
		["hand-ellipse"] = "hand-ellipse",
		["hand-half-ellipse"] = "hand-half-ellipse",
		["hand-two-arrows-horizontal"] = "hand-two-arrows-horizontal",
		["hashtag"] = "hashtag",
		["hat-fedora"] = "hat-fedora",
		["hat-toque"] = "hat-toque",
		["head-blank"] = "head-blank",
		["head-blush"] = "head-blush",
		["head-female"] = "head-female",
		["head-freckles"] = "head-freckles",
		["head-lips"] = "head-lips",
		["head-male"] = "head-male",
		["headphones"] = "headphones",
		["headphones-arrow-up"] = "headphones-arrow-up",
		["headphones-arrow-up-lock"] = "headphones-arrow-up-lock",
		["headphones-slash"] = "headphones-slash",
		["headphones-x"] = "headphones-x",
		["headphones-x-lock"] = "headphones-x-lock",
		["heart"] = "heart",
		["house"] = "house",
		["image"] = "image",
		["image-stacked"] = "image-stacked",
		["instagram"] = "instagram",
		["jacket"] = "jacket",
		["key"] = "key",
		["key-alt"] = "key-alt",
		["key-apostrophe"] = "key-apostrophe",
		["key-arrow-down"] = "key-arrow-down",
		["key-arrow-right"] = "key-arrow-right",
		["key-arrow-up"] = "key-arrow-up",
		["key-asterisk"] = "key-asterisk",
		["key-backspace"] = "key-backspace",
		["key-caps-lock"] = "key-caps-lock",
		["key-caret"] = "key-caret",
		["key-comma"] = "key-comma",
		["key-command"] = "key-command",
		["key-control"] = "key-control",
		["key-grave-accent"] = "key-grave-accent",
		["key-period"] = "key-period",
		["key-return"] = "key-return",
		["key-shift"] = "key-shift",
		["key-space"] = "key-space",
		["key-tab"] = "key-tab",
		["language-characters"] = "language-characters",
		["leg-left"] = "leg-left",
		["leg-right"] = "leg-right",
		["lightning-bolt"] = "lightning-bolt",
		["linkedin"] = "linkedin",
		["lips"] = "lips",
		["lipstick"] = "lipstick",
		["list-bulleted"] = "list-bulleted",
		["location-pin"] = "location-pin",
		["location-pin-map"] = "location-pin-map",
		["lock-closed"] = "lock-closed",
		["lollipop"] = "lollipop",
		["magnifying-glass"] = "magnifying-glass",
		["magnifying-glass-minus"] = "magnifying-glass-minus",
		["magnifying-glass-plus"] = "magnifying-glass-plus",
		["mascara"] = "mascara",
		["megaphone"] = "megaphone",
		["memory-card"] = "memory-card",
		["messenger"] = "messenger",
		["microphone"] = "microphone",
		["microphone-slash"] = "microphone-slash",
		["microphone-text-box"] = "microphone-text-box",
		["microphone-triangle-exclamation"] = "microphone-triangle-exclamation",
		["minus"] = "minus",
		["minus-small"] = "minus-small",
		["mirror-standing"] = "mirror-standing",
		["moments"] = "moments",
		["moon"] = "moon",
		["mouse-button-left"] = "mouse-button-left",
		["mouse-button-right"] = "mouse-button-right",
		["mouse-scrollwheel"] = "mouse-scrollwheel",
		["music-note"] = "music-note",
		["nebula"] = "nebula",
		["necklace"] = "necklace",
		["nine-dots-grid"] = "nine-dots-grid",
		["ninja"] = "ninja",
		["nose"] = "nose",
		["page"] = "page",
		["paint-brush"] = "paint-brush",
		["paint-bucket"] = "paint-bucket",
		["pants"] = "pants",
		["pants-2d-text"] = "pants-2d-text",
		["paper-airplane"] = "paper-airplane",
		["parrot"] = "parrot",
		["pause-large"] = "pause-large",
		["pause-small"] = "pause-small",
		["pencil"] = "pencil",
		["pencil-square"] = "pencil-square",
		["person"] = "person",
		["person-arrow-from-bottom-right"] = "person-arrow-from-bottom-right",
		["person-check"] = "person-check",
		["person-circle-slash"] = "person-circle-slash",
		["person-climbing"] = "person-climbing",
		["person-clock"] = "person-clock",
		["person-falling"] = "person-falling",
		["person-graduate"] = "person-graduate",
		["person-jumping"] = "person-jumping",
		["person-magnifying-glass"] = "person-magnifying-glass",
		["person-photo-camera"] = "person-photo-camera",
		["person-play"] = "person-play",
		["person-play-clock"] = "person-play-clock",
		["person-plus"] = "person-plus",
		["person-racing"] = "person-racing",
		["person-running"] = "person-running",
		["person-standing"] = "person-standing",
		["person-standing-arrow-reverse"] = "person-standing-arrow-reverse",
		["person-standing-dual-arrows-vertical"] = "person-standing-dual-arrows-vertical",
		["person-standing-gear"] = "person-standing-gear",
		["person-swimming"] = "person-swimming",
		["person-teleport"] = "person-teleport",
		["person-trash-can"] = "person-trash-can",
		["person-walking"] = "person-walking",
		["person-with-smaller-person"] = "person-with-smaller-person",
		["phone"] = "phone",
		["phone-down"] = "phone-down",
		["phone-plus"] = "phone-plus",
		["phone-volume"] = "phone-volume",
		["phone-x"] = "phone-x",
		["photo-camera"] = "photo-camera",
		["photo-camera-face"] = "photo-camera-face",
		["photo-camera-slash"] = "photo-camera-slash",
		["picture-in-picture"] = "picture-in-picture",
		["pig"] = "pig",
		["pin"] = "pin",
		["pin-slash"] = "pin-slash",
		["play-large"] = "play-large",
		["play-small"] = "play-small",
		["plus-large"] = "plus-large",
		["plus-small"] = "plus-small",
		["premium"] = "premium",
		["ps-circle"] = "ps-circle",
		["ps-dpad-down"] = "ps-dpad-down",
		["ps-dpad-left"] = "ps-dpad-left",
		["ps-dpad-right"] = "ps-dpad-right",
		["ps-dpad-up"] = "ps-dpad-up",
		["ps-l1"] = "ps-l1",
		["ps-l2"] = "ps-l2",
		["ps-l3"] = "ps-l3",
		["ps-r1"] = "ps-r1",
		["ps-r2"] = "ps-r2",
		["ps-r3"] = "ps-r3",
		["ps-square"] = "ps-square",
		["ps-stick-left"] = "ps-stick-left",
		["ps-stick-right"] = "ps-stick-right",
		["ps-triagle"] = "ps-triagle",
		["ps-x"] = "ps-x",
		["ps4-options"] = "ps4-options",
		["ps4-share"] = "ps4-share",
		["ps4-touchpad"] = "ps4-touchpad",
		["ps5-options"] = "ps5-options",
		["ps5-share"] = "ps5-share",
		["ps5-touchpad"] = "ps5-touchpad",
		["pumpkin"] = "pumpkin",
		["purse"] = "purse",
		["rectangle-list"] = "rectangle-list",
		["rectangle-numbers-counting"] = "rectangle-numbers-counting",
		["rectangle-person-with-three-horizontal-lines"] = "rectangle-person-with-three-horizontal-lines",
		["robux"] = "robux",
		["rosette-seven-point"] = "rosette-seven-point",
		["rosette-ten-point"] = "rosette-ten-point",
		["seven-point-rosette"] = "seven-point-rosette",
		["shield-check"] = "shield-check",
		["shield-lock"] = "shield-lock",
		["shirt"] = "shirt",
		["shirt-2d-text"] = "shirt-2d-text",
		["shirt-pants"] = "shirt-pants",
		["shoe-left"] = "shoe-left",
		["shoe-right"] = "shoe-right",
		["shopping-basket"] = "shopping-basket",
		["shopping-basket-check"] = "shopping-basket-check",
		["shopping-cart"] = "shopping-cart",
		["shorts"] = "shorts",
		["sidebar"] = "sidebar",
		["signal-exclamation"] = "signal-exclamation",
		["six-dots-two-column-grid"] = "six-dots-two-column-grid",
		["skip-end-large"] = "skip-end-large",
		["skip-end-small"] = "skip-end-small",
		["skip-next-large"] = "skip-next-large",
		["skip-next-small"] = "skip-next-small",
		["skip-previous-large"] = "skip-previous-large",
		["skip-previous-small"] = "skip-previous-small",
		["skip-start-large"] = "skip-start-large",
		["skip-start-small"] = "skip-start-small",
		["smartphone-portrait"] = "smartphone-portrait",
		["speaker"] = "speaker",
		["speaker-slash"] = "speaker-slash",
		["speaker-triangle-exclamation"] = "speaker-triangle-exclamation",
		["speaker-x"] = "speaker-x",
		["speech-bubble-align-center"] = "speech-bubble-align-center",
		["speech-bubble-align-left"] = "speech-bubble-align-left",
		["speech-bubble-exclamation"] = "speech-bubble-exclamation",
		["speech-bubble-round"] = "speech-bubble-round",
		["square-bone"] = "square-bone",
		["square-books"] = "square-books",
		["square-check"] = "square-check",
		["square-code"] = "square-code",
		["square-dashed-person-standing"] = "square-dashed-person-standing",
		["square-dual-arrows-horizontal"] = "square-dual-arrows-horizontal",
		["square-dual-arrows-to-corner"] = "square-dual-arrows-to-corner",
		["square-face-sound"] = "square-face-sound",
		["square-face-waving-hand"] = "square-face-waving-hand",
		["square-face-winking"] = "square-face-winking",
		["square-minus"] = "square-minus",
		["square-person"] = "square-person",
		["squares-grid-plus"] = "squares-grid-plus",
		["squares-grid-qr"] = "squares-grid-qr",
		["stacked-squares-arrow-down-left"] = "stacked-squares-arrow-down-left",
		["stacked-squares-arrow-up-right"] = "stacked-squares-arrow-up-right",
		["stacked-squares-plus"] = "stacked-squares-plus",
		["star"] = "star",
		["stop-large"] = "stop-large",
		["stop-small"] = "stop-small",
		["studio"] = "studio",
		["sun"] = "sun",
		["sweater"] = "sweater",
		["sword"] = "sword",
		["tag-sparkle"] = "tag-sparkle",
		["teletype"] = "teletype",
		["tencent-qq"] = "tencent-qq",
		["text-b-bold"] = "text-b-bold",
		["text-box-microphone"] = "text-box-microphone",
		["text-h-subscript-1"] = "text-h-subscript-1",
		["text-h-subscript-2"] = "text-h-subscript-2",
		["text-h-subscript-3"] = "text-h-subscript-3",
		["text-i-italic"] = "text-i-italic",
		["text-s-strikethrough"] = "text-s-strikethrough",
		["text-u-underline"] = "text-u-underline",
		["text-uppercase-a-lowercase-a"] = "text-uppercase-a-lowercase-a",
		["text-x-subscript-2"] = "text-x-subscript-2",
		["text-x-superscript-2"] = "text-x-superscript-2",
		["three-bars-horizontal"] = "three-bars-horizontal",
		["three-bars-horizontal-chevron-left"] = "three-bars-horizontal-chevron-left",
		["three-bars-horizontal-narrowing"] = "three-bars-horizontal-narrowing",
		["three-bars-horizontal-triangles-vertical"] = "three-bars-horizontal-triangles-vertical",
		["three-bars-vertical-triangles-horizontal"] = "three-bars-vertical-triangles-horizontal",
		["three-chevrons-enlarging-down"] = "three-chevrons-enlarging-down",
		["three-chevrons-enlarging-up"] = "three-chevrons-enlarging-up",
		["three-dots-horizontal"] = "three-dots-horizontal",
		["three-dots-vertical"] = "three-dots-vertical",
		["three-horizontal-bars-wrapping-right"] = "three-horizontal-bars-wrapping-right",
		["three-people"] = "three-people",
		["three-ring-note"] = "three-ring-note",
		["three-sliders-horizontal"] = "three-sliders-horizontal",
		["three-stacked-squares-tilted"] = "three-stacked-squares-tilted",
		["thumb-down"] = "thumb-down",
		["thumb-up"] = "thumb-up",
		["tik-tok"] = "tik-tok",
		["tilt"] = "tilt",
		["torso"] = "torso",
		["trash-can"] = "trash-can",
		["triangle-exclamation"] = "triangle-exclamation",
		["trophy"] = "trophy",
		["tshirt"] = "tshirt",
		["tshirt-2d-text"] = "tshirt-2d-text",
		["tshirt-dual-arrows"] = "tshirt-dual-arrows",
		["twitch"] = "twitch",
		["twitter"] = "twitter",
		["two-arrows-down-and-up"] = "two-arrows-down-and-up",
		["two-arrows-from-center"] = "two-arrows-from-center",
		["two-arrows-left-right"] = "two-arrows-left-right",
		["two-arrows-loop-clockwise"] = "two-arrows-loop-clockwise",
		["two-arrows-loop-clockwise-1"] = "two-arrows-loop-clockwise-1",
		["two-arrows-loop-clockwise-infinity"] = "two-arrows-loop-clockwise-infinity",
		["two-arrows-spin-clockwise"] = "two-arrows-spin-clockwise",
		["two-arrows-spin-clockwise-plus"] = "two-arrows-spin-clockwise-plus",
		["two-arrows-switch-right"] = "two-arrows-switch-right",
		["two-arrows-to-center"] = "two-arrows-to-center",
		["two-folders"] = "two-folders",
		["two-location-pins-connecting-arrow"] = "two-location-pins-connecting-arrow",
		["two-makeup-brushes"] = "two-makeup-brushes",
		["two-people"] = "two-people",
		["two-people-speech-bubble"] = "two-people-speech-bubble",
		["two-stacked-squares"] = "two-stacked-squares",
		["two-switches-horizontal"] = "two-switches-horizontal",
		["verified-backplate"] = "verified-backplate",
		["verified-check"] = "verified-check",
		["verified-mono"] = "verified-mono",
		["video-camera"] = "video-camera",
		["video-camera-arrow-to-bottom-left"] = "video-camera-arrow-to-bottom-left",
		["video-camera-arrow-to-top-right"] = "video-camera-arrow-to-top-right",
		["video-camera-slash"] = "video-camera-slash",
		["video-camera-triangle-exclamation"] = "video-camera-triangle-exclamation",
		["video-camera-x"] = "video-camera-x",
		["wallet"] = "wallet",
		["we-chat"] = "we-chat",
		["whatsapp"] = "whatsapp",
		["x"] = "x",
		["x-small"] = "x-small",
		["xbox-a"] = "xbox-a",
		["xbox-a-pressed"] = "xbox-a-pressed",
		["xbox-a-unpressed"] = "xbox-a-unpressed",
		["xbox-b"] = "xbox-b",
		["xbox-dpad"] = "xbox-dpad",
		["xbox-dpad-down"] = "xbox-dpad-down",
		["xbox-dpad-left"] = "xbox-dpad-left",
		["xbox-dpad-right"] = "xbox-dpad-right",
		["xbox-dpad-up"] = "xbox-dpad-up",
		["xbox-lb"] = "xbox-lb",
		["xbox-lt"] = "xbox-lt",
		["xbox-menu"] = "xbox-menu",
		["xbox-rb"] = "xbox-rb",
		["xbox-rt"] = "xbox-rt",
		["xbox-stick-left"] = "xbox-stick-left",
		["xbox-stick-left-directional"] = "xbox-stick-left-directional",
		["xbox-stick-left-horizontal"] = "xbox-stick-left-horizontal",
		["xbox-stick-left-vertical"] = "xbox-stick-left-vertical",
		["xbox-stick-right"] = "xbox-stick-right",
		["xbox-stick-right-directional"] = "xbox-stick-right-directional",
		["xbox-stick-right-horizontal"] = "xbox-stick-right-horizontal",
		["xbox-stick-right-vertical"] = "xbox-stick-right-vertical",
		["xbox-view"] = "xbox-view",
		["xbox-x"] = "xbox-x",
		["xbox-y"] = "xbox-y",
		["xr-headset"] = "xr-headset",
		["youtube"] = "youtube"
	};
end);

NeverLose.IsMouseOverFrame = LPH_NO_VIRTUALIZE(function(self , Frame)
	if not Frame then
		return;
	end;

	if NeverLose.Global3DRenderMode then
		if Frame.GuiState == Enum.GuiState.Hover or Frame.GuiState == Enum.GuiState.Press then
			return true;
		end;

		return false;
	end;

	local AbsPos: Vector2, AbsSize: Vector2 = Frame.AbsolutePosition, Frame.AbsoluteSize;

	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
end);

NeverLose.CreateSignal = LPH_NO_VIRTUALIZE(function(self , DefaultValue)
	local __cache = Instance.new('BindableEvent');
	local bind = {
		Value = DefaultValue,
		__event = __cache
	};

	function bind:GetValue()
		return bind.Value;
	end;

	function bind:SetValue(f)
		bind.Value = f;

		return __cache:Fire(f);
	end;

	function bind:Connect(f)
		local signal = __cache.Event:Connect(f);

		NeverLose:AddSignal(signal);

		return signal;
	end;

	return bind;
end);

NeverLose.SetIconMode = LPH_NO_VIRTUALIZE(function(self , Label: TextLabel , Icon: string)
	local useBold = string.lower(string.sub(Icon , -5)) == '-bold';

	if useBold then
		Label.Text = Icon:sub(1,-6);
		Label.FontFace = NeverLose.BuiltInBold;
	else
		Label.Text = Icon;
		Label.FontFace = NeverLose.BuiltInRegular;
	end;
end);

function NeverLose:GetIconFont(icon: string)
	local useBold = string.lower(string.sub(icon , -5)) == '-bold';

	if useBold then
		return NeverLose.BuiltInBold;
	end;

	return NeverLose.BuiltInRegular;
end;

function NeverLose:MoreThanHalfY(Value: number)
	return (NeverLose.ScreenGui.AbsoluteSize.Y / 2) < Value
end;

NeverLose.IsStudio = RunService:IsStudio();
NeverLose.IsMobile = UserInputService.TouchEnabled;

NeverLose.CreateInput = LPH_NO_VIRTUALIZE(function(self , Frame , Callback)
	local Button = Instance.new('ImageButton',Frame);

	Button.ZIndex = Frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.ImageTransparency = 1;
	Button.Image = "rbxasset://textuers/translateIcon.png";

	if Callback then
		local bth_signal = Button.MouseButton1Click:Connect(Callback);

		return Button , bth_signal;
	end;

	return Button;
end);

NeverLose.PlayAnimate = LPH_NO_VIRTUALIZE(function(Self , Info , Property)
	local Tween = TweenService:Create(Self , Info or TweenInfo.new(0.25) , Property);

	Tween:Play();

	return Tween;
end);

NeverLose.Drag = LPH_NO_VIRTUALIZE(function(InputFrame: Frame, MoveFrame: Frame, Speed : number)
	local dragToggle: boolean = false;
	local dragStart: Vector3 = nil;
	local startPos: UDim2 = nil;
	local Tween = TweenInfo.new(Speed);

	local updateInput = function(input)
		local delta = input.Position - dragStart;
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y);

		if NeverLose.Global3DRenderMode then
			NeverLose.PlayAnimate(MoveFrame,Tween,{
				Position = UDim2.fromScale(0.5,0.5)
			});
		else
			NeverLose.PlayAnimate(MoveFrame,Tween,{
				Position = position
			});
		end;
	end;

	NeverLose:AddSignal(InputFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true;
			dragStart = input.Position;
			startPos = MoveFrame.Position;

			local input_end;
			input_end = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false;

					input_end:Disconnect();
				end
			end)
		end
	end));

	NeverLose:AddSignal(UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end));
end);

NeverLose.Rounding = LPH_NO_VIRTUALIZE(function(num, numDecimalPlaces)
	local mult = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end);

NeverLose.ProcessParams = LPH_NO_VIRTUALIZE(function(self , Params , Fixed)
	Params = Params or {};

	local k = Params or {};

	for i,v in next , Fixed do
		k[i] = Params[i] or v;
	end;

	table.clear(Fixed);

	return k;
end);

NeverLose.EnabledBlur = true;
NeverLose.BlurModuleParent = workspace.CurrentCamera;

NeverLose.GetCalculatePosition = LPH_NO_VIRTUALIZE(function(planePos, planeNormal, rayOrigin, rayDirection)
	local n = planeNormal;
	local d = rayDirection;
	local v = rayOrigin - planePos;

	local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z);
	local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
	local a = -num / den;

	return rayOrigin + (a * rayDirection);
end);

NeverLose.CreateBlurModule = LPH_NO_VIRTUALIZE(function(self , Frame , Signal)
	if not NeverLose.EnabledBlur then
		return NeverLose:AddSignal(Instance.new('BindableEvent').Event:Connect(function() return "nl"; end));	
	end;

	local Part = Instance.new('Part',NeverLose.BlurModuleParent);
	local DepthOfField = Instance.new('DepthOfFieldEffect',cloneref(game:GetService('Lighting')));
	local BlockMesh = Instance.new("BlockMesh");

	BlockMesh.Parent = Part;

	Part.Material = Enum.Material.Glass;
	Part.Transparency = 1;
	Part.Reflectance = 1;
	Part.CastShadow = false;
	Part.Anchored = true;
	Part.CanCollide = false;
	Part.CanQuery = false;
	Part.CollisionGroup = NeverLose.RandomString();
	Part.Size = Vector3.new(1, 1, 1) * 0.01;
	Part.Color = Color3.fromRGB(0,0,0);

	DepthOfField.Enabled = true;
	DepthOfField.FarIntensity = 0;
	DepthOfField.FocusDistance = 0;
	DepthOfField.InFocusRadius = 1000;
	DepthOfField.NearIntensity = 1;
	DepthOfField.Name = NeverLose.RandomString();

	Part.Name = NeverLose.RandomString();

	local disconnect;

	local UpdateFunction = function()
		local IsWindowActive = Signal:GetValue();

		if IsWindowActive and not NeverLose.Global3DRenderMode then

			NeverLose.PlayAnimate(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 1
			})

			NeverLose.PlayAnimate(Part,TweenInfo.new(0.1),{
				Transparency = 0.97,
				Size = Vector3.new(1, 1, 1) * 0.01;
			})

			Part.Parent = NeverLose.BlurModuleParent;
		else
			NeverLose.PlayAnimate(DepthOfField,TweenInfo.new(0.1),{
				NearIntensity = 0
			})

			NeverLose.PlayAnimate(Part,TweenInfo.new(0.1),{
				Size = Vector3.zero,
				Transparency = 1.5,
			})

			Part.Parent = nil;

			return false;
		end;

		if IsWindowActive then
			local corner0 = Frame.AbsolutePosition;
			local corner1 = corner0 + Frame.AbsoluteSize;

			local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1);
			local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1);

			local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ);

			local planeNormal = CurrentCamera.CFrame.LookVector;

			local pos0 = NeverLose.GetCalculatePosition(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
			local pos1 = NeverLose.GetCalculatePosition(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);

			pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0);
			pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1);

			local size   = pos1 - pos0;
			local center = (pos0 + pos1) / 2;

			BlockMesh.Offset = center
			BlockMesh.Scale  = size / 0.0101;
			Part.CFrame = CurrentCamera.CFrame;
		end;
	end;

	local rbxsignal = NeverLose:AddSignal(CurrentCamera:GetPropertyChangedSignal('CFrame'):Connect(UpdateFunction))
	local loopThread = NeverLose:AddSignal(UserInputService.InputChanged:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
			pcall(UpdateFunction);
		end;
	end));

	local THREAD = task.spawn(function()
		while true do task.wait(0.1)
			pcall(UpdateFunction);
		end;
	end);

	disconnect = function()
		rbxsignal:Disconnect();
		loopThread:Disconnect();
		task.cancel(THREAD);
		Part:Destroy();
		DepthOfField:Destroy();
	end;

	Frame.Destroying:Connect(disconnect);

	return rbxsignal;
end);

local EmptyFunction = function() end;

function NeverLose:RollingEffect(parent)
	local UIGradient = Instance.new("UIGradient")

	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.4), NumberSequenceKeypoint.new(1.00, 0.00)}
	UIGradient.Parent = parent

	return UIGradient;
end;

function NeverLose:CreateShadow(parent , RollingEffect)
	local Shadow = {};

	local UIShadowSafe85 = Instance.new("UIStroke")
	local UIShadowSafe65 = Instance.new("UIStroke")
	local UIShadowSafe50 = Instance.new("UIStroke")
	local UIShadowSafe45 = Instance.new("UIStroke")

	UIShadowSafe85.Thickness = 6.000
	UIShadowSafe85.Transparency = 1
	UIShadowSafe85.Parent = parent

	UIShadowSafe65.Thickness = 5.000
	UIShadowSafe65.Transparency = 1
	UIShadowSafe65.Parent = parent

	UIShadowSafe50.Thickness = 4.000
	UIShadowSafe50.Transparency = 1
	UIShadowSafe50.Parent = parent

	UIShadowSafe45.Thickness = 3.000
	UIShadowSafe45.Transparency = 1
	UIShadowSafe45.Parent = parent

	local RollingEffectThread;
	local r1,r2,r3,r4;

	if RollingEffect then
		r1 = NeverLose:RollingEffect(UIShadowSafe85);
		r2 = NeverLose:RollingEffect(UIShadowSafe65);
		r3 = NeverLose:RollingEffect(UIShadowSafe50);
		r4 = NeverLose:RollingEffect(UIShadowSafe45);
	end;

	Shadow.Render = LPH_NO_VIRTUALIZE(function(self , value)
		if RollingEffectThread then
			task.cancel(RollingEffectThread);
			RollingEffectThread = nil;
		end;

		if value then
			NeverLose.PlayAnimate(UIShadowSafe85 , SlowyTween , {
				Transparency = 0.900
			})

			NeverLose.PlayAnimate(UIShadowSafe65 , SlowyTween , {
				Transparency = 0.900
			})

			NeverLose.PlayAnimate(UIShadowSafe50 , SlowyTween , {
				Transparency = 0.900
			})

			NeverLose.PlayAnimate(UIShadowSafe45 , SlowyTween , {
				Transparency = 0.900
			})

			if RollingEffect then
				RollingEffectThread = task.spawn(function()
					local level = 20;
					while true do task.wait(0.025)
						NeverLose.PlayAnimate(r1 , SlowyTween , {
							Rotation = r1.Rotation + level
						});

						NeverLose.PlayAnimate(r2 , SlowyTween , {
							Rotation = r2.Rotation + level
						});

						NeverLose.PlayAnimate(r3 , SlowyTween , {
							Rotation = r3.Rotation + level
						});

						NeverLose.PlayAnimate(r4 , SlowyTween , {
							Rotation = r4.Rotation + level
						});
					end;
				end);
			end;
		else
			NeverLose.PlayAnimate(UIShadowSafe85 , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(UIShadowSafe65 , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(UIShadowSafe50 , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(UIShadowSafe45 , SlowyTween , {
				Transparency = 1
			})
		end;
	end);

	return Shadow;
end;

function NeverLose:CreateOptionWindow(Frame: Frame , Zindex)
	Zindex = Zindex or 9;

	local Window = {
		Signal = NeverLose:CreateSignal(false),
	};

	local OptionHandler = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIListLayout = Instance.new("UIListLayout")
	local UIStroke = Instance.new("UIStroke")
	local shadow = NeverLose:CreateShadow(OptionHandler);

	OptionHandler.Name = NeverLose.RandomString();
	OptionHandler.Parent = NeverLose.ScreenGui
	OptionHandler.AnchorPoint = Vector2.new(0, 0)
	OptionHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	OptionHandler.BackgroundTransparency = 0.035
	OptionHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OptionHandler.BorderSizePixel = 0
	OptionHandler.ClipsDescendants = true
	OptionHandler.Position = UDim2.new(255,255,255,255)
	OptionHandler.Size = UDim2.new(0, 220, 0, 75)
	OptionHandler.ZIndex = Zindex + 9

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = OptionHandler

	UIListLayout.Parent = OptionHandler
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = OptionHandler

	NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
		NeverLose.PlayAnimate(OptionHandler , SlowyTween , {
			Size = UDim2.new(0, 220, 0, UIListLayout.AbsoluteContentSize.Y - 1)
		})
	end)));

	NeverLose:AddSignal(OptionHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if OptionHandler.BackgroundTransparency > 0.9 then
			OptionHandler.Visible = false;
			UIListLayout.Parent = nil;
			OptionHandler.Parent = nil;
		else
			OptionHandler.Visible = true;
			UIListLayout.Parent = OptionHandler

			if NeverLose.Global3DRenderMode then
				OptionHandler.Parent = NeverLose.GlobalSurfaceGui;
			else
				OptionHandler.Parent = NeverLose.ScreenGui;
			end;
		end
	end)));

	local FollowingThread;
	local SetPosition = LPH_NO_VIRTUALIZE(function()
		if NeverLose:MoreThanHalfY(Frame.AbsolutePosition.Y + 65) then
			OptionHandler.AnchorPoint = Vector2.new(0,1)
		else
			OptionHandler.AnchorPoint = Vector2.new(0,0)
		end;

		OptionHandler.Position = UDim2.fromOffset(Frame.AbsolutePosition.X + 18 , Frame.AbsolutePosition.Y + 65);
	end);

	Window.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if FollowingThread then
			task.cancel(FollowingThread);
			FollowingThread = nil;
		end;

		if value then
			SetPosition();

			NeverLose.PlayAnimate(OptionHandler , SlowyTween , {
				BackgroundTransparency = 0.035
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 0.650
			})

			shadow:Render(true);

			if NeverLose.Global3DRenderMode then
				OptionHandler.Parent = NeverLose.GlobalSurfaceGui;
			else
				OptionHandler.Parent = NeverLose.ScreenGui;
			end;

			FollowingThread = task.spawn(function()
				while true do task.wait()
					SetPosition();
				end
			end)
		else
			NeverLose.PlayAnimate(OptionHandler , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			shadow:Render(false);
		end;
	end);

	Window.SetRender(false);
	Window.Signal:Connect(Window.SetRender)

	local Payback = NeverLose:RegisiterItem(OptionHandler , Window.Signal);

	Payback.Winbdow = Window;
	Payback.Root = OptionHandler;
	Payback.Signal = Window.Signal;

	return Payback;
end;

function NeverLose:CreateColorPicker(HandleFrame: Frame)
	local ZIndex = HandleFrame.ZIndex;

	local ColorPickerLib = {};

	local ColorPickerHandler = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local SaViMap = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local ColorZoneSelection = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local ColorMap = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_4 = Instance.new("UICorner")
	local ColorMapSelection = Instance.new("Frame")
	local UIStroke_3 = Instance.new("UIStroke")
	local UICorner_5 = Instance.new("UICorner")
	local RGBLabel = Instance.new("TextLabel")
	local UICorner_6 = Instance.new("UICorner")
	local Shadow = NeverLose:CreateShadow(ColorPickerHandler);

	ColorPickerHandler.Name = NeverLose.RandomString();
	ColorPickerHandler.Parent = NeverLose.ScreenGui
	ColorPickerHandler.AnchorPoint = Vector2.new(0, 0)
	ColorPickerHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	ColorPickerHandler.BackgroundTransparency = 0.035
	ColorPickerHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPickerHandler.BorderSizePixel = 0
	ColorPickerHandler.ClipsDescendants = true
	ColorPickerHandler.Position = UDim2.new(255, 0, 255, 20)
	ColorPickerHandler.Size = UDim2.new(0, 200, 0, 240)
	ColorPickerHandler.ZIndex = ZIndex + 125

	NeverLose:AddSignal(ColorPickerHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if ColorPickerHandler.BackgroundTransparency > 0.9 then
			ColorPickerHandler.Visible = false;
			ColorPickerHandler.Parent = nil
		else
			ColorPickerHandler.Visible = true;

			if NeverLose.Global3DRenderMode then
				ColorPickerHandler.Parent = NeverLose.GlobalSurfaceGui;
			else
				ColorPickerHandler.Parent = NeverLose.ScreenGui;
			end;
		end;
	end)));

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = ColorPickerHandler

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = ColorPickerHandler

	SaViMap.Name = NeverLose.RandomString();
	SaViMap.Parent = ColorPickerHandler
	SaViMap.AnchorPoint = Vector2.new(0.5, 0)
	SaViMap.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
	SaViMap.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SaViMap.BorderSizePixel = 0
	SaViMap.Position = UDim2.new(0.5, 0, 0, 5)
	SaViMap.Size = UDim2.new(0, 185, 0, 185)
	SaViMap.ZIndex = ZIndex + 126
	SaViMap.Image = NeverLose.ImageColorMapping -- UNSAFE IMAGE

	UICorner_2.CornerRadius = UDim.new(0, 5)
	UICorner_2.Parent = SaViMap

	ColorZoneSelection.Name = NeverLose.RandomString();
	ColorZoneSelection.Parent = SaViMap
	ColorZoneSelection.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorZoneSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorZoneSelection.BackgroundTransparency = 1.000
	ColorZoneSelection.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorZoneSelection.BorderSizePixel = 0
	ColorZoneSelection.Position = UDim2.new(0.5, 0, 0.5, 0)
	ColorZoneSelection.Size = UDim2.new(0, 10, 0, 10)
	ColorZoneSelection.ZIndex = ZIndex + 127

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = ColorZoneSelection

	UIStroke_2.Color = Color3.fromRGB(255, 255, 255)
	UIStroke_2.Parent = ColorZoneSelection

	ColorMap.Name = NeverLose.RandomString();
	ColorMap.Parent = ColorPickerHandler
	ColorMap.AnchorPoint = Vector2.new(0.5, 0)
	ColorMap.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorMap.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorMap.BorderSizePixel = 0
	ColorMap.Position = UDim2.new(0.5, 0, 0, 200)
	ColorMap.Size = UDim2.new(1, -15, 0, 10)
	ColorMap.ZIndex = ZIndex + 126

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(203, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 101, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))}
	UIGradient.Parent = ColorMap

	UICorner_4.CornerRadius = UDim.new(0, 3)
	UICorner_4.Parent = ColorMap

	ColorMapSelection.Name = NeverLose.RandomString();
	ColorMapSelection.Parent = ColorMap
	ColorMapSelection.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorMapSelection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorMapSelection.BackgroundTransparency = 1.000
	ColorMapSelection.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorMapSelection.BorderSizePixel = 0
	ColorMapSelection.Position = UDim2.new(0, 0, 0.5, 0)
	ColorMapSelection.Size = UDim2.new(0, 5, 1, 0)
	ColorMapSelection.ZIndex = ZIndex + 126

	UIStroke_3.Thickness = 2.000
	UIStroke_3.Color = Color3.fromRGB(255, 255, 255)
	UIStroke_3.Parent = ColorMapSelection

	UICorner_5.CornerRadius = UDim.new(0, 3)
	UICorner_5.Parent = ColorMapSelection

	RGBLabel.Name = NeverLose.RandomString();
	RGBLabel.Parent = ColorPickerHandler
	RGBLabel.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
	RGBLabel.BackgroundTransparency = 0.750
	RGBLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RGBLabel.BorderSizePixel = 0
	RGBLabel.Position = UDim2.new(0, 10, 0, 217)
	RGBLabel.Size = UDim2.new(1, -20, 0, 15)
	RGBLabel.ZIndex = ZIndex + 127
	RGBLabel.Font = Enum.Font.GothamBold
	RGBLabel.Text = "#FFFFFF"
	RGBLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	RGBLabel.TextSize = 12.000
	RGBLabel.TextTransparency = 0.400
	RGBLabel.TextXAlignment = Enum.TextXAlignment.Left

	UICorner_6.CornerRadius = UDim.new(0, 4)
	UICorner_6.Parent = RGBLabel

	ColorPickerLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if value then
			ColorPickerHandler.Position = UDim2.new(0,HandleFrame.AbsolutePosition.X + 20 , 0 ,HandleFrame.AbsolutePosition.Y + 75);

			NeverLose.PlayAnimate(ColorPickerHandler,SlowyTween , {
				BackgroundTransparency = 0.035
			})

			NeverLose.PlayAnimate(UIStroke,SlowyTween , {
				Transparency = 0.650
			})

			NeverLose.PlayAnimate(SaViMap,SlowyTween , {
				BackgroundTransparency = 0,
				ImageTransparency = 0
			})

			NeverLose.PlayAnimate(UIStroke_2,SlowyTween , {
				Transparency = 0
			})

			NeverLose.PlayAnimate(ColorMap,SlowyTween , {
				BackgroundTransparency = 0
			})

			NeverLose.PlayAnimate(UIStroke_3,SlowyTween , {
				Transparency = 0
			})

			NeverLose.PlayAnimate(RGBLabel,SlowyTween , {
				BackgroundTransparency = 0.750,
				TextTransparency = 0.400
			})

			Shadow:Render(true)
		else
			NeverLose.PlayAnimate(ColorPickerHandler,SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke,SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(SaViMap,SlowyTween , {
				BackgroundTransparency = 1,
				ImageTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke_2,SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(ColorMap,SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke_3,SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(RGBLabel,SlowyTween , {
				BackgroundTransparency = 1,
				TextTransparency = 1
			})

			Shadow:Render(false)
		end;
	end);

	ColorPickerLib.SetRender(false);
	ColorPickerLib.Root = ColorPickerHandler;
	ColorPickerLib.H = 1;
	ColorPickerLib.S = 1;
	ColorPickerLib.V = 1;
	ColorPickerLib.Callback = EmptyFunction;

	function ColorPickerLib:Update()
		local RealColor = Color3.fromHSV(ColorPickerLib.H , ColorPickerLib.S , ColorPickerLib.V);

		NeverLose.PlayAnimate(ColorZoneSelection,ManualTween,{
			Position = UDim2.fromScale(ColorPickerLib.S , 1 - ColorPickerLib.V)
		});

		NeverLose.PlayAnimate(SaViMap,ManualTween,{
			BackgroundColor3 = Color3.fromHSV(ColorPickerLib.H , 1 , 1)
		});

		NeverLose.PlayAnimate(ColorMapSelection,ManualTween,{
			Position = UDim2.fromScale(ColorPickerLib.H,0.5)
		});

		RGBLabel.Text = "#"..RealColor:ToHex();

		ColorPickerLib.Callback(RealColor);
	end;

	function ColorPickerLib:SetValue(Color)
		if typeof(Color) == 'string' then
			Color = Color3.fromHex(Color);
		end;

		local H , S , V = Color:ToHSV();

		ColorPickerLib.H = H;
		ColorPickerLib.S = S;
		ColorPickerLib.V = V;

		ColorPickerLib:Update();
	end;

	ColorPickerLib.IsHold = false;

	NeverLose:AddSignal(ColorPickerHandler.InputBegan:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;
		end;
	end));

	NeverLose:AddSignal(ColorPickerHandler.InputEnded:Connect(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = false;
		end;
	end));

	NeverLose:AddSignal(ColorMap.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;

			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or ColorPickerLib.IsHold) do task.wait()
				local ColorY = ColorMap.AbsolutePosition.X
				local ColorYM = ColorY + ColorMap.AbsoluteSize.X;
				local Value = math.clamp(Mouse.X, ColorY, ColorYM)
				local Code = ((Value - ColorY) / (ColorYM - ColorY));

				ColorPickerLib.H = Code;
				ColorPickerLib:Update();
			end;
		end;
	end)));

	NeverLose:AddSignal(SaViMap.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
		if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
			ColorPickerLib.IsHold = true;

			while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or ColorPickerLib.IsHold) do task.wait();
				local PosX = SaViMap.AbsolutePosition.X;
				local ScaleX = PosX + SaViMap.AbsoluteSize.X;
				local Value, PosY = math.clamp(Mouse.X, PosX, ScaleX), SaViMap.AbsolutePosition.Y;
				local ScaleY = PosY + SaViMap.AbsoluteSize.Y;
				local Vals = math.clamp(Mouse.Y, PosY, ScaleY);

				ColorPickerLib.S = (Value - PosX) / (ScaleX - PosX);
				ColorPickerLib.V = (1 - ((Vals - PosY) / (ScaleY - PosY)));
				ColorPickerLib:Update();
			end
		end
	end)));

	return ColorPickerLib;
end;

NeverLose.KeyEnum = {
	One = '1',
	Two = '2',
	Three = '3',
	Four = '4',
	Five = '5',
	Six = '6',
	Seven = '7',
	Eight = '8',
	Nine = '9',
	Zero = '0',
	['Minus'] = "-",
	['Plus'] = "+",
	BackSlash = "\\",
	Slash = "/",
	Period = '.',
	Semicolon = ';',
	Colon = ":",
	LeftControl = "LCtrl",
	RightControl = "RCtrl",
	LeftShift = "LShift",
	RightShift = "RShift",
	Return = "Enter",
	LeftBracket = "[",
	RightBracket = "]",
	Quote = "'",
	Comma = ",",
	Equals = "=",
	LeftSuper = "Super",
	RightSuper = "Super",
	LeftAlt = "LAlt",
	RightAlt = "RAlt",
	Escape = "Esc",
};

NeverLose.EnumReverse = {};

for i,v in next , NeverLose.KeyEnum do
	NeverLose.EnumReverse[v] = i;
end;

function NeverLose:KeyCodeToStr(K: Enum.KeyCode)
	if typeof(K) == 'string' then
		if NeverLose.KeyEnum[K] then
			return NeverLose.KeyEnum[K];
		end;

		return K;
	end;

	return (NeverLose.KeyEnum[K.Name] or K.Name);
end;

function NeverLose:StrToKeyCode(str: string)
	if NeverLose.EnumReverse[str] then
		return Enum.KeyCode[NeverLose.EnumReverse[str]];
	end;

	return Enum.KeyCode[str];
end;

function NeverLose:RegisiterHandler(Handler: Frame , Signal)
	local handle = {};
	local ZINdex = Handler.ZIndex;

	function handle:AddToggle(Config)
		Config = NeverLose:ProcessParams(Config , {
			Default = false,
			Flag = nil,
			Callback = EmptyFunction,
		});

		local Toggle = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Circle = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")

		Toggle.Name = NeverLose.RandomString();
		Toggle.Parent = Handler
		Toggle.BackgroundColor3 = Color3.fromRGB(10, 13, 21)
		Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Toggle.BorderSizePixel = 0
		Toggle.ClipsDescendants = true
		Toggle.Size = UDim2.new(0, 30, 0, 18)
		Toggle.ZIndex = ZINdex + 13
		Toggle.LayoutOrder = -(#Handler:GetChildren() + 5);

		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = Toggle

		Circle.Name = NeverLose.RandomString();
		Circle.Parent = Toggle
		Circle.AnchorPoint = Vector2.new(0.5, 0.5)
		Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Circle.BackgroundTransparency = 0.500
		Circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Circle.BorderSizePixel = 0
		Circle.Position = UDim2.new(0.300000012, 0, 0.5, 0)
		Circle.Size = UDim2.new(0, 16, 0, 16)
		Circle.ZIndex = ZINdex + 14

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = Circle

		local ToggleLib = {
			Root = Toggle	
		};

		ToggleLib.SetUI = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(Toggle,SlowyTween,{
					BackgroundTransparency = 0,
					BackgroundColor3 = NeverLose.AccentColor
				})

				NeverLose.PlayAnimate(Circle,SlowyTween,{
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0,
					Position = UDim2.new(0.7, 0, 0.5, 0)
				})
			else
				NeverLose.PlayAnimate(Toggle,SlowyTween,{
					BackgroundTransparency = 0,
					BackgroundColor3 = Color3.fromRGB(10, 13, 21)
				})

				NeverLose.PlayAnimate(Circle,SlowyTween,{
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 0.500,
					Position = UDim2.new(0.300000012, 0, 0.5, 0)
				})
			end;
		end);

		ToggleLib.SetVisible = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ToggleLib.SetUI(Config.Default);
			else
				NeverLose.PlayAnimate(Toggle,SlowyTween,{
					BackgroundTransparency = 1,
					BackgroundColor3 = Color3.fromRGB(10, 13, 21)
				})

				NeverLose.PlayAnimate(Circle,SlowyTween,{
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					Position = UDim2.new(0.300000012, 0, 0.5, 0)
				})
			end;
		end);

		ToggleLib.SetUI(Config.Default);
		ToggleLib.SetVisible(Signal:GetValue());

		NeverLose:CreateInput(Toggle , LPH_NO_VIRTUALIZE(function()
			Config.Default = not Config.Default;

			ToggleLib.SetUI(Config.Default);

			Config.Callback(Config.Default)
		end))

		ToggleLib.Signal = Signal:Connect(ToggleLib.SetVisible);

		function ToggleLib:GetValue()
			return Config.Default;
		end;

		function ToggleLib:SetValue(v)
			Config.Default = v;

			if Signal:GetValue() then
				ToggleLib.SetUI(Config.Default);
			end;

			Config.Callback(Config.Default)
		end;

		if Config.Flag then
			NeverLose.Flags[Config.Flag] = ToggleLib;
		end;

		return ToggleLib;
	end;

	function handle:AddSlider(Config)
		Config = NeverLose:ProcessParams(Config , {
			Default = 50,
			Min = 0,
			Max = 10,
			Type = "",
			Rounding = 0,
			Nums = {},
			Flag = nil,
			Size = 125,
			Callback = EmptyFunction,
		});

		local SliderLib = {};

		SliderLib.GetSize = LPH_NO_VIRTUALIZE(function()
			return (Config.Default - Config.Min) / (Config.Max - Config.Min);
		end);

		local FullNumSize = TextService:GetTextSize(string.rep("0",(Config.Rounding + #tostring(Config.Max))+1)..tostring(Config.Type),10,Enum.Font.GothamMedium,Vector2.new(math.huge,math.huge));

		SliderLib.MaximumSize = FullNumSize.X;

		if Config.Nums then
			local nszie = 0;

			for i,ns in next , Config.Nums do
				local size = TextService:GetTextSize(string.rep("m",string.len(tostring(ns))),10,Enum.Font.GothamMedium,Vector2.new(math.huge,math.huge));

				if nszie < size.X then
					nszie = size.X;
				end
			end;

			if SliderLib.MaximumSize < nszie then
				SliderLib.MaximumSize = nszie;
			end;
		end;

		local Slider = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local ValueFrame = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ValueLabel = Instance.new("TextBox")
		local SlideMain = Instance.new("Frame")
		local SlideFrame = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		local SlideMoving = Instance.new("Frame")
		local UICorner_4 = Instance.new("UICorner")
		local Frame = Instance.new("Frame")
		local UICorner_5 = Instance.new("UICorner")
		local boxSize = 2;

		Slider.Name = NeverLose.RandomString();
		Slider.Parent = Handler
		Slider.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		Slider.BackgroundTransparency = 1.000
		Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Slider.BorderSizePixel = 0
		Slider.ClipsDescendants = false
		Slider.Size = UDim2.new(0, Config.Size, 0, 18)
		Slider.ZIndex = ZINdex + 13
		Slider.LayoutOrder = -(#Handler:GetChildren() + 5);

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Slider

		ValueFrame.Name = NeverLose.RandomString();
		ValueFrame.Parent = Slider
		ValueFrame.AnchorPoint = Vector2.new(1, 0)
		ValueFrame.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		ValueFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueFrame.BorderSizePixel = 0
		ValueFrame.ClipsDescendants = true
		ValueFrame.Position = UDim2.new(1, 0, 0, 0)
		ValueFrame.Size = UDim2.new(0, SliderLib.MaximumSize + boxSize, 0, 18)
		ValueFrame.ZIndex = ZINdex + 13

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = ValueFrame

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = ValueFrame

		ValueLabel.Name = NeverLose.RandomString();
		ValueLabel.Parent = ValueFrame
		ValueLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.BackgroundTransparency = 1.000
		ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueLabel.BorderSizePixel = 0
		ValueLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValueLabel.Size = UDim2.new(1, 0, 1, 0)
		ValueLabel.ZIndex = ZINdex + 14
		ValueLabel.Font = Enum.Font.GothamMedium
		ValueLabel.Text = tostring(Config.Default)..tostring(Config.Type);
		ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.TextSize = 10.000
		ValueLabel.ClearTextOnFocus = false;
		ValueLabel.TextTransparency = 0.350

		SlideMain.Name = NeverLose.RandomString();
		SlideMain.Parent = Slider
		SlideMain.AnchorPoint = Vector2.new(0, 0.5)
		SlideMain.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SlideMain.BackgroundTransparency = 1.000
		SlideMain.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SlideMain.BorderSizePixel = 0
		SlideMain.Position = UDim2.new(0, 0, 0.5, 0)
		SlideMain.Size = UDim2.new(1, -((SliderLib.MaximumSize + 11)), 0, 18)
		SlideMain.ZIndex = ZINdex + 13

		SlideFrame.Name = NeverLose.RandomString();
		SlideFrame.Parent = SlideMain
		SlideFrame.AnchorPoint = Vector2.new(0, 0.5)
		SlideFrame.BackgroundColor3 = Color3.fromRGB(30, 29, 36)
		SlideFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SlideFrame.BorderSizePixel = 0
		SlideFrame.Position = UDim2.new(0, 0, 0.5, 0)
		SlideFrame.Size = UDim2.new(1, 0, 0, 5)
		SlideFrame.ZIndex = ZINdex + 13

		UICorner_3.CornerRadius = UDim.new(1, 0)
		UICorner_3.Parent = SlideFrame

		SlideMoving.Name = NeverLose.RandomString();
		SlideMoving.Parent = SlideFrame
		SlideMoving.BackgroundColor3 = NeverLose.AccentColor
		SlideMoving.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SlideMoving.BorderSizePixel = 0
		SlideMoving.Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
		SlideMoving.ZIndex = ZINdex + 14

		UICorner_4.CornerRadius = UDim.new(1, 0)
		UICorner_4.Parent = SlideMoving

		Frame.Parent = SlideMoving
		Frame.AnchorPoint = Vector2.new(1, 0.5)
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Position = UDim2.new(1, 5, 0.5, 0)
		Frame.Size = UDim2.new(0, 10, 0, 10)
		Frame.ZIndex = ZINdex + 15

		UICorner_5.CornerRadius = UDim.new(1, 0)
		UICorner_5.Parent = Frame

		local LoadText = LPH_NO_VIRTUALIZE(function()
			if Config.Nums[Config.Default] then
				ValueLabel.Text = Config.Nums[Config.Default]

			else
				ValueLabel.Text = tostring(Config.Default)..tostring(Config.Type);

			end;
		end);

		ValueLabel.FocusLost:Connect(LPH_NO_VIRTUALIZE(function()
			local OutVal = NeverLose:ParseInput(ValueLabel.Text , true);
			if OutVal then
				local rx = math.clamp(OutVal , Config.Min , Config.Max);
				local Value = NeverLose.Rounding(rx,Config.Rounding);

				if Value then
					Config.Default = Value;

					TweenService:Create(SlideMoving , ManualTween ,{
						Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
					}):Play();

					LoadText();

					Config.Callback(Config.Default)
				else
					LoadText();
				end;

			else
				LoadText()
			end;
		end));

		SliderLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(ValueFrame,SlowyTween,{
					BackgroundTransparency = 0,
					Size = UDim2.new(0, SliderLib.MaximumSize + boxSize, 0, 18)
				});

				NeverLose.PlayAnimate(UIStroke,SlowyTween,{
					Transparency = 0.650
				});

				NeverLose.PlayAnimate(ValueLabel,SlowyTween,{
					TextTransparency = 0.350
				});

				NeverLose.PlayAnimate(SlideFrame,SlowyTween,{
					BackgroundTransparency = 0
				});

				NeverLose.PlayAnimate(SlideMoving,SlowyTween,{
					BackgroundTransparency = 0,
					Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
				});

				NeverLose.PlayAnimate(Frame,SlowyTween,{
					BackgroundTransparency = 0
				});
			else
				NeverLose.PlayAnimate(ValueFrame,SlowyTween,{
					BackgroundTransparency = 1,
				});

				NeverLose.PlayAnimate(UIStroke,SlowyTween,{
					Transparency = 1
				});

				NeverLose.PlayAnimate(ValueLabel,SlowyTween,{
					TextTransparency = 1
				});

				NeverLose.PlayAnimate(SlideFrame,SlowyTween,{
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(SlideMoving,SlowyTween,{
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 0, 1, 0)
				});

				NeverLose.PlayAnimate(Frame,SlowyTween,{
					BackgroundTransparency = 1
				});
			end;
		end);

		SliderLib.SetRender(Signal:GetValue());
		SliderLib.Signal = Signal:Connect(SliderLib.SetRender);

		local Update = function(Input)
			local SizeScale = math.clamp((((Input.Position.X) - SlideMain.AbsolutePosition.X) / SlideMain.AbsoluteSize.X), 0, 1);
			local Main = ((Config.Max - Config.Min) * SizeScale) + Config.Min;
			local Value = NeverLose.Rounding(Main,Config.Rounding);
			local PositionX = UDim2.fromScale(SizeScale, 1);
			local Size = ((Value - Config.Min) / (Config.Max - Config.Min)) + 0.02;

			Config.Default = Value;

			TweenService:Create(SlideMoving , ManualTween ,{
				Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
			}):Play();

			LoadText()


			Config.Callback(Value)
		end;

		local IsHold = false;

		do
			SlideMain.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					IsHold = true
					Update(Input)
				end
			end))

			SlideMain.InputEnded:Connect(LPH_NO_VIRTUALIZE(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if UserInputService.TouchEnabled then
						if not NeverLose:IsMouseOverFrame(SlideMain) then
							IsHold = false
						end;
					else
						IsHold = false
					end;
				end
			end))

			UserInputService.InputChanged:Connect(LPH_NO_VIRTUALIZE(function(Input)
				if IsHold then
					if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)  then
						if UserInputService.TouchEnabled then
							if not NeverLose:IsMouseOverFrame(SlideMain) then
								IsHold = false
							else
								Update(Input)
							end;
						else
							Update(Input)
						end;
					end;
				end;
			end));
		end;

		function SliderLib:GetValue()
			return Config.Default;
		end;

		function SliderLib:SetValue(v)
			Config.Default = v;

			if Signal:GetValue() then
				NeverLose.PlayAnimate(SlideMoving,SlowyTween,{
					BackgroundTransparency = 0,
					Size = UDim2.new(SliderLib.GetSize(), 0, 1, 0)
				});
			end;

			LoadText()

			Config.Callback(Config.Default);
		end;

		if Config.Flag then
			NeverLose.Flags[Config.Flag] = SliderLib;
		end;

		return SliderLib;
	end;

	function handle:AddOption(GearIcon)
		local Option = Instance.new("Frame")
		local Icon = Instance.new("TextLabel")
		local UICorner = Instance.new("UICorner")

		Option.Name = NeverLose.RandomString();
		Option.Parent = Handler
		Option.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
		Option.BackgroundTransparency = 1.000
		Option.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Option.BorderSizePixel = 0
		Option.ClipsDescendants = true
		Option.Size = UDim2.new(0, 20, 0, 18)
		Option.ZIndex = ZINdex + 13
		Option.LayoutOrder = -(#Handler:GetChildren() + 5);

		Icon.Name = NeverLose.RandomString();
		Icon.Parent = Option
		Icon.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		Icon.Size = UDim2.new(1, 0, 1, 0)
		Icon.ZIndex = ZINdex + 14
		Icon.FontFace = NeverLose.BuiltInBold
		Icon.Text = (GearIcon == 1 and 'gear') or (GearIcon == 2 and 'chevron-large-right') or "three-dots-horizontal";
		Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
		Icon.TextSize = 16.000
		Icon.TextTransparency = 0.400
		Icon.TextWrapped = true

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Option

		local Window = NeverLose:CreateOptionWindow(Option , ZINdex + 13);
		Window.Trigger = Option;
		local reciveSignal;

		Window.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 0.400
				})
			else
				NeverLose.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 1
				})
			end;
		end);

		Window.SetRender(Signal:GetValue());
		Signal:Connect(Window.SetRender);

		local bthg = NeverLose:CreateInput(Option , LPH_NO_VIRTUALIZE(function()
			if reciveSignal then
				reciveSignal:Disconnect();
				reciveSignal = nil;	
			end;

			Window.Signal:SetValue(true);

			reciveSignal = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not NeverLose:IsMouseOverFrame(Window.Root) and not NeverLose:IsMouseOverFrame(Option) and not (NeverLose.UIRepairs and NeverLose.UIRepairs.ActivePicker) then
						if reciveSignal then
							reciveSignal:Disconnect();
							reciveSignal = nil;	
						end;

						Window.Signal:SetValue(false);
					end
				end
			end)
		end));

		NeverLose:AddSignal(bthg.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(Option , SlowyTween , {
				BackgroundTransparency = 0.5
			})

			NeverLose.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.25
			})
		end)));

		NeverLose:AddSignal(bthg.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(Option , SlowyTween , {
				BackgroundTransparency = 1.000
			})

			NeverLose.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.400
			})
		end)));

		return Window;
	end;

	function handle:AddColorPicker(Config)
		Config = NeverLose:ProcessParams(Config , {
			Default = Color3.fromRGB(255, 255, 255),
			Callback  = EmptyFunction,
		});

		if typeof(Config.Default) == 'string' then
			Config.Default = Color3.fromHex(Config.Default:gsub('#',''));
		end;

		local ColorPickerLib = {};
		local ColorPicker = Instance.new("Frame")
		ColorPickerLib.Root = ColorPicker;
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ImageLabel = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")

		ColorPicker.Name = NeverLose.RandomString();
		ColorPicker.Parent = Handler
		ColorPicker.BackgroundColor3 = Config.Default;
		ColorPicker.BackgroundTransparency = 0
		ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPicker.BorderSizePixel = 0
		ColorPicker.ClipsDescendants = true
		ColorPicker.Size = UDim2.new(0, 18, 0, 18)
		ColorPicker.ZIndex = ZINdex + 13

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = ColorPicker

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = ColorPicker

		ImageLabel.Parent = ColorPicker
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Size = UDim2.new(1, 0, 1, 0)
		ImageLabel.ZIndex = ZINdex + 11
		ImageLabel.Image = "rbxasset://textures/meshPartFallback.png"
		ImageLabel.ImageTransparency = 0.9
		ImageLabel.BackgroundTransparency = 1;
		ImageLabel.ScaleType = Enum.ScaleType.Crop

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = ImageLabel

		local BackendM = NeverLose:CreateColorPicker(ColorPicker);

		BackendM:SetValue(Config.Default)
		BackendM.Callback = function(color)
			ColorPicker.BackgroundColor3 = color;
			Config.Default = color;
			Config.Callback(Config.Default);
		end;

		local signal;
		NeverLose:CreateInput(ColorPicker , LPH_NO_VIRTUALIZE(function()
			if signal then
				signal:Disconnect();
				signal = nil;
			end;

			BackendM.SetRender(true);

			signal = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not NeverLose:IsMouseOverFrame(ColorPicker) and not NeverLose:IsMouseOverFrame(BackendM.Root) then
						if signal then
							signal:Disconnect();
							signal = nil;
						end;

						BackendM.SetRender(false);
					end;
				end;
			end)
		end));

		ColorPickerLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(ColorPicker , SlowyTween , {
					BackgroundTransparency = 0
				})

				NeverLose.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 0.650
				})

				NeverLose.PlayAnimate(ImageLabel , SlowyTween , {
					ImageTransparency = 0.9
				})
			else
				NeverLose.PlayAnimate(ColorPicker , SlowyTween , {
					BackgroundTransparency = 1
				})

				NeverLose.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 1
				})

				NeverLose.PlayAnimate(ImageLabel , SlowyTween , {
					ImageTransparency = 1
				})
			end;
		end);

		ColorPickerLib.SetRender(Signal:GetValue());
		Signal:Connect(ColorPickerLib.SetRender);

		function ColorPickerLib:GetValue()
			return Config.Default;
		end;

		function ColorPickerLib:SetValue(v)
			Config.Default = v;
			BackendM:SetValue(Config.Default)
		end;

		if Config.Flag then
			NeverLose.Flags[Config.Flag] = ColorPickerLib;
		end;

		return ColorPickerLib;
	end;

	function handle:AddKeybind(Config)
		Config = NeverLose:ProcessParams(Config,{
			Default = nil,
			Blacklist = {},
			Callback = EmptyFunction,
			Flag = nil
		});

		local KeybindLib = {};

		local Keybind = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local ValueLabel = Instance.new("TextLabel")

		Keybind.Name = NeverLose.RandomString();
		Keybind.Parent = Handler
		Keybind.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		Keybind.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Keybind.BorderSizePixel = 0
		Keybind.ClipsDescendants = true
		Keybind.Size = UDim2.new(0, 45, 0, 18)
		Keybind.ZIndex = ZINdex + 13

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Keybind

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = Keybind

		ValueLabel.Name = NeverLose.RandomString();
		ValueLabel.Parent = Keybind
		ValueLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.BackgroundTransparency = 1.000
		ValueLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ValueLabel.BorderSizePixel = 0
		ValueLabel.ClipsDescendants = true
		ValueLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		ValueLabel.Size = UDim2.new(1, 0, 1, 0)
		ValueLabel.ZIndex = ZINdex + 14
		ValueLabel.Font = Enum.Font.GothamMedium
		ValueLabel.Text = NeverLose:KeyCodeToStr(Config.Default or "None")
		ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		ValueLabel.TextSize = 10.000
		ValueLabel.TextTransparency = 0.500

		KeybindLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(Keybind,SlowyTween, {
					BackgroundTransparency = 0
				})

				NeverLose.PlayAnimate(UIStroke,SlowyTween, {
					Transparency = 0.650
				})

				NeverLose.PlayAnimate(ValueLabel,SlowyTween, {
					TextTransparency = 0.500
				})
			else
				NeverLose.PlayAnimate(Keybind,SlowyTween, {
					BackgroundTransparency = 1
				})

				NeverLose.PlayAnimate(UIStroke,SlowyTween, {
					Transparency = 1
				})

				NeverLose.PlayAnimate(ValueLabel,SlowyTween, {
					TextTransparency = 1
				})
			end;
		end);

		function KeybindLib:Update()
			local size = TextService:GetTextSize(ValueLabel.Text,ValueLabel.TextSize,ValueLabel.Font,Vector2.new(math.huge,math.huge));

			NeverLose.PlayAnimate(Keybind , SlowyTween , {
				Size = UDim2.new(0, size.X + 7, 0, 18)
			})
		end;

		local IsBlacklist = LPH_NO_VIRTUALIZE(function(v)
			return Config.Blacklist and (Config.Blacklist[v] or table.find(Config.Blacklist,v))
		end);

		KeybindLib:Update()

		KeybindLib.SetRender(Signal:GetValue());
		Signal:Connect(KeybindLib.SetRender);

		local IsBinding = false;
		NeverLose:CreateInput(Keybind , function()
			if IsBinding then
				return;
			end;

			IsBinding = true;

			ValueLabel.Text = "...";

			KeybindLib:Update();

			local Selected = nil;

			while not Selected do
				local Key = UserInputService.InputBegan:Wait();

				if Key.KeyCode ~= Enum.KeyCode.Unknown and not IsBlacklist(Key.KeyCode) and not IsBlacklist(Key.KeyCode.Name) then
					Selected = Key.KeyCode;
				else
					if Key.UserInputType == Enum.UserInputType.MouseButton1 and not IsBlacklist(Enum.UserInputType.MouseButton1) and not IsBlacklist("M1B") then
						Selected = "M1B";
					elseif Key.UserInputType == Enum.UserInputType.MouseButton2 and not IsBlacklist(Enum.UserInputType.MouseButton2) and not IsBlacklist("M2B") then
						Selected = "M2B";
					end;
				end;
			end;

			IsBinding = false;

			local KeyName = typeof(Selected) == "string" and Selected or Selected.Name;

			Config.Default = KeyName;

			ValueLabel.Text = NeverLose:KeyCodeToStr(KeyName);

			KeybindLib:Update();

			Config.Callback(KeyName)
		end)

		function KeybindLib:GetValue()
			return Config.Default;
		end;

		function KeybindLib:SetValue(v)
			Config.Default = v;
			ValueLabel.Text = NeverLose:KeyCodeToStr(v);
			KeybindLib:Update();
			Config.Callback(Config.Default);
		end;

		if Config.Flag then
			NeverLose.Flags[Config.Flag] = KeybindLib;
		end;

		return KeybindLib;
	end;

	function handle:AddTextInput(Config)
		Config = NeverLose:ProcessParams(Config , {
			Default = "",
			Placeholder = "Placeholder",
			Callback = print,
			Flag = nil,
			Size = 100,
			Numeric = false,
		});

		local TextBoxLib = {};

		local TextInput = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local TextBox = Instance.new("TextBox")

		TextInput.Name = NeverLose.RandomString();
		TextInput.Parent = Handler
		TextInput.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextInput.BorderSizePixel = 0
		TextInput.ClipsDescendants = true
		TextInput.Size = UDim2.new(0, Config.Size, 0, 18)
		TextInput.ZIndex = ZINdex + 13

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = TextInput

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = TextInput

		TextBox.Parent = TextInput
		TextBox.AnchorPoint = Vector2.new(0, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0, 5, 0.5, 0)
		TextBox.Size = UDim2.new(1, -5, 0, 17)
		TextBox.ZIndex = ZINdex + 14
		TextBox.ClearTextOnFocus = false
		TextBox.Font = Enum.Font.GothamMedium
		TextBox.PlaceholderText = Config.Placeholder
		TextBox.Text = tostring(Config.Default)
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextSize = 11.000
		TextBox.TextTransparency = 0.350
		TextBox.TextXAlignment = Enum.TextXAlignment.Left

		TextBoxLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(TextInput , SlowyTween ,{
					BackgroundTransparency = 0
				})	

				NeverLose.PlayAnimate(UIStroke , SlowyTween ,{
					Transparency = 0.650
				})	

				NeverLose.PlayAnimate(TextBox , SlowyTween ,{
					TextTransparency = 0.350
				})	
			else
				NeverLose.PlayAnimate(TextInput , SlowyTween ,{
					BackgroundTransparency = 1
				})	

				NeverLose.PlayAnimate(UIStroke , SlowyTween ,{
					Transparency = 1
				})	

				NeverLose.PlayAnimate(TextBox , SlowyTween ,{
					TextTransparency = 1
				})
			end;
		end);

		NeverLose:AddSignal(TextBox:GetPropertyChangedSignal('Text'):Connect(LPH_NO_VIRTUALIZE(function()
			local valout = NeverLose:ParseInput(TextBox.Text , Config.Numeric);

			if Config.Numeric then
				TextBox.Text = string.gsub(TextBox.Text , '[^0-9.]','')
			end;

			if valout then
				Config.Default = valout;
				Config.Callback(valout);
			end
		end)));

		TextBoxLib.SetRender(Signal:GetValue());
		Signal:Connect(TextBoxLib.SetRender);

		function TextBoxLib:GetValue()
			return Config.Default;
		end;

		function TextBoxLib:SetValue(v)
			Config.Default = v;
			TextBox.Text = tostring(v);
			Config.Callback(Config.Default);
		end;

		if Config.Flag then
			NeverLose.Flags[Config.Flag] = TextBoxLib;
		end;

		return TextBoxLib;
	end;

	function handle:AddDropdown(Config)
		Config = NeverLose:ProcessParams(Config , {
			Default = nil,
			Values = {},
			Multi = false,
			Callback = EmptyFunction,
			AutoUpdate = false,
			Flag = nil,
			Size = 100
		})

		Config.Default = NeverLose.ProcessDropdown(Config.Default);

		local Dropdown = Instance.new("Frame")
		local DropdownIcon = Instance.new("TextLabel")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local BasedLabel = Instance.new("TextLabel")

		Dropdown.Name = NeverLose.RandomString();
		Dropdown.Parent = Handler
		Dropdown.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		Dropdown.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Dropdown.BorderSizePixel = 0
		Dropdown.ClipsDescendants = true
		Dropdown.Size = UDim2.new(0, Config.Size, 0, 18)
		Dropdown.ZIndex = ZINdex + 13

		DropdownIcon.Name = NeverLose.RandomString();
		DropdownIcon.Parent = Dropdown
		DropdownIcon.AnchorPoint = Vector2.new(1, 0.5)
		DropdownIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DropdownIcon.BackgroundTransparency = 1.000
		DropdownIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DropdownIcon.BorderSizePixel = 0
		DropdownIcon.Position = UDim2.new(1, -2, 0.5, 0)
		DropdownIcon.Size = UDim2.new(0, 18, 0, 18)
		DropdownIcon.ZIndex = ZINdex + 14
		DropdownIcon.FontFace = NeverLose.BuiltInBold
		DropdownIcon.Text = "chevron-small-down"
		DropdownIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
		DropdownIcon.TextSize = 16.000
		DropdownIcon.TextTransparency = 0.250
		DropdownIcon.TextWrapped = true

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = Dropdown

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = Dropdown

		BasedLabel.Name = NeverLose.RandomString();
		BasedLabel.Parent = Dropdown
		BasedLabel.AnchorPoint = Vector2.new(0, 0.5)
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.ClipsDescendants = true
		BasedLabel.Position = UDim2.new(0, 5, 0.5, 0)
		BasedLabel.Size = UDim2.new(1, -25, 0, 15)
		BasedLabel.ZIndex = ZINdex + 14
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = NeverLose.ParseDropdown(Config.Default);
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 12.000
		BasedLabel.TextTransparency = 0.5
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		do
			local UIGradient = Instance.new("UIGradient")

			UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.00), NumberSequenceKeypoint.new(0.85, 0.23), NumberSequenceKeypoint.new(1.00, 1.00)}
			UIGradient.Parent = BasedLabel;
		end;

		NeverLose:AddSignal(Dropdown.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0.200
			})
		end)));

		NeverLose:AddSignal(Dropdown.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0.5
			})
		end)));

		local DropdownLib = {
			OpenSignal = NeverLose:CreateSignal(false),
			Signals = {},
			Refuse = {},
		};

		DropdownLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(Dropdown , SlowyTween , {
					BackgroundTransparency = 0
				});

				NeverLose.PlayAnimate(DropdownIcon , SlowyTween , {
					TextTransparency = 0.250
				});

				NeverLose.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 0.650
				});

				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0.5
				});
			else
				NeverLose.PlayAnimate(Dropdown , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(DropdownIcon , SlowyTween , {
					TextTransparency = 1
				});

				NeverLose.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 1
				});

				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				});
			end
		end);

		DropdownLib.SetRender(Signal:GetValue())
		Signal:Connect(DropdownLib.SetRender);
		DropdownLib.ExtentSize = 0;

		do
			local DropdownHandler = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local UIStroke = Instance.new("UIStroke")
			local DropdownScrollFrame = Instance.new("ScrollingFrame")
			local UIListLayout = Instance.new("UIListLayout")
			local Shadow = NeverLose:CreateShadow(DropdownHandler);

			DropdownHandler.Name = NeverLose.RandomString();
			DropdownHandler.Parent = NeverLose.ScreenGui;
			DropdownHandler.AnchorPoint = Vector2.new(0.5, 0)
			DropdownHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
			DropdownHandler.BackgroundTransparency = 0.5
			DropdownHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownHandler.BorderSizePixel = 0
			DropdownHandler.ClipsDescendants = true
			DropdownHandler.Position = UDim2.new(255,255,255,255)
			DropdownHandler.Size = UDim2.new(0, 125, 0, 50)
			DropdownHandler.ZIndex = ZINdex + 125
			DropdownLib.BlockRoot = DropdownHandler;

			NeverLose:AddSignal(DropdownHandler:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
				if DropdownHandler.BackgroundTransparency > 0.9 then
					DropdownHandler.Visible = false;
					DropdownHandler.Parent = nil;
				else
					DropdownHandler.Visible = true;

					if NeverLose.Global3DRenderMode then
						DropdownHandler.Parent = NeverLose.GlobalSurfaceGui;
					else
						DropdownHandler.Parent = NeverLose.ScreenGui;
					end;
				end;
			end));

			UICorner.CornerRadius = UDim.new(0, 10)
			UICorner.Parent = DropdownHandler

			UIStroke.Transparency = 0.650
			UIStroke.Color = Color3.fromRGB(45, 48, 58)
			UIStroke.Parent = DropdownHandler

			DropdownScrollFrame.Name = NeverLose.RandomString();
			DropdownScrollFrame.Parent = DropdownHandler
			DropdownScrollFrame.Active = true
			DropdownScrollFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			DropdownScrollFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			DropdownScrollFrame.BackgroundTransparency = 1.000
			DropdownScrollFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			DropdownScrollFrame.BorderSizePixel = 0
			DropdownScrollFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
			DropdownScrollFrame.Size = UDim2.new(1, -5, 1, -5)
			DropdownScrollFrame.ZIndex = ZINdex + 127
			DropdownScrollFrame.ScrollBarThickness = 0

			DropdownLib.RootItem = DropdownScrollFrame;

			UIListLayout.Parent = DropdownScrollFrame
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
				DropdownScrollFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y)
				NeverLose.PlayAnimate(DropdownHandler , SlowyTween , {
					Size = UDim2.new(0, (Dropdown.AbsoluteSize.X + 5) + DropdownLib.ExtentSize, 0, math.min(UIListLayout.AbsoluteContentSize.Y + 5, 250));
				})
			end)));

			local SetPosition = LPH_NO_VIRTUALIZE(function()
				if NeverLose:MoreThanHalfY(Dropdown.AbsolutePosition.Y + 85) then
					DropdownHandler.AnchorPoint = Vector2.new(0.5,1)
				else
					DropdownHandler.AnchorPoint = Vector2.new(0.5,0)
				end;

				DropdownHandler.Position = UDim2.fromOffset(Dropdown.AbsolutePosition.X + (DropdownHandler.AbsoluteSize.X / 2), Dropdown.AbsolutePosition.Y + 85);

			end);

			DropdownLib.SetFrameRender = LPH_NO_VIRTUALIZE(function(value)
				DropdownLib.OpenSignal:SetValue(value);

				if value then
					Shadow:Render(true);

					DropdownHandler.Size = UDim2.new(0, (Dropdown.AbsoluteSize.X + 5) + DropdownLib.ExtentSize, 0, math.min(UIListLayout.AbsoluteContentSize.Y + 5, 250));

					SetPosition();

					NeverLose.PlayAnimate(DropdownHandler , SlowyTween , {
						BackgroundTransparency = 0.035
					})

					if Config.AutoUpdate then
						DropdownLib:Generate();
					end;
				else

					NeverLose.PlayAnimate(DropdownHandler , SlowyTween , {
						BackgroundTransparency = 1
					})

					Shadow:Render(false);
				end;
			end);

			DropdownLib.SetFrameRender(false);
		end;

		DropdownLib.Root = Dropdown;
		local SecureSignal;
		DropdownLib.DisconnectInput=function()if SecureSignal then SecureSignal:Disconnect();SecureSignal=nil end end;
		NeverLose:CreateInput(Dropdown , LPH_NO_VIRTUALIZE(function()
			if SecureSignal then
				SecureSignal:Disconnect();
				SecureSignal = nil;
			end;

			DropdownLib.SetFrameRender(true);
			NeverLose.IsMosueOverOtherFrame = true;

			SecureSignal = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not NeverLose:IsMouseOverFrame(DropdownLib.BlockRoot) and not NeverLose:IsMouseOverFrame(Dropdown) then
						if SecureSignal then
							SecureSignal:Disconnect();
							SecureSignal = nil;
						end;

						NeverLose.IsMosueOverOtherFrame = false;
						DropdownLib.SetFrameRender(false);
					end;
				end
			end)
		end))

		DropdownLib.IsMatch = LPH_NO_VIRTUALIZE(function(v1)
			if typeof(Config.Default) =='table' then
				if Config.Default[v1] or table.find(Config.Default , v1) then
					return true;
				end
			end

			if Config.Default == v1 then
				return true;
			end;
		end);

		function DropdownLib:Generate()
			for i,v in next , DropdownLib.RootItem:GetChildren() do
				if v:IsA('Frame') then
					v:Destroy();
				end;
			end;

			for i,v in next , DropdownLib.Signals do
				v:Disconnect();
			end;

			table.clear(DropdownLib.Signals);
			table.clear(DropdownLib.Refuse);

			local Lastone;
			for i,Value in next , Config.Values do
				local ItemFrame = Instance.new("Frame")
				local ItemLabel = Instance.new("TextLabel")
				local UICorner = Instance.new("UICorner")

				ItemFrame.Name = NeverLose.RandomString();
				ItemFrame.Parent = DropdownLib.RootItem
				ItemFrame.BackgroundColor3 = Color3.fromRGB(29, 31, 38)
				ItemFrame.BackgroundTransparency = 1.000
				ItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ItemFrame.BorderSizePixel = 0
				ItemFrame.Size = UDim2.new(1, 0, 0, 25)
				ItemFrame.ZIndex = ZINdex + 1258

				ItemLabel.Name = NeverLose.RandomString();
				ItemLabel.Parent = ItemFrame
				ItemLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ItemLabel.BackgroundTransparency = 1.000
				ItemLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ItemLabel.BorderSizePixel = 0
				ItemLabel.Position = UDim2.new(0, 15, 0, 4)
				ItemLabel.Size = UDim2.new(0,1, 0, 15)
				ItemLabel.ZIndex = ZINdex + 1258
				ItemLabel.Font = Enum.Font.GothamMedium
				ItemLabel.Text = tostring(Value);
				ItemLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				ItemLabel.TextSize = 13.000
				ItemLabel.TextTransparency = 0.200
				ItemLabel.TextXAlignment = Enum.TextXAlignment.Left

				UICorner.CornerRadius = UDim.new(0, 10)
				UICorner.Parent = ItemFrame
				local sizetext = TextService:GetTextSize(ItemLabel.Text , ItemLabel.TextSize,ItemLabel.Font,Vector2.new(math.huge,math.huge));

				DropdownLib.ExtentSize = math.max(DropdownLib.ExtentSize , sizetext.X);

				local MIcon , MarkItem = nil , nil;

				if Config.Multi then
					local Icon = Instance.new("TextLabel")

					Icon.Parent = ItemFrame;
					Icon.AnchorPoint = Vector2.new(0, 0.5)
					Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					Icon.BackgroundTransparency = 1.000
					Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
					Icon.BorderSizePixel = 0
					Icon.Position = UDim2.new(0, 5, 0.5, 0)
					Icon.Size = UDim2.new(0, 20, 0, 20)
					Icon.ZIndex = ZINdex + 1259
					Icon.FontFace = NeverLose.BuiltInBold;
					Icon.Text = "check"
					Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
					Icon.TextSize = 18.000
					Icon.TextTransparency = 1
					Icon.TextWrapped = true;

					local VisiblewOfMult = LPH_NO_VIRTUALIZE(function()
						if DropdownLib.IsMatch(Value) then
							NeverLose.PlayAnimate(ItemLabel , VSlowTween , {
								TextTransparency = 0.200,
								Position = UDim2.new(0, 30, 0, 4)
							})

							NeverLose.PlayAnimate(Icon , vs , {
								TextTransparency = 0.250
							})

							Lastone = ItemLabel;
						else

							NeverLose.PlayAnimate(Icon , SlowyTween , {
								TextTransparency = 1
							})

							NeverLose.PlayAnimate(ItemLabel , VSlowTween , {
								TextTransparency = 0.5,
								Position = UDim2.new(0, 15, 0, 4)
							})
						end;
					end);

					MIcon = Icon;
					MarkItem = VisiblewOfMult;
				else
					local DefaultVisible = LPH_NO_VIRTUALIZE(function()
						if DropdownLib.IsMatch(Value) then
							NeverLose.PlayAnimate(ItemLabel , SlowyTween , {
								TextTransparency = 0.200
							})

							Lastone = ItemLabel;
						else
							NeverLose.PlayAnimate(ItemLabel , SlowyTween , {
								TextTransparency = 0.5
							})
						end;
					end);

					MarkItem = DefaultVisible;
				end;

				MarkItem();

				table.insert(DropdownLib.Refuse , MarkItem)

				table.insert(DropdownLib.Signals,ItemFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(ItemFrame , SlowyTween , {
						BackgroundTransparency = 0.1
					})
				end)));

				table.insert(DropdownLib.Signals,ItemFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(ItemFrame , SlowyTween , {
						BackgroundTransparency = 1
					})
				end)));

				table.insert(DropdownLib.Signals , DropdownLib.OpenSignal:Connect(LPH_NO_VIRTUALIZE(function(val)
					if val then
						MarkItem();
					else
						NeverLose.PlayAnimate(ItemLabel , SlowyTween , {
							TextTransparency = 1
						})

						if MIcon then
							NeverLose.PlayAnimate(MIcon , SlowyTween , {
								TextTransparency = 1
							})
						end;
					end;
				end)));

				if Config.Multi then
					local _,bth_signal = NeverLose:CreateInput(ItemFrame , LPH_NO_VIRTUALIZE(function()
						Config.Default[Value] = not Config.Default[Value];

						MarkItem();

						BasedLabel.Text = NeverLose.ParseDropdown(Config.Default);

						Config.Callback(Config.Default);
					end));

					table.insert(DropdownLib.Signals , bth_signal);
				else
					local _,bth_signal = NeverLose:CreateInput(ItemFrame , LPH_NO_VIRTUALIZE(function()
						Config.Default = Value;

						for i,v in next , DropdownLib.Refuse do
							task.spawn(v);
						end;

						BasedLabel.Text = NeverLose.ParseDropdown(Config.Default);

						Config.Callback(Config.Default);
					end));

					table.insert(DropdownLib.Signals , bth_signal);
				end;
			end;
		end;

		DropdownLib:Generate();

		function DropdownLib:GetValue()
			return Config.Default;
		end;

		function DropdownLib:SetValue(v)
			Config.Default = v;

			BasedLabel.Text = NeverLose.ParseDropdown(Config.Default);

			for i,v in next , DropdownLib.Refuse do
				task.spawn(v);
			end;

			Config.Callback(Config.Default);
		end;

		function DropdownLib:SetValues(a)
			Config.Values = a;

			if not Config.AutoUpdate then
				DropdownLib:Generate();
			end;
		end;

		if Config.Flag then
			NeverLose.Flags[Config.Flag] = DropdownLib;
		end;

		return DropdownLib;
	end;

	return handle;
end;

NeverLose.ProcessDropdown = LPH_NO_VIRTUALIZE(function(value)
	if typeof(value) == 'table' then
		local data = {};

		for i,v in next , value do
			if typeof(v) == 'boolean' and typeof(i) ~= 'number' then
				data[i] = v;
			else
				data[v] = true;
			end;
		end;

		return data;
	else
		return value;
	end;
end);

NeverLose.ParseDropdown = LPH_NO_VIRTUALIZE(function(value)
	if not value then return 'Select'; end;

	local Out;

	if typeof(value) == 'table' then
		if #value > 0 then
			local x = {};

			for i,v in next , value do
				table.insert(x , tostring(v))
			end;

			Out = table.concat(x,' , ');

			table.clear(x);
		else
			local x = {};

			for i,v in next , value do
				if v == true then
					table.insert(x , tostring(i));
				end			
			end;

			Out = table.concat(x,' , ');

			table.clear(x)

			if not Out:byte() then
				Out = 'Select';
			end
		end;
	else
		Out = tostring(value or 'Select');
	end;

	return Out;
end);

function NeverLose:ParseInput(Value , Numeric)
	if not Value then
		return (Numeric and nil) or "";	
	end;

	if Numeric then
		local out = string.gsub(tostring(Value), '[^0-9.%-]', '')

		if tonumber(out) then
			return tonumber(out);
		end;

		return nil;
	end;

	return Value;
end;

function NeverLose:CreateToolTips(Container: Frame , Name: string , Content: string)
	local Tooltips = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local TooltipName = Instance.new("TextLabel")
	local TooltipContent = Instance.new("TextLabel")
	local Shadow = NeverLose:CreateShadow(Tooltips);

	Tooltips.Name = NeverLose.RandomString();
	Tooltips.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
	Tooltips.BackgroundTransparency = 0.075
	Tooltips.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Tooltips.BorderSizePixel = 0
	Tooltips.ClipsDescendants = true
	Tooltips.Position = UDim2.new(255,255,255,255)
	Tooltips.Size = UDim2.new(0,0,0,0)
	Tooltips.ZIndex = 130

	UICorner.CornerRadius = UDim.new(0, 10)
	UICorner.Parent = Tooltips

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = Tooltips

	TooltipName.Name = NeverLose.RandomString();
	TooltipName.Parent = Tooltips
	TooltipName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TooltipName.BackgroundTransparency = 1.000
	TooltipName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TooltipName.BorderSizePixel = 0
	TooltipName.Position = UDim2.new(0, 15, 0, 5)
	TooltipName.Size = UDim2.new(0, 1, 0, 20)
	TooltipName.ZIndex = 132
	TooltipName.Font = Enum.Font.GothamBold
	TooltipName.Text = Name
	TooltipName.TextColor3 = Color3.fromRGB(255, 255, 255)
	TooltipName.TextSize = 15.000
	TooltipName.TextXAlignment = Enum.TextXAlignment.Left

	TooltipContent.Name = NeverLose.RandomString();
	TooltipContent.Parent = Tooltips
	TooltipContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TooltipContent.BackgroundTransparency = 1.000
	TooltipContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TooltipContent.BorderSizePixel = 0
	TooltipContent.Position = UDim2.new(0, 15, 0, 30)
	TooltipContent.Size = UDim2.new(0, 1, 0, 15)
	TooltipContent.ZIndex = 132
	TooltipContent.Font = Enum.Font.GothamBold
	TooltipContent.Text = Content
	TooltipContent.TextColor3 = Color3.fromRGB(255, 255, 255)
	TooltipContent.TextSize = 12.000
	TooltipContent.TextTransparency = 0.650
	TooltipContent.TextXAlignment = Enum.TextXAlignment.Left
	TooltipContent.TextYAlignment = Enum.TextYAlignment.Top

	local ToolTip = {};

	ToolTip.Update = LPH_NO_VIRTUALIZE(function()
		local SizeName = TextService:GetTextSize(TooltipName.Text , TooltipName.TextSize , TooltipName.Font , Vector2.new(math.huge,math.huge));
		local SizeContent = TextService:GetTextSize(TooltipContent.Text , TooltipContent.TextSize , TooltipContent.Font , Vector2.new(math.huge,math.huge));

		local MaxX = math.max(SizeName.X , SizeContent.X) + 65;
		local MaxY = SizeName.Y + SizeContent.Y + 30;

		NeverLose.PlayAnimate(Tooltips,SlowyTween , {
			Size = UDim2.new(0,MaxX,0,MaxY)
		})
	end)

	NeverLose:AddSignal(Tooltips:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
		if Tooltips.BackgroundTransparency > 0.9 then
			Tooltips.Visible = false;
			Tooltips.Parent = nil;
		else
			Tooltips.Visible = true;

			if NeverLose.Global3DRenderMode then
				Tooltips.Parent = NeverLose.GlobalSurfaceGui;
			else
				Tooltips.Parent = NeverLose.ScreenGui;
			end;
		end
	end)));

	ToolTip.SetRender = LPH_NO_VIRTUALIZE(function(value)
		if value then
			Tooltips.Position = UDim2.fromOffset(Container.AbsolutePosition.X + Container.AbsoluteSize.X , Container.AbsolutePosition.Y + (Container.AbsoluteSize.Y + 25));

			NeverLose.PlayAnimate(Tooltips , SlowyTween , {
				BackgroundTransparency = 0.075
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 0.650
			})

			NeverLose.PlayAnimate(TooltipName , SlowyTween , {
				TextTransparency = 0
			})

			NeverLose.PlayAnimate(TooltipContent , SlowyTween , {
				TextTransparency = 0.650
			})

			ToolTip.Update();
			Shadow:Render(true);
		else
			NeverLose.PlayAnimate(Tooltips , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(TooltipName , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(TooltipContent , SlowyTween , {
				TextTransparency = 1
			})

			Shadow:Render(false);
		end;
	end);

	ToolTip.SetRender(false);
	ToolTip.Update();

	local DelayThread;
	NeverLose:AddSignal(Container.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
		if DelayThread then
			task.cancel(DelayThread);
			DelayThread = nil;
		end;

		DelayThread = task.delay(1,ToolTip.SetRender,true);
	end)));

	NeverLose:AddSignal(Container.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
		if DelayThread then
			task.cancel(DelayThread);
			DelayThread = nil;
		end;

		ToolTip.SetRender(false);
		ToolTip.Update();
	end)))

	return ToolTip;
end;

function NeverLose:RegisiterItem(Frame: Frame , Signel)
	local idx = {};
	local LayerIndex = Frame.ZIndex;

	function idx:AddLabel(Name: string,Warp: boolean)
		local BasedFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local BasedHandler = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local UICorner = Instance.new("UICorner")

		BasedFrame.Name = NeverLose.RandomString();
		BasedFrame.Parent = Frame
		BasedFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		BasedFrame.BackgroundTransparency = 1.000
		BasedFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedFrame.BorderSizePixel = 0
		BasedFrame.Size = UDim2.new(1, 0, 0, 30)
		BasedFrame.ZIndex = LayerIndex + 8

		NeverLose:AddQuery(BasedFrame , Name);

		BasedLabel.Name = NeverLose.RandomString();
		BasedLabel.Parent = BasedFrame
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.Position = UDim2.new(0, 11, 0, 6)
		BasedLabel.Size = UDim2.new(0,1, 0, 15)
		BasedLabel.ZIndex = LayerIndex + 9
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = Name
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 13.000
		BasedLabel.TextTransparency = 0.35
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = NeverLose.RandomString();
		LineFrame.Parent = BasedFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = LayerIndex + 11

		BasedHandler.Name = NeverLose.RandomString();
		BasedHandler.Parent = BasedFrame
		BasedHandler.AnchorPoint = Vector2.new(1, 0)
		BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedHandler.BackgroundTransparency = 1.000
		BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedHandler.BorderSizePixel = 0
		BasedHandler.Position = UDim2.new(1, -11, 0, 2)
		BasedHandler.Size = UDim2.new(1, -20, 0, 25)
		BasedHandler.ZIndex = LayerIndex + 12

		UIListLayout.Parent = BasedHandler
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 5)

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = BasedFrame

		local UpdateWarp = LPH_NO_VIRTUALIZE(function()
			local size = TextService:GetTextSize(BasedLabel.Text , BasedLabel.TextSize , BasedLabel.Font , Vector2.new(math.huge,math.huge));
			NeverLose.PlayAnimate(BasedFrame , SlowyTween , {
				Size = UDim2.new(1, 0, 0, size.Y + 13);
			})

			BasedLabel.Size = UDim2.new(1, -35, 1, 0)
			BasedLabel.TextYAlignment = Enum.TextYAlignment.Top;
		end);

		if Warp then
			UpdateWarp();
		end;

		local handle = NeverLose:RegisiterHandler(BasedHandler , Signel);

		handle.Root = BasedFrame;

		handle.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(BasedFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0.35
				})

				NeverLose.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 0.650
				})
			else
				NeverLose.PlayAnimate(BasedFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				})

				NeverLose.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				})
			end;
		end);

		function handle:SetVisible(val)
			BasedFrame.Visible = val;
		end;

		NeverLose:AddSignal(BasedFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(BasedFrame , SlowyTween , {
				BackgroundTransparency = 0.35
			});

			NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0.25
			})

		end)))

		NeverLose:AddSignal(BasedFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(BasedFrame , SlowyTween , {
				BackgroundTransparency = 1
			});

			NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
				TextTransparency = 0.35
			})
		end)))

		function handle:SetText(t)
			local oldtxt = BasedLabel.Text;

			BasedLabel.Text = t;

			if Warp and oldtxt ~= t then
				UpdateWarp();
			end;
		end;

		function handle:ToolTip(Content: string)
			handle.ToolTip = NeverLose:CreateToolTips(BasedFrame , Name , Content);

			return handle;
		end;

		handle.SetRender(Signel:GetValue());
		Signel:Connect(handle.SetRender);

		return handle;
	end;

	function idx:AddButton(Config)
		Config = NeverLose:ProcessParams(Config , {
			Icon = 'chevron-large-left',
			Name = "Button",
			Callback = EmptyFunction,
			ToolTip = nil,
		});

		local Button = {};
		local ButtonFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Icon = Instance.new("TextLabel")

		NeverLose:AddQuery(ButtonFrame , Config.Name);

		ButtonFrame.Name = NeverLose.RandomString();
		ButtonFrame.Parent = Frame
		ButtonFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		ButtonFrame.BackgroundTransparency = 1.000
		ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonFrame.BorderSizePixel = 0
		ButtonFrame.Size = UDim2.new(1, 0, 0, 30)
		ButtonFrame.ZIndex = LayerIndex + 8

		BasedLabel.Name = NeverLose.RandomString();
		BasedLabel.Parent = ButtonFrame
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.Position = UDim2.new(0, 35, 0, 6)
		BasedLabel.Size = UDim2.new(0,1, 0, 15)
		BasedLabel.ZIndex = LayerIndex + 9
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = Config.Name;
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 13.000
		BasedLabel.TextTransparency = 0.200
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = NeverLose.RandomString();
		LineFrame.Parent = ButtonFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = LayerIndex + 11

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = ButtonFrame

		Icon.Name = NeverLose.RandomString();
		Icon.Parent = ButtonFrame
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 11, 0, 5)
		Icon.Size = UDim2.new(0, 18, 0, 18)
		Icon.ZIndex = LayerIndex + 9
		Icon.FontFace = NeverLose.BuiltInBold
		Icon.Text = Config.Icon
		Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
		Icon.TextSize = 16.000
		Icon.TextTransparency = 0.250
		Icon.TextWrapped = true

		function Button:SetText(t)
			BasedLabel.Text = t;
		end;

		function Button:SetIcon(t)
			Icon.Text = t
		end;

		local bth = NeverLose:CreateInput(ButtonFrame , LPH_NO_VIRTUALIZE(function()
			Config.Callback();
		end));

		NeverLose:AddSignal(bth.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(ButtonFrame , SlowyTween , {
				BackgroundTransparency = 0.35
			});
		end)))

		NeverLose:AddSignal(bth.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(ButtonFrame , SlowyTween , {
				BackgroundTransparency = 1
			});
		end)))

		Button.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(ButtonFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0.200
				});

				NeverLose.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 0.650
				});

				NeverLose.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 0.250
				});
			else
				NeverLose.PlayAnimate(ButtonFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				});

				NeverLose.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 1
				});
			end;
		end);

		if Config.ToolTip then
			Button.ToolTip = NeverLose:CreateToolTips(ButtonFrame , Config.Name , Config.ToolTip);
		end;

		Button.SetRender(Signel:GetValue())
		Signel:Connect(Button.SetRender);

		return Button;
	end;

	function idx:AddUserFrame(Name : string , Profile: string , Expires : string)
		local UserFrame = Instance.new("Frame")
		local UserLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local LogoImage = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local UserStatusLabel = Instance.new("TextLabel")

		UserFrame.Name = NeverLose.RandomString();
		UserFrame.Parent = Frame
		UserFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		UserFrame.BackgroundTransparency = 1.000
		UserFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		UserFrame.BorderSizePixel = 0
		UserFrame.Size = UDim2.new(1, 0, 0, 60)
		UserFrame.ZIndex = LayerIndex + 8

		UserLabel.Name = NeverLose.RandomString();
		UserLabel.Parent = UserFrame
		UserLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		UserLabel.BackgroundTransparency = 1.000
		UserLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		UserLabel.BorderSizePixel = 0
		UserLabel.Position = UDim2.new(0, 65, 0, 10)
		UserLabel.Size = UDim2.new(1, -35, 0, 15)
		UserLabel.ZIndex = LayerIndex + 9
		UserLabel.Font = Enum.Font.GothamMedium
		UserLabel.Text = Name or 'User'
		UserLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		UserLabel.TextSize = 13.000
		UserLabel.TextTransparency = 0.200
		UserLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = NeverLose.RandomString();
		LineFrame.Parent = UserFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = LayerIndex + 11

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = UserFrame

		LogoImage.Name = NeverLose.RandomString();
		LogoImage.Parent = UserFrame
		LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LogoImage.BackgroundTransparency = 1.000
		LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogoImage.BorderSizePixel = 0
		LogoImage.Position = UDim2.new(0, 10, 0, 5)
		LogoImage.Size = UDim2.new(0, 45, 0, 45)
		LogoImage.ZIndex = LayerIndex + 9
		LogoImage.Image = Profile or "rbxasset://textures/ui/clb_robux_20@3x.png";

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = LogoImage

		UserStatusLabel.Name = NeverLose.RandomString();
		UserStatusLabel.Parent = UserFrame
		UserStatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		UserStatusLabel.BackgroundTransparency = 1.000
		UserStatusLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		UserStatusLabel.BorderSizePixel = 0
		UserStatusLabel.Position = UDim2.new(0, 65, 0, 25)
		UserStatusLabel.Size = UDim2.new(1, -35, 0, 15)
		UserStatusLabel.ZIndex = LayerIndex + 9
		UserStatusLabel.Font = Enum.Font.GothamMedium
		UserStatusLabel.Text = Expires or 'Never'
		UserStatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		UserStatusLabel.TextSize = 13.000
		UserStatusLabel.TextTransparency = 0.200
		UserStatusLabel.TextXAlignment = Enum.TextXAlignment.Left

		local UserFrameItem = {};

		UserFrameItem.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				NeverLose.PlayAnimate(UserLabel,SlowyTween,{
					TextTransparency = 0.200
				})

				NeverLose.PlayAnimate(LineFrame,SlowyTween,{
					BackgroundTransparency = 0.650
				})

				NeverLose.PlayAnimate(LogoImage,SlowyTween,{
					ImageTransparency = 0
				})

				NeverLose.PlayAnimate(UserStatusLabel,SlowyTween,{
					TextTransparency = 0.200
				})
			else
				NeverLose.PlayAnimate(UserLabel,SlowyTween,{
					TextTransparency = 1
				})

				NeverLose.PlayAnimate(LineFrame,SlowyTween,{
					BackgroundTransparency = 1
				})

				NeverLose.PlayAnimate(LogoImage,SlowyTween,{
					ImageTransparency = 1
				})

				NeverLose.PlayAnimate(UserStatusLabel,SlowyTween,{
					TextTransparency = 1
				})
			end;
		end);

		UserFrameItem.SetRender(Signel:GetValue())
		Signel:Connect(UserFrameItem.SetRender);

		function UserFrameItem:SetUsername(name)
			UserLabel.Text = name or 'User'
		end;

		function UserFrameItem:SetProfile(Profile)
			LogoImage.Image = Profile or "rbxasset://textures/ui/clb_robux_20@3x.png";
		end;

		function UserFrameItem:SetExpires(Exp)
			UserStatusLabel.Text = Exp or 'Never';
		end;

		return UserFrameItem;
	end;

	return idx;
end;

function NeverLose:CreateWindow(Config)
	Config = NeverLose:ProcessParams(Config , {
		Logo = NeverLose.GlobalLogo,
		Name = "Neverlose",
		Content = "Counter-Strike 2",
		Size = UDim2.new(0, 640, 0, 480),
		ConfigFolder = "NeverLoseConfigs",
		Enable3DRenderer = false,
		Keybind = "Insert"
	});

	local Window = {
		Logo = Config.Logo,
		Name = Config.Name,
		Content = Config.Content,
		Size = Config.Size,
		ConfigFolder = Config.ConfigFolder,
		Signal = NeverLose:CreateSignal(true),
		Tabs = {},
		CurrentTab = 1,
		Keybind = Config.Keybind,
		Enable3DRenderer = Config.Enable3DRenderer
	};

	NeverLose.GlobalLogo = Window.Logo;

	local Logging = NeverLose:CreateLogger();
	if not isfolder(Window.ConfigFolder) then
		makefolder(Window.ConfigFolder);
	end;

	local WindowFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local LeftMenuFrame = Instance.new("Frame")
	local HeadFrame = Instance.new("Frame")
	local LogoImage = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local WindowName = Instance.new("TextLabel")
	local WindowContent = Instance.new("TextLabel")
	local LineFrame = Instance.new("Frame")
	local LeftScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local BottomFrame = Instance.new("Frame")
	local AccountProfile = Instance.new("ImageLabel")
	local UICorner_3 = Instance.new("UICorner")
	local AccountName = Instance.new("TextLabel")
	local ExpireLabel = Instance.new("TextLabel")
	local LineFrame_2 = Instance.new("Frame")
	local UserSettingButton = Instance.new("TextLabel")
	local RightMenuFrame = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local UICorner_4 = Instance.new("UICorner")
	local RightHeader = Instance.new("Frame")
	local LineFrame_3 = Instance.new("Frame")
	local ConfigFrame = Instance.new("Frame")
	local UIStroke_2 = Instance.new("UIStroke")
	local UICorner_5 = Instance.new("UICorner")
	local ConfigIcon = Instance.new("TextLabel")
	local LineFrame_4 = Instance.new("Frame")
	local ConfigName = Instance.new("TextLabel")
	local ConfigBthIcon = Instance.new("TextLabel")
	local SearchFrame = Instance.new("Frame")
	local SearchIcon = Instance.new("TextLabel")
	local SearchBox = Instance.new("TextBox")
	local TabContainer = Instance.new("Frame")

	WindowFrame.Name = NeverLose.RandomString();
	WindowFrame.Parent = NeverLose.ScreenGui;
	WindowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	WindowFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
	WindowFrame.BackgroundTransparency = 0.055
	WindowFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowFrame.BorderSizePixel = 0
	WindowFrame.ClipsDescendants = true
	WindowFrame.Position = UDim2.new(255, 0, 255, 0)
	WindowFrame.Size = Window.Size
	WindowFrame.Active = true;

	if not NeverLose.EnabledBlur then
		WindowFrame.BackgroundTransparency = 0.0255
	end;

	local renderParentWindow = LPH_NO_VIRTUALIZE(function()
		if Window.__3DRender then
			if WindowFrame.BackgroundTransparency > 0.9 then
				WindowFrame.Visible = false;
				WindowFrame.Parent = nil
			else
				WindowFrame.Visible = true;

				NeverLose.PlayAnimate(WindowFrame,VSlowTween , {
					Position = UDim2.fromScale(0.5,0.5);
				});

				WindowFrame.Parent = Window.SurfaceGui;
			end;
		else
			if WindowFrame.BackgroundTransparency > 0.9 then
				WindowFrame.Visible = false;
				WindowFrame.Parent = nil
			else
				WindowFrame.Visible = true;
				WindowFrame.Parent = NeverLose.ScreenGui


			end;
		end;
	end);

	NeverLose:AddSignal(WindowFrame:GetPropertyChangedSignal('BackgroundTransparency'):Connect(renderParentWindow))

	Window.SetRender = LPH_NO_VIRTUALIZE(function(self , value)
		if value then
			NeverLose.PlayAnimate(WindowFrame , SlowyTween , {
				BackgroundTransparency = (NeverLose.EnabledBlur and 0.055) or 0.0255,
				Size = Window.Size
			})

			NeverLose.PlayAnimate(LogoImage , SlowyTween , {
				ImageTransparency = 0
			})

			NeverLose.PlayAnimate(WindowName , SlowyTween , {
				TextTransparency = 0
			})

			NeverLose.PlayAnimate(WindowContent , SlowyTween , {
				TextTransparency = 0.650
			})

			NeverLose.PlayAnimate(LineFrame , SlowyTween , {
				BackgroundTransparency = 0.650
			})

			NeverLose.PlayAnimate(AccountProfile , SlowyTween , {
				ImageTransparency = 0
			})

			NeverLose.PlayAnimate(AccountName , SlowyTween , {
				TextTransparency = 0
			})

			NeverLose.PlayAnimate(ExpireLabel , SlowyTween , {
				TextTransparency = 0.650
			})

			NeverLose.PlayAnimate(LineFrame_2 , SlowyTween , {
				BackgroundTransparency = 0.650
			})

			NeverLose.PlayAnimate(UserSettingButton , SlowyTween , {
				TextTransparency = 0.5
			})

			NeverLose.PlayAnimate(RightMenuFrame , SlowyTween , {
				BackgroundTransparency = 0.600
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 0.650
			})

			NeverLose.PlayAnimate(LineFrame_3 , SlowyTween , {
				BackgroundTransparency = 0.650
			})

			NeverLose.PlayAnimate(ConfigFrame , SlowyTween , {
				BackgroundTransparency = 0.750
			})

			NeverLose.PlayAnimate(UIStroke_2 , SlowyTween , {
				Transparency = 0.650
			})

			NeverLose.PlayAnimate(ConfigIcon , SlowyTween , {
				TextTransparency = 0.250
			})

			NeverLose.PlayAnimate(LineFrame_4 , SlowyTween , {
				BackgroundTransparency = 0.650
			})

			NeverLose.PlayAnimate(ConfigName , SlowyTween , {
				TextTransparency = 0.350
			})

			NeverLose.PlayAnimate(ConfigBthIcon , SlowyTween , {
				TextTransparency = 0.250
			})

			NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
				TextTransparency = 0.250
			})

			NeverLose.PlayAnimate(SearchBox , SlowyTween , {
				TextTransparency = 0.350
			})

			Window.Shadow:Render(true);
		else

			NeverLose.PlayAnimate(WindowFrame , SlowyTween , {
				BackgroundTransparency = 1,
				Size = Window.Size + UDim2.fromOffset(-15,-15)
			})

			NeverLose.PlayAnimate(LogoImage , SlowyTween , {
				ImageTransparency = 1
			})

			NeverLose.PlayAnimate(WindowName , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(WindowContent , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(LineFrame , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(AccountProfile , SlowyTween , {
				ImageTransparency = 1
			})

			NeverLose.PlayAnimate(AccountName , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(ExpireLabel , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(LineFrame_2 , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UserSettingButton , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(RightMenuFrame , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(LineFrame_3 , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(ConfigFrame , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke_2 , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(ConfigIcon , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(LineFrame_4 , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(ConfigName , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(ConfigBthIcon , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(SearchBox , SlowyTween , {
				TextTransparency = 1
			})

			Window.Shadow:Render(false);
		end;
	end);

	Window.Shadow = NeverLose:CreateShadow(WindowFrame);
	Window.Shadow:Render(false);

	task.delay(0.25,function()
		WindowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		Window:SetRender(true);
		NeverLose:AddSignal(Window.Signal:Connect(LPH_NO_VIRTUALIZE(function(...)
			Window:SetRender(...);
		end)))
	end)

	if NeverLose.EnabledBlur then
		NeverLose:CreateBlurModule(WindowFrame,Window.Signal);
	end;

	do
		local Frame = Instance.new("Frame")

		Frame.Parent = WindowFrame
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(1, 0, 0, 50)
		Frame.ZIndex = 7
		Frame.BackgroundTransparency = 1;

		NeverLose.Drag(Frame , WindowFrame , 0.15)
	end

	UICorner.Parent = WindowFrame

	LeftMenuFrame.Name = NeverLose.RandomString();
	LeftMenuFrame.Parent = WindowFrame
	LeftMenuFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LeftMenuFrame.BackgroundTransparency = 1.000
	LeftMenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LeftMenuFrame.BorderSizePixel = 0
	LeftMenuFrame.Size = UDim2.new(0, 175, 1, 0)

	HeadFrame.Name = NeverLose.RandomString();
	HeadFrame.Parent = LeftMenuFrame
	HeadFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HeadFrame.BackgroundTransparency = 1.000
	HeadFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeadFrame.BorderSizePixel = 0
	HeadFrame.Size = UDim2.new(1, 0, 0, 50)
	HeadFrame.ZIndex = 7

	LogoImage.Name = NeverLose.RandomString();
	LogoImage.Parent = HeadFrame
	LogoImage.AnchorPoint = Vector2.new(0, 0.5)
	LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LogoImage.BackgroundTransparency = 1.000
	LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LogoImage.BorderSizePixel = 0
	LogoImage.Position = UDim2.new(0, 10, 0.5, 0)
	LogoImage.Size = UDim2.new(0, 35, 0, 35)
	LogoImage.ZIndex = 7
	LogoImage.Image = Window.Logo
	LogoImage.ImageColor3 = NeverLose.IconColor

	UICorner_2.CornerRadius = UDim.new(0, 7)
	UICorner_2.Parent = LogoImage

	WindowName.Name = NeverLose.RandomString();
	WindowName.Parent = HeadFrame
	WindowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowName.BackgroundTransparency = 1.000
	WindowName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowName.BorderSizePixel = 0
	WindowName.Position = UDim2.new(0, 55, 0, 4)
	WindowName.Size = UDim2.new(0, 200, 0, 25)
	WindowName.ZIndex = 7
	WindowName.Font = Enum.Font.GothamBold
	WindowName.Text = Window.Name
	WindowName.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowName.TextSize = 18.000
	WindowName.TextXAlignment = Enum.TextXAlignment.Left

	WindowContent.Name = NeverLose.RandomString();
	WindowContent.Parent = HeadFrame
	WindowContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowContent.BackgroundTransparency = 1.000
	WindowContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowContent.BorderSizePixel = 0
	WindowContent.Position = UDim2.new(0, 55, 0, 25)
	WindowContent.Size = UDim2.new(0, 200, 0, 15)
	WindowContent.ZIndex = 7
	WindowContent.Font = Enum.Font.GothamBold
	WindowContent.Text = Window.Content
	WindowContent.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowContent.TextSize = 9.000
	WindowContent.TextTransparency = 0.650
	WindowContent.TextXAlignment = Enum.TextXAlignment.Left

	LineFrame.Name = NeverLose.RandomString();
	LineFrame.Parent = HeadFrame
	LineFrame.AnchorPoint = Vector2.new(0.5, 1)
	LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame.BackgroundTransparency = 0.650
	LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame.BorderSizePixel = 0
	LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
	LineFrame.Size = UDim2.new(1, -10, 0, 1)
	LineFrame.ZIndex = 5

	LeftScrollingFrame.Name = NeverLose.RandomString();
	LeftScrollingFrame.Parent = LeftMenuFrame
	LeftScrollingFrame.Active = true
	LeftScrollingFrame.AnchorPoint = Vector2.new(0.5, 0)
	LeftScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	LeftScrollingFrame.BackgroundTransparency = 1.000
	LeftScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LeftScrollingFrame.BorderSizePixel = 0
	LeftScrollingFrame.Position = UDim2.new(0.5, 0, 0, 60)
	LeftScrollingFrame.Size = UDim2.new(1, -10, 1, -115)
	LeftScrollingFrame.ZIndex = 7
	LeftScrollingFrame.ScrollBarThickness = 0

	UIListLayout.Parent = LeftScrollingFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
		LeftScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 1)
	end)))

	BottomFrame.Name = NeverLose.RandomString();
	BottomFrame.Parent = LeftMenuFrame
	BottomFrame.AnchorPoint = Vector2.new(0, 1)
	BottomFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	BottomFrame.BackgroundTransparency = 1.000
	BottomFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	BottomFrame.BorderSizePixel = 0
	BottomFrame.Position = UDim2.new(0, 0, 1, 0)
	BottomFrame.Size = UDim2.new(1, 0, 0, 50)
	BottomFrame.ZIndex = 7

	AccountProfile.Name = NeverLose.RandomString();
	AccountProfile.Parent = BottomFrame
	AccountProfile.AnchorPoint = Vector2.new(0, 0.5)
	AccountProfile.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AccountProfile.BackgroundTransparency = 1.000
	AccountProfile.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AccountProfile.BorderSizePixel = 0
	AccountProfile.Position = UDim2.new(0, 10, 0.5, 0)
	AccountProfile.Size = UDim2.new(0, 35, 0, 35)
	AccountProfile.ZIndex = 7
	AccountProfile.Image = NeverLose.UserProfile or ""

	UICorner_3.CornerRadius = UDim.new(1, 0)
	UICorner_3.Parent = AccountProfile

	AccountName.Name = NeverLose.RandomString();
	AccountName.Parent = BottomFrame
	AccountName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	AccountName.BackgroundTransparency = 1.000
	AccountName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AccountName.BorderSizePixel = 0
	AccountName.Position = UDim2.new(0, 55, 0, 5)
	AccountName.Size = UDim2.new(0, 100, 0, 25)
	AccountName.ZIndex = 7
	AccountName.Font = Enum.Font.GothamBold
	AccountName.Text = ""
	AccountName.TextColor3 = Color3.fromRGB(255, 255, 255)
	AccountName.TextSize = 14.000
	AccountName.TextXAlignment = Enum.TextXAlignment.Left
	AccountName.TextTruncate = Enum.TextTruncate.SplitWord;

	ExpireLabel.Name = NeverLose.RandomString();
	ExpireLabel.Parent = BottomFrame
	ExpireLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ExpireLabel.BackgroundTransparency = 1.000
	ExpireLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ExpireLabel.BorderSizePixel = 0
	ExpireLabel.Position = UDim2.new(0, 55, 0, 25)
	ExpireLabel.Size = UDim2.new(0, 200, 0, 15)
	ExpireLabel.ZIndex = 7
	ExpireLabel.Font = Enum.Font.GothamBold
	ExpireLabel.Text = "never"
	ExpireLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	ExpireLabel.TextSize = 10.000
	ExpireLabel.TextTransparency = 0.650
	ExpireLabel.TextXAlignment = Enum.TextXAlignment.Left

	LineFrame_2.Name = NeverLose.RandomString();
	LineFrame_2.Parent = BottomFrame
	LineFrame_2.AnchorPoint = Vector2.new(0.5, 0)
	LineFrame_2.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame_2.BackgroundTransparency = 0.650
	LineFrame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame_2.BorderSizePixel = 0
	LineFrame_2.Position = UDim2.new(0.5, 0, 0, 0)
	LineFrame_2.Size = UDim2.new(1, -10, 0, 1)
	LineFrame_2.ZIndex = 5

	UserSettingButton.Name = NeverLose.RandomString();
	UserSettingButton.Parent = BottomFrame
	UserSettingButton.AnchorPoint = Vector2.new(1, 0.5)
	UserSettingButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	UserSettingButton.BackgroundTransparency = 1.000
	UserSettingButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	UserSettingButton.BorderSizePixel = 0
	UserSettingButton.Position = UDim2.new(1, -7, 0.5, 0)
	UserSettingButton.Size = UDim2.new(0, 25, 0, 25)
	UserSettingButton.ZIndex = 7
	UserSettingButton.FontFace = NeverLose.BuiltInBold
	UserSettingButton.Text = "chevron-large-right"
	UserSettingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	UserSettingButton.TextSize = 13.000
	UserSettingButton.TextTransparency = 0.5

	NeverLose:AddSignal(BottomFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
		NeverLose.PlayAnimate(UserSettingButton,SlowyTween , {
			TextTransparency = 0.25
		})		
	end)))

	NeverLose:AddSignal(BottomFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
		NeverLose.PlayAnimate(UserSettingButton,SlowyTween , {
			TextTransparency = 0.5
		})		
	end)))

	RightMenuFrame.Name = NeverLose.RandomString();
	RightMenuFrame.Parent = WindowFrame
	RightMenuFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
	RightMenuFrame.BackgroundTransparency = 0.600
	RightMenuFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RightMenuFrame.BorderSizePixel = 0
	RightMenuFrame.ClipsDescendants = true
	RightMenuFrame.Position = UDim2.new(0, 176, 0, 0)
	RightMenuFrame.Size = UDim2.new(1, -176, 1, 0)
	RightMenuFrame.ZIndex = 8

	UIStroke.Transparency = 0.650
	UIStroke.Color = Color3.fromRGB(45, 48, 58)
	UIStroke.Parent = RightMenuFrame

	UICorner_4.CornerRadius = UDim.new(0, 13)
	UICorner_4.Parent = RightMenuFrame

	RightHeader.Name = NeverLose.RandomString();
	RightHeader.Parent = RightMenuFrame
	RightHeader.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	RightHeader.BackgroundTransparency = 1.000
	RightHeader.BorderColor3 = Color3.fromRGB(0, 0, 0)
	RightHeader.BorderSizePixel = 0
	RightHeader.Size = UDim2.new(1, 0, 0, 50)
	RightHeader.ZIndex = 9

	LineFrame_3.Name = NeverLose.RandomString();
	LineFrame_3.Parent = RightHeader
	LineFrame_3.AnchorPoint = Vector2.new(0.5, 1)
	LineFrame_3.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame_3.BackgroundTransparency = 0.650
	LineFrame_3.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame_3.BorderSizePixel = 0
	LineFrame_3.Position = UDim2.new(0.5, 0, 1, 0)
	LineFrame_3.Size = UDim2.new(1, -10, 0, 1)
	LineFrame_3.ZIndex = 9

	ConfigFrame.Name = NeverLose.RandomString();
	ConfigFrame.Parent = RightHeader
	ConfigFrame.AnchorPoint = Vector2.new(0, 0.5)
	ConfigFrame.BackgroundColor3 = Color3.fromRGB(13, 17, 22)
	ConfigFrame.BackgroundTransparency = 0.750
	ConfigFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigFrame.BorderSizePixel = 0
	ConfigFrame.Position = UDim2.new(0, 10, 0.5, 0)
	ConfigFrame.Size = UDim2.new(0, 115, 0, 30)
	ConfigFrame.ZIndex = 9

	UIStroke_2.Transparency = 0.650
	UIStroke_2.Color = Color3.fromRGB(45, 48, 58)
	UIStroke_2.Parent = ConfigFrame

	UICorner_5.CornerRadius = UDim.new(0, 4)
	UICorner_5.Parent = ConfigFrame

	ConfigIcon.Name = NeverLose.RandomString();
	ConfigIcon.Parent = ConfigFrame
	ConfigIcon.AnchorPoint = Vector2.new(0, 0.5)
	ConfigIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfigIcon.BackgroundTransparency = 1.000
	ConfigIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigIcon.BorderSizePixel = 0
	ConfigIcon.Position = UDim2.new(0, 2, 0.5, 0)
	ConfigIcon.Size = UDim2.new(0, 25, 0, 25)
	ConfigIcon.ZIndex = 9
	ConfigIcon.FontFace = NeverLose.BuiltInBold
	ConfigIcon.Text = "pencil-square"
	ConfigIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
	ConfigIcon.TextSize = 16.000
	ConfigIcon.TextTransparency = 0.250
	ConfigIcon.TextWrapped = true

	LineFrame_4.Name = NeverLose.RandomString();
	LineFrame_4.Parent = ConfigFrame
	LineFrame_4.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
	LineFrame_4.BackgroundTransparency = 0.650
	LineFrame_4.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineFrame_4.BorderSizePixel = 0
	LineFrame_4.Position = UDim2.new(0, 30, 0, 0)
	LineFrame_4.Size = UDim2.new(0, 1, 1, 0)

	ConfigName.Name = NeverLose.RandomString();
	ConfigName.Parent = ConfigFrame
	ConfigName.AnchorPoint = Vector2.new(0, 0.5)
	ConfigName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfigName.BackgroundTransparency = 1.000
	ConfigName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigName.BorderSizePixel = 0
	ConfigName.Position = UDim2.new(0, 40, 0.5, 0)
	ConfigName.Size = UDim2.new(1, -7, 0, 15)
	ConfigName.ZIndex = 9
	ConfigName.Font = Enum.Font.GothamMedium
	ConfigName.Text = "Default"
	ConfigName.TextColor3 = Color3.fromRGB(255, 255, 255)
	ConfigName.TextSize = 12.000
	ConfigName.TextTransparency = 0.350
	ConfigName.TextXAlignment = Enum.TextXAlignment.Left

	ConfigBthIcon.Name = NeverLose.RandomString();
	ConfigBthIcon.Parent = ConfigFrame
	ConfigBthIcon.AnchorPoint = Vector2.new(1, 0.5)
	ConfigBthIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ConfigBthIcon.BackgroundTransparency = 1.000
	ConfigBthIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ConfigBthIcon.BorderSizePixel = 0
	ConfigBthIcon.Position = UDim2.new(1, -2, 0.5, 0)
	ConfigBthIcon.Size = UDim2.new(0, 25, 0, 25)
	ConfigBthIcon.ZIndex = 9
	ConfigBthIcon.FontFace = NeverLose.BuiltInBold
	ConfigBthIcon.Text = "chevron-small-down"
	ConfigBthIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
	ConfigBthIcon.TextSize = 16.000
	ConfigBthIcon.TextTransparency = 0.250
	ConfigBthIcon.TextWrapped = true

	SearchFrame.Name = NeverLose.RandomString();
	SearchFrame.Parent = RightHeader
	SearchFrame.AnchorPoint = Vector2.new(1, 0.5)
	SearchFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchFrame.BackgroundTransparency = 1.000
	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchFrame.BorderSizePixel = 0
	SearchFrame.ClipsDescendants = true
	SearchFrame.Position = UDim2.new(1, -10, 0.5, 0)
	SearchFrame.Size = UDim2.new(0, 30, 0, 30)
	SearchFrame.ZIndex = 12

	SearchIcon.Name = NeverLose.RandomString();
	SearchIcon.Parent = SearchFrame
	SearchIcon.AnchorPoint = Vector2.new(0, 0.5)
	SearchIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchIcon.BackgroundTransparency = 1.000
	SearchIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchIcon.BorderSizePixel = 0
	SearchIcon.Position = UDim2.new(0, 2, 0.5, 0)
	SearchIcon.Size = UDim2.new(0, 25, 0, 25)
	SearchIcon.ZIndex = 12
	SearchIcon.FontFace = NeverLose.BuiltInBold
	SearchIcon.Text = "magnifying-glass"
	SearchIcon.TextColor3 = Color3.fromRGB(223, 223, 223)
	SearchIcon.TextSize = 14.000
	SearchIcon.TextTransparency = 0.45
	SearchIcon.TextWrapped = true

	SearchBox.Name = NeverLose.RandomString();
	SearchBox.Parent = SearchFrame
	SearchBox.AnchorPoint = Vector2.new(0, 0.5)
	SearchBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.BackgroundTransparency = 1.000
	SearchBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchBox.BorderSizePixel = 0
	SearchBox.Position = UDim2.new(0, 35, 0.5, 0)
	SearchBox.Size = UDim2.new(1, -35, 0, 25)
	SearchBox.ZIndex = 12
	SearchBox.ClearTextOnFocus = false
	SearchBox.Font = Enum.Font.GothamMedium
	SearchBox.PlaceholderText = "Search"
	SearchBox.Text = ""
	SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	SearchBox.TextSize = 13.000
	SearchBox.TextTransparency = 1
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left

	TabContainer.Name = NeverLose.RandomString();
	TabContainer.Parent = RightMenuFrame
	TabContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabContainer.BackgroundTransparency = 1.000
	TabContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabContainer.BorderSizePixel = 0
	TabContainer.ClipsDescendants = true
	TabContainer.Position = UDim2.new(0, 0, 0, 50)
	TabContainer.Size = UDim2.new(1, 0, 1, -50)
	TabContainer.ZIndex = 5

	do
		Window.Searching = false;
		local Input = NeverLose:CreateInput(SearchIcon , LPH_NO_VIRTUALIZE(function()
			Window.Searching = not Window.Searching;

			if Window.Searching then
				NeverLose.PlayAnimate(SearchFrame , VSlowTween , {
					Size = UDim2.new(0, 220, 0, 30)
				})

				NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.25
				})

				NeverLose.PlayAnimate(SearchBox , VSlowTween , {
					TextTransparency = 0.350
				})
			else
				NeverLose.PlayAnimate(SearchFrame , VSlowTween , {
					Size = UDim2.new(0, 30, 0, 30)
				})

				NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.45
				})

				NeverLose.PlayAnimate(SearchBox , SlowyTween , {
					TextTransparency = 1
				})

				SearchBox.Text = "";
			end;
		end));	

		local wati_for_finish = tick();
		local last_thread;
		local max_time = 0.2;

		NeverLose:AddSignal(SearchBox:GetPropertyChangedSignal('Text'):Connect(LPH_NO_VIRTUALIZE(function()
			if not SearchBox.Text:byte() then
				for i,v in next , NeverLose.NameRegisitry do
					v.Root.Visible = true;
				end;

				return;	
			end;

			wati_for_finish = tick();

			if last_thread then
				task.cancel(last_thread);
				last_thread = nil;
			end;

			last_thread = task.delay(max_time,function()
				if SearchBox.Text:byte() and (tick() - wati_for_finish) > max_time then
					for i,v in next , NeverLose.NameRegisitry do
						if string.find(string.lower(v.Idx) , string.lower(SearchBox.Text), 1, true) then
							v.Root.Visible = true;
						else
							v.Root.Visible = false;
						end;
					end;
				end;
			end);
		end)));

		NeverLose:AddSignal(Input.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
				TextTransparency = 0.25
			})
		end)))

		NeverLose:AddSignal(Input.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			if Window.Searching then
				NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.25
				})
			else
				NeverLose.PlayAnimate(SearchIcon , SlowyTween , {
					TextTransparency = 0.45
				})
			end;
		end)));
	end;

	if Window.Enable3DRenderer then
		local Part = Instance.new('Part');

		Part.Name = NeverLose.RandomString();
		Part.Anchored = true;
		Part.Transparency = 1;
		Part.CanCollide = false;
		Part.CanTouch = false;
		Part.AudioCanCollide = false;
		Part.CollisionGroup = NeverLose.RandomString();
		Part.CFrame = CFrame.new(0,0,0);
		Part.Size = Vector3.zero;

		local SurfaceGui = Instance.new("SurfaceGui")

		SurfaceGui.Parent = NeverLose.ScreenGui;
		SurfaceGui.Adornee = Part;
		SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		SurfaceGui.AlwaysOnTop = true
		SurfaceGui.LightInfluence = 1.000
		SurfaceGui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
		SurfaceGui.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize;
		SurfaceGui.PixelsPerStud = 40;

		Window.SurfaceGui = SurfaceGui;
		NeverLose.GlobalSurfaceGui = SurfaceGui;

		local PerfectScale = Vector2.new(1920 , 1080 + 300)

		Window.Load3DBlock = LPH_NO_VIRTUALIZE(function()
			if not Window.Signal:GetValue() then
				local _,OnScreen = CurrentCamera:WorldToViewportPoint(Part.Position);

				if OnScreen then
					NeverLose.PlayAnimate(Part,VSlowTween , {
						CFrame = CurrentCamera.CFrame * CFrame.new(0,0,-15) * CFrame.Angles(0,math.rad(180),0);
					});
				end;

				return
			end;

			local Dimensions = 50;

			local XY_Incom = Vector2.new(PerfectScale.X + 5, PerfectScale.Y * 1.35) / (Dimensions / 2);
			local PerfectDistance = XY_Incom.Magnitude;
			local SizeIndicator = PerfectDistance / 1.35;

			Part.Parent = NeverLose.BlurModuleParent or workspace;

			NeverLose.PlayAnimate(Part,VSlowTween , {
				CFrame = (CurrentCamera.CFrame * CFrame.new(0,0,-25)) * CFrame.Angles(0,math.rad(180),0);
			});

			Part.Size = Vector3.new(PerfectScale.X / SizeIndicator,PerfectScale.Y / SizeIndicator,0);
		end);

		function Window:Set3DRender(val)
			Window.__3DRender = val;
			NeverLose.Global3DRenderMode = val;

			if val then
				Window.Load3DBlock();
			else


				Part.Parent = nil;
			end;

			renderParentWindow();
		end;
	end;

	function Window:AddTabLabel(Name: string)
		local TabLabel = Instance.new("TextLabel")

		TabLabel.Name = NeverLose.RandomString()
		TabLabel.Parent = LeftScrollingFrame
		TabLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabLabel.BackgroundTransparency = 1.000
		TabLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabLabel.BorderSizePixel = 0
		TabLabel.Size = UDim2.new(1, -7, 0, 15)
		TabLabel.ZIndex = 8
		TabLabel.Font = Enum.Font.GothamMedium
		TabLabel.Text = Name
		TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabLabel.TextSize = 11.000
		TabLabel.TextTransparency = 0.500
		TabLabel.TextXAlignment = Enum.TextXAlignment.Left

		local SetRender = LPH_NO_VIRTUALIZE(function(val)
			if val then
				NeverLose.PlayAnimate(TabLabel , SlowyTween,{
					TextTransparency = 0.500
				})
			else
				NeverLose.PlayAnimate(TabLabel , SlowyTween,{
					TextTransparency = 1
				})
			end
		end)

		SetRender(Window.Signal:GetValue());

		return Window.Signal:Connect(SetRender);
	end;

	function Window:AddTab(Config)
		Config = NeverLose:ProcessParams(Config , {
			Icon = "crosshairs",
			Name = "Tab",
			Type = "Double"
		});

		local Tab = {
			Signal = NeverLose:CreateSignal(false);
		};

		local TabButton = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local TabIcon = Instance.new("TextLabel")
		local TabContentLabel = Instance.new("TextLabel")

		Tab.Idx = TabButton;

		TabButton.Name = NeverLose.RandomString();
		TabButton.Parent = LeftScrollingFrame
		TabButton.BackgroundColor3 = Color3.fromRGB(41, 45, 49)
		TabButton.BackgroundTransparency = 0.500
		TabButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabButton.BorderSizePixel = 0
		TabButton.Size = UDim2.new(1, -1, 0, 30)
		TabButton.ZIndex = 8

		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = TabButton

		TabIcon.Name = NeverLose.RandomString();
		TabIcon.Parent = TabButton
		TabIcon.AnchorPoint = Vector2.new(0, 0.5)
		TabIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabIcon.BackgroundTransparency = 1.000
		TabIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabIcon.BorderSizePixel = 0
		TabIcon.Position = UDim2.new(0, 2, 0.5, 0)
		TabIcon.Size = UDim2.new(0, 25, 0, 25)
		TabIcon.ZIndex = 9
		TabIcon.FontFace = NeverLose.BuiltInBold
		TabIcon.Text = Config.Icon;
		TabIcon.TextColor3 = NeverLose.AccentColor
		TabIcon.TextSize = 16.000
		TabIcon.TextWrapped = true

		TabContentLabel.Name = NeverLose.RandomString();
		TabContentLabel.Parent = TabButton
		TabContentLabel.AnchorPoint = Vector2.new(0, 0.5)
		TabContentLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabContentLabel.BackgroundTransparency = 1.000
		TabContentLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabContentLabel.BorderSizePixel = 0
		TabContentLabel.Position = UDim2.new(0, 30, 0.5, 0)
		TabContentLabel.Size = UDim2.new(1, -7, 0, 15)
		TabContentLabel.ZIndex = 9
		TabContentLabel.Font = Enum.Font.GothamMedium
		TabContentLabel.Text = Config.Name
		TabContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		TabContentLabel.TextSize = 12.000
		TabContentLabel.TextXAlignment = Enum.TextXAlignment.Left

		local TabFrame = Instance.new("Frame")
		local LeftScroll = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local RightScroll = Instance.new("ScrollingFrame")
		local UIListLayout_2 = Instance.new("UIListLayout")

		TabFrame.Name = NeverLose.RandomString();
		TabFrame.Parent = TabContainer
		TabFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		TabFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TabFrame.BackgroundTransparency = 1.000
		TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabFrame.BorderSizePixel = 0
		TabFrame.ClipsDescendants = true
		TabFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		TabFrame.Size = UDim2.new(1, 0, 1, 0)
		TabFrame.Visible = true;

		LeftScroll.Name = NeverLose.RandomString();
		LeftScroll.Parent = TabFrame
		LeftScroll.Active = true
		LeftScroll.AnchorPoint = Vector2.new(0.5, 0.5)
		LeftScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LeftScroll.BackgroundTransparency = 1.000
		LeftScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LeftScroll.BorderSizePixel = 0
		LeftScroll.ClipsDescendants = false
		LeftScroll.Position = UDim2.new(0.25, 0, 0.5, 0)
		LeftScroll.Size = UDim2.new(0.5, 0, 1, -5)
		LeftScroll.ScrollBarThickness = 0

		UIListLayout.Parent = LeftScroll
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)

		NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			LeftScroll.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 1)
		end)))

		RightScroll.Name = NeverLose.RandomString();
		RightScroll.Parent = TabFrame
		RightScroll.Active = true
		RightScroll.AnchorPoint = Vector2.new(0.5, 0.5)
		RightScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		RightScroll.BackgroundTransparency = 1.000
		RightScroll.BorderColor3 = Color3.fromRGB(0, 0, 0)
		RightScroll.BorderSizePixel = 0
		RightScroll.ClipsDescendants = false
		RightScroll.Position = UDim2.new(0.75, 0, 0.5, 0)
		RightScroll.Size = UDim2.new(0.5, 0, 1, -5)
		RightScroll.ScrollBarThickness = 0

		UIListLayout_2.Parent = RightScroll
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 5)

		if Config.Type == "Single" then
			UIListLayout_2:Destroy();
			RightScroll:Destroy();
			RightScroll = LeftScroll;
			UIListLayout_2 = UIListLayout;
			LeftScroll.Size = UDim2.new(1, 0, 1, -5);
			LeftScroll.Position = UDim2.new(0.5, 0, 0.5, 0)
		else
			NeverLose:AddSignal(UIListLayout_2:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
				RightScroll.CanvasSize = UDim2.fromOffset(0,UIListLayout_2.AbsoluteContentSize.Y + 1)
			end)))
		end;

		NeverLose:AddSignal(TabIcon:GetPropertyChangedSignal('TextTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if TabIcon.TextTransparency > 0.4 then
				UIListLayout.Parent = nil;
				UIListLayout_2.Parent = nil;
				TabFrame.Visible = false;
				TabFrame.Parent = nil
			else
				UIListLayout.Parent = LeftScroll;
				UIListLayout_2.Parent = RightScroll;
				TabFrame.Visible = true;
				TabFrame.Parent = TabContainer;
			end;
		end)));

		Tab.SetValue = LPH_NO_VIRTUALIZE(function(value)
			Tab.Signal:SetValue(value);

			if value then
				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 0.500
				})

				NeverLose.PlayAnimate(TabIcon , SlowyTween , {
					TextTransparency = 0,
					TextColor3 = NeverLose.AccentColor
				})

				NeverLose.PlayAnimate(TabContentLabel , SlowyTween , {
					TextTransparency = 0
				})
			else
				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 1
				})

				NeverLose.PlayAnimate(TabIcon , SlowyTween , {
					TextTransparency = 0.5,
					TextColor3 = Color3.fromRGB(252, 252, 252)
				})

				NeverLose.PlayAnimate(TabContentLabel , SlowyTween , {
					TextTransparency = 0.5
				})
			end;
		end);

		table.insert(Window.Tabs,Tab);

		if Window.Tabs[Window.CurrentTab] == Tab then
			Tab.SetValue(true)
		else
			Tab.SetValue(false);
		end;

		local over = NeverLose:CreateInput(TabButton,LPH_NO_VIRTUALIZE(function()
			for i,v in next , Window.Tabs do
				if v.Idx == TabButton then
					v.SetValue(true);
					Window.CurrentTab = i;
				else
					v.SetValue(false);
				end;
			end;
		end));

		NeverLose:AddSignal(over.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			if Window.Tabs[Window.CurrentTab] == Tab then
				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 0.500
				})
			else
				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 0.8
				})
			end;
		end)))

		NeverLose:AddSignal(over.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			if Window.Tabs[Window.CurrentTab] == Tab then
				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 0.500
				})
			else
				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 1
				})
			end;
		end)))

		Window.Signal:Connect(LPH_NO_VIRTUALIZE(function(value)
			if value then
				if Window.Tabs[Window.CurrentTab] == Tab then
					Tab.SetValue(true)
				else
					Tab.SetValue(false);
				end;
			else
				Tab.SetValue(false);

				NeverLose.PlayAnimate(TabButton , SlowyTween , {
					BackgroundTransparency = 1
				})

				NeverLose.PlayAnimate(TabIcon , SlowyTween , {
					TextTransparency = 1,
				})

				NeverLose.PlayAnimate(TabContentLabel , SlowyTween , {
					TextTransparency = 1
				})
			end;
		end));

		function Tab:AddSection(Config)
			Config = NeverLose:ProcessParams(Config , {
				Name = "SECTION",
				Position = 'left'
			});

			local SectionFrame = Instance.new("Frame")
			local SectionLabel = Instance.new("TextLabel")
			local SectionHandler = Instance.new("Frame")
			local UIStroke = Instance.new("UIStroke")
			local UICorner = Instance.new("UICorner")
			local UIListLayout = Instance.new("UIListLayout")

			SectionFrame.Name = NeverLose.RandomString();
			SectionFrame.Parent = (string.lower(Config.Position) == 'left' and LeftScroll) or RightScroll
			SectionFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionFrame.BackgroundTransparency = 1.000
			SectionFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionFrame.BorderSizePixel = 0
			SectionFrame.ClipsDescendants = true
			SectionFrame.Size = UDim2.new(1, -5, 0, 0)
			SectionFrame.ZIndex = 9

			SectionLabel.Name = NeverLose.RandomString();
			SectionLabel.Parent = SectionFrame
			SectionLabel.AnchorPoint = Vector2.new(0.5, 0)
			SectionLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			SectionLabel.BackgroundTransparency = 1.000
			SectionLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionLabel.BorderSizePixel = 0
			SectionLabel.Position = UDim2.new(0.5, 0, 0, 0)
			SectionLabel.Size = UDim2.new(1, -35, 0, 15)
			SectionLabel.ZIndex = 9
			SectionLabel.Font = Enum.Font.GothamMedium
			SectionLabel.Text = Config.Name
			SectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			SectionLabel.TextSize = 11.000
			SectionLabel.TextTransparency = 0.500
			SectionLabel.TextXAlignment = Enum.TextXAlignment.Left

			SectionHandler.Name = NeverLose.RandomString();
			SectionHandler.Parent = SectionFrame
			SectionHandler.AnchorPoint = Vector2.new(0.5, 0)
			SectionHandler.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
			SectionHandler.BackgroundTransparency = 0.500
			SectionHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
			SectionHandler.BorderSizePixel = 0
			SectionHandler.ClipsDescendants = true
			SectionHandler.Position = UDim2.new(0.5, 0, 0, 20)
			SectionHandler.Size = UDim2.new(1, -10, 1, -21)
			SectionHandler.ZIndex = 9

			UIStroke.Transparency = 0.650
			UIStroke.Color = Color3.fromRGB(45, 48, 58)
			UIStroke.Parent = SectionHandler

			UICorner.CornerRadius = UDim.new(0, 10)
			UICorner.Parent = SectionHandler

			UIListLayout.Parent = SectionHandler
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()


				if UIListLayout.AbsoluteContentSize.Y <= 1 then
					NeverLose.PlayAnimate(SectionFrame , VSlowTween , {
						Size = UDim2.new(1, -5, 0, 0)
					})
				else
					NeverLose.PlayAnimate(SectionFrame , VSlowTween , {
						Size = UDim2.new(1, -5, 0, UIListLayout.AbsoluteContentSize.Y + 19.5)
					})
				end;
			end));

			local Section = NeverLose:RegisiterItem(SectionHandler , Tab.Signal);

			Section.SetRender = LPH_NO_VIRTUALIZE(function(value)
				if value then
					NeverLose.PlayAnimate(SectionLabel,SlowyTween,{
						TextTransparency = 0.500
					})

					NeverLose.PlayAnimate(SectionHandler,SlowyTween,{
						BackgroundTransparency = 0.500
					})

					NeverLose.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.650
					})
				else
					NeverLose.PlayAnimate(SectionLabel,SlowyTween,{
						TextTransparency = 1
					})

					NeverLose.PlayAnimate(SectionHandler,SlowyTween,{
						BackgroundTransparency = 1
					})

					NeverLose.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 1
					})
				end;
			end);

			Section.SetRender(Tab.Signal:GetValue());
			Tab.Signal:Connect(Section.SetRender);

			return Section;
		end;

		return Tab;
	end;

	function Window:_InitConfig()
		local ConfigSignal = NeverLose:CreateSignal(false);
		local ConfigLib = {
			Signals = {},
		};

		local ConfigMenu = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIListLayout = Instance.new("UIListLayout")
		local UIStroke = Instance.new("UIStroke")
		local InputFrame = Instance.new("Frame")
		local BasedLabel = Instance.new("TextLabel")
		local LineFrame = Instance.new("Frame")
		local BasedHandler = Instance.new("Frame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local TextInput = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke_2 = Instance.new("UIStroke")
		local TextBox = Instance.new("TextBox")
		local LoadConfig = Instance.new("Frame")
		local Icon = Instance.new("TextLabel")
		local UICorner_3 = Instance.new("UICorner")
		local UICorner_4 = Instance.new("UICorner")

		local shadow = NeverLose:CreateShadow(ConfigMenu);

		ConfigLib.SetRender = LPH_NO_VIRTUALIZE(function(value)
			if value then
				ConfigMenu.Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110 , ConfigFrame.AbsolutePosition.Y + 96)

				NeverLose.PlayAnimate(ConfigMenu , SlowyTween , {
					BackgroundTransparency = 0.035,
					Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110 , ConfigFrame.AbsolutePosition.Y + 95)
				})	

				NeverLose.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 0.650
				})
				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 0.200
				})	

				NeverLose.PlayAnimate(UIStroke_2 , SlowyTween , {
					Transparency = 0.65
				})	

				NeverLose.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 0.650
				})	
				NeverLose.PlayAnimate(TextInput , SlowyTween , {
					BackgroundTransparency = 0
				})	
				NeverLose.PlayAnimate(TextBox , SlowyTween , {
					TextTransparency = 0.350
				})	
				NeverLose.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 0.350
				})	

				NeverLose.PlayAnimate(ConfigBthIcon , SlowyTween , {
					Rotation = 180
				})	

				shadow:Render(true)
			else
				NeverLose.PlayAnimate(ConfigBthIcon , SlowyTween , {
					Rotation = 0
				})

				NeverLose.PlayAnimate(ConfigMenu , SlowyTween , {
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(ConfigFrame.AbsolutePosition.X + 110 , ConfigFrame.AbsolutePosition.Y + 96)
				})	

				NeverLose.PlayAnimate(UIStroke_2 , SlowyTween , {
					Transparency = 1
				})	

				NeverLose.PlayAnimate(UIStroke , SlowyTween , {
					Transparency = 1
				})
				NeverLose.PlayAnimate(BasedLabel , SlowyTween , {
					TextTransparency = 1
				})	
				NeverLose.PlayAnimate(LineFrame , SlowyTween , {
					BackgroundTransparency = 1
				})	
				NeverLose.PlayAnimate(TextInput , SlowyTween , {
					BackgroundTransparency = 1
				})	
				NeverLose.PlayAnimate(TextBox , SlowyTween , {
					TextTransparency = 1
				})	
				NeverLose.PlayAnimate(Icon , SlowyTween , {
					TextTransparency = 1
				})	

				shadow:Render(false)
			end;
		end);

		NeverLose:AddSignal(ConfigMenu:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if ConfigMenu.BackgroundTransparency > 0.9 then
				ConfigMenu.Visible = false;
				UIListLayout.Parent = nil;
				ConfigMenu.Parent = nil;
			else

				ConfigMenu.Visible = true;
				UIListLayout.Parent = ConfigMenu

				if NeverLose.Global3DRenderMode then
					ConfigMenu.Parent = NeverLose.GlobalSurfaceGui;
				else
					ConfigMenu.Parent = NeverLose.ScreenGui;
				end;
			end
		end)))

		ConfigMenu.Name = NeverLose.RandomString();
		ConfigMenu.Parent = NeverLose.ScreenGui;
		ConfigMenu.AnchorPoint = Vector2.new(0.5, 0)
		ConfigMenu.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		ConfigMenu.BackgroundTransparency = 0.035
		ConfigMenu.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ConfigMenu.BorderSizePixel = 0
		ConfigMenu.ClipsDescendants = true
		ConfigMenu.Position = UDim2.new(255,255,255,255)
		ConfigMenu.Size = UDim2.new(0, 220,0, 110)
		ConfigMenu.ZIndex = 151

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = ConfigMenu

		UIListLayout.Parent = ConfigMenu
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 4)

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = ConfigMenu

		InputFrame.Name = NeverLose.RandomString();
		InputFrame.Parent = ConfigMenu
		InputFrame.BackgroundColor3 = Color3.fromRGB(25, 27, 33)
		InputFrame.BackgroundTransparency = 1.000
		InputFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InputFrame.BorderSizePixel = 0
		InputFrame.Size = UDim2.new(1, 0, 0, 30)
		InputFrame.ZIndex = 154

		BasedLabel.Name = NeverLose.RandomString();
		BasedLabel.Parent = InputFrame
		BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.BackgroundTransparency = 1.000
		BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedLabel.BorderSizePixel = 0
		BasedLabel.Position = UDim2.new(0, 11, 0, 6)
		BasedLabel.Size = UDim2.new(0,1, 0, 15)
		BasedLabel.ZIndex = 154
		BasedLabel.Font = Enum.Font.GothamMedium
		BasedLabel.Text = "Config"
		BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		BasedLabel.TextSize = 13.000
		BasedLabel.TextTransparency = 0.200
		BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

		LineFrame.Name = NeverLose.RandomString();
		LineFrame.Parent = InputFrame
		LineFrame.AnchorPoint = Vector2.new(0.5, 1)
		LineFrame.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
		LineFrame.BackgroundTransparency = 0.650
		LineFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineFrame.BorderSizePixel = 0
		LineFrame.Position = UDim2.new(0.5, 0, 1, 0)
		LineFrame.Size = UDim2.new(1, -20, 0, 1)
		LineFrame.ZIndex = 154

		BasedHandler.Name = NeverLose.RandomString();
		BasedHandler.Parent = InputFrame
		BasedHandler.AnchorPoint = Vector2.new(1, 0)
		BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		BasedHandler.BackgroundTransparency = 1.000
		BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
		BasedHandler.BorderSizePixel = 0
		BasedHandler.Position = UDim2.new(1, -11, 0, 2)
		BasedHandler.Size = UDim2.new(1, -20, 0, 25)
		BasedHandler.ZIndex = 154

		UIListLayout_2.Parent = BasedHandler
		UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Right
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout_2.Padding = UDim.new(0, 5)

		NeverLose:AddSignal(UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			if #ConfigLib.Signals <= 0 then
				NeverLose.PlayAnimate(ConfigMenu , SlowyTween , {
					Size = UDim2.new(0, 220,0, UIListLayout.AbsoluteContentSize.Y + 0);
				})
			else
				NeverLose.PlayAnimate(ConfigMenu , SlowyTween , {
					Size = UDim2.new(0, 220,0, UIListLayout.AbsoluteContentSize.Y + 5);
				})
			end;

		end)));

		TextInput.Name = NeverLose.RandomString();
		TextInput.Parent = BasedHandler
		TextInput.BackgroundColor3 = Color3.fromRGB(26, 28, 36)
		TextInput.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextInput.BorderSizePixel = 0
		TextInput.ClipsDescendants = true
		TextInput.Size = UDim2.new(0, 100, 0, 18)
		TextInput.ZIndex = 154

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = TextInput

		UIStroke_2.Transparency = 0.650
		UIStroke_2.Color = Color3.fromRGB(45, 48, 58)
		UIStroke_2.Parent = TextInput

		TextBox.Parent = TextInput
		TextBox.AnchorPoint = Vector2.new(0, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0, 5, 0.5, 0)
		TextBox.Size = UDim2.new(1, -5, 0, 17)
		TextBox.ZIndex = 154
		TextBox.ClearTextOnFocus = false
		TextBox.Font = Enum.Font.GothamMedium
		TextBox.PlaceholderText = "Config Name ..."
		TextBox.Text = ""
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextSize = 11.000
		TextBox.TextTransparency = 0.350
		TextBox.TextXAlignment = Enum.TextXAlignment.Left

		LoadConfig.Name = NeverLose.RandomString();
		LoadConfig.Parent = BasedHandler
		LoadConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
		LoadConfig.BackgroundTransparency = 1.000
		LoadConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LoadConfig.BorderSizePixel = 0
		LoadConfig.ClipsDescendants = true
		LoadConfig.Size = UDim2.new(0, 20, 0, 18)
		LoadConfig.ZIndex = 153

		Icon.Name = NeverLose.RandomString();
		Icon.Parent = LoadConfig
		Icon.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		Icon.Size = UDim2.new(1, 0, 1, 0)
		Icon.ZIndex = 153
		Icon.FontFace = NeverLose.BuiltInBold
		Icon.Text = "plus-large"
		Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
		Icon.TextSize = 16.000
		Icon.TextTransparency = 0.350
		Icon.TextWrapped = true

		UICorner_3.CornerRadius = UDim.new(0, 4)
		UICorner_3.Parent = LoadConfig

		UICorner_4.CornerRadius = UDim.new(0, 10)
		UICorner_4.Parent = InputFrame

		local OpenButton = Instance.new("TextButton")
		local UICorner = Instance.new("UICorner")

		OpenButton.Name = NeverLose.RandomString();
		OpenButton.Parent = ConfigFrame
		OpenButton.AnchorPoint = Vector2.new(0, 0.5)
		OpenButton.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		OpenButton.BackgroundTransparency = 1.000
		OpenButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		OpenButton.BorderSizePixel = 0
		OpenButton.Position = UDim2.new(0, 31, 0.5, 0)
		OpenButton.Size = UDim2.new(1, -31, 1, 0)
		OpenButton.ZIndex = 10
		OpenButton.Font = Enum.Font.SourceSans
		OpenButton.Text = ""
		OpenButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		OpenButton.TextSize = 14.000

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = OpenButton

		ConfigLib.SetRender(false);
		ConfigSignal:Connect(ConfigLib.SetRender);
		ConfigLib.UnsafeThread = nil;
		ConfigLib.SelectedConfig = "Default";

		local UpdateSize = LPH_NO_VIRTUALIZE(function()
			local size = TextService:GetTextSize(ConfigName.Text , ConfigName.TextSize,ConfigName.Font,Vector2.new(math.huge,math.huge));

			NeverLose.PlayAnimate(ConfigFrame,SlowyTween , {
				Size = UDim2.fromOffset(size.X + 75, 30)
			});
		end);

		UpdateSize();

		function ConfigLib:GetData(performance)
			local ikc = {};
			
			local cd = 0;
			for Flag,v in next , NeverLose.Flags do
				if v and v.GetValue then
					local data = v:GetValue();

					if typeof(data) == 'Color3' then
						table.insert(ikc,{
							Idx = Flag,
							Value = data:ToHex(),
						});
					else
						table.insert(ikc,{
							Idx = Flag,
							Value = data
						});
					end;
				end;
				
				if performance then
					if cd % 35 == 1 then
						task.wait()
					end
				end;
				
				cd += 1;
			end;

			return NeverLose.Base64Encode(Encryption.new(HttpService:JSONEncode(ikc)));
		end;

		function ConfigLib:LoadData(data)
			local coded = HttpService:JSONDecode(Encryption.reverse(NeverLose.Base64Decode(data)));

			for i,v in next , coded do
				if v.Idx then
					if NeverLose.Flags[v.Idx] then
						task.spawn(function()
							NeverLose.Flags[v.Idx]:SetValue(v.Value)
						end)
					end;
				end;
			end;
		end;

		function ConfigLib:RefreshConfig()
			if not isfolder(Window.ConfigFolder) then
				makefolder(Window.ConfigFolder);
			end;
			
			if not isfile(Window.ConfigFolder..'/Default') then
				writefile(Window.ConfigFolder..'/Default',ConfigLib:GetData());
			end;
			
			for i,v in next,ConfigMenu:GetChildren() do
				if v:GetAttribute('ConfigItem') then
					v:Destroy();
				end;
			end;

			for i,v in next , ConfigLib.Signals do
				v:Disconnect();
			end

			table.clear(ConfigLib.Signals);

			local ConfigList = {};
			for i,v in next , listfiles(Window.ConfigFolder) do

				local name = string.sub(v , #Window.ConfigFolder + 2);

				table.insert(ConfigList , name)
			end;

			for i,ConfigNameStr in next , ConfigList do
				local ConfigItemFrame = Instance.new("Frame")
				local BasedHandler = Instance.new("Frame")
				local UIListLayout = Instance.new("UIListLayout")
				local DeleteConfig = Instance.new("Frame")
				local Icon = Instance.new("TextLabel")
				local UICorner = Instance.new("UICorner")
				local LoadConfig = Instance.new("Frame")
				local Icon_2 = Instance.new("TextLabel")
				local UICorner_2 = Instance.new("UICorner")
				local UICorner_3 = Instance.new("UICorner")
				local BasedLabel = Instance.new("TextLabel")
				local UIStroke = Instance.new("UIStroke")

				ConfigItemFrame.Name = NeverLose.RandomString();
				ConfigItemFrame.Parent = ConfigMenu
				ConfigItemFrame.BackgroundColor3 = Color3.fromRGB(21, 20, 27)
				ConfigItemFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ConfigItemFrame.BorderSizePixel = 0
				ConfigItemFrame.Size = UDim2.new(1, -10, 0, 30)
				ConfigItemFrame.ZIndex = 153
				ConfigItemFrame:SetAttribute('ConfigItem',true);

				BasedHandler.Name = NeverLose.RandomString();
				BasedHandler.Parent = ConfigItemFrame
				BasedHandler.AnchorPoint = Vector2.new(1, 0)
				BasedHandler.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				BasedHandler.BackgroundTransparency = 1.000
				BasedHandler.BorderColor3 = Color3.fromRGB(0, 0, 0)
				BasedHandler.BorderSizePixel = 0
				BasedHandler.Position = UDim2.new(1, -11, 0, 2)
				BasedHandler.Size = UDim2.new(1, -20, 0, 25)
				BasedHandler.ZIndex = 153

				UIListLayout.Parent = BasedHandler
				UIListLayout.FillDirection = Enum.FillDirection.Horizontal
				UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
				UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				UIListLayout.Padding = UDim.new(0, 5)

				DeleteConfig.Name = NeverLose.RandomString();
				DeleteConfig.Parent = BasedHandler
				DeleteConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
				DeleteConfig.BackgroundTransparency = 1.000
				DeleteConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
				DeleteConfig.BorderSizePixel = 0
				DeleteConfig.ClipsDescendants = true
				DeleteConfig.Size = UDim2.new(0, 20, 0, 18)
				DeleteConfig.ZIndex = 153

				Icon.Name = NeverLose.RandomString();
				Icon.Parent = DeleteConfig
				Icon.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Icon.BackgroundTransparency = 1.000
				Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Icon.BorderSizePixel = 0
				Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
				Icon.Size = UDim2.new(1, 0, 1, 0)
				Icon.ZIndex = 153
				Icon.FontFace = NeverLose.BuiltInBold
				Icon.Text = "trash-can"
				Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
				Icon.TextSize = 16.000
				Icon.TextTransparency = 0.400
				Icon.TextWrapped = true

				UICorner.CornerRadius = UDim.new(0, 4)
				UICorner.Parent = DeleteConfig

				LoadConfig.Name = NeverLose.RandomString();
				LoadConfig.Parent = BasedHandler
				LoadConfig.BackgroundColor3 = Color3.fromRGB(39, 40, 49)
				LoadConfig.BackgroundTransparency = 1.000
				LoadConfig.BorderColor3 = Color3.fromRGB(0, 0, 0)
				LoadConfig.BorderSizePixel = 0
				LoadConfig.ClipsDescendants = true
				LoadConfig.Size = UDim2.new(0, 20, 0, 18)
				LoadConfig.ZIndex = 153

				Icon_2.Name = NeverLose.RandomString();
				Icon_2.Parent = LoadConfig
				Icon_2.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Icon_2.BackgroundTransparency = 1.000
				Icon_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
				Icon_2.BorderSizePixel = 0
				Icon_2.Position = UDim2.new(0.5, 0, 0.5, 0)
				Icon_2.Size = UDim2.new(1, 0, 1, 0)
				Icon_2.ZIndex = 153
				Icon_2.FontFace = NeverLose.BuiltInBold
				Icon_2.Text = "arrow-right-from-portrait-rectangle"
				Icon_2.TextColor3 = Color3.fromRGB(223, 223, 223)
				Icon_2.TextSize = 16.000
				Icon_2.TextTransparency = 0.400
				Icon_2.TextWrapped = true

				UICorner_2.CornerRadius = UDim.new(0, 4)
				UICorner_2.Parent = LoadConfig

				UICorner_3.CornerRadius = UDim.new(0, 5)
				UICorner_3.Parent = ConfigItemFrame

				BasedLabel.Name = NeverLose.RandomString();
				BasedLabel.Parent = ConfigItemFrame
				BasedLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				BasedLabel.BackgroundTransparency = 1.000
				BasedLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				BasedLabel.BorderSizePixel = 0
				BasedLabel.Position = UDim2.new(0, 11, 0, 7)
				BasedLabel.Size = UDim2.new(0, 1, 0, 15)
				BasedLabel.ZIndex = 153
				BasedLabel.Font = Enum.Font.GothamMedium
				BasedLabel.Text = ConfigNameStr
				BasedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				BasedLabel.TextSize = 13.000
				BasedLabel.TextTransparency = 0.200
				BasedLabel.TextXAlignment = Enum.TextXAlignment.Left

				UIStroke.Transparency = 0.500
				UIStroke.Color = Color3.fromRGB(45, 48, 58)
				UIStroke.Parent = ConfigItemFrame

				local Render = LPH_NO_VIRTUALIZE(function(rst)
					if rst then
						NeverLose.PlayAnimate(ConfigItemFrame,SlowyTween,{
							BackgroundTransparency = 0
						})

						NeverLose.PlayAnimate(Icon,SlowyTween,{
							TextTransparency = 0.400
						})

						NeverLose.PlayAnimate(Icon_2,SlowyTween,{
							TextTransparency = 0.400
						})

						NeverLose.PlayAnimate(BasedLabel,SlowyTween,{
							TextTransparency = 0.200
						})

						NeverLose.PlayAnimate(UIStroke,SlowyTween,{
							Transparency = 0.500
						})
					else
						NeverLose.PlayAnimate(ConfigItemFrame,SlowyTween,{
							BackgroundTransparency = 1
						})

						NeverLose.PlayAnimate(Icon,SlowyTween,{
							TextTransparency = 1
						})

						NeverLose.PlayAnimate(Icon_2,SlowyTween,{
							TextTransparency = 1
						})

						NeverLose.PlayAnimate(BasedLabel,SlowyTween,{
							TextTransparency = 1
						})

						NeverLose.PlayAnimate(UIStroke,SlowyTween,{
							Transparency = 1
						})
					end;
				end)

				Render(ConfigSignal:GetValue());
				table.insert(ConfigLib.Signals , ConfigSignal:Connect(Render));

				table.insert(ConfigLib.Signals , ConfigItemFrame.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.25
					})
				end)));

				table.insert(ConfigLib.Signals , ConfigItemFrame.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(UIStroke,SlowyTween,{
						Transparency = 0.500
					})
				end)));

				local deleter,signal = NeverLose:CreateInput(DeleteConfig,function()
					if ConfigNameStr == "Default" then
						Logging.new("trash-can","You can't delete default config!",3.5)
						return;
					end;
					
					delfile(Window.ConfigFolder..'/'..ConfigNameStr);

					UpdateSize();

					ConfigLib:RefreshConfig();

					Logging.new("trash-can",'Deleted '..tostring(ConfigNameStr),3.5)
				end);


				local _,load_signal = NeverLose:CreateInput(LoadConfig,function()
					local path = Window.ConfigFolder..'/'..ConfigNameStr;

					if isfile(path) then
						local data = readfile(path);

						ConfigLib:LoadData(data);

						ConfigLib.SelectedConfig = ConfigNameStr;
						ConfigName.Text = ConfigNameStr;

						UpdateSize();

						ConfigLib:RefreshConfig();

						Logging.new("folder",'Loaded '..tostring(ConfigNameStr),3.5)
					end
				end);

				table.insert(ConfigLib.Signals , signal);
				table.insert(ConfigLib.Signals , load_signal);

				table.insert(ConfigLib.Signals , deleter.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(Icon,SlowyTween,{
						TextTransparency = 0.2,
						TextColor3 = Color3.fromRGB(223, 125, 125)
					})
				end)))

				table.insert(ConfigLib.Signals , deleter.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(Icon,SlowyTween,{
						TextTransparency = 0.400,
						TextColor3 = Color3.fromRGB(223, 223, 223)
					})
				end)))

				table.insert(ConfigLib.Signals , LoadConfig.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(Icon_2,SlowyTween,{
						TextTransparency = 0.2,
						TextColor3 = NeverLose.AccentColor
					})
				end)))

				table.insert(ConfigLib.Signals , LoadConfig.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
					NeverLose.PlayAnimate(Icon_2,SlowyTween,{
						TextTransparency = 0.400,
						TextColor3 = Color3.fromRGB(223, 223, 223)
					})
				end)))
			end;

			table.clear(ConfigList);
		end;
		
		task.delay(1,function()
			if not NeverLose.Alive then return end;
			if ConfigLib.SelectedConfig == "Default" then
				local path = Window.ConfigFolder..'/Default';
				local ConfigNameStr = "Default";
				
				if isfile(path) then
					local data = readfile(path);

					ConfigLib:LoadData(data);

					ConfigLib.SelectedConfig = ConfigNameStr;
					ConfigName.Text = ConfigNameStr;

					UpdateSize();

					ConfigLib:RefreshConfig();

					Logging.new("folder","Loaded Default Config",3.5);
					
					task.spawn(function()
						while NeverLose.Alive do task.wait(5.75);
							if NeverLose.Alive and NeverLose.AutoSave ~= false and isfile(path) and ConfigLib.SelectedConfig == "Default" then
								writefile(Window.ConfigFolder..'/Default',ConfigLib:GetData(true));
							end;
						end;
					end);
				end;
			end;
		end);

		local hover_write = NeverLose:CreateInput(ConfigIcon,function()
			local path = Window.ConfigFolder..'/'..(ConfigLib.SelectedConfig or "Default");

			if isfile(path) then
				writefile(Window.ConfigFolder..'/'..(ConfigLib.SelectedConfig or "Default"),ConfigLib:GetData());

				Logging.new("folder",'Saved '..tostring(ConfigLib.SelectedConfig),3.5)
			end;
		end);

		NeverLose:AddSignal(hover_write.MouseEnter:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(ConfigIcon,SlowyTween,{
				TextTransparency = 0.1
			})
		end)));

		NeverLose:AddSignal(hover_write.MouseLeave:Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(ConfigIcon,SlowyTween,{
				TextTransparency = 0.25
			})
		end)));


		local mv = NeverLose:CreateInput(LoadConfig , function()
			local cfg_name = TextBox.Text;

			if cfg_name and cfg_name:byte() and not cfg_name:find('/',1,true) and not cfg_name:find('\\',1,true) then
				cfg_name = string.sub(cfg_name , 1 , 24);

				writefile(Window.ConfigFolder..'/'..cfg_name,ConfigLib:GetData());
				ConfigLib.SelectedConfig = cfg_name;
				ConfigName.Text = cfg_name;

				Logging.new("folder",'Created '..tostring(cfg_name),3.5)

				TextBox.Text = "";

				UpdateSize();

				ConfigLib:RefreshConfig();
			end;
		end);

		NeverLose:AddSignal(mv.MouseEnter:Connect(function()
			NeverLose.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.1
			})
		end))

		NeverLose:AddSignal(mv.MouseLeave:Connect(function()
			NeverLose.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.35
			})
		end))

		ConfigLib:RefreshConfig();

		OpenButton.MouseButton1Click:Connect(LPH_NO_VIRTUALIZE(function()
			if ConfigLib.UnsafeThread then
				ConfigLib.UnsafeThread:Disconnect();
				ConfigLib.UnsafeThread = nil;
			end;

			ConfigSignal:SetValue(true);

			ConfigLib.UnsafeThread = UserInputService.InputBegan:Connect(function(Input)
				if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
					if not NeverLose:IsMouseOverFrame(ConfigMenu) then
						if ConfigLib.UnsafeThread then
							ConfigLib.UnsafeThread:Disconnect();
							ConfigLib.UnsafeThread = nil;
						end;

						ConfigSignal:SetValue(false);
					end;
				end;
			end)
		end));

		return ConfigLib;
	end;

	Window.Config = Window:_InitConfig();

	local UserSettings = NeverLose:CreateOptionWindow(BottomFrame , BottomFrame.ZIndex + 13);
	local reciveSignal;
	NeverLose:CreateInput(BottomFrame , LPH_NO_VIRTUALIZE(function()
		if reciveSignal then
			reciveSignal:Disconnect();
			reciveSignal = nil;	
		end;

		UserSettings.Signal:SetValue(true);

		reciveSignal = UserInputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if not NeverLose:IsMouseOverFrame(UserSettings.Root) and not NeverLose:IsMouseOverFrame(BottomFrame) and not NeverLose.IsMosueOverOtherFrame then
					if reciveSignal then
						reciveSignal:Disconnect();
						reciveSignal = nil;	
					end;

					UserSettings.Signal:SetValue(false);
				end
			end
		end);
	end))

	Window.UserSettings = UserSettings;

	function Window:SetAccount(Config)
		Config = NeverLose:ProcessParams(Config , {
			Profile = NeverLose.UserProfile,
			Username = LocalPlayer.DisplayName,
			Expires = "Never",
		});

		AccountName.Text = Config.Username;
		AccountProfile.Image = Config.Profile;
		ExpireLabel.Text = Config.Expires;

		Window.Username = Config.Username or Window.Username;
		Window.Profile = Config.Profile or Window.Profile;
		Window.Expires = Config.Expires or Window.Expires;

		if Window.UserSettings.UserFrame then
			Window.UserSettings.UserFrame:SetUsername(Window.Username);
			Window.UserSettings.UserFrame:SetProfile(Window.Profile);
			Window.UserSettings.UserFrame:SetExpires(Window.Expires);
		else
			Window.UserSettings.UserFrame = UserSettings:AddUserFrame(Window.Username , Window.Profile , Window.Expires);
		end;
	end;

	function Window:SetSize(newsize)
		Window.Size = newsize;

		if Window.Signal:GetValue() then
			NeverLose.PlayAnimate(WindowFrame , VSlowTween , {
				Size = Window.Size
			})
		end
	end;

	Window:SetAccount();

	NeverLose:AddSignal(UserInputService.InputBegan:Connect(LPH_NO_VIRTUALIZE(function(value,ISTYPING)
		if value.KeyCode == Window.Keybind or value.KeyCode.Name == Window.Keybind then
			if not ISTYPING then
				Window:ToggleInterface()
			end
		end;
	end)));

	function Window:ToggleInterface()
		Window.Signal:SetValue(not Window.Signal:GetValue());

		if Window.__3DRender then
			Window.Load3DBlock();
		end;
	end;

	function Window:Watermark()
		if NeverLose.__WatermarkCache then
			return NeverLose.__WatermarkCache;
		end;

		local Watermark_lb = {};
		local Watermark = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIListLayout = Instance.new("UIListLayout")
		local Shadow = NeverLose:CreateShadow(Watermark);

		Watermark.Name = NeverLose.RandomString();
		Watermark.Parent = NeverLose.ScreenGui
		Watermark.AnchorPoint = Vector2.new(1, 0)
		Watermark.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
		Watermark.BackgroundTransparency = 0.200
		Watermark.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Watermark.BorderSizePixel = 0
		Watermark.ClipsDescendants = true
		Watermark.Position = UDim2.new(1, -10, 0, 10)
		Watermark.Size = UDim2.new(0, 120, 0, 30)
		Watermark.ZIndex = 16

		UICorner.CornerRadius = UDim.new(0, 25)
		UICorner.Parent = Watermark

		UIListLayout.Parent = Watermark
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right

		local empty_space = Instance.new('Frame');

		empty_space.Size = UDim2.fromOffset(15,0);
		empty_space.BackgroundTransparency = 1;
		empty_space.Parent = Watermark;
		empty_space.LayoutOrder = 5;

		Watermark:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if Watermark.BackgroundTransparency > 0.9 then
				Watermark.Visible = false;
				Watermark.Parent = nil;
			else
				Watermark.Parent = NeverLose.ScreenGui
				Watermark.Visible = true;
			end;
		end));

		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(LPH_NO_VIRTUALIZE(function()
			NeverLose.PlayAnimate(Watermark , SlowyTween , {
				Size = UDim2.new(0, UIListLayout.AbsoluteContentSize.X + 5, 0, 30)
			})
		end));

		NeverLose.__WatermarkCache = Watermark_lb;

		Shadow:Render(true);

		Watermark_lb.Renders = {};
		Watermark_lb.Status = true;

		function Watermark_lb:SetRender(value)
			Watermark_lb.Status = value;

			if value then
				NeverLose.PlayAnimate(Watermark,SlowyTween , {
					BackgroundTransparency = 0.200
				})

				Shadow:Render(true);

				for i,v in next , Watermark_lb.Renders do
					pcall(v,true);
				end;
			else
				NeverLose.PlayAnimate(Watermark,SlowyTween , {
					BackgroundTransparency = 1
				})

				Shadow:Render(false);

				for i,v in next , Watermark_lb.Renders do
					pcall(v,false);
				end;
			end
		end;

		function Watermark_lb:AddBlock(IconStr , Name)
			local InnerBlock = {};

			local Frame = Instance.new("Frame")
			local Content = Instance.new("TextLabel")
			local Icon = Instance.new("TextLabel")

			Frame.Parent = Watermark
			Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Frame.BackgroundTransparency = 1.000
			Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Frame.BorderSizePixel = 0
			Frame.Size = UDim2.new(0, 50, 0, 30)

			Content.Name = NeverLose.RandomString();
			Content.Parent = Frame
			Content.AnchorPoint = Vector2.new(0, 0.5)
			Content.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
			Content.BackgroundTransparency = 1.000
			Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Content.BorderSizePixel = 0
			Content.Position = UDim2.new(0, 35, 0.5, 0)
			Content.Size = UDim2.new(0, 1, 0, 25)
			Content.ZIndex = 17
			Content.Font = Enum.Font.GothamBold
			Content.Text = Name
			Content.TextColor3 = Color3.fromRGB(186, 186, 186)
			Content.TextSize = 15.000
			Content.TextTransparency = 0.200
			Content.TextXAlignment = Enum.TextXAlignment.Left

			Icon.Name = NeverLose.RandomString();
			Icon.Parent = Frame
			Icon.AnchorPoint = Vector2.new(0, 0.5)
			Icon.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
			Icon.BackgroundTransparency = 1.000
			Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Icon.BorderSizePixel = 0
			Icon.Position = UDim2.new(0, 10, 0.5, 0)
			Icon.Size = UDim2.new(0, 20, 0, 20)
			Icon.ZIndex = 17
			Icon.FontFace = NeverLose.BuiltInBold;
			Icon.Text = IconStr
			Icon.TextColor3 = NeverLose.AccentColor
			Icon.TextSize = 18.000
			Icon.TextTransparency = 0.250
			Icon.TextWrapped = true

			InnerBlock.Update = LPH_NO_VIRTUALIZE(function(value)
				local size = TextService:GetTextSize(Content.Text , Content.TextSize,Content.Font,Vector2.new(math.huge,math.huge))

				if InnerBlock.Visible then
					NeverLose.PlayAnimate(Frame,VSlowTween,{
						Size = UDim2.new(0, size.X + 35, 0, 30)
					})
				else
					NeverLose.PlayAnimate(Frame,VSlowTween,{
						Size = UDim2.new(0, 0, 0, 30)
					})
				end;
			end);

			InnerBlock.Visible = true;

			InnerBlock.Update();

			function InnerBlock:SetVisible(v)
				InnerBlock.Visible = v;

				if Watermark_lb.Status then
					InnerBlock.SetRender(v);
				end;

				InnerBlock.Update();
			end;

			InnerBlock.SetRender = LPH_NO_VIRTUALIZE(function(value)
				if value and InnerBlock.Visible then
					NeverLose.PlayAnimate(Content,SlowyTween , {
						TextTransparency = 0.200
					})

					NeverLose.PlayAnimate(Icon,SlowyTween , {
						TextTransparency = 0.250
					})
				else

					NeverLose.PlayAnimate(Content,SlowyTween , {
						TextTransparency = 1
					})

					NeverLose.PlayAnimate(Icon,SlowyTween , {
						TextTransparency = 1
					})
				end;
			end);

			table.insert(Watermark_lb.Renders,InnerBlock.SetRender);

			function InnerBlock:SetText(t)
				Content.Text = t;

				InnerBlock.Update();
			end;

			function InnerBlock:Input(func)
				local c,s = NeverLose:CreateInput(Frame,func);

				return s;
			end;

			return InnerBlock;
		end;

		return Watermark_lb;
	end;

	Window:SetRender(false);

	return Window;
end;

function NeverLose:CreateNotification()
	if NeverLose.__Notification_Cache then
		return NeverLose.__Notification_Cache;
	end;

	local Notifier = {};
	local Notification = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Notification.Name = NeverLose.RandomString();
	Notification.Parent = NeverLose.ScreenGui;
	Notification.AnchorPoint = Vector2.new(1, 0)
	Notification.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Notification.BackgroundTransparency = 1.000
	Notification.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Notification.BorderSizePixel = 0
	Notification.Position = UDim2.new(1, -25, 0, 25)
	Notification.Size = UDim2.new(0, 25, 0, 25)

	UIListLayout.Parent = Notification
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 0)

	NeverLose.__Notification_Cache = Notifier;

	function Notifier.new(Config)
		Config = NeverLose:ProcessParams(Config , {
			Title = "Notification",
			Content = "Hello World!",
			Logo = NeverLose.GlobalLogo or "rbxasset://textures/ui/VerifiedBadgeNameIcon.png",
			Duration = 5,
		});

		if NeverLose.__WatermarkCache then
			NeverLose.PlayAnimate(Notification,SlowyTween , {
				Position = UDim2.new(1, -25, 0, 55)
			});
		end;

		local ContainerFrame = Instance.new("Frame")
		local NotifyFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local LogoImage = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local NotifyName = Instance.new("TextLabel")
		local NotifyContent = Instance.new("TextLabel");
		local shadow = NeverLose:CreateShadow(NotifyFrame , true);

		ContainerFrame.Name = NeverLose.RandomString();
		ContainerFrame.Parent = Notification
		ContainerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ContainerFrame.BackgroundTransparency = 1.000
		ContainerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ContainerFrame.BorderSizePixel = 0
		ContainerFrame.Size = UDim2.new(0, 0, 0, 100)

		NotifyFrame.Name = NeverLose.RandomString();
		NotifyFrame.Parent = ContainerFrame
		NotifyFrame.AnchorPoint = Vector2.new(1, 0)
		NotifyFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		NotifyFrame.BackgroundTransparency = 0.075
		NotifyFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyFrame.BorderSizePixel = 0
		NotifyFrame.ClipsDescendants = true
		NotifyFrame.Position = UDim2.new(0, 750, 0, 0)
		NotifyFrame.Size = UDim2.new(0, 220, 0, 55)
		NotifyFrame.ZIndex = 130

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = NotifyFrame

		UIStroke.Transparency = 0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = NotifyFrame

		LogoImage.Name = NeverLose.RandomString();
		LogoImage.Parent = NotifyFrame
		LogoImage.AnchorPoint = Vector2.new(0, 0.5)
		LogoImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LogoImage.BackgroundTransparency = 1.000
		LogoImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogoImage.BorderSizePixel = 0
		LogoImage.Position = UDim2.new(0, 10, 0.5, 0)
		LogoImage.Size = UDim2.new(0, 35, 0, 35)
		LogoImage.ZIndex = 131
		LogoImage.Image = Config.Logo
		LogoImage.ImageColor3 = NeverLose.IconColor;

		UICorner_2.CornerRadius = UDim.new(0, 7)
		UICorner_2.Parent = LogoImage

		NotifyName.Name = NeverLose.RandomString();
		NotifyName.Parent = NotifyFrame
		NotifyName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyName.BackgroundTransparency = 1.000
		NotifyName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyName.BorderSizePixel = 0
		NotifyName.Position = UDim2.new(0, 50, 0, 7)
		NotifyName.Size = UDim2.new(0, 200, 0, 20)
		NotifyName.ZIndex = 132
		NotifyName.Font = Enum.Font.GothamBold
		NotifyName.Text = Config.Title
		NotifyName.TextColor3 = Color3.fromRGB(255, 255, 255)
		NotifyName.TextSize = 17.000
		NotifyName.TextXAlignment = Enum.TextXAlignment.Left

		NotifyContent.Name = NeverLose.RandomString();
		NotifyContent.Parent = NotifyFrame
		NotifyContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		NotifyContent.BackgroundTransparency = 1.000
		NotifyContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NotifyContent.BorderSizePixel = 0
		NotifyContent.Position = UDim2.new(0, 50, 0, 28)
		NotifyContent.Size = UDim2.new(0, 200, 0, 15)
		NotifyContent.ZIndex = 132
		NotifyContent.Font = Enum.Font.GothamBold
		NotifyContent.Text = Config.Content
		NotifyContent.TextColor3 = Color3.fromRGB(255, 255, 255)
		NotifyContent.TextSize = 12.000
		NotifyContent.TextTransparency = 0.650
		NotifyContent.TextXAlignment = Enum.TextXAlignment.Left

		local Size1 = TextService:GetTextSize(NotifyName.Text,NotifyName.TextSize,NotifyName.Font,Vector2.new(math.huge,math.huge));
		local Size2 = TextService:GetTextSize(NotifyContent.Text,NotifyContent.TextSize,NotifyContent.Font,Vector2.new(math.huge,math.huge));

		local MainSize = math.max(Size1.X , Size2.X);

		NotifyFrame.Size = UDim2.new(0, MainSize + 65, 0, 55);

		shadow:Render(true)
		NeverLose.PlayAnimate(NotifyFrame , VSlowTween , {
			Position = UDim2.new(1, 0, 0, 0)
		})

		ContainerFrame.Size = UDim2.new(0, 0, 0, 65)

		task.delay(Config.Duration or 5 , LPH_NO_VIRTUALIZE(function()

			if NeverLose.__WatermarkCache then
				NeverLose.PlayAnimate(Notification,SlowyTween , {
					Position = UDim2.new(1, -25, 0, 55)
				});
			end;

			shadow:Render(false)

			NeverLose.PlayAnimate(NotifyFrame , SlowyTween , {
				BackgroundTransparency = 1
			})

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			})

			NeverLose.PlayAnimate(LogoImage , SlowyTween , {
				ImageTransparency = 1
			})

			NeverLose.PlayAnimate(NotifyName , SlowyTween , {
				TextTransparency = 1
			})

			NeverLose.PlayAnimate(NotifyContent , SlowyTween , {
				TextTransparency = 1
			})

			task.wait(0.125);

			NeverLose.PlayAnimate(ContainerFrame , SlowyTween , {
				Size = UDim2.new(0, 0, 0, 0)
			})

			task.wait(0.125);

			ContainerFrame:Destroy();
		end))
	end;

	return Notifier;
end;

function NeverLose:CreateLogger()
	if NeverLose.__LogSystem then
		return 	NeverLose.__LogSystem;
	end;

	local Logging = {};
	local Log = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Log.Name = NeverLose.RandomString();
	Log.Parent = NeverLose.ScreenGui
	Log.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Log.BackgroundTransparency = 1.000
	Log.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Log.BorderSizePixel = 0
	Log.Position = UDim2.new(0, 25, 0, 5 + math.abs(NeverLose.ScreenGui.AbsolutePosition.Y))
	Log.Size = UDim2.new(0, 25, 0, 25)

	UIListLayout.Parent = Log
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 12)

	NeverLose.__LogSystem = Logging;

	function Logging.new(IconStr: string , Message: string , Duration: number)
		Duration = Duration or 3;
		Message = Message or "Log";
		IconStr = IconStr or "crosshairs";

		local LogFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local LogContent = Instance.new("TextLabel")
		local Line = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local Icon = Instance.new("TextLabel")
		local Shadow = NeverLose:CreateShadow(LogFrame , true);

		LogFrame.Name = NeverLose.RandomString();
		LogFrame.Parent = Log
		LogFrame.AnchorPoint = Vector2.new(0.5, 0)
		LogFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 27)
		LogFrame.BackgroundTransparency =  1--0.075
		LogFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogFrame.BorderSizePixel = 0
		LogFrame.ClipsDescendants = true
		LogFrame.Position = UDim2.new(0,0,0,0)
		LogFrame.Size = UDim2.new(0, 0, 0, 20)
		LogFrame.ZIndex = 130

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = LogFrame

		UIStroke.Transparency = 1--0.650
		UIStroke.Color = Color3.fromRGB(45, 48, 58)
		UIStroke.Parent = LogFrame

		LogContent.Name = NeverLose.RandomString();
		LogContent.Parent = LogFrame
		LogContent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LogContent.BackgroundTransparency = 1.000
		LogContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LogContent.BorderSizePixel = 0
		LogContent.Position = UDim2.new(0, 25, 0, 2)
		LogContent.Size = UDim2.new(0, 200, 0, 15)
		LogContent.ZIndex = 132
		LogContent.Font = Enum.Font.GothamBold
		LogContent.Text = Message
		LogContent.TextColor3 = Color3.fromRGB(255, 255, 255)
		LogContent.TextSize = 12.000
		LogContent.TextTransparency = 1--0.250
		LogContent.TextXAlignment = Enum.TextXAlignment.Left

		Line.Name = NeverLose.RandomString();
		Line.Parent = LogFrame
		Line.AnchorPoint = Vector2.new(0, 0.5)
		Line.BackgroundColor3 = NeverLose.AccentColor
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BackgroundTransparency = 1 --0
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, -2, 0.5, 0)
		Line.Size = UDim2.new(0, 5, 1, 0)
		Line.ZIndex = 131

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = Line

		Icon.Name = NeverLose.RandomString();
		Icon.Parent = LogFrame
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 7, 0, 3)
		Icon.Size = UDim2.new(0, 15, 0, 15)
		Icon.ZIndex = 133
		Icon.FontFace = NeverLose.BuiltInBold
		Icon.Text = IconStr
		Icon.TextColor3 = Color3.fromRGB(223, 223, 223)
		Icon.TextSize = 13.000
		Icon.TextTransparency = 1--0.250
		Icon.TextWrapped = true

		local size = TextService:GetTextSize(LogContent.Text,LogContent.TextSize,LogContent.Font,Vector2.new(math.huge,math.huge));

		NeverLose.PlayAnimate(LogFrame , SlowyTween , {
			Size = UDim2.new(0, size.X + 35, 0, 20),
			BackgroundTransparency =  0.075
		});

		task.delay(0.15,LPH_NO_VIRTUALIZE(function()
			Shadow:Render(true);

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 0.650
			});

			NeverLose.PlayAnimate(LogContent , SlowyTween , {
				TextTransparency = 0.25
			});

			NeverLose.PlayAnimate(Line , SlowyTween , {
				BackgroundTransparency = 0
			});

			NeverLose.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 0.25
			});

			task.wait(Duration + 0.1);

			Shadow:Render(false);

			NeverLose.PlayAnimate(LogFrame , SlowyTween , {
				BackgroundTransparency =  1
			});

			NeverLose.PlayAnimate(UIStroke , SlowyTween , {
				Transparency = 1
			});

			NeverLose.PlayAnimate(LogContent , SlowyTween , {
				TextTransparency = 1
			});

			NeverLose.PlayAnimate(Line , SlowyTween , {
				BackgroundTransparency = 1
			});

			NeverLose.PlayAnimate(Icon , SlowyTween , {
				TextTransparency = 1
			});

			task.wait(0.25);

			LogFrame:Destroy();
		end))
	end;

	return Logging
end;

function NeverLose:CreateIndicator()
	local IndicatorFrame = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	IndicatorFrame.Name = NeverLose.RandomString();
	IndicatorFrame.Parent = NeverLose.ScreenGui;
	IndicatorFrame.AnchorPoint = Vector2.new(0, 0.5)
	IndicatorFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	IndicatorFrame.BackgroundTransparency = 1.000
	IndicatorFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	IndicatorFrame.BorderSizePixel = 0
	IndicatorFrame.Position = UDim2.new(0, 15, 0.5, 0)
	IndicatorFrame.Size = UDim2.new(0, 100, 0, 100)
	IndicatorFrame.ZIndex = 15

	UIListLayout.Parent = IndicatorFrame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 10)

	local Indicators = {};

	Indicators.Color = {
		Red = Color3.fromRGB(255, 102, 105),
		Green = Color3.fromRGB(135, 255, 143),
		White = Color3.fromRGB(186, 186, 186),
	};

	Indicators.Root = IndicatorFrame;

	function Indicators.new(Config)
		Config = NeverLose:ProcessParams(Config , {
			Name = "Indicator",
			Icon = 'crosshairs',
			Color = 'Red',
		});

		local Indicator = {
			CurrentColor = Config.Color,	
			Visible = false,
		};

		local IndicatorItem = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Line = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIGradient = Instance.new("UIGradient")
		local Icon = Instance.new("TextLabel")
		local Content = Instance.new("TextLabel")
		local Shadow = NeverLose:CreateShadow(IndicatorItem);

		IndicatorItem.Name = NeverLose.RandomString();
		IndicatorItem.BackgroundColor3 = Color3.fromRGB(8, 8, 13)
		IndicatorItem.BackgroundTransparency = 1
		IndicatorItem.BorderColor3 = Color3.fromRGB(0, 0, 0)
		IndicatorItem.BorderSizePixel = 0
		IndicatorItem.ClipsDescendants = true
		IndicatorItem.Size = UDim2.new(0, 85, 0, 40)
		IndicatorItem.ZIndex = 16
		IndicatorItem.Visible = false;

		IndicatorItem:GetPropertyChangedSignal('BackgroundTransparency'):Connect(LPH_NO_VIRTUALIZE(function()
			if IndicatorItem.BackgroundTransparency > 0.9 then
				IndicatorItem.Parent = nil;
				IndicatorItem.Visible = false;
			else
				IndicatorItem.Parent = IndicatorFrame;
				IndicatorItem.Visible = true;
			end;
		end))

		UICorner.CornerRadius = UDim.new(0, 25)
		UICorner.Parent = IndicatorItem

		Line.Name = NeverLose.RandomString();
		Line.Parent = IndicatorItem
		Line.AnchorPoint = Vector2.new(0, 0.5)
		Line.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(0, 2, 0.5, 0)
		Line.BackgroundTransparency = 1;
		Line.Size = UDim2.new(0, 3, 0.649999976, 0)
		Line.ZIndex = 17

		UICorner_2.CornerRadius = UDim.new(0, 25)
		UICorner_2.Parent = Line

		UIGradient.Rotation = 90
		UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(0.50, 0.00), NumberSequenceKeypoint.new(1.00, 1.00)}
		UIGradient.Parent = Line

		Icon.Name = NeverLose.RandomString();
		Icon.Parent = IndicatorItem
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 10, 0.5, 0)
		Icon.Size = UDim2.new(0, 25, 0, 25)
		Icon.ZIndex = 17
		Icon.FontFace = NeverLose.BuiltInBold;
		Icon.Text = Config.Icon
		Icon.TextColor3 = Color3.fromRGB(186, 186, 186)
		Icon.TextSize = 21.000
		Icon.TextTransparency = 1
		Icon.TextWrapped = true

		Content.Name = NeverLose.RandomString();
		Content.Parent = IndicatorItem
		Content.AnchorPoint = Vector2.new(0, 0.5)
		Content.BackgroundColor3 = Color3.fromRGB(186, 186, 186)
		Content.BackgroundTransparency = 1.000
		Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Content.BorderSizePixel = 0
		Content.Position = UDim2.new(0, 40, 0.5, 0)
		Content.Size = UDim2.new(1, -40, 0, 25)
		Content.ZIndex = 17
		Content.Font = Enum.Font.GothamBold
		Content.Text = Config.Name
		Content.TextColor3 = Color3.fromRGB(186, 186, 186)
		Content.TextSize = 20.000
		Content.TextTransparency = 1
		Content.TextXAlignment = Enum.TextXAlignment.Left

		Indicator.Update = LPH_NO_VIRTUALIZE(function()
			local text = TextService:GetTextSize(Content.Text,Content.TextSize , Content.Font , Vector2.new(math.huge,math.huge));

			NeverLose.PlayAnimate(IndicatorItem , SlowyTween , {
				Size = UDim2.new(0, text.X + 60, 0, 40);
			})
		end);

		Indicator.SetRender = LPH_NO_VIRTUALIZE(function(self , value)
			Indicator.Visible = value;

			if value then
				NeverLose.PlayAnimate(IndicatorItem , SlowyTween , {
					BackgroundTransparency = 0.200
				});

				NeverLose.PlayAnimate(Line , SlowyTween , {
					BackgroundTransparency = 0,
					BackgroundColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				NeverLose.PlayAnimate(Icon , VSlowTween , {
					TextTransparency = 0.250,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				NeverLose.PlayAnimate(Content , VSlowTween , {
					TextTransparency = 0.2,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				Shadow:Render(true);
			else
				NeverLose.PlayAnimate(IndicatorItem , SlowyTween , {
					BackgroundTransparency = 1
				});

				NeverLose.PlayAnimate(Line , SlowyTween , {
					BackgroundTransparency = 1,
					BackgroundColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				NeverLose.PlayAnimate(Icon , VSlowTween , {
					TextTransparency = 1,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				NeverLose.PlayAnimate(Content , VSlowTween , {
					TextTransparency = 1,
					TextColor3 = Indicators.Color[Indicator.CurrentColor]
				});

				Shadow:Render(false);
			end;

			Indicator.Update();
		end);

		Indicator.Update();
		Indicator:SetRender(false);

		function Indicator:SetColor(new_color)
			Indicator.CurrentColor = new_color;

			if Indicator.Visible then
				Indicator:SetRender(true);
			end;
		end;

		function Indicator:SetText(name)
			Config.Name = name;

			Content.Text = Config.Name;

			Indicator.Update();
		end;

		return Indicator;
	end;

	return Indicators;
end;

function NeverLose:Unload()
	if not NeverLose.UnloadEnabled then
		return;	
	end;

	NeverLose.ScreenGui:Destroy();

	for i,v in next , NeverLose.GlobalSignals do
		pcall(v.Disconnect,v)
	end;
end;

return NeverLose;

end)()
Library.UnloadEnabled=true
Library.Alive=true
Library.AutoSave=true
local initializeUI=function(Library)
 local UIS=game:GetService("UserInputService")
 local TextService=game:GetService("TextService")
 local S={Alive=true,Connections={},Pickers={},Options={},Sliders={},Dropdowns={},Drag=nil,ActivePicker=nil,ActiveOption=nil,ActiveDropdown=nil}
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
  if S.ActiveDropdown then S.ActiveDropdown.SetFrameRender(false)end
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
  if S.ActiveDropdown and inside(S.ActiveDropdown.BlockRoot,p)then return end
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
    if S.ActiveDropdown then S.ActiveDropdown.SetFrameRender(false)end
    if S.ActivePicker then S.ActivePicker.SetRender(false)end
    S.ActiveOption=o;root.Parent=Library.ScreenGui;root.Visible=true;shadow:Render(true);resize()
   else
    if S.ActiveOption==o then S.ActiveOption=nil end
    if S.ActivePicker and S.ActivePicker.Anchor:IsDescendantOf(root)then S.ActivePicker.SetRender(false)end
    if S.ActiveDropdown and S.ActiveDropdown.Root:IsDescendantOf(root)then S.ActiveDropdown.SetFrameRender(false)end
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
  local addDropdown=h.AddDropdown
  function h:AddDropdown(config)
   local d=addDropdown(self,config)
   local render=d.SetFrameRender
   local placing=false
   local function reposition()
    if placing or not S.Alive or not d.OpenSignal:GetValue()or not d.Root.Parent then return end
    placing=true
    local viewport=workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280,720)
    local width=math.min(math.max(d.Root.AbsoluteSize.X,d.ExtentSize+35),math.max(80,viewport.X-16))
    local height=math.min(d.BlockRoot.Size.Y.Offset,math.max(30,viewport.Y-16))
    local pos=d.Root.AbsolutePosition
    local y=pos.Y+d.Root.AbsoluteSize.Y+4
    if y+height>viewport.Y-8 then y=pos.Y-height-4 end
    d.BlockRoot.AnchorPoint=Vector2.zero
    d.BlockRoot.Size=UDim2.fromOffset(width,height)
    d.BlockRoot.Position=UDim2.fromOffset(math.clamp(pos.X,8,math.max(8,viewport.X-width-8)),math.clamp(y,8,math.max(8,viewport.Y-height-8)))
    placing=false
   end
   d.SetFrameRender=function(value)
    if value then
     if S.ActiveDropdown and S.ActiveDropdown~=d then S.ActiveDropdown.SetFrameRender(false)end
     S.ActiveDropdown=d
    else
     if S.ActiveDropdown==d then S.ActiveDropdown=nil end
     Library.IsMosueOverOtherFrame=false
     if d.DisconnectInput then d.DisconnectInput()end
    end
    render(value)
    if value then reposition();task.defer(reposition)end
   end
   connect(d.BlockRoot:GetPropertyChangedSignal("AbsoluteSize"),reposition)
   signal:Connect(function(value)if not value then d.SetFrameRender(false)end end)
   table.insert(S.Dropdowns,d);schedule();return d
  end
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
  for _,d in ipairs(self.Dropdowns)do d.BlockRoot:Destroy()end
  table.clear(self.Connections)
 end
 local unload=Library.Unload
 function Library:Unload()S:Destroy();return unload(self)end
 return S
end

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
local initializeESP=function(App,WhiteIcons)
 local Players=game:GetService("Players")
 local RunService=game:GetService("RunService")
 local LocalPlayer=Players.LocalPlayer
 assert(Drawing and Drawing.new,"Drawing API unavailable")
 local ESP={Alive=true,Enabled=false,Entries={},Connections={},ItemCatalog={},Settings={Box=true,Names=true,Distance=true,Health=true,HealthNumber=true,ItemName=true,ItemIcon=true,TeamCheck=false,FixedSize=false,MaxDistance=1800,TextSize=13,Color=Color3.fromRGB(225,233,245)},Stats={Visible=0,Tracked=0,Drawings=0,Icons=0,FrameMs=0,Errors=0}}
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
 function ESP:ProjectBounds(camera,entry,now)
  local viewport=camera.ViewportSize
  local rootFrame=entry.Root.CFrame
  local center=rootFrame:PointToWorldSpace(entry.Offset)
  local projected=camera:WorldToViewportPoint(center)
  if projected.Z<.5 then return nil end
  local radius=entry.Half.Magnitude*viewport.Y/(2*math.tan(math.rad(camera.FieldOfView)*.5)*math.max(.1,projected.Z-entry.Half.Magnitude))
  if projected.X+radius<0 or projected.X-radius>viewport.X or projected.Y+radius<0 or projected.Y-radius>viewport.Y then return nil end
  if now>=(entry.NextBounds or 0)then entry.NextBounds=now+.25;measure(entry)end
  -- Project only the body, excluding equipment and accessories.
  local minX,minY,maxX,maxY=math.huge,math.huge,-math.huge,-math.huge
  for _,sign in ipairs(CORNERS)do
   local point=camera:WorldToViewportPoint(rootFrame:PointToWorldSpace(entry.Offset+entry.Half*sign))
   if point.Z<.1 then return nil end
   minX=math.min(minX,point.X);minY=math.min(minY,point.Y)
   maxX=math.max(maxX,point.X);maxY=math.max(maxY,point.Y)
  end
  if maxX<0 or minX>viewport.X or maxY<0 or minY>viewport.Y then return nil end
  local x,y=floor(minX+.5),floor(minY+.5)
  local w,h=floor(maxX+.5)-x,floor(maxY+.5)-y
  if w<2 or h<5 or h>viewport.Y*2 then return nil end
  return x,y,w,h
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
   local x,y,w,h=self:ProjectBounds(camera,e,now)
   if not x then hide(e);continue end
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
 -- Consume the previous build's flag so old saved configs cannot re-enable fixed pixels.
 App.Library.Flags.player_esp_fixed_size={GetValue=function()return false end,SetValue=function()end}
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

initializeESP(App,{
 ["135031786336654"]="iVBORw0KGgoAAAANSUhEUgAAAFYAAAAjCAYAAAAOuf2FAAAACXBIWXMAAAPoAAAD6AG1e1JrAAAA+ElEQVRoge3YsQkCQRCF4QUxFazAxB6MLMMWbMHU0DoMrwwzazCxAuFSEX4RND5Pd5mZ3Tcw4cHux/EedwlIQXYPHByc46uNhPqZELjRUMPgRkQNgRsV1T1uZFTXuNFR3eLWgOoStxZUd7g1obrCrQ3VDW6NqC5wrWHTwA6N9fkEi2DRG6soQFGAogBFgaIARQGKAhQFigIUBSgKMP8cbeGTNkXdsQ/MgCPtTQfMS8GugAvtzhVY54SdADvgbn0zB/N4/+ed/gu7AE7Wt3E4Z2D5K+wGuFnfwPH0wHYMbKsFlbXYVFCFik0FVajYVFCFiu0Fq4Ii+/RPBeDs7qDMGG4AAAAASUVORK5CYII=",
 ["87740243479553"]="iVBORw0KGgoAAAANSUhEUgAAAEwAAAAwCAYAAAC7d5yRAAAACXBIWXMAAAPoAAAD6AG1e1JrAAAFaElEQVRoge2baawdYxjH555bW0MlqCVVKWlJGldEU4JqtCUkgpAgsXzRWEIlmn5BKkijhNgTFW3xwRKCRC2NKEWJth8siS2INWIJUkuL9p7zk/f2/zhP3jsz57h3zj1z7/gnkznzznveed7/edb3nZMkSZIAdwNfAcuAs4BJQE+SAaAHGAf0Wj+11fR5F2D3uH1MADiT7WjoCPgdeBVYAhwHzNV5EjA+ZYyaI2sysAH4AXgKOEbtRvDoJg94ViRt01FnMIzIzcBHwEvALcA8YA+NcwAwFXjZjYc0d6r69DiCRyd5wFsRYf0izRNYd6TF+BZYDfyk/n+572xVnx+BZ4BLgUM8UTLZXm/epQZwniZJRIqR5tsaKWT6e96s/Ti+7U9gLbAIOALYMcM/llP7JOBk+bI7pXF/pBBXz9Cy+H5en/7oftDAD4F7gNOAvUwmJ1+5tC8WRMIFAs8A7nPahyacR147aETjeATTXQVcDkxPka1m2tdVAp0fGefTBJ1nAQ9oMjiiGtKQoRJnY3jt8/gbeFvB5URg1xS5Tfu6R6DlTbEpAHsCFyqqfue0wxx8Eag77UsLLo8DNwCz4/TG+75ua9+/OZYB2E1CLwS+cdpSJPJMN+AL4CEFrf0zXEv3fJ8z2x5dW6J6AvB9h0jLis7eLViivQa4GpgB7BzJPqS8r1Cy2S7AQEoALJXgaabUaQJj3xeuPwDuVeTdOyYhTfucKzJyfZJdTIoD9Oq82AnbDTRytC+UaM8BC4BDTeaYxJS2UA9PLIQoQ3CyOl8wwhrWru+Lf8CQIr3jIu/AAoHmsI9++DuAy1T+rVeQm6c+taI07OYSEZYXeeOq5WtVHa84P2wB5j3gNuB54ImiCKvpvFwPsTqyrMiLvN6st7qq5Kaw/FW0hl2hh/anmIQ/hlMhdCpweNni+2EOvwDvhlRqWGR5KJKcAjwG/OwemCVoVm5VRpictydFgmYY3he4GHgQuB9YKSJDnvSJq03t1y07zC+/UDRhva1sHNgJ6FPetkmClJ00k29FoYSlJIa1+LD7Ok8BnpYw7Zpn1vJRJ2HPW2/LTyMKlEm767Bv0A5pRlaagx4p0q4bccIMkdaFXKeVeda15GOf47yqU/BL7a8l3QTNtGSWS0liEuw6BIuTgIuAT91kGlEQKYJEnxr58Wd2lbDIp4VNEqRFftKmdRtcKXa8SpxNKbXjcMw1bTn+V1UyoRo4Nuk2aJrldFee2K9rR8D5LtL6Rc11uv8l8AawJSJwKNrUr9IoLBdN0bNCZO9LygCapM0E3nQ+wyawRPf9kotp21Xqs1DXi9yk2yHLExu2Ch8F5kSBKTxvh9JsxKSQEbbfrgVuDTvu/n6K/7tGkz1V133/QbNs+edhlXf7RbKUZ7cqDVmLdRltRth8TfwSXR8dEZIF83XnRuMVt2A4Uog2YWotzPhAvcLwsbYHV8qPbWlDuza71xjKZXKdgDOdk4EXgY3A5/KD29ogLOzCH6wxRpdWDbMUM+LG6w2jw5SGeNPLMsk5+u6gpesxC5zpuui5vEW0tPYFNkZSNaDNXH2+sk3Clqn/wPcqB5rRbm4LkzTC1qj/2Hb4WXCmeRDwW+Tk03zYZ8CEypJGMwCEEur9HC3zZdC0SkXKHLNc1cKPGZGn++9VmbAbWxBm7YvVv/KO/5wWhFly+4gnusqOf0bKelmahm10Wllpxz9RL+J5f+XRcMs6g96vrSppa3PM0mvdUepf+Uh5dpuEzRZhlfdjh7vdpqwNFmyDo8oa1qPzBL3WhIiLX5KxSDm/0qlFRNq6HLM0wu5S3/8JA44ErtfbhSuAJ/X/qNe1XRci6VIRlmuS/wBbv4uNYadXnQAAAABJRU5ErkJggg==",
 ["85104961522887"]="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",
 ["121458426511116"]="iVBORw0KGgoAAAANSUhEUgAAACQAAAAwCAYAAAB5R9gVAAAACXBIWXMAAAPoAAAD6AG1e1JrAAAEIklEQVRYhc2ZW2iURxSA11yq0mq1RmhT4ktqa7EPCT6oIL60iBakYErRh1IxDX1S6MUXodSnKhLSqkEshT6KCgk1fWptU6WaEHsTCq2t1XopBIOCrfGS235y1nPCyWT/3X9/NvlzYPlnZ2dnvjnnzMyZ82cyBQSYpc/HgENAP9AHnANqfRstVwNPAQuBKt+PfNfnePtEAlQCXwM/Ac9o3RbgCPA0cBz4AfgG+AW4CwwCZ4APgBfy9JeDKxWkQp9fqFbse27mQBvwJ48ky2SxuiGgF9hqE3JaqygVZi1wD2gwGAfU4gYc1c+YgmT1+0gA9z/QCexy2q4oBegkcFjL1YGviAlRiEJicPIRua+g+2OZzsE8B9wEVlq92F/L22PC5IN7oH4m0iMLxkwYBWSDvgZcdt8NtAa4khDIxEwpPvhEXKCPgbNW5+pbtTMzQanyD3BHy/8Bywr6khtYbNzj/QdYro5p6o8rpsnrwCJgBdAE1BXUTgD0qdOQ2fnLhNqx9uMaL+jIEUDbZKNz9U3BbJMAtZvGdYWVtOTr1KltD/o1D5DtOXGdeEfJGgqgWoAOYE8emHAT9GL11t5+35AIyP8J2OgG8TC2SmzFREnWtc2da7GPjAig1mCWBjMArAHqgd3AsIP4V1fUJT1a0PLj2mfig3WV69D7i+zgq137VwJtDGibv4EfgQvA94lgAqBOpx1vsib9fZ4+P9R6ryUPeMsfQUlNtSkwkT3brGMH3hGYNXT2K0WPiCIR4lzgZwdiM5VQ5D3gTaBZY5wW1YDXiIkB/ab9ViXVzvtBh8Ukai+y//cGE64sajrXuEY3RJGxiE1uOPhEAflFIEfRy8BsG0/Bip7ynwSzK6dk9bTfJ/FWpLacc9bqzcL+XE4ZCTQ+qGBzPEOondenUDu448TDdQNLJkC5wP3gFAOFcHboXvU3Em+y76YRiGAzPRqursVliJWTiingVa+dxily5jhiptvrHfqNlLTjNdTlHXpPCv5DoITfvYa+ShFoXMyxF2jskpbJJgG9yAyRjAJtTlk7WX3eyMwAh/aKOG9AXSkDjerzmMDMB/5K2WRj+nxbgJ4nXcm68HipJTA9ZdzrcbnN9a35z173QzZFoGYDOhGEAe2y/LScnSaYbh+c/RGY7CVgp5aHphDGxut38XVFxoWUaDz0pOZuJDedLxYuF4yN+ZYPo6VwzTXsczcBeT3wedBBOUxo+WyRz3yQaEDrNFNhV9/GIM5e76AtDja4OID5EumSmmmZoBl/QdSrcwPwTm4vmJy1f1ad328NprlhZ9axoM1wntyAvGaod5aYeFEsdqXFZdsl4aQvVCS5cLsEM0lSS5Lk78rkw37zDZp7ERLVyGc6XJ0cOZIh+Qg4AJwGTkkeSHfdi5rrlgS8vDWySRV86fIQ2qeRkOubMMcAAAAASUVORK5CYII=",
 ["113669110589610"]="iVBORw0KGgoAAAANSUhEUgAAABQAAAAwCAYAAAARtFotAAAACXBIWXMAAAPoAAAD6AG1e1JrAAADq0lEQVRIiZWXSYhVVxCGXw8qaW3EIeIQNGo2LlQQjJCNtiEIGsQBNQm4EaOiKGQTBGdNHMlCsEVREBeJreIQxRDiIkQF23kO2GJ0Y4w4NRFx6H79Sdn/0XrHe29fCy51675T/6npVJ1XKBQKBaDMPUuBG8DPwC5goNa0AyqA8sALaWRA4nXAeeAjyTUGnKFXLvAy/7FCfAlwDfhAcnvxVcAMYC6wCfgNWA8Miowp86CfAHeB4ZIr3UZf0UpFSukFcBiYBHQsAQU2APsjiwM3a4yeA01As3iLHqNzwOA38QOuAOMDkAOrEQBOGSc3y1Kj66/DJXctqz1CoMU7AZe0OIAmUVHh+gfoZ4qjgAsunpXi66Tw0llXlLvh3egq0B+ofh1D4HPgTBS3UbKqxYHGFKz+zuvay2DgNFAl2Xa66BQvA/sS4hgs/EJ6HXzZ/GWW6v0nLXzh4vN/goUBcJwr8tbTA3wG7AEWqzyeqIibUjLs6QlwFBgTH7s+cg8V6wS9B9A8tNXXoj31+qEKWJujZIL1IWmPvYXdgGdAg2Q7VnkAfTyP+UIeqo+HJG95D8Am8R2+9qbp42rJVqwPciTFbzrHn4zl+jhVcl/gfg7AorjVagfvspWN0RDJIyOFLMuOJPXEv4FG1yRm5wB8Kb4wjIkA1lUFfc5tsBLY2QZgUXxifJ6H6YdtrmOvARakWBlieg84FZqrP3pTtGC+5N7AQSuDFMAg79fZ7xyPgBVR5xjkWn6Wq8dsRJRYJ+FXLRgg+csUy5LcXlUSPwk2D267Iv8+o7HGJTMvTkhPuXbYbVAbWZEFWJOW4RWuY9e6mZLkdtioEfg4zvD06MgNUMn8GFkSgzUAf7obRsmQx9XSaF2STqRYGACtGy1LyrDdVZ4CXSR/k6NT27w5DsxMyrAN6JOu0dqRayvDRVk62c/yAGiW1CXUZFpj9UP/0ySXvwXOmvnKsAX6YaScBGi98sN32pY+9NJQ+kVJ2p5hZUhSfQlIfAvV+3id60ORsqdmjYaNQb8QkxsDs3O4/MjAgFleNw2wNqNkAvh/als1WRaWi/+eAehjaPed/omAvAWzsXknw1X/3TpTdWKG3fm92QZYSIjR0VQwI2BRDlc94IF3jpwnYG+kkEYtbuMRWUm5kKPlE3mxMdFKoDvwr2sIxZyAP2TV4dbIpfAfxDYw7jcJgF8nWuhAxwK7le22bltG4Q6UGMM36dcfHpszs3TP/kNT0S6jRreAzbYu1jX5FU+GDvP3HrAAAAAAAElFTkSuQmCC",
 ["99364596537843"]="iVBORw0KGgoAAAANSUhEUgAAABQAAAAwCAYAAAARtFotAAAACXBIWXMAAAPoAAAD6AG1e1JrAAADq0lEQVRIiZWXSYhVVxCGXw8qaW3EIeIQNGo2LlQQjJCNtiEIGsQBNQm4EaOiKGQTBGdNHMlCsEVREBeJreIQxRDiIkQF23kO2GJ0Y4w4NRFx6H79Sdn/0XrHe29fCy51675T/6npVJ1XKBQKBaDMPUuBG8DPwC5goNa0AyqA8sALaWRA4nXAeeAjyTUGnKFXLvAy/7FCfAlwDfhAcnvxVcAMYC6wCfgNWA8Miowp86CfAHeB4ZIr3UZf0UpFSukFcBiYBHQsAQU2APsjiwM3a4yeA01As3iLHqNzwOA38QOuAOMDkAOrEQBOGSc3y1Kj66/DJXctqz1CoMU7AZe0OIAmUVHh+gfoZ4qjgAsunpXi66Tw0llXlLvh3egq0B+ofh1D4HPgTBS3UbKqxYHGFKz+zuvay2DgNFAl2Xa66BQvA/sS4hgs/EJ6HXzZ/GWW6v0nLXzh4vN/goUBcJwr8tbTA3wG7AEWqzyeqIibUjLs6QlwFBgTH7s+cg8V6wS9B9A8tNXXoj31+qEKWJujZIL1IWmPvYXdgGdAg2Q7VnkAfTyP+UIeqo+HJG95D8Am8R2+9qbp42rJVqwPciTFbzrHn4zl+jhVcl/gfg7AorjVagfvspWN0RDJIyOFLMuOJPXEv4FG1yRm5wB8Kb4wjIkA1lUFfc5tsBLY2QZgUXxifJ6H6YdtrmOvARakWBlieg84FZqrP3pTtGC+5N7AQSuDFMAg79fZ7xyPgBVR5xjkWn6Wq8dsRJRYJ+FXLRgg+csUy5LcXlUSPwk2D267Iv8+o7HGJTMvTkhPuXbYbVAbWZEFWJOW4RWuY9e6mZLkdtioEfg4zvD06MgNUMn8GFkSgzUAf7obRsmQx9XSaF2STqRYGACtGy1LyrDdVZ4CXSR/k6NT27w5DsxMyrAN6JOu0dqRayvDRVk62c/yAGiW1CXUZFpj9UP/0ySXvwXOmvnKsAX6YaScBGi98sN32pY+9NJQ+kVJ2p5hZUhSfQlIfAvV+3id60ORsqdmjYaNQb8QkxsDs3O4/MjAgFleNw2wNqNkAvh/als1WRaWi/+eAehjaPed/omAvAWzsXknw1X/3TpTdWKG3fm92QZYSIjR0VQwI2BRDlc94IF3jpwnYG+kkEYtbuMRWUm5kKPlE3mxMdFKoDvwr2sIxZyAP2TV4dbIpfAfxDYw7jcJgF8nWuhAxwK7le22bltG4Q6UGMM36dcfHpszs3TP/kNT0S6jRreAzbYu1jX5FU+GDvP3HrAAAAAAAElFTkSuQmCC",
 ["5043252057"]="iVBORw0KGgoAAAANSUhEUgAAAEQAAAARCAYAAABkUAr2AAAACXBIWXMAAAPoAAAD6AG1e1JrAAAB5UlEQVRYheXYTYhOURwG8Jd3KJmIjZrSLKZ8bqxQihqxURYWRBLKx4psSCEWw0hCNmrICruhxjQLsVBS5GNhpXznayMhTZGfTv1nmt7MO8zc995bnvqf7uLee87znHOe89xbQeU/q3FoxiwswwbsxRkcyXMg47G9Ae+dgkXYgv1Rp3Aa53EFN/AQr/DN8FiepyBNeD6G5ydhATbiGHrwAr9kg67UT97L9QNaR7hnIuZhLQ6jG0/xU+NwFROKEOROEE3XVbRhDQ7gMh7jh3zRPSBGXoI0hXl14h2e4AH6FYsk/PEw2cHxZkV6GmZgJlZgE/bhKD4pH3ox909cRjPbS7ETJ8LFXw8xtqwMLisk33kWBtwZhjy/Hse/EaENu9GH98qJNBFvY4xpojZjISb/62ofbhWsREfs9bIhnVS3cBY7sARTs/K8ShB/hEuR1j4qB5L33MY57EqhCdMbfQik5nPBxL/gHi5iT5hyS63751WpedlAst9xHTdxLWJ0X0TodRHACiFeT5A02KzwFRfie2JxpM7aTlP8flM08XqCnBwl+X7cx8HY4+2RR0bqtBrbdDAdlqlSs3oIybvxlThQiew2bMV6rMKcOIrHstR7IsiVUpBqRNhDmJ1TxynRpt8BhQtQW78B7mFEJ1OIdhEAAAAASUVORK5CYII=",
 ["94916482207980"]="iVBORw0KGgoAAAANSUhEUgAAAEQAAAAkCAYAAAAw55zoAAAACXBIWXMAAAPoAAAD6AG1e1JrAAACOUlEQVRoge2YPUwUQRSA5+JpDHoJMRhMSAwWNFJQWWmhVlaclSWFJJZcpZRSKh0liRaUVGJFJRRYUVFAQyExMYFgiAlKLniGz0zyLrnMvd27/Tlmd+++ZKu7ee/Nl5m3s2MA4/lx8VqPbxmmTcdASBuDFeIwEJJXIQvAMlDOcQ+5AiwB75IKWWgpeB2o5FDIDWCtJY8qJaqMJjvAWI6E3AG2lVxtUroJ9gpoKMF+AFM5EHIfOFDy/APm4ggxwDPgVAl6Kr9lVchT4JeS4w9Q1cZECT4lq8KlIasoa0JmgHMl/iHwIGhc1CRj0j80bPcuZUBISfrehRJ7DxgPGx8nYUXeNBqrwHWPQq4BKwG1fQGGO8WIm7gsZxKNr8CIByF2shsBNa2IrI5xki7PWsDS3AcmLlHIuGwHlwvZPl1v5aRCDPACqCvF/AQeXoIQ2yCPlDjn0lgjxUtDiJGJWwEudRHWKyHPgTMlhn3VPokzl7SEGNki+yHLNm0hNTlcuRzIYcz4FmKkmdqm6vK2B0LmlbH2eD6aZA5pCzHy2l3tUkYSIa6UT8BQ0vp7IcS0fGaHbZU0hBjJsSQ5TVaFmLw+3gsgY0+nP1QpHtNxhQwB3yge34GbcYQsUlzeRxUyCfyluDSCbvs0GSVgk+KzpX30aUJm6R9edhJyCzimfzgBbocJ+Uj/8SFIyKOAy56iY+f82BVSDrk87gd2gautQt74rigDvG4KuQv89l1NBrA3b/eskM++KyE7rP0HfqiZSky/DlwAAAAASUVORK5CYII=",
 ["115683661427909"]="iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAAPoAAAD6AG1e1JrAAAE60lEQVRogdWaaWhcVRTHJ5ku2oi0omIVRRCMWKHWfquKHxRUrIpi6wIVF5BKRSsqoh/8pIKKdQEpWoy4K4oLGly6fBLBtWKpiLWKK1rXuqfjzE9u+j/p8XDfS2aSN00OhLfMffed3z3LPfe+1IAeoLdWq9WAOrACeA04T/d6ak7Ufpo9s9uFnQrVdb6SnTIE/As8CzwA3AssBvaLz+12EGAucLjO3xZAA2jpL8nnwLfAT8Ba4DZggQMxmLaAcNYfD8DTUnIT8Ce75ENgGfCOlE+/I8tsBj7V74cBe2QUM6D/uWBsV8u4absAn0ixZhj1n4H7gUd0/QVwAfAm8DXwo+5vBO4BBoClAqpn3jMC5GJuLjCvY+XVyUsBIEpLv21X23d1fz1wBbAD+ENuh6z4PnBfSgQCionAANbomTMMshOAWcChwF3ORUxxi4UIhIC2uuvngO9dG7v/F/CerHRuepfem6yb5AfgeN2b3nZiSClRxzPV4Q4pno5JBuUeQ7JEMwPkIVsahIYbDC9/K65+0fXNRaPvU7YlixyAmfNI4PeMUt8IIr04yR3ABmeFbSUuaP00M0B2vl0utwq4Qal8ITCz7cwFHAKcAlwlH16r1GkvTMr842C2aq6gZMSjmIVy8Ybr6zPgcWA5MB+YAewF7FlksbIY6QdOA64FnpQLbHZu5i1WplgZUMP9xT7S7x8pnSfrH23WyJmnLr8rJQTmpI6As4DrgUcF1S5ATrzbeSA7/gYsGdP8YT7nwIYDKrbRcR/NEWSCfSKAms5aSe4ckxuNAWwYTvctJlKsVCUNHZ/oGCADZAXhJeo8l3Jz0sqk4tHE+n1lwgAcSK/8c8Ap2I6btEZpZ5luC3BgFQAjE47SoH9pToZcETmaJSywkzw04co7iOmuWPvKvTwqg4rJI+R6W0I5EqWlIjIVmldXCWAWSJPPB3p5rgRJ8qtqoEUq7a3Ay83arwP7K4X3dgNgVijXySj1ItAHrAPO1xqjCOBi9TttXGuINgBmax2RAxjxZeBY4HQ9My/M8B7A1unDKbsbAHM0/XtlCNdfArerTLkSuDwUlR52oON1Q5sAVuFeV6C8t8hGKZ/W2auBBxXM/jk7pgA+yA9S1RZYopVbdCEfwOtTYKq9zeYrguv488u6ZYW4VeOVMZiPU4msdikTzdD5wgysPT+oNr3dArgpKGDKp/lhvg9IZ7m9tdbw7Q1km83AVadSc4dbQyCOTGC18vh5ocRyp/pBqhrg7gKATfq9p8By14TnPMwt/h1VA6wpAHhrFIATnOt0Pw4cwGMBwJTYUADgF0ffBWh7NsVHX2XKh5H0i/4xjSK7IF5VW9vS8ZborxrAgvHloLgdnykBsGefCvApAz0PXGq7E1UC2CiuKwB4uASgx23zpP3Wi4CTU2lSqdJRAZ2/ERS30VzdSSq0dXgVeudGsO42g5sBYJW1KevHbRqUbtVXBTBTe0U5ANsTrbY0HidAnz6E5ABunAoAszMbXbZYWTkVAPZ1X3Li4mT5VAA4IGyZ+Gx04WQGsInoYDfiEWDpVADoz9Tzdm2L+Gpz+jgBFkhZA/CV5UlTAWBRBsDkuMkMYJXoiUF5qyhTXByjNpPjfy4KABa73O+/izXsAzeTHOCcELhD2sgatH8coVv1TTviYiDtOqev+2l9ezZw1ESvpP4D0r5u8NicHnYAAAAASUVORK5CYII=",
 ["126436179305996"]="iVBORw0KGgoAAAANSUhEUgAAADwAAAAeCAYAAABwmH1PAAAACXBIWXMAAAPoAAAD6AG1e1JrAAABHklEQVRYhe2WMWpCURBFJwrBTrC0iJAFSDYgLsMNiLoAF2Fnl0WkCzaBJE12YOEOXICKhY2e8MBCvq9y7vdbzMBtL/f8N/++Z+jHxJKHU08AEydMrDTxDxOlpRiTuFx7xrVE3MPEw4N4aRFPS++Y2yHvGS1NtDTR0kRLEy3tHXPqCZhd+G2BN2FLJ/+vC/8F0PZ4mjNQDzgVPuIaeBEBjzOHNKwS2IBpJtQKaDl9O8Cu4Pt7PvVKgQ2YZ6D/gIZoldPsgVdvVhMB14CPDPQnUL/Bb5LxGimymgg46Rn4yQR9f4RVpgTgpCawzEBPq15lSgK2c0OnplbNWJnPSgBO6gIbAey3apUpGTipDxwcsNJV5g7ASQPgeCOwpJWL+gcKhYE5vDvFZgAAAABJRU5ErkJggg==",
 ["98130849488537"]="iVBORw0KGgoAAAANSUhEUgAAABcAAAAZCAYAAADaILXQAAAACXBIWXMAAAPoAAAD6AG1e1JrAAAB+UlEQVRIiaXVW4hNcRTH8cE8uEVhJg+KcikKiVxDosQLcikPElGakpeJeKE8kjxIlDeXpLwTJY9KoZBCSVKGXMYtMT5a+e/a9uy9zzjnV/86/f+//T3rv/Zaa7ehrcXViaWYVjxrBrYTBzAKu/DCX33C+lbgi/E7wR6jz7+60gp8h3odbwW+pQE8bjOnWfg8fMY7fK34g4PNwodgJsZgMg7jR4L+xAmM+B/4yFRq+3EWJ1O1LErnu3ExeQZcip04hIe5Cskr9m5jXRWjCrwZzytyeiFX25m6Bgo/UgJ8g6s4g6l4Wjj/gOmN4PGmi7qPKRiM9uTbUHKzY3XwVfjVD81qDMNNrMQejMMsvM/57mFoGbw9vZyi+jA/wa5hIb5jb3ou9jK9xfgy+BrVOp88Ef2KtPcIR9FT8HaXwc+p1yWMTd5N6K3x7svDI6IHJabeNKgi8iz3kaJ4ZmsN/FvmC2MHXpWYnuQq4yMW4GXqzOHpd20q29KcKDaFVDnZ8N+GubiOiZiQartKz+JjkuU8yqxMPdhYMrxixtQpMtGRPbC9gbk7RR7QuxrrBgblo7lcY75VqOk6RSEsL3ZozOFTufncjO5gWd3giuvH8IpIY0BFi0dXRrfGmI0VH4YveJ2Ap7G2qv2r1mhMwmwsSVHFirKckdo9G2b91h9JRsOJxHFn5AAAAABJRU5ErkJggg==",
 ["124628897178906"]="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",
 ["104391708781777"]="iVBORw0KGgoAAAANSUhEUgAAACcAAAAwCAYAAACScGMWAAAACXBIWXMAAAPoAAAD6AG1e1JrAAAEAklEQVRYhcWZfcifUxjHn8eYWTGL8lZayESzmFrysqTIW4mwtZGekcfLHyustvLsD/xDrWaYlQf/yF8kb4uF1cQfhDAx8vLPZsRImOd33/dH1/qeupzffe7797Td5/et03Xfd+fle5/rOudc13VGRiIAh1jR86jkBcA64HHgMWAtcAVwnKu7CNgIPArcA8wEzgI2A+PAA8BVYYyR6SBuAMyQXAM8BVwOnAEsBK4B7gUeEembgW3AHSJp37eq3Kh+jgaeBC7T+6GDEgszdII1Bq7V+0XAJl8nbgccDqwEXgBOBRYAJwNnA88BnwK3AtcBtwFvArNTfdbOGHCTVLJQM2GquQt4OPWnwGGSY8Ckno91g5sqDS9p9t8FdgE7gIlBZ+4cYIOe5wDnA68D36mjTcCLwNv683HgNeBD4HPgV6AE/gF6wM/AxyJm3z3C+x/A8a0zCFxtRc8fqbENkkJV8x5/898L9Veq2LvhEm/fKXIXm51Jtahx6UpPpagppSPhS5Eg7H98VcpkArHbgb+BP4F9DR0eTBSSWxrVCrzjGqTUc7BRSe4F5iX3PuAzVQzqyYVCckXS7rQ/+coHimrAnwzjPdNEbmKA1dkFSslP3Gn0f9sDlkd/kguV5G92otTanTbcYaGUXFqrWp2nf6lSzgXhtfV8itwRwNeJo6ZrlJLfA0em7O6WIZHzWJSyuzMZDirJf+3oTKn2JOCXqEFOcr8Dd9ees+aXRSfFMBbFRB85twFuiSrnQk9yXRO5ja5yNQRyDzaRu1OVpsiLQvKVvq3EkVuiSsHBzIVS8oe+wMdFXnOB6xVPbI3+qktUbqzFtSvWf1QUloucH2cSOK1vM1YMOlPPK6NGXaOQtGD8Psso1M1csL8LVbnMTG6baU8h6YpUgD1PcSWZtpVSco9yNauBb2Nyo85T+TJq2CUq9zxfaZAddaoNs2eR/TDsbkwJoRua7G5DZnJ+rM19xCJy41GDrlFKmuM7p43cpVGjXOS+AY5KkQs2Nz9zbFE5kgtS5MKKnQ38GP1V1yglx2rJRQS3Z7a7nuQTTeSCaiejRl2jkHyviVxwAO7PTK6StNPpxDZy5kKR2b+rJK9s204Wu8q5XPee5Oq2BXGMktFdkquiNK7FsIY32siNugR2eYAEypr8cl2f4dvTg6zYl6e5nZQuYz41wGKyfPROhabmgS8DzgNmNZELdvfsgKn/siWDvkuJQru/eMi8DrlGp4TApk57bSs2ZD6nHIEiKoGgYTfwFfAWsF4u0Lm6fEned8nJnOHK6CAzt9SpK4V9mpn3gdO9WSRImCtuBPbfULbegdV1ImnTbj79T8AXwAfAq/L37G7MLvLs6nJu3eyr7CcwXRL/ATeYGJZYFWldAAAAAElFTkSuQmCC",
 ["116274228220670"]="iVBORw0KGgoAAAANSUhEUgAAAD4AAAAkCAYAAADRjIm5AAAACXBIWXMAAAPoAAAD6AG1e1JrAAADtElEQVRogeWaS2wOURTHL5VSj6DpQxQhxMIjRBMsEEJsiIXEAo1HhJWkTR8k9ZYQWiLikVgI6pVIJBKhpWJHxEKjFnZeG4+EUlqt10+OnGkmY+73zTfzjX6tf3I2c+899/xnzj3n3nPHACZG6QMUAbOBpcB6oBTY6hF5tk77SN+RMdtl0qlsADAPqAAuAU+Ar4RHO9AMXATKgblA/0whPk6J3lFD40a7ziUvYuy/Jj4E2AQ8pPvxANgIDI6TeAFQA7SSefgEHFAb00Z8ILAXaAtp1EfgEXADOAccUSPdIs/qgJvaV8aEgdi4R22ORHwx8CqFiV8Dl3UNzgfyPPquALkBv0qe6ihXnW9SsOMFsCgM8X7AIeBXgEnkC1UDUwKQEbxUQmFS41RgO9AUwK6fwEEgKyjxQcD1AC51ApiWovEO5IUeBbJDvABHZO6TAZbgNT/XN54HkifvJlDSAdSmEkQsxB0061c0EaRAbRLbbLjjfcnGo0Q2HjY0AOMjGmnLzaXqylF0TwAaE9h/wUZctpN++KEBJqphNuIObqVhqyo2blGb/bDGSzzXkkI6gWVpIByEuOBdmuZbrrZ78QEY5ia+w2LIyjSSDkLcQZ0G2ShzlVh0b3MT98vVp9NMOhXigqdAccT5zlpyvDGaf73oiOlomCq+A7ttuTiAjLK4/CSbSzTEQDoMcQf3I2QUCZperJKGKp+Gmgwj7hxEuqJyCiI53osKaaj0aajtRcQP++gq/x9c/bbN1SdbgltRLwhuoxMFN6MnJi/O9IJ0JvsBL55Lm9NBjnp+KOnBGxiJB36odhMfDrT4dOrU7V9P27KuAL756H8PDHUTF1mb4EAvte++PeCQ0le/qNjsh9VOX+9AqWHb0KhHv0w9lk5MUkuQ5dPV3zs4Ww/tNnRoSaowgwoRIzRX+0VvtzclLEQYLdNIuSYR5CudAmZ0Y+mpWG1IdpFxFcjxjjcWpVla9rWtFTceAzu1BpbMXaMWG6cDu9RTkkFs32eLTSbJZAs17wXFWy0hV+rYQp8Y8ieqBpBCLRFXqU6J+EHxDFiQSL8JYECO7p7CXii0qlfUA+eBYz4XCse1rV77fg451xf1iL9cOwxxo5IP7I9wyxEnWtSt84PyMSHWmuyoNujBIciFQ1yQue9pkTTplVE6iBuXjAHK9AQUdimkgjZNTaV6AAltu4lI3C2Smuboi6jTa56waxUd26QXjWWqO0r6i424TWSDMQtYotvizT6/gsgzaZM+M3VMrHb9BhugiqOuoUfnAAAAAElFTkSuQmCC",
 ["95580515511329"]="iVBORw0KGgoAAAANSUhEUgAAAEgAAAAwCAYAAACynDzrAAAACXBIWXMAAAPoAAAD6AG1e1JrAAAElklEQVRoge2bS4hcRRSG25lJJGJ8iyDoCG7ExybgQhF1pWYnvgjBhYpEjBgTRSGgCVFQfGGMETWIgqJBhYguzEYURFCCC41EDcRXxAe+RQPqdN9PTvsfPZZ3enr63pnbVvvDoW7fqq6u+uucU6ce3WolAMaVHgb8DKyP73MEsJ/SE4DLAwdjZYWOBh4CXuFP7AU2A1uAR4LY543AXcDdPWQ9sC4Re7cWuBa4DlgJXKbGRbF3V0vK8l2uAJYBFwIX9ZDzgHNKZClwOrBVfb4ZOO4fSuFsAc+q0BRQMFqw/rZDv89Ptecg4PNAECo8NQ/SnkZmynfp9CFFH4LqM+xNCTokENRhtNElLCXoYOALFeg03MBhQFGmQf8T9Dd+LyPoS2V2GF24L9qXEnQA8KkyO4wuvO+PpVP8McCPyiwYXfgMvsEJ8sjxSmX8pkKdBhoXp9umCXrQCZpQeqsynJhiRE3NCdqYrkkmgJOAS4D7ga9VcD5Icq35BvgleTcX8MCxF0EPzLR4OwrYESqc6xDffuMnmz1CFN2rE1Widv/dsnxzMYbr/0WMOWzzScACvTt5nkZ0JvLi56qDZSR8CHwV6nR43e/Z0mumbYAFSh8OFdcJb9h3wE7gdeAF4ElgE3BvWPqka6WntBuwGlgDXBVW9tOJ5a8ALpAiTAKrVMdq7SzcoJX/oT3JSZz3jTUSFDXANWN5nE1Ltl98h8EJWhHDk7mCt6EfgjbUSJCjE+pbpt9ZKPN2mQjvd6vsDidTk8ogMh7cybT5/TA4ptRHMPqCQVDIdGwTjuAMV0WTnmaQtqnsc7FtjSGo+OKalh/+3aUaodtsMah3e4BjyzoegljbwTQ8U1Zu3hEadlYYfWog6DVgkeo2bXK86bNGVO+gQU+r3NZhI+jOGv2Pm+ijqntR2Ps2vGxmJv/Q9UMqZ5/fUJntjRMUzGshsCvRgCqxTDv4nZvCb6zVNssTQbtiG2zz37Gz1TTCyJ0dOjioiZV9t5D/sWBsu+Iei4GeNycMvCix5w8SDV45DBrkBD1ecfZyYr5VkGZB2VsD1Of1rBkGcsbCIdq+pIGzhZvlxU68/MkSRb92rna75I7wnIqVuzQO3jBoz30VtcfJ+Qg4UHV2HXCFtjU+c7ljnJRZVNEe9xmbVGeckTwKHp+NNEpO0ol7avA9hZ7PHIrRr9H3nKhLC3X4nrdDoDewaQ0bQTblVl13TSldpzqbN4+ayDkj2Y8eBP49i3NOifXnQJAFZlW1p6301dxMa0lYXRc1EHRNLuaVbidUWZQWSu3wcTIL8zIAx+s0oS7t2ZYNOQaF87GDVQlanoV5GYDDgc9q0J5CqV2fOSILB23QJUZqOGtqJ5th/33tMQC31OScCz2fmxtBLyUaMAg6St8H9s/GvAzhxKKK/5lSujkr7TEAv1YgJiWoe9jvC9QsUONlgL9uZOVG0Dvdrg1OUhGWKFtyNLEjdR7FLG6jF6G8O/fv7b8QWUXQDuDU5K8H/WoO0h47sVic1ewVofswdg/nY81qLp/oSpyt02wB6vJDlxp4FzhNddhNibw0p9Vq/QFwPdeN2O26jAAAAABJRU5ErkJggg==",
 ["119508840812085"]="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",
 ["133170389820229"]="iVBORw0KGgoAAAANSUhEUgAAABgAAAAZCAYAAAArK+5dAAAACXBIWXMAAAPoAAAD6AG1e1JrAAABxUlEQVRIibXVS6hOURQH8HPzypVSxESRd6Hkw9CjyKvcq2SEATIRyoQRE2MlRUpmDE1M7oByL+U1UULpzsxISlxvP+3sW9tuf1/fuefeVf9TZ529//+91l5rnQpVQ+zCpnbfm5JXOIER7J8ogcP+2W+crSMwBavRj4M4UEA49Q3/23X0dhKYhqN4HEMfi93DkpLAQtw1PnY5F1iAl20Wf++An4X1VzAzFQj5HsgWfcQl7EArYl2GVbiQ7PmB06VLPpSRv4mEVRc4Eve8jwWRfusJj0kYTMg/YX2NMj2JYaxNfLNiNbXCy7JIOmrXavZBC4uS96V4GLlOBce2LD17GzTddDxJuK4G575MYEsDgV68Srhu5hF8wYYGAnPwNo9gMb7iHXZn4fbHIuhWoC/LxvHgnIqLWVnOxh3cr0E+A48S8s9YWVq4Ak/jooEuyefidnb6W/moCNia5fAZNsYfyuYMwbcT52MfpBbSvTwV6MGxNtPzTweUbCTt6FGBcJLxsGFsT7OSDrsz+DUG0m94gXOYl99Pfgeh6T4km59jT0RfASHyNbGCigVQcoZB97pmFVV1BALm4wGGJkogIIzc8J+Y3ETgL2mR1T6HlipQAAAAAElFTkSuQmCC",
 ["76768360776984"]="iVBORw0KGgoAAAANSUhEUgAAAB0AAAAwCAYAAADtoXHnAAAACXBIWXMAAAPoAAAD6AG1e1JrAAAC3UlEQVRYhb2YT4hNURzHL/MGTf5kMYWNhWhWk40/ZaEZSrKgyFIokYVsiMjGQk2SbCwsZjNmY4cV5ZVBkREpophhIfIvIn/uveej3/M7r5/77rzBO+f96r7vve+eez/3/M7vd+49vyRJkgSYojoV6AE2AgeBQeAacBd4CrwBvvHbnOpn/f8d8AyoAueBAWAvsBTotJwaSHUVMAL8JKylwBiwus4TOjALeKyNciDTxqnuZ/q/7501ZzZ/rb8+003sFtAhm+/tET3xY4Ibt2LOeG+XB+4APpgGMcypytgfFujbyEAK908F+lAPZDzaAX2RaJi3A5qrjgn0kB5ItMW0VPWUQDfrgQ/tWJap7hHocnPCtQG6XqALgC+Roc5or0C7gOeRg8mpSnrO8xPEjcjjmqs+sdPgUOQIzlSv1IAKvVA4GQta9W+ZzjbMSrmqvOK6fE8vF54otGWqI9a9ZyOPaao6ZKEHCk8UC3rcQrdEhmaqOy10RcQZyZn7rrHQhcCnSGBnervYQqcD45HSJld9DcxNCt+8N80ThbRMdbTsu3c4EjRVvaScDvmp6MGJQqPQ0DPKqVjo7sg93W+htVcNsC5SIGWqm6x7/ZjKwonAaePM/jIL9dHbHeHD26l+lM+ierYYqCxu7gd2ca46auaEetr4cd0XOIIz1aP1IDJ0D+0P7N5cdYPlFCeInpKV9v+aM/u9llOcCufoci4k9D0w/4/xLKk5PAgUTLnqI2BaA7Tg4ouBZqZMtdrgWgOtBP5eSlUHG4KoBBpq6ZiqHmtIl5K02RrIvanqtr+Brgwcvf3N3OsDaRHwtUWwMyWiJc0CyafNbOBli2njoeN+GdGQLiW9PWee9F/B0v677g9P6NqS3s4Arpqb5IWynS3L2bKeLeXdkaFq2ssSsKzQt2sF1LpsMre+Ak5O6tYysHG1LCXXav1QSrG3tawnm9Sg7gHXgdNAHzDTD1Vp8CRJ8gsVuOyYPnJDmQAAAABJRU5ErkJggg==",
 ["18885719914"]="iVBORw0KGgoAAAANSUhEUgAAADwAAAAYCAYAAACmwZ5SAAAACXBIWXMAAAPoAAAD6AG1e1JrAAAEhUlEQVRYhd2YW4iVVRTHv3PG4zial3SSxMx7ecnyVlZmKkaZUkEkajIWgviQDxJdfJkQ9SkIEgaKHnqoKKQIFBQzQQpDrCQDyzQyr+jkODNl4znNufxiDf8dm6/vO3Mu6qgLNuf27b3Wf13+a+0TAEEPrARwCzAQSAIp4C5gDNDrauoOegjwcGAL8C5wBzAR2AF8DIy9GQG/CHQCWWANcD/wI7AfmHK9A04qRcvZMxP4BbgMPAf0Ax4ApgG1Wn11do8CTgL9gXHALGAhsAqYA/SJeb5Ge6w+J+l9rcA9rTrup+9sTx3wGLAOWALcq98TVxtwQiBuE8C5QINqz1LvNNACtAG/Ak8JnH9Gb+Ah4APgqPZsB+aJqJI6/yVgkaI6CvgcuAD8BRwGXgWmeiRXSmBuBe4GHgRmAyPse/dAjQfMDl4ArADeAD4DDgEXVXd5rQLwD9AMZICtwDBPqUVsMPCp0vcscFIOMtD3yanmkN+kZyQwHTiis5EeA/4D0Ag8DNTHRLxWJPg48Lbs/kM63zf7fNZ8E/gSOKYHsh6wYlJQpG3/EBmSklFGQAd0lp15XpH7SHWcVLpaBCYoIxbruXxIRxr4UxHfrD3DpGsAMBlYLsefA9rFEea4VmCvdYBAabJUQC/oAQeyO7BOvpbTTPntwCPAamCblDrj7fyfRFB1et6PUB/VbmsIsJOcMqpVJdIEvACsB3YDvyuiae3PAB16tZY3JPDANscoKUW+EwBncLscF46Si/QnakXhIaNevbm9G2dnlVWnBPCMMJz3ys7Xm5ZTUoFqNVNGNKPEyOhOccHSUJY4pc4Iez0OfCWC8gFbDe8CLnl7iwXBgWlTul+OwdEs0u1i6Wc9gqhU0iK6hNL1jGes44GCUjKrdDzh7fH7s09Y5Ugc3xSAL0SgXYCflMHViB36uowfrjHRGZBXin4LHFR0Dwv01FALe17RMMdUK87BHZrmutpZoFqyeqhWdostjXU3qA3tVO08AYxXy1gsll0RGlasft9RCyqUAKSY5HVOXo6e4A8eI+T5QpUp1KoemdRUZe+HhgYFN3nVKBv8dJ6oFpYO6cjGgC6Wwh0C3CmH/0eOgaabpgoAZyIUvSfy6lvBKDhHrNsSaotulSNprSMaZP43WjbEpElnES9Gyd9K4+UCXQ7g+ZrmToqlSxl6ouxyE6ABbgzP+O7N7JBnneTKaFlOkRn6oUbVcgBbDb8iwjvlGe1PfN3VtisBc9jPwIy4y8N4FXdUvZQqWWWEKVsbMUV1txLercpa2zLgLZHhcdVkRo5w2Rg1EeY0jFjt9o8DbD9siqjLUsSNcC1qKY0VRDfuxjNQpGqRekZTXJM3Rl6Sk3OyIyc79qvlJeIAJ0QaZ0ugfJc6nTp8H7BR17v5MrJasHEZkPKcMEv35ddUQt9oTj8kxwyKOidcQ1s0ohViQHbo7rtVzfxRYLTm6CtyQa9gpXT3Has/Fabpc+S9OZxCljrfe3WSFXPu0SRll/x7lLJX/O+Xa7GC0Bc23tnFfCXwsqYhu6CHB4gbdv0LwvJLeGpRWRwAAAAASUVORK5CYII=",
 ["110537115575260"]="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",
 ["108330096653868"]="iVBORw0KGgoAAAANSUhEUgAAAE4AAAAgCAYAAAC8VE43AAAACXBIWXMAAAPoAAAD6AG1e1JrAAABZ0lEQVRoge2ZsUrEQBCGh0PxAYL4ClZapbO00MLS1tJSS1tfwcred7C0tRCuELTRR1BQsNTzE4vAcdyqO9nM7q3zwzSBZCffzj9JJoKNxDhMbshqHXFw8XJwSkmNFRcTezPnfwIXwFoGOJpYBy7ncNiNvVbswuPABrwCR8BSAXDmxSpwDnwE8r8eGlwDnAGTQAK3wFYBoLpYBo6Bl0C+E61jtAm1wE0gmVLsuw3cE9YVsKG9fp/ERsAB8ExZCvWxTg/Aft+NSbGzzS/2tdZ74Pi3XU+AlRQVndIa7Q/2zSl1H7MCJwXat1cfswQnU/bNqSR9LAc4yQgtWR/7b+DEIhwcDq6TV5xSDk6p00V+ODTk1eOivY6MCnwB3iwdXOufXHV+5L+l7H812fKvY6Uk/W/IQWYuTQ8y74bqf0OOznNpdnR+CDzlHp37zxp04Gr9PbijqTgLiXGY3JDVOuLg4uXglJLaKu4LsL2THNUiYeYAAAAASUVORK5CYII=",
 ["134999474924250"]="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",
 ["117474230479176"]="iVBORw0KGgoAAAANSUhEUgAAAEkAAAAjCAYAAADYHCfgAAAACXBIWXMAAAPoAAAD6AG1e1JrAAABsUlEQVRogeWWsUoDQRCGF7GxsLwmxmBvaSucL6DY+AoWiZpX8BWEpBDBB7AV0S4pLG2FgIWdxZWJYKHyycIqIXhJ7rJzO6sfTBPIzd6XnfljAPPHqwEcA3fAAHh1NXCfHQHr054R+gWMYK0B58AHs/kEroCN/yRpHxhRnCGwJy2pBrSBB+AROM37dQSr7W5GWex3T3xLWgEOgGvgPafpPXAIrFZwgxYRNH7mnxtV9jBLwLabeXtF5+XNzf4usOxZUL3kiOUxdJNRWNKmG6FnD4d4Ac6ALU+SLvHPxbySamN7RopF91djzhQrin1mveyekaLs/rKLVoqWjz0jRZH9dSt2CrjxvWekmLW/nsQ6w8A2yIiHLEeSz1SbZGQb9ImHXo4kUWyDLvHQCSWpRTw0Q0naIR7SUJIS4iEJJSmWhMum/E8S5btJP+JkM9KNTUQJ1wktqRVxshnpMhElXBpaUhJxspmqJGlPuCyUoElJ/UiTzVQpqRtpspkqJWlOuKYWSZoTLtUiSXPCJVokaU24LKSg3yRpTLieNkkaE66jTZLGhGtqk6Qx4VJtkjQmXBJa0heMW+AgI8H7DgAAAABJRU5ErkJggg==",
 ["89678507894873"]="iVBORw0KGgoAAAANSUhEUgAAADkAAAAwCAYAAACrF9JNAAAACXBIWXMAAAPoAAAD6AG1e1JrAAAEqUlEQVRogd2aaYgcVRDHZ2bXIwkSRMVEkCjxwCOIKAEFDVERPCGCIBi/CQpeKOIHoyhIRCQI+eAXA6JB/RBPWMUrRhRFWUWToEElihIxh0eCR4w73f2Tl/xLap/T09274063BU31dPe8eb+qevXqvekWMNpqtVrA2cDXwDJ9HgVGgHar6QK0gQ5wJwekC9wTPTMi6LYdrSYJcCywxQEmOn8OuBQ4Iud7HcHbUV9w4FYHGCQTaNBBvgeekqdPB44BZue01Y7AO7WAB24UjHkQ9zm+9ivwE/A5MAY8BFwDnAkcnQfUy+szagDgmRxIk9SFcdbnmR+AD4EngduBi4ETgUMLft+Avff3H4OE3OI6WiSZnkuiIw/+N+BL4HXgDuBq4BxgHnA8cGSJ/rVd4pvkfR8R9IsM4A8GI73ge0m4vgvYA+wExoHH5f1L5P1TgIU2veWAlw914GfnpUFL6uC7Oop+J3j/d43/MG+/DDwILAcWA3OjmeFURcZSYL4ZIYb8xnVoJsRCPg79iT7eNwn3fwTeAZ4HdgP73JBbLabJEQB84BoYtmTRkToD2BTXS1Lpj4EL/5W0gLU1giwSg7fw98ZI3VC4QGwjBnmXbvSzVFNkQnptDLlEN/plxCZJKv2Y+A6ELrBSN8z9/wfIe2Nvjmh+ugX4K5rkswYCbrNC45/pBDhI+m495MPWD2yb66zMs8FeF2Nk0mGOPS4O1/0nKrbfBd4CtgJ/VkhIPutNDNEQmfQZkyBzKqG5qihOCrsFqjjuVwn2LLBRhthboQMGXdTB6UgqffmkMenAbAVQWBcCBwNzgAXBaqo7bwZWAE8ALwKbgO9UH8cTfS/AQWT4RPp6PxR7Adg2RydaBo3a3k+REewHgFlhfACLNBy2RRa3cw84HY8m0i+ENW6ZfvYDiA3R8UaIo8EMo3WmBzHY7cCVwBp3L5tGXYzq2pumBVrBEGYM2xkMIe2tHgrspboXPP/tFBYNmfRurWF3KPlt/U8he0G78fypOhU6cq6uWxSMR0YoC7gPuEhtzQdOAA6bUUgDkV6njn0StkicAUaVsKp4MpFeozYGt3UyRUgbm2E9GOSN6PpRCjnvobKQV1hbM75ZFkGax9arYy/p8yzpqxxgGUh7JhQui4buSQc4R9uaQTZEnlyt61UqLfPmWb6tYUOGxPOa69x6TR2rgFepLon0sqFDelGyCTty5wPXArcBDwAPAzeobCybfLrS99UNsl2QfVdWCNtEel3tIHPKxkN0/7oKnkykN7aaIC4BXaaOl8mwqfSO3L3XOolb255XATJzzy2uVcgWQIZVSxVJpJc3CXKBC8OsAuQjTYC0uXSe9mqqQr5Zi/q1JOTh+pe7LGTqlm2za518otLviwigDOR2l2Hr6c1oyfVRBcjM/fW3sBGQOn87Gm9lVyMn1xoyyrBjU4DcG7ZRfTt1r3qerlC/Zk0N1w1T8OQvYY6tO6SF6mkaXx6gn3Slx11btZ1CbKkVXoSyHTj/v4p/2cIfXT0/1oSKx8bjqpKhal4O2ynBMEv0/Xp6MYibJ8PLTOFPpgD7CvA+8BnwFbBZb3+9p3Eb3gZ5NO+9n78BSr4Sj07LciEAAAAASUVORK5CYII=",
 ["137578202023787"]="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",
 ["90508848541858"]="iVBORw0KGgoAAAANSUhEUgAAACgAAAAjCAYAAADmOUiuAAAACXBIWXMAAAPoAAAD6AG1e1JrAAAAsElEQVRYhd3TMQ3CUBhF4TOAAAY0sGIBB8yoYMAGQQZjLeCAGQsMCIDhkBpo+5ryesOX3O3lz1keKgO3sRu/WMnjU3rgbaLALtuxgSv1UyHwMjbw0HN4qsCnuhwTeK0U2NqXBi7Ul/UCm9LA3YCjUwa+1XVJ4LlyYOtYEviwfuC99JPMNuYO8B8Co2E4DIfhMByGw3AYDsNhOAyH4TAchsNwGA7DYTgMh+EwHHMH9PkCJ2tdwy7tM7MAAAAASUVORK5CYII=",
 ["115462650029863"]="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",
 ["89493120270980"]="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",
 ["128935317455601"]="iVBORw0KGgoAAAANSUhEUgAAAE4AAAAwCAYAAAC/gkysAAAACXBIWXMAAAPoAAAD6AG1e1JrAAAG10lEQVRogeWbCahUZRTHZ+ZlKkGoBUVWYpmFFRVYgSWWSRtERlokSURQYssLXotJBRFE0UpWIi1mBWYbRUVKUUQJbdBqm9lGttpiLul7M/cX53VO7/hx13HmvTfjgct3597vfvf7/vfs55tSqU4CytruCxwHPAh8AEzQ65V6x25rAnbS9iL+o83avlgPcECHHKUdCLhOBWyLtsv0eiYIAq6MY9y7QxAKDHCkAlbVdqYHNuX5sudKFfepdq/UroQuGtgH2KigbQJGZwHnnp0E3A0sVY79BRjZ1uDRx3FHK2gmrjcBZ6eJqgNOABP6Ftiq56f58duOgJ21nasL7gEioKa/r40zEg60Q/SZHn0mFPW2Ba4CXK7iiYJmAMohdKL2HapWs+KA2xP4yelHe36yjV9qJ3ILn+MAs0UbGffMjeMeYIi252q/bm1fsXe0I3Ad2r7qOCyOBMx/gOeAe0R3AYd5awqMUoNgtA743FnXSrv5bnN0oabPssg4cgOwGngCuAK4w43h9eOPwPi2AM9x2jQnWlEOwKrOAOTpb9b1gjz+4KAmJ1oHOIVeoz6qOTCrAcAe3FXA4f79LUcuoH8pQ681ggy4rS5h0GtMWpXbxrhAPioIRNoh9AXwFPCh6kGjh4ARfh6tqNumBEA0grzReBt4EvhSr5kYfwOc0nJhmLOkM4MF5SExIr8Ba4HvgR+AX4E/HfeG5D+MqQRxaw4cdJzn0jvm3ZdT8m495CcB+TtgOXAbMEsD+12AS10fA+p3YDaw3oFoFrzTz2fASR3ScsJ1AXOY/p5fB3BxJNz2DvCm/g713RTVdwZqNUiQDp78HXCExp0nAOOA4TEcd3OdwEXO1Ugju79cow27FjnALWVVUemIlZL+Au1g4DOdmKWGRLxeAxYBlwFdWk/wC6yXDMgiutLeeSWwm2VmUlSOAdo8MIHHVPmudQsbSKolfBxvgVepBb4OmC6Gw0tJjMrx3BmrmuoBTgJrlAO6Yw6fMxtoihJ+d2sy9GU1QucBEyWJkBPM4qKuQXfcpIxqgxC8mptTNaWfuD5vAYuB69Xw7JoUiTgws0FUnTFR/bRrgAdUv30VePGDmaKYGDiOEbpVJX2iGRrxFE5VgzgsAcRiHCkDAXto/WCF1gcEUAYJ5xUFM01iBNA1wCPAmcDuikE5sZxpicUQ4ZgAf4jzvaq0Jpm/mKR+vCP+tHoTJwNjPUemcp8D1Py4h1sctLxgxgEp4eHXyjhdSRZ8GznX9vQGgtbTAuBHCRxp816YBZxxm5j37Q23ogCwVtCTRp4jhdblBU4MBMHCo8AlSHOc/T0p3Dxa5wIs4rBQbKCc9SivqIrJzuKSKOO6VLNmubFv0et5xTYJqKLhWyOomhe4Y2Im/wewQLlnpYZtIRnQEvuOCXYA7Fcgo2z33wCeBT5V59YXjfqD++wdm/KmzQ+NSS7eHwAh1obg61vfea6iX3bnkt3N4mRfMuwNodTaS012glT+gSXBwppFNv5fRXYkGXd0aztf7w13FbAtMSbeb4X4P2Ohoc/aHMDZh1jh9W6Mj/lRjrEaBVymcbCJjXJpp+4gIzvEgbsheIEteoYt2vU/yHFkVAC43vDH+ZlD9fqN/VCBs4/yXl7g5Iu+rhy1XtvpAXCjY4CzRSwyjtP2To2Ffd+sya42UQ8im45gH0ozDYWt565U4AIQZdJ7afgxKgbcES5FFQWtGI6TggX6+xZPpmVohC5xnFsJgDvHjdVs4G4vAlxsfEYfcB2aYPQLxYGxUbPIW4P9cJ7SrKNdv9VxeYc77+wHUa2L40ynVGKyBvbVJbtADCgeEF9HsFayL8/EiHo4RtW5JWON+7R9PuHdzQDu3tzANcBRjoIIw4M5SZ8/P2PxFq2g9doZwXPWp1m0jc5uBHBld74yY/F+gbbIae75JTlEruos/Cq3w6nZZHNa3BDghJyynqqD59nWFborogZGAh8HE80q6uTdQra9Pp7N9/FSI4k+kb3aLTzNWhowFwdRyHgN04yr0gxGVvwcWmyfnAiPMIEQGisDbmlDgQs4b14wWZ/CtsPi26v0md4MtJ6Pc1a6aA4vzr352/mORchniy0y6io1g+hb/FEalIc708PzycFz1orYLnP9Q24JNyOGbk5Nt1tIEWp/raMcq3WFC7Uuu0DrKSu07xpNnW8O5mic/b79iaWp4AkBe4se00q8/IHkPtETwAvAWSmFEePeMyTMKWAx3wVu0OpdoXqpqAt15sfo1pDjZY6673l2Uq22oURQ+Enpl+Rc9xaR3Fiya112TS3U/SViwWVT4s/KabKVTPbAeCtvlSmLca0oFR65to9ZnPwv7DLbWDVDrlQAAAAASUVORK5CYII=",
 ["132671093599611"]="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",
 ["97503940758072"]="iVBORw0KGgoAAAANSUhEUgAAADAAAAAkCAYAAADPRbkKAAAACXBIWXMAAAPoAAAD6AG1e1JrAAABZElEQVRYhdWYvUoDQRhFA4IgVlZu3kAQIQ9gaZdp04qVr2CZKS1tbS0ts6WvYCUEnyBDSGElgiAcGdjAOM7MOksK74XdavmYw9yzfyNgNOA4Aq6BZ+ABOBww4wC4B5bADXA8ZC01F+8BF8Aj8MnPvAJnFbNOgJdoxhfwBMyA/V0CnAK3wJpyPrpd6Zt3Cbz3zHrrdud8KEBYkdrkKrWtTG2WpYr9tSK1iSuVqkxtkhXzpwlwB2zYbXxNrrqjrzK12XRrnngAh25WHqBFNwsPYNHN3AMYdDP1AA26GW9vc4oir8LngKLIixBAUeR5CKAo8jQEUBR5HL8LOTWBiQBaNYGJAKyawEQARk1gIoBGTWASX2ROSWASAK2SwCQArJLAJACMksAkABolgcn8VnEqApMBaFUEJgNgVQQmA2BUBCYD0KgITOHfqFMQmAJAqyAwBQCrIDAFAKMgMAWA/yjyL4H9Wr8BIA+jqmIsYeQAAAAASUVORK5CYII=",
 ["123379108834670"]="iVBORw0KGgoAAAANSUhEUgAAABwAAAAwCAYAAAACYxrZAAAACXBIWXMAAAPoAAAD6AG1e1JrAAACW0lEQVRYhb2YzYtOYRjGz5yhEeMjX9NgCisW8w+QpFjZsLaRj7IgpOQjzAxZ2Fr6C0gkWVHWFrKQj2bI99CEQsK8M+9PT+6n9+rpzPMuzv266+0+nffU9fzu677POc8pCucAui3vBL4B48BVYJ23VhScZfko/2LS8gQw6C3WBZR2fM2EGsBvO77rLVha3k4rmvb7BQy7CwI3jWjaBKcsn+xEo+ySMjZF9AWwyEusy3IP8EgEEcFwvsebbk9SwuhfiM/ACk+6ucDjhErFh3VxHnQHMnRfgAFdYF26BcDzCrqG5UvedIczdBPAap3RunSLgZeJiIoPedMdz9B9Avp1gXXplgPvMp15wZvuTBu6AU+6fuBDIqLiZ73pzietr8LvgWWedCut3WeiG/GmG8p4Nw70edDFB+tm4EeG7pwLnQjfr6CbFu/6POnWy7tJFd0JFzrx7nLGu5/AGl1gXbpB4CHwTMRU/HptsRAVr3zfxbNI9xFY6+ndJhNR33ToT3t5V1q+JeWLopFyDFjiQddteauUr6OdWVq+kZm71150peUNUsYqumP/g65p+a23d1vaeHdbF+fxCLqToQubzI21BWnRbWtDd0Svrx3AvUxnhrlbqNXwuGdOJSVU8UMudLS8WwV8TQSj2CgwvzZd4t++inI2OkU3D3iSeBbiD3AF6NXrPegOJnQxX9TPIS4B9CZ0TblfLnUZcg1g/wx0p1xnLgQwJ9kuR/9ehe2Yi28aFZ3ZmTtKDPFuUkbgqdvMFUkAO2yolW6v/edLJ6Lhs8du4A3wAJht533piqL4C4jk3ce5Gi5TAAAAAElFTkSuQmCC",
 ["134641266212807"]="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",
 ["133110292547731"]="iVBORw0KGgoAAAANSUhEUgAAABgAAAAwCAYAAAALiLqjAAAACXBIWXMAAAPoAAAD6AG1e1JrAAADNElEQVRYha2YO2gVURCGjSYSRY0E4wvxUaTxgQhG1EZUbARFECxUxDqIhSgBC+MDU9kY6ygEQrBIZ5CAoKD4CGpQUMQgRERNKiHiK/fe/eSEmTg7d++a7N1pZvfsOfPPzD/n7OzOmmUEmC36FPAAuA5cAuqBE8A1oAd4BtwEWoAas36OvY9JeGiMvwQWy/0h4C4wQbmUgKfAaaBJnSwD0QFgBfACWGOerQX+AJGAFICi6ACg8g24Day2Nr337UCHXNebMcSgl8iAhesgz4HtNuU2gpCKFgO8DPhq0pEmRZPGy7K+1hpvBO4DDQagPcV7LwVxMHBybspxA7AUeAQskvvlwKhJRZrnQe5MepyQfwVYCAwAS+T+ojFQqpCiyIzv07RM5T6h/juBVmAB8HkauddnP0z1xI27KOYBZ2QfWANvgTfAL5MS+/xjcKoigIKYSO4Z4hDiAoHDxNMzBvwWoBazm2u19JPStNl4GZEuYd5Pue4GNmkkZdGYzXbULFZRktMA9dkI0AXs8NWkJRYOtOnWvpViggMDSUQPmAVZpGScG/fGw7H8yUzMKgpwwxO8wZwn/yM4TTT6Vk/wYTchq2j0uzzBHRkJtqKRj+vutinqzwGgJPr9pF1DcB3wzk3KIprePu/9OrMrqyG4ILrDE7zfeJBHBR33BLc5D7JKJHqLj6A7B4BI9Ji+uKZ4AIZy2AMl0UP+qF4JfHdeZJGC6Fs2O+FitzGeB0Cb5VfbRTuh2hQd9BF05QAQGRvNsTcaMJgjwSOmAajRjm40xyPiofd+q5mUB8GdPv8nnQfVArT6CurJCSASvcdHMJxDeiLRYbOu8hyETfbBhJgFqGRazDrbSCjI3CpLtSi6v6yjk4EG4IvzZiZSEH0lRrAB2DiDfjRJdO2xSgBHzMSZAkTmelulFF2o4iyKzEumsYxgGeh1oc5EiqIHY0aN8fDB8EomTWQguSC6N7bBDMB8aZIwxrVDLkyDFwU4m0iwDDYD5+UHSPglQMpX/YT7naApOpAYgQMK32lNwF5pY/qA1ynva70PIOsTK0gHE79v/7WUoSnYGeocuCoH5BP5LxEiemzan1gF/QVfWoWNE0rj6AAAAABJRU5ErkJggg==",
 ["89484880162332"]="iVBORw0KGgoAAAANSUhEUgAAABgAAAAwCAYAAAALiLqjAAAACXBIWXMAAAPoAAAD6AG1e1JrAAADPElEQVRYha2YO2hUQRSGNy/UEAsFtYhGIRAUH5GIIIJoI2olaCVooaCmkKCFgkXUJjaCqJWKIBaRQIhYqQRECRYWgaQQBR8xgiAoPiIqJrt7P5nwT3J29m7c3XsPLGdm7sz5Z85rzmwmYwioAeocV78JWKT2WmAIGAYiZukK0AE0xMkIhdeqvRzYAFwDJoG9wA0JzFFMDvAFcAFo9fIKhIsvBE4D94B+4IMEjAM/1c4HwrMC8Kf6ofWtofB5wCOgB2jUWL8WTQVqiTtBXmCetoUATh2das8Xv6zJk2UAOPoK7ACWAPVWRc6Ag2rXGoN1zaF3S/57n9bVhQY+CYyZ/jQ6cDDQe67ESTzAea1rCI18XEZsMh5VDzz9j2CCDewudYJNwB+g3YwdjRF+G3gcCI3MvI1ezVa49/1bCqRWF1zyayuoW/PcHKsW/31YnlhTFGRe78AlYELqsv4eAe+B16ZPAHTdq0eOUhjN5iQtwGiwu7nIg7mg7ARWexsUqUrHawTealE+EJQvA+i3nOMssDjuBO2KXLuoHIqMQ/h1IxbAH2tPmcFViiKTMsbjAM4lBMCosjcO4H4KAFnxw2HCWwC8qsCD4iiKy6jewCuAbzETKyGbWZeF6tmecPd27cuZQDMAJ1LQf078bkGaEL+pj/ZmqpR8DJ0pMLDaz1KIgbza+0IPWgp8NhOrBfCnaAs9aD3JKS/+yV9e1sDh9VgN5cSfxBn4amCkaigb3A311gaDwS6SnKDTbt6niHcpqCgS32nV7xptKq7spGqF/wKaC240YL/ZfbUAefFRUxnOpAp3vaVl4IEC9ajTm6KBuwsMrE7SO8ACHAgNvFK1EAn0bzfXERp4K7OU1MAfXekeGrhFH+zEatUzVFRwacCVjEnugZz4nSIP0sBAMLFagK44F3Xl4puUVLQrDqAZ+J7AyJH4hHnCFhS9W8ykKJUqwhJwLCUDPyzlQX3BU7XSU2TFe0p50FiJV8uU+P8yrAc4VJSDNLAOOKVX/fgcGTUnYY77nwd245tjVWSA/NN1jatp9MfGA7mw+/8hzkYe4EtRijCCp1/2pZD1mFvlKmXgCHBRgTkC/BXA89hdZzKZf6JRouigf8pUAAAAAElFTkSuQmCC",
}
)
local initializeRemovals=function(App)
 local Players=game:GetService("Players")
 local Lighting=game:GetService("Lighting")
 local PlayerGui=Players.LocalPlayer:WaitForChild("PlayerGui")
 local F={Alive=true,Targets={},Connections={},MarkerNames={},Settings={Smoke=false,Flash=false,Fire=false,Explosions=false,Muzzle=false,Damage=false,Scope=false,EnemyMarkers=false,Pings=false,BulletEffects=false,Tracers=true,Impacts=true,BulletHoles=true,Blood=true,DamageNumbers=false},Stats={Targets=0,Changed=0,Errors=0}}
 App.Removals=F
 local shotCategories={Tracers=true,Impacts=true,BulletHoles=true,Blood=true}
 local impactMaterials={Wood=true,Sand=true,Metal=true,Concrete=true,Grass=true,Glass=true,Kevlar=true,Helmet=true}
 function F:IsEnabled(category)
  if shotCategories[category]then return self.Settings.BulletEffects and self.Settings[category]end
  return self.Settings[category]==true
 end
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
  local visual=instance:IsA("BasePart")or instance:IsA("ParticleEmitter")or instance:IsA("Beam")or instance:IsA("Trail")or instance:IsA("Smoke")or instance:IsA("Fire")or instance:IsA("Light")or instance:IsA("PostEffect")or instance:IsA("Decal")or instance:IsA("Explosion")or instance:IsA("ImageHandleAdornment")
  local gui=instance:IsA("GuiObject")or instance:IsA("ScreenGui")or instance:IsA("BillboardGui")
  local sound=instance:IsA("Sound")
  if not visual and not gui and not sound then return nil end
  local path=pathOf(instance)
  local parent=instance.Parent
  -- Only known cosmetic containers/tags: weapon meshes and physical projectiles stay intact.
  if instance:IsA("ImageHandleAdornment")and instance:HasTag("BulletHole")then return "BulletHoles"end
  if instance:IsA("Trail")and parent==workspace.Terrain and instance.Name=="Trail"then return "Tracers"end
  if instance:IsA("Beam")and parent and parent.Name=="_TrailHolder"and parent.Parent and parent.Parent:IsA("Camera")then return "Tracers"end
  if (instance:IsA("ParticleEmitter")or instance:IsA("Light"))and parent and parent:IsA("Attachment")then
   local pool=parent.Parent
   if pool and pool.Name=="phold"and pool.Parent==workspace.Terrain then
    local material=parent.Name:match("^(%a+)%d+$")
    if material=="Blood"or material=="Headshot"then return "Blood"end
    if impactMaterials[material]then return "Impacts"end
   end
  end
  if gui then
   if has(path,"/menu/")or has(path,"mintproject")then return nil end
   if instance:IsA("BillboardGui")and instance.Name=="Hit"and parent and parent:IsA("BasePart")and parent.Parent and parent.Parent.Name=="BBG"and parent.Parent.Parent==PlayerGui then return "DamageNumbers"end
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
  if instance:IsA("ImageHandleAdornment")then return {Visible=false,Transparency=1}end
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
     if not self.Alive or not record.Active or not self:IsEnabled(record.Category)then return end
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
  if record.Instance:IsA("ParticleEmitter")or record.Instance:IsA("Trail")then pcall(function()record.Instance:Clear()end)end
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
  if self:IsEnabled(category)then self:Apply(record)end
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
   if record.Category==category or category=="BulletEffects"and shotCategories[record.Category]then
    if self:IsEnabled(record.Category)then self:Apply(record)elseif record.Active then self:Restore(record)end
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
  for _,tag in ipairs({"Smoke","MollyFX","BulletHole"})do
   local function considerTree(instance)
    F:Consider(instance)
    for _,child in ipairs(instance:GetDescendants())do F:Consider(child)end
   end
   table.insert(F.Connections,Collection:GetInstanceAddedSignal(tag):Connect(considerTree))
   for _,instance in ipairs(Collection:GetTagged(tag))do considerTree(instance)end
  end
 end
 local section=App.Tabs.Visuals:AddSection({Name="REMOVALS",Position="left"})
 F.Rows={}
 for _,entry in ipairs({{"Smoke","No smoke"},{"Flash","No flash"},{"Fire","No fire effects"},{"Explosions","No explosion effects"},{"Muzzle","No muzzle flash"},{"Damage","No damage overlay"},{"Scope","No scope overlay"},{"EnemyMarkers","No enemy markers"},{"Pings","No ping markers"}})do
  local category=entry[1]
  local row=section:AddLabel(entry[2])
  local toggle=row:AddToggle({Default=false,Flag="removals_"..category,Callback=function(value)F:Set(category,value)end})
  toggle.Root.LayoutOrder=10
  F.Rows[category]={Row=row,Toggle=toggle}
 end
 local bullets=section:AddLabel("No bullet effects")
 local bulletToggle=bullets:AddToggle({Default=false,Flag="removals_BulletEffects",Callback=function(value)F:Set("BulletEffects",value)end})
 bulletToggle.Root.LayoutOrder=10
 F.Rows.BulletEffects={Row=bullets,Toggle=bulletToggle}
 local bulletOptions=bullets:AddOption();bulletOptions.Trigger.LayoutOrder=20;F.BulletOptions=bulletOptions
 for _,entry in ipairs({{"Tracers","Bullet tracers"},{"Impacts","Impact particles"},{"BulletHoles","Bullet holes"},{"Blood","Blood effects"}})do
  local category=entry[1]
  bulletOptions:AddLabel(entry[2]):AddToggle({Default=true,Flag="removals_"..category,Callback=function(value)F:Set(category,value)end})
 end
 local damageNumbers=section:AddLabel("No damage numbers")
 local numberToggle=damageNumbers:AddToggle({Default=false,Flag="removals_DamageNumbers",Callback=function(value)F:Set("DamageNumbers",value)end})
 numberToggle.Root.LayoutOrder=10
 F.Rows.DamageNumbers={Row=damageNumbers,Toggle=numberToggle}
 local unload=App.Library.Unload
 function App.Library:Unload()F:Destroy();return unload(self)end
 return F
end

initializeRemovals(App)
local initializeCrosshair=function(App)
 local Players=game:GetService("Players")
 local RunService=game:GetService("RunService")
 local LocalPlayer=Players.LocalPlayer
 local PlayerGui=LocalPlayer:WaitForChild("PlayerGui")
 local C={Alive=true,GameAngle=0,ScopeAngle=0,Settings={NoSniperZoom=false,Force=false,Custom=false,Size=100,Transparency=0,Length=8,Width=2,Gap=4,Dot=true,Outline=false,Color=Color3.fromRGB(242,245,250),Spin=false,SpinSpeed=90,ScopeSize=100,ScopeTransparency=0,ScopeLength=180,ScopeGap=6,ScopeSpin=false,ScopeSpinSpeed=90},Records={},Connections={},TargetConnections={},Strokes={},Stats={Errors=0}}
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
  if instance:IsA("Camera")and property=="FieldOfView"and not (self.Scope and self.Scope.Visible)then
   original=Variables and Variables.defaultfov or self.BaseFOV or original
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
   local camera=workspace.CurrentCamera
   if self.Settings.NoSniperZoom and scope and scope.Visible and camera then
    want(camera,"FieldOfView",Variables and Variables.defaultfov or self.BaseFOV or 70)
   elseif camera and not (scope and scope.Visible)then
    self.BaseFOV=Variables and Variables.defaultfov or camera.FieldOfView
   end
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
 table.insert(C.Connections,workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(schedule))
 local section=App.Tabs.Visuals:AddSection({Name="CROSSHAIR",Position="right"})
 section:AddLabel("No sniper zoom"):AddToggle({Default=false,Flag="crosshair_no_sniper_zoom",Callback=function(v)C:Set("NoSniperZoom",v)end})
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

initializeCrosshair(App)
local initializeWorld=function(App,Presets)
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

initializeWorld(App,{
 {Name="Aurora",Folder="Aurora"},
 {Name="Beautiful",Folder="Beautfil"},
 {Name="Blue",Folder="Blue"},
 {Name="Chill Gray",Folder="ChillGray"},
 {Name="Chill Pink",Folder="ChillPink"},
 {Name="Chroma Key",Folder="ChromaKey"},
 {Name="Cyan",Folder="Cyan"},
 {Name="Emo",Folder="Emo"},
 {Name="Goodnight",Folder="Goodnight"},
 {Name="Hades",Folder="Hades"},
 {Name="Hazy",Folder="Hazy"},
 {Name="Light Blue",Folder="LightBlue"},
 {Name="Light Pink",Folder="LightPink"},
 {Name="Moonlight",Folder="Moonlight"},
 {Name="Neon Sky",Folder="NeonSky"},
 {Name="Neon Sky2",Folder="NeonSky2"},
 {Name="Night",Folder="Night"},
 {Name="Orange",Folder="Orange"},
 {Name="Overcast",Folder="Overcast"},
 {Name="Pandora",Folder="Pandora"},
 {Name="Pink Sunrise",Folder="Pink Sunrise"},
 {Name="Red",Folder="Red"},
 {Name="Rem Ram",Folder="RemRam"},
 {Name="Space Blue",Folder="Space Blue"},
 {Name="Spooky",Folder="Spooky"},
 {Name="Universe",Folder="Universe"},
 {Name="Violet Evergarden",Folder="VioletEvergarden"},
 {Name="Yumeko",Folder="Yumeko"},
 {Name="Classic blue",Faces={"rbxasset://textures/sky/sky512_bk.tex","rbxasset://textures/sky/sky512_dn.tex","rbxasset://textures/sky/sky512_ft.tex","rbxasset://textures/sky/sky512_lf.tex","rbxasset://textures/sky/sky512_rt.tex","rbxasset://textures/sky/sky512_up.tex"}},
 {Name="Sunset",Faces={"rbxassetid://323494035","rbxassetid://323494368","rbxassetid://323494130","rbxassetid://323494252","rbxassetid://323494067","rbxassetid://323493360"}},
}
)
local initializeMovement=function(App)
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

initializeMovement(App)
local initializeRecoil=function(App)
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

initializeRecoil(App)
ENV.MintProjectNeverloseCS2=App
ENV.MintProjectUI=App
Window.Signal:SetValue(true)
return App
