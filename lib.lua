-- ════════════════════════════════════════════════════════════════
--   FERAL UI LIBRARY (TRANSPARAN SİYAH EDİSYON)
-- ════════════════════════════════════════════════════════════════

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer
local Mouse            = LocalPlayer:GetMouse()

local C = {
    -- Ana renkler: Transparan Siyah Tema
    BgMain     = Color3.fromRGB(0, 0, 0),       -- Saf Siyah
    BgMainT    = 0.35,                          -- Transparanlık (Arkayı görmeni sağlar)
    BgRowHov   = Color3.fromRGB(40, 40, 40),
    Sidebar    = Color3.fromRGB(5, 5, 5),
    SidebarT   = 0.4,                           -- Sidebar biraz daha transparan
    Header     = Color3.fromRGB(0, 0, 0),       -- Üst kısım tam siyah
    HeaderT    = 0.2,                           -- Üst kısım hafif transparan
    Border     = Color3.fromRGB(60, 60, 60),    -- Belirgin gri border
    Accent     = Color3.fromRGB(74, 144, 255),  -- Mavi vurgu rengi
    TxtMain    = Color3.fromRGB(255, 255, 255),
    TxtSub     = Color3.fromRGB(180, 180, 180),
    TxtMuted   = Color3.fromRGB(100, 100, 100),
    TxtTab     = Color3.fromRGB(255, 255, 255),
    TxtTabOff  = Color3.fromRGB(140, 140, 140),
    ChkBg      = Color3.fromRGB(25, 25, 25),
    ChkBorder  = Color3.fromRGB(80, 80, 80),
    SliderBg   = Color3.fromRGB(40, 40, 40),
    SliderFill = Color3.fromRGB(74, 144, 255),
    InputBg    = Color3.fromRGB(10, 10, 10),
    InputBord  = Color3.fromRGB(70, 70, 70),
    BtnBg      = Color3.fromRGB(30, 30, 30),
    BtnBord    = Color3.fromRGB(75, 75, 75),
    BtnHov     = Color3.fromRGB(50, 50, 50),
    Divider    = Color3.fromRGB(50, 50, 50),
    White      = Color3.fromRGB(255, 255, 255),
    LoadingBar = Color3.fromRGB(74, 144, 255),
    LoadingBg  = Color3.fromRGB(40, 40, 40),
    PanelBg    = Color3.fromRGB(0, 0, 0),
    PanelT     = 0.45,
}

local function New(cls, props, kids)
    local o = Instance.new(cls)
    for k,v in pairs(props or {}) do if k~="Parent" then o[k]=v end end
    for _,c in ipairs(kids or {}) do c.Parent=o end
    if props and props.Parent then o.Parent=props.Parent end
    return o
end

local function Tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or .14, Enum.EasingStyle.Quad), props):Play()
end

local function Drag(frame, handle)
    local drag, di, mp, fp = false
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            drag=true; mp=i.Position; fp=frame.Position
            i.Changed:Connect(function()
                if i.UserInputState==Enum.UserInputState.End then drag=false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseMovement then di=i end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if i==di and drag then
            local d=i.Position-mp
            frame.Position=UDim2.new(fp.X.Scale,fp.X.Offset+d.X,fp.Y.Scale,fp.Y.Offset+d.Y)
        end
    end)
end

-- ══════════════════════════════════════
-- LOADING SCREEN (SİYAH & TRANSPARAN)
-- ══════════════════════════════════════
local function ShowLoadingScreen(gui, callback)
    local LoadFrame = New("Frame", {
        Name = "LoadingScreen",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.2, -- Hafif transparan siyah
        ZIndex = 100,
        Parent = gui,
    })

    -- Üst Siyah Bölüm (Header)
    local TopBlackBar = New("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0, -- Tam siyah
        BorderSizePixel = 0,
        ZIndex = 101,
        Parent = LoadFrame,
    })

    local UserLabel = New("TextLabel", {
        Size = UDim2.new(0, 200, 0, 20),
        Position = UDim2.new(0.5, -100, 0.5, -85),
        BackgroundTransparency = 1,
        Text = "WELCOME, " .. LocalPlayer.Name:upper(),
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextColor3 = C.Accent,
        ZIndex = 102,
        Parent = LoadFrame,
    })

    -- FERAL Yazısı
    local letters = {"F", "E", "R", "A", "L"}
    local letterLabels = {}
    local totalWidth = #letters * 60
    local startX = -totalWidth / 2

    local LetterContainer = New("Frame", {
        Size = UDim2.new(0, totalWidth, 0, 80),
        Position = UDim2.new(0.5, startX, 0.5, -40),
        BackgroundTransparency = 1,
        ZIndex = 102,
        Parent = LoadFrame,
    })

    for i, letter in ipairs(letters) do
        local lbl = New("TextLabel", {
            Size = UDim2.new(0, 55, 0, 80),
            Position = UDim2.new(0, (i - 1) * 60, 0, 0),
            BackgroundTransparency = 1,
            Text = letter,
            Font = Enum.Font.GothamBold,
            TextSize = 65,
            TextColor3 = C.White,
            ZIndex = 103,
            Parent = LetterContainer,
        })
        table.insert(letterLabels, lbl)
    end

    local BarBg = New("Frame", {
        Size = UDim2.new(0, 280, 0, 3),
        Position = UDim2.new(0.5, -140, 0.5, 65),
        BackgroundColor3 = C.LoadingBg,
        BorderSizePixel = 0,
        ZIndex = 102,
        Parent = LoadFrame,
    })

    local BarFill = New("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = C.LoadingBar,
        BorderSizePixel = 0,
        ZIndex = 103,
        Parent = BarBg,
    })

    local StatusLabel = New("TextLabel", {
        Size = UDim2.new(0, 280, 0, 20),
        Position = UDim2.new(0.5, -140, 0.5, 80),
        BackgroundTransparency = 1,
        Text = "LOADING ASSETS...",
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextColor3 = C.TxtMuted,
        ZIndex = 102,
        Parent = LoadFrame,
    })

    -- Bounce Animasyonu (Daha akıcı)
    local bounceConn
    local startTime = tick()
    bounceConn = RunService.RenderStepped:Connect(function()
        local t = tick() - startTime
        for i, lbl in ipairs(letterLabels) do
            local offset = math.sin((t * 3.5) + (i * 0.8)) * 14
            lbl.Position = UDim2.new(0, (i - 1) * 60, 0, offset)
        end
    end)

    task.spawn(function()
        local stages = {"INITIALIZING...", "FERAL SYSTEM...", "READY!"}
        for i, stage in ipairs(stages) do
            StatusLabel.Text = stage
            Tw(BarFill, {Size = UDim2.new(i/#stages, 0, 1, 0)}, 0.4)
            task.wait(0.8)
        end
        
        if bounceConn then bounceConn:Disconnect() end
        Tw(LoadFrame, {BackgroundTransparency = 1}, 0.5)
        for _, v in pairs(LoadFrame:GetDescendants()) do
            if v:IsA("TextLabel") then Tw(v, {TextTransparency = 1}, 0.3)
            elseif v:IsA("Frame") then Tw(v, {BackgroundTransparency = 1}, 0.3) end
        end
        task.wait(0.5)
        LoadFrame:Destroy()
        if callback then callback() end
    end)
end

-- ══════════════════════════════════════
-- MAIN LIBRARY START
-- ══════════════════════════════════════
local Feral = {}

function Feral:CreateWindow(cfg)
    cfg = cfg or {}
    local title = cfg.Title  or "FERAL"
    local game_ = cfg.Game   or "UNIVERSAL"
    local W, H = cfg.Width or 640, cfg.Height or 390
    
    local GUI = New("ScreenGui", {Name="FeralMenu", Parent=game.CoreGui, DisplayOrder=999})
    
    local Main = New("Frame", {
        Size=UDim2.new(0,W,0,H),
        Position=UDim2.new(0.5,-W/2,0.5,-H/2),
        BackgroundColor3=C.BgMain,
        BackgroundTransparency=C.BgMainT,
        BorderSizePixel=0, Visible=false, Parent=GUI,
    },{
        New("UICorner",{CornerRadius=UDim.new(0,10)}),
        New("UIStroke",{Color=C.Border,Thickness=1.2,Transparency=0.3}),
    })

    -- HEADER (Tam Siyah Üst Kısım)
    local Hdr = New("Frame",{
        Size=UDim2.new(1,0,0,42),
        BackgroundColor3=C.Header,
        BackgroundTransparency=C.HeaderT,
        BorderSizePixel=0, ZIndex=3, Parent=Main,
    },{New("UICorner",{CornerRadius=UDim.new(0,10)})})
    
    -- Alttaki köşelerin kavisini kapatmak için düzleştirici frame
    New("Frame",{Size=UDim2.new(1,0,0.5,0),Position=UDim2.new(0,0,0.5,0),
        BackgroundColor3=C.Header,BackgroundTransparency=C.HeaderT,BorderSizePixel=0,ZIndex=3,Parent=Hdr})

    New("TextLabel",{
        Size=UDim2.new(0,100,1,0), Position=UDim2.new(0,18,0,0),
        BackgroundTransparency=1, Text=title, Font=Enum.Font.GothamBold,
        TextSize=16, TextColor3=C.White, TextXAlignment=Enum.TextXAlignment.Left, ZIndex=4, Parent=Hdr
    })

    local ClsBtn=New("TextButton",{Size=UDim2.new(0,28,0,28),Position=UDim2.new(1,-32,0,7),
        BackgroundTransparency=1,Text="✕",TextSize=14,Font=Enum.Font.GothamBold,
        TextColor3=Color3.fromRGB(255,100,100),ZIndex=4,Parent=Hdr})

    ClsBtn.MouseButton1Click:Connect(function()
        Tw(Main,{Size=UDim2.new(0,W,0,0),BackgroundTransparency=1},.2)
        task.delay(.2,function() GUI:Destroy() end)
    end)

    local Body = New("Frame",{
        Size=UDim2.new(1,0,1,-42), Position=UDim2.new(0,0,0,42),
        BackgroundTransparency=1, Parent=Main,
    })

    -- SIDEBAR
    local SB = New("Frame",{
        Size=UDim2.new(0,135,1,0),
        BackgroundColor3=C.Sidebar, BackgroundTransparency=C.SidebarT, BorderSizePixel=0, Parent=Body,
    },{New("UIStroke",{Color=C.Border,Thickness=1,Transparency=0.5})})

    local TabList = New("Frame",{
        Size=UDim2.new(1,0,1,-10), Position=UDim2.new(0,0,0,8),
        BackgroundTransparency=1, Parent=SB,
    },{New("UIListLayout",{FillDirection=Enum.FillDirection.Vertical,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,2)})})

    -- PANEL
    local Panel = New("Frame",{
        Size=UDim2.new(1,-135,1,0), Position=UDim2.new(0,135,0,0),
        BackgroundColor3=C.PanelBg, BackgroundTransparency=C.PanelT, BorderSizePixel=0, Parent=Body,
    })

    ShowLoadingScreen(GUI, function()
        Main.Visible = true
        Main.Size = UDim2.new(0, W, 0, 0)
        Tw(Main, {Size = UDim2.new(0, W, 0, H)}, .3)
    end)

    Drag(Main, Hdr)
    
    -- (Tab ve Buton ekleme mantığı devam eder...)
    return Feral
end

return Feral
