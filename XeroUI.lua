

local Players = game:GetService("Players")
local Input = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")
local TweenService = game:GetService("TweenService")

local XeroEnv = (getgenv and getgenv()) or _G
local XERO_BACKGROUND_FOLDER = "XeroHub/Assets"

local function canonicalThemeName(name)
    local raw = tostring(name or "")
    local key = string.lower(raw)
    if key == "blanco" or key == "white" or key == "light" or key == "claro" then
        return "Blanco"
    end
    if key == "xero" or key == "nox" or key == "onyx" or key == "dark" or key == "oscuro" or key == "" then
        return "Xero"
    end
    for themeName in pairs(THEMES) do
        if string.lower(themeName) == key then
            return themeName
        end
    end
    return raw ~= "" and raw or "Xero"
end

local function deepCopy(value)
    if type(value) ~= "table" then return value end
    local out = {}
    for k, v in pairs(value) do
        out[k] = deepCopy(v)
    end
    return out
end

local function deepMerge(base, override)
    local out = deepCopy(base)
    if type(override) ~= "table" then return out end
    for k, v in pairs(override) do
        if type(v) == "table" and type(out[k]) == "table" and not (typeof and typeof(v) == "Color3") then
            local isColorList = true
            for _, item in pairs(v) do
                if typeof(item) ~= "Color3" and type(item) ~= "number" then
                    isColorList = false
                    break
                end
            end
            if isColorList and (k == "RootGradient" or k == "SliderTrackGradient" or k == "SliderFillGradient" or k == "AnimeShadeStops") then
                out[k] = deepCopy(v)
            else
                out[k] = deepMerge(out[k], v)
            end
        else
            out[k] = v
        end
    end
    return out
end

local THEME_BACKGROUNDS = {
    Xero = {
        URL = tostring(XeroEnv.XERO_BACKGROUND_URL or ""),
        CACHE = tostring(XeroEnv.XERO_BACKGROUND_CACHE or "XeroHub/Assets/custom_bg.png"),
    },
    Blanco = {
        URL = tostring(XeroEnv.XERO_BACKGROUND_LIGHT_URL or XeroEnv.XERO_BACKGROUND_WHITE_URL or ""),
        CACHE = tostring(XeroEnv.XERO_BACKGROUND_LIGHT_CACHE or XeroEnv.XERO_BACKGROUND_WHITE_CACHE or "XeroHub/Assets/custom_bg_light.png"),
    },
}

local THEMES = {
    Xero = {
        Name = "Xero",
        Colors = {
            Window = Color3.fromRGB(9,9,9), Panel = Color3.fromRGB(14,14,14),
            Row = Color3.fromRGB(20,20,20), Field = Color3.fromRGB(11,11,11),
            Hover = Color3.fromRGB(29,29,29), Border = Color3.fromRGB(42,42,42),
            Text = Color3.fromRGB(242,242,242), Muted = Color3.fromRGB(157,157,157),
            Faint = Color3.fromRGB(103,103,103), White = Color3.fromRGB(255,255,255),
        },
        Glass = {
            Root = 0.06,
            Sidebar = 0.20,
            Row = 0.28,
            Field = 0.32,
            Button = 0.22,
            NavIdle = 0.36,
            NavHover = 0.18,
            NavActive = 0.10,
            Popup = 0.10,
        },
        Visuals = {
            RootBase = Color3.fromRGB(7,7,7),
            RootStroke = Color3.fromRGB(48,48,48),
            RootGradient = {
                Color3.fromRGB(5,5,5),
                Color3.fromRGB(10,10,10),
                Color3.fromRGB(4,4,4),
            },
            AnimeImageTransparency = 0.06,
            AnimeShadeColor = Color3.fromRGB(0,0,0),
            AnimeShadeTransparency = 0.64,
            AnimeShadeStops = {0.00, 0.10, 0.30},
            SidebarBase = Color3.fromRGB(10,10,10),
            SidebarStroke = Color3.fromRGB(28,28,28),
            SearchStroke = Color3.fromRGB(32,32,32),
            OpenStroke = Color3.fromRGB(66,66,66),
            OpenButtonBase = Color3.fromRGB(9,9,9),
            BackdropGlowA = Color3.fromRGB(26,26,28),
            BackdropGlowB = Color3.fromRGB(20,20,24),
            BackdropWatermarkTransparency = 0.974,
            GridColor = Color3.fromRGB(255,255,255),
            GridVTransparency = 0.952,
            GridHTransparency = 0.962,
            NavButtonIdle = Color3.fromRGB(10,10,10),
            NavButtonHover = Color3.fromRGB(18,18,18),
            ResizeGuideTransparency = 0.32,
            ControlStroke = Color3.fromRGB(31,31,31),
            FieldStroke = Color3.fromRGB(30,30,30),
            ButtonBase = Color3.fromRGB(14,14,14),
            ButtonStroke = Color3.fromRGB(30,30,30),
            DropdownStroke = Color3.fromRGB(28,28,28),
            PopupStroke = Color3.fromRGB(66,66,66),
            GothicShell = Color3.fromRGB(255,255,255),
            GothicShellStroke = Color3.fromRGB(72,72,78),
            GothicGlow = Color3.fromRGB(26,26,32),
            GothicBar = Color3.fromRGB(64,64,72),
            GothicCorner = Color3.fromRGB(86,86,92),
            GothicWatermark = Color3.fromRGB(255,255,255),
            GothicWatermarkTransparency = 0.952,
            GothicRow = Color3.fromRGB(11,11,14),
            GothicStroke = Color3.fromRGB(42,42,48),
            GothicDesc = Color3.fromRGB(178,178,178),
            GothicBadgeText = Color3.fromRGB(252,252,252),
            GothicBadgeBackground = Color3.fromRGB(18,18,18),
            GothicBadgeStroke = Color3.fromRGB(54,54,58),
            SliderValueBackground = Color3.fromRGB(11,11,11),
            SliderValueText = Color3.fromRGB(242,242,242),
            SliderValueStroke = Color3.fromRGB(42,42,42),
            SliderRail = Color3.fromRGB(18,18,18),
            SliderRailStroke = Color3.fromRGB(37,37,40),
            SliderTrack = Color3.fromRGB(43,43,46),
            SliderTrackGradient = {Color3.fromRGB(36,36,39),Color3.fromRGB(48,48,51),Color3.fromRGB(36,36,39)},
            SliderFill = Color3.fromRGB(232,232,232),
            SliderFillGradient = {Color3.fromRGB(255,255,255),Color3.fromRGB(200,200,204)},
            SliderHalo = Color3.fromRGB(255,255,255),
            SliderThumb = Color3.fromRGB(248,248,248),
            SliderThumbStroke = Color3.fromRGB(72,72,76),
        },
    },
    Blanco = {
        Name = "Blanco",
        Colors = {
            Window = Color3.fromRGB(248,248,250), Panel = Color3.fromRGB(241,241,244),
            Row = Color3.fromRGB(232,232,236), Field = Color3.fromRGB(252,252,255),
            Hover = Color3.fromRGB(223,223,228), Border = Color3.fromRGB(201,201,208),
            Text = Color3.fromRGB(20,20,24), Muted = Color3.fromRGB(88,88,98),
            Faint = Color3.fromRGB(122,122,132), White = Color3.fromRGB(255,255,255),
        },
        Glass = {
            Root = 0.02,
            Sidebar = 0.08,
            Row = 0.12,
            Field = 0.04,
            Button = 0.08,
            NavIdle = 0.08,
            NavHover = 0.02,
            NavActive = 0.00,
            Popup = 0.04,
        },
        Visuals = {
            RootBase = Color3.fromRGB(250,250,252),
            RootStroke = Color3.fromRGB(210,210,216),
            RootGradient = {
                Color3.fromRGB(255,255,255),
                Color3.fromRGB(245,245,248),
                Color3.fromRGB(236,236,240),
            },
            AnimeImageTransparency = 0.02,
            AnimeShadeColor = Color3.fromRGB(255,255,255),
            AnimeShadeTransparency = 0.48,
            AnimeShadeStops = {0.00, 0.08, 0.22},
            SidebarBase = Color3.fromRGB(244,244,247),
            SidebarStroke = Color3.fromRGB(214,214,220),
            SearchStroke = Color3.fromRGB(206,206,212),
            OpenStroke = Color3.fromRGB(190,190,198),
            OpenButtonBase = Color3.fromRGB(247,247,250),
            BackdropGlowA = Color3.fromRGB(225,225,230),
            BackdropGlowB = Color3.fromRGB(234,234,239),
            BackdropWatermarkTransparency = 0.94,
            GridColor = Color3.fromRGB(30,30,35),
            GridVTransparency = 0.965,
            GridHTransparency = 0.972,
            NavButtonIdle = Color3.fromRGB(238,238,242),
            NavButtonHover = Color3.fromRGB(229,229,234),
            ResizeGuideTransparency = 0.42,
            ControlStroke = Color3.fromRGB(198,198,205),
            FieldStroke = Color3.fromRGB(202,202,209),
            ButtonBase = Color3.fromRGB(246,246,249),
            ButtonStroke = Color3.fromRGB(202,202,209),
            DropdownStroke = Color3.fromRGB(202,202,209),
            PopupStroke = Color3.fromRGB(190,190,198),
            GothicShell = Color3.fromRGB(255,255,255),
            GothicShellStroke = Color3.fromRGB(202,202,210),
            GothicGlow = Color3.fromRGB(226,226,232),
            GothicBar = Color3.fromRGB(194,194,203),
            GothicCorner = Color3.fromRGB(184,184,194),
            GothicWatermark = Color3.fromRGB(28,28,34),
            GothicWatermarkTransparency = 0.90,
            GothicRow = Color3.fromRGB(238,238,242),
            GothicStroke = Color3.fromRGB(198,198,206),
            GothicDesc = Color3.fromRGB(92,92,102),
            GothicBadgeText = Color3.fromRGB(32,32,38),
            GothicBadgeBackground = Color3.fromRGB(233,233,238),
            GothicBadgeStroke = Color3.fromRGB(198,198,206),
            SliderValueBackground = Color3.fromRGB(252,252,255),
            SliderValueText = Color3.fromRGB(20,20,24),
            SliderValueStroke = Color3.fromRGB(198,198,205),
            SliderRail = Color3.fromRGB(225,225,231),
            SliderRailStroke = Color3.fromRGB(190,190,199),
            SliderTrack = Color3.fromRGB(207,207,215),
            SliderTrackGradient = {Color3.fromRGB(198,198,207),Color3.fromRGB(217,217,224),Color3.fromRGB(198,198,207)},
            SliderFill = Color3.fromRGB(50,50,56),
            SliderFillGradient = {Color3.fromRGB(20,20,24),Color3.fromRGB(78,78,86)},
            SliderHalo = Color3.fromRGB(20,20,24),
            SliderThumb = Color3.fromRGB(250,250,252),

            SliderThumbStroke = Color3.fromRGB(118,118,128),
        },
    },
    Midnight = {
        Name = "Midnight",
        Colors = {
            Window = Color3.fromRGB(8,10,18), Panel = Color3.fromRGB(12,15,26),
            Row = Color3.fromRGB(18,22,36), Field = Color3.fromRGB(10,12,20),
            Hover = Color3.fromRGB(28,34,52), Border = Color3.fromRGB(48,56,82),
            Text = Color3.fromRGB(230,235,255), Muted = Color3.fromRGB(140,150,185),
            Faint = Color3.fromRGB(90,100,130), White = Color3.fromRGB(255,255,255),
        },
        Glass = { Root = 0.07, Sidebar = 0.22, Row = 0.30, Field = 0.34, Button = 0.24, NavIdle = 0.38, NavHover = 0.18, NavActive = 0.10, Popup = 0.12 },
        Visuals = {
            RootBase = Color3.fromRGB(6,8,14), RootStroke = Color3.fromRGB(55,65,95),
            RootGradient = { Color3.fromRGB(5,7,14), Color3.fromRGB(12,16,28), Color3.fromRGB(4,6,12) },
            AnimeImageTransparency = 0.08, AnimeShadeColor = Color3.fromRGB(0,0,0), AnimeShadeTransparency = 0.62, AnimeShadeStops = {0.00,0.12,0.32},
            SidebarBase = Color3.fromRGB(10,12,22), SidebarStroke = Color3.fromRGB(36,42,64),
            SearchStroke = Color3.fromRGB(40,48,70), OpenStroke = Color3.fromRGB(70,80,110), OpenButtonBase = Color3.fromRGB(8,10,18),
            BackdropGlowA = Color3.fromRGB(40,50,90), BackdropGlowB = Color3.fromRGB(20,28,50), BackdropWatermarkTransparency = 0.97,
            GridColor = Color3.fromRGB(180,190,255), GridVTransparency = 0.955, GridHTransparency = 0.965,
            NavButtonIdle = Color3.fromRGB(12,14,24), NavButtonHover = Color3.fromRGB(22,26,42), ResizeGuideTransparency = 0.35,
            ControlStroke = Color3.fromRGB(42,50,72), FieldStroke = Color3.fromRGB(40,48,68), ButtonBase = Color3.fromRGB(16,20,32), ButtonStroke = Color3.fromRGB(42,50,72),
            DropdownStroke = Color3.fromRGB(40,48,68), PopupStroke = Color3.fromRGB(70,80,110),
            GothicShell = Color3.fromRGB(255,255,255), GothicShellStroke = Color3.fromRGB(70,80,110), GothicGlow = Color3.fromRGB(30,36,60),
            GothicBar = Color3.fromRGB(70,80,110), GothicCorner = Color3.fromRGB(90,100,130), GothicWatermark = Color3.fromRGB(255,255,255), GothicWatermarkTransparency = 0.95,
            GothicRow = Color3.fromRGB(12,14,24), GothicStroke = Color3.fromRGB(48,56,82), GothicDesc = Color3.fromRGB(160,170,200),
            GothicBadgeText = Color3.fromRGB(240,245,255), GothicBadgeBackground = Color3.fromRGB(16,20,32), GothicBadgeStroke = Color3.fromRGB(55,65,95),
            SliderValueBackground = Color3.fromRGB(10,12,20), SliderValueText = Color3.fromRGB(230,235,255), SliderValueStroke = Color3.fromRGB(48,56,82),
            SliderRail = Color3.fromRGB(16,20,32), SliderRailStroke = Color3.fromRGB(42,50,72), SliderTrack = Color3.fromRGB(40,48,70),
            SliderTrackGradient = { Color3.fromRGB(32,40,60), Color3.fromRGB(48,56,82), Color3.fromRGB(32,40,60) },
            SliderFill = Color3.fromRGB(120,150,255), SliderFillGradient = { Color3.fromRGB(160,180,255), Color3.fromRGB(80,110,220) },
            SliderHalo = Color3.fromRGB(120,150,255), SliderThumb = Color3.fromRGB(240,245,255), SliderThumbStroke = Color3.fromRGB(80,100,160),
        },
    },
    Ocean = {
        Name = "Ocean",
        Colors = {
            Window = Color3.fromRGB(6,14,18), Panel = Color3.fromRGB(10,20,26),
            Row = Color3.fromRGB(14,28,34), Field = Color3.fromRGB(8,16,20),
            Hover = Color3.fromRGB(22,42,50), Border = Color3.fromRGB(36,70,80),
            Text = Color3.fromRGB(220,245,250), Muted = Color3.fromRGB(120,170,180),
            Faint = Color3.fromRGB(70,110,120), White = Color3.fromRGB(255,255,255),
        },
        Glass = { Root = 0.07, Sidebar = 0.22, Row = 0.30, Field = 0.34, Button = 0.24, NavIdle = 0.38, NavHover = 0.18, NavActive = 0.10, Popup = 0.12 },
        Visuals = {
            RootBase = Color3.fromRGB(4,12,16), RootStroke = Color3.fromRGB(40,80,90),
            RootGradient = { Color3.fromRGB(4,12,16), Color3.fromRGB(10,24,30), Color3.fromRGB(3,10,14) },
            AnimeImageTransparency = 0.08, AnimeShadeColor = Color3.fromRGB(0,0,0), AnimeShadeTransparency = 0.62, AnimeShadeStops = {0.00,0.12,0.32},
            SidebarBase = Color3.fromRGB(8,18,22), SidebarStroke = Color3.fromRGB(28,55,62),
            SearchStroke = Color3.fromRGB(32,60,68), OpenStroke = Color3.fromRGB(50,100,110), OpenButtonBase = Color3.fromRGB(6,14,18),
            BackdropGlowA = Color3.fromRGB(20,70,80), BackdropGlowB = Color3.fromRGB(10,40,50), BackdropWatermarkTransparency = 0.97,
            GridColor = Color3.fromRGB(120,220,230), GridVTransparency = 0.955, GridHTransparency = 0.965,
            NavButtonIdle = Color3.fromRGB(10,20,24), NavButtonHover = Color3.fromRGB(18,34,40), ResizeGuideTransparency = 0.35,
            ControlStroke = Color3.fromRGB(34,64,72), FieldStroke = Color3.fromRGB(32,60,68), ButtonBase = Color3.fromRGB(12,24,30), ButtonStroke = Color3.fromRGB(34,64,72),
            DropdownStroke = Color3.fromRGB(32,60,68), PopupStroke = Color3.fromRGB(50,100,110),
            GothicShell = Color3.fromRGB(255,255,255), GothicShellStroke = Color3.fromRGB(50,100,110), GothicGlow = Color3.fromRGB(16,40,48),
            GothicBar = Color3.fromRGB(50,100,110), GothicCorner = Color3.fromRGB(70,120,130), GothicWatermark = Color3.fromRGB(255,255,255), GothicWatermarkTransparency = 0.95,
            GothicRow = Color3.fromRGB(10,20,24), GothicStroke = Color3.fromRGB(36,70,80), GothicDesc = Color3.fromRGB(140,190,200),
            GothicBadgeText = Color3.fromRGB(230,250,255), GothicBadgeBackground = Color3.fromRGB(12,24,30), GothicBadgeStroke = Color3.fromRGB(40,80,90),
            SliderValueBackground = Color3.fromRGB(8,16,20), SliderValueText = Color3.fromRGB(220,245,250), SliderValueStroke = Color3.fromRGB(36,70,80),
            SliderRail = Color3.fromRGB(12,24,30), SliderRailStroke = Color3.fromRGB(34,64,72), SliderTrack = Color3.fromRGB(32,60,70),
            SliderTrackGradient = { Color3.fromRGB(24,48,56), Color3.fromRGB(36,70,80), Color3.fromRGB(24,48,56) },
            SliderFill = Color3.fromRGB(60,200,210), SliderFillGradient = { Color3.fromRGB(120,230,240), Color3.fromRGB(30,160,175) },
            SliderHalo = Color3.fromRGB(60,200,210), SliderThumb = Color3.fromRGB(240,252,255), SliderThumbStroke = Color3.fromRGB(50,130,140),
        },
    },
    Emerald = {
        Name = "Emerald",
        Colors = {
            Window = Color3.fromRGB(8,14,10), Panel = Color3.fromRGB(12,20,14),
            Row = Color3.fromRGB(16,28,20), Field = Color3.fromRGB(10,16,12),
            Hover = Color3.fromRGB(24,42,30), Border = Color3.fromRGB(42,72,50),
            Text = Color3.fromRGB(230,250,235), Muted = Color3.fromRGB(130,175,145),
            Faint = Color3.fromRGB(80,115,90), White = Color3.fromRGB(255,255,255),
        },
        Glass = { Root = 0.07, Sidebar = 0.22, Row = 0.30, Field = 0.34, Button = 0.24, NavIdle = 0.38, NavHover = 0.18, NavActive = 0.10, Popup = 0.12 },
        Visuals = {
            RootBase = Color3.fromRGB(6,12,8), RootStroke = Color3.fromRGB(48,80,55),
            RootGradient = { Color3.fromRGB(5,12,8), Color3.fromRGB(12,22,14), Color3.fromRGB(4,10,6) },
            AnimeImageTransparency = 0.08, AnimeShadeColor = Color3.fromRGB(0,0,0), AnimeShadeTransparency = 0.62, AnimeShadeStops = {0.00,0.12,0.32},
            SidebarBase = Color3.fromRGB(10,18,12), SidebarStroke = Color3.fromRGB(32,55,38),
            SearchStroke = Color3.fromRGB(36,60,42), OpenStroke = Color3.fromRGB(55,95,65), OpenButtonBase = Color3.fromRGB(8,14,10),
            BackdropGlowA = Color3.fromRGB(30,70,40), BackdropGlowB = Color3.fromRGB(16,40,22), BackdropWatermarkTransparency = 0.97,
            GridColor = Color3.fromRGB(140,230,160), GridVTransparency = 0.955, GridHTransparency = 0.965,
            NavButtonIdle = Color3.fromRGB(10,18,12), NavButtonHover = Color3.fromRGB(18,32,22), ResizeGuideTransparency = 0.35,
            ControlStroke = Color3.fromRGB(38,64,44), FieldStroke = Color3.fromRGB(36,60,42), ButtonBase = Color3.fromRGB(14,24,16), ButtonStroke = Color3.fromRGB(38,64,44),
            DropdownStroke = Color3.fromRGB(36,60,42), PopupStroke = Color3.fromRGB(55,95,65),
            GothicShell = Color3.fromRGB(255,255,255), GothicShellStroke = Color3.fromRGB(55,95,65), GothicGlow = Color3.fromRGB(20,40,24),
            GothicBar = Color3.fromRGB(55,95,65), GothicCorner = Color3.fromRGB(75,120,85), GothicWatermark = Color3.fromRGB(255,255,255), GothicWatermarkTransparency = 0.95,
            GothicRow = Color3.fromRGB(10,18,12), GothicStroke = Color3.fromRGB(42,72,50), GothicDesc = Color3.fromRGB(150,195,160),
            GothicBadgeText = Color3.fromRGB(235,250,240), GothicBadgeBackground = Color3.fromRGB(14,24,16), GothicBadgeStroke = Color3.fromRGB(48,80,55),
            SliderValueBackground = Color3.fromRGB(10,16,12), SliderValueText = Color3.fromRGB(230,250,235), SliderValueStroke = Color3.fromRGB(42,72,50),
            SliderRail = Color3.fromRGB(14,24,16), SliderRailStroke = Color3.fromRGB(38,64,44), SliderTrack = Color3.fromRGB(36,60,42),
            SliderTrackGradient = { Color3.fromRGB(28,48,32), Color3.fromRGB(42,72,50), Color3.fromRGB(28,48,32) },
            SliderFill = Color3.fromRGB(70,210,120), SliderFillGradient = { Color3.fromRGB(120,240,160), Color3.fromRGB(40,170,90) },
            SliderHalo = Color3.fromRGB(70,210,120), SliderThumb = Color3.fromRGB(240,255,245), SliderThumbStroke = Color3.fromRGB(50,140,80),
        },
    },
    Crimson = {
        Name = "Crimson",
        Colors = {
            Window = Color3.fromRGB(16,8,8), Panel = Color3.fromRGB(22,12,12),
            Row = Color3.fromRGB(30,16,16), Field = Color3.fromRGB(14,8,8),
            Hover = Color3.fromRGB(48,22,22), Border = Color3.fromRGB(80,36,36),
            Text = Color3.fromRGB(255,235,235), Muted = Color3.fromRGB(185,130,130),
            Faint = Color3.fromRGB(120,80,80), White = Color3.fromRGB(255,255,255),
        },
        Glass = { Root = 0.07, Sidebar = 0.22, Row = 0.30, Field = 0.34, Button = 0.24, NavIdle = 0.38, NavHover = 0.18, NavActive = 0.10, Popup = 0.12 },
        Visuals = {
            RootBase = Color3.fromRGB(12,6,6), RootStroke = Color3.fromRGB(90,40,40),
            RootGradient = { Color3.fromRGB(12,6,6), Color3.fromRGB(22,10,10), Color3.fromRGB(10,5,5) },
            AnimeImageTransparency = 0.08, AnimeShadeColor = Color3.fromRGB(0,0,0), AnimeShadeTransparency = 0.62, AnimeShadeStops = {0.00,0.12,0.32},
            SidebarBase = Color3.fromRGB(18,10,10), SidebarStroke = Color3.fromRGB(60,28,28),
            SearchStroke = Color3.fromRGB(70,32,32), OpenStroke = Color3.fromRGB(110,50,50), OpenButtonBase = Color3.fromRGB(16,8,8),
            BackdropGlowA = Color3.fromRGB(80,20,20), BackdropGlowB = Color3.fromRGB(40,12,12), BackdropWatermarkTransparency = 0.97,
            GridColor = Color3.fromRGB(255,140,140), GridVTransparency = 0.955, GridHTransparency = 0.965,
            NavButtonIdle = Color3.fromRGB(18,10,10), NavButtonHover = Color3.fromRGB(32,16,16), ResizeGuideTransparency = 0.35,
            ControlStroke = Color3.fromRGB(70,32,32), FieldStroke = Color3.fromRGB(65,30,30), ButtonBase = Color3.fromRGB(24,12,12), ButtonStroke = Color3.fromRGB(70,32,32),
            DropdownStroke = Color3.fromRGB(65,30,30), PopupStroke = Color3.fromRGB(110,50,50),
            GothicShell = Color3.fromRGB(255,255,255), GothicShellStroke = Color3.fromRGB(110,50,50), GothicGlow = Color3.fromRGB(40,14,14),
            GothicBar = Color3.fromRGB(110,50,50), GothicCorner = Color3.fromRGB(140,70,70), GothicWatermark = Color3.fromRGB(255,255,255), GothicWatermarkTransparency = 0.95,
            GothicRow = Color3.fromRGB(18,10,10), GothicStroke = Color3.fromRGB(80,36,36), GothicDesc = Color3.fromRGB(200,150,150),
            GothicBadgeText = Color3.fromRGB(255,240,240), GothicBadgeBackground = Color3.fromRGB(24,12,12), GothicBadgeStroke = Color3.fromRGB(90,40,40),
            SliderValueBackground = Color3.fromRGB(14,8,8), SliderValueText = Color3.fromRGB(255,235,235), SliderValueStroke = Color3.fromRGB(80,36,36),
            SliderRail = Color3.fromRGB(24,12,12), SliderRailStroke = Color3.fromRGB(70,32,32), SliderTrack = Color3.fromRGB(60,28,28),
            SliderTrackGradient = { Color3.fromRGB(48,22,22), Color3.fromRGB(80,36,36), Color3.fromRGB(48,22,22) },
            SliderFill = Color3.fromRGB(230,70,70), SliderFillGradient = { Color3.fromRGB(255,120,120), Color3.fromRGB(180,40,40) },
            SliderHalo = Color3.fromRGB(230,70,70), SliderThumb = Color3.fromRGB(255,245,245), SliderThumbStroke = Color3.fromRGB(150,60,60),
        },
    },
    Violet = {
        Name = "Violet",
        Colors = {
            Window = Color3.fromRGB(12,8,18), Panel = Color3.fromRGB(18,12,26),
            Row = Color3.fromRGB(26,18,36), Field = Color3.fromRGB(14,10,20),
            Hover = Color3.fromRGB(40,28,55), Border = Color3.fromRGB(70,50,95),
            Text = Color3.fromRGB(240,230,255), Muted = Color3.fromRGB(165,145,195),
            Faint = Color3.fromRGB(110,90,135), White = Color3.fromRGB(255,255,255),
        },
        Glass = { Root = 0.07, Sidebar = 0.22, Row = 0.30, Field = 0.34, Button = 0.24, NavIdle = 0.38, NavHover = 0.18, NavActive = 0.10, Popup = 0.12 },
        Visuals = {
            RootBase = Color3.fromRGB(10,6,14), RootStroke = Color3.fromRGB(80,55,110),
            RootGradient = { Color3.fromRGB(10,6,14), Color3.fromRGB(18,12,26), Color3.fromRGB(8,5,12) },
            AnimeImageTransparency = 0.08, AnimeShadeColor = Color3.fromRGB(0,0,0), AnimeShadeTransparency = 0.62, AnimeShadeStops = {0.00,0.12,0.32},
            SidebarBase = Color3.fromRGB(14,10,22), SidebarStroke = Color3.fromRGB(50,36,70),
            SearchStroke = Color3.fromRGB(55,40,75), OpenStroke = Color3.fromRGB(95,70,130), OpenButtonBase = Color3.fromRGB(12,8,18),
            BackdropGlowA = Color3.fromRGB(70,40,110), BackdropGlowB = Color3.fromRGB(35,20,55), BackdropWatermarkTransparency = 0.97,
            GridColor = Color3.fromRGB(200,160,255), GridVTransparency = 0.955, GridHTransparency = 0.965,
            NavButtonIdle = Color3.fromRGB(14,10,22), NavButtonHover = Color3.fromRGB(26,18,38), ResizeGuideTransparency = 0.35,
            ControlStroke = Color3.fromRGB(60,42,82), FieldStroke = Color3.fromRGB(55,40,75), ButtonBase = Color3.fromRGB(20,14,30), ButtonStroke = Color3.fromRGB(60,42,82),
            DropdownStroke = Color3.fromRGB(55,40,75), PopupStroke = Color3.fromRGB(95,70,130),
            GothicShell = Color3.fromRGB(255,255,255), GothicShellStroke = Color3.fromRGB(95,70,130), GothicGlow = Color3.fromRGB(30,18,50),
            GothicBar = Color3.fromRGB(95,70,130), GothicCorner = Color3.fromRGB(120,90,160), GothicWatermark = Color3.fromRGB(255,255,255), GothicWatermarkTransparency = 0.95,
            GothicRow = Color3.fromRGB(14,10,22), GothicStroke = Color3.fromRGB(70,50,95), GothicDesc = Color3.fromRGB(180,160,210),
            GothicBadgeText = Color3.fromRGB(245,240,255), GothicBadgeBackground = Color3.fromRGB(20,14,30), GothicBadgeStroke = Color3.fromRGB(80,55,110),
            SliderValueBackground = Color3.fromRGB(14,10,20), SliderValueText = Color3.fromRGB(240,230,255), SliderValueStroke = Color3.fromRGB(70,50,95),
            SliderRail = Color3.fromRGB(20,14,30), SliderRailStroke = Color3.fromRGB(60,42,82), SliderTrack = Color3.fromRGB(50,36,70),
            SliderTrackGradient = { Color3.fromRGB(40,28,55), Color3.fromRGB(70,50,95), Color3.fromRGB(40,28,55) },
            SliderFill = Color3.fromRGB(170,110,255), SliderFillGradient = { Color3.fromRGB(210,160,255), Color3.fromRGB(120,70,210) },
            SliderHalo = Color3.fromRGB(170,110,255), SliderThumb = Color3.fromRGB(250,245,255), SliderThumbStroke = Color3.fromRGB(120,80,180),
        },
    },
    Amber = {
        Name = "Amber",
        Colors = {
            Window = Color3.fromRGB(16,12,6), Panel = Color3.fromRGB(22,18,10),
            Row = Color3.fromRGB(32,26,14), Field = Color3.fromRGB(14,12,8),
            Hover = Color3.fromRGB(48,38,20), Border = Color3.fromRGB(90,70,30),
            Text = Color3.fromRGB(255,245,220), Muted = Color3.fromRGB(190,165,110),
            Faint = Color3.fromRGB(120,100,60), White = Color3.fromRGB(255,255,255),
        },
        Glass = { Root = 0.07, Sidebar = 0.22, Row = 0.30, Field = 0.34, Button = 0.24, NavIdle = 0.38, NavHover = 0.18, NavActive = 0.10, Popup = 0.12 },
        Visuals = {
            RootBase = Color3.fromRGB(12,10,5), RootStroke = Color3.fromRGB(100,80,35),
            RootGradient = { Color3.fromRGB(12,10,5), Color3.fromRGB(22,18,10), Color3.fromRGB(10,8,4) },
            AnimeImageTransparency = 0.08, AnimeShadeColor = Color3.fromRGB(0,0,0), AnimeShadeTransparency = 0.62, AnimeShadeStops = {0.00,0.12,0.32},
            SidebarBase = Color3.fromRGB(18,14,8), SidebarStroke = Color3.fromRGB(65,50,22),
            SearchStroke = Color3.fromRGB(75,58,25), OpenStroke = Color3.fromRGB(120,95,40), OpenButtonBase = Color3.fromRGB(16,12,6),
            BackdropGlowA = Color3.fromRGB(90,70,20), BackdropGlowB = Color3.fromRGB(45,35,10), BackdropWatermarkTransparency = 0.97,
            GridColor = Color3.fromRGB(255,210,120), GridVTransparency = 0.955, GridHTransparency = 0.965,
            NavButtonIdle = Color3.fromRGB(18,14,8), NavButtonHover = Color3.fromRGB(30,24,12), ResizeGuideTransparency = 0.35,
            ControlStroke = Color3.fromRGB(75,58,25), FieldStroke = Color3.fromRGB(70,55,24), ButtonBase = Color3.fromRGB(24,18,10), ButtonStroke = Color3.fromRGB(75,58,25),
            DropdownStroke = Color3.fromRGB(70,55,24), PopupStroke = Color3.fromRGB(120,95,40),
            GothicShell = Color3.fromRGB(255,255,255), GothicShellStroke = Color3.fromRGB(120,95,40), GothicGlow = Color3.fromRGB(40,30,10),
            GothicBar = Color3.fromRGB(120,95,40), GothicCorner = Color3.fromRGB(150,120,50), GothicWatermark = Color3.fromRGB(255,255,255), GothicWatermarkTransparency = 0.95,
            GothicRow = Color3.fromRGB(18,14,8), GothicStroke = Color3.fromRGB(90,70,30), GothicDesc = Color3.fromRGB(210,185,130),
            GothicBadgeText = Color3.fromRGB(255,250,230), GothicBadgeBackground = Color3.fromRGB(24,18,10), GothicBadgeStroke = Color3.fromRGB(100,80,35),
            SliderValueBackground = Color3.fromRGB(14,12,8), SliderValueText = Color3.fromRGB(255,245,220), SliderValueStroke = Color3.fromRGB(90,70,30),
            SliderRail = Color3.fromRGB(24,18,10), SliderRailStroke = Color3.fromRGB(75,58,25), SliderTrack = Color3.fromRGB(65,50,22),
            SliderTrackGradient = { Color3.fromRGB(48,38,20), Color3.fromRGB(90,70,30), Color3.fromRGB(48,38,20) },
            SliderFill = Color3.fromRGB(240,180,50), SliderFillGradient = { Color3.fromRGB(255,210,100), Color3.fromRGB(200,140,30) },
            SliderHalo = Color3.fromRGB(240,180,50), SliderThumb = Color3.fromRGB(255,250,235), SliderThumbStroke = Color3.fromRGB(160,120,40),
        },
    },
    Cyber = {
        Name = "Cyber",
        Colors = {
            Window = Color3.fromRGB(6,10,12), Panel = Color3.fromRGB(10,16,18),
            Row = Color3.fromRGB(14,24,26), Field = Color3.fromRGB(8,12,14),
            Hover = Color3.fromRGB(20,40,42), Border = Color3.fromRGB(30,90,85),
            Text = Color3.fromRGB(200,255,250), Muted = Color3.fromRGB(100,180,170),
            Faint = Color3.fromRGB(60,120,115), White = Color3.fromRGB(255,255,255),
        },
        Glass = { Root = 0.08, Sidebar = 0.24, Row = 0.32, Field = 0.36, Button = 0.26, NavIdle = 0.40, NavHover = 0.20, NavActive = 0.10, Popup = 0.14 },
        Visuals = {
            RootBase = Color3.fromRGB(4,8,10), RootStroke = Color3.fromRGB(40,110,100),
            RootGradient = { Color3.fromRGB(4,8,10), Color3.fromRGB(10,18,20), Color3.fromRGB(3,6,8) },
            AnimeImageTransparency = 0.1, AnimeShadeColor = Color3.fromRGB(0,0,0), AnimeShadeTransparency = 0.65, AnimeShadeStops = {0.00,0.14,0.34},
            SidebarBase = Color3.fromRGB(8,14,16), SidebarStroke = Color3.fromRGB(24,70,65),
            SearchStroke = Color3.fromRGB(28,80,75), OpenStroke = Color3.fromRGB(40,140,130), OpenButtonBase = Color3.fromRGB(6,10,12),
            BackdropGlowA = Color3.fromRGB(20,90,85), BackdropGlowB = Color3.fromRGB(10,50,48), BackdropWatermarkTransparency = 0.97,
            GridColor = Color3.fromRGB(80,255,230), GridVTransparency = 0.95, GridHTransparency = 0.96,
            NavButtonIdle = Color3.fromRGB(8,14,16), NavButtonHover = Color3.fromRGB(16,30,32), ResizeGuideTransparency = 0.32,
            ControlStroke = Color3.fromRGB(30,80,75), FieldStroke = Color3.fromRGB(28,75,70), ButtonBase = Color3.fromRGB(12,22,24), ButtonStroke = Color3.fromRGB(30,80,75),
            DropdownStroke = Color3.fromRGB(28,75,70), PopupStroke = Color3.fromRGB(40,140,130),
            GothicShell = Color3.fromRGB(255,255,255), GothicShellStroke = Color3.fromRGB(40,140,130), GothicGlow = Color3.fromRGB(12,40,38),
            GothicBar = Color3.fromRGB(40,140,130), GothicCorner = Color3.fromRGB(60,170,160), GothicWatermark = Color3.fromRGB(255,255,255), GothicWatermarkTransparency = 0.95,
            GothicRow = Color3.fromRGB(8,14,16), GothicStroke = Color3.fromRGB(30,90,85), GothicDesc = Color3.fromRGB(130,210,200),
            GothicBadgeText = Color3.fromRGB(220,255,250), GothicBadgeBackground = Color3.fromRGB(12,22,24), GothicBadgeStroke = Color3.fromRGB(40,110,100),
            SliderValueBackground = Color3.fromRGB(8,12,14), SliderValueText = Color3.fromRGB(200,255,250), SliderValueStroke = Color3.fromRGB(30,90,85),
            SliderRail = Color3.fromRGB(12,22,24), SliderRailStroke = Color3.fromRGB(30,80,75), SliderTrack = Color3.fromRGB(24,70,65),
            SliderTrackGradient = { Color3.fromRGB(18,50,48), Color3.fromRGB(30,90,85), Color3.fromRGB(18,50,48) },
            SliderFill = Color3.fromRGB(50,255,220), SliderFillGradient = { Color3.fromRGB(120,255,240), Color3.fromRGB(20,200,180) },
            SliderHalo = Color3.fromRGB(50,255,220), SliderThumb = Color3.fromRGB(240,255,252), SliderThumbStroke = Color3.fromRGB(40,160,150),
        },
    },
    Rose = {
        Name = "Rose",
        Colors = {
            Window = Color3.fromRGB(16,8,12), Panel = Color3.fromRGB(24,12,18),
            Row = Color3.fromRGB(34,18,26), Field = Color3.fromRGB(14,8,12),
            Hover = Color3.fromRGB(50,26,36), Border = Color3.fromRGB(95,45,65),
            Text = Color3.fromRGB(255,235,242), Muted = Color3.fromRGB(195,140,160),
            Faint = Color3.fromRGB(130,90,105), White = Color3.fromRGB(255,255,255),
        },
        Glass = { Root = 0.07, Sidebar = 0.22, Row = 0.30, Field = 0.34, Button = 0.24, NavIdle = 0.38, NavHover = 0.18, NavActive = 0.10, Popup = 0.12 },
        Visuals = {
            RootBase = Color3.fromRGB(12,6,10), RootStroke = Color3.fromRGB(105,50,70),
            RootGradient = { Color3.fromRGB(12,6,10), Color3.fromRGB(22,12,18), Color3.fromRGB(10,5,8) },
            AnimeImageTransparency = 0.08, AnimeShadeColor = Color3.fromRGB(0,0,0), AnimeShadeTransparency = 0.62, AnimeShadeStops = {0.00,0.12,0.32},
            SidebarBase = Color3.fromRGB(18,10,14), SidebarStroke = Color3.fromRGB(70,32,48),
            SearchStroke = Color3.fromRGB(80,36,55), OpenStroke = Color3.fromRGB(130,55,80), OpenButtonBase = Color3.fromRGB(16,8,12),
            BackdropGlowA = Color3.fromRGB(90,30,55), BackdropGlowB = Color3.fromRGB(45,15,28), BackdropWatermarkTransparency = 0.97,
            GridColor = Color3.fromRGB(255,160,190), GridVTransparency = 0.955, GridHTransparency = 0.965,
            NavButtonIdle = Color3.fromRGB(18,10,14), NavButtonHover = Color3.fromRGB(30,16,22), ResizeGuideTransparency = 0.35,
            ControlStroke = Color3.fromRGB(80,36,55), FieldStroke = Color3.fromRGB(75,34,50), ButtonBase = Color3.fromRGB(26,14,20), ButtonStroke = Color3.fromRGB(80,36,55),
            DropdownStroke = Color3.fromRGB(75,34,50), PopupStroke = Color3.fromRGB(130,55,80),
            GothicShell = Color3.fromRGB(255,255,255), GothicShellStroke = Color3.fromRGB(130,55,80), GothicGlow = Color3.fromRGB(40,14,26),
            GothicBar = Color3.fromRGB(130,55,80), GothicCorner = Color3.fromRGB(160,70,100), GothicWatermark = Color3.fromRGB(255,255,255), GothicWatermarkTransparency = 0.95,
            GothicRow = Color3.fromRGB(18,10,14), GothicStroke = Color3.fromRGB(95,45,65), GothicDesc = Color3.fromRGB(210,160,180),
            GothicBadgeText = Color3.fromRGB(255,240,245), GothicBadgeBackground = Color3.fromRGB(26,14,20), GothicBadgeStroke = Color3.fromRGB(105,50,70),
            SliderValueBackground = Color3.fromRGB(14,8,12), SliderValueText = Color3.fromRGB(255,235,242), SliderValueStroke = Color3.fromRGB(95,45,65),
            SliderRail = Color3.fromRGB(26,14,20), SliderRailStroke = Color3.fromRGB(80,36,55), SliderTrack = Color3.fromRGB(70,32,48),
            SliderTrackGradient = { Color3.fromRGB(50,26,36), Color3.fromRGB(95,45,65), Color3.fromRGB(50,26,36) },
            SliderFill = Color3.fromRGB(255,90,140), SliderFillGradient = { Color3.fromRGB(255,140,180), Color3.fromRGB(200,50,100) },
            SliderHalo = Color3.fromRGB(255,90,140), SliderThumb = Color3.fromRGB(255,245,250), SliderThumbStroke = Color3.fromRGB(170,60,100),
        },
    },
    Nord = {
        Name = "Nord",
        Colors = {
            Window = Color3.fromRGB(36,41,51), Panel = Color3.fromRGB(46,52,64),
            Row = Color3.fromRGB(59,66,82), Field = Color3.fromRGB(40,45,56),
            Hover = Color3.fromRGB(67,76,94), Border = Color3.fromRGB(76,86,106),
            Text = Color3.fromRGB(236,239,244), Muted = Color3.fromRGB(136,146,176),
            Faint = Color3.fromRGB(94,105,130), White = Color3.fromRGB(255,255,255),
        },
        Glass = { Root = 0.05, Sidebar = 0.16, Row = 0.22, Field = 0.26, Button = 0.18, NavIdle = 0.28, NavHover = 0.14, NavActive = 0.06, Popup = 0.10 },
        Visuals = {
            RootBase = Color3.fromRGB(30,34,42), RootStroke = Color3.fromRGB(76,86,106),
            RootGradient = { Color3.fromRGB(30,34,42), Color3.fromRGB(46,52,64), Color3.fromRGB(28,32,40) },
            AnimeImageTransparency = 0.08, AnimeShadeColor = Color3.fromRGB(0,0,0), AnimeShadeTransparency = 0.55, AnimeShadeStops = {0.00,0.10,0.28},
            SidebarBase = Color3.fromRGB(40,45,56), SidebarStroke = Color3.fromRGB(67,76,94),
            SearchStroke = Color3.fromRGB(76,86,106), OpenStroke = Color3.fromRGB(94,105,130), OpenButtonBase = Color3.fromRGB(36,41,51),
            BackdropGlowA = Color3.fromRGB(94,129,172), BackdropGlowB = Color3.fromRGB(67,76,94), BackdropWatermarkTransparency = 0.96,
            GridColor = Color3.fromRGB(216,222,233), GridVTransparency = 0.955, GridHTransparency = 0.965,
            NavButtonIdle = Color3.fromRGB(40,45,56), NavButtonHover = Color3.fromRGB(59,66,82), ResizeGuideTransparency = 0.4,
            ControlStroke = Color3.fromRGB(76,86,106), FieldStroke = Color3.fromRGB(67,76,94), ButtonBase = Color3.fromRGB(46,52,64), ButtonStroke = Color3.fromRGB(76,86,106),
            DropdownStroke = Color3.fromRGB(67,76,94), PopupStroke = Color3.fromRGB(94,105,130),
            GothicShell = Color3.fromRGB(255,255,255), GothicShellStroke = Color3.fromRGB(94,105,130), GothicGlow = Color3.fromRGB(59,66,82),
            GothicBar = Color3.fromRGB(94,129,172), GothicCorner = Color3.fromRGB(129,161,193), GothicWatermark = Color3.fromRGB(255,255,255), GothicWatermarkTransparency = 0.94,
            GothicRow = Color3.fromRGB(40,45,56), GothicStroke = Color3.fromRGB(76,86,106), GothicDesc = Color3.fromRGB(180,190,210),
            GothicBadgeText = Color3.fromRGB(236,239,244), GothicBadgeBackground = Color3.fromRGB(46,52,64), GothicBadgeStroke = Color3.fromRGB(76,86,106),
            SliderValueBackground = Color3.fromRGB(40,45,56), SliderValueText = Color3.fromRGB(236,239,244), SliderValueStroke = Color3.fromRGB(76,86,106),
            SliderRail = Color3.fromRGB(46,52,64), SliderRailStroke = Color3.fromRGB(67,76,94), SliderTrack = Color3.fromRGB(59,66,82),
            SliderTrackGradient = { Color3.fromRGB(50,58,72), Color3.fromRGB(76,86,106), Color3.fromRGB(50,58,72) },
            SliderFill = Color3.fromRGB(136,192,208), SliderFillGradient = { Color3.fromRGB(180,220,230), Color3.fromRGB(94,160,180) },
            SliderHalo = Color3.fromRGB(136,192,208), SliderThumb = Color3.fromRGB(236,239,244), SliderThumbStroke = Color3.fromRGB(100,140,160),
        },
    },
    Carbon = {
        Name = "Carbon",
        Colors = {
            Window = Color3.fromRGB(14,14,14), Panel = Color3.fromRGB(20,20,20),
            Row = Color3.fromRGB(28,28,28), Field = Color3.fromRGB(16,16,16),
            Hover = Color3.fromRGB(40,40,40), Border = Color3.fromRGB(55,55,55),
            Text = Color3.fromRGB(245,245,245), Muted = Color3.fromRGB(150,150,150),
            Faint = Color3.fromRGB(95,95,95), White = Color3.fromRGB(255,255,255),
        },
        Glass = { Root = 0.04, Sidebar = 0.16, Row = 0.24, Field = 0.28, Button = 0.20, NavIdle = 0.32, NavHover = 0.16, NavActive = 0.08, Popup = 0.10 },
        Visuals = {
            RootBase = Color3.fromRGB(10,10,10), RootStroke = Color3.fromRGB(60,60,60),
            RootGradient = { Color3.fromRGB(8,8,8), Color3.fromRGB(18,18,18), Color3.fromRGB(6,6,6) },
            AnimeImageTransparency = 0.08, AnimeShadeColor = Color3.fromRGB(0,0,0), AnimeShadeTransparency = 0.6, AnimeShadeStops = {0.00,0.10,0.30},
            SidebarBase = Color3.fromRGB(16,16,16), SidebarStroke = Color3.fromRGB(40,40,40),
            SearchStroke = Color3.fromRGB(45,45,45), OpenStroke = Color3.fromRGB(70,70,70), OpenButtonBase = Color3.fromRGB(14,14,14),
            BackdropGlowA = Color3.fromRGB(40,40,40), BackdropGlowB = Color3.fromRGB(28,28,28), BackdropWatermarkTransparency = 0.97,
            GridColor = Color3.fromRGB(255,255,255), GridVTransparency = 0.96, GridHTransparency = 0.97,
            NavButtonIdle = Color3.fromRGB(16,16,16), NavButtonHover = Color3.fromRGB(28,28,28), ResizeGuideTransparency = 0.35,
            ControlStroke = Color3.fromRGB(50,50,50), FieldStroke = Color3.fromRGB(48,48,48), ButtonBase = Color3.fromRGB(22,22,22), ButtonStroke = Color3.fromRGB(50,50,50),
            DropdownStroke = Color3.fromRGB(48,48,48), PopupStroke = Color3.fromRGB(70,70,70),
            GothicShell = Color3.fromRGB(255,255,255), GothicShellStroke = Color3.fromRGB(70,70,70), GothicGlow = Color3.fromRGB(30,30,30),
            GothicBar = Color3.fromRGB(80,80,80), GothicCorner = Color3.fromRGB(100,100,100), GothicWatermark = Color3.fromRGB(255,255,255), GothicWatermarkTransparency = 0.95,
            GothicRow = Color3.fromRGB(16,16,16), GothicStroke = Color3.fromRGB(55,55,55), GothicDesc = Color3.fromRGB(170,170,170),
            GothicBadgeText = Color3.fromRGB(250,250,250), GothicBadgeBackground = Color3.fromRGB(22,22,22), GothicBadgeStroke = Color3.fromRGB(60,60,60),
            SliderValueBackground = Color3.fromRGB(16,16,16), SliderValueText = Color3.fromRGB(245,245,245), SliderValueStroke = Color3.fromRGB(55,55,55),
            SliderRail = Color3.fromRGB(22,22,22), SliderRailStroke = Color3.fromRGB(50,50,50), SliderTrack = Color3.fromRGB(45,45,45),
            SliderTrackGradient = { Color3.fromRGB(36,36,36), Color3.fromRGB(55,55,55), Color3.fromRGB(36,36,36) },
            SliderFill = Color3.fromRGB(230,230,230), SliderFillGradient = { Color3.fromRGB(255,255,255), Color3.fromRGB(180,180,180) },
            SliderHalo = Color3.fromRGB(230,230,230), SliderThumb = Color3.fromRGB(250,250,250), SliderThumbStroke = Color3.fromRGB(90,90,90),
        },
    },
}

local CURRENT_THEME_NAME = canonicalThemeName(XeroEnv.XERO_THEME or "Xero")
local CURRENT_THEME = THEMES[CURRENT_THEME_NAME] or THEMES.Xero
local Nox = {
    Version = "3.2.0-hybrid",
    Brand = "XeroUI",
    SupportsGameLabels = true,
    Creator = "Kev + hybrid",
    UIScale = 1,

    Launcher = {
        Enabled = true,
        AutoLoad = nil,
        AutoLoadOnce = true,
        AutoExecute = nil,
        CloseAfterExecute = true,
        CloseBeforeExecute = true,
        Scripts = {},
    },
}
local C, Glass = {}, {}

local LauncherEnv = (getgenv and getgenv()) or _G
LauncherEnv.__XERO_LAUNCHER_STATE = LauncherEnv.__XERO_LAUNCHER_STATE or {
    AutoLoaded = false,
    AutoLoadRunning = false,
    ExecutionId = 0,
    Scripts = {},
    Config = {},
}
local LauncherState = LauncherEnv.__XERO_LAUNCHER_STATE

local function launcherConfigCopy()
    local out = {}
    for key,value in pairs(LauncherState.Config or {}) do
        out[key] = value
    end
    return out
end

local function launcherNormalizeId(value)
    local id = tostring(value or "")
    id = id:gsub("^%s+",""):gsub("%s+$","")
    return id
end

local function launcherIsUrl(value)
    return type(value) == "string" and value:match("^https?://") ~= nil
end

local function launcherLoadSource(source, chunkName)
    local loader = loadstring or load
    if type(loader) ~= "function" then
        return false, "El entorno no expone loadstring/load."
    end

    if type(source) ~= "string" or source == "" then
        return false, "El source está vacío."
    end

    local okCompile, chunk = pcall(loader, source, chunkName or "XeroHubLauncher")
    if not okCompile or type(chunk) ~= "function" then
        return false, tostring(chunk)
    end

    local okRun, result = pcall(chunk)
    if not okRun then
        return false, tostring(result)
    end

    return true, result
end

local function launcherResolveSource(entry)
    if type(entry) == "function" then
        return entry, "callback"
    end

    if type(entry) ~= "table" then
        if launcherIsUrl(entry) then
            local okHttp, body = pcall(function()
                return game:HttpGet(entry)
            end)
            if not okHttp or type(body) ~= "string" or body == "" then
                return nil, "No se pudo obtener el recurso remoto."
            end
            return body, "source"
        end
        return entry, "source"
    end

    if type(entry.Execute) == "function" then return entry.Execute, "callback" end
    if type(entry.Callback) == "function" then return entry.Callback, "callback" end

    local source = entry.Source
    if source == nil then source = entry.Code end
    if source == nil then source = entry.URL end
    if source == nil then source = entry.Url end

    if type(source) == "function" then return source, "callback" end

    if launcherIsUrl(source) then
        local okHttp, body = pcall(function()
            return game:HttpGet(source)
        end)
        if not okHttp or type(body) ~= "string" or body == "" then
            return nil, "No se pudo obtener el recurso remoto."
        end
        return body, "source"
    end

    return source, "source"
end

local function launcherInvoke(window, entry, id)
    local source, sourceType = launcherResolveSource(entry)
    if source == nil then
        return false, "No existe Source/Code/URL/Execute para '" .. tostring(id) .. "'."
    end

    LauncherState.ExecutionId = (tonumber(LauncherState.ExecutionId) or 0) + 1

    if sourceType == "callback" then
        local ok, result = pcall(source, window, id)
        if not ok then return false, tostring(result) end
        return true, result
    end

    return launcherLoadSource(source, "XeroHubLauncher_" .. tostring(id))
end

local function overwriteTable(target, source)
    for key in pairs(target) do target[key] = nil end
    for key, value in pairs(source or {}) do target[key] = value end
end

local function applyThemeDefinition(themeName)
    local resolved = canonicalThemeName(themeName)
    CURRENT_THEME_NAME = resolved
    CURRENT_THEME = THEMES[resolved] or THEMES.Xero
    overwriteTable(C, CURRENT_THEME.Colors)
    overwriteTable(Glass, CURRENT_THEME.Glass)
    XeroEnv.XERO_THEME = resolved
    return CURRENT_THEME
end

local function getThemeDefinition(themeName)
    return THEMES[canonicalThemeName(themeName)] or THEMES.Xero
end

applyThemeDefinition(CURRENT_THEME_NAME)

local function backgroundSource(themeName)
    return THEME_BACKGROUNDS[canonicalThemeName(themeName)] or THEME_BACKGROUNDS.Xero
end

local function isPngPayload(data)
    return type(data) == "string"
        and #data > 1024
        and data:sub(1, 8) == "\137PNG\r\n\26\n"
end

local function ensureFolderTree(path)
    if type(makefolder) ~= "function" then return end
    local current = ""
    for part in tostring(path):gmatch("[^/]+") do
        current = current == "" and part or (current .. "/" .. part)
        local exists = type(isfolder) == "function" and isfolder(current)
        if not exists then pcall(makefolder, current) end
    end
end

local function customAssetFunction()
    local fn = getcustomasset or getsynasset
    return type(fn) == "function" and fn or nil
end

local function cachedBackgroundAsset(themeName)
    local assetFn = customAssetFunction()
    local source = backgroundSource(themeName)
    if not assetFn or type(isfile) ~= "function" or not isfile(source.CACHE) then
        return nil
    end

    if type(readfile) == "function" then
        local okRead, data = pcall(readfile, source.CACHE)
        if not okRead or not isPngPayload(data) then return nil end
    end

    local okAsset, asset = pcall(assetFn, source.CACHE)
    if okAsset and type(asset) == "string" and asset ~= "" then return asset end
    return nil
end

local function downloadBackgroundAsset(themeName)
    local assetFn = customAssetFunction()
    local source = backgroundSource(themeName)
    if not source or type(source.URL) ~= "string" or source.URL == "" then return nil end
    if not assetFn or type(writefile) ~= "function" then return nil end

    local body
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if type(req) == "function" then
        local okRequest, response = pcall(req, {
            Url = source.URL,
            Method = "GET",
            Headers = { ["User-Agent"] = "XeroHub/3.0" },
        })
        if okRequest and response then
            local status = tonumber(response.StatusCode or response.Status)
            if status and status >= 200 and status < 300 and isPngPayload(response.Body) then
                body = response.Body
            end
        end
    end

    if not body then
        local okHttp, data = pcall(function()
            return game:HttpGet(source.URL)
        end)
        if okHttp and isPngPayload(data) then body = data end
    end

    if not body then return nil end
    ensureFolderTree(XERO_BACKGROUND_FOLDER)
    local okWrite = pcall(writefile, source.CACHE, body)
    if not okWrite then return nil end

    local okAsset, asset = pcall(assetFn, source.CACHE)
    if okAsset and type(asset) == "string" and asset ~= "" then return asset end
    return nil
end

local function colorEquals(left, right)
    return typeof(left) == "Color3" and typeof(right) == "Color3"
        and math.abs(left.R - right.R) < 0.0001
        and math.abs(left.G - right.G) < 0.0001
        and math.abs(left.B - right.B) < 0.0001
end

local function themeRoleFromColor(color)
    if typeof(color) ~= "Color3" then return nil end
    for role, value in pairs(C) do
        if colorEquals(color, value) then return role end
    end
    return nil
end

local function setThemeRole(object, suffix, role)
    if object and role and type(object.SetAttribute) == "function" then
        object:SetAttribute("XeroTheme" .. suffix, role)
    end
end

local function detectAndTagThemeRoles(object)
    if not object or type(object.IsA) ~= "function" then return end
    if object:IsA("GuiObject") then
        setThemeRole(object, "Background", themeRoleFromColor(object.BackgroundColor3))
    end
    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
        setThemeRole(object, "Text", themeRoleFromColor(object.TextColor3))
    end
    if object:IsA("TextBox") then
        setThemeRole(object, "Placeholder", themeRoleFromColor(object.PlaceholderColor3))
    end
    if object:IsA("UIStroke") then
        setThemeRole(object, "Stroke", themeRoleFromColor(object.Color))
    end
end

local function applyThemeRolesToObject(object)
    if not object or type(object.GetAttribute) ~= "function" then return end
    local bgRole = object:GetAttribute("XeroThemeBackground")
    if bgRole and object:IsA("GuiObject") and C[bgRole] then
        object.BackgroundColor3 = C[bgRole]
    end
    local textRole = object:GetAttribute("XeroThemeText")
    if textRole and (object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox")) and C[textRole] then
        object.TextColor3 = C[textRole]
    end
    local placeholderRole = object:GetAttribute("XeroThemePlaceholder")
    if placeholderRole and object:IsA("TextBox") and C[placeholderRole] then
        object.PlaceholderColor3 = C[placeholderRole]
    end
    local strokeRole = object:GetAttribute("XeroThemeStroke")
    if strokeRole and object:IsA("UIStroke") and C[strokeRole] then
        object.Color = C[strokeRole]
    end
end

local function applyThemeRolesRecursive(root)
    if not root then return end
    applyThemeRolesToObject(root)
    for _, descendant in ipairs(root:GetDescendants()) do
        applyThemeRolesToObject(descendant)
    end
end

local FONT = Enum.Font.Gotham
local MEDIUM = Enum.Font.GothamMedium
local BOLD = Enum.Font.GothamBold
local function new(class, props, parent)
    local object = Instance.new(class)
    if object:IsA("GuiObject") then object.BorderSizePixel = 0 end
    if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
        object.Font = FONT
        object.TextSize = 13
        object.TextColor3 = C.Text
        object.Text = ""
    end
    if object:IsA("GuiButton") then object.AutoButtonColor = false end
    for key, value in pairs(props or {}) do object[key] = value end
    detectAndTagThemeRoles(object)
    object.Parent = parent
    return object
end
local function round(object, radius)
    return new("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, object)
end
local function stroke(object, color, thickness)
    return new("UIStroke", {Color = color or C.Border, Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, object)
end
local function padding(object, x, y)
    return new("UIPadding", {PaddingLeft = UDim.new(0,x), PaddingRight = UDim.new(0,x),
        PaddingTop = UDim.new(0,y or x), PaddingBottom = UDim.new(0,y or x)}, object)
end
local function vertical(object, gap)
    return new("UIListLayout", {Padding = UDim.new(0,gap or 0),
        SortOrder = Enum.SortOrder.LayoutOrder}, object)
end
local function label(parent, text, size, color, props)
    local p = {Text = text or "", TextSize = size or 13, TextColor3 = color or C.Text,
        BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1,0,0,20)}
    for k,v in pairs(props or {}) do p[k] = v end
    return new("TextLabel", p, parent)
end
local function button(parent, text, props)
    local p = {
        Text = text or "",
        BackgroundColor3 = C.Row,
        BackgroundTransparency = Glass.Button,
        Size = UDim2.fromOffset(36,36)
    }
    for k,v in pairs(props or {}) do p[k] = v end
    return new("TextButton", p, parent)
end
local function plain(text)
    return tostring(text or ""):gsub("<[^>]+>", "")
end
local function normalized(text)
    local s = string.lower(plain(text))
    for a,b in pairs({["á"]="a",["é"]="e",["í"]="i",["ó"]="o",["ú"]="u",["ñ"]="n",
        ["Á"]="a",["É"]="e",["Í"]="i",["Ó"]="o",["Ú"]="u",["Ñ"]="n"}) do s = s:gsub(a,b) end
    return s
end
local function invoke(callback, ...)
    if type(callback) ~= "function" then return end
    local ok, err = pcall(callback, ...)
    if not ok then end
end
local function softTween(obj, props, dur, style, dir)
    local t = TweenService:Create(obj, TweenInfo.new(dur or 0.2, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
    t:Play()
    return t
end
local function disconnect(bucket)
    for _,connection in ipairs(bucket) do connection:Disconnect() end
    table.clear(bucket)
end
local function connect(window, signal, callback, bucket)
    local connection = signal:Connect(callback)
    table.insert(bucket or window._connections, connection)
    return connection
end
local function hover(window, target, baseColor, baseTransparency, hoverColor, hoverTransparency)
    local idleColor = baseColor or C.Row
    local idleTransparency = baseTransparency
    if idleTransparency == nil then
        idleTransparency = target.BackgroundTransparency
        if idleTransparency == nil then idleTransparency = Glass.Button end
    end

    local overColor = hoverColor or C.Hover
    local overTransparency = hoverTransparency
    if overTransparency == nil then
        overTransparency = math.max(0, idleTransparency - 0.10)
    end

    local idleRole = themeRoleFromColor(idleColor)
    local hoverRole = themeRoleFromColor(overColor)

    connect(window, target.MouseEnter, function()
        target.BackgroundColor3 = hoverRole and C[hoverRole] or overColor
        target.BackgroundTransparency = overTransparency
    end)
    connect(window, target.MouseLeave, function()
        target.BackgroundColor3 = idleRole and C[idleRole] or idleColor
        target.BackgroundTransparency = idleTransparency
    end)
end
local function line(parent, x, y, w, h, rotation, color)
    return new("Frame", {Position=UDim2.fromOffset(x,y), Size=UDim2.fromOffset(w,h),
        Rotation=rotation or 0, BackgroundColor3=color or C.Muted}, parent)
end
local function mark(parent, size, color)
    local holder = new("Frame", {Name="XeroMark", BackgroundTransparency=1, Size=UDim2.fromOffset(size,size)}, parent)
    local tone = color or C.Text
    local length = math.max(14, math.floor(size * 0.72))
    local thickness = math.max(2, math.floor(size * 0.105))

    local function xBar(rotation)
        local bar = new("Frame", {
            AnchorPoint=Vector2.new(.5,.5),
            Position=UDim2.fromScale(.5,.5),
            Size=UDim2.fromOffset(length,thickness),
            Rotation=rotation,
            BackgroundColor3=tone,
        }, holder)
        round(bar, thickness)
        return bar
    end

    xBar(45)
    xBar(-45)

    return holder
end
local function icon(parent, kind, numberOverride)
    local h = new("Frame", {BackgroundTransparency=1, Size=UDim2.fromOffset(20,20)}, parent)
    if kind == "close" then line(h,3,9,14,1,45); line(h,3,9,14,1,-45)
    elseif kind == "menu" then for _,y in ipairs({5,10,15}) do line(h,3,y,14,1) end
    elseif kind == "search" then
        local circle = new("Frame", {Position=UDim2.fromOffset(3,2),Size=UDim2.fromOffset(10,10),BackgroundTransparency=1},h)
        round(circle,10); stroke(circle,C.Muted,1.4); line(h,12,13,6,1,45)
    elseif kind == "minus" then line(h,4,10,12,1)
    else
        local symbols = {Inicio="01",Aimbot="02",["Kill All"]="03",Visuales="04",Movimiento="05",
            AutoFarm="06",["Gráficos"]="07",Sonidos="08",Animaciones="09",Apariencia="10",["Generar Armas"]="11",["Configuración"]="12",["Créditos"]="13"}
        label(h, numberOverride or symbols[kind] or "·", 10, C.Muted, {Font=Enum.Font.Code,TextXAlignment=Enum.TextXAlignment.Center})
    end
    return h
end
local function scroll(parent, props)
    local p = {BackgroundTransparency=1, Size=UDim2.fromScale(1,1), CanvasSize=UDim2.new(),
        AutomaticCanvasSize=Enum.AutomaticSize.Y, ScrollingDirection=Enum.ScrollingDirection.Y,
        ScrollBarThickness=3, ScrollBarImageColor3=C.Faint, ElasticBehavior=Enum.ElasticBehavior.Never}
    for k,v in pairs(props or {}) do p[k]=v end
    return new("ScrollingFrame",p,parent)
end

local Tab = {}; Tab.__index = Tab
local Control = {}; Control.__index = Control

local function textHeight(text,size,font,width)
    if text=="" then return 0 end
    return math.max(size+3,math.ceil(TextService:GetTextSize(text,size,font,Vector2.new(math.max(30,width),100000)).Y)+3)
end
function Control:_resize(width)
    if self.Destroyed then return end
    local section=self.__type=="Section"
    local px=section and 2 or 10
    local py=section and 7 or 8
    local headWidth=math.max(40,width-px*2)
    local reserve=self.Reserve or 0
    local copyWidth=math.max(30,headWidth-reserve)
    local titleHeight=textHeight(self.Title,self.TitleLabel.TextSize,self.TitleLabel.Font,copyWidth)
    local descHeight=textHeight(self.Desc,self.DescLabel.TextSize,self.DescLabel.Font,copyWidth)
    local copyHeight=titleHeight+(descHeight>0 and 4+descHeight or 0)
    local headHeight=math.max(copyHeight,self.HeadMinimum or 0)
    self.Head.Position=UDim2.fromOffset(px,py)
    self.Head.Size=UDim2.new(1,-px*2,0,headHeight)
    local copyOffsetX=self.CopyOffsetX or 0
    self.Copy.Position=UDim2.fromOffset(copyOffsetX,0)
    self.Copy.Size=UDim2.new(1,-reserve-copyOffsetX,0,copyHeight)
    self.TitleLabel.Size=UDim2.new(1,0,0,titleHeight)
    self.DescLabel.Position=UDim2.fromOffset(0,titleHeight+4)
    self.DescLabel.Size=UDim2.new(1,0,0,descHeight)
    if self.Thumbnail then
        local size=self.ThumbnailSize or 36
        local thumbY=math.max(0,math.floor((headHeight-size)/2))
        local thumbX=(self.ImageAlign=="left") and 0 or math.max(0,headWidth-size)
        self.Thumbnail.Position=UDim2.fromOffset(thumbX,thumbY)
        self.Thumbnail.Size=UDim2.fromOffset(size,size)
    end
    local y=py+headHeight
    if self.BodyField then
        local fieldHeight=28
        if self.ValueLabel then fieldHeight=math.max(28,textHeight(self.ValueLabel.Text,11,FONT,headWidth-36)+12) end
        self.BodyField.Position=UDim2.fromOffset(px,y+6)
        self.BodyField.Size=UDim2.new(1,-px*2,0,fieldHeight)
        y+=6+fieldHeight
    end
    if self.SliderArea then
        local sliderAreaHeight=self.SliderAreaHeight or 14
        local sliderLimitsGap=self.SliderLimitsGap or 2
        self.SliderArea.Position=UDim2.fromOffset(px,y+3)
        self.SliderArea.Size=UDim2.new(1,-px*2,0,sliderAreaHeight)
        self.Limits.Position=UDim2.fromOffset(px,y+3+sliderAreaHeight+sliderLimitsGap)
        self.Limits.Size=UDim2.new(1,-px*2,0,10)
        y+=sliderAreaHeight+sliderLimitsGap+14
    end
    if self.Rule then self.Rule.Position=UDim2.fromOffset(px,y+5); self.Rule.Size=UDim2.new(1,-px*2,0,1); y+=7 end
    local height=y+(section and 3 or py)
    self.ElementFrame.Size=UDim2.new(1,0,0,height)
    self.Slot.Size=UDim2.new(1,-6,0,height)
end
function Tab:_layout()
    if self.Window.Destroyed then return end
    local width=math.max(80,(self.Window.ContentWidth or 500)-8)
    local height=4
    for _,c in ipairs(self.Elements) do
        if not c.Destroyed then
            c:_resize(width)
            if c.Slot.Visible then height+=c.Slot.Size.Y.Offset+5 end
        end
    end
    local bottomPad=22
    local canvasHeight=math.max(0,height-5+bottomPad)
    self.Content.CanvasSize=UDim2.fromOffset(0,canvasHeight)
    local viewportHeight=self.Content.AbsoluteSize.Y
    self.Content.CanvasPosition=Vector2.new(0,math.clamp(self.Content.CanvasPosition.Y,0,math.max(0,canvasHeight-viewportHeight)))
end

function Control:ApplyTheme()
    if self.Destroyed then return self end
    local light = (self.Window and self.Window.ThemeName == "Blanco") or CURRENT_THEME_NAME == "Blanco"
    if self.ElementFrame and self.ElementFrame.Parent then
        self.ElementFrame.BackgroundColor3 = light and (self.LightColor or C.Row) or (self.DarkColor or C.Row)
    end
    if self.RowStroke and self.RowStroke.Parent then
        self.RowStroke.Color = light and (self.LightStrokeColor or C.Border) or (self.DarkStrokeColor or THEMES.Xero.Visuals.ControlStroke)
    end
    if self.TitleLabel and self.TitleLabel.Parent then
        if self.Locked then
            self.TitleLabel.TextColor3 = C.Faint
        else
            self.TitleLabel.TextColor3 = light and (self.LightTitleColor or C.Text) or (self.DarkTitleColor or C.Text)
        end
    end
    if self.DescLabel and self.DescLabel.Parent then
        self.DescLabel.TextColor3 = light and (self.LightDescColor or C.Muted) or (self.DarkDescColor or C.Muted)
    end
    if self.PictureStroke and self.PictureStroke.Parent then
        self.PictureStroke.Color = light and (self.LightImageStrokeColor or C.Border) or (self.DarkImageStrokeColor or C.Text)
    end
    if self._applyThemeExtras then self:_applyThemeExtras(light) end
    return self
end

function Control:SetTitle(value)
    self.Title = plain(value); self.TitleLabel.Text = self.Title
    self.Tab:_queueFilter(); return self
end
function Control:SetDesc(value)
    self.Desc = plain(value); self.DescLabel.Text = self.Desc
    self.DescLabel.Visible = self.Desc ~= ""; self.Tab:_queueFilter(); return self
end
function Control:SetVisible(value) self.ElementFrame.Visible = value == true; return self end
function Control:Show() return self:SetVisible(true) end
function Control:Hide() return self:SetVisible(false) end
function Control:Lock()
    self.Locked = true; self.TitleLabel.TextColor3 = C.Faint
    if self.Interactive then self.Interactive.Active = false end
    return self
end
function Control:Unlock()
    self.Locked = false; self.TitleLabel.TextColor3 = C.Text
    if self.Interactive then self.Interactive.Active = true end
    return self
end
function Control:Destroy()
    if self.Destroyed then return end
    self.Destroyed = true
    if self.Window._popupOwner == self then self.Window:_closePopup() end
    if self.Window._drag and self.Window._drag.Owner == self then self.Window:_endDrag() end
    self.Slot:Destroy(); self.Tab:_queueFilter()
end
function Control:SetValue(value, silent) return self:Set(value,silent) end
function Control:Get() return self.Value end

function Tab:_queueFilter()
    if self._filterQueued or self.Window.Destroyed then return end
    self._filterQueued = true
    task.defer(function()
        self._filterQueued = false
        if not self.Window.Destroyed then self:_filter() end
    end)
end
function Tab:_filter()
    local query = normalized(self.Query or "")
    local shown, total = 0,0
    local matchingGroups = {}
    local ordered=table.clone(self.Elements)
    table.sort(ordered,function(a,b) return a.Slot.LayoutOrder<b.Slot.LayoutOrder end)
    local groupTitle=""
    for _,c in ipairs(ordered) do
        if not c.Destroyed then
            if c.__type=="Section" then groupTitle=c.Title else c.GroupTitle=groupTitle end
        end
    end
    for _,c in ipairs(self.Elements) do
        if not c.Destroyed and c.__type ~= "Section" then
            local allowed = c.ElementFrame.Visible
            local matched = query == "" or string.find(normalized(c.Title .. " " .. c.Desc .. " " .. (c.GroupTitle or "")),query,1,true) ~= nil
            c.Slot.Visible = allowed and matched
            if allowed then total += 1 end
            if allowed and matched then shown += 1; matchingGroups[c.GroupTitle or ""] = true end
        end
    end
    for _,c in ipairs(self.Elements) do
        if not c.Destroyed and c.__type == "Section" then
            c.Slot.Visible = c.ElementFrame.Visible and (query == "" or matchingGroups[c.Title] == true)
        end
    end
    self.Empty.Visible = shown == 0
    if self.Window.CurrentTab == self then
        self.Window.CountLabel.Text = tostring(shown) .. (query ~= "" and " / " .. total or "") .. " opciones"
    end
    if self._lastQuery~=query then self.Content.CanvasPosition=Vector2.zero; self._lastQuery=query end
    self:_layout()
end
function Tab:_control(kind, options)
    local o = options or {}
    self._order += 1
    local lightTheme = self.Window.ThemeName == "Blanco"
    local darkColor = o.Color or THEMES.Xero.Colors.Row
    local lightColor = o.LightColor or THEMES.Blanco.Colors.Row
    local darkStrokeColor = o.StrokeColor or THEMES.Xero.Visuals.ControlStroke
    local lightStrokeColor = o.LightStrokeColor or THEMES.Blanco.Visuals.ControlStroke
    local slot = new("Frame", {Name="Slot",BackgroundTransparency=1,
        Size=UDim2.new(1,-4,0,0),LayoutOrder=self._order},self.Content)
    local row = new("Frame", {Name=kind,BackgroundColor3=lightTheme and lightColor or darkColor,BackgroundTransparency=Glass.Row,
        Size=UDim2.new(1,0,0,0),LayoutOrder=self._order,ClipsDescendants=true},slot)
    round(row,11); local rowStroke=stroke(row,lightTheme and lightStrokeColor or darkStrokeColor); rowStroke.Transparency=.18
    local head = new("Frame", {Name="Heading",BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,0),LayoutOrder=1},row)
    local copy = new("Frame", {Name="Copy",BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,0)},head)
    local title = label(copy,plain(o.Title or kind),12,C.Text,{Font=MEDIUM,TextWrapped=true,
        TextYAlignment=Enum.TextYAlignment.Top,Size=UDim2.new(1,0,0,18),LayoutOrder=1})
    local desc = label(copy,plain(o.Desc),11,C.Muted,{TextWrapped=true,AutomaticSize=Enum.AutomaticSize.Y,
        Size=UDim2.new(1,0,0,0),LayoutOrder=2,Visible=o.Desc ~= nil and o.Desc ~= ""})
    local control = setmetatable({Title=plain(o.Title or kind),Desc=plain(o.Desc),__type=kind,
        Window=self.Window,Tab=self,ElementFrame=row,Slot=slot,Head=head,Copy=copy,RowStroke=rowStroke,
        TitleLabel=title,DescLabel=desc,Callback=o.Callback,GroupTitle=self._groupTitle,Locked=false,
        DarkColor=darkColor,LightColor=lightColor,DarkStrokeColor=darkStrokeColor,LightStrokeColor=lightStrokeColor,
        DarkTitleColor=o.TitleColor,LightTitleColor=o.LightTitleColor,DarkDescColor=o.DescColor,LightDescColor=o.LightDescColor},Control)
    desc.AutomaticSize=Enum.AutomaticSize.None; desc.TextYAlignment=Enum.TextYAlignment.Top
    table.insert(self.Elements,control)
    connect(self.Window,row:GetPropertyChangedSignal("Visible"),function() self:_queueFilter() end)
    connect(self.Window,row:GetPropertyChangedSignal("LayoutOrder"),function() slot.LayoutOrder=row.LayoutOrder; self:_queueFilter() end)
    if o.Locked then control:Lock() end
    self:_queueFilter()
    return control
end
function Tab:Section(options)
    local o = type(options)=="string" and {Title=options} or (options or {})
    self._groupTitle = plain(o.Title)
    local c = self:_control("Section",o)
    c.ElementFrame.BackgroundTransparency = 1
    c.ElementFrame.UIStroke:Destroy(); c.RowStroke=nil
    c.DarkTitleColor=THEMES.Xero.Colors.Muted; c.LightTitleColor=THEMES.Blanco.Colors.Muted
    c.TitleLabel.TextColor3=C.Muted; c.TitleLabel.TextSize=10; c.TitleLabel.Font=BOLD
    local rule = new("Frame",{Size=UDim2.new(1,0,0,1),BackgroundColor3=C.Border,LayoutOrder=3},c.ElementFrame)
    c.Rule = rule
    return c
end
function Tab:Paragraph(options)
    local c = self:_control("Paragraph",options)
    local o = options or {}
    if o.TitleColor then c.TitleLabel.TextColor3=o.TitleColor end
    if o.DescColor then c.DescLabel.TextColor3=o.DescColor end
    if type(o.Image)=="string" and (o.Image:match("^rbxassetid://") or o.Image:match("^rbxthumb://")) then
        local pictureSize=math.max(32, tonumber(o.ImageSize) or 32)
        local align=(o.ImageAlign=="left") and "left" or "right"
        c.ImageAlign=align
        c.ThumbnailSize=pictureSize
        c.CopyOffsetX=align=="left" and (pictureSize+12) or 0
        c.Reserve=(align=="left") and 0 or (pictureSize+14)
        c.HeadMinimum=math.max(34,pictureSize)
        local picture=new("ImageLabel",{Name="Thumbnail",Image=o.Image,BackgroundColor3=C.Field,
            Position=UDim2.new(1,-pictureSize,0,0),Size=UDim2.fromOffset(pictureSize,pictureSize),ScaleType=Enum.ScaleType.Crop},c.Head)
        round(picture,o.CircleImage and math.floor(pictureSize/2) or 10)
        local darkImageStroke=o.ImageStrokeColor or Color3.fromRGB(238,238,238)
        local lightImageStroke=o.LightImageStrokeColor or THEMES.Blanco.Colors.Border
        local pictureStroke=stroke(picture,(c.Window.ThemeName=="Blanco") and lightImageStroke or darkImageStroke,o.ImageStrokeThickness or 1)
        c.Thumbnail=picture
        c.PictureStroke=pictureStroke
        c.DarkImageStrokeColor=darkImageStroke
        c.LightImageStrokeColor=lightImageStroke
    end
    if o.Gothic then
        local decor=new("Frame",{Name="Decor",BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=0},c.ElementFrame)
        local gothicVisuals = c.Window.ThemeDef.Visuals
        local shell=new("Frame",{Name="Shell",BackgroundColor3=gothicVisuals.GothicShell,BackgroundTransparency=.985,
            Position=UDim2.fromOffset(1,1),Size=UDim2.new(1,-2,1,-2),ZIndex=0},decor)
        round(shell,10); local shellStroke=stroke(shell,gothicVisuals.GothicShellStroke,1)
        local glow=new("Frame",{AnchorPoint=Vector2.new(1,.5),Position=UDim2.fromScale(.985,.5),Size=UDim2.fromScale(.38,.92),
            BackgroundColor3=gothicVisuals.GothicGlow,BackgroundTransparency=.54,Rotation=-8,ZIndex=0},decor)
        round(glow,22)
        new("UIGradient",{Rotation=28,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.16),NumberSequenceKeypoint.new(1,1)})},glow)
        local bar=line(decor,18,14,1,200,0,gothicVisuals.GothicBar); bar.BackgroundTransparency=.58; bar.ZIndex=0
        local corner=line(decor,18,14,42,1,0,gothicVisuals.GothicCorner); corner.BackgroundTransparency=.48; corner.ZIndex=0
        local wm=label(decor,o.DecorText or "XERO",28,gothicVisuals.GothicWatermark,{AnchorPoint=Vector2.new(1,1),Position=UDim2.fromScale(.968,.9),
            Size=UDim2.fromScale(.46,.30),Font=BOLD,TextTransparency=gothicVisuals.GothicWatermarkTransparency,TextXAlignment=Enum.TextXAlignment.Right,TextYAlignment=Enum.TextYAlignment.Bottom,ZIndex=0})
        c.DarkColor=o.Color or THEMES.Xero.Visuals.GothicRow
        c.LightColor=o.LightColor or THEMES.Blanco.Visuals.GothicRow
        c.DarkStrokeColor=o.StrokeColor or THEMES.Xero.Visuals.GothicStroke
        c.LightStrokeColor=o.LightStrokeColor or THEMES.Blanco.Visuals.GothicStroke
        c.DarkDescColor=o.DescColor or THEMES.Xero.Visuals.GothicDesc
        c.LightDescColor=o.LightDescColor or THEMES.Blanco.Visuals.GothicDesc
        c.TitleLabel.Font=BOLD
        c.TitleLabel.TextSize=math.max(c.TitleLabel.TextSize,14)
        c.DescLabel.TextSize=math.max(c.DescLabel.TextSize,11)
        if c.Thumbnail then
            c.HeadMinimum=math.max(c.HeadMinimum or 0,(c.ThumbnailSize or 36)+8)
            c.Thumbnail.ZIndex=2
        end
        local badge, badgeStroke
        if o.BadgeText then
            badge=label(c.Head,string.upper(plain(o.BadgeText)),9,gothicVisuals.GothicBadgeText,{
                AnchorPoint=Vector2.new(1,0),Position=UDim2.new(1,-4,0,0),Size=UDim2.fromOffset(82,22),
                TextXAlignment=Enum.TextXAlignment.Center,Font=Enum.Font.Code,BackgroundColor3=gothicVisuals.GothicBadgeBackground,BackgroundTransparency=.05,ZIndex=3})
            round(badge,9); badgeStroke=stroke(badge,gothicVisuals.GothicBadgeStroke,1)
        end
        c._applyThemeExtras=function(self)
            local v=self.Window.ThemeDef.Visuals
            shell.BackgroundColor3=v.GothicShell
            shellStroke.Color=v.GothicShellStroke
            glow.BackgroundColor3=v.GothicGlow
            bar.BackgroundColor3=v.GothicBar
            corner.BackgroundColor3=v.GothicCorner
            wm.TextColor3=v.GothicWatermark
            wm.TextTransparency=v.GothicWatermarkTransparency
            if badge then
                badge.TextColor3=v.GothicBadgeText
                badge.BackgroundColor3=v.GothicBadgeBackground
                if badgeStroke then badgeStroke.Color=v.GothicBadgeStroke end
            end
        end
        c:ApplyTheme()
    end
    c:ApplyTheme()
    function c:Set(value) return self:SetDesc(value) end
    return c
end
function Tab:Button(options)
    local c = self:_control("Button",options)
    c.Reserve=34; c.HeadMinimum=28
    local hit = button(c.Head,"→",{Name="Action",BackgroundColor3=C.Panel,BackgroundTransparency=Glass.Button,TextSize=14,
        Position=UDim2.new(1,-26,0,0),Size=UDim2.fromOffset(26,26)})
    round(hit,8); stroke(hit,C.Border); hover(c.Window,hit,C.Field)
    local titleHit=button(c.Copy,"",{Name="Activate",BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=3})
    local function activate() if not c.Locked and not c.Destroyed then invoke(c.Callback) end end
    connect(c.Window,hit.Activated,activate); connect(c.Window,titleHit.Activated,activate)
    c.Interactive=hit
    return c
end
function Tab:Toggle(options)
    local o = options or {}; local c = self:_control("Toggle",o)
    c.Reserve=46; c.HeadMinimum=28
    local target=button(c.Head,"",{Name="ToggleHit",BackgroundTransparency=1,
        Position=UDim2.new(1,-38,0,0),Size=UDim2.fromOffset(38,26)})
    local hit=new("Frame",{Name="Switch",BackgroundColor3=C.Border,
        Position=UDim2.fromOffset(4,4),Size=UDim2.fromOffset(30,18)},target)
    round(hit,7)
    local knob=new("Frame",{Name="Thumb",BackgroundColor3=C.Muted,Position=UDim2.fromOffset(4,4),
        Size=UDim2.fromOffset(10,10)},hit); round(knob,4)
    local tick=label(knob,"",11,C.Window,{TextXAlignment=Enum.TextXAlignment.Center,Size=UDim2.fromScale(1,1)})
    c.Interactive=target
    function c:Set(value,silent)
        if self.Destroyed then return self end
        value=value == true
        local changed=self.Value ~= value; self.Value=value
        hit.BackgroundColor3=value and C.White or C.Border
        knob.BackgroundColor3=value and C.Window or C.Muted
        knob.Position=UDim2.fromOffset(value and 16 or 4,4)
        tick.Text=value and "·" or ""; tick.TextColor3=C.White
        if changed and not silent then invoke(self.Callback,value) end
        return self
    end
    c._applyThemeExtras=function(self) self:Set(self.Value,true) end
    c:Set(o.Value == true,true)
    connect(c.Window,target.Activated,function() if not c.Locked then c:Set(not c.Value) end end)
    return c
end
local function field(parent, placeholder)
    local box=new("TextBox",{Name="Field",Text="",PlaceholderText=placeholder or "",
        PlaceholderColor3=C.Faint,BackgroundColor3=C.Field,BackgroundTransparency=Glass.Field,ClearTextOnFocus=false,
        TextXAlignment=Enum.TextXAlignment.Left,TextSize=11,Size=UDim2.new(1,0,0,28),LayoutOrder=2},parent)
    round(box,8); stroke(box,C.Border); padding(box,9,0)
    return box
end
function Tab:Input(options)
    local o=options or {}; local c=self:_control("Input",o)
    local box=field(c.ElementFrame,o.Placeholder or "Escribe aquí…")
    c.Interactive=box; c.BodyField=box
    function c:Set(value,silent)
        value=tostring(value or ""); local changed=self.Value ~= value
        self.Value=value; box.Text=value
        if changed and not silent then invoke(self.Callback,value) end
        return self
    end
    c:Set(o.Value or o.Default or "",true)
    connect(c.Window,box.FocusLost,function()
        if c.Locked then box.Text=c.Value else c:Set(box.Text) end
    end)
    if o.Live then connect(c.Window,box:GetPropertyChangedSignal("Text"),function()
        if not c.Locked then c:Set(box.Text) end
    end) end
    return c
end
function Tab:Slider(options)
    local o=options or {}; local c=self:_control("Slider",o)
    local range=type(o.Value)=="table" and o.Value or {}
    local low=tonumber(range.Min or o.Min) or 0; local high=tonumber(range.Max or o.Max) or 100
    if high<low then low,high=high,low end
    local step=math.max(tonumber(o.Step) or 1,0.000001)
    local decimals=0
    while decimals<6 and math.abs(step*10^decimals-math.floor(step*10^decimals+.5))>.000001 do decimals+=1 end
    c.Min,c.Max,c.Step=low,high,step
    c.Reserve=70; c.HeadMinimum=28
    c.SliderAreaHeight=30; c.SliderLimitsGap=1

    local sliderVisuals=c.Window.ThemeDef.Visuals
    local box=field(c.Head,"")
    box.Name="Value"
    box.Size=UDim2.fromOffset(58,26)
    box.Position=UDim2.new(1,-58,0,0)
    box.TextXAlignment=Enum.TextXAlignment.Center
    box.BackgroundColor3=sliderVisuals.SliderValueBackground
    box.TextColor3=sliderVisuals.SliderValueText
    box.Font=MEDIUM
    box.TextSize=10
    if box:FindFirstChildOfClass("UICorner") then box:FindFirstChildOfClass("UICorner").CornerRadius=UDim.new(0,9) end
    local boxStroke=box:FindFirstChildOfClass("UIStroke")
    if boxStroke then boxStroke.Color=sliderVisuals.SliderValueStroke; boxStroke.Transparency=.12 end

    local area=button(c.ElementFrame,"",{Name="SliderArea",BackgroundTransparency=1,
        Size=UDim2.new(1,0,0,30),LayoutOrder=2})

    local rail=new("Frame",{Name="Rail",Position=UDim2.new(0,8,.5,-5),Size=UDim2.new(1,-16,0,10),
        BackgroundColor3=sliderVisuals.SliderRail},area)
    round(rail,7); local railStroke=stroke(rail,sliderVisuals.SliderRailStroke,1)

    local track=new("Frame",{Name="Track",Position=UDim2.new(0,6,.5,-3),Size=UDim2.new(1,-12,0,6),
        BackgroundColor3=sliderVisuals.SliderTrack},rail)
    round(track,4)
    local trackGradient=new("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,sliderVisuals.SliderTrackGradient[1]),
        ColorSequenceKeypoint.new(.5,sliderVisuals.SliderTrackGradient[2]),
        ColorSequenceKeypoint.new(1,sliderVisuals.SliderTrackGradient[3])
    })},track)

    local fill=new("Frame",{Name="Fill",Size=UDim2.fromScale(0,1),BackgroundColor3=sliderVisuals.SliderFill},track)
    round(fill,4)
    local fillGradient=new("UIGradient",{Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,sliderVisuals.SliderFillGradient[1]),
        ColorSequenceKeypoint.new(1,sliderVisuals.SliderFillGradient[2])
    })},fill)

    local halo=new("Frame",{Name="ThumbHalo",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(0,.5),
        Size=UDim2.fromOffset(20,20),BackgroundColor3=sliderVisuals.SliderHalo,BackgroundTransparency=.88,ZIndex=3},track)
    round(halo,10)
    local thumb=new("Frame",{Name="Thumb",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(0,.5),
        Size=UDim2.fromOffset(13,13),BackgroundColor3=sliderVisuals.SliderThumb,ZIndex=4},track)
    round(thumb,7); local thumbStroke=stroke(thumb,sliderVisuals.SliderThumbStroke,1); thumbStroke.Transparency=.05

    local limits=new("Frame",{Name="Limits",BackgroundTransparency=1,Size=UDim2.new(1,0,0,10),LayoutOrder=3},c.ElementFrame)
    c.SliderArea=area; c.Limits=limits
    label(limits,tostring(low),8,C.Faint,{Size=UDim2.fromScale(.5,1),Font=Enum.Font.Code})
    label(limits,tostring(high),8,C.Faint,{Size=UDim2.fromScale(.5,1),Position=UDim2.fromScale(.5,0),
        TextXAlignment=Enum.TextXAlignment.Right,Font=Enum.Font.Code})

    c._applyThemeExtras=function(self)
        local v=self.Window.ThemeDef.Visuals
        box.BackgroundColor3=v.SliderValueBackground
        box.TextColor3=v.SliderValueText
        if boxStroke then boxStroke.Color=v.SliderValueStroke end
        rail.BackgroundColor3=v.SliderRail
        railStroke.Color=v.SliderRailStroke
        track.BackgroundColor3=v.SliderTrack
        trackGradient.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,v.SliderTrackGradient[1]),
            ColorSequenceKeypoint.new(.5,v.SliderTrackGradient[2]),
            ColorSequenceKeypoint.new(1,v.SliderTrackGradient[3])
        })
        fill.BackgroundColor3=v.SliderFill
        fillGradient.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,v.SliderFillGradient[1]),
            ColorSequenceKeypoint.new(1,v.SliderFillGradient[2])
        })
        halo.BackgroundColor3=v.SliderHalo
        thumb.BackgroundColor3=v.SliderThumb
        thumbStroke.Color=v.SliderThumbStroke
    end

    local function format(value) return string.format("%." .. decimals .. "f",value) end
    function c:Set(value,silent)
        if self.Destroyed then return self end
        value=tonumber(value)
        if not value or value~=value or value==math.huge or value==-math.huge then return self end
        value=math.clamp(low+math.floor((value-low)/step+.5)*step,low,high)
        value=tonumber(format(value)) or low
        local changed=self.Value~=value; self.Value=value; box.Text=format(value)
        local ratio=high>low and (value-low)/(high-low) or 0
        fill.Size=UDim2.fromScale(ratio,1)
        thumb.Position=UDim2.fromScale(ratio,.5)
        halo.Position=UDim2.fromScale(ratio,.5)
        if changed and not silent then invoke(self.Callback,value) end
        return self
    end
    local function update(position)
        local width=track.AbsoluteSize.X
        if width>0 then c:Set(low+math.clamp((position.X-track.AbsolutePosition.X)/width,0,1)*(high-low)) end
    end
    connect(c.Window,area.InputBegan,function(input)
        if c.Locked then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            c.Window:_beginDrag(input,update,self.Content,c); update(input.Position)
        end
    end)
    connect(c.Window,box.FocusLost,function()
        if not c.Locked then c:Set(tonumber(box.Text)) end
        box.Text=format(c.Value)
    end)
    c.Interactive=area
    c:Set(range.Default or (type(o.Value)=="number" and o.Value) or o.Default or low,true)
    c:ApplyTheme()
    return c
end
function Tab:Dropdown(options)
    local o=options or {}; local c=self:_control("Dropdown",o)
    c.Values=table.clone(o.Values or {}); c.Multi=o.Multi==true or o.MultiSelect==true
    local hit=button(c.ElementFrame,"",{Name="Dropdown",BackgroundColor3=C.Field,BackgroundTransparency=Glass.Field,
        Size=UDim2.new(1,0,0,28),LayoutOrder=2}); round(hit,8); stroke(hit,C.Border)
    local valueLabel=label(hit,"",11,C.Text,{Position=UDim2.fromOffset(8,0),Size=UDim2.new(1,-30,1,0),TextWrapped=true})
    label(hit,"⌄",14,C.Muted,{Position=UDim2.new(1,-24,0,0),Size=UDim2.new(0,16,1,0),TextXAlignment=Enum.TextXAlignment.Center})
    c.Interactive=hit; c.BodyField=hit; c.ValueLabel=valueLabel
    function c:Set(value,silent,force)
        if self.Destroyed then return self end
        local changed
        if self.Multi then
            local arr=type(value)=="table" and table.clone(value) or (value and {value} or {})
            changed=table.concat(arr,"\0") ~= table.concat(type(self.Value)=="table" and self.Value or {},"\0")
            self.Value=arr; valueLabel.Text=#arr>0 and table.concat(arr,", ") or "Seleccionar…"
        else
            changed=self.Value~=value; self.Value=value
            valueLabel.Text=value~=nil and tostring(value) or "Seleccionar…"
        end
        if (changed or force) and not silent then invoke(self.Callback,self.Multi and table.clone(self.Value) or self.Value) end
        self.Tab:_queueFilter()
        return self
    end
    function c:Refresh(values)
        self.Values=table.clone(values or {})
        self._revision=(self._revision or 0)+1
        if self.Window._popupOwner==self and self._renderOptions then self._renderOptions() end
        return self
    end
    function c:Open()
        if self.Locked or self.Destroyed then return end
        local window=self.Window
        local panel=window:_popup(self.Title,360,410,self)
        local search=field(panel,"Buscar una opción…")
        search.Position=UDim2.fromOffset(16,48); search.Size=UDim2.new(1,-32,0,30)
        local list=scroll(panel,{Position=UDim2.fromOffset(16,90),Size=UDim2.new(1,-32,1,-120)})
        vertical(list,5)
        local hint=label(panel,"",10,C.Faint,{Position=UDim2.new(0,16,1,-29),Size=UDim2.new(1,-32,0,16)})
        local optionConnections={}
        window._popupCleanup=function() disconnect(optionConnections); self._renderOptions=nil end
        local function render()
            disconnect(optionConnections)
            for _,child in ipairs(list:GetChildren()) do if child:IsA("GuiObject") then child:Destroy() end end
            local query=normalized(search.Text); local count, matches=0,0
            for _,value in ipairs(self.Values) do
                if query=="" or string.find(normalized(value),query,1,true) then
                    matches+=1
                    if count<120 then
                        count+=1
                        local selected=self.Multi and table.find(self.Value,value)~=nil or (not self.Multi and self.Value==value)
                        local choiceHeight=math.max(32,textHeight(tostring(value),12,FONT,math.max(60,panel.AbsoluteSize.X-78))+12)
                        local choice=button(list,"",{Name="Option",Size=UDim2.new(1,-4,0,choiceHeight),LayoutOrder=count,
                            BackgroundColor3=selected and C.Text or C.Row})
                        round(choice,8)
                        label(choice,tostring(value),13,selected and C.Window or C.Text,{Position=UDim2.fromOffset(12,0),
                            Size=UDim2.new(1,-38,1,0),TextWrapped=true})
                        label(choice,selected and "✓" or "",12,C.Window,{Position=UDim2.new(1,-28,0,0),Size=UDim2.new(0,20,1,0)})
                        connect(window,choice.Activated,function()
                            if self.Multi then
                                local arr=table.clone(self.Value); local i=table.find(arr,value)
                                if i then table.remove(arr,i) else table.insert(arr,value) end
                                self:Set(arr)
                                if window._popupOwner==self then render() end
                            else
                                local revision=self._revision or 0
                                self:Set(value,false,true)
                                if window._popupOwner==self and revision==(self._revision or 0) then window:_closePopup() end
                            end
                        end,optionConnections)
                    end
                end
            end
            hint.Text=matches==0 and "Sin resultados" or (matches>120 and "120 de "..matches.." · Escribe para filtrar" or matches.." opciones")
        end
        self._renderOptions=render
        connect(window,search:GetPropertyChangedSignal("Text"),render,window._popupConnections)
        connect(window,panel:GetPropertyChangedSignal("AbsoluteSize"),render,window._popupConnections)
        render()
    end
    connect(c.Window,hit.Activated,function() c:Open() end)
    c:Set(o.Value or o.Default or (c.Multi and {} or nil),true)
    return c
end
function Tab:Colorpicker(options)
    local o = options or {}
    local c = self:_control("Colorpicker", o)
    c.Reserve = 68
    c.HeadMinimum = 40
    local hit = button(c.Head, "", {
        Name = "Color",
        Position = UDim2.new(1, -52, 0, 0),
        Size = UDim2.fromOffset(52, 36),
    })
    round(hit, 10)
    local hitStroke = stroke(hit, C.Border, 1)
    hitStroke.Transparency = 0.06
    local hitInner = new("Frame", {
        Name = "Inner",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -6, 1, -6),
        Position = UDim2.fromOffset(3, 3),
    }, hit)
    round(hitInner, 8)
    c.Interactive = hit

    function c:Set(value, silent)
        if typeof(value) ~= "Color3" then return self end
        local changed = self.Value ~= value
        self.Value = value
        hit.BackgroundColor3 = value
        if self._updateColor then self._updateColor() end
        if changed and not silent then invoke(self.Callback, value) end
        return self
    end

    function c:Open()
        if self.Locked then return end
        local window = self.Window
        local panel = window:_popup(self.Title, 320, 360, self)
        local body = new("Frame", {
            Name = "ColorBody",
            Position = UDim2.fromOffset(14, 50),
            Size = UDim2.new(1, -28, 1, -64),
            BackgroundTransparency = 1,
        }, panel)

        local h, s, v = self.Value:ToHSV()
        local state = { H = h, S = s, V = v, Internal = false }
        if state.S < 0.001 then state.H = 0 end

        local preview = new("Frame", {
            Name = "Preview",
            Size = UDim2.fromOffset(40, 40),
            Position = UDim2.fromOffset(0, 0),
            BackgroundColor3 = self.Value,
        }, body)
        round(preview, 12)
        stroke(preview, C.Border, 1)

        local hex = field(body, "#FFFFFF")
        hex.Position = UDim2.fromOffset(48, 4)
        hex.Size = UDim2.new(1, -48, 0, 32)
        hex.TextSize = 12
        hex.Font = MEDIUM
        hex.TextXAlignment = Enum.TextXAlignment.Center

        local sv = button(body, "", {
            Name = "SV",
            Position = UDim2.fromOffset(0, 52),
            Size = UDim2.new(1, -28, 0, 180),
            BackgroundColor3 = Color3.fromHSV(state.H, 1, 1),
            ClipsDescendants = true,
        })
        round(sv, 12)
        stroke(sv, C.Border, 1).Transparency = 0.08
        local white = new("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            ZIndex = 2,
        }, sv)
        new("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
        }, white)
        local black = new("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.new(0, 0, 0),
            BorderSizePixel = 0,
            ZIndex = 3,
        }, sv)
        new("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(1, 0),
            }),
        }, black)
        local cursor = new("Frame", {
            Name = "Cursor",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(14, 14),
            BackgroundColor3 = Color3.new(1, 1, 1),
            ZIndex = 5,
            Position = UDim2.fromScale(state.S, 1 - state.V),
        }, sv)
        round(cursor, 99)
        stroke(cursor, Color3.new(0, 0, 0), 1.5)

        local hueBar = button(body, "", {
            Name = "Hue",
            Position = UDim2.new(1, -20, 0, 52),
            Size = UDim2.fromOffset(16, 180),
            BackgroundColor3 = Color3.new(1, 1, 1),
        })
        round(hueBar, 8)
        stroke(hueBar, C.Border, 1).Transparency = 0.08
        new("UIGradient", {
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
            }),
        }, hueBar)
        local hueCursor = new("Frame", {
            Name = "HueCursor",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, state.H),
            Size = UDim2.fromOffset(18, 6),
            BackgroundColor3 = Color3.new(1, 1, 1),
            ZIndex = 5,
        }, hueBar)
        round(hueCursor, 3)
        stroke(hueCursor, Color3.new(0, 0, 0), 1)

        local rgbRow = new("Frame", {
            Name = "RGB",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 244),
            Size = UDim2.new(1, 0, 0, 32),
        }, body)
        local function rgbBox(name, order)
            local box = field(rgbRow, name)
            box.Name = name
            box.Size = UDim2.new(0.333, -4, 1, 0)
            box.Position = UDim2.new((order - 1) * 0.333, order > 1 and 2 or 0, 0, 0)
            box.TextXAlignment = Enum.TextXAlignment.Center
            box.TextSize = 11
            box.Font = MEDIUM
            return box
        end
        local rBox, gBox, bBox = rgbBox("R", 1), rgbBox("G", 2), rgbBox("B", 3)

        local function toHex(col)
            return string.format("#%02X%02X%02X", math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5))
        end

        local function applyHSV()
            state.Internal = true
            local col = Color3.fromHSV(state.H, state.S, state.V)
            self:Set(col)
            preview.BackgroundColor3 = col
            sv.BackgroundColor3 = Color3.fromHSV(state.H, 1, 1)
            hex.Text = toHex(col)
            rBox.Text = tostring(math.floor(col.R * 255 + 0.5))
            gBox.Text = tostring(math.floor(col.G * 255 + 0.5))
            bBox.Text = tostring(math.floor(col.B * 255 + 0.5))
            cursor.Position = UDim2.fromScale(state.S, 1 - state.V)
            hueCursor.Position = UDim2.fromScale(0.5, state.H)
            state.Internal = false
        end

        function c._updateColor()
            if state.Internal then return end
            local nh, ns, nv = self.Value:ToHSV()
            if ns > 0.001 then state.H = nh end
            state.S, state.V = ns, nv
            applyHSV()
        end

        local function updateSV(pos)
            local abs = sv.AbsolutePosition
            local size = sv.AbsoluteSize
            if size.X < 1 or size.Y < 1 then return end
            state.S = math.clamp((pos.X - abs.X) / size.X, 0, 1)
            state.V = 1 - math.clamp((pos.Y - abs.Y) / size.Y, 0, 1)
            applyHSV()
        end
        local function updateHue(pos)
            local abs = hueBar.AbsolutePosition
            local size = hueBar.AbsoluteSize
            if size.Y < 1 then return end
            state.H = math.clamp((pos.Y - abs.Y) / size.Y, 0, 1)
            applyHSV()
        end

        connect(window, sv.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                window:_beginDrag(input, updateSV, nil, self)
                updateSV(input.Position)
            end
        end, window._popupConnections)
        connect(window, hueBar.InputBegan, function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                window:_beginDrag(input, updateHue, nil, self)
                updateHue(input.Position)
            end
        end, window._popupConnections)

        connect(window, hex.FocusLost, function()
            local value = hex.Text:gsub("#", "")
            if #value == 6 and value:match("^%x+$") then
                self:Set(Color3.fromHex(value))
                c._updateColor()
            else
                applyHSV()
            end
        end, window._popupConnections)

        local function bindRGB(box, channel)
            connect(window, box.FocusLost, function()
                local n = math.clamp(tonumber(box.Text) or 0, 0, 255)
                local col = self.Value
                local r, g, b = col.R * 255, col.G * 255, col.B * 255
                if channel == "R" then r = n elseif channel == "G" then g = n else b = n end
                self:Set(Color3.fromRGB(r, g, b))
                c._updateColor()
            end, window._popupConnections)
        end
        bindRGB(rBox, "R")
        bindRGB(gBox, "G")
        bindRGB(bBox, "B")

        window._popupCleanup = function()
            self._updateColor = nil
        end
        applyHSV()
    end

    connect(c.Window, hit.Activated, function()
        c:Open()
    end)
    c:Set(o.Default or o.Value or C.White, true)
    return c
end

function Tab:Keybind(options)
    local o = options or {}
    local c = self:_control("Keybind", o)
    c.Reserve = 92
    c.HeadMinimum = 28

    local hit = button(c.Head, "None", {
        Name = "KeybindHit",
        BackgroundColor3 = C.Field,
        BackgroundTransparency = Glass.Field,
        TextSize = 11,
        Font = MEDIUM,
        Size = UDim2.fromOffset(84, 26),
        Position = UDim2.new(1, -84, 0, 1),
        TextXAlignment = Enum.TextXAlignment.Center,
    })
    round(hit, 8)
    local hitStroke = stroke(hit, C.Border, 1)
    hitStroke.Transparency = 0.12
    c.Interactive = hit
    c.Listening = false

    local function keyName(key)
        if typeof(key) ~= "EnumItem" then return "None" end
        local name = key.Name
        local map = {
            LeftControl = "LCtrl", RightControl = "RCtrl",
            LeftShift = "LShift", RightShift = "RShift",
            LeftAlt = "LAlt", RightAlt = "RAlt",
            MouseButton1 = "M1", MouseButton2 = "M2", MouseButton3 = "M3",
        }
        return map[name] or name
    end

    function c:Set(value, silent)
        local key = value
        if type(value) == "string" and value ~= "" and Enum.KeyCode[value] then
            key = Enum.KeyCode[value]
        end
        if key ~= nil and typeof(key) ~= "EnumItem" then return self end
        local changed = self.Value ~= key
        self.Value = key
        hit.Text = keyName(key)
        if changed and not silent then invoke(self.Callback, key) end
        return self
    end

    function c:Get()
        return self.Value
    end

    c:Set(o.Default or o.Value or o.Key, true)

    connect(c.Window, hit.Activated, function()
        if c.Locked or c.Listening then return end
        c.Listening = true
        hit.Text = "..."
        hit.TextColor3 = C.Muted
        local conn
        conn = Input.InputBegan:Connect(function(input, processed)
            if processed then return end
            local key = input.KeyCode
            if key == Enum.KeyCode.Unknown or key == Enum.KeyCode.Escape then
                c.Listening = false
                hit.Text = keyName(c.Value)
                hit.TextColor3 = C.Text
                if conn then conn:Disconnect() end
                return
            end
            c.Listening = false
            hit.TextColor3 = C.Text
            c:Set(key)
            if conn then conn:Disconnect() end
        end)
        table.insert(c.Window._connections, conn)
    end)

    if o.Callback and (o.Mode == "Toggle" or o.Hold or o.OnPress) then
        connect(c.Window, Input.InputBegan, function(input, processed)
            if processed or c.Locked or not c.Value then return end
            if input.KeyCode == c.Value then
                if o.Mode == "Toggle" then
                    c._toggled = not c._toggled
                    invoke(c.Callback, c._toggled)
                else
                    invoke(c.Callback, true)
                end
            end
        end)
        if o.Hold then
            connect(c.Window, Input.InputEnded, function(input)
                if c.Locked or not c.Value then return end
                if input.KeyCode == c.Value then invoke(c.Callback, false) end
            end)
        end
    end

    return c
end

function Tab:Divider(options)
    local o = options or {}
    local c = self:_control("Divider", {
        Title = o.Title or " ",
        Desc = nil,
    })
    c.ElementFrame.BackgroundTransparency = 1
    if c.RowStroke then c.RowStroke.Transparency = 1 end
    c.TitleLabel.Visible = o.Title ~= nil and o.Title ~= ""
    c.TitleLabel.TextSize = 10
    c.TitleLabel.TextColor3 = C.Faint
    c.TitleLabel.Font = BOLD
    if not c.TitleLabel.Visible then
        c.HeadMinimum = 8
        local rule = new("Frame", {
            Name = "Rule",
            BackgroundColor3 = C.Border,
            BackgroundTransparency = 0.55,
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.fromOffset(0, 6),
        }, c.Head)
        c.Rule = rule
    end
    return c
end

function Tab:Label(options)
    return self:Paragraph(options)
end

function Tab:Select() self.Window:SelectTab(self); return self end
function Tab:LockAll() for _,c in ipairs(self.Elements) do c:Lock() end end
function Tab:UnlockAll() for _,c in ipairs(self.Elements) do c:Unlock() end end

function Nox:ConfigureLauncher(config)
    local cfg = config or {}
    local target = LauncherState.Config

    for key,value in pairs(cfg) do
        target[key] = value
    end

    if cfg.Enabled ~= nil then self.Launcher.Enabled = cfg.Enabled ~= false end
    if cfg.AutoLoad ~= nil then self.Launcher.AutoLoad = cfg.AutoLoad end
    if cfg.AutoLoadOnce ~= nil then self.Launcher.AutoLoadOnce = cfg.AutoLoadOnce ~= false end
    if cfg.AutoExecute ~= nil then self.Launcher.AutoExecute = cfg.AutoExecute end
    if cfg.CloseAfterExecute ~= nil then self.Launcher.CloseAfterExecute = cfg.CloseAfterExecute ~= false end
    if cfg.CloseBeforeExecute ~= nil then self.Launcher.CloseBeforeExecute = cfg.CloseBeforeExecute ~= false end

    return self
end

function Nox:RegisterScript(config)
    local entry = type(config) == "table" and table.clone(config) or {Source = config}
    local id = launcherNormalizeId(entry.Id or entry.Key or entry.Name or entry.Title)

    if id == "" then
        error("XeroHub Launcher: cada script necesita Id/Key/Name/Title.")
    end

    entry.Id = id
    entry.Title = tostring(entry.Title or entry.Name or id)
    entry.Description = tostring(entry.Description or entry.Desc or "Ejecutar script.")
    entry.Visible = entry.Visible ~= false
    entry.Enabled = entry.Enabled ~= false

    LauncherState.Scripts[id] = entry
    self.Launcher.Scripts[id] = entry

    return entry
end

function Nox:UnregisterScript(id)
    local key = launcherNormalizeId(id)
    LauncherState.Scripts[key] = nil
    self.Launcher.Scripts[key] = nil
    return self
end

function Nox:GetScript(id)
    local key = launcherNormalizeId(id)
    return LauncherState.Scripts[key] or self.Launcher.Scripts[key]
end

function Nox:GetScripts()
    local result = {}
    for _,entry in pairs(LauncherState.Scripts) do
        result[#result+1] = entry
    end
    table.sort(result,function(a,b)
        return tostring(a.Order or a.Title) < tostring(b.Order or b.Title)
    end)
    return result
end

function Nox:RunAutoLoad(window)
    local cfg = LauncherState.Config or {}
    local source = cfg.AutoLoad
    if source == nil then source = self.Launcher.AutoLoad end
    if source == nil then return true end

    local once = cfg.AutoLoadOnce
    if once == nil then once = self.Launcher.AutoLoadOnce end

    if once and LauncherState.AutoLoaded then
        return true
    end

    if LauncherState.AutoLoadRunning then
        return true
    end

    LauncherState.AutoLoadRunning = true

    local ok, err
    if type(source) == "string" and LauncherState.Scripts[launcherNormalizeId(source)] then
        local entry = LauncherState.Scripts[launcherNormalizeId(source)]
        ok, err = launcherInvoke(window,entry,entry.Id)
    else
        ok, err = launcherInvoke(window,source,"__AUTOLOAD__")
    end

    LauncherState.AutoLoadRunning = false

    if ok then
        LauncherState.AutoLoaded = true
        return true
    end

    if window and not window.Destroyed and self.Notify then
        self:Notify({
            Title = "AutoLoad",
            Content = "Error al inicializar: " .. tostring(err),
            Duration = 4,
        })
    end

    return false, err
end

function Nox:Execute(idOrEntry, window)
    local entry = idOrEntry
    local id

    if type(idOrEntry) == "string" then
        id = launcherNormalizeId(idOrEntry)
        entry = LauncherState.Scripts[id] or self.Launcher.Scripts[id]

        if not entry then
            entry = idOrEntry
            id = "__DIRECT__"
        end
    elseif type(idOrEntry) == "table" then
        id = launcherNormalizeId(idOrEntry.Id or idOrEntry.Key or idOrEntry.Name or idOrEntry.Title or "__DIRECT__")
    else
        id = "__DIRECT__"
    end

    local cfg = LauncherState.Config or {}
    local closeAfter = cfg.CloseAfterExecute
    if closeAfter == nil then closeAfter = self.Launcher.CloseAfterExecute end

    local closeBefore = cfg.CloseBeforeExecute
    if closeBefore == nil then closeBefore = self.Launcher.CloseBeforeExecute end

    self:RunAutoLoad(window)

    if window and not window.Destroyed and closeBefore and closeAfter then
        window:Close()
    end

    local ok, result = launcherInvoke(window,entry,id)

    if not ok then
        if window and not window.Destroyed then
            self:Notify({
                Title = "Launcher",
                Content = "No se pudo ejecutar " .. tostring(id) .. ": " .. tostring(result),
                Duration = 5,
            })
        end
        return false, result
    end

    if window and not window.Destroyed and closeAfter and not closeBefore then
        window:Close()
    end

    return true, result
end

function Nox:SetAutoLoad(source, once)
    self.Launcher.AutoLoad = source
    LauncherState.Config.AutoLoad = source
    if once ~= nil then
        self.Launcher.AutoLoadOnce = once == true
        LauncherState.Config.AutoLoadOnce = once == true
    end
    return self
end

function Nox:SetAutoExecute(target)
    self.Launcher.AutoExecute = target
    LauncherState.Config.AutoExecute = target
    return self
end

function Nox:SetCloseAfterExecute(value)
    local enabled = value ~= false
    self.Launcher.CloseAfterExecute = enabled
    LauncherState.Config.CloseAfterExecute = enabled
    return self
end

local function buildLauncherTab(window, options)
    local cfg = options or {}
    if cfg.Enabled == false or cfg.LauncherMode == false then return nil end

    local tab = window:Tab({
        Title = cfg.Title or "Launcher",
        Desc = cfg.Description or "Centro de ejecución de XeroHub.",
    })

    tab:Section({Title = "Scripts"})

    local scripts = {}
    for _,entry in ipairs(window._launcherScripts or {}) do
        if entry.Visible ~= false then
            scripts[#scripts+1] = entry
        end
    end

    table.sort(scripts,function(a,b)
        local ao = tonumber(a.Order) or 9999
        local bo = tonumber(b.Order) or 9999
        if ao == bo then return tostring(a.Title) < tostring(b.Title) end
        return ao < bo
    end)

    if #scripts == 0 then
        tab:Paragraph({
            Title = "Launcher listo",
            Desc = "Registra scripts mediante Nox:RegisterScript({...}) para mostrarlos aquí.",
            Gothic = true,
            DecorText = "LAUNCHER",
            BadgeText = "READY",
        })
    else
        for _,entry in ipairs(scripts) do
            tab:Button({
                Title = entry.Title,
                Desc = entry.Description,
                Locked = entry.Enabled == false,
                Callback = function()
                    Nox:Execute(entry,window)
                end,
            })
        end
    end

    return tab
end

local DESCRIPTIONS = {
    Inicio="Tu espacio. Todo bajo control.", Aimbot="Organiza tus ajustes de precisión y selección.",
    ["Kill All"]="Controles y ajustes de esta función.", Visuales="Elige qué información quieres ver.",
    Movimiento="Personaliza el movimiento y sus controles.", AutoFarm="Configura tus acciones automáticas.",
    ["Gráficos"]="Ajusta el ambiente, la iluminación y los efectos.", Sonidos="Personaliza los sonidos de disparo y muerte.",
    Animaciones="Combina paquetes y movimientos a tu gusto.", Apariencia="Tu avatar, a tu manera.",
    ["Configuración"]="Tu interfaz y tus configuraciones guardadas.", ["Generar Armas"]="Organiza tus opciones de inventario.", ["Créditos"]="Conoce al creador y los datos del proyecto.",
}

function Nox:KeySystem(config, onSuccess)
    local cfg = config or {}
    local keys = cfg.Key or cfg.Keys or {}
    if type(keys) ~= "table" then keys = {keys} end
    local title = tostring(cfg.Title or "Key System")
    local note = tostring(cfg.Note or cfg.Content or "Introduce una key valida.")
    local saveKey = cfg.SaveKey ~= false
    local folder = tostring(cfg.Folder or "XeroUI")
    local fileName = folder .. "/.key"

    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    local parent = (gethui and gethui()) or game:GetService("CoreGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "XeroUIKeySystem"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.Parent = parent end)
    if not gui.Parent then gui.Parent = lp:WaitForChild("PlayerGui") end

    local shade = Instance.new("Frame")
    shade.Size = UDim2.fromScale(1,1)
    shade.BackgroundColor3 = Color3.new(0,0,0)
    shade.BackgroundTransparency = 0.35
    shade.BorderSizePixel = 0
    shade.Parent = gui

    local panel = Instance.new("Frame")
    panel.AnchorPoint = Vector2.new(0.5,0.5)
    panel.Position = UDim2.fromScale(0.5,0.5)
    panel.Size = UDim2.fromOffset(340,210)
    panel.BackgroundColor3 = C.Window
    panel.BorderSizePixel = 0
    panel.Parent = gui
    local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(0,14); pc.Parent = panel
    local ps = Instance.new("UIStroke"); ps.Color = C.Border; ps.Thickness = 1; ps.Parent = panel

    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Position = UDim2.fromOffset(18,16)
    t.Size = UDim2.new(1,-36,0,24)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 16
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextColor3 = C.Text
    t.Text = title
    t.Parent = panel

    local d = Instance.new("TextLabel")
    d.BackgroundTransparency = 1
    d.Position = UDim2.fromOffset(18,44)
    d.Size = UDim2.new(1,-36,0,40)
    d.Font = Enum.Font.Gotham
    d.TextSize = 12
    d.TextWrapped = true
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.TextYAlignment = Enum.TextYAlignment.Top
    d.TextColor3 = C.Muted
    d.Text = note
    d.Parent = panel

    local box = Instance.new("TextBox")
    box.Position = UDim2.fromOffset(18,96)
    box.Size = UDim2.new(1,-36,0,34)
    box.BackgroundColor3 = C.Field
    box.BorderSizePixel = 0
    box.Font = Enum.Font.Gotham
    box.TextSize = 13
    box.TextColor3 = C.Text
    box.PlaceholderColor3 = C.Faint
    box.PlaceholderText = "Key..."
    box.Text = ""
    box.ClearTextOnFocus = false
    box.Parent = panel
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0,8); bc.Parent = box
    local bs = Instance.new("UIStroke"); bs.Color = C.Border; bs.Thickness = 1; bs.Parent = box
    local bp = Instance.new("UIPadding"); bp.PaddingLeft = UDim.new(0,10); bp.PaddingRight = UDim.new(0,10); bp.Parent = box

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Position = UDim2.fromOffset(18,134)
    status.Size = UDim2.new(1,-36,0,16)
    status.Font = Enum.Font.Gotham
    status.TextSize = 11
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.TextColor3 = C.Muted
    status.Text = ""
    status.Parent = panel

    local submit = Instance.new("TextButton")
    submit.Position = UDim2.fromOffset(18,158)
    submit.Size = UDim2.new(1,-36,0,36)
    submit.BackgroundColor3 = C.Row
    submit.BorderSizePixel = 0
    submit.AutoButtonColor = false
    submit.Font = Enum.Font.GothamMedium
    submit.TextSize = 13
    submit.TextColor3 = C.Text
    submit.Text = cfg.Button or "Continuar"
    submit.Parent = panel
    local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0,9); sc.Parent = submit

    local function valid(k)
        k = tostring(k or ""):gsub("^%s+",""):gsub("%s+$","")
        if k == "" then return false end
        if type(cfg.KeyValidator) == "function" then
            local ok, res = pcall(cfg.KeyValidator, k)
            return ok and res and true or false
        end
        for _,v in ipairs(keys) do
            if tostring(v) == k then return true end
        end
        return false
    end

    local done = false
    local function succeed(k)
        if done then return end
        done = true
        if saveKey and writefile and makefolder then
            pcall(function()
                if not isfolder or not isfolder(folder) then pcall(makefolder, folder) end
                writefile(fileName, k)
            end)
        end
        gui:Destroy()
        if type(onSuccess) == "function" then onSuccess(true) end
    end

    if saveKey and isfile and readfile and isfile(fileName) then
        local okR, saved = pcall(readfile, fileName)
        if okR and valid(saved) then
            gui:Destroy()
            if type(onSuccess) == "function" then onSuccess(true) end
            return true
        end
    end

    submit.MouseButton1Click:Connect(function()
        local k = box.Text
        if valid(k) then
            status.TextColor3 = C.Text
            status.Text = "OK"
            succeed(k)
        else
            status.TextColor3 = Color3.fromRGB(229, 90, 90)
            status.Text = "Key invalida"
        end
    end)
    box.FocusLost:Connect(function(enter)
        if enter then submit.MouseButton1Click:Fire() end
    end)
    return gui
end

function Nox:CreateWindow(options)
    local o=options or {}
    if self.Window and not self.Window.Destroyed then self.Window:Destroy() end
    local player=Players.LocalPlayer
    assert(player,"client only")
    if o.KeySystem then
        local unlocked = false
        self:KeySystem(o.KeySystem, function()
            unlocked = true
        end)
        while not unlocked do
            task.wait()
        end
    end
    local parent = player:WaitForChild("PlayerGui")
    pcall(function()
        if gethui then
            local hui = gethui()
            if hui then parent = hui end
        elseif protectgui or (syn and syn.protect_gui) then
            parent = game:GetService("CoreGui")
        end
    end)
    local env=(getgenv and getgenv()) or _G
    if env.__NOX_UI and env.__NOX_UI.Destroy then pcall(function() env.__NOX_UI:Destroy() end) end
    local resolvedTheme = canonicalThemeName(o.Theme or CURRENT_THEME_NAME)
    local w={_connections={},_popupConnections={},_onDestroy={},_onOpen={},_onClose={},Tabs={},
        Groups={},Opened=true,Destroyed=false,Compact=false,ToggleKey=o.ToggleKey or Enum.KeyCode.RightShift,
        Title=plain(o.Title or "XeroHub"),_brandBaseTitle=plain(o.Title or "XeroHub"),Author=o.Author or "by Kev",UIScale=1,_navOrder=0,
        ThemeName=resolvedTheme,ThemeDef=getThemeDefinition(resolvedTheme),_themeGeneration=0,
        _launcherScripts={},_launcherMode=o.LauncherMode~=false}
    self.Window=w; env.__NOX_UI=w

    local launcherOptions = type(o.Launcher)=="table" and o.Launcher or {}
    if o.AutoLoad ~= nil then launcherOptions.AutoLoad=o.AutoLoad end
    if o.AutoLoadOnce ~= nil then launcherOptions.AutoLoadOnce=o.AutoLoadOnce end
    if o.AutoExecute ~= nil then launcherOptions.AutoExecute=o.AutoExecute end
    if o.CloseAfterExecute ~= nil then launcherOptions.CloseAfterExecute=o.CloseAfterExecute end
    if o.CloseBeforeExecute ~= nil then launcherOptions.CloseBeforeExecute=o.CloseBeforeExecute end
    self:ConfigureLauncher(launcherOptions)

    local providedScripts = o.LauncherScripts or o.Scripts or launcherOptions.Scripts
    if type(providedScripts)=="table" then
        for index,entry in ipairs(providedScripts) do
            if type(entry)=="table" then
                local registered=self:RegisterScript(entry)
                w._launcherScripts[#w._launcherScripts+1]=registered
            end
        end
    end

    for _,entry in pairs(LauncherState.Scripts) do
        local already=false
        for _,localEntry in ipairs(w._launcherScripts) do
            if localEntry.Id==entry.Id then already=true; break end
        end
        if not already then
            w._launcherScripts[#w._launcherScripts+1]=entry
        end
    end

    local gui=new("ScreenGui",{Name="XeroHubUI",ResetOnSpawn=false,IgnoreGuiInset=true,
        DisplayOrder=2147483000,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},parent)
    pcall(function()
        gui.ScreenInsets=Enum.ScreenInsets.None
        gui.ClipToDeviceSafeArea=false
        gui.SafeAreaCompatibility=Enum.SafeAreaCompatibility.None
    end)
    pcall(function() gui.OnTopOfCoreBlur=true end)
    local launcherGui=new("ScreenGui",{Name="XeroHubLauncher",ResetOnSpawn=false,IgnoreGuiInset=true,
        DisplayOrder=2147483001,ZIndexBehavior=Enum.ZIndexBehavior.Sibling},parent)
    pcall(function()
        launcherGui.ScreenInsets=Enum.ScreenInsets.None
        launcherGui.ClipToDeviceSafeArea=false
        launcherGui.SafeAreaCompatibility=Enum.SafeAreaCompatibility.None
    end)
    pcall(function() launcherGui.OnTopOfCoreBlur=true end)
    local launcherSurface=new("Frame",{Name="FullScreen",BackgroundTransparency=1,Size=UDim2.fromScale(1,1)},launcherGui)
    w.LauncherGui=launcherGui
    pcall(function()
        local pg = protectgui or (syn and syn.protect_gui) or (gethui and function() end)
        if protectgui then protectgui(gui) end
        if syn and syn.protect_gui then syn.protect_gui(gui) end
        if protectgui then protectgui(launcherGui) end
        if syn and syn.protect_gui then syn.protect_gui(launcherGui) end
    end)
    self.ScreenGui=gui; w.ScreenGui=gui
    local surface=new("Frame",{Name="Surface",BackgroundTransparency=1,Size=UDim2.fromScale(1,1)},gui)
    local root=new("Frame",{Name="XeroPanel",BackgroundColor3=w.ThemeDef.Visuals.RootBase,BackgroundTransparency=Glass.Root,AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(680,430),ClipsDescendants=true},surface)
    round(root,20); local rootStroke=stroke(root,w.ThemeDef.Visuals.RootStroke)
    local rootGradient=new("UIGradient",{Rotation=22,Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,w.ThemeDef.Visuals.RootGradient[1]),
        ColorSequenceKeypoint.new(.52,w.ThemeDef.Visuals.RootGradient[2]),
        ColorSequenceKeypoint.new(1,w.ThemeDef.Visuals.RootGradient[3])
    })},root)
    local scale=new("UIScale",{Scale=1},root); self.UIScaleObj=scale

    local animeImage=new("ImageLabel",{
        Name="AnimeBackground",BackgroundTransparency=1,AnchorPoint=Vector2.new(.5,.5),
        Position=UDim2.fromScale(.5,.5),Size=UDim2.fromScale(1,1),Image="",
        ImageTransparency=.06,ScaleType=Enum.ScaleType.Crop,Visible=false,ZIndex=1,
    },root)
    round(animeImage,20)

    local animeShade=new("Frame",{
        Name="AnimeShade",BackgroundColor3=w.ThemeDef.Visuals.AnimeShadeColor,BackgroundTransparency=w.ThemeDef.Visuals.AnimeShadeTransparency,
        Size=UDim2.fromScale(1,1),Visible=false,ZIndex=2,
    },root)
    round(animeShade,20)
    local animeShadeGradient=new("UIGradient",{
        Rotation=0,
        Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,w.ThemeDef.Visuals.AnimeShadeStops[1]),
            NumberSequenceKeypoint.new(.58,w.ThemeDef.Visuals.AnimeShadeStops[2]),
            NumberSequenceKeypoint.new(1,w.ThemeDef.Visuals.AnimeShadeStops[3]),
        })
    },animeShade)

    local backdrop=new("Frame",{Name="NoxBackdrop",BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=1},root)
    local glowA=new("Frame",{Name="SoftGlowA",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.68,.34),
        Size=UDim2.fromScale(.54,.62),BackgroundColor3=w.ThemeDef.Visuals.BackdropGlowA,BackgroundTransparency=.58,Rotation=-16,ZIndex=1},backdrop)
    round(glowA,72)
    new("UIGradient",{Rotation=35,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.12),NumberSequenceKeypoint.new(1,1)})},glowA)
    local glowB=new("Frame",{Name="SoftGlowB",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.22,.84),
        Size=UDim2.fromScale(.46,.38),BackgroundColor3=w.ThemeDef.Visuals.BackdropGlowB,BackgroundTransparency=.64,Rotation=18,ZIndex=1},backdrop)
    round(glowB,64)
    new("UIGradient",{Rotation=205,Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,.2),NumberSequenceKeypoint.new(1,1)})},glowB)
    local watermark=label(backdrop,"XERO",80,Color3.fromRGB(255,255,255),{
        AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.61,.58),Size=UDim2.fromScale(.30,.12),
        Font=BOLD,TextTransparency=w.ThemeDef.Visuals.BackdropWatermarkTransparency,TextXAlignment=Enum.TextXAlignment.Center,TextYAlignment=Enum.TextYAlignment.Center,Rotation=-10,ZIndex=1})
    for i=1,6 do
        local v=new("Frame",{Name="GridV",Position=UDim2.new(i/7,0,0,0),Size=UDim2.new(0,1,1,0),
            BackgroundColor3=w.ThemeDef.Visuals.GridColor,BackgroundTransparency=w.ThemeDef.Visuals.GridVTransparency,ZIndex=1},backdrop)
    end
    for i=1,4 do
        local h=new("Frame",{Name="GridH",Position=UDim2.new(0,0,i/5,0),Size=UDim2.new(1,0,0,1),
            BackgroundColor3=w.ThemeDef.Visuals.GridColor,BackgroundTransparency=w.ThemeDef.Visuals.GridHTransparency,ZIndex=1},backdrop)
    end

    local function showBackdropFallback()
        animeImage.Image = ""
        animeImage.Visible = false
        animeShade.Visible = false
        backdrop.Visible = true
    end

    local function applyAnimeBackground(asset, themeDef)
        if not root.Parent or type(asset) ~= "string" or asset == "" then
            showBackdropFallback()
            return
        end
        animeImage.Image = asset
        animeImage.ImageTransparency = (themeDef and themeDef.Visuals and themeDef.Visuals.AnimeImageTransparency) or 0.06
        animeImage.Visible = true
        animeShade.Visible = true
        backdrop.Visible = false
    end

    local function resolveBackgroundAsset(source)
        if source == nil or source == false then return nil end
        if type(source) == "table" then
            source = source.Image or source.URL or source.Url or source.Asset or source.Id
        end
        if type(source) ~= "string" then return nil end
        source = source:gsub("^%s+",""):gsub("%s+$","")
        if source == "" then return nil end
        if source:match("^rbxassetid://") or source:match("^rbxthumb://") or source:match("^rbxasset://") then
            return source
        end
        if source:match("^%d+$") then
            return "rbxassetid://" .. source
        end
        if source:match("^https?://") then
            local assetFn = customAssetFunction()
            if not assetFn or type(writefile) ~= "function" then return nil end
            local body
            local req = (syn and syn.request) or (http and http.request) or http_request or request
            if type(req) == "function" then
                local okRequest, response = pcall(req, {
                    Url = source,
                    Method = "GET",
                    Headers = { ["User-Agent"] = "XeroUI/3.2" },
                })
                if okRequest and response then
                    local status = tonumber(response.StatusCode or response.Status)
                    if status and status >= 200 and status < 300 and isPngPayload(response.Body) then
                        body = response.Body
                    end
                end
            end
            if not body then
                local okHttp, data = pcall(function()
                    return game:HttpGet(source)
                end)
                if okHttp and isPngPayload(data) then body = data end
            end
            if not body then return nil end
            ensureFolderTree(XERO_BACKGROUND_FOLDER)
            local cachePath = XERO_BACKGROUND_FOLDER .. "/custom_" .. tostring(math.floor(os.clock()*1000)%100000000) .. ".png"
            local okWrite = pcall(writefile, cachePath, body)
            if not okWrite then return nil end
            local okAsset, asset = pcall(assetFn, cachePath)
            if okAsset and type(asset) == "string" and asset ~= "" then return asset end
            return nil
        end
        local assetFn = customAssetFunction()
        if assetFn and type(isfile) == "function" and isfile(source) then
            local okAsset, asset = pcall(assetFn, source)
            if okAsset and type(asset) == "string" and asset ~= "" then return asset end
        end
        return source
    end

    function w:ClearBackground()
        w._customBackground = nil
        showBackdropFallback()
        return self
    end

    local function applyIconAsset(targetMark, targetImage, source, size)
        if source == nil or source == false or source == "" then
            targetMark.Visible = true
            targetImage.Visible = false
            targetImage.Image = ""
            return
        end
        local asset = resolveBackgroundAsset(source)
        if not asset then
            if type(source) == "string" and (source:match("^rbxassetid://") or source:match("^%d+$")) then
                asset = source:match("^%d+$") and ("rbxassetid://" .. source) or source
            end
        end
        if asset then
            targetImage.Image = asset
            targetImage.Size = UDim2.fromOffset(size, size)
            targetImage.Visible = true
            targetMark.Visible = false
        else
            targetMark.Visible = true
            targetImage.Visible = false
        end
    end

    function w:SetIcon(source)
        w._customIcon = source
        applyIconAsset(logo, logoImage, source, (w.Narrow and 24) or 28)
        applyIconAsset(openIcon, openIconImage, source, 22)
        return self
    end

    function w:SetLogo(source)
        return self:SetIcon(source)
    end

    function w:ClearIcon()
        w._customIcon = nil
        logo.Visible = true
        logoImage.Visible = false
        logoImage.Image = ""
        openIcon.Visible = true
        openIconImage.Visible = false
        openIconImage.Image = ""
        return self
    end

    function w:GetIcon()
        return w._customIcon
    end

    function w:SetBackground(source, transparency)
        if source == nil or source == false or source == "" then
            return self:ClearBackground()
        end
        w._customBackground = source
        if typeof(transparency) == "number" then
            w._customBackgroundTransparency = math.clamp(transparency, 0, 1)
        end
        local themeDef = w.ThemeDef
        local asset = resolveBackgroundAsset(source)
        if asset then
            applyAnimeBackground(asset, themeDef)
            if w._customBackgroundTransparency ~= nil then
                animeImage.ImageTransparency = w._customBackgroundTransparency
            end
        else
            showBackdropFallback()
        end
        return self
    end

    function w:GetBackground()
        return w._customBackground
    end

    local function refreshBackgroundForTheme(themeName)
        local resolved = canonicalThemeName(themeName)
        local themeDef = getThemeDefinition(resolved)
        w._themeGeneration += 1
        local generation = w._themeGeneration
        if w._customBackground then
            local asset = resolveBackgroundAsset(w._customBackground)
            if asset and not w.Destroyed and w._themeGeneration == generation then
                applyAnimeBackground(asset, themeDef)
                if w._customBackgroundTransparency ~= nil then
                    animeImage.ImageTransparency = w._customBackgroundTransparency
                end
                return
            end
            showBackdropFallback()
            return
        end
        local source = backgroundSource(resolved)
        if not source or not source.URL or source.URL == "" then
            showBackdropFallback()
            return
        end
        local cachedAnimeAsset = cachedBackgroundAsset(resolved)
        if cachedAnimeAsset then
            applyAnimeBackground(cachedAnimeAsset, themeDef)
            return
        end
        showBackdropFallback()
        task.spawn(function()
            local asset = downloadBackgroundAsset(resolved)
            if asset and not w.Destroyed and w._themeGeneration == generation then
                applyAnimeBackground(asset, themeDef)
            end
        end)
    end

    local top=new("Frame",{Name="Topbar",BackgroundTransparency=1,Size=UDim2.new(1,0,0,58),ZIndex=5},root)
    local logo=mark(top,28); logo.Position=UDim2.fromOffset(16,12)
    local logoImage=new("ImageLabel",{
        Name="LogoImage",BackgroundTransparency=1,Size=UDim2.fromOffset(28,28),
        Position=UDim2.fromOffset(16,12),Image="",ScaleType=Enum.ScaleType.Fit,Visible=false,ZIndex=6,
    },top)
    round(logoImage,8)

    local titleCluster=new("Frame",{Name="TitleCluster",BackgroundTransparency=1,
        Position=UDim2.fromOffset(50,9),Size=UDim2.fromOffset(290,24)},top)
    local brand=label(titleCluster,w._brandBaseTitle,16,C.Text,{Position=UDim2.fromOffset(0,0),
        Size=UDim2.fromOffset(120,22),Font=BOLD})
    local statusLabel=label(titleCluster,"-- activos",12,C.Muted,{Position=UDim2.fromOffset(126,0),
        Size=UDim2.fromOffset(96,22),Font=BOLD})
    local inferredGameLabel=w._brandBaseTitle:match("|%s*(.-)%s*$")
    local subtitleGame=tostring(o.Subtitle or inferredGameLabel or "XERO")
    local subtitle=label(top,"X E R O  /  "..subtitleGame,8,C.Faint,{Position=UDim2.fromOffset(52,37),Size=UDim2.fromOffset(180,14)})
    local author=label(top,w.Author,11,C.Muted,{Position=UDim2.new(1,-248,0,27),Size=UDim2.fromOffset(104,20),TextXAlignment=Enum.TextXAlignment.Right})
    local controls=new("Frame",{BackgroundTransparency=1,Position=UDim2.new(1,-76,0,8),Size=UDim2.fromOffset(64,28)},top)
    local menu=button(controls,"",{Name="Menu",Size=UDim2.fromOffset(1,1),Visible=false,Active=false})
    local minimize=button(controls,"",{Name="Minimize",Position=UDim2.fromOffset(0,0),Size=UDim2.fromOffset(28,28)}); round(minimize,8)
    icon(minimize,"minus").Position=UDim2.fromOffset(4,4)
    local close=button(controls,"",{Name="Close",Position=UDim2.fromOffset(32,0),Size=UDim2.fromOffset(28,28)}); round(close,8)
    icon(close,"close").Position=UDim2.fromOffset(4,4)
    hover(w,minimize); hover(w,close)
    local topRule=line(root,14,57,784,1,0,C.Border); topRule.Size=UDim2.new(1,-28,0,1)
    local sidebar=new("Frame",{Name="Navigation",BackgroundColor3=w.ThemeDef.Visuals.SidebarBase,BackgroundTransparency=Glass.Sidebar,Position=UDim2.fromOffset(12,70),
        Size=UDim2.new(0,154,1,-82),ZIndex=12},root); round(sidebar,12); local sidebarStroke=stroke(sidebar,w.ThemeDef.Visuals.SidebarStroke)
    local nav=scroll(sidebar,{Name="Tabs",Position=UDim2.fromOffset(8,10),Size=UDim2.new(1,-16,1,-58),ScrollBarThickness=0})
    vertical(nav,6)
    local navFooter=label(sidebar,"XERO  /  OBSIDIAN",8,C.Faint,{Position=UDim2.new(0,12,1,-28),Size=UDim2.new(1,-24,0,16),Font=Enum.Font.Code})
    local drawerShade=button(root,"",{Name="DrawerBackdrop",BackgroundTransparency=1,
        Position=UDim2.fromOffset(0,70),Size=UDim2.new(1,0,1,-70),Visible=false,Active=false,ZIndex=11})
    local content=new("Frame",{Name="Content",BackgroundTransparency=1,Position=UDim2.fromOffset(182,70),Size=UDim2.new(1,-194,1,-82),ZIndex=4},root)
    local pageTitle=label(content,"Inicio",20,C.Text,{Size=UDim2.new(1,-90,0,26),Font=BOLD})
    local pageDesc=label(content,DESCRIPTIONS.Inicio,10,C.Muted,{Position=UDim2.fromOffset(0,24),Size=UDim2.new(1,0,0,20),TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top})
    local count=label(content,"0 opciones",9,C.Faint,{Position=UDim2.new(1,-96,0,5),Size=UDim2.fromOffset(96,16),TextXAlignment=Enum.TextXAlignment.Right,Font=Enum.Font.Code})
    w.CountLabel=count
    local searchBox=new("Frame",{Name="SearchBox",BackgroundColor3=C.Field,BackgroundTransparency=Glass.Field,ClipsDescendants=true,
        Position=UDim2.new(1,-312,0,8),Size=UDim2.fromOffset(198,30),ZIndex=6},top)
    round(searchBox,9); local searchStroke=stroke(searchBox,w.ThemeDef.Visuals.SearchStroke)
    local search=new("TextBox",{Name="Search",BackgroundTransparency=1,ClearTextOnFocus=false,TextSize=12,TextTruncate=Enum.TextTruncate.AtEnd,
        PlaceholderText="Buscar ajuste...",PlaceholderColor3=C.Faint,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center,
        Position=UDim2.fromOffset(28,0),Size=UDim2.new(1,-54,1,0)},searchBox)
    icon(searchBox,"search").Position=UDim2.new(0,8,.5,-10)
    local clear=button(searchBox,"×",{Name="Clear",BackgroundTransparency=1,Position=UDim2.new(1,-28,0,0),Size=UDim2.new(0,26,1,0),Visible=false})
    local pages=new("Frame",{Name="Pages",BackgroundTransparency=1,Position=UDim2.fromOffset(0,34),Size=UDim2.new(1,0,1,-34)},content)
    local footer=label(root,"XEROHUB",8,C.Faint,{Position=UDim2.new(0,18,1,-24),Size=UDim2.new(.6,0,0,14),Font=Enum.Font.Code})
    local shortcut=label(root,"RSHIFT  /  MOSTRAR U OCULTAR",8,C.Faint,{Position=UDim2.new(.4,0,1,-24),Size=UDim2.new(.6,-18,0,14),TextXAlignment=Enum.TextXAlignment.Right,Font=Enum.Font.Code})
    local openButton=button(launcherSurface,"",{Name="OpenXeroHub",Position=UDim2.new(.5,-73,0,16),Size=UDim2.fromOffset(146,44),BackgroundColor3=w.ThemeDef.Visuals.OpenButtonBase,BackgroundTransparency=Glass.Button,ZIndex=20})
    round(openButton,12); local openStroke=stroke(openButton,w.ThemeDef.Visuals.OpenStroke)
    local openIcon=mark(openButton,22); openIcon.Position=UDim2.fromOffset(12,11)
    local openIconImage=new("ImageLabel",{
        Name="OpenIconImage",BackgroundTransparency=1,Size=UDim2.fromOffset(22,22),
        Position=UDim2.fromOffset(12,11),Image="",ScaleType=Enum.ScaleType.Fit,Visible=false,ZIndex=21,
    },openButton)
    round(openIconImage,6)
    local openLabel=label(openButton,"XEROHUB",11,C.Text,{Position=UDim2.fromOffset(45,5),Size=UDim2.new(1,-55,0,20),Font=MEDIUM})
    local openHint=label(openButton,"ABRIR PANEL",8,C.Muted,{Position=UDim2.fromOffset(45,25),Size=UDim2.new(1,-55,0,12),Font=MEDIUM})
    w.OpenButton=openButton; w._launcherMoved=false; w.UIElements={Main=root,Title=brand,ActiveStatus=statusLabel,SideBar=sidebar,MainBar=content,Pages=pages,Search=searchBox,Topbar=top}
    local desired=o.Size or UDim2.fromOffset(680,430)
    w._desiredWidth=desired.X.Offset>0 and desired.X.Offset or 680
    w._desiredHeight=desired.Y.Offset>0 and desired.Y.Offset or 430
    w._initialFitDone=false
    w.Resizable=o.Resizable~=false
    local minSize=o.MinSize or Vector2.new(390,320)
    w._minWidth=math.max(300,tonumber(minSize.X) or 390)
    w._minHeight=math.max(260,tonumber(minSize.Y) or 320)

    local resizeHandles={}
    local resizeVisuals={}

    local function addResizeVisual(name, position, anchor, size, rotation)
        local grip = new("Frame", {
            Name = name,
            AnchorPoint = anchor,
            Position = position,
            Size = size,
            Rotation = rotation or 0,
            BackgroundColor3 = C.Text,
            BackgroundTransparency = w.ThemeDef.Visuals.ResizeGuideTransparency,
            BorderSizePixel = 0,
            ZIndex = 39,
            Visible = w.Resizable,
        }, root)
        round(grip, 99)
        table.insert(resizeVisuals, grip)
        return grip
    end

    addResizeVisual("ResizeGuideBL_Outer", UDim2.new(0, 13, 1, -10), Vector2.new(.5, .5), UDim2.fromOffset(16, 3), -45)
    addResizeVisual("ResizeGuideBL_Inner", UDim2.new(0, 20, 1, -10), Vector2.new(.5, .5), UDim2.fromOffset(10, 3), -45)
    addResizeVisual("ResizeGuideBR_Outer", UDim2.new(1, -13, 1, -10), Vector2.new(.5, .5), UDim2.fromOffset(16, 3), 45)
    addResizeVisual("ResizeGuideBR_Inner", UDim2.new(1, -20, 1, -10), Vector2.new(.5, .5), UDim2.fromOffset(10, 3), 45)

    addResizeVisual("ResizeGuideLeft", UDim2.new(0, 6, .5, 0), Vector2.new(.5, .5), UDim2.fromOffset(3, 36), 0)
    addResizeVisual("ResizeGuideRight", UDim2.new(1, -6, .5, 0), Vector2.new(.5, .5), UDim2.fromOffset(3, 36), 0)

    local function addResizeHandle(name,position,anchor,size,xFactor,yFactor,showGrip)
        local hit=button(root,"",{Name=name,AnchorPoint=anchor,Position=position,
            Size=size,BackgroundTransparency=1,ZIndex=40,Visible=w.Resizable})
        table.insert(resizeHandles,{Hit=hit,X=xFactor,Y=yFactor})
        return hit
    end
    addResizeHandle("ResizeTL",UDim2.fromScale(0,0),Vector2.new(0,0),UDim2.fromOffset(28,28),-1,-1,false)
    addResizeHandle("ResizeTR",UDim2.fromScale(1,0),Vector2.new(1,0),UDim2.fromOffset(28,28), 1,-1,false)
    addResizeHandle("ResizeBL",UDim2.fromScale(0,1),Vector2.new(0,1),UDim2.fromOffset(28,28),-1, 1,false)
    addResizeHandle("ResizeBR",UDim2.fromScale(1,1),Vector2.new(1,1),UDim2.fromOffset(28,28), 1, 1,false)
    addResizeHandle("ResizeTop",UDim2.fromScale(.5,0),Vector2.new(.5,0),UDim2.new(.34,0,0,12),0,-1,false)
    addResizeHandle("ResizeBottom",UDim2.fromScale(.5,1),Vector2.new(.5,1),UDim2.new(.34,0,0,14),0,1,false)
    addResizeHandle("ResizeLeft",UDim2.fromScale(0,.5),Vector2.new(0,.5),UDim2.new(0,12,.34,0),-1,0,false)
    addResizeHandle("ResizeRight",UDim2.fromScale(1,.5),Vector2.new(1,.5),UDim2.new(0,12,.34,0),1,0,false)
    function w:_endDrag()
        local d=self._drag; self._drag=nil
        if d and d.Scroll and d.Scroll.Parent then d.Scroll.ScrollingEnabled=d.WasScrolling end
        if d and type(d.Owner)=="table" and d.Owner.X~=nil and d.Owner.Y~=nil then
            if self._fit then self._fit(false) end
        end
    end
    function w:_beginDrag(input,update,scroller,owner)
        self:_endDrag()
        self._drag={Input=input,Update=update,Scroll=scroller,Owner=owner,WasScrolling=scroller and scroller.ScrollingEnabled}
        if scroller then scroller.ScrollingEnabled=false end
    end
    function w:_closePopup()
        self:_endDrag(); disconnect(self._popupConnections)
        if self._popupCleanup then self._popupCleanup(); self._popupCleanup=nil end
        if self._popupLayer then self._popupLayer:Destroy(); self._popupLayer=nil end
        self._popupOwner=nil
        launcherGui.Enabled=true
    end
    function w:_popup(title,width,height,owner)
        self:_closePopup()
        local layer=button(surface,"",{Name="ModalBackdrop",BackgroundColor3=Color3.new(),BackgroundTransparency=1,Size=UDim2.fromScale(1,1),ZIndex=50})
        launcherGui.Enabled=false
        local panel=button(layer,"",{Name="Modal",BackgroundColor3=C.Panel,BackgroundTransparency=1,AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(width,height),ZIndex=2,ClipsDescendants=true})
        round(panel,16); stroke(panel,C.Border)
        local pScale=new("UIScale",{Scale=0.94},panel)
        label(panel,title,14,C.Text,{Position=UDim2.fromOffset(16,17),Size=UDim2.new(1,-62,0,22),Font=BOLD,TextTruncate=Enum.TextTruncate.AtEnd})
        local dismiss=button(panel,"×",{Position=UDim2.new(1,-50,0,7),Size=UDim2.fromOffset(40,40),TextSize=18}); round(dismiss,8)
        local function fit()
            panel.Size=UDim2.fromOffset(math.max(100,math.min(width,surface.AbsoluteSize.X-24)),math.max(100,math.min(height,surface.AbsoluteSize.Y-24)))
        end
        connect(self,layer.Activated,function() self:_closePopup() end,self._popupConnections)
        connect(self,dismiss.Activated,function() self:_closePopup() end,self._popupConnections)
        connect(self,surface:GetPropertyChangedSignal("AbsoluteSize"),fit,self._popupConnections)
        self._popupLayer=layer; self._popupOwner=owner; fit()
        softTween(layer,{BackgroundTransparency=0.35},0.2)
        softTween(panel,{BackgroundTransparency=Glass.Popup},0.22)
        softTween(pScale,{Scale=1},0.28,Enum.EasingStyle.Back)
        return panel
    end
    function w:_drawer(value)
        self._drawerOpen=false
        sidebar.Visible=true
        drawerShade.Visible=false
    end
    local function clampRoot()
        local bounds=surface.AbsoluteSize; local size=root.AbsoluteSize
        if bounds.X<=0 or bounds.Y<=0 then return end
        local x=root.Position.X.Scale*bounds.X+root.Position.X.Offset
        local y=root.Position.Y.Scale*bounds.Y+root.Position.Y.Offset
        local minX=math.min(size.X/2,bounds.X/2); local minY=math.min(size.Y/2,bounds.Y/2)
        root.Position=UDim2.fromOffset(math.clamp(x,minX,math.max(minX,bounds.X-minX)),math.clamp(y,minY,math.max(minY,bounds.Y-minY)))
    end
    local function clampLauncher()
        local bounds=launcherSurface.AbsoluteSize; local size=openButton.AbsoluteSize
        local position=openButton.Position
        openButton.Position=UDim2.fromOffset(math.clamp(position.X.Scale*bounds.X+position.X.Offset,0,math.max(0,bounds.X-size.X)),
            math.clamp(position.Y.Scale*bounds.Y+position.Y.Offset,0,math.max(0,bounds.Y-size.Y)))
    end
    function w:_applyOpenButtonState()
        local ghosted=self._openButtonGhosted==true
        local visibleWhenClosed=(self._openButtonEnabled~=false) or ghosted
        local shouldShow=(not self.Opened) and visibleWhenClosed
        openButton.Visible=shouldShow
        openButton.Active=shouldShow
        openButton.AutoButtonColor=shouldShow and (not ghosted)
        openButton.BackgroundTransparency=ghosted and 1 or Glass.Button
        openLabel.TextTransparency=ghosted and 1 or 0
        openHint.TextTransparency=ghosted and 1 or 0
        if openStroke then openStroke.Transparency=ghosted and 1 or 0 end
        if openIcon then
            for _,d in ipairs(openIcon:GetDescendants()) do
                if d:IsA("Frame") then d.BackgroundTransparency=ghosted and 1 or 0 end
                if d:IsA("UIStroke") then d.Transparency=ghosted and 1 or 0 end
            end
        end
    end
    local function fit(skipContentLayout)
        if w.Destroyed then return end
        local bounds=surface.AbsoluteSize
        if bounds.X<1 or bounds.Y<1 then return end

        local maxWidth=math.max(280,bounds.X/w.UIScale)
        local maxHeight=math.max(240,bounds.Y/w.UIScale)
        local minWidth=math.min(w._minWidth,maxWidth)
        local minHeight=math.min(w._minHeight,maxHeight)

        if not w._initialFitDone then
            if maxHeight < 500 then
                w._desiredHeight=math.min(w._desiredHeight,math.max(minHeight,maxHeight*0.78))
                w._desiredWidth=math.min(w._desiredWidth,math.max(minWidth,maxWidth*0.76))
            elseif maxWidth < 650 then
                w._desiredWidth=math.min(w._desiredWidth,math.max(minWidth,maxWidth*0.86))
                w._desiredHeight=math.min(w._desiredHeight,math.max(minHeight,maxHeight*0.84))
            elseif maxWidth < 900 then
                w._desiredWidth=math.min(w._desiredWidth,math.max(minWidth,maxWidth*0.78))
                w._desiredHeight=math.min(w._desiredHeight,math.max(minHeight,maxHeight*0.80))
            end
            w._initialFitDone=true
        end

        local width=math.clamp(w._desiredWidth,minWidth,maxWidth)
        local height=math.clamp(w._desiredHeight,minHeight,maxHeight)
        root.Size=UDim2.fromOffset(width,height)

        local phone=width<520
        local tiny=width<380
        local short=height<390
        local veryShort=height<330
        w.Short=height<435
        w.Narrow=width<500
        w.Compact=width<650 or w.Short

        local topHeight=(phone or short) and 48 or 52
        local contentTop=topHeight+8
        local sidebarWidth
        if width<340 then sidebarWidth=76
        elseif width<430 then sidebarWidth=86
        elseif width<560 then sidebarWidth=100
        elseif width<700 then sidebarWidth=116
        else sidebarWidth=136 end

        local left=8+sidebarWidth+10
        local right=phone and 7 or 10
        local bottom=veryShort and 4 or (w.Short and 6 or 9)
        w.ContentWidth=math.max(150,width-left-right)

        top.Size=UDim2.new(1,0,0,topHeight)
        logo.Size=UDim2.fromOffset(phone and 24 or 28,phone and 24 or 28)
        logoImage.Size=UDim2.fromOffset(phone and 24 or 28,phone and 24 or 28)
        logoImage.Position=logo.Position
        logo.Position=UDim2.fromOffset(phone and 10 or 14,phone and 11 or 11)
        logo.Visible=true

        controls.Position=UDim2.new(1,-68,0,8)
        controls.Size=UDim2.fromOffset(60,28)
        minimize.Position=UDim2.fromOffset(0,0); minimize.Size=UDim2.fromOffset(26,26)
        close.Position=UDim2.fromOffset(30,0); close.Size=UDim2.fromOffset(26,26)

        local clusterX=phone and 40 or 48
        local clusterRight=width-76
        local clusterWidth=math.max(82,clusterRight-clusterX-4)
        titleCluster.Position=UDim2.fromOffset(clusterX,phone and 10 or 10)
        titleCluster.Size=UDim2.fromOffset(clusterWidth,24)
        brand.Text=(tiny and "XERO") or (w._brandBaseTitle or "XeroHub")
        brand.TextSize=phone and 13 or 15
        statusLabel.TextSize=phone and 10 or 11

        local measuredBrand=math.ceil(TextService:GetTextSize(
            brand.Text,brand.TextSize,brand.Font,Vector2.new(300,24)
        ).X)
        local measuredStatus=math.ceil(TextService:GetTextSize(
            statusLabel.Text,statusLabel.TextSize,statusLabel.Font,Vector2.new(180,24)
        ).X)
        local gap=phone and 6 or 8
        local canShowStatus=(measuredBrand+gap+measuredStatus)<=clusterWidth
        if not canShowStatus and brand.Text~="XERO" then
            brand.Text="XERO"
            measuredBrand=math.ceil(TextService:GetTextSize(
                brand.Text,brand.TextSize,brand.Font,Vector2.new(180,24)
            ).X)
            canShowStatus=(measuredBrand+gap+measuredStatus)<=clusterWidth
        end
        brand.Position=UDim2.fromOffset(0,0)
        brand.Size=UDim2.fromOffset(math.min(measuredBrand,clusterWidth),22)
        statusLabel.Position=UDim2.fromOffset(measuredBrand+gap,0)
        statusLabel.Size=UDim2.fromOffset(math.max(0,clusterWidth-measuredBrand-gap),22)
        statusLabel.Visible=canShowStatus

        subtitle.Visible=false
        author.Visible=false
        menu.Visible=false

        topRule.Position=UDim2.fromOffset(12,topHeight-1)
        topRule.Size=UDim2.new(1,-24,0,1)

        sidebar.Visible=true
        sidebar.Position=UDim2.fromOffset(8,contentTop)
        sidebar.Size=UDim2.new(0,sidebarWidth,1,-contentTop-bottom)
        nav.Position=UDim2.fromOffset(4,6)
        nav.Size=UDim2.new(1,-8,1,(w.Short or sidebarWidth<110) and -10 or -32)
        nav.ScrollBarThickness=2
        navFooter.Visible=not w.Short and sidebarWidth>=116
        navFooter.Position=UDim2.new(0,8,1,-27)
        navFooter.Size=UDim2.new(1,-16,0,15)
        drawerShade.Visible=false

        if phone then
            if searchBox.Parent~=content then searchBox.Parent=content end
            searchBox.Position=UDim2.fromOffset(0,28)
            searchBox.Size=UDim2.new(1,0,0,28)
            searchBox.Visible=w.ContentWidth>=150
        else
            if searchBox.Parent~=top then searchBox.Parent=top end
            local searchWidth=math.clamp(math.floor(width*0.28),170,236)
            searchBox.Size=UDim2.fromOffset(searchWidth,28)
            searchBox.Position=UDim2.new(1,-(searchWidth+76),0,8)
            searchBox.Visible=true
        end

        content.Position=UDim2.fromOffset(left,contentTop)
        content.Size=UDim2.new(1,-left-right,1,-contentTop-bottom)
        pageTitle.Position=UDim2.fromOffset(0,0)
        pageTitle.Size=UDim2.new(1,phone and 0 or -76,0,22)
        pageTitle.TextSize=phone and 16 or 18
        pageTitle.TextTruncate=Enum.TextTruncate.AtEnd

        count.Position=UDim2.new(1,-84,0,2)
        count.Visible=(not phone) and (not short) and width>=720

        pageDesc.Position=UDim2.fromOffset(0,21)
        pageDesc.Size=UDim2.new(1,-6,0,18)
        pageDesc.Visible=(not phone) and height>=430 and w.ContentWidth>=280

        local pagesY
        if phone then
            pagesY=62
        else
            pagesY=pageDesc.Visible and 40 or 25
        end
        pages.Position=UDim2.fromOffset(0,pagesY)
        pages.Size=UDim2.new(1,0,1,-pagesY)

        footer.Visible=(not phone) and (not short)
        shortcut.Visible=(not phone) and (not short) and width>=660

        for _,tab in ipairs(w.Tabs) do
            if tab.NavButton then
                tab.NavButton.Size=UDim2.new(1,0,0,phone and 30 or 28)
            end
            if tab.SelectionBar then
                tab.SelectionBar.Position=UDim2.fromOffset(1,phone and 6 or 5)
                tab.SelectionBar.Size=UDim2.fromOffset(2,18)
                tab.SelectionBar.Visible=(w.CurrentTab==tab)
                tab.SelectionBar.BackgroundTransparency=(w.CurrentTab==tab) and 0 or 1
            end
            local glyph=tab.NavButton and tab.NavButton:FindFirstChildOfClass("Frame")
            if glyph then
                glyph.Position=UDim2.fromOffset(phone and 4 or 6,phone and 5 or 4)
                glyph.Visible=sidebarWidth>=76
            end
            if tab.NavTitle then
                tab.NavTitle.Position=UDim2.fromOffset(phone and 23 or 26,0)
                tab.NavTitle.Size=UDim2.new(1,phone and -25 or -30,1,0)
                tab.NavTitle.TextSize=phone and 9 or 10
            end
        end
        for _,section in ipairs(w.Groups) do
            local group=section.ElementFrame
            if group then
                local heading=group:FindFirstChildOfClass("TextLabel")
                if heading then
                    heading.TextSize=phone and 8 or 9
                    heading.Size=UDim2.new(1,-6,0,phone and 18 or 20)
                end
            end
        end

        if bounds.X<380 then
            openButton.Size=UDim2.fromOffset(math.min(138,math.max(112,bounds.X-20)),44)
            openLabel.Text="XEROHUB"
            openLabel.TextSize=11
        else
            openButton.Size=UDim2.fromOffset(146,44)
            openLabel.Text="XEROHUB"
            openLabel.TextSize=11
        end
        if not w._launcherMoved then
            local launcherWidth=openButton.Size.X.Offset
            openButton.Position=UDim2.fromOffset(math.max(0,math.floor((bounds.X-launcherWidth)/2)),16)
        end

        w:_drawer(false)
        clampRoot()
        clampLauncher()
        if not skipContentLayout then
            for _,tab in ipairs(w.Tabs) do tab:_queueFilter() end
        end
    end
    w._fit=fit
    function w:SelectTab(which)
        if self.Destroyed then return end
        local target=type(which)=="number" and self.Tabs[which] or which
        if type(which)=="string" then for _,tab in ipairs(self.Tabs) do if tab.Title==which then target=tab; break end end end
        if type(target)~="table" or target.Window~=self then return end
        if self.CurrentTab then self.CurrentTab.Query=search.Text end
        self:_closePopup()
        self.CurrentTab=target
        for _,tab in ipairs(self.Tabs) do
            local selected=tab==target
            tab.Page.Visible=selected
            tab.NavButton.BackgroundColor3=selected and C.Row or self.ThemeDef.Visuals.NavButtonIdle
            tab.NavButton.BackgroundTransparency=selected and Glass.NavActive or Glass.NavIdle
            tab.NavTitle.TextColor3=selected and C.Text or C.Muted
            if tab.Number then tab.Number.TextColor3=selected and C.Text or C.Faint end
            if tab.SelectionBar then
                tab.SelectionBar.Visible=selected
                tab.SelectionBar.BackgroundTransparency=selected and 0 or 1
            end
        end
        pageTitle.Text=target.Title; pageDesc.Text=target.Desc
        search.Text=target.Query or ""; clear.Visible=search.Text~=""
        self:_drawer(false); target:_filter()
        return target
    end
    function w:_tab(options,holder)
        local opt=options or {}; local title=plain(opt.Title or "Pestaña")
        local index=#self.Tabs+1
        local tab=setmetatable({Window=self,Title=title,Desc=opt.Desc or DESCRIPTIONS[title] or "Personaliza tus opciones.",
            Elements={},_order=0,Query="",Index=index},Tab)
        local page=new("Frame",{Name=title,BackgroundTransparency=1,Size=UDim2.fromScale(1,1),Visible=false},pages)
        local list=scroll(page,{Name="Options",AutomaticCanvasSize=Enum.AutomaticSize.None}); vertical(list,5); padding(list,2,4)
        local empty=label(page,"Sin coincidencias. Prueba otra búsqueda.",12,C.Muted,{Position=UDim2.fromOffset(12,18),Size=UDim2.new(1,-24,0,50),TextWrapped=true,Visible=false})
        local navButton=button(holder or nav,"",{Name=title,Size=UDim2.new(1,0,0,28),BackgroundColor3=self.ThemeDef.Visuals.NavButtonIdle,BackgroundTransparency=Glass.NavIdle,LayoutOrder=index})
        round(navButton,8)
        local selectionBar=new("Frame",{Name="Selected",Position=UDim2.fromOffset(1,5),Size=UDim2.fromOffset(2,18),
            BackgroundColor3=C.Text,BackgroundTransparency=0,Visible=false,ZIndex=3},navButton); round(selectionBar,2)
        local glyph=icon(navButton,title,string.format("%02d",index)); glyph.Position=UDim2.fromOffset(6,4)
        local titleLabel=label(navButton,title,10,C.Muted,{Position=UDim2.fromOffset(26,0),Size=UDim2.new(1,-30,1,0),Font=MEDIUM,TextTruncate=Enum.TextTruncate.AtEnd})
        tab.Page,tab.Content,tab.Empty=page,list,empty; tab.NavButton,tab.NavTitle=navButton,titleLabel
        tab.Number=glyph:FindFirstChildOfClass("TextLabel"); tab.SelectionBar=selectionBar
        table.insert(self.Tabs,tab)
        connect(self,navButton.Activated,function() self:SelectTab(tab) end)
        connect(self,navButton.MouseEnter,function()
            if self.CurrentTab~=tab then
                navButton.BackgroundColor3=self.ThemeDef.Visuals.NavButtonHover
                navButton.BackgroundTransparency=Glass.NavHover
            end
        end)
        connect(self,navButton.MouseLeave,function()
            if self.CurrentTab~=tab then
                navButton.BackgroundColor3=self.ThemeDef.Visuals.NavButtonIdle
                navButton.BackgroundTransparency=Glass.NavIdle
            end
        end)
        connect(self,list:GetPropertyChangedSignal("AbsoluteSize"),function() tab:_queueFilter() end)
        if not self.CurrentTab then self:SelectTab(tab) end
        return tab
    end
    function w:Tab(options) return self:_tab(options) end
    function w:Section(options)
        local opt=options or {}; self._navOrder+=1
        local group=new("Frame",{Name=plain(opt.Title),BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=self._navOrder},nav)
        vertical(group,6)
        local heading=label(group,string.upper(plain(opt.Title or "GENERAL")),9,C.Faint,{Size=UDim2.new(1,-8,0,20),Font=BOLD,LayoutOrder=0,TextWrapped=true})
        padding(heading,8,0)
        local items=new("Frame",{Name="Items",BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=1},group)
        vertical(items,3)
        local section={Window=self,ElementFrame=group}
        function section:Tab(config) return self.Window:_tab(config,items) end
        function section:Open() items.Visible=true; return self end
        function section:Close() items.Visible=false; return self end
        table.insert(self.Groups,section)
        return section
    end
    function w:SetTitle(title)
        self.Title=plain(title)
        footer.Text=self.Title

        local active=self.Title:match("(%d+)%s+activos")
        local baseTitle=self.Title:gsub("%s*%d+%s+activos%s*$","")
        baseTitle=baseTitle:gsub("%s*·%s*$","")
        baseTitle=baseTitle:gsub("%s*%-%s*$","")
        baseTitle=baseTitle:gsub("%s+$","")
        if baseTitle=="" then baseTitle="XeroHub" end
        self._brandBaseTitle=baseTitle

        if active then
            statusLabel.Text=active.." activos"
        end

        if self._fit then
            self._fit(true)
        else
            brand.Text=self._brandBaseTitle
        end
        return self
    end
    function w:SetAuthor(text) self.Author=plain(text); author.Text=self.Author end
    function w:SetSize(size)
        self._desiredWidth=math.max(1,size.X.Offset); self._desiredHeight=math.max(1,size.Y.Offset); fit(); return self
    end
    function w:GetSize() return Vector2.new(self._desiredWidth,self._desiredHeight) end
    function w:SetResizable(value)
        self.Resizable=value~=false
        for _,info in ipairs(resizeHandles) do info.Hit.Visible=self.Resizable end
        for _,grip in ipairs(resizeVisuals) do grip.Visible=self.Resizable end
        return self
    end
    function w:SetUIScale(value)
        self.UIScale=math.clamp(tonumber(value) or 1,.7,1.4); scale.Scale=self.UIScale
        Nox.UIScale=self.UIScale; fit(); return self
    end
    function w:GetUIScale() return self.UIScale end
    function w:SetToTheCenter() root.Position=UDim2.fromScale(.5,.5); clampRoot(); return self end
    function w:SetToggleKey(key) self.ToggleKey=key; return self end
    function w:SetOpenButtonVisible(value)
        if value==nil then
            self._openButtonEnabled=true
        else
            self._openButtonEnabled=value~=false
        end
        self:_applyOpenButtonState()
        return self
    end
    function w:SetOpenButtonGhosted(value)
        self._openButtonGhosted=value==true
        self:_applyOpenButtonState()
        return self
    end
    function w:EditOpenButton(config)
        if config.Enabled~=nil then self:SetOpenButtonVisible(config.Enabled) end
        if config.Ghosted~=nil then self:SetOpenButtonGhosted(config.Ghosted) end
        if config.Title then openLabel.Text=plain(config.Title) end
        return self
    end
    function w:GetTheme()
        return self.ThemeName or CURRENT_THEME_NAME
    end
    function w:SetTheme(name, silent)
        local resolved = canonicalThemeName(name)
        local themeDef = getThemeDefinition(resolved)
        self.ThemeName = resolved
        self.ThemeDef = themeDef
        applyThemeDefinition(resolved)

        root.BackgroundColor3 = themeDef.Visuals.RootBase
        root.BackgroundTransparency = Glass.Root
        rootStroke.Color = themeDef.Visuals.RootStroke
        rootGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, themeDef.Visuals.RootGradient[1]),
            ColorSequenceKeypoint.new(.52, themeDef.Visuals.RootGradient[2]),
            ColorSequenceKeypoint.new(1, themeDef.Visuals.RootGradient[3])
        })
        animeShade.BackgroundColor3 = themeDef.Visuals.AnimeShadeColor
        animeShade.BackgroundTransparency = themeDef.Visuals.AnimeShadeTransparency
        animeShadeGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, themeDef.Visuals.AnimeShadeStops[1]),
            NumberSequenceKeypoint.new(.58, themeDef.Visuals.AnimeShadeStops[2]),
            NumberSequenceKeypoint.new(1, themeDef.Visuals.AnimeShadeStops[3])
        })
        glowA.BackgroundColor3 = themeDef.Visuals.BackdropGlowA
        glowB.BackgroundColor3 = themeDef.Visuals.BackdropGlowB
        watermark.TextTransparency = themeDef.Visuals.BackdropWatermarkTransparency
        for _, child in ipairs(backdrop:GetChildren()) do
            if child.Name == "GridV" then
                child.BackgroundColor3 = themeDef.Visuals.GridColor
                child.BackgroundTransparency = themeDef.Visuals.GridVTransparency
            elseif child.Name == "GridH" then
                child.BackgroundColor3 = themeDef.Visuals.GridColor
                child.BackgroundTransparency = themeDef.Visuals.GridHTransparency
            end
        end
        topRule.BackgroundColor3 = C.Border
        sidebar.BackgroundColor3 = themeDef.Visuals.SidebarBase
        sidebar.BackgroundTransparency = Glass.Sidebar
        sidebarStroke.Color = themeDef.Visuals.SidebarStroke
        searchBox.BackgroundColor3 = C.Field
        searchBox.BackgroundTransparency = Glass.Field
        searchStroke.Color = themeDef.Visuals.SearchStroke
        openButton.BackgroundColor3 = themeDef.Visuals.OpenButtonBase
        openButton.BackgroundTransparency = Glass.Button
        openStroke.Color = themeDef.Visuals.OpenStroke
        for _, grip in ipairs(resizeVisuals) do
            grip.BackgroundColor3 = C.Text
            grip.BackgroundTransparency = themeDef.Visuals.ResizeGuideTransparency
        end
        self:_applyOpenButtonState()
        if self.CurrentTab then
            self:SelectTab(self.CurrentTab)
        end
        applyThemeRolesRecursive(gui)
        applyThemeRolesRecursive(launcherGui)
        for _, tab in ipairs(self.Tabs) do
            for _, control in ipairs(tab.Elements or {}) do
                if control.ApplyTheme then control:ApplyTheme() end
            end
        end
        refreshBackgroundForTheme(resolved)
        if not silent and Nox.Notify and Nox.Window == self then
            Nox:Notify({Title = "Tema", Content = "Interfaz cambiada a " .. (resolved == "Blanco" and "Blanco" or "Oscuro")})
        end
        return self
    end
    function w:RegisterScript(config)
        local entry=Nox:RegisterScript(config)
        local exists=false
        for _,item in ipairs(self._launcherScripts) do
            if item.Id==entry.Id then exists=true; break end
        end
        if not exists then
            self._launcherScripts[#self._launcherScripts+1]=entry
        end
        return entry
    end
    function w:ExecuteScript(idOrEntry)
        return Nox:Execute(idOrEntry,self)
    end
    function w:SetAutoLoad(source,once)
        Nox:SetAutoLoad(source,once)
        return self
    end
    function w:SetAutoExecute(target)
        Nox:SetAutoExecute(target)
        return self
    end
    function w:SetCloseAfterExecute(value)
        Nox:SetCloseAfterExecute(value)
        return self
    end
    function w:OnDestroy(callback) table.insert(self._onDestroy,callback); return self end
    function w:OnOpen(callback) table.insert(self._onOpen,callback); return self end
    function w:OnClose(callback) table.insert(self._onClose,callback); return self end
    function w:Open()
        if self.Destroyed then return self end
        local changed = not self.Opened
        self.Opened = true
        root.Visible = true
        root.BackgroundTransparency = 1
        if scale then scale.Scale = 0.94 * self.UIScale end
        softTween(root, { BackgroundTransparency = Glass.Root }, 0.28)
        if scale then softTween(scale, { Scale = self.UIScale }, 0.32, Enum.EasingStyle.Back) end
        self:_applyOpenButtonState()
        if changed then for _, callback in ipairs(self._onOpen) do invoke(callback) end end
        return self
    end
    function w:Close()
        if self.Destroyed then return self end
        local changed = self.Opened
        self.Opened = false
        self:_closePopup()
        softTween(root, { BackgroundTransparency = 1 }, 0.18)
        if scale then softTween(scale, { Scale = 0.94 * self.UIScale }, 0.18) end
        task.delay(0.18, function()
            if not self.Opened and not self.Destroyed then
                root.Visible = false
            end
        end)
        self:_applyOpenButtonState()
        if changed then for _, callback in ipairs(self._onClose) do invoke(callback) end end
        return self
    end
    function w:Toggle() if self.Opened then return self:Close() else return self:Open() end end
    function w:Destroy()
        if self.Destroyed then return end
        self.Destroyed=true; self:_closePopup(); disconnect(self._connections)
        for _,callback in ipairs(self._onDestroy) do invoke(callback) end
        gui:Destroy(); launcherGui:Destroy()
        if env.__NOX_UI==self then env.__NOX_UI=nil end
        if Nox.Window==self then Nox.Window=nil end
    end
    function w:Dialog(config)
        local cfg=config or {}; local panel=self:_popup(plain(cfg.Title or "XeroHub"),350,230,nil)
        local body=scroll(panel,{Position=UDim2.fromOffset(18,58),Size=UDim2.new(1,-36,1,-122)})
        label(body,plain(cfg.Content or cfg.Desc),13,C.Muted,{Size=UDim2.new(1,-6,0,0),AutomaticSize=Enum.AutomaticSize.Y,TextWrapped=true,TextYAlignment=Enum.TextYAlignment.Top})
        local buttons=cfg.Buttons or {{Title="Aceptar"}}
        for i,entry in ipairs(buttons) do
            local b=button(panel,entry.Title or "Aceptar",{Position=UDim2.new((i-1)/#buttons,16,1,-54),Size=UDim2.new(1/#buttons,-22,0,36)})
            round(b,8)
            connect(self,b.Activated,function() self:_closePopup(); invoke(entry.Callback) end,self._popupConnections)
        end
        return {Close=function() self:_closePopup() end}
    end
    connect(w,minimize.Activated,function() w:Close() end)
    connect(w,close.Activated,function()
        w:Dialog({Title="Cerrar XeroHub",Content="Se cerrará el panel y se limpiará esta sesión. Puedes volver a ejecutar el hub cuando quieras.",
            Buttons={{Title="Volver"},{Title="Cerrar",Callback=function() w:Destroy() end}}})
    end)
    connect(w,clear.Activated,function() search.Text="" end)
    connect(w,search:GetPropertyChangedSignal("Text"),function()
        clear.Visible=search.Text~=""
        if w.CurrentTab then w.CurrentTab.Query=search.Text; w.CurrentTab:_queueFilter() end
    end)
    local function drag(input,target,centered)
        if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
        local start=input.Position; local pos=target.Position; local moved=false
        local parentSize=target.Parent.AbsoluteSize
        local startX=pos.X.Scale*parentSize.X+pos.X.Offset
        local startY=pos.Y.Scale*parentSize.Y+pos.Y.Offset
        w:_beginDrag(input,function(position)
            local delta=position-start
            if delta.Magnitude>5 then moved=true end
            if moved then
                target.Position=UDim2.fromOffset(startX+delta.X,startY+delta.Y)
                if centered then clampRoot() else
                    w._launcherMoved=true
                    w._skipOpen=true
                    clampLauncher()
                end
            end
        end)
    end

    local function beginResize(info,input)
        if not w.Resizable then return end
        if input.UserInputType~=Enum.UserInputType.MouseButton1 and input.UserInputType~=Enum.UserInputType.Touch then return end
        local start=input.Position
        local startWidth=root.AbsoluteSize.X
        local startHeight=root.AbsoluteSize.Y
        local bounds=surface.AbsoluteSize
        local rootCenter=Vector2.new(root.AbsolutePosition.X+root.AbsoluteSize.X/2,root.AbsolutePosition.Y+root.AbsoluteSize.Y/2)
        w:_beginDrag(input,function(position)
            local delta=position-start
            local maxScreenW=math.max(260,bounds.X)
            local maxScreenH=math.max(220,bounds.Y)
            local minScreenW=math.min(w._minWidth*w.UIScale,maxScreenW)
            local minScreenH=math.min(w._minHeight*w.UIScale,maxScreenH)
            local screenW=math.clamp(startWidth+info.X*delta.X,minScreenW,maxScreenW)
            local screenH=math.clamp(startHeight+info.Y*delta.Y,minScreenH,maxScreenH)
            w._desiredWidth=screenW/w.UIScale
            w._desiredHeight=screenH/w.UIScale
            root.Size=UDim2.fromOffset(w._desiredWidth,w._desiredHeight)
            if not w._resizeFitQueued then
                w._resizeFitQueued=true
                task.defer(function()
                    RunService.RenderStepped:Wait()
                    w._resizeFitQueued=false
                    if not w.Destroyed then fit(true) end
                end)
            end
        end,nil,info)
    end
    for _,info in ipairs(resizeHandles) do
        connect(w,info.Hit.InputBegan,function(input) beginResize(info,input) end)
    end
    top.Active=true
    connect(w,top.InputBegan,function(input)
        if input.Position.X < controls.AbsolutePosition.X then drag(input,root,true) end
    end)
    connect(w,openButton.InputBegan,function(input) w._skipOpen=false; drag(input,openButton,false) end)
    connect(w,openButton.Activated,function() if not w._skipOpen then w:Toggle() end end)
    connect(w,Input.InputChanged,function(input)
        local d=w._drag
        if d and ((d.Input.UserInputType==Enum.UserInputType.Touch and input==d.Input)
            or (d.Input.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseMovement)) then d.Update(input.Position) end
    end)
    connect(w,Input.InputEnded,function(input)
        local d=w._drag
        if d and (input==d.Input or (d.Input.UserInputType==Enum.UserInputType.MouseButton1 and input.UserInputType==Enum.UserInputType.MouseButton1)) then w:_endDrag() end
    end)
    connect(w,Input.WindowFocusReleased,function() w:_endDrag() end)
    connect(w,Input.InputBegan,function(input,processed)
        if input.KeyCode==Enum.KeyCode.Escape and w._popupLayer then w:_closePopup(); return end
        if processed or Input:GetFocusedTextBox() then return end
        if input.KeyCode==w.ToggleKey then w:Toggle() end
    end)
    connect(w,surface:GetPropertyChangedSignal("AbsoluteSize"),fit)
    connect(w,launcherSurface:GetPropertyChangedSignal("AbsoluteSize"),clampLauncher)
    connect(w,gui.Destroying,function() if not w.Destroyed then w:Destroy() end end)
    if o.OpenButton then w:EditOpenButton(o.OpenButton) end
    if o.Author then w:SetAuthor(o.Author) end
    footer.Text="XEROHUB  /  KEV"

    if w._launcherMode then
        w._launcherTab = buildLauncherTab(w,o)
    end

    w:SetTheme(resolvedTheme, true)
    local bgOpt = o.Background or o.BackgroundImage or o.Image or o.AnimeBackground
    if bgOpt ~= nil then
        w:SetBackground(bgOpt, o.BackgroundTransparency or o.ImageTransparency)
    else
        refreshBackgroundForTheme(resolvedTheme)
    end
    local iconOpt = o.Icon or o.Logo or o.LogoImage
    if iconOpt ~= nil then
        w:SetIcon(iconOpt)
    end

    task.defer(function()
        if w.Destroyed then return end

        self:RunAutoLoad(w)

        local cfg = LauncherState.Config or {}
        local autoExecute = cfg.AutoExecute
        if autoExecute == nil then autoExecute = self.Launcher.AutoExecute end

        if autoExecute ~= nil and autoExecute ~= false then
            task.defer(function()
                if w.Destroyed then return end

                local target = autoExecute
                if target == true then
                    target = cfg.AutoExecuteScript or self.Launcher.AutoExecuteScript
                end

                if target ~= nil and target ~= false then
                    self:Execute(target,w)
                end
            end)
        end
    end)

    task.defer(function()
        if not w.Destroyed then
            fit()
            w.Opened = true
            root.Visible = true
            root.BackgroundTransparency = Glass.Root
            if scale then scale.Scale = w.UIScale end
            w:_applyOpenButtonState()
        end
    end)
    return w
end
function Nox:AddTheme(name, definition)
    local themeName = tostring(name or "")
    if themeName == "" then return nil end
    definition = definition or {}
    local hasFull = type(definition.Colors) == "table" and type(definition.Visuals) == "table" and type(definition.Glass) == "table"
    local baseName = "Xero"
    if definition.Base then
        baseName = canonicalThemeName(definition.Base)
    elseif string.lower(tostring(definition.Style or "")) == "light" then
        baseName = "Blanco"
    elseif hasFull and not definition.Base then
        baseName = nil
    end
    local merged
    if baseName == nil then
        merged = deepCopy(definition)
    else
        local base = THEMES[baseName] or THEMES.Xero
        merged = deepMerge(base, definition)
    end
    merged.Name = themeName
    if type(merged.Colors) ~= "table" then merged.Colors = deepCopy((THEMES.Xero).Colors) end
    if type(merged.Glass) ~= "table" then merged.Glass = deepCopy((THEMES.Xero).Glass) end
    if type(merged.Visuals) ~= "table" then merged.Visuals = deepCopy((THEMES.Xero).Visuals) end
    THEMES[themeName] = merged
    if definition.Background then
        THEME_BACKGROUNDS[themeName] = {
            URL = tostring(definition.Background.URL or definition.BackgroundUrl or ""),
            CACHE = tostring(definition.Background.CACHE or definition.BackgroundCache or ("XeroHub/Assets/" .. themeName .. ".png")),
        }
    end
    return merged
end

function Nox:RemoveTheme(name)
    local themeName = tostring(name or "")
    local protected = {
        Xero = true, Blanco = true, Midnight = true, Ocean = true, Emerald = true,
        Crimson = true, Violet = true, Amber = true, Cyber = true, Rose = true, Nord = true, Carbon = true,
    }
    if protected[themeName] then return false end
    THEMES[themeName] = nil
    THEME_BACKGROUNDS[themeName] = nil
    return true
end

function Nox:SetTheme(name)
    local resolved = canonicalThemeName(name)
    if not THEMES[resolved] then
        resolved = "Xero"
    end
    applyThemeDefinition(resolved)
    self.Theme = {Name = resolved, Accent = C.White, Background = C.Window, Text = C.Text}
    if self.Window and not self.Window.Destroyed and self.Window.SetTheme then
        self.Window:SetTheme(resolved, true)
    end
    return self.Theme
end

function Nox:GetCurrentTheme()
    if self.Window and not self.Window.Destroyed and self.Window.GetTheme then
        return self.Window:GetTheme()
    end
    return CURRENT_THEME_NAME
end

function Nox:GetThemes()
    local list = {}
    for name, def in pairs(THEMES) do
        list[name] = {Name = def.Name or name}
    end
    return list
end

function Nox:GetTheme(name)
    local resolved = canonicalThemeName(name or CURRENT_THEME_NAME)
    return THEMES[resolved]
end
function Nox:Notify(options)
    if not self.Window then return end
    local w = self.Window
    local o = options or {}
    if w.Destroyed then return end
    w._notices = w._notices or {}
    local duration = math.clamp(tonumber(o.Duration) or 3, 1, 12)
    local holder = new("Frame", {
        Name = "XeroNotice",
        BackgroundColor3 = C.Window,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 40, 0, 0),
        Size = UDim2.fromOffset(300, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 120,
        BackgroundTransparency = 0.04,
    }, w.ScreenGui)
    new("UISizeConstraint", { MaxSize = Vector2.new(340, math.huge) }, holder)
    round(holder, 14)
    local st = stroke(holder, C.Border, 1)
    st.Transparency = 0.15
    padding(holder, 14, 12)
    vertical(holder, 6)

    local accent = new("Frame", {
        Name = "Accent",
        BackgroundColor3 = (typeof(o.Color) == "Color3" and o.Color) or C.Text,
        Size = UDim2.new(0, 3, 1, 0),
        Position = UDim2.fromOffset(0, 0),
        ZIndex = 121,
    }, holder)
    round(accent, 2)

    label(holder, plain(o.Title or "XeroHub"), 13, C.Text, { Font = BOLD, LayoutOrder = 1, Size = UDim2.new(1, -8, 0, 18) })
    label(holder, plain(o.Content or o.Desc or ""), 12, C.Muted, {
        Size = UDim2.new(1, -8, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        TextWrapped = true,
        LayoutOrder = 2,
    })

    local barBg = new("Frame", {
        Name = "BarBg",
        BackgroundColor3 = C.Border,
        BackgroundTransparency = 0.5,
        Size = UDim2.new(1, 0, 0, 3),
        LayoutOrder = 3,
    }, holder)
    round(barBg, 2)
    local bar = new("Frame", {
        Name = "Bar",
        BackgroundColor3 = (typeof(o.Color) == "Color3" and o.Color) or C.Text,
        Size = UDim2.fromScale(1, 1),
        BorderSizePixel = 0,
    }, barBg)
    round(bar, 2)

    local function layoutNotices()
        local y = 16
        for i = #w._notices, 1, -1 do
            local item = w._notices[i]
            if item and item.Parent then
                softTween(item, { Position = UDim2.new(1, -16, 0, y) }, 0.22)
                y = y + item.AbsoluteSize.Y + 10
            else
                table.remove(w._notices, i)
            end
        end
    end

    table.insert(w._notices, holder)
    task.defer(function()
        layoutNotices()
        softTween(holder, { Position = UDim2.new(1, -16, 0, holder.Position.Y.Offset) }, 0.28)
        softTween(bar, { Size = UDim2.fromScale(0, 1) }, duration, Enum.EasingStyle.Linear)
    end)

    local closed = false
    local function close()
        if closed then return end
        closed = true
        softTween(holder, { Position = UDim2.new(1, 40, 0, holder.Position.Y.Offset), BackgroundTransparency = 1 }, 0.2)
        task.delay(0.22, function()
            if holder.Parent then holder:Destroy() end
            for i, item in ipairs(w._notices) do
                if item == holder then
                    table.remove(w._notices, i)
                    break
                end
            end
            layoutNotices()
        end)
    end

    task.delay(duration, close)
    return { Close = close }
end

Nox:SetTheme("Xero")
return Nox