--< THIS IS A LOCAL SCRIPT AHH >--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Handshake = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Handshake")

while task.wait(60) do
	Handshake:FireServer()
end
