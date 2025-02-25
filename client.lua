local QBCore = exports['qb-core']:GetCoreObject()
local vehicleList = {
    {name = "Sultan", model = "sultan"},
    {name = "Banshee", model = "banshee"}
}

local menuOpen = false
local lastSpawnTime = 0

RegisterCommand("openvehiclemenu", function()
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        QBCore.Functions.Notify("Araç içerisindeyken menüyü açamazsın!", "error")
        return
    end
    if not menuOpen then
        menuOpen = true
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openMenu",
            vehicles = vehicleList
        })
    end
end, false)

RegisterNUICallback("spawnVehicle", function(data, cb)
    local currentTime = GetGameTimer()
    if currentTime - lastSpawnTime < 15000 then
        QBCore.Functions.Notify("15 Saniye Boyunca Araç Çıkarılamaz!", "error")
        return
    end
    
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    QBCore.Functions.SpawnVehicle(data.model, function(vehicle)
        SetVehicleNumberPlateText(vehicle, "MONTANA")
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", "MONTANA")
    end, coords, true)
    
    lastSpawnTime = GetGameTimer()
    menuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeMenu" })
    cb("ok")
end)

RegisterNUICallback("closeMenu", function(_, cb)
    menuOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = "closeMenu" })
    cb("ok")
end)

-- 
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 288) then -- F1 Tuşu
            if menuOpen then
                SendNUIMessage({ action = "closeMenu" })
                menuOpen = false
                SetNuiFocus(false, false)
            else
                ExecuteCommand("openvehiclemenu")
            end
        end
    end
end)
