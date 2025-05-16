--< THIS SHOULD BE A SCRIPT SCRIPT >--

remoteFolder = Instance.new("Folder")
remoteFolder.Name = "Remotes"

remote1 = Instance.new("RemoteEvent")
remote2 = Instance.new("RemoteEvent")

remote1.Name = "GiveAdminToCurrentClient"
remote2.Name = "Handshake"

remote1.Parent = remoteFolder
remote2.Parent = remoteFolder

script.Parent.InitAC.Parent = game:GetService("ServerScriptService")
script.Parent.ClientAC.Parent = game:GetService("StarterPlayer").StarterPlayerScripts
script.Parent.Anticheat.Parent = game:GetService("ServerScriptService")
remoteFolder.Parent = game:GetService("ReplicatedStorage")


script:Destroy()
