-- With default.project.json synced through Rojo, run this LocalScript on the client.
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local MintProject = require(ReplicatedStorage:WaitForChild('MintProject'))
local makeDemo = require(ReplicatedStorage:WaitForChild('MintProjectDemo'))
makeDemo(MintProject)
