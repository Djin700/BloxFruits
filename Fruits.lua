local plr = game:GetService("Players").LocalPlayer
local fruitsname = {"Banana","Pineapple","Apple"}
local FarmSpeed = 1 --Seconds

local function Finder()
	for _,fruit in workspace:GetChildren() do
		if (fruit:IsA("Tool") or fruit:IsA("Model") and fruit.Name == "Fruit") and fruit.Name ~= fruitsname[1] and  fruit.Name ~= fruitsname[2] and fruit.Name ~= fruitsname[3] then
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
					else
						print("Dalbaeb Tupoi!")
					end
				end
			end
			task.wait(FarmSpeed)
		end
	end
	print("Stopped!")
end

Finder()
