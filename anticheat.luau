--< THIS SHOULD BE A MODULE SCRIPTTT >--

local Players = game:GetService("Players") --< players >--
local RunService = game:GetService("RunService") --< for the heartbeat >--
local ReplicatedStorage = game:GetService("ReplicatedStorage") --< rep storage >--

local Remotes = ReplicatedStorage:WaitForChild("Remotes") --< remote events >--
local Handshake = Remotes:WaitForChild("Handshake") --< if u don't shake u fake >--
local BaitRemote = Remotes:WaitForChild("GiveAdminToCurrentClient") --< bait remote for npcs with no rizzy >--

local AntiCheat = {}
local playerData = {}

local MAX_SPEED = 100 --< max skibidi speed limit >--
local HANDSHAKE_TIMEOUT = 90 --< timer for handshakes or u get kicked >--

local WHITELISTED_USERIDS = {
	--< put id of owner/admin here, the ones with certified rizz >--
}

local function isWhitelisted(player)
	return table.find(WHITELISTED_USERIDS, player.UserId) ~= nil --< w rizz? (checks whitelisted) >--
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
			if isWhitelisted(player) then return end --< checking if admin or nah >--

			local current = hrp.Position
			local now = tick()
			local dt = now - data.LastCheck

			local dist = (current - data.LastPos).Magnitude
			local speed = dist / dt

			if speed > MAX_SPEED then
				warn(player.Name .. " speed: " .. speed) --< bro tryin to be fast or sum >--
				player:Kick("ps tampering detected.") --< kicked ez >--
			end

			data.LastPos = current
			data.LastCheck = now
		end)
	end)
end

function AntiCheat:Init()
	Handshake.OnServerEvent:Connect(function(player)
		if playerData[player] then
			playerData[player].LastHandshake = tick() --< check if shake is valid >--
		end
	end)

	BaitRemote.OnServerEvent:Connect(function(player)
		if isWhitelisted(player) then return end --< incase some stupid admin tries >--
		warn(player.Name .. " fired a bait remote!") --< bro thinks he slick >--
		player:Kick("BUDDY FELL FOR BAIT AHAHAHAH.") --< gottem >--
	end)

	task.spawn(function()
		while true do
			for player, data in pairs(playerData) do
				if isWhitelisted(player) then continue end --< rizzed bros still safe >--
				if tick() - data.LastHandshake > HANDSHAKE_TIMEOUT then
					warn(player.Name .. " failed handshake timeout") --< bro forgot to shake dat assssss >--
					player:Kick("no handshake") --< handshake or handshake outta here >--
				end
			end
			task.wait(30) --< wait a lil before checking  >--
		end
	end)

	Players.PlayerAdded:Connect(function(player)
		self:InitPlayer(player) --< new player detectection software p100 >--
	end)

	Players.PlayerRemoving:Connect(function(player)
		playerData[player] = nil --< clean up >--
	end)

	print("init.") --< initialisation print >--
end

return AntiCheat
