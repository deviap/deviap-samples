print("Hello Client!")

-- We need to start the connection
core.networking:start()

local lines = {}

local txtBox = core.construct("guiTextBox", {
    parent = core.interface,
    size = guiCoord(1, 0, 1, 0),
    text = "",
    textWrap = true,
    textMultiline = true
})

function message(message)
    table.insert(lines, message)
    if #lines > 10 then
        table.remove(lines, 1)
    end

    local txt = ""
    for _,v in pairs(lines) do
        txt = txt .. v .. "\n"
    end
    txtBox.text = txt
end

core.networking:on("message", message)

core.networking:on("_connected", function(client)
    message("connected")
end)

core.networking:on("_disconnected", function(client)
    message("disconnected")
end)