local plr = game:GetService("Players").LocalPlayer
local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")

local blocklist = {'Banana','Pineapple','Apple'}

local DefSettings = _G.FruitFarmSettings
local FarmSpeed = DefSettings.FarmSpeed
local ServerHop = DefSettings.ServerHop
local RandomFruit = DefSettings.RandomFruit
local Team = DefSettings.Team

print("Скрипт загружен!")
task.wait(1)

local function ServerHop()
	local Player = game.Players.LocalPlayer    
	local Http = game:GetService("HttpService")
	local TPS = game:GetService("TeleportService")
	local Api = "https://games.roblox.com/v1/games/"

	local _place,_id = game.PlaceId, game.JobId
	local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=50"

	local function ListServers(cursor)
		local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
		return Http:JSONDecode(Raw)
	end

	while wait(1) do
		local Servers = ListServers()
		local Server = Servers.data[math.random(1,#Servers.data)]
		TPS:TeleportToPlaceInstance(_place, Server.id, Player)
	end
end

local function SetTeam()
	print("Команда сменена!")
	remote:InvokeServer("SetTeam",tostring(Team))
end

local function RandomFruit()
	print("Рандомный фрукт куплен!")
	remote:InvokeServer("Cousin","Buy")
end

local function Store()
	print("Попытка сложить фрукты⚠")
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

			remote:InvokeServer(unpack(args))
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

			remote:InvokeServer(unpack(args))
		end
	end
	print("Фрукты успешно сложены✔")
end

local function FindHandle(Model)
	local current = nil

	for i,part in Model:GetDescendants() do
		if part:IsA("BasePart") or part:IsA("UnionOperation") or part:IsA("MeshPart") then
			current = part
			break
		end
	end

	return current
end

local function Finder()
	for _,fruit in workspace:GetDescendants() do
		if fruit:IsA("Model") and fruit.Name == "Fruit" and not fruit.Parent:FindFirstChild("Humanoid") or fruit:IsA("Tool") and not table.find(blocklist,fruit.Name) and not fruit.Parent:FindFirstChild("Humanoid") then
			local currentpart = FindHandle(fruit)

			print(currentpart)

			if currentpart ~= nil then
				for i=1,3 do
					plr.Character.HumanoidRootPart.CFrame = currentpart.CFrame*CFrame.new(math.random(0.1,0.2),0,math.random(0.1,0.2))
					task.wait(0.15)
				end
			end

			print("Fruit found!")
			task.wait(FarmSpeed)
		end
	end
	task.spawn(function()
		if RandomFruit == true then RandomFruit() end
		task.wait(0.5)
		Store()
		task.wait(1)
		if ServerHop == true then ServerHop() end
	end)
end

SetTeam()
task.wait(5)
Finder()
