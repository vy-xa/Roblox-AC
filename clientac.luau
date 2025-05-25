--< THIS IS A LOCAL SCRIPT AHH >--

local ReplicatedStorage = game:GetService("ReplicatedStorage") --< rep storage >--
local Handshake = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Handshake") --< handshake remote >--

while task.wait(60) do --< every 60 seconds >--
	Handshake:FireServer() --< handshake event firing >--
end
