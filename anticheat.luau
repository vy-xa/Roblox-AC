--< THIS SHOULD BE A MODULE SCRIPTTT >--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local Handshake = Remotes:WaitForChild("Handshake")
local BaitRemote = Remotes:WaitForChild("GiveAdminToCurrentClient")

local AntiCheat = {}
local playerData = {}

local MAX_SPEED = 100 --< studs/sec >--
local HANDSHAKE_TIMEOUT = 90

local WHITELISTED_USERIDS = {
	--< put id of admin/owner here or sum like that >--
}

local function isWhitelisted(player)
	return table.find(WHITELISTED_USERIDS, player.UserId) ~= nil
end

function AntiCheat:InitPlayer(player)
	local data = {
		LastPos = nil,
		LastCheck = tick(),
		LastHandshake = tick()
	}
	playerData[player] = data

	player.CharacterAdded:Connect(function(char)
		local hrp = char:WaitForChild("HumanoidRootPart", 5)
		if not hrp then return end

		data.LastPos = hrp.Position
		data.LastCheck = tick()

		RunService.Heartbeat:Connect(function()
			if not player or not player.Parent then return end
			if isWhitelisted(player) then return end

			local current = hrp.Position
			local now = tick()
			local dt = now - data.LastCheck

			local dist = (current - data.LastPos).Magnitude
			local speed = dist / dt

			if speed > MAX_SPEED then
				warn(player.Name .. " speed: " .. speed)
				player:Kick("ps tampering detected.")
			end

			data.LastPos = current
			data.LastCheck = now
		end)
	end)
end

function AntiCheat:Init()
	Handshake.OnServerEvent:Connect(function(player)
		if playerData[player] then
			playerData[player].LastHandshake = tick()
		end
	end)

	BaitRemote.OnServerEvent:Connect(function(player)
		if isWhitelisted(player) then return end
		warn(player.Name .. " fired a bait remote!")
		player:Kick("BUDDY FELL FOR BAIT AHAHAHAH.")
	end)

	task.spawn(function()
		while true do
			for player, data in pairs(playerData) do
				if isWhitelisted(player) then continue end
				if tick() - data.LastHandshake > HANDSHAKE_TIMEOUT then
					warn(player.Name .. " failed handshake timeout")
					player:Kick("no handshake")
				end
			end
			task.wait(30)
		end
	end)

	Players.PlayerAdded:Connect(function(player)
		self:InitPlayer(player)
	end)

	Players.PlayerRemoving:Connect(function(player)
		playerData[player] = nil
	end)

	print("init.")
end

return AntiCheat
