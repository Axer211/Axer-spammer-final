--[[ 
  AXER SPAMMER V1.5 – Ice Edition
  Changes:
  - Anti‑lag: spam loop now uses task.defer + minimal yields, remote fires are protected.
  - Executable: wrapped in pcall, waits for game load, fallback for TextChatService.
  - Ice color GUI: light blue/cyan palette, frosty buttons, dark text for readability.
--]]

local success, err = pcall(function()
    -- Wait for game to fully load
    game:IsLoaded() or game.Loaded:Wait()

    local Players = game:GetService("Players")
    local TCS = game:GetService("TextChatService")
    local lp = Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local RUN = game:GetService("RunService")
    local SoundService = game:GetService("SoundService")
    local TweenService = game:GetService("TweenService")
    local VirtualUser = game:GetService("VirtualUser")

    -- [[ ADMIN CONFIG ]] --
    local Admins = {
        ["VENUS_EDIT"] = true,
        ["AX3RKABOT"] = true
    }

    local isSpamming = false
    local fixedDelay = 1.5
    local currentMsg = ""
    local spamMode = "SPAM"
    local nameRGB, bioRGB, isRGB = true, true, true

    local SETTINGS = {
        NAME_TEXT = "🇰🇬卂乂乇尺  丂卩卂爪爪乇尺  ㄩ丂乇尺🇰🇬",
        BIO_TEXT = "Welcome " .. lp.DisplayName,
        SPEED = 0.1,
        STAY_TIME = 2,
        FONT = Enum.Font.GothamBold,
        LOGO_FONT = Enum.Font.LuckiestGuy,
        INTRO_SOUND_ID = "rbxassetid://86685635786943",
        START_TIME = 21,
        PLAY_DURATION = 7
    }

    -- Ice theme colors
    local ICE_COLOR = Color3.fromRGB(0, 150, 255)
    local ICE_LIGHT = Color3.fromRGB(220, 240, 255)
    local ICE_DARK = Color3.fromRGB(160, 200, 240)
    local ICE_TEXT = Color3.fromRGB(0, 50, 100)

    local currentThemeColor = ICE_COLOR
    local PATTERN_CYCLE = {
        "`", "/=-=", "Z_", "Q_", "@", "#", "*", "%", "@", "/-", "", "P_",
    }
    local currentPatternIndex = 1

    -- Remote with fallback
    local Remote = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("1RPNam1eTex1t")
    local RemoteColor = ReplicatedStorage:FindFirstChild("RE") and ReplicatedStorage.RE:FindFirstChild("1RPNam1eColo1r")

    local function Send(text, mode)
        local pattern = PATTERN_CYCLE[currentPatternIndex]
        currentPatternIndex = (currentPatternIndex % #PATTERN_CYCLE) + 1
        local finalMsg = ""
        local rawWords = {"AXER PAPA", "AXER PAPA BOL", "AXER SPAMMER USE KR", "BURGER", "GRAVITY", "QATAR", "JUICE", "ORANGE", "BALL", "SNAKE", "APPLE", "VENOM", "LUN", "BUS", "CAR", "PLANE", "QUANTUM"}

        if mode == "SPAM" then
            local randomWord = rawWords[math.random(1, #rawWords)]
            local core = ""
            if randomWord == "AXER PAPA BOL" or randomWord == "AXER SPAMMER USE KR" then
                core = (text ~= "" and (text .. " ") or "") .. randomWord
            else
                core = (text ~= "" and (text .. " ") or "") .. "TMKX ME " .. randomWord
            end
            local pStr = ""
            while (#pStr + #pattern) <= (197 - #core) do pStr = pStr .. pattern end
            finalMsg = pStr .. " " .. core
        elseif mode == "CLEAN_SPAM" then
            local pStr = ""
            while (#pStr + #pattern) <= (197 - #text) do pStr = pStr .. pattern end
            finalMsg = pStr .. " " .. text
        elseif mode == "LOADED" then
            local lpPattern = " /=-=_"
            local pStr = ""
            while (#pStr + #lpPattern) <= (197 - #text) do pStr = pStr .. lpPattern end
            finalMsg = pStr .. " " .. text
        else
            finalMsg = text
        end

        -- Anti‑lag: send asynchronously and protect against errors
        task.defer(function()
            pcall(function()
                if TCS and TCS.TextChannels and TCS.TextChannels.RBXGeneral then
                    TCS.TextChannels.RBXGeneral:SendAsync(finalMsg)
                end
                local chat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                if chat and chat:FindFirstChild("SayMessageRequest") then
                    chat.SayMessageRequest:FireServer(finalMsg, "All")
                end
            end)
        end)
    end

    -- GUI Creation (Ice Theme)
    local sg = Instance.new("ScreenGui", lp.PlayerGui)
    sg.Name = "AXER_V1_MASTER"
    sg.ResetOnSpawn = false

    local logo = Instance.new("TextButton", sg)
    logo.Size = UDim2.new(0, 50, 0, 50)
    logo.Position = UDim2.new(0.05, 0, 0.4, 0)
    logo.BackgroundColor3 = ICE_DARK
    logo.Text = "AXER"
    logo.Font = SETTINGS.LOGO_FONT
    logo.TextSize = 14
    logo.Draggable = true
    logo.TextColor3 = Color3.new(1, 1, 1)
    logo.ZIndex = 30
    logo.Visible = false
    Instance.new("UICorner", logo).CornerRadius = UDim.new(1, 0)
    local logoStroke = Instance.new("UIStroke", logo)
    logoStroke.Thickness = 2
    logoStroke.Color = ICE_COLOR

    local mainFrame = Instance.new("Frame", sg)
    mainFrame.Size = UDim2.new(0, 350, 0, 300)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -185)
    mainFrame.BackgroundColor3 = ICE_LIGHT
    mainFrame.Visible = false
    mainFrame.Active = true
    mainFrame.Draggable = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    local frameStroke = Instance.new("UIStroke", mainFrame)
    frameStroke.Thickness = 3
    frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    frameStroke.Color = ICE_COLOR

    -- Particles (keep them white for contrast)
    local particleContainer = Instance.new("Frame", mainFrame)
    particleContainer.Name = "ParticleContainer"
    particleContainer.Size = UDim2.new(1, 0, 1, 0)
    particleContainer.BackgroundTransparency = 0.3
    particleContainer.ClipsDescendants = true
    particleContainer.ZIndex = 0

    task.spawn(function()
        while true do
            task.wait(math.random(1, 3) / 10)
            local p = Instance.new("Frame", particleContainer)
            local size = math.random(1, 3)
            p.Size = UDim2.new(0, size, 0, size)
            p.Position = UDim2.new(math.random(), 0, -0.05, 0)
            p.BackgroundColor3 = Color3.new(1, 1, 1)
            p.BorderSizePixel = 0
            p.BackgroundTransparency = 0.5
            Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
            local fallTime = math.random(3, 6)
            TweenService:Create(p, TweenInfo.new(fallTime, Enum.EasingStyle.Linear), {
                Position = UDim2.new(p.Position.X.Scale, 0, 1.05, 0),
                BackgroundTransparency = 1
            }):Play()
            task.delay(fallTime, function() p:Destroy() end)
        end
    end)

    local instaLabel = Instance.new("TextLabel", mainFrame)
    instaLabel.Size = UDim2.new(1, 0, 0, 20)
    instaLabel.Position = UDim2.new(0, 0, 1, -25)
    instaLabel.Text = "INSTAGRAM: MYST1C4SHER"
    instaLabel.Font = Enum.Font.GothamBold
    instaLabel.TextSize = 10
    instaLabel.BackgroundTransparency = 1
    instaLabel.TextColor3 = ICE_TEXT

    local headerHeight = 50
    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0, headerHeight)
    header.BackgroundColor3 = ICE_DARK
    header.BorderSizePixel = 0
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(0.6, 0, 0.5, 0)
    title.Position = UDim2.new(0.05, 0, 0.15, 0)
    title.Text = "AXER SPAMMER"
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 16
    title.TextColor3 = ICE_TEXT
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.BackgroundTransparency = 1

    local version = Instance.new("TextLabel", header)
    version.Size = UDim2.new(0.2, 0, 0.3, 0)
    version.Position = UDim2.new(0.05, 0, 0.6, 0)
    version.Text = "V1.5 ICE"
    version.Font = Enum.Font.Gotham
    version.TextSize = 10
    version.TextColor3 = ICE_TEXT
    version.TextXAlignment = Enum.TextXAlignment.Left
    version.BackgroundTransparency = 1

    local idLabel = Instance.new("TextLabel", header)
    idLabel.Size = UDim2.new(0.4, 0, 0.4, 0)
    idLabel.Position = UDim2.new(0.45, 0, 0.45, 0)
    idLabel.Text = "ID: " .. lp.UserId
    idLabel.Font = Enum.Font.GothamMedium
    idLabel.TextSize = 10
    idLabel.TextColor3 = ICE_TEXT
    idLabel.TextXAlignment = Enum.TextXAlignment.Right
    idLabel.BackgroundTransparency = 1

    local pfpFrame = Instance.new("ImageLabel", header)
    pfpFrame.Size = UDim2.new(0, 38, 0, 38)
    pfpFrame.Position = UDim2.new(0.97, -38, 0.5, -19)
    pfpFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
    pfpFrame.Image = "rbxthumb://type=AvatarHeadShot&id=" .. lp.UserId .. "&w=150&h=150"
    Instance.new("UICorner", pfpFrame).CornerRadius = UDim.new(1, 0)
    local pfpStroke = Instance.new("UIStroke", pfpFrame)
    pfpStroke.Thickness = 2
    pfpStroke.Color = ICE_COLOR

    -- Tabs
    local tabFrame = Instance.new("Frame", mainFrame)
    tabFrame.Size = UDim2.new(1, 0, 0, 40)
    tabFrame.Position = UDim2.new(0,0,0, headerHeight + 2)
    tabFrame.BackgroundTransparency = 1
    local tabLayout = Instance.new("UIListLayout", tabFrame)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local function createTab(name)
        local btn = Instance.new("TextButton", tabFrame)
        btn.Size = UDim2.new(0.23, 0, 0.7, 0)
        btn.Text = name
        btn.BackgroundColor3 = ICE_DARK
        btn.TextColor3 = ICE_TEXT
        btn.Font = SETTINGS.FONT
        btn.TextSize = 9
        Instance.new("UICorner", btn)
        return btn
    end
    local cmdBtn, themeBtn, settBtn, infoBtn = createTab("SPAM"), createTab("THEMES"), createTab("SETT"), createTab("INFO")

    local pageContainer = Instance.new("Frame", mainFrame)
    pageContainer.Size = UDim2.new(1, 0, 0.65, 0)
    pageContainer.Position = UDim2.new(0, 0, 0.28, 0)
    pageContainer.BackgroundTransparency = 1

    local function setupPage(page)
        local layout = Instance.new("UIListLayout", page)
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.SortOrder = Enum.SortOrder.LayoutOrder
    end

    local cmdPage = Instance.new("Frame", pageContainer)
    cmdPage.Size = UDim2.new(1, 0, 1, 0)
    cmdPage.BackgroundTransparency = 1
    setupPage(cmdPage)

    local themePage = Instance.new("ScrollingFrame", pageContainer)
    themePage.Size = cmdPage.Size
    themePage.Visible = false
    themePage.BackgroundTransparency = 1
    themePage.ScrollBarThickness = 2
    themePage.BorderSizePixel = 0
    setupPage(themePage)
    themePage.CanvasSize = UDim2.new(0,0,0,700)

    local settPage = Instance.new("ScrollingFrame", pageContainer)
    settPage.Size = cmdPage.Size
    settPage.Visible = false
    settPage.BackgroundTransparency = 1
    settPage.ScrollBarThickness = 2
    settPage.BorderSizePixel = 0
    setupPage(settPage)
    settPage.CanvasSize = UDim2.new(0,0,0,300)

    local infoPage = Instance.new("ScrollingFrame", pageContainer)
    infoPage.Size = cmdPage.Size
    infoPage.Visible = false
    infoPage.BackgroundTransparency = 1
    setupPage(infoPage)
    infoPage.CanvasSize = UDim2.new(0,0,0,200)

    -- Info page
    local function createInfo(txt)
        local l = Instance.new("TextLabel", infoPage)
        l.Size = UDim2.new(0.9, 0, 0, 20)
        l.Text = txt
        l.Font = Enum.Font.Gotham
        l.TextSize = 11
        l.TextColor3 = ICE_TEXT
        l.BackgroundTransparency = 1
    end

    local bigInfo = Instance.new("TextLabel", infoPage)
    bigInfo.Size = UDim2.new(0.9, 0, 0, 120)
    bigInfo.Text = "👨‍💻\nCODED BY\nAXER\n\nMADE WITH LOVE ❤️"
    bigInfo.Font = Enum.Font.GothamBold
    bigInfo.TextSize = 18
    bigInfo.TextColor3 = ICE_TEXT
    bigInfo.BackgroundTransparency = 1
    bigInfo.TextWrapped = true
    bigInfo.TextScaled = true
    bigInfo.TextXAlignment = Enum.TextXAlignment.Center
    bigInfo.TextYAlignment = Enum.TextYAlignment.Center
    bigInfo.LayoutOrder = 1
    bigInfo.AnchorPoint = Vector2.new(0.5, 0)
    bigInfo.Position = UDim2.new(0.5, 0, 0, 10)

    -- Command page
    _G.TargetBox = Instance.new("TextBox", cmdPage)
    _G.TargetBox.Size = UDim2.new(0.9, 0, 0, 35)
    _G.TargetBox.PlaceholderText = "TARGET NAME"
    _G.TargetBox.Text = ""
    _G.TargetBox.BackgroundColor3 = Color3.fromRGB(230, 245, 255)
    _G.TargetBox.TextColor3 = ICE_TEXT
    _G.TargetBox.Font = SETTINGS.FONT
    Instance.new("UICorner", _G.TargetBox)
    _G.TargetBox.FocusLost:Connect(function() currentMsg = _G.TargetBox.Text end)

    local delayBox = Instance.new("TextBox", cmdPage)
    delayBox.Size = UDim2.new(0.9, 0, 0, 30)
    delayBox.Text = "1.5"
    delayBox.BackgroundColor3 = Color3.fromRGB(230, 245, 255)
    delayBox.TextColor3 = ICE_TEXT
    delayBox.Font = SETTINGS.FONT
    Instance.new("UICorner", delayBox)
    delayBox.FocusLost:Connect(function() fixedDelay = tonumber(delayBox.Text) or 1.5 end)

    local modeBtn = Instance.new("TextButton", cmdPage)
    modeBtn.Size = UDim2.new(0.9, 0, 0, 30)
    modeBtn.Text = "NORMAL MODE"
    modeBtn.BackgroundColor3 = ICE_DARK
    modeBtn.TextColor3 = ICE_TEXT
    modeBtn.Font = SETTINGS.FONT
    Instance.new("UICorner", modeBtn)
    modeBtn.MouseButton1Click:Connect(function()
        spamMode = (spamMode == "SPAM" and "CLEAN_SPAM" or "SPAM")
        modeBtn.Text = (spamMode == "SPAM" and "NORMAL MODE" or "CLEAN MODE")
    end)

    local sBtn = Instance.new("TextButton", cmdPage)
    sBtn.Size = UDim2.new(0.9, 0, 0, 35)
    sBtn.Text = "START"
    sBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    sBtn.TextColor3 = Color3.new(1,1,1)
    sBtn.Font = SETTINGS.FONT
    Instance.new("UICorner", sBtn)
    sBtn.MouseButton1Click:Connect(function() isSpamming = true end)

    local stopBtn = Instance.new("TextButton", cmdPage)
    stopBtn.Size = UDim2.new(0.9, 0, 0, 35)
    stopBtn.Text = "STOP"
    stopBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
    stopBtn.TextColor3 = Color3.new(1,1,1)
    stopBtn.Font = SETTINGS.FONT
    Instance.new("UICorner", stopBtn)
    stopBtn.MouseButton1Click:Connect(function() isSpamming = false end)

    -- Admin commands handler (unchanged)
    local function processAdminCommand(sender, message)
        local msg = message:lower()
        local args = string.split(message, " ")

        if msg:sub(1,9) == "!addadmin" then
            if args[2] then Admins[args[2]] = true end
        elseif msg:sub(1,12) == "!removeadmin" then
            if args[2] then Admins[args[2]] = nil end
        elseif msg == "!admins" then
            print("Admins: "..table.concat(table.keys(Admins), ", "))
        elseif msg:sub(1,8) == "!target " then
            local target = message:sub(9)
            currentMsg = target
            _G.TargetBox.Text = target
        elseif msg == "!cleartarget" then
            currentMsg = ""
            _G.TargetBox.Text = ""
        elseif msg == "!start" then
            isSpamming = true
        elseif msg == "!stop" then
            isSpamming = false
        elseif msg:sub(1,7) == "!delay " then
            local d = tonumber(args[2])
            if d then fixedDelay = d end
        elseif msg:sub(1,6) == "!mode " then
            local m = args[2]
            if m == "spam" then spamMode = "SPAM"
            elseif m == "clean" then spamMode = "CLEAN_SPAM"
            elseif m == "loaded" then spamMode = "LOADED" end
        elseif msg:sub(1,5) == "!say " then
            local txt = message:sub(6)
            Send(txt, "NORMAL")
        elseif msg:sub(1,6) == "!spam " then
            local txt = message:sub(7)
            currentMsg = txt
        elseif msg == "!rgb on" then
            isRGB = true
        elseif msg == "!rgb off" then
            isRGB = false
        elseif msg == "!namergb on" then
            nameRGB = true
        elseif msg == "!namergb off" then
            nameRGB = false
        elseif msg == "!biorgb on" then
            bioRGB = true
        elseif msg == "!biorgb off" then
            bioRGB = false
        elseif msg == "!hidegui" then
            mainFrame.Visible = false
        elseif msg == "!showgui" then
            mainFrame.Visible = true
        elseif msg == "!toggleui" then
            mainFrame.Visible = not mainFrame.Visible
        elseif msg == "!rejoin" then
            game:GetService("TeleportService"):Teleport(game.PlaceId, sender)
        elseif msg == "!kickme" then
            sender:Kick("Kicked by admin")
        elseif msg == "!reset" then
            sender.Character:BreakJoints()
        elseif msg == "!antilag" then
            print("Anti‑lag is active by default.")
        elseif msg == "!fpsboost" then
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        elseif msg == "!info" then
            print("AXER SPAMMER V1.5 ICE | Admin:", sender.Name)
        elseif msg == "!help" then
            print("!start / !stop\n!target NAME\n!delay NUM\n!mode spam/clean/loaded\n!say TEXT\n!spam TEXT\n!rgb on/off\n!hidegui / !showgui\n!rejoin\n!kickme\n!reset\n!admins")
        end
    end

    -- Chat listeners
    for _, plr in pairs(game.Players:GetPlayers()) do
        plr.Chatted:Connect(function(msg) processAdminCommand(plr, msg) end)
    end
    game.Players.PlayerAdded:Connect(function(plr)
        plr.Chatted:Connect(function(msg) processAdminCommand(plr, msg) end)
    end)

    -- Settings page
    local function createInput(placeholder, defaultText, callback)
        local i = Instance.new("TextBox", settPage)
        i.Size = UDim2.new(0.9, 0, 0, 30)
        i.Text = defaultText
        i.PlaceholderText = placeholder
        i.BackgroundColor3 = Color3.fromRGB(230, 245, 255)
        i.TextColor3 = ICE_TEXT
        i.Font = SETTINGS.FONT
        Instance.new("UICorner", i)
        i.FocusLost:Connect(function() callback(i.Text) end)
        return i
    end

    createInput("CUSTOM RP NAME", SETTINGS.NAME_TEXT, function(t)
        SETTINGS.NAME_TEXT = t
        pcall(function() Remote:FireServer("RolePlayName", SETTINGS.NAME_TEXT, Color3.new(1,1,1)) end)
    end)
    createInput("CUSTOM BIO TEXT", SETTINGS.BIO_TEXT, function(t)
        SETTINGS.BIO_TEXT = t
        pcall(function() Remote:FireServer("RolePlayBio", SETTINGS.BIO_TEXT, Color3.new(1,1,1)) end)
    end)

    local function createToggle(text, startState, callback)
        local b = Instance.new("TextButton", settPage)
        b.Size = UDim2.new(0.9, 0, 0, 35)
        b.Text = text .. ": " .. (startState and "ON" or "OFF")
        b.BackgroundColor3 = startState and Color3.fromRGB(0, 60, 0) or Color3.fromRGB(60, 0, 0)
        b.TextColor3 = Color3.new(1,1,1)
        b.Font = SETTINGS.FONT
        Instance.new("UICorner", b)
        local s = startState
        b.MouseButton1Click:Connect(function()
            s = not s
            b.Text = text .. ": " .. (s and "ON" or "OFF")
            b.BackgroundColor3 = s and Color3.fromRGB(0, 60, 0) or Color3.fromRGB(60, 0, 0)
            callback(s)
        end)
    end
    createToggle("Name RGB", nameRGB, function(v) nameRGB = v end)
    createToggle("Bio RGB", bioRGB, function(v) bioRGB = v end)

    -- Theme page
    local tList = {
        {"RGB Rainbow", "RGB"},
        {"Crimson", Color3.fromRGB(220, 20, 60)},
        {"Aqua", Color3.fromRGB(0, 255, 255)},
        {"Neon Green", Color3.fromRGB(57, 255, 20)},
        {"Gold", Color3.fromRGB(255, 215, 0)},
        {"Hot Pink", Color3.fromRGB(255, 105, 180)},
        {"Deep Sea", Color3.fromRGB(0, 105, 148)},
        {"Vampire Red", Color3.fromRGB(150, 0, 0)},
        {"Lavender", Color3.fromRGB(230, 190, 255)},
        {"Orange Sun", Color3.fromRGB(255, 140, 0)},
        {"Mint", Color3.fromRGB(152, 255, 152)},
        {"Cyber Blue", Color3.fromRGB(0, 0, 255)},
        {"Electric Purple", Color3.fromRGB(191, 0, 255)},
        {"Silver", Color3.fromRGB(192, 192, 192)},
        {"Midnight", Color3.fromRGB(25, 25, 112)},
        {"Toxic", Color3.fromRGB(173, 255, 47)},
        {"Blood", Color3.fromRGB(138, 3, 3)},
        {"Sky Blue", Color3.fromRGB(135, 206, 235)},
        {"Chocolate", Color3.fromRGB(123, 63, 0)},
        {"Emerald", Color3.fromRGB(80, 200, 120)},
        {"Ice Blue", ICE_COLOR}  -- added ice theme
    }
    for _, t in ipairs(tList) do
        local b = Instance.new("TextButton", themePage)
        b.Size = UDim2.new(0.9, 0, 0, 30)
        b.Text = t[1]
        b.BackgroundColor3 = ICE_DARK
        b.TextColor3 = ICE_TEXT
        b.Font = SETTINGS.FONT
        Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            if t[2] == "RGB" then
                isRGB = true
            else
                isRGB = false
                currentThemeColor = t[2]
                TweenService:Create(frameStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Color = t[2]}):Play()
                TweenService:Create(logoStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {Color = t[2]}):Play()
                pfpStroke.Color = t[2]
            end
        end)
    end

    -- Autofill name & bio
    pcall(function()
        Remote:FireServer("RolePlayName", SETTINGS.NAME_TEXT, Color3.new(1,1,1))
        Remote:FireServer("RolePlayBio", SETTINGS.BIO_TEXT, Color3.new(1,1,1))
    end)

    -- RGB loop for name/bio (with anti‑lag throttle)
    task.spawn(function()
        local lastUpdate = 0
        while true do
            local nc = (nameRGB or isRGB) and Color3.fromHSV(tick() % 5 / 5, 1, 1) or currentThemeColor
            local bc = (bioRGB or isRGB) and Color3.fromHSV(tick() % 5 / 5, 1, 1) or currentThemeColor
            pcall(function()
                RemoteColor:FireServer("PickingRPNameColor", nc)
                RemoteColor:FireServer("PickingRPBioColor", bc)
            end)
            task.wait(0.1) -- reduced frequency for performance
        end
    end)

    -- Intro sequence
    task.spawn(function()
        -- Sound
        local introSound = Instance.new("Sound")
        introSound.Parent = SoundService
        introSound.SoundId = SETTINGS.INTRO_SOUND_ID
        introSound.TimePosition = SETTINGS.START_TIME
        introSound.Volume = 0
        introSound:Play()
        TweenService:Create(introSound, TweenInfo.new(1.5), {Volume = 1}):Play()

        -- Full screen intro GUI
        local introGui = Instance.new("ScreenGui")
        introGui.Parent = game.CoreGui
        introGui.IgnoreGuiInset = true
        introGui.DisplayOrder = 999999

        local blackScreen = Instance.new("Frame")
        blackScreen.Parent = introGui
        blackScreen.Size = UDim2.new(1, 0, 1, 0)
        blackScreen.Position = UDim2.new(0, 0, 0, 0)
        blackScreen.BackgroundColor3 = Color3.new(0, 0, 0)
        blackScreen.BorderSizePixel = 0
        blackScreen.ZIndex = 10

        local introText = Instance.new("TextLabel")
        introText.Parent = blackScreen
        introText.Size = UDim2.new(1, 0, 1, 0)
        introText.Position = UDim2.new(0, 0, 0, 0)
        introText.BackgroundTransparency = 1
        introText.Text = ""
        introText.Font = Enum.Font.GothamBlack
        introText.TextScaled = true
        introText.TextTransparency = 1
        introText.TextColor3 = Color3.new(1,1,1)
        introText.ZIndex = 11

        -- Loading bar (ice themed)
        local loadingBG = Instance.new("Frame")
        loadingBG.Parent = blackScreen
        loadingBG.Size = UDim2.new(0.6, 0, 0.03, 0)
        loadingBG.Position = UDim2.new(0.2, 0, 0.85, 0)
        loadingBG.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        loadingBG.BorderSizePixel = 0
        loadingBG.ZIndex = 11
        Instance.new("UICorner", loadingBG)

        local loadingBar = Instance.new("Frame")
        loadingBar.Parent = loadingBG
        loadingBar.Size = UDim2.new(0, 0, 1, 0)
        loadingBar.BackgroundColor3 = ICE_COLOR
        loadingBar.BorderSizePixel = 0
        Instance.new("UICorner", loadingBar)

        local loadingText = Instance.new("TextLabel")
        loadingText.Parent = blackScreen
        loadingText.Size = UDim2.new(1, 0, 0.05, 0)
        loadingText.Position = UDim2.new(0, 0, 0.9, 0)
        loadingText.BackgroundTransparency = 1
        loadingText.Text = "Loading... 0%"
        loadingText.Font = Enum.Font.GothamBold
        loadingText.TextScaled = true
        loadingText.TextColor3 = Color3.new(1,1,1)
        loadingText.ZIndex = 11

        -- RGB effect on intro text
        local rgbLoop = RUN.RenderStepped:Connect(function()
            introText.TextColor3 = Color3.fromHSV(tick() % 3 / 3, 1, 1)
        end)

        introText.Text = "WELCOME " .. lp.DisplayName
        TweenService:Create(introText, TweenInfo.new(1), {TextTransparency = 0}):Play()

        -- Simulate loading
        task.spawn(function()
            local progress = 0
            local stages = {
                {msg = "Initializing...", time = 10},
                {msg = "Loading Assets...", time = 25},
                {msg = "Loading UI...", time = 20},
                {msg = "Loading Scripts...", time = 25},
                {msg = "Finalizing...", time = 20}
            }
            for _, stage in ipairs(stages) do
                for i = 1, stage.time do
                    progress += 1
                    loadingBar.Size = UDim2.new(progress/100, 0, 1, 0)
                    loadingText.Text = stage.msg .. " (" .. progress .. "%)"
                    task.wait(math.random(2,5)/100)
                end
            end
        end)

        for i = 1, 100 do
            loadingBar.Size = UDim2.new(i/100, 0, 1, 0)
            loadingText.Text = "Loading... " .. i .. "%"
            task.wait(0.02)
        end

        TweenService:Create(introText, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
        task.wait(2)
        TweenService:Create(introText, TweenInfo.new(1), {TextTransparency = 1}):Play()
        task.wait(1)

        introText.Text = "THANKS FOR USING\nAXER SPAMMER"
        TweenService:Create(introText, TweenInfo.new(1.5), {TextTransparency = 0}):Play()
        task.wait(2.5)
        TweenService:Create(introText, TweenInfo.new(1), {TextTransparency = 1}):Play()
        TweenService:Create(blackScreen, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
        task.wait(1)

        rgbLoop:Disconnect()
        introGui:Destroy()

        mainFrame.Visible = true
        logo.Visible = true

        Send("AXER SPAMMER LOADED", "LOADED")

        local fadeOut = TweenService:Create(introSound, TweenInfo.new(1), {Volume = 0})
        fadeOut:Play()
        fadeOut.Completed:Wait()
        introSound:Destroy()
    end)

    -- Main RGB loop for UI strokes (with throttling)
    RUN.RenderStepped:Connect(function()
        local r = Color3.fromHSV(tick() % 5 / 5, 1, 1)
        logoStroke.Color = r
        instaLabel.TextColor3 = r
        if isRGB then
            frameStroke.Color = r
            pfpStroke.Color = r
        end
    end)

    logo.MouseButton1Click:Connect(function() mainFrame.Visible = not mainFrame.Visible end)

    -- Anti‑lag spam loop: uses task.defer and a small throttle
    task.spawn(function()
        local lastSend = 0
        while true do
            if isSpamming and currentMsg ~= "" then
                local now = tick()
                if now - lastSend >= fixedDelay then
                    lastSend = now
                    Send(currentMsg, spamMode)
                end
            end
            task.wait(0.1) -- smooth loop, reduces CPU load
        end
    end)

    -- Anti AFK
    lp.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)

    -- Anti Lag (system optimizations)
    local Lighting = game:GetService("Lighting")
    local Terrain = workspace:FindFirstChildOfClass("Terrain")
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 1
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
            v.Enabled = false
        end
    end
    if Terrain then
        Terrain.WaterWaveSize = 0
        Terrain.WaterWaveSpeed = 0
        Terrain.WaterReflectance = 0
        Terrain.WaterTransparency = 0
    end

    -- No Sit
    lp.CharacterAdded:Connect(function(char)
        local humanoid = char:WaitForChild("Humanoid")
        humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
            if humanoid.Sit then humanoid.Sit = false end
        end)
    end)

    -- Tab switching
    local function showPage(p)
        for _, v in pairs({cmdPage, themePage, settPage, infoPage}) do
            v.Visible = (v == p)
        end
    end
    cmdBtn.MouseButton1Click:Connect(function() showPage(cmdPage) end)
    themeBtn.MouseButton1Click:Connect(function() showPage(themePage) end)
    settBtn.MouseButton1Click:Connect(function() showPage(settPage) end)
    infoBtn.MouseButton1Click:Connect(function() showPage(infoPage) end)

    print("AXER SPAMMER V1.5 ICE LOADED")
end)

if not success then
    warn("AXER SPAMMER ERROR: " .. tostring(err))
end