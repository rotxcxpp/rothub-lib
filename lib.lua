--[[
╔══════════════════════════════════════════════════════════╗
║           FERAL UI LIBRARY - Grand Piece Online          ║
║                                                          ║
║  Bu dosyayı executor'a yapıştır, direkt çalışır.        ║
║  Aynı zamanda kendi toggle/slider'larını ekleyebilirsin: ║
║                                                          ║
║  local Toggle = Tabs.Main:AddToggle("id", {             ║
║      Title = "Auto Join PS", Default = false             ║
║  })                                                      ║
║  Toggle:OnChanged(function(val) print(val) end)          ║
║                                                          ║
║  RightShift → Menüyü aç/kapat                           ║
╚══════════════════════════════════════════════════════════╝
--]]

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer      = Players.LocalPlayer
local Mouse            = LocalPlayer:GetMouse()

-- ══════════════════════════════════════
-- RENKLER
-- ══════════════════════════════════════
local C = {
    BgMain     = Color3.fromRGB(15, 15, 26),
    BgRowHov   = Color3.fromRGB(28, 28, 46),
    Sidebar    = Color3.fromRGB(11, 11, 20),
    Header     = Color3.fromRGB(13, 13, 23),
    Border     = Color3.fromRGB(42, 42, 72),
    Accent     = Color3.fromRGB(74, 122, 255),
    TxtMain    = Color3.fromRGB(218, 222, 245),
    TxtSub     = Color3.fromRGB(98, 102, 158),
    TxtMuted   = Color3.fromRGB(68, 68, 118),
    TxtTab     = Color3.fromRGB(255, 255, 255),
    TxtTabOff  = Color3.fromRGB(128, 128, 185),
    ChkBg      = Color3.fromRGB(13, 18, 48),
    ChkBorder  = Color3.fromRGB(55, 55, 95),
    SliderBg   = Color3.fromRGB(32, 32, 56),
    SliderFill = Color3.fromRGB(74, 122, 255),
    InputBg    = Color3.fromRGB(18, 18, 32),
    InputBord  = Color3.fromRGB(50, 50, 88),
    BtnBg      = Color3.fromRGB(25, 25, 48),
    BtnBord    = Color3.fromRGB(55, 55, 100),
    BtnHov     = Color3.fromRGB(38, 38, 68),
    Divider    = Color3.fromRGB(35, 35, 60),
    AvatarPink = Color3.fromRGB(230, 155, 188),
    White      = Color3.fromRGB(255, 255, 255),
}

-- ══════════════════════════════════════
-- YARDIMCILAR
-- ══════════════════════════════════════
local function New(cls, props, kids)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do if k ~= "Parent" then o[k] = v end end
    for _, c in ipairs(kids or {}) do c.Parent = o end
    if props and props.Parent then o.Parent = props.Parent end
    return o
end

local function Tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or .14, Enum.EasingStyle.Quad), props):Play()
end

local function Drag(frame, handle)
    local drag, di, mp, fp = false
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true; mp = i.Position; fp = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then drag = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement then di = i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i == di and drag then
            local d = i.Position - mp
            frame.Position = UDim2.new(fp.X.Scale, fp.X.Offset + d.X, fp.Y.Scale, fp.Y.Offset + d.Y)
        end
    end)
end

-- ══════════════════════════════════════
-- GUI KURULUM
-- ══════════════════════════════════════
pcall(function()
    if game.CoreGui:FindFirstChild("FeralMenu") then
        game.CoreGui.FeralMenu:Destroy()
    end
end)

local W, H, HDR_H, SB_W = 640, 390, 40, 130

local GUI = New("ScreenGui", {
    Name = "FeralMenu", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = game.CoreGui,
})

local Main = New("Frame", {
    Size = UDim2.new(0,W,0,H),
    Position = UDim2.new(0.5,-W/2,0.5,-H/2),
    BackgroundColor3 = C.BgMain,
    BorderSizePixel = 0, ClipsDescendants = true,
    Parent = GUI,
}, {
    New("UICorner", {CornerRadius = UDim.new(0,8)}),
    New("UIStroke", {Color = C.Border, Thickness = 1}),
})

-- Header
local Hdr = New("Frame", {
    Size = UDim2.new(1,0,0,HDR_H),
    BackgroundColor3 = C.Header,
    BorderSizePixel = 0, ZIndex = 3, Parent = Main,
}, { New("UICorner", {CornerRadius = UDim.new(0,8)}) })
New("Frame", {Size=UDim2.new(1,0,0.5,0), Position=UDim2.new(0,0,0.5,0),
    BackgroundColor3=C.Header, BorderSizePixel=0, ZIndex=3, Parent=Hdr})
New("Frame", {Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
    BackgroundColor3=C.Border, BorderSizePixel=0, ZIndex=4, Parent=Hdr})
New("Frame", {Size=UDim2.new(0,26,0,26), Position=UDim2.new(0,10,0,7),
    BackgroundColor3=C.AvatarPink, BorderSizePixel=0, ZIndex=4, Parent=Hdr}, {
    New("UICorner", {CornerRadius=UDim.new(1,0)}),
    New("TextLabel", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
        Text="🐱", TextScaled=true, Font=Enum.Font.GothamBold, TextColor3=C.White, ZIndex=5}),
})
New("TextLabel", {Size=UDim2.new(0,80,1,0), Position=UDim2.new(0,40,0,0),
    BackgroundTransparency=1, Text="Feral", Font=Enum.Font.GothamBold,
    TextSize=15, TextColor3=C.White, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4, Parent=Hdr})

local ClsBtn = New("TextButton", {Size=UDim2.new(0,28,0,28), Position=UDim2.new(1,-30,0,6),
    BackgroundTransparency=1, Text="✕", TextSize=14, Font=Enum.Font.GothamBold,
    TextColor3=Color3.fromRGB(200,75,75), ZIndex=4, Parent=Hdr})
local SettBtn = New("TextButton", {Size=UDim2.new(0,28,0,28), Position=UDim2.new(1,-60,0,6),
    BackgroundTransparency=1, Text="⚙", TextSize=15, Font=Enum.Font.GothamBold,
    TextColor3=C.TxtMuted, ZIndex=4, Parent=Hdr})

ClsBtn.MouseButton1Click:Connect(function()
    Tw(Main, {Size=UDim2.new(0,W,0,0), Position=UDim2.new(0.5,-W/2,0.5,0)}, .18)
    task.delay(.2, function() GUI.Enabled = false end)
end)
SettBtn.MouseEnter:Connect(function() Tw(SettBtn, {TextColor3=C.White}, .1) end)
SettBtn.MouseLeave:Connect(function() Tw(SettBtn, {TextColor3=C.TxtMuted}, .1) end)
Drag(Main, Hdr)

-- Body
local Body = New("Frame", {
    Size=UDim2.new(1,0,1,-HDR_H), Position=UDim2.new(0,0,0,HDR_H),
    BackgroundTransparency=1, ClipsDescendants=true, Parent=Main,
})

-- Sidebar
local SB = New("Frame", {
    Size=UDim2.new(0,SB_W,1,0), BackgroundColor3=C.Sidebar,
    BorderSizePixel=0, Parent=Body,
}, { New("UIStroke", {Color=C.Border, Thickness=1}) })
New("TextLabel", {Size=UDim2.new(1,-10,0,28), Position=UDim2.new(0,10,0,4),
    BackgroundTransparency=1, Text="Grand Piece Online",
    Font=Enum.Font.Gotham, TextSize=10, TextColor3=C.TxtMuted,
    TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, Parent=SB})
local TabList = New("Frame", {
    Size=UDim2.new(1,0,1,-32), Position=UDim2.new(0,0,0,32),
    BackgroundTransparency=1, Parent=SB,
}, { New("UIListLayout", {FillDirection=Enum.FillDirection.Vertical, SortOrder=Enum.SortOrder.LayoutOrder}) })

-- Panel
local Panel = New("Frame", {
    Size=UDim2.new(1,-SB_W,1,0), Position=UDim2.new(0,SB_W,0,0),
    BackgroundTransparency=1, Parent=Body,
})
local TitleRow = New("Frame", {Size=UDim2.new(1,0,0,30), BackgroundTransparency=1, Parent=Panel})
local TitleLbl = New("TextLabel", {
    Size=UDim2.new(1,-36,1,0), Position=UDim2.new(0,14,0,0),
    BackgroundTransparency=1, Text="Main Tab",
    Font=Enum.Font.GothamBold, TextSize=14, TextColor3=C.White,
    TextXAlignment=Enum.TextXAlignment.Left, Parent=TitleRow,
})
New("TextLabel", {Size=UDim2.new(0,22,1,0), Position=UDim2.new(1,-26,0,0),
    BackgroundTransparency=1, Text="🔍", TextSize=14,
    Font=Enum.Font.GothamBold, TextColor3=C.TxtMuted, Parent=TitleRow})
New("Frame", {Size=UDim2.new(1,0,0,1), Position=UDim2.new(0,0,1,-1),
    BackgroundColor3=C.Divider, BorderSizePixel=0, Parent=TitleRow})

-- ══════════════════════════════════════
-- TAB SİSTEMİ
-- ══════════════════════════════════════
local TabBtns  = {}
local TabOrder = 0
local ActiveTabScroll = nil

local function SwitchTo(tabName, tabScroll)
    for name, b in pairs(TabBtns) do
        Tw(b.Lbl, {TextColor3 = name == tabName and C.TxtTab or C.TxtTabOff}, .12)
        b.Lbl.Font = name == tabName and Enum.Font.GothamBold or Enum.Font.Gotham
        b.Ind.Visible = name == tabName
        b.Abg.Visible = name == tabName
    end
    TitleLbl.Text = tabName .. " Tab"
    if ActiveTabScroll then ActiveTabScroll.Visible = false end
    tabScroll.Visible = true
    ActiveTabScroll = tabScroll
end

local function AddTab(name)
    TabOrder += 1

    -- Sidebar butonu
    local TBtn = New("Frame", {
        Size=UDim2.new(1,0,0,32), BackgroundTransparency=1,
        LayoutOrder=TabOrder, Parent=TabList,
    })
    local Ind = New("Frame", {
        Size=UDim2.new(0,2,0.6,0), Position=UDim2.new(0,0,0.2,0),
        BackgroundColor3=C.Accent, BorderSizePixel=0, Visible=false, Parent=TBtn,
    })
    local Abg = New("Frame", {
        Size=UDim2.new(1,0,1,0),
        BackgroundColor3=Color3.fromRGB(55,95,210),
        BackgroundTransparency=0.88, BorderSizePixel=0, Visible=false, Parent=TBtn,
    })
    local Lbl = New("TextLabel", {
        Size=UDim2.new(1,-12,1,0), Position=UDim2.new(0,12,0,0),
        BackgroundTransparency=1, Text=name,
        Font=Enum.Font.Gotham, TextSize=14,
        TextColor3=C.TxtTabOff, TextXAlignment=Enum.TextXAlignment.Left, Parent=TBtn,
    })
    local BtnClick = New("TextButton", {Size=UDim2.new(1,0,1,0),
        BackgroundTransparency=1, Text="", Parent=TBtn})
    TabBtns[name] = {Lbl=Lbl, Ind=Ind, Abg=Abg}

    -- Bu tab'ın scroll'u
    local Scr = New("ScrollingFrame", {
        Size=UDim2.new(1,0,1,-30), Position=UDim2.new(0,0,0,30),
        BackgroundTransparency=1,
        ScrollBarThickness=3, ScrollBarImageColor3=C.Border,
        BorderSizePixel=0,
        CanvasSize=UDim2.new(0,0,0,0),
        AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Visible=false, Parent=Panel,
    }, { New("UIListLayout", {FillDirection=Enum.FillDirection.Vertical, SortOrder=Enum.SortOrder.LayoutOrder}) })

    BtnClick.MouseButton1Click:Connect(function() SwitchTo(name, Scr) end)
    BtnClick.MouseEnter:Connect(function()
        if not Ind.Visible then Tw(Lbl, {TextColor3=C.White}, .1) end
    end)
    BtnClick.MouseLeave:Connect(function()
        if not Ind.Visible then Tw(Lbl, {TextColor3=C.TxtTabOff}, .1) end
    end)

    -- İlk tab'ı seç
    if TabOrder == 1 then SwitchTo(name, Scr) end

    -- Tab objesi
    local Tab = {}
    local itemOrder = 0

    -- SECTION
    function Tab:AddSection(label)
        itemOrder += 1
        local F = New("Frame", {Size=UDim2.new(1,0,0,22), BackgroundTransparency=1,
            LayoutOrder=itemOrder, Parent=Scr})
        New("Frame", {Size=UDim2.new(1,0,0,1), BackgroundColor3=C.Divider,
            BorderSizePixel=0, Parent=F})
        New("TextLabel", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
            Text=label, Font=Enum.Font.GothamBold, TextSize=12,
            TextColor3=C.Accent, Parent=F})
    end

    -- TOGGLE
    function Tab:AddToggle(id, opts)
        opts = opts or {}
        local ttl  = opts.Title   or id
        local desc = opts.Desc    or nil
        local val  = opts.Default or false
        local cbs  = {}
        itemOrder += 1

        local hd = desc ~= nil
        local rh = hd and 52 or 36
        local Row = New("Frame", {Size=UDim2.new(1,0,0,rh), BackgroundTransparency=1,
            LayoutOrder=itemOrder, Parent=Scr})
        New("Frame", {Size=UDim2.new(1,0,0,1), BackgroundColor3=C.Divider,
            BorderSizePixel=0, Parent=Row})
        New("TextLabel", {
            Size=UDim2.new(1,-50,0,18), Position=UDim2.new(0,14,0, hd and 7 or 9),
            BackgroundTransparency=1, Text=ttl,
            Font=Enum.Font.GothamBold, TextSize=13,
            TextColor3=C.TxtMain, TextXAlignment=Enum.TextXAlignment.Left, Parent=Row,
        })
        if hd then
            New("TextLabel", {
                Size=UDim2.new(1,-50,0,14), Position=UDim2.new(0,14,0,26),
                BackgroundTransparency=1, Text=desc,
                Font=Enum.Font.Gotham, TextSize=10.5,
                TextColor3=C.TxtSub, TextXAlignment=Enum.TextXAlignment.Left,
                TextWrapped=true, Parent=Row,
            })
        end
        local ChkBg = New("Frame", {
            Size=UDim2.new(0,16,0,16), Position=UDim2.new(1,-30,0, hd and 18 or 10),
            BackgroundColor3=C.BgMain, BorderSizePixel=0, Parent=Row,
        }, {
            New("UICorner", {CornerRadius=UDim.new(0,3)}),
            New("UIStroke", {Color=C.ChkBorder, Thickness=1.5}),
        })
        local Tick = New("Frame", {
            Size=UDim2.new(0,8,0,8), Position=UDim2.new(0.5,-4,0.5,-4),
            BackgroundColor3=C.Accent, BorderSizePixel=0, Visible=val, Parent=ChkBg,
        }, { New("UICorner", {CornerRadius=UDim.new(0,2)}) })
        local Str = ChkBg:FindFirstChildOfClass("UIStroke")

        local function Upd()
            Tick.Visible = val
            Tw(Str, {Color = val and C.Accent or C.ChkBorder}, .12)
            Tw(ChkBg, {BackgroundColor3 = val and C.ChkBg or C.BgMain}, .12)
            for _, cb in ipairs(cbs) do cb(val) end
        end
        Upd()

        local Btn = New("TextButton", {Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1, Text="", Parent=Row})
        Btn.MouseButton1Click:Connect(function() val = not val; Upd() end)
        Btn.MouseEnter:Connect(function() Tw(Row, {BackgroundColor3=C.BgRowHov}, .1); Row.BackgroundTransparency=0 end)
        Btn.MouseLeave:Connect(function() Row.BackgroundTransparency=1 end)

        local T = {}
        function T:OnChanged(fn) table.insert(cbs, fn) end
        function T:Set(v) val=v; Upd() end
        function T:Get() return val end
        return T
    end

    -- SLIDER
    function Tab:AddSlider(id, opts)
        opts = opts or {}
        local ttl = opts.Title   or id
        local min = opts.Min     or 0
        local max = opts.Max     or 100
        local val = math.clamp(opts.Default or min, min, max)
        local cbs = {}
        itemOrder += 1

        local Row = New("Frame", {Size=UDim2.new(1,0,0,54), BackgroundTransparency=1,
            LayoutOrder=itemOrder, Parent=Scr})
        New("Frame", {Size=UDim2.new(1,0,0,1), BackgroundColor3=C.Divider,
            BorderSizePixel=0, Parent=Row})
        New("TextLabel", {
            Size=UDim2.new(1,-70,0,16), Position=UDim2.new(0,14,0,8),
            BackgroundTransparency=1, Text=ttl,
            Font=Enum.Font.GothamBold, TextSize=13,
            TextColor3=C.TxtMain, TextXAlignment=Enum.TextXAlignment.Left, Parent=Row,
        })
        local VBox = New("Frame", {Size=UDim2.new(0,50,0,16), Position=UDim2.new(1,-62,0,9),
            BackgroundColor3=C.BgRowHov, BorderSizePixel=0, Parent=Row,
        }, { New("UICorner", {CornerRadius=UDim.new(0,3)}) })
        local VLbl = New("TextLabel", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
            Text=tostring(val), Font=Enum.Font.Gotham, TextSize=11,
            TextColor3=C.TxtSub, Parent=VBox})

        local Track = New("Frame", {
            Size=UDim2.new(1,-28,0,5), Position=UDim2.new(0,14,0,36),
            BackgroundColor3=C.SliderBg, BorderSizePixel=0, Parent=Row,
        }, { New("UICorner", {CornerRadius=UDim.new(1,0)}) })

        local pct = (val-min)/(max-min)
        local Fill = New("Frame", {Size=UDim2.new(pct,0,1,0),
            BackgroundColor3=C.SliderFill, BorderSizePixel=0, Parent=Track,
        }, { New("UICorner", {CornerRadius=UDim.new(1,0)}) })
        local Knob = New("Frame", {
            Size=UDim2.new(0,10,0,10), AnchorPoint=Vector2.new(0.5,0.5),
            Position=UDim2.new(pct,0,0.5,0),
            BackgroundColor3=C.White, BorderSizePixel=0, Parent=Track,
        }, { New("UICorner", {CornerRadius=UDim.new(1,0)}) })

        local sliding = false
        local function UpdateSlider(xPos)
            local rel = math.clamp((xPos - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
            val = math.floor(min + rel*(max-min))
            VLbl.Text = tostring(val)
            Fill.Size = UDim2.new(rel,0,1,0)
            Knob.Position = UDim2.new(rel,0,0.5,0)
            for _, cb in ipairs(cbs) do cb(val) end
        end

        local SBtn = New("TextButton", {Size=UDim2.new(1,0,0,22), Position=UDim2.new(0,0,0,30),
            BackgroundTransparency=1, Text="", Parent=Row})
        SBtn.MouseButton1Down:Connect(function() sliding=true; UpdateSlider(Mouse.X) end)
        UserInputService.InputChanged:Connect(function(i)
            if sliding and i.UserInputType==Enum.UserInputType.MouseMovement then UpdateSlider(i.Position.X) end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then sliding=false end
        end)

        local S = {}
        function S:OnChanged(fn) table.insert(cbs, fn) end
        function S:Set(v)
            val=math.clamp(v,min,max)
            local r=(val-min)/(max-min)
            VLbl.Text=tostring(val); Fill.Size=UDim2.new(r,0,1,0); Knob.Position=UDim2.new(r,0,0.5,0)
            for _,cb in ipairs(cbs) do cb(val) end
        end
        function S:Get() return val end
        return S
    end

    -- INPUT
    function Tab:AddInput(id, opts)
        opts = opts or {}
        local ttl = opts.Title   or id
        local val = opts.Default or ""
        local cbs = {}
        itemOrder += 1

        local Row = New("Frame", {Size=UDim2.new(1,0,0,54), BackgroundTransparency=1,
            LayoutOrder=itemOrder, Parent=Scr})
        New("Frame", {Size=UDim2.new(1,0,0,1), BackgroundColor3=C.Divider,
            BorderSizePixel=0, Parent=Row})
        New("TextLabel", {
            Size=UDim2.new(1,-20,0,16), Position=UDim2.new(0,14,0,6),
            BackgroundTransparency=1, Text=ttl,
            Font=Enum.Font.GothamBold, TextSize=13,
            TextColor3=C.TxtMain, TextXAlignment=Enum.TextXAlignment.Left, Parent=Row,
        })
        local IBg = New("Frame", {
            Size=UDim2.new(1,-28,0,22), Position=UDim2.new(0,14,0,26),
            BackgroundColor3=C.InputBg, BorderSizePixel=0, Parent=Row,
        }, {
            New("UICorner", {CornerRadius=UDim.new(0,4)}),
            New("UIStroke", {Color=C.InputBord, Thickness=1}),
        })
        local TB = New("TextBox", {
            Size=UDim2.new(1,-12,1,0), Position=UDim2.new(0,6,0,0),
            BackgroundTransparency=1, Text=val,
            Font=Enum.Font.Gotham, TextSize=12, TextColor3=C.TxtMain,
            PlaceholderText="", PlaceholderColor3=C.TxtMuted,
            TextXAlignment=Enum.TextXAlignment.Left,
            ClearTextOnFocus=false, Parent=IBg,
        })
        local Str = IBg:FindFirstChildOfClass("UIStroke")
        TB.Focused:Connect(function() Tw(Str, {Color=C.Accent}, .14) end)
        TB.FocusLost:Connect(function()
            val=TB.Text; Tw(Str, {Color=C.InputBord}, .14)
            for _, cb in ipairs(cbs) do cb(val) end
        end)

        local I = {}
        function I:OnChanged(fn) table.insert(cbs, fn) end
        function I:Set(v) val=v; TB.Text=v end
        function I:Get() return val end
        return I
    end

    -- BUTTON
    function Tab:AddButton(id, opts)
        opts = opts or {}
        local ttl = opts.Title    or id
        local desc = opts.Desc    or nil
        local cb  = opts.Callback or function() end
        itemOrder += 1

        local hd = desc ~= nil
        local rh = hd and 52 or 36
        local Row = New("Frame", {Size=UDim2.new(1,0,0,rh), BackgroundTransparency=1,
            LayoutOrder=itemOrder, Parent=Scr})
        New("Frame", {Size=UDim2.new(1,0,0,1), BackgroundColor3=C.Divider,
            BorderSizePixel=0, Parent=Row})

        local BF = New("Frame", {
            Size=UDim2.new(1,-28,0,rh-14), Position=UDim2.new(0,14,0,7),
            BackgroundColor3=C.BtnBg, BorderSizePixel=0, Parent=Row,
        }, {
            New("UICorner", {CornerRadius=UDim.new(0,5)}),
            New("UIStroke", {Color=C.BtnBord, Thickness=1}),
        })
        New("TextLabel", {
            Size=UDim2.new(1,-12,0, hd and 18 or rh-14),
            Position=UDim2.new(0,10,0, hd and 4 or 0),
            BackgroundTransparency=1, Text=ttl,
            Font=Enum.Font.GothamBold, TextSize=13,
            TextColor3=C.TxtMain, TextXAlignment=Enum.TextXAlignment.Left, Parent=BF,
        })
        if hd then
            New("TextLabel", {
                Size=UDim2.new(1,-12,0,13), Position=UDim2.new(0,10,0,22),
                BackgroundTransparency=1, Text=desc,
                Font=Enum.Font.Gotham, TextSize=10.5,
                TextColor3=C.TxtSub, TextXAlignment=Enum.TextXAlignment.Left,
                TextWrapped=true, Parent=BF,
            })
        end
        local BtnClick = New("TextButton", {Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1, Text="", Parent=BF})
        BtnClick.MouseButton1Click:Connect(function()
            Tw(BF, {BackgroundColor3=C.Accent}, .08)
            task.delay(.15, function() Tw(BF, {BackgroundColor3=C.BtnBg}, .12) end)
            cb()
        end)
        BtnClick.MouseEnter:Connect(function() Tw(BF, {BackgroundColor3=C.BtnHov}, .1) end)
        BtnClick.MouseLeave:Connect(function() Tw(BF, {BackgroundColor3=C.BtnBg}, .1) end)

        local B = {}
        function B:SetCallback(fn) cb=fn end
        return B
    end

    -- DROPDOWN
    function Tab:AddDropdown(id, opts)
        opts = opts or {}
        local ttl  = opts.Title   or id
        local ops  = opts.Options or {}
        local val  = opts.Default or (ops[1] or "")
        local cbs  = {}
        itemOrder += 1

        local Row = New("Frame", {Size=UDim2.new(1,0,0,36), BackgroundTransparency=1,
            LayoutOrder=itemOrder, Parent=Scr})
        New("Frame", {Size=UDim2.new(1,0,0,1), BackgroundColor3=C.Divider,
            BorderSizePixel=0, Parent=Row})
        local SelLbl = New("TextLabel", {
            Size=UDim2.new(1,-36,1,0), Position=UDim2.new(0,14,0,0),
            BackgroundTransparency=1, Text=ttl..": "..tostring(val),
            Font=Enum.Font.GothamBold, TextSize=13,
            TextColor3=C.TxtMain, TextXAlignment=Enum.TextXAlignment.Left, Parent=Row,
        })
        New("TextLabel", {Size=UDim2.new(0,20,1,0), Position=UDim2.new(1,-24,0,0),
            BackgroundTransparency=1, Text="›", Font=Enum.Font.GothamBold,
            TextSize=20, TextColor3=C.TxtMuted, Parent=Row})
        local BtnClick = New("TextButton", {Size=UDim2.new(1,0,1,0),
            BackgroundTransparency=1, Text="", Parent=Row})
        BtnClick.MouseEnter:Connect(function() Tw(Row, {BackgroundColor3=C.BgRowHov}, .1); Row.BackgroundTransparency=0 end)
        BtnClick.MouseLeave:Connect(function() Row.BackgroundTransparency=1 end)

        local D = {}
        function D:OnChanged(fn) table.insert(cbs, fn) end
        function D:Set(v) val=v; SelLbl.Text=ttl..": "..tostring(v); for _,cb in ipairs(cbs) do cb(v) end end
        function D:Get() return val end
        BtnClick.MouseButton1Click:Connect(function()
            if #ops == 0 then return end
            local idx=1
            for i,op in ipairs(ops) do if op==val then idx=i break end end
            D:Set(ops[(idx%#ops)+1])
        end)
        return D
    end

    return Tab
end

-- ══════════════════════════════════════
-- HAZIR TABLAR VE İTEMLAR
-- (Bunları istediğin gibi düzenle)
-- ══════════════════════════════════════
local Tabs = {
    Main   = AddTab("Main"),
    Esp    = AddTab("Esp"),
    Combat = AddTab("Combat"),
    Farm   = AddTab("Farm"),
    Misc   = AddTab("Misc"),
    Config = AddTab("Config"),
}

-- ── MAIN ──────────────────────────────
local AutoJoinPs = Tabs.Main:AddToggle("AutoJoinPs", {
    Title = "Auto Join PS", Desc = "Enable whether to auto join ps or not", Default = false,
})
AutoJoinPs:OnChanged(function(Value)
    -- buraya kodu yaz
    print("Auto Join PS:", Value)
end)

local AutoRejoin = Tabs.Main:AddToggle("AutoRejoin", {
    Title = "Auto Rejoin", Desc = "Auto Rejoins When Kicked", Default = false,
})
AutoRejoin:OnChanged(function(Value)
    print("Auto Rejoin:", Value)
end)

local ServerCode = Tabs.Main:AddInput("ServerCode", {
    Title = "Private Server Code", Default = "",
})
ServerCode:OnChanged(function(Value)
    print("Server Code:", Value)
end)

Tabs.Main:AddSection("Races")

local RaceReroll = Tabs.Main:AddToggle("RaceReroll", {
    Title = "Race Reroll", Desc = "Enable or disable race reroll", Default = true,
})
RaceReroll:OnChanged(function(Value)
    print("Race Reroll:", Value)
end)

Tabs.Main:AddSection("Speed")

local SpeedToggle = Tabs.Main:AddToggle("Speed", {
    Title = "Speed", Desc = "Increases your velocity", Default = false,
})
SpeedToggle:OnChanged(function(Value)
    -- Örnek: LocalPlayer.Character.Humanoid.WalkSpeed = Value and SpeedBoost:Get() or 16
    print("Speed:", Value)
end)

local SpeedBoost = Tabs.Main:AddSlider("SpeedBoost", {
    Title = "Speed Boost", Min = 0, Max = 500, Default = 50,
})
SpeedBoost:OnChanged(function(Value)
    print("Speed Boost:", Value)
end)

-- ── ESP ───────────────────────────────
local PlayerESP = Tabs.Esp:AddToggle("PlayerESP", {
    Title = "Player ESP", Desc = "Shows players through walls", Default = false,
})
PlayerESP:OnChanged(function(Value)
    print("Player ESP:", Value)
end)

local ChestESP = Tabs.Esp:AddToggle("ChestESP", {
    Title = "Chest ESP", Desc = "Highlights chests on map", Default = false,
})
ChestESP:OnChanged(function(Value)
    print("Chest ESP:", Value)
end)

local NPCSESP = Tabs.Esp:AddToggle("NPCSESP", {
    Title = "NPC ESP", Desc = "Shows all NPCs", Default = false,
})
NPCSESP:OnChanged(function(Value)
    print("NPC ESP:", Value)
end)

local ESPRange = Tabs.Esp:AddSlider("ESPRange", {
    Title = "ESP Range", Min = 0, Max = 1000, Default = 200,
})
ESPRange:OnChanged(function(Value)
    print("ESP Range:", Value)
end)

-- ── COMBAT ────────────────────────────
local AutoParry = Tabs.Combat:AddToggle("AutoParry", {
    Title = "Auto Parry", Desc = "Automatically parries attacks", Default = false,
})
AutoParry:OnChanged(function(Value)
    print("Auto Parry:", Value)
end)

local AutoDodge = Tabs.Combat:AddToggle("AutoDodge", {
    Title = "Auto Dodge", Desc = "Automatically dodges attacks", Default = false,
})
AutoDodge:OnChanged(function(Value)
    print("Auto Dodge:", Value)
end)

local AttackSpeed = Tabs.Combat:AddSlider("AttackSpeed", {
    Title = "Attack Speed", Min = 0, Max = 100, Default = 30,
})
AttackSpeed:OnChanged(function(Value)
    print("Attack Speed:", Value)
end)

-- ── FARM ──────────────────────────────
Tabs.Farm:AddSection("Level Farm")

local LvlFarmFishmen = Tabs.Farm:AddToggle("LvlFarmFishmen", {
    Title = "Level Farm Fishmen", Desc = "Farms levels using the fishmen method", Default = true,
})
LvlFarmFishmen:OnChanged(function(Value)
    print("Level Farm Fishmen:", Value)
end)

local LvlFarmNormal = Tabs.Farm:AddToggle("LvlFarmNormal", {
    Title = "Level Farm Normal", Desc = "A more Orthodox method of level farming", Default = false,
})
LvlFarmNormal:OnChanged(function(Value)
    print("Level Farm Normal:", Value)
end)

local LvlFarmBest = Tabs.Farm:AddToggle("LvlFarmBest", {
    Title = "Level Farm (BEST)", Desc = "Farms levels using the anticheat bypass method", Default = false,
})
LvlFarmBest:OnChanged(function(Value)
    print("Level Farm Best:", Value)
end)

Tabs.Farm:AddSection("Halloween Farm")

local AutoFarmH = Tabs.Farm:AddToggle("AutoFarmHalloween", {
    Title = "Auto Farm Halloween", Desc = "Auto Knocks on doors to farm candy (fully automatic)", Default = false,
})
AutoFarmH:OnChanged(function(Value)
    print("Auto Farm Halloween:", Value)
end)

local AutoFarmHB = Tabs.Farm:AddToggle("AutoFarmHalloweenBetter", {
    Title = "Auto Farm Halloween (Better)", Desc = "Same as the previous one but improved with anticheat bypass", Default = false,
})
AutoFarmHB:OnChanged(function(Value)
    print("Auto Farm Halloween Better:", Value)
end)

-- ── MISC ──────────────────────────────
local NoClip = Tabs.Misc:AddToggle("NoClip", {
    Title = "No Clip", Desc = "Walk through walls", Default = false,
})
NoClip:OnChanged(function(Value)
    print("No Clip:", Value)
end)

local InfJump = Tabs.Misc:AddToggle("InfiniteJump", {
    Title = "Infinite Jump", Desc = "Jump infinitely", Default = false,
})
InfJump:OnChanged(function(Value)
    if Value then
        _G.InfJumpConn = UserInputService.JumpRequest:Connect(function()
            pcall(function() LocalPlayer.Character.Humanoid:ChangeState("Jumping") end)
        end)
    else
        if _G.InfJumpConn then _G.InfJumpConn:Disconnect() end
    end
end)

local AntiAFK = Tabs.Misc:AddToggle("AntiAFK", {
    Title = "Anti AFK", Desc = "Prevents AFK kick", Default = false,
})
AntiAFK:OnChanged(function(Value)
    print("Anti AFK:", Value)
end)

local Gravity = Tabs.Misc:AddSlider("Gravity", {
    Title = "Gravity", Min = 0, Max = 100, Default = 35,
})
Gravity:OnChanged(function(Value)
    workspace.Gravity = Value
end)

-- ── CONFIG ────────────────────────────
local KeybindToggle = Tabs.Config:AddToggle("KeybindToggle", {
    Title = "Keybind Toggle", Desc = "Enable keybind to open/close menu", Default = false,
})
KeybindToggle:OnChanged(function(Value)
    print("Keybind Toggle:", Value)
end)

local ConfigName = Tabs.Config:AddInput("ConfigName", {
    Title = "Config Name", Default = "",
})
ConfigName:OnChanged(function(Value)
    print("Config Name:", Value)
end)

local AutoSave = Tabs.Config:AddToggle("AutoSaveConfig", {
    Title = "Auto Save Config", Desc = "Saves config automatically", Default = false,
})
AutoSave:OnChanged(function(Value)
    print("Auto Save Config:", Value)
end)

-- ══════════════════════════════════════
-- KLAVYE  (RightShift = aç/kapat)
-- ══════════════════════════════════════
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        GUI.Enabled = not GUI.Enabled
    end
end)

-- ══════════════════════════════════════
-- AÇILIŞ ANİMASYONU
-- ══════════════════════════════════════
Main.Size = UDim2.new(0,W,0,0)
Main.Position = UDim2.new(0.5,-W/2,0.5,0)
Tw(Main, {Size=UDim2.new(0,W,0,H), Position=UDim2.new(0.5,-W/2,0.5,-H/2)}, .22)

print("[Feral] Yuklendi! RightShift = ac/kapat.")

-- Dışarıdan erişim için (isteğe bağlı)
return {
    Tabs = Tabs,
    GUI  = GUI,
}
