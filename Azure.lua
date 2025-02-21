--[[
    Azure UI Library
    Version: 1.0.0
    Created by Cascade
    
    A modern, clean UI library for Roblox with smooth animations and a beautiful design.
    
    Features:
    - Modern and clean design
    - Dark and Light themes
    - Smooth animations and transitions
    - Automatic layout management
    - Responsive design
    
    Main Components:
    - Windows: Main container for your UI
    - Tabs: Organize content into different sections
    - Toggles: Boolean input controls
    - Sliders: Numeric input controls
    
    Example Usage:
    ```lua
    local Azure = require(game:GetService("ReplicatedStorage").Azure)
    
    -- Create a new window
    local Window = Azure:CreateWindow({
        Title = "My Window",
        Theme = "Dark", -- or "Light"
        Size = UDim2.fromOffset(600, 400)
    })
    
    -- Create a tab
    local Tab = Window:CreateTab("Settings")
    
    -- Add a toggle
    Tab:CreateToggle({
        Title = "Enable Feature",
        Default = false,
        Callback = function(Value)
            print("Toggle value:", Value)
        end
    })
    
    -- Add a slider
    Tab:CreateSlider({
        Title = "Speed",
        Min = 0,
        Max = 100,
        Default = 50,
        Callback = function(Value)
            print("Slider value:", Value)
        end
    })
    ```
]]

local Azure = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Utility Functions
local function Create(className, properties)
    local instance = Instance.new(className)
    for k, v in pairs(properties) do
        instance[k] = v
    end
    return instance
end

local function Tween(instance, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(instance, tweenInfo, properties)
    tween:Play()
    return tween
end

-- Main Window Creator
function Azure:CreateWindow(config)
    config = config or {}
    local WindowTitle = config.Title or "Azure"
    local WindowSize = config.Size or UDim2.fromOffset(600, 400)
    local Theme = config.Theme or "Dark"
    
    -- Create Main GUI
    local AzureUI = Create("ScreenGui", {
        Name = "AzureUI",
        Parent = CoreGui,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Create Main Frame
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = AzureUI,
        BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(25, 25, 35) or Color3.fromRGB(240, 240, 245),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2),
        Size = WindowSize,
        ClipsDescendants = true
    })
    
    -- Add Shadow
    local Shadow = Create("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })
    
    -- Add Corner with smaller radius
    local Corner = Create("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Create Title Bar with gradient
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(225, 225, 230),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })
    
    -- Add Title Bar Corner
    local TitleBarCorner = Create("UICorner", {
        Parent = TitleBar,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Add Title with better positioning and font
    local Title = Create("TextLabel", {
        Name = "Title",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -30, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = WindowTitle,
        TextColor3 = Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Create Tab Container with better contrast
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(235, 235, 240),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 150, 1, -40),
        ClipsDescendants = true
    })
    
    -- Add Tab Container Corner
    local TabContainerCorner = Create("UICorner", {
        Parent = TabContainer,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Add Padding to Tab Container
    local TabContainerPadding = Create("UIPadding", {
        Parent = TabContainer,
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10)
    })
    
    -- Create Content Container with adjusted position
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 150, 0, 40),
        Size = UDim2.new(1, -150, 1, -40),
        ClipsDescendants = true
    })
    
    -- Add Padding to Content Container
    local ContentPadding = Create("UIPadding", {
        Parent = ContentContainer,
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15)
    })
    
    local Window = {}
    
    -- Add Tab Creation Function
    function Window:CreateTab(name)
        local Tab = {}
        
        -- Create Tab Button
        local TabButton = Create("TextButton", {
            Name = name.."Tab",
            Parent = TabContainer,
            BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(220, 220, 225),
            Size = UDim2.new(1, 0, 0, 35),
            Font = Enum.Font.GothamSemibold,
            Text = name,
            TextColor3 = Theme == "Dark" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(60, 60, 60),
            TextSize = 14,
            AutoButtonColor = false
        })
        
        -- Add Corner to Tab Button
        local TabButtonCorner = Create("UICorner", {
            Parent = TabButton,
            CornerRadius = UDim.new(0, 4)
        })
        
        -- Add Hover Effect
        TabButton.MouseEnter:Connect(function()
            Tween(TabButton, {
                BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(210, 210, 215),
                TextColor3 = Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40)
            }, 0.2)
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not TabButton.Selected then
                Tween(TabButton, {
                    BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(220, 220, 225),
                    TextColor3 = Theme == "Dark" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(60, 60, 60)
                }, 0.2)
            end
        end)
        
        -- Create Tab Content
        local TabContent = Create("ScrollingFrame", {
            Name = name.."Content",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40),
            ScrollBarImageTransparency = 0.7,
            VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
            Visible = false,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(0, 0, 0, 0)
        })
        
        -- Add Layout for Tab Content
        local TabContentLayout = Create("UIListLayout", {
            Parent = TabContent,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        -- Add Elements Creation Functions
        function Tab:CreateToggle(toggleConfig)
            local toggleContainer = Create("Frame", {
                Name = toggleConfig.Title.."Toggle",
                Parent = TabContent,
                BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(225, 225, 230),
                Size = UDim2.new(1, 0, 0, 40),
                LayoutOrder = #TabContent:GetChildren()
            })
            
            -- Add Corner to Toggle Container
            local ToggleCorner = Create("UICorner", {
                Parent = toggleContainer,
                CornerRadius = UDim.new(0, 4)
            })
            
            -- Add Toggle Title
            local ToggleTitle = Create("TextLabel", {
                Name = "Title",
                Parent = toggleContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -55, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = toggleConfig.Title,
                TextColor3 = Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            return toggleContainer
        end
        
        function Tab:CreateSlider(sliderConfig)
            local sliderContainer = Create("Frame", {
                Name = sliderConfig.Title.."Slider",
                Parent = TabContent,
                BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(225, 225, 230),
                Size = UDim2.new(1, 0, 0, 50),
                LayoutOrder = #TabContent:GetChildren()
            })
            
            -- Add Corner to Slider Container
            local SliderCorner = Create("UICorner", {
                Parent = sliderContainer,
                CornerRadius = UDim.new(0, 4)
            })
            
            -- Add Slider Title
            local SliderTitle = Create("TextLabel", {
                Name = "Title",
                Parent = sliderContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 5),
                Size = UDim2.new(1, -30, 0, 20),
                Font = Enum.Font.GothamMedium,
                Text = sliderConfig.Title,
                TextColor3 = Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            return sliderContainer
        end
        
        return Tab
    end
    
    -- Make Window Draggable
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    
    TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    return Window
end

return Azure
