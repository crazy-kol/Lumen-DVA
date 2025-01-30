local authorizedAdmins = {
    "steam:110000xxxxxxxxxx",  -- Replace with actual Steam hex IDs
    "steam:110000yyyyyyyyyy"
}


function IsPlayerAuthorized(playerId, permission)

    return IsPlayerAceAllowed(playerId, permission)
end


RegisterCommand("cleanup", function(source, args, rawCommand)

    if not IsPlayerAuthorized(source, "staff.cleanup") then -- Ace
        TriggerClientEvent("ox_lib:notify", source, {
            title = "Error",
            description = "You do not have permission to execute this cleanup command.",
            type = "error",
            duration = 3000,
            position = "center-right"
        })
        return
    end
    

    TriggerClientEvent('ox_lib:notify', source, {
        title = 'Command Executed',
        description = 'You have successfully initiated the mass vehicle cleanup.',
        type = 'success'
    })
    

    TriggerClientEvent('ox_lib:notify', -1, {
        title = 'Vehicle Cleanup',
        description = 'All vehicles will be deleted in **30 seconds**. Please enter your vehicles now.',
        type = 'warning'
    })
    Wait(15000)
    
    TriggerClientEvent('ox_lib:notify', -1, {
        title = 'Vehicle Cleanup',
        description = 'All vehicles will be deleted in **15 seconds**. Please secure your vehicle.',
        type = 'warning'
    })
    Wait(10000)
    
    TriggerClientEvent('ox_lib:notify', -1, {
        title = 'Vehicle Cleanup',
        description = 'Final warning! **5 seconds** until vehicle removal.',
        type = 'warning'
    })
    Wait(5000)
    

    TriggerClientEvent("wld:delallveh", -1)
    

    TriggerClientEvent('ox_lib:notify', -1, {
        title = 'Cleanup Complete',
        description = 'All unused vehicles have been successfully removed.',
        type = 'success'
    })
end, false)


