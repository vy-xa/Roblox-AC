--< THIS SHOULD BE A SCRIPT SCRIPT >--

remoteFolder = Instance.new("Folder") --< makin the folder for remotes >--
remoteFolder.Name = "Remotes" --< naming to remotes >--

remote1 = Instance.new("RemoteEvent") --< first remote >--
remote2 = Instance.new("RemoteEvent") --< second remote >--

remote1.Name = "GiveAdminToCurrentClient" --< bait remote >--
remote2.Name = "Handshake" --< hanshake event >--

remote1.Parent = remoteFolder --< put into storage >--
remote2.Parent = remoteFolder --< put into storage >--

script.Parent.InitAC.Parent = game:GetService("ServerScriptService") --< move init script to ss >--
script.Parent.ClientAC.Parent = game:GetService("StarterPlayer").StarterPlayerScripts --< client anti cheat to the player scripts >--
script.Parent.Anticheat.Parent = game:GetService("ServerScriptService") --< the main anti cheat goes ss >--
remoteFolder.Parent = game:GetService("ReplicatedStorage") --< remotes in rep storage >--

script:Destroy() --< deletes the handler >--
