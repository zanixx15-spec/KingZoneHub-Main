local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local MainWindow = Rayfield:CreateWindow({
   Name = "KingZoneHub",
   Icon = 0,
   LoadingTitle = "Loading . . .",
   LoadingSubtitle = "by Leo",
   ShowText = "KingZone",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "KingZone Hub"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },

   KeySystem = false,
   KeySettings = {
      Title = "KingZoneHub",
      Subtitle = "Key System",
      Note = "Key for tg@Leogametop",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello,Zero,Hero"}
   }
})

-- Tab များ ဖန်တီးခြင်း
local MainTab = MainWindow:CreateTab("Main", 4483362458)
local SettingTab = MainWindow:CreateTab("Setting", 4483362458) -- Tab အသစ်

Rayfield:Notify({
   Title = "LeoHub",
   Content = "Ready For Use",
   Duration = 6.5,
   Image = 4483362458,
})

---------------------------------------------------------
-- [MAIN TAB] - ESP TOGGLE
---------------------------------------------------------
local ESPConnection
MainTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
      local Players = game:GetService("Players")
      local LocalPlayer = Players.LocalPlayer

      local function removeESP()
         for _, p in ipairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("PlayerESP") then
               p.Character.PlayerESP:Destroy()
            end
         end
      end

      if Value then
         local function addESP(player)
            if player == LocalPlayer then return end

            local function apply(char)
               if not char or char:FindFirstChild("PlayerESP") then return end
               char:WaitForChild("HumanoidRootPart", 5)
               
               local highlight = Instance.new("Highlight")
               highlight.Name = "PlayerESP"
               highlight.FillColor = Color3.fromRGB(255, 0, 0)
               highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
               highlight.FillTransparency = 0.5
               highlight.OutlineTransparency = 0
               highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
               highlight.Parent = char
            end

            if player.Character then apply(player.Character) end
            player.CharacterAdded:Connect(apply)
         end

         for _, p in ipairs(Players:GetPlayers()) do addESP(p) end
         ESPConnection = Players.PlayerAdded:Connect(addESP)
      else
         if ESPConnection then ESPConnection:Disconnect() end
         removeESP()
      end
   end,
})

---------------------------------------------------------
-- [MAIN TAB] - AIMASSIST TOGGLE
---------------------------------------------------------
local AimAssistLoop
MainTab:CreateToggle({
   Name = "AimAssist",
   CurrentValue = false,
   Flag = "Toggle2",
   Callback = function(Value)
      local RunService = game:GetService("RunService")
      local Players = game:GetService("Players")
      local LocalPlayer = Players.LocalPlayer
      local Camera = workspace.CurrentCamera

      local FOV = 150
      local Smoothness = 0.3

      local function GetTarget()
         local closest
         local shortest = FOV

         for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
               local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
               local head = player.Character:FindFirstChild("Head")

               if humanoid and head and humanoid.Health > 0 then
                  local pos, visible = Camera:WorldToViewportPoint(head.Position)

                  if visible then
                     local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                     local distance = (Vector2.new(pos.X, pos.Y) - center).Magnitude

                     if distance < shortest then
                        shortest = distance
                        closest = head
                     end
                  end
               end
            end
         end
         return closest
      end

      if Value then
         AimAssistLoop = RunService.RenderStepped:Connect(function()
            local target = GetTarget()
            if target then
               local goal = CFrame.lookAt(Camera.CFrame.Position, target.Position)
               Camera.CFrame = Camera.CFrame:Lerp(goal, Smoothness)
            end
         end)
      else
         if AimAssistLoop then
            AimAssistLoop:Disconnect()
         end
      end
   end,
})

---------------------------------------------------------
-- [SETTING TAB] - GODMODE TOGGLE
---------------------------------------------------------
local GodmodeLoop
SettingTab:CreateToggle({
   Name = "Godmode",
   CurrentValue = false,
   Flag = "ToggleGodmode",
   Callback = function(Value)
      local Players = game:GetService("Players")
      local RunService = game:GetService("RunService")
      local LocalPlayer = Players.LocalPlayer

      if Value then
         GodmodeLoop = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
               local humanoid = char:FindFirstChildOfClass("Humanoid")
               if humanoid then
                  humanoid.Health = humanoid.MaxHealth
               end

               for _, part in ipairs(char:GetDescendants()) do
                  if part:IsA("BasePart") then
                     part.CanTouch = true
                     for _, child in ipairs(part:GetChildren()) do
                        if child:IsA("TouchTransmitter") then
                           child:Destroy()
                        end
                     end
                  end
               end
            end
         end)
      else
         if GodmodeLoop then
            GodmodeLoop:Disconnect()
         end
      end
   end,
})

---------------------------------------------------------
-- [SETTING TAB] - INFINITE JUMP TOGGLE
---------------------------------------------------------
local JumpConnection
SettingTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "Toggle3",
   Callback = function(Value)
      local UserInputService = game:GetService("UserInputService")
      local LocalPlayer = game:GetService("Players").LocalPlayer

      if Value then
         JumpConnection = UserInputService.JumpRequest:Connect(function()
            local character = LocalPlayer.Character
            if character then
               local humanoid = character:FindFirstChildOfClass("Humanoid")
               if humanoid then
                  humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
               end
            end
         end)
      else
         if JumpConnection then
            JumpConnection:Disconnect()
         end
      end
   end,
})

---invisible toggle
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Invisibility နဲ့ Name Tag ကို ထိန်းချုပ်မယ့် function
local function setInvisibility(isInvisible)
	local character = LocalPlayer.Character
	if not character then return end

	local targetTransparency = isInvisible and 1 or 0

	-- ၁။ Character ခန္ဓာကိုယ်နဲ့ Accessory များကို Invisible/Visible လုပ်ခြင်း
	for _, descendant in ipairs(character:GetDescendants()) do
		if descendant:IsA("BasePart") then
			if descendant.Name ~= "HumanoidRootPart" then
				descendant.Transparency = targetTransparency
			end
		elseif descendant:IsA("Decal") then
			descendant.Transparency = targetTransparency
		end
	end

	-- ၂။ ခေါင်းပေါ်က Display Name (Name Tag) ကို ကွယ်ခြင်း/ဖော်ခြင်း
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		if isInvisible then
			humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		else
			humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
		end
	end
end

-- UI Toggle
local Toggle = SettingTab:CreateToggle({
	Name = "Invisible",
	CurrentValue = false,
	Flag = "Toggle4",
	Callback = function(Value)
		setInvisibility(Value)
	end,
})

-- Player သေပြီး ပြန်ယှဉ်လာပါက (Respawn) Toggle အခြေအနေအတိုင်း စစ်ပေးရန်
LocalPlayer.CharacterAdded:Connect(function(character)
	task.wait(0.5) -- Character လုံးဝ load ဖြစ်အောင် ခဏစောင့်မည်
	if Toggle.CurrentValue then
		setInvisibility(true)
	end
end)