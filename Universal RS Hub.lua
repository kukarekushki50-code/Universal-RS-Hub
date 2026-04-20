local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ROSTICKK BS | Universal",
   LoadingTitle = "Загрузка системы...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RostickkConfigs"
   }
})

-- Глобальные настройки
local Toggles = {
    Noclip = false,
    NoFall = false,
    GodMode = false,
    Fly = false,
    AutoCollect = false,
    InfJump = false,
    Fullbright = false,
    SpinBot = false,
    ClickTP = false,
    SuperSpeed = false
}

local FlySpeed = 50
local CurrentNormalSpeed = 16

-- [Раздел: Основное (Main)]
local MainTab = Window:CreateTab("Основные", 4483362458)

-- 1. Настроенный God Mode
MainTab:CreateToggle({
   Name = "Universal God Mode",
   CurrentValue = false,
   Callback = function(Value)
      Toggles.GodMode = Value
      if Value then
          task.spawn(function()
              while Toggles.GodMode do
                  local char = game.Players.LocalPlayer.Character
                  local hum = char and char:FindFirstChildOfClass("Humanoid")
                  if hum then
                      hum.MaxHealth = math.huge
                      hum.Health = math.huge
                      hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                  end
                  task.wait(0.1)
              end
          end)
          Rayfield:Notify({Title = "God Mode", Content = "Улучшенный режим бога включен", Duration = 3})
      end
   end,
})

-- 2. WalkSpeed (Обычный слайдер)
MainTab:CreateSlider({
   Name = "Настройка скорости",
   Range = {16, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Callback = function(Value)
      CurrentNormalSpeed = Value
      if not Toggles.SuperSpeed and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
          game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- 2.1 НОВЫЙ ПЕРЕКЛЮЧАТЕЛЬ: Скорость 1 Квадриллион
MainTab:CreateToggle({
   Name = "Скорость 1 Квадриллиард",
   CurrentValue = false,
   Callback = function(Value)
      Toggles.SuperSpeed = Value
      local hum = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
      if hum then
          if Value then
              hum.WalkSpeed = 1e15 -- 1 квадриллион
              Rayfield:Notify({Title = "Super Speed", Content = "Скорость установлена на максимум!", Duration = 3})
          else
              hum.WalkSpeed = CurrentNormalSpeed -- Возврат к значению из слайдера
          end
      end
   end,
})

-- 3. Noclip
MainTab:CreateToggle({
   Name = "Noclip (Сквозь стены)",
   CurrentValue = false,
   Callback = function(Value)
      Toggles.Noclip = Value
      game:GetService("RunService").Stepped:Connect(function()
          if Toggles.Noclip and game.Players.LocalPlayer.Character then
              for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                  if v:IsA("BasePart") then v.CanCollide = false end
              end
          end
      end)
   end,
})

-- 4. Fly (Q - Вверх, E - Вниз)
MainTab:CreateToggle({
   Name = "Fly (Q - Вверх, E - Вниз)",
   CurrentValue = false,
   Callback = function(Value)
      Toggles.Fly = Value
      local lp = game.Players.LocalPlayer
      local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
      if Value and hrp then
          local bv = Instance.new("BodyVelocity", hrp)
          bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
          bv.Velocity = Vector3.new(0, 0, 0)
          bv.Name = "GeminiFly"
          task.spawn(function()
              while Toggles.Fly do
                  local dir = Vector3.new(0,0,0)
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Q) then dir = dir + Vector3.new(0, 1, 0) end
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.E) then dir = dir + Vector3.new(0, -1, 0) end
                  local camDir = workspace.CurrentCamera.CFrame.LookVector
                  if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                      bv.Velocity = camDir * FlySpeed + dir * FlySpeed
                  else
                      bv.Velocity = dir * FlySpeed
                  end
                  task.wait()
              end
              if bv then bv:Destroy() end
          end)
      elseif hrp and hrp:FindFirstChild("GeminiFly") then
          hrp.GeminiFly:Destroy()
      end
   end,
})

-- 5. Optimized Universal Collect Items
MainTab:CreateToggle({
   Name = "Universal Collect Items",
   CurrentValue = false,
   Callback = function(Value)
       Toggles.AutoCollect = Value
       task.spawn(function()
           while Toggles.AutoCollect do
               local char = game.Players.LocalPlayer.Character
               local hrp = char and char:FindFirstChild("HumanoidRootPart")
               if hrp then
                   for _, v in pairs(workspace:GetDescendants()) do
                       if not Toggles.AutoCollect then break end
                       if v:IsA("TouchTransmitter") and v.Parent then
                           firetouchinterest(hrp, v.Parent, 0)
                           firetouchinterest(hrp, v.Parent, 1)
                       end
                   end
               end
               task.wait(1.5)
           end
       end)
   end,
})

-- 6. Click Teleport (Ctrl + Click)
MainTab:CreateToggle({
    Name = "Click TP (Ctrl + ЛКМ)",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.ClickTP = Value
        local UserInputService = game:GetService("UserInputService")
        local player = game.Players.LocalPlayer
        local mouse = player:GetMouse()
        mouse.Button1Down:Connect(function()
            if Toggles.ClickTP and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                if mouse.Target then
                    player.Character:MoveTo(mouse.Hit.p)
                end
            end
        end)
    end,
})

-- 7. SpinBot
MainTab:CreateToggle({
    Name = "SpinBot (Крутилка)",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.SpinBot = Value
        task.spawn(function()
            while Toggles.SpinBot do
                local char = game.Players.LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(50), 0)
                end
                task.wait()
            end
        end)
    end,
})

-- 8. Gravity Slider
MainTab:CreateSlider({
    Name = "Гравитация",
    Range = {0, 196},
    Increment = 1,
    Suffix = "Gravity",
    CurrentValue = 196,
    Callback = function(Value)
        workspace.Gravity = Value
    end,
})

-- 9. Anti-AFK
MainTab:CreateButton({
    Name = "Активировать Anti-AFK",
    Callback = function()
        local VirtualUser = game:GetService("VirtualUser")
        game.Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        Rayfield:Notify({Title = "Anti-AFK", Content = "Теперь тебя не кикнет за бездействие", Duration = 3})
    end,
})

-- 10. Дополнительные визуалы и прыжок
MainTab:CreateToggle({
    Name = "Бесконечный прыжок",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.InfJump = Value
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if Toggles.InfJump then
                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end,
})

MainTab:CreateToggle({
    Name = "Fullbright (Свет)",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.Fullbright = Value
        if Value then
            game.Lighting.Ambient = Color3.new(1, 1, 1)
            game.Lighting.Brightness = 2
            game.Lighting.GlobalShadows = false
        else
            game.Lighting.GlobalShadows = true
        end
    end,
})

-- [Раздел: Внешние скрипты]
local ScriptsTab = Window:CreateTab("Внешние скрипты", 4483362458)

ScriptsTab:CreateSection("Популярное")

ScriptsTab:CreateButton({
   Name = "Infinite Yield (Админка)",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})

ScriptsTab:CreateButton({
   Name = "The Button",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/Scripts/refs/heads/main/TheButton.lua"))()
   end,
})

ScriptsTab:CreateSection("Murder Mystery 2")

ScriptsTab:CreateButton({
   Name = "MM2 Loader (V5 / Normalniy)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/doloword-hash/botscriptts.3/refs/heads/main/NORMALNIYHUB.lua"))()
   end,
})

Rayfield:LoadConfiguration()