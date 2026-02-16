--[[
    Feral UI Library
    Roblox Menu Library
]]

local Feral = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

-- Renkler
local Colors = {
    Background = Color3.fromRGB(15, 15, 20),
    Sidebar = Color3.fromRGB(18, 18, 24),
    Divider = Color3.fromRGB(40, 40, 50),
    TabHover = Color3.fromRGB(30, 30, 40),
    TabActive = Color3.fromRGB(35, 35, 48),
    ContentBg = Color3.fromRGB(20, 20, 28),
    ElementBg = Color3.fromRGB(30, 30, 38),
    ElementBorder = Color3.fromRGB(45, 45, 55),
    TextPrimary = Color3.fromRGB(220, 220, 230),
    TextSecondary = Color3.fromRGB(140, 140, 160),
    Accent = Color3.fromRGB(80, 160, 255),
    SectionLabel = Color3.fromRGB(80, 160, 255),
    ToggleOn = Color3.fromRGB(80, 160, 255),
    ToggleOff = Color3.fromRGB(50, 50, 60),
    CheckMark = Color3.fromRGB(255, 255, 255),
    DropdownArrow = Color3.fromRGB(140, 140, 160),
    SliderFill = Color3.fromRGB(80, 160, 255),
    SliderBg = Color3.fromRGB(40, 40, 50),
}

local function Create(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then inst[k] = v end
    end
    if props.Parent then inst.Parent = props.Parent end
    return inst
end

local function Tween(obj, props, dur)
    TweenService:Create(obj, TweenInfo.new(dur or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function MakeCorner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 8), Parent = parent})
end

local function MakeStroke(parent, color, th)
    return Create("UIStroke", {Color = color or Colors.ElementBorder, Thickness = th or 1, Parent = parent})
end

local function MakePadding(parent, t, b, l, r)
    return Create("UIPadding", {
        PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or 0),
        PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or 0), Parent = parent
    })
end

function Feral:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "Feral"
    local SubTitle = config.SubTitle or "Game"
    local LogoId = config.LogoId or ""
    local ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl
    local WindowSize = config.Size or UDim2.new(0, 580, 0, 380)

    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "FeralUI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = (syn and syn.protect_gui and game:GetService("CoreGui")) or Player:WaitForChild("PlayerGui")
    })
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end end)

    -- Ana Frame
    local Main = Create("Frame", {
        Name = "Main", Size = WindowSize, Position = UDim2.new(0.5, -290, 0.5, -190),
        BackgroundColor3 = Colors.Background, BackgroundTransparency = 0.05, Parent = ScreenGui
    })
    MakeCorner(Main, 10)
    MakeStroke(Main, Colors.Divider, 1)

    -- Shadow
    local Shadow = Create("ImageLabel", {
        Name = "Shadow", Size = UDim2.new(1, 30, 1, 30), Position = UDim2.new(0, -15, 0, -15),
        BackgroundTransparency = 1, Image = "rbxassetid://6014261993", ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.5, ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450),
        Parent = Main
    })

    -- Sidebar
    local Sidebar = Create("Frame", {
        Name = "Sidebar", Size = UDim2.new(0, 130, 1, 0), Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Colors.Sidebar, BackgroundTransparency = 0.1, Parent = Main
    })
    MakeCorner(Sidebar, 10)
    -- Sağ köşeyi kapat
    local SidebarCover = Create("Frame", {
        Size = UDim2.new(0, 15, 1, 0), Position = UDim2.new(1, -15, 0, 0),
        BackgroundColor3 = Colors.Sidebar, BackgroundTransparency = 0.1, BorderSizePixel = 0, Parent = Sidebar
    })

    -- Sidebar Header (Logo + Title)
    local SidebarHeader = Create("Frame", {
        Name = "Header", Size = UDim2.new(1, 0, 0, 60), BackgroundTransparency = 1, Parent = Sidebar
    })

    if LogoId ~= "" then
        Create("ImageLabel", {
            Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(0, 12, 0.5, -15),
            BackgroundTransparency = 1, Image = LogoId, Parent = SidebarHeader
        })
    end

    Create("TextLabel", {
        Size = UDim2.new(1, -50, 0, 20), Position = UDim2.new(0, LogoId ~= "" and 48 or 12, 0, 10),
        BackgroundTransparency = 1, Text = Title, TextColor3 = Colors.Accent,
        Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SidebarHeader
    })

    Create("TextLabel", {
        Size = UDim2.new(1, -50, 0, 14), Position = UDim2.new(0, LogoId ~= "" and 48 or 12, 0, 32),
        BackgroundTransparency = 1, Text = SubTitle, TextColor3 = Colors.TextSecondary,
        Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = SidebarHeader
    })

    -- Sidebar divider
    Create("Frame", {
        Size = UDim2.new(1, -20, 0, 1), Position = UDim2.new(0, 10, 0, 58),
        BackgroundColor3 = Colors.Divider, BorderSizePixel = 0, Parent = Sidebar
    })

    -- Tab list
    local TabList = Create("ScrollingFrame", {
        Name = "TabList", Size = UDim2.new(1, 0, 1, -65), Position = UDim2.new(0, 0, 0, 62),
        BackgroundTransparency = 1, ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = Sidebar
    })
    Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = TabList})
    MakePadding(TabList, 4, 4, 6, 6)

    -- Sidebar-Content divider
    Create("Frame", {
        Size = UDim2.new(0, 1, 1, -10), Position = UDim2.new(0, 130, 0, 5),
        BackgroundColor3 = Colors.Divider, BorderSizePixel = 0, Parent = Main
    })

    -- Content Header
    local ContentHeader = Create("Frame", {
        Name = "ContentHeader", Size = UDim2.new(1, -135, 0, 45), Position = UDim2.new(0, 133, 0, 0),
        BackgroundTransparency = 1, Parent = Main
    })

    local TabTitle = Create("TextLabel", {
        Name = "TabTitle", Size = UDim2.new(1, -80, 1, 0), Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1, Text = "Main Tab", TextColor3 = Colors.TextPrimary,
        Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Center,
        Parent = ContentHeader
    })

    -- Settings icon (sağ üst)
    local SettingsBtn = Create("ImageButton", {
        Name = "Settings", Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(1, -30, 0.5, -10),
        BackgroundTransparency = 1, Image = "rbxassetid://7059346373", ImageColor3 = Colors.TextSecondary,
        Parent = ContentHeader
    })

    -- Search icon
    local SearchBtn = Create("ImageButton", {
        Name = "Search", Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(1, -58, 0.5, -9),
        BackgroundTransparency = 1, Image = "rbxassetid://7072706663", ImageColor3 = Colors.TextSecondary,
        Parent = ContentHeader
    })

    -- Content header divider
    Create("Frame", {
        Size = UDim2.new(1, -135, 0, 1), Position = UDim2.new(0, 133, 0, 44),
        BackgroundColor3 = Colors.Divider, BorderSizePixel = 0, Parent = Main
    })

    -- Content Area
    local ContentArea = Create("Frame", {
        Name = "ContentArea", Size = UDim2.new(1, -135, 1, -48), Position = UDim2.new(0, 133, 0, 46),
        BackgroundTransparency = 1, ClipsDescendants = true, Parent = Main
    })

    -- Drag
    local dragging, dragInput, dragStart, startPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = Main.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Toggle visibility
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == ToggleKey then
            Main.Visible = not Main.Visible
        end
    end)

    local Window = {Tabs = {}, ActiveTab = nil, Main = Main, ContentArea = ContentArea, TabTitle = TabTitle, TabList = TabList}

    function Window:CreateTab(tabConfig)
        tabConfig = tabConfig or {}
        local TabName = tabConfig.Name or "Tab"
        local TabIcon = tabConfig.Icon or ""

        -- Tab Button
        local TabBtn = Create("TextButton", {
            Name = TabName, Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Colors.TabHover, BackgroundTransparency = 1,
            Text = "", AutoButtonColor = false, Parent = TabList
        })
        MakeCorner(TabBtn, 6)

        -- Active indicator (sol kenar)
        local Indicator = Create("Frame", {
            Size = UDim2.new(0, 3, 0, 16), Position = UDim2.new(0, 0, 0.5, -8),
            BackgroundColor3 = Colors.Accent, BackgroundTransparency = 1, Parent = TabBtn
        })
        MakeCorner(Indicator, 2)

        if TabIcon ~= "" then
            Create("ImageLabel", {
                Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 10, 0.5, -8),
                BackgroundTransparency = 1, Image = TabIcon, ImageColor3 = Colors.TextSecondary, Parent = TabBtn
            })
        end

        Create("TextLabel", {
            Size = UDim2.new(1, -35, 1, 0), Position = UDim2.new(0, TabIcon ~= "" and 32 or 12, 0, 0),
            BackgroundTransparency = 1, Text = TabName, TextColor3 = Colors.TextSecondary,
            Font = Enum.Font.GothamSemibold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
            Parent = TabBtn
        })

        -- Tab Content
        local TabContent = Create("ScrollingFrame", {
            Name = TabName.."Content", Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1, ScrollBarThickness = 2, ScrollBarImageColor3 = Colors.Divider,
            CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible = false, Parent = ContentArea
        })
        Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = TabContent})
        MakePadding(TabContent, 8, 8, 12, 12)

        local Tab = {Name = TabName, Button = TabBtn, Content = TabContent, Indicator = Indicator, Elements = {}}

        -- Hover
        TabBtn.MouseEnter:Connect(function()
            if Window.ActiveTab ~= Tab then Tween(TabBtn, {BackgroundTransparency = 0.5}, 0.15) end
        end)
        TabBtn.MouseLeave:Connect(function()
            if Window.ActiveTab ~= Tab then Tween(TabBtn, {BackgroundTransparency = 1}, 0.15) end
        end)

        -- Click
        TabBtn.MouseButton1Click:Connect(function()
            Window:SelectTab(Tab)
        end)

        function Window:SelectTab(tab)
            if Window.ActiveTab then
                Window.ActiveTab.Content.Visible = false
                Tween(Window.ActiveTab.Button, {BackgroundTransparency = 1}, 0.15)
                Tween(Window.ActiveTab.Indicator, {BackgroundTransparency = 1}, 0.15)
                for _, c in pairs(Window.ActiveTab.Button:GetChildren()) do
                    if c:IsA("TextLabel") then Tween(c, {TextColor3 = Colors.TextSecondary}, 0.15) end
                end
            end
            Window.ActiveTab = tab
            tab.Content.Visible = true
            TabTitle.Text = tab.Name .. " Tab"
            Tween(tab.Button, {BackgroundTransparency = 0.3}, 0.15)
            Tween(tab.Indicator, {BackgroundTransparency = 0}, 0.15)
            for _, c in pairs(tab.Button:GetChildren()) do
                if c:IsA("TextLabel") then Tween(c, {TextColor3 = Colors.TextPrimary}, 0.15) end
            end
        end

        -- Section
        function Tab:CreateSection(name)
            local SectionFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, Parent = TabContent
            })
            Create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = name,
                TextColor3 = Colors.SectionLabel, Font = Enum.Font.GothamBold, TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Center, Parent = SectionFrame
            })
        end

        -- Toggle
        function Tab:CreateToggle(cfg)
            cfg = cfg or {}
            local toggled = cfg.Default or false
            local EL = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = Colors.ElementBg,
                BackgroundTransparency = 0.3, Parent = TabContent
            })
            MakeCorner(EL, 6)

            Create("TextLabel", {
                Size = UDim2.new(1, -60, 0, 18), Position = UDim2.new(0, 12, 0, 5),
                BackgroundTransparency = 1, Text = cfg.Name or "Toggle", TextColor3 = Colors.TextPrimary,
                Font = Enum.Font.GothamSemibold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = EL
            })
            if cfg.Description then
                Create("TextLabel", {
                    Size = UDim2.new(1, -60, 0, 12), Position = UDim2.new(0, 12, 0, 24),
                    BackgroundTransparency = 1, Text = cfg.Description, TextColor3 = Colors.TextSecondary,
                    Font = Enum.Font.Gotham, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = EL
                })
            end

            local Box = Create("Frame", {
                Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(1, -36, 0.5, -11),
                BackgroundColor3 = toggled and Colors.ToggleOn or Colors.ToggleOff, Parent = EL
            })
            MakeCorner(Box, 4)
            MakeStroke(Box, Colors.ElementBorder, 1)

            local Check = Create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                Text = toggled and "✓" or "", TextColor3 = Colors.CheckMark,
                Font = Enum.Font.GothamBold, TextSize = 14, Parent = Box
            })

            local Btn = Create("TextButton", {
                Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = EL
            })

            local ToggleObj = {Value = toggled}
            Btn.MouseButton1Click:Connect(function()
                toggled = not toggled
                ToggleObj.Value = toggled
                Tween(Box, {BackgroundColor3 = toggled and Colors.ToggleOn or Colors.ToggleOff}, 0.2)
                Check.Text = toggled and "✓" or ""
                if cfg.Callback then pcall(cfg.Callback, toggled) end
            end)

            function ToggleObj:Set(val)
                toggled = val; ToggleObj.Value = val
                Tween(Box, {BackgroundColor3 = toggled and Colors.ToggleOn or Colors.ToggleOff}, 0.2)
                Check.Text = toggled and "✓" or ""
                if cfg.Callback then pcall(cfg.Callback, toggled) end
            end
            table.insert(Tab.Elements, ToggleObj)
            return ToggleObj
        end

        -- TextBox
        function Tab:CreateTextBox(cfg)
            cfg = cfg or {}
            local EL = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 42), BackgroundColor3 = Colors.ElementBg,
                BackgroundTransparency = 0.3, Parent = TabContent
            })
            MakeCorner(EL, 6)

            Create("TextLabel", {
                Size = UDim2.new(0.45, 0, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1, Text = cfg.Name or "Input", TextColor3 = Colors.TextPrimary,
                Font = Enum.Font.GothamSemibold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = EL
            })

            local Input = Create("TextBox", {
                Size = UDim2.new(0.5, -20, 0, 26), Position = UDim2.new(0.5, 0, 0.5, -13),
                BackgroundColor3 = Colors.SliderBg, Text = "", PlaceholderText = cfg.Placeholder or "Enter...",
                TextColor3 = Colors.TextPrimary, PlaceholderColor3 = Colors.TextSecondary,
                Font = Enum.Font.Gotham, TextSize = 12, ClearTextOnFocus = false, Parent = EL
            })
            MakeCorner(Input, 4)

            Input.FocusLost:Connect(function(enter)
                if enter and cfg.Callback then pcall(cfg.Callback, Input.Text) end
            end)

            return {Instance = Input}
        end

        -- Dropdown
        function Tab:CreateDropdown(cfg)
            cfg = cfg or {}
            local opened = false
            local selected = cfg.Default or (cfg.Options and cfg.Options[1]) or ""

            local EL = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Colors.ElementBg,
                BackgroundTransparency = 0.3, ClipsDescendants = false, Parent = TabContent
            })
            MakeCorner(EL, 6)

            Create("TextLabel", {
                Size = UDim2.new(0.5, 0, 0, 38), Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1, Text = cfg.Name or "Dropdown", TextColor3 = Colors.TextPrimary,
                Font = Enum.Font.GothamSemibold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = EL
            })

            local SelBtn = Create("TextButton", {
                Size = UDim2.new(1, -8, 0, 30), Position = UDim2.new(0, 4, 0, 4),
                BackgroundTransparency = 1, Text = "", Parent = EL
            })

            local SelLabel = Create("TextLabel", {
                Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1, Text = selected, TextColor3 = Colors.TextSecondary,
                Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = SelBtn
            })

            local Arrow = Create("TextLabel", {
                Size = UDim2.new(0, 20, 1, 0), Position = UDim2.new(1, -24, 0, 0),
                BackgroundTransparency = 1, Text = "›", TextColor3 = Colors.DropdownArrow, Rotation = 90,
                Font = Enum.Font.GothamBold, TextSize = 18, Parent = SelBtn
            })

            local DropFrame = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 2),
                BackgroundColor3 = Colors.ElementBg, ClipsDescendants = true, Visible = false,
                ZIndex = 10, Parent = EL
            })
            MakeCorner(DropFrame, 6)
            MakeStroke(DropFrame, Colors.ElementBorder, 1)

            local DropList = Create("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1), Parent = DropFrame})
            MakePadding(DropFrame, 4, 4, 4, 4)

            local DropObj = {Value = selected}

            local function Refresh(options)
                for _, c in pairs(DropFrame:GetChildren()) do
                    if c:IsA("TextButton") then c:Destroy() end
                end
                for _, opt in ipairs(options) do
                    local OptBtn = Create("TextButton", {
                        Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = Colors.TabHover,
                        BackgroundTransparency = 0.5, Text = opt, TextColor3 = Colors.TextPrimary,
                        Font = Enum.Font.Gotham, TextSize = 12, ZIndex = 11, Parent = DropFrame
                    })
                    MakeCorner(OptBtn, 4)
                    OptBtn.MouseButton1Click:Connect(function()
                        selected = opt; DropObj.Value = opt; SelLabel.Text = opt
                        opened = false; DropFrame.Visible = false
                        Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
                        Tween(Arrow, {Rotation = 90}, 0.15)
                        if cfg.Callback then pcall(cfg.Callback, opt) end
                    end)
                end
            end

            if cfg.Options then Refresh(cfg.Options) end

            SelBtn.MouseButton1Click:Connect(function()
                opened = not opened
                if opened then
                    DropFrame.Visible = true
                    local h = (#(cfg.Options or {}) * 27) + 8
                    Tween(DropFrame, {Size = UDim2.new(1, 0, 0, math.min(h, 150))}, 0.2)
                    Tween(Arrow, {Rotation = -90}, 0.15)
                else
                    Tween(DropFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.15)
                    Tween(Arrow, {Rotation = 90}, 0.15)
                    task.delay(0.15, function() DropFrame.Visible = false end)
                end
            end)

            function DropObj:Set(val) selected = val; DropObj.Value = val; SelLabel.Text = val end
            function DropObj:Refresh(opts) cfg.Options = opts; Refresh(opts) end
            table.insert(Tab.Elements, DropObj)
            return DropObj
        end

        -- Button
        function Tab:CreateButton(cfg)
            cfg = cfg or {}
            local EL = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Colors.ElementBg,
                BackgroundTransparency = 0.3, Text = "", AutoButtonColor = false, Parent = TabContent
            })
            MakeCorner(EL, 6)

            Create("TextLabel", {
                Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 12, 0, 0),
                BackgroundTransparency = 1, Text = cfg.Name or "Button", TextColor3 = Colors.TextPrimary,
                Font = Enum.Font.GothamSemibold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = EL
            })

            EL.MouseEnter:Connect(function() Tween(EL, {BackgroundTransparency = 0.1}, 0.15) end)
            EL.MouseLeave:Connect(function() Tween(EL, {BackgroundTransparency = 0.3}, 0.15) end)
            EL.MouseButton1Click:Connect(function() if cfg.Callback then pcall(cfg.Callback) end end)
        end

        -- Slider
        function Tab:CreateSlider(cfg)
            cfg = cfg or {}
            local min = cfg.Min or 0
            local max = cfg.Max or 100
            local val = cfg.Default or min

            local EL = Create("Frame", {
                Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = Colors.ElementBg,
                BackgroundTransparency = 0.3, Parent = TabContent
            })
            MakeCorner(EL, 6)

            Create("TextLabel", {
                Size = UDim2.new(0.7, 0, 0, 18), Position = UDim2.new(0, 12, 0, 4),
                BackgroundTransparency = 1, Text = cfg.Name or "Slider", TextColor3 = Colors.TextPrimary,
                Font = Enum.Font.GothamSemibold, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = EL
            })

            local ValLabel = Create("TextLabel", {
                Size = UDim2.new(0.25, 0, 0, 18), Position = UDim2.new(0.75, -12, 0, 4),
                BackgroundTransparency = 1, Text = tostring(val), TextColor3 = Colors.TextSecondary,
                Font = Enum.Font.Gotham, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, Parent = EL
            })

            local SliderBg = Create("Frame", {
                Size = UDim2.new(1, -24, 0, 6), Position = UDim2.new(0, 12, 0, 32),
                BackgroundColor3 = Colors.SliderBg, Parent = EL
            })
            MakeCorner(SliderBg, 3)

            local SliderFill = Create("Frame", {
                Size = UDim2.new((val - min) / (max - min), 0, 1, 0),
                BackgroundColor3 = Colors.SliderFill, Parent = SliderBg
            })
            MakeCorner(SliderFill, 3)

            local SliderBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 12, 0, 26),
                BackgroundTransparency = 1, Text = "", Parent = EL
            })

            local SliderObj = {Value = val}
            local sliding = false

            SliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = true end
            end)
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then sliding = false end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local rel = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
                    val = math.floor(min + (max - min) * rel)
                    SliderObj.Value = val; ValLabel.Text = tostring(val)
                    Tween(SliderFill, {Size = UDim2.new(rel, 0, 1, 0)}, 0.05)
                    if cfg.Callback then pcall(cfg.Callback, val) end
                end
            end)

            function SliderObj:Set(v)
                val = math.clamp(v, min, max); SliderObj.Value = val; ValLabel.Text = tostring(val)
                local rel = (val - min) / (max - min)
                Tween(SliderFill, {Size = UDim2.new(rel, 0, 1, 0)}, 0.15)
                if cfg.Callback then pcall(cfg.Callback, val) end
            end
            table.insert(Tab.Elements, SliderObj)
            return SliderObj
        end

        table.insert(Window.Tabs, Tab)
        if #Window.Tabs == 1 then Window:SelectTab(Tab) end
        return Tab
    end

    function Window:Destroy()
        ScreenGui:Destroy()
    end

    return Window
end

return Feral
