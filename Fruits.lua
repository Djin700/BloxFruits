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

local Http = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local Api = "https://games.roblox.com/v1/games/"
local _place,_id = game.PlaceId, game.JobId
local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=10"

local function ServerList(cursor)
	local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
	return Http:JSONDecode(Raw)
end

local function ServerHop()
	local Servers = ServerList()
	local Server = Servers.data[math.random(1,#Servers.data)]
	TPS:TeleportToPlaceInstance(_place, Server.id, plr)
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
			for i=1,3 do
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
	task.delay(5,function()
		for i=1,50 do
			ServerHop()
		end
	end)
end

Finder()
