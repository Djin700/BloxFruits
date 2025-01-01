local plr = game:GetService("Players").LocalPlayer
local blockname = {"Banana","Pineapple","Apple"}

local FarmSpeed = 1
local ServerHop = true

-- if _G.FarmSpeed ~= nil then
-- 	FarmSpeed = _G.FarmSpeed
-- end

-- if _G.ServerHop ~= nil then
-- 	ServerHop = _G.ServerHop
-- end

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer
local placeId = game.PlaceId

local function getRandomServer(placeId)
    -- Получаем список серверов
    local response = TeleportService:GetPlayerPlaceInstanceAsync(Players.LocalPlayer.UserId, placeId)
    
    if response and #response > 0 then
        -- Выбираем случайный сервер из списка
        local randomIndex = math.random(1, #response)
        return response[randomIndex].PlaceId, response[randomIndex].JobId
    else
        return nil
    end
end

local function ServerHop()
    while task.wait(0.1) do
	    local randomPlaceId, randomJobId = getRandomServer(placeId)
	    if randomPlaceId and randomJobId then
	        TeleportService:Teleport(randomPlaceId, player)
	    else
	        warn("Не удалось получить случайный сервер.")
	    end
    end
end

local function SetTeam()
	local args = {
	    [1] = "SetTeam",
	    [2] = "Marines"
	}
	
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

local function Store()
	print("Попытка сложить фрукты⚠")
	task.wait(0.5)
	for i,v in plr.Backpack:GetChildren() do
		if v:IsA("Tool") then
			local args = {
				[1] = "",
				[2] = "",
				[3] = "",
			}
			local name = string.split(v.Name," ")
			args[1] = "StoreFruit"
			args[2]= tostring(name[1].."-"..name[1])
			args[3] = v

			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end
	end
	for i,v in plr.Character:GetChildren() do
		if v:IsA("Tool") then
			local args = {
				[1] = "",
				[2] = "",
				[3] = "",
			}
			local name = string.split(v.Name," ")
			args[1] = "StoreFruit"
			args[2]= tostring(name[1].."-"..name[1])
			args[3] = v
			
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
		end
	end
	print("Фрукты успешно сложены✔")
end

local function RandomFruit()
	local args = {
		[1] = "Cousin",
		[2] = "Buy"
	}
	game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
end

local function Finder()
	for _,fruit in workspace:GetChildren() do
		if (fruit:IsA("Tool") or fruit:IsA("Model") and fruit.Name == "Fruit") and fruit.Name ~= blockname[1] and  fruit.Name ~= blockname[2] and fruit.Name ~= blockname[3] then
			local Handle = fruit:FindFirstChild("Handle")
			for i=1,10 do
				if Handle and plr.Character then
					plr.Character.HumanoidRootPart.CFrame = Handle.CFrame*CFrame.new(math.random(0.1,0.2),0,math.random(0.1,0.2))
					task.wait(0.15)
				elseif Handle == nil and plr.Character then
					local currentpart = nil
					for _,handlepart in fruit:GetDescendants() do
						if handlepart:IsA("BasePart") then
							currentpart = handlepart
							break
						end
					end
					if currentpart then
					plr.Character.HumanoidRootPart.CFrame = currentpart.CFrame*CFrame.new(math.random(0.1,0.2),0,math.random(0.1,0.2))
					task.wait(0.15)
					end
				end
			end
			task.wait(FarmSpeed)
		end
	end
	RandomFruit()
	Store()
	task.wait(5)
	print("Hop!")
	ServerHop()
end

SetTeam()
task.wait(5)
Finder()
