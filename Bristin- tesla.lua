-- Загружаем UI библиотеку Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Bristin HUB | Car Hover",
   LoadingTitle = "Загрузка физики...",
   LoadingSubtitle = "by Mirofun",
   ConfigurationSaving = { Enabled = false }
})

local isHovering = false
local hoverForce = 50 -- Сила подкидывания

local HoverTab = Window:CreateTab("Авто-Ховер", 4483362458)
HoverTab:CreateSection("Настройки полета")

-- Слайдер силы
HoverTab:CreateSlider({
   Name = "Сила подлета",
   Range = {10, 200},
   Increment = 10,
   Suffix = " force",
   CurrentValue = 50,
   Callback = function(Value) hoverForce = Value end,
})

-- Кнопка включения
HoverTab:CreateToggle({
   Name = "ВКЛ/ВЫКЛ АВТО-ПОДЛЕТ",
   CurrentValue = false,
   Callback = function(State)
       isHovering = State
       
       if isHovering then
           task.spawn(function()
               while isHovering do
                   pcall(function()
                       local char = game.Players.LocalPlayer.Character
                       if char then
                           -- Ищем машину (обычно это VehicleSeat или сам объект машины)
                           local seat = char:FindFirstChildOfClass("Humanoid") and char.Humanoid.SeatPart
                           
                           if seat then
                               local carModel = seat.Parent
                               -- Ищем главную часть машины (PrimaryPart или корпус)
                               local carRoot = carModel.PrimaryPart or carModel:FindFirstChild("CarRoot") or carModel:FindFirstChild("Chassis")
                               
                               if not carRoot then
                                   -- Если не нашли, берем любую часть с массой
                                   for _, v in pairs(carModel:GetDescendants()) do
                                       if v:IsA("BasePart") and v.Mass > 1 then
                                           carRoot = v
                                           break
                                       end
                                   end
                               end
                               
                               if carRoot then
                                   -- Подкидываем машину вверх
                                   carRoot.AssemblyLinearVelocity = Vector3.new(
                                       carRoot.AssemblyLinearVelocity.X, 
                                       hoverForce, -- Импульс вверх
                                       carRoot.AssemblyLinearVelocity.Z
                                   )
                               end
                           end
                       end
                   end)
                   task.wait(0.1) -- Частота обновления
               end
           end)
       end
   end,
})

Rayfield:Notify({
   Title = "Bristin HUB",
   Content = "Физика загружена! Садись в машину и включай.",
   Duration = 5,
   Image = 4483362458,
})