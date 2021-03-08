print("Hello Server!")

-- When a user connects
core.networking:on("_clientConnected", function(client)
   print("new client", client)
   core.networking:broadcast("message", client.name .. " connected")
end)

core.networking:on("_clientDisconnected", function(client)
   print("lost client", client)
   core.networking:broadcast("message", client.name .. " disconnected")
end)

while sleep(1) do
   core.networking:broadcast("message", "ping")
end