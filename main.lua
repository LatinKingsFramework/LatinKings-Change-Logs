LatinKingsCore = nil

Citizen.CreateThread(function()
    while LatinKingsCore == nil do
        TriggerEvent('LatinKingsCore:GetObject', function(obj) LatinKingsCore = obj end)
        Citizen.Wait(0)
    end
end)

-- CONFIG VARS
grannypos = { x = 3312.95, y = 5178.88, z = 18.63, h = 210.79 }
model = "ig_mrs_thornhill"


    Citizen.CreateThread(function()

       local hash = GetHashKey(model) -- Store model as Hash
       RequestModel(hash)
        -- Wait until Model has loaded
        while not HasModelLoaded(hash) do Citizen.Wait(0) end
        ped = CreatePed(4, hash, grannypos.x, grannypos.y, grannypos.z, grannypos.h, true, true)

        -- Makes the ped not run away/die/get hurt/etc
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)

        local pedanimdict = "mini@drinking"
        local pedanim = "shots_barman_b"
        loadAnimDict(pedanimdict)	
        TaskPlayAnim(ped, pedanimdict, pedanim, 3.0, 3.0, -1, 49, 1, 0, 0, 0)
    end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(2)
	end
end

local prob = math.random(1,10)

healAnimDict = "mini@cpr@char_a@cpr_str"
healAnim = "cpr_pumpchest"

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
    local plyCoords = GetEntityCoords(PlayerPedId(), 0)
    local pos = GetEntityCoords(GetPlayerPed(-1))
        local distance = #(vector3(grannypos.x, grannypos.y, grannypos.z) - plyCoords)
        if distance < 10 then
            if not IsPedInAnyVehicle(PlayerPedId(), true) then
                if distance < 3 then
                    LatinKingsCore.Functions.DrawText3D(grannypos.x, grannypos.y, grannypos.z + 0.5, '[E] - Solicitar a la abuela por $2,000')
                    DisableControlAction(0, 57, true)
                    if IsDisabledControlJustReleased(0, 54) then

                        LatinKingsCore.Functions.Progressbar("check-", "Solicitando la ayuda de la abuela", 5000, false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function()
                            if prob > 5 then
                             loadAnimDict('missheistdockssetup1clipboard@base')
                             TaskPlayAnim( PlayerPedId(), "missheistdockssetup1clipboard@base", "base", 3.0, 1.0, -1, 49, 0, 0, 0, 0 ) 
                             loadAnimDict(healAnimDict)	
                             TaskPlayAnim(ped, healAnimDict, healAnim, 3.0, 3.0, 8000, 49, 0, 0, 0, 0)
                             LatinKingsCore.Functions.Progressbar("check-", "Bendiciéndote con una vida", 10000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                             }, {}, {}, {}, function()
                                LatinKingsCore.Functions.Notify("Fuiste tratado! ..", "success")
                                TriggerEvent('hospital:client:Revive')
                                TriggerServerEvent('LTKS-grandma:server:Charge')
                                ClearPedTasks(PlayerPedId())
                             end, function() -- Cancel
                                ClearPedTasks(PlayerPedId())
                            end)
                        else 
                            LatinKingsCore.Functions.Notify("La abuela se negó a ayudar", "error")
                        end 
                        end)
                            
                        
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)
