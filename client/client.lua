--------------------------------------
------Created By Whit3Xlightning & Lumen Studios------
--https://github.com/crazy-kol https://github.com/Whit3Xlightning --
--------------------------------------

RegisterNetEvent("wld:delallveh")
AddEventHandler("wld:delallveh", function ()
    for vehicle in EnumerateVehicles() do
        if (not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1))) then 
            SetVehicleHasBeenOwnedByPlayer(vehicle, false) 
            SetEntityAsMissionEntity(vehicle, false, false) 
            DeleteVehicle(vehicle)
            if (DoesEntityExist(vehicle)) then 
                DeleteVehicle(vehicle) 
            end
        end
    end
end)
