-- Azure UI Library
-- Created by Cascade

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
    
    -- Add Corner
    local Corner = Create("UICorner", {
        Parent = MainFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Create Title Bar
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(230, 230, 235),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 30)
    })
    
    -- Add Title
    local Title = Create("TextLabel", {
        Name = "Title",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(1, -20, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = WindowTitle,
        TextColor3 = Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Create Tab Container
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(20, 20, 30) or Color3.fromRGB(245, 245, 250),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(0, 120, 1, -30)
    })
    
    -- Create Content Container
    local ContentContainer = Create("Frame", {
        Name = "ContentContainer",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 120, 0, 30),
        Size = UDim2.new(1, -120, 1, -30)
    })
    
    local Window = {}
    
    -- Add Tab Creation Function
    function Window:CreateTab(name)
        local Tab = {}
        
        -- Create Tab Button
        local TabButton = Create("TextButton", {
            Name = name.."Tab",
            Parent = TabContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 30),
            Font = Enum.Font.Gotham,
            Text = name,
            TextColor3 = Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40),
            TextSize = 14
        })
        
        -- Create Tab Content
        local TabContent = Create("ScrollingFrame", {
            Name = name.."Content",
            Parent = ContentContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            ScrollBarThickness = 4,
            Visible = false
        })
        
        -- Add Elements Creation Functions
        function Tab:CreateToggle(toggleConfig)
            local toggle = Create("Frame", {
                Name = toggleConfig.Title.."Toggle",
                Parent = TabContent,
                BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(230, 230, 235),
                Size = UDim2.new(1, -20, 0, 40),
                Position = UDim2.new(0, 10, 0, #TabContent:GetChildren() * 45)
            })
            
            -- Add toggle functionality here
            return toggle
        end
        
        function Tab:CreateSlider(sliderConfig)
            local slider = Create("Frame", {
                Name = sliderConfig.Title.."Slider",
                Parent = TabContent,
                BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(230, 230, 235),
                Size = UDim2.new(1, -20, 0, 40),
                Position = UDim2.new(0, 10, 0, #TabContent:GetChildren() * 45)
            })
            
            -- Add slider functionality here
            return slider
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
