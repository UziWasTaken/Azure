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
    
    -- Create Main Frame with gradient
    local MainFrame = Create("Frame", {
        Name = "MainFrame",
        Parent = AzureUI,
        BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(25, 25, 35) or Color3.fromRGB(240, 240, 245),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, -WindowSize.X.Offset/2, 0.5, -WindowSize.Y.Offset/2),
        Size = WindowSize,
        ClipsDescendants = true
    })

    -- Add Gradient to MainFrame
    local MainGradient = Create("UIGradient", {
        Parent = MainFrame,
        Color = Theme == "Dark" and 
            ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 45)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
            }) or 
            ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(250, 250, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 240, 245))
            }),
        Rotation = 45
    })
    
    -- Add Shadow with better depth
    local Shadow = Create("ImageLabel", {
        Name = "Shadow",
        Parent = MainFrame,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = "rbxassetid://6015897843",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(49, 49, 450, 450)
    })

    -- Add Accent Bar
    local AccentBar = Create("Frame", {
        Name = "AccentBar",
        Parent = MainFrame,
        BackgroundColor3 = Color3.fromRGB(60, 120, 255),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 0),
        Size = UDim2.new(1, 0, 0, 2),
        ZIndex = 2
    })

    -- Add Accent Gradient
    local AccentGradient = Create("UIGradient", {
        Parent = AccentBar,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 120, 255)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 160, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 120, 255))
        }),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 0.2)
        })
    })

    -- Create Title Bar with better styling
    local TitleBar = Create("Frame", {
        Name = "TitleBar",
        Parent = MainFrame,
        BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(225, 225, 230),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 40)
    })

    -- Add Title Bar Gradient
    local TitleGradient = Create("UIGradient", {
        Parent = TitleBar,
        Color = Theme == "Dark" and 
            ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 55)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
            }) or 
            ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 235, 240)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 225, 230))
            }),
        Rotation = 90
    })

    -- Add Logo/Icon
    local Logo = Create("ImageLabel", {
        Name = "Logo",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 10, 0, 8),
        Size = UDim2.new(0, 24, 0, 24),
        Image = "rbxassetid://6031251532",
        ImageColor3 = Theme == "Dark" and Color3.fromRGB(60, 120, 255) or Color3.fromRGB(40, 100, 235)
    })

    -- Add Title with better font and position
    local Title = Create("TextLabel", {
        Name = "Title",
        Parent = TitleBar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 45, 0, 0),
        Size = UDim2.new(1, -55, 1, 0),
        Font = Enum.Font.GothamBold,
        Text = WindowTitle,
        TextColor3 = Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })

    -- Create Tab Container with better styling
    local TabContainer = Create("Frame", {
        Name = "TabContainer",
        Parent = MainFrame,
        BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(235, 235, 240),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(0, 150, 1, -40),
        ClipsDescendants = true
    })

    -- Add Tab Container Gradient
    local TabContainerGradient = Create("UIGradient", {
        Parent = TabContainer,
        Color = Theme == "Dark" and 
            ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 45)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(30, 30, 40))
            }) or 
            ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 240, 245)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 235, 240))
            }),
        Rotation = 90
    })

    -- Add Tab Container Layout
    local TabLayout = Create("UIListLayout", {
        Parent = TabContainer,
        Padding = UDim.new(0, 5),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    -- Add Tab Container Padding
    local TabContainerPadding = Create("UIPadding", {
        Parent = TabContainer,
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10)
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
        
        -- Create Tab Button with better styling
        local TabButton = Create("TextButton", {
            Name = name.."Tab",
            Parent = TabContainer,
            BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(220, 220, 225),
            Size = UDim2.new(0.9, 0, 0, 35),
            Font = Enum.Font.GothamSemibold,
            Text = "    " .. name,
            TextColor3 = Theme == "Dark" and Color3.fromRGB(200, 200, 200) or Color3.fromRGB(60, 60, 60),
            TextSize = 14,
            AutoButtonColor = false,
            ClipsDescendants = true
        })

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

        -- Add CreateButton Function to Tab
        function Tab:CreateButton(buttonConfig)
            local buttonContainer = Create("Frame", {
                Name = buttonConfig.Title.."Button",
                Parent = TabContent,
                BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(225, 225, 230),
                Size = UDim2.new(1, 0, 0, 40),
                LayoutOrder = #TabContent:GetChildren(),
                ClipsDescendants = true
            })
            
            -- Add Container Corner
            local ContainerCorner = Create("UICorner", {
                Parent = buttonContainer,
                CornerRadius = UDim.new(0, 6)
            })
            
            -- Add Container Gradient
            local ContainerGradient = Create("UIGradient", {
                Parent = buttonContainer,
                Color = Theme == "Dark" and 
                    ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
                    }) or 
                    ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 230, 235)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 225, 230))
                    }),
                Rotation = 90
            })
            
            -- Create Button
            local Button = Create("TextButton", {
                Name = "Button",
                Parent = buttonContainer,
                BackgroundColor3 = Color3.fromRGB(60, 120, 255),
                Size = UDim2.new(1, -20, 1, -10),
                Position = UDim2.new(0, 10, 0, 5),
                Font = Enum.Font.GothamSemibold,
                Text = buttonConfig.Title,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 14,
                AutoButtonColor = false
            })
            
            -- Add Button Corner
            local ButtonCorner = Create("UICorner", {
                Parent = Button,
                CornerRadius = UDim.new(0, 4)
            })
            
            -- Add Button Gradient
            local ButtonGradient = Create("UIGradient", {
                Parent = Button,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 120, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 110, 245))
                }),
                Rotation = 90
            })
            
            -- Add Click Effect
            Button.MouseButton1Down:Connect(function(X, Y)
                -- Ripple Effect
                local Ripple = Create("Frame", {
                    Parent = Button,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BackgroundTransparency = 0.7,
                    Position = UDim2.new(0, X - Button.AbsolutePosition.X, 0, Y - Button.AbsolutePosition.Y),
                    Size = UDim2.new(0, 0, 0, 0),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                })
                
                local RippleCorner = Create("UICorner", {
                    Parent = Ripple,
                    CornerRadius = UDim.new(1, 0)
                })
                
                local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 2
                local Tween = TweenService:Create(Ripple, TweenInfo.new(0.5), {Size = UDim2.new(0, Size, 0, Size), BackgroundTransparency = 1})
                Tween:Play()
                Tween.Completed:Connect(function()
                    Ripple:Destroy()
                end)
                
                -- Callback
                if buttonConfig.Callback then
                    buttonConfig.Callback()
                end
            end)
            
            -- Add Hover Effect
            Button.MouseEnter:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(Button, {BackgroundColor3 = Color3.fromRGB(60, 120, 255)}, 0.2)
            end)
            
            return buttonContainer
        end
        
        -- Add Toggle Creation Function
        function Tab:CreateToggle(toggleConfig)
            local toggleContainer = Create("Frame", {
                Name = toggleConfig.Title.."Toggle",
                Parent = TabContent,
                BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(225, 225, 230),
                Size = UDim2.new(1, 0, 0, 40),
                LayoutOrder = #TabContent:GetChildren(),
                ClipsDescendants = true
            })

            -- Create Dropdown Container
            local dropdownContainer = Create("Frame", {
                Name = "DropdownContainer",
                Parent = toggleContainer,
                BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(220, 220, 225),
                Position = UDim2.new(0, 0, 1, 0),
                Size = UDim2.new(1, 0, 0, 0),
                ClipsDescendants = true
            })

            -- Add Dropdown Items if specified
            local dropdownHeight = 0
            if toggleConfig.Dropdown then
                for _, item in ipairs(toggleConfig.Dropdown) do
                    local dropdownItem = Create("TextButton", {
                        Name = item.."Item",
                        Parent = dropdownContainer,
                        BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(230, 230, 235),
                        Size = UDim2.new(1, 0, 0, 30),
                        Position = UDim2.new(0, 0, 0, dropdownHeight),
                        Font = Enum.Font.GothamMedium,
                        Text = item,
                        TextColor3 = Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40),
                        TextSize = 14,
                        AutoButtonColor = false
                    })

                    -- Add hover effect for dropdown items
                    dropdownItem.MouseEnter:Connect(function()
                        Tween(dropdownItem, {
                            BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(50, 50, 60) or Color3.fromRGB(220, 220, 225)
                        }, 0.2)
                    end)

                    dropdownItem.MouseLeave:Connect(function()
                        Tween(dropdownItem, {
                            BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(40, 40, 50) or Color3.fromRGB(230, 230, 235)
                        }, 0.2)
                    end)

                    dropdownItem.MouseButton1Click:Connect(function()
                        if toggleConfig.DropdownCallback then
                            toggleConfig.DropdownCallback(item)
                        end
                    end)

                    dropdownHeight = dropdownHeight + 30
                end
            end

            -- Add Container Corner
            local ContainerCorner = Create("UICorner", {
                Parent = toggleContainer,
                CornerRadius = UDim.new(0, 6)
            })

            -- Add Container Gradient
            local ContainerGradient = Create("UIGradient", {
                Parent = toggleContainer,
                Color = Theme == "Dark" and 
                    ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
                    }) or 
                    ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 230, 235)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 225, 230))
                    }),
                Rotation = 90
            })
            
            -- Add Toggle Title
            local ToggleTitle = Create("TextLabel", {
                Name = "Title",
                Parent = toggleContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 15, 0, 0),
                Size = UDim2.new(1, -65, 1, 0),
                Font = Enum.Font.GothamMedium,
                Text = toggleConfig.Title,
                TextColor3 = Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left
            })
            
            -- Create Toggle Button
            local ToggleButton = Create("Frame", {
                Name = "ToggleButton",
                Parent = toggleContainer,
                BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(45, 45, 55) or Color3.fromRGB(215, 215, 220),
                Position = UDim2.new(1, -55, 0.5, -10),
                Size = UDim2.new(0, 40, 0, 20),
                ClipsDescendants = true
            })
            
            -- Add Toggle Button Corner
            local ToggleButtonCorner = Create("UICorner", {
                Parent = ToggleButton,
                CornerRadius = UDim.new(1, 0)
            })
            
            -- Create Toggle Circle
            local ToggleCircle = Create("Frame", {
                Name = "Circle",
                Parent = ToggleButton,
                BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40),
                Position = UDim2.new(0, 2, 0.5, -8),
                Size = UDim2.new(0, 16, 0, 16),
                AnchorPoint = Vector2.new(0, 0)
            })
            
            -- Add Circle Corner
            local CircleCorner = Create("UICorner", {
                Parent = ToggleCircle,
                CornerRadius = UDim.new(1, 0)
            })
            
            -- Add Circle Gradient
            local CircleGradient = Create("UIGradient", {
                Parent = ToggleCircle,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 230, 230))
                }),
                Rotation = 45
            })
            
            -- Add Click Animation
            local Toggled = toggleConfig.Default or false
            
            local function UpdateToggle()
                local ToggleColor = Color3.fromRGB(60, 120, 255)
                local Position = Toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                local BackgroundColor = Toggled and ToggleColor or 
                    (Theme == "Dark" and Color3.fromRGB(45, 45, 55) or Color3.fromRGB(215, 215, 220))
                
                Tween(ToggleCircle, {Position = Position}, 0.2)
                Tween(ToggleButton, {BackgroundColor3 = BackgroundColor}, 0.2)
            end
            
            UpdateToggle()
            
            -- Modify click behavior to show/hide dropdown
            local dropdownOpen = false
            ToggleButton.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Toggled = not Toggled
                    UpdateToggle()
                    
                    -- Toggle dropdown if it exists
                    if toggleConfig.Dropdown then
                        dropdownOpen = not dropdownOpen
                        local newSize = dropdownOpen and UDim2.new(1, 0, 0, dropdownHeight) or UDim2.new(1, 0, 0, 0)
                        local newContainerSize = dropdownOpen and UDim2.new(1, 0, 0, 40 + dropdownHeight) or UDim2.new(1, 0, 0, 40)
                        
                        Tween(dropdownContainer, {Size = newSize}, 0.2)
                        Tween(toggleContainer, {Size = newContainerSize}, 0.2)
                    end
                    
                    if toggleConfig.Callback then
                        toggleConfig.Callback(Toggled)
                    end
                end
            end)

            return toggleContainer
        end
        
        -- Add Slider Creation Function
        function Tab:CreateSlider(sliderConfig)
            local sliderContainer = Create("Frame", {
                Name = sliderConfig.Title.."Slider",
                Parent = TabContent,
                BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(225, 225, 230),
                Size = UDim2.new(1, 0, 0, 50),
                LayoutOrder = #TabContent:GetChildren()
            })
            
            -- Add Container Corner
            local ContainerCorner = Create("UICorner", {
                Parent = sliderContainer,
                CornerRadius = UDim.new(0, 6)
            })
            
            -- Add Container Gradient
            local ContainerGradient = Create("UIGradient", {
                Parent = sliderContainer,
                Color = Theme == "Dark" and 
                    ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
                    }) or 
                    ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 230, 235)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 225, 230))
                    }),
                Rotation = 90
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
            
            -- Create Slider Bar
            local SliderBar = Create("Frame", {
                Name = "SliderBar",
                Parent = sliderContainer,
                BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(45, 45, 55) or Color3.fromRGB(215, 215, 220),
                Position = UDim2.new(0, 15, 0, 35),
                Size = UDim2.new(1, -30, 0, 4),
                AnchorPoint = Vector2.new(0, 0.5)
            })
            
            -- Add Slider Bar Corner
            local SliderBarCorner = Create("UICorner", {
                Parent = SliderBar,
                CornerRadius = UDim.new(1, 0)
            })
            
            -- Create Slider Fill
            local SliderFill = Create("Frame", {
                Name = "SliderFill",
                Parent = SliderBar,
                BackgroundColor3 = Color3.fromRGB(60, 120, 255),
                Size = UDim2.new(0.5, 0, 1, 0),
                BorderSizePixel = 0
            })
            
            -- Add Slider Fill Corner
            local SliderFillCorner = Create("UICorner", {
                Parent = SliderFill,
                CornerRadius = UDim.new(1, 0)
            })
            
            -- Add Slider Fill Gradient
            local SliderFillGradient = Create("UIGradient", {
                Parent = SliderFill,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 120, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 150, 255))
                }),
                Rotation = 90
            })
            
            -- Create Slider Button
            local SliderButton = Create("Frame", {
                Name = "SliderButton",
                Parent = SliderFill,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Position = UDim2.new(1, -6, 0.5, -6),
                Size = UDim2.new(0, 12, 0, 12),
                AnchorPoint = Vector2.new(0.5, 0.5),
                ZIndex = 2
            })
            
            -- Add Slider Button Corner
            local SliderButtonCorner = Create("UICorner", {
                Parent = SliderButton,
                CornerRadius = UDim.new(1, 0)
            })
            
            -- Add Value Label
            local ValueLabel = Create("TextLabel", {
                Name = "Value",
                Parent = sliderContainer,
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -50, 0, 5),
                Size = UDim2.new(0, 35, 0, 20),
                Font = Enum.Font.GothamBold,
                Text = tostring(sliderConfig.Default or sliderConfig.Min),
                TextColor3 = Theme == "Dark" and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(40, 40, 40),
                TextSize = 12
            })
            
            -- Add Slider Functionality
            local Dragging = false
            local Value = sliderConfig.Default or sliderConfig.Min
            
            local function UpdateSlider(value)
                Value = math.clamp(value, sliderConfig.Min, sliderConfig.Max)
                local Percent = (Value - sliderConfig.Min) / (sliderConfig.Max - sliderConfig.Min)
                
                Tween(SliderFill, {Size = UDim2.new(Percent, 0, 1, 0)}, 0.1)
                ValueLabel.Text = tostring(math.round(Value))
                
                if sliderConfig.Callback then
                    sliderConfig.Callback(Value)
                end
            end
            
            UpdateSlider(Value)
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = true
                    local Percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local Value = sliderConfig.Min + ((sliderConfig.Max - sliderConfig.Min) * Percent)
                    UpdateSlider(Value)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local Percent = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                    local Value = sliderConfig.Min + ((sliderConfig.Max - sliderConfig.Min) * Percent)
                    UpdateSlider(Value)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Dragging = false
                end
            end)
            
            return sliderContainer
        end
        
        return Tab
    end
    
    -- Add Button Creation Function
    function Window:CreateButton(buttonConfig)
        local buttonContainer = Create("Frame", {
            Name = buttonConfig.Title.."Button",
            Parent = ContentContainer,
            BackgroundColor3 = Theme == "Dark" and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(225, 225, 230),
            Size = UDim2.new(1, 0, 0, 40),
            LayoutOrder = #ContentContainer:GetChildren(),
            ClipsDescendants = true
        })
        
        -- Add Container Corner
        local ContainerCorner = Create("UICorner", {
            Parent = buttonContainer,
            CornerRadius = UDim.new(0, 6)
        })
        
        -- Add Container Gradient
        local ContainerGradient = Create("UIGradient", {
            Parent = buttonContainer,
            Color = Theme == "Dark" and 
                ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 50)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 45))
                }) or 
                ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 230, 235)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 225, 230))
                }),
            Rotation = 90
        })
        
        -- Create Button
        local Button = Create("TextButton", {
            Name = "Button",
            Parent = buttonContainer,
            BackgroundColor3 = Color3.fromRGB(60, 120, 255),
            Size = UDim2.new(1, -20, 1, -10),
            Position = UDim2.new(0, 10, 0, 5),
            Font = Enum.Font.GothamSemibold,
            Text = buttonConfig.Title,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 14,
            AutoButtonColor = false
        })
        
        -- Add Button Corner
        local ButtonCorner = Create("UICorner", {
            Parent = Button,
            CornerRadius = UDim.new(0, 4)
        })
        
        -- Add Button Gradient
        local ButtonGradient = Create("UIGradient", {
            Parent = Button,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 120, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 110, 245))
            }),
            Rotation = 90
        })
        
        -- Add Click Effect
        Button.MouseButton1Down:Connect(function(X, Y)
            -- Ripple Effect
            local Ripple = Create("Frame", {
                Parent = Button,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.7,
                Position = UDim2.new(0, X - Button.AbsolutePosition.X, 0, Y - Button.AbsolutePosition.Y),
                Size = UDim2.new(0, 0, 0, 0),
                AnchorPoint = Vector2.new(0.5, 0.5),
            })
            
            local RippleCorner = Create("UICorner", {
                Parent = Ripple,
                CornerRadius = UDim.new(1, 0)
            })
            
            local Size = math.max(Button.AbsoluteSize.X, Button.AbsoluteSize.Y) * 2
            local Tween = TweenService:Create(Ripple, TweenInfo.new(0.5), {Size = UDim2.new(0, Size, 0, Size), BackgroundTransparency = 1})
            Tween:Play()
            Tween.Completed:Connect(function()
                Ripple:Destroy()
            end)
            
            -- Callback
            if buttonConfig.Callback then
                buttonConfig.Callback()
            end
        end)
        
        -- Add Hover Effect
        Button.MouseEnter:Connect(function()
            Tween(Button, {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}, 0.2)
        end)
        
        Button.MouseLeave:Connect(function()
            Tween(Button, {BackgroundColor3 = Color3.fromRGB(60, 120, 255)}, 0.2)
        end)
        
        return buttonContainer
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
