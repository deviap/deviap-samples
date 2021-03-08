local person = core.construct("block", {
    parent = core.scene,
    mesh = "fs:client/meshes/charmerge.glb",
    position = vector3(0, 0, 0),
    colour = colour(1, 1, 0)
})

-- Mesh loading occurs in the background
-- wait for it to finish, otherwise meshScale will be wrong
while not person.meshLoaded do sleep() end

-- We need to scale the mesh back to it's native size
-- Otherwise it would appear squished
person.scale = person.meshScale/100

-- Just make sure the camera is pointing in the right place
core.scene.camera.position = vector3(0, 0, 4)
core.scene.camera:lookAt(vector3(0, 0, 0))

-- Allow the user to move the camera
require("devgit:source/application/utilities/camera.lua")

-- Light it up!
core.graphics.upperAmbient = colour(1, 1, 1)

local db = false

-- Create a button to trigger each animation
for i,v in pairs(person.animations) do
    local btn = core.construct("guiTextBox", {
        parent = core.interface,
        position = guiCoord(1, -150, 0, i * 25),
        size = guiCoord(0, 150, 0, 20),
        text = v,
        backgroundAlpha = 0
    })

    -- Play every anim, but weight 0
    -- Meaning each anim has no effect on skeleton
    person:playAnimation(v, true, 10)
    person:setAnimationWeight(v,  0)

    btn:on("mouseLeftUp", function()
        if db then return end
        db = true
        btn.text = "Blending..."

        -- Slowly change the weighting of the anims
        for i = 0, 1, 0.0125 do
            for _,anim in pairs(person.animations) do
                if anim == v then
                    person:setAnimationWeight(anim, i)
                else
                    person:setAnimationWeight(anim, 1 - i)
                end
            end
            sleep()
        end

        for _,v in pairs(core.interface.children) do
            if v.className == "guiTextBox" then
                v.textFont = "deviap:fonts/openSansRegular.ttf"
            end
        end
        
        btn.textFont = "deviap:fonts/openSansBold.ttf"
        btn.text = v

        db = false
    end)
end