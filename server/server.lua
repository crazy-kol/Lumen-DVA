-- Constants for configuration
local webhookURL = Config.Webhook
local NOTIFICATION_DURATION = 3000
local NOTIFICATION_POSITION = "center-right"

-- Constants for cleanup timing (in milliseconds)
local CLEANUP_TIMINGS = {
    INITIAL_WARNING = 30000,
    SECOND_WARNING = 15000,
    FINAL_WARNING = 5000
}

-- Constants for webhook colors
local WEBHOOK_COLORS = {
    SUCCESS = 65280,    -- Green
    INFO = 3447003,     -- Blue
    ERROR = 15158332    -- Red
}

-- Cache commonly used functions for better performance
local json_encode = json.encode
local TriggerClientEvent = TriggerClientEvent
local Wait = Wait

---Sends a notification to Discord webhook with error handling
---@param title string The title of the webhook message
---@param description string The description of the webhook message
---@param color number The color of the webhook embed
local function SendWebhookNotification(title, description, color)
    if not webhookURL then return end

    local embed = {
        {
            ["title"] = title,
            ["description"] = description,
            ["color"] = color,
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S"),
        }
    }

    local data = {
        ["embeds"] = embed,
    }

    PerformHttpRequest(webhookURL, function(statusCode, responseText, headers)
        if statusCode ~= 200 and statusCode ~= 204 then
            print(("^1[ERROR] Webhook failed with status code: %d^7"):format(statusCode))
        end
    end, "POST", json_encode(data), {["Content-Type"] = "application/json"})
end

---Checks if a player has the required permission
---@param playerId number The player's server ID
---@param permission string The permission to check
---@return boolean
local function IsPlayerAuthorized(playerId, permission)
    return IsPlayerAceAllowed(playerId, permission)
end

---Sends a notification to a specific player or all players
---@param target number|string The target player ID or -1 for all players
---@param notifyData table The notification data
local function SendNotification(target, notifyData)
    notifyData.duration = notifyData.duration or NOTIFICATION_DURATION
    notifyData.position = notifyData.position or NOTIFICATION_POSITION
    TriggerClientEvent("ox_lib:notify", target, notifyData)
end

-- Register the cleanup command
RegisterCommand("cleanup", function(source, args, rawCommand)
    -- Check if player has permission
    if not IsPlayerAuthorized(source, "staff.cleanup") then
        SendNotification(source, {
            title = "Error",
            description = "You do not have permission to execute this cleanup command.",
            type = "error"
        })
        return
    end

    -- Notify the command executor
    SendNotification(source, {
        title = "Command Executed",
        description = "You have successfully initiated the mass vehicle cleanup.",
        type = "success"
    })

    -- Log the cleanup initiation
    SendWebhookNotification(
        "Cleanup Command Executed", 
        "A mass vehicle cleanup has been initiated by an authorized staff member.", 
        WEBHOOK_COLORS.INFO
    )

    -- Initial warning (30 seconds)
    SendNotification(-1, {
        title = "Vehicle Cleanup",
        description = "All vehicles will be deleted in 30 seconds. Please enter your vehicles now.",
        type = "warning"
    })
    Wait(CLEANUP_TIMINGS.INITIAL_WARNING - CLEANUP_TIMINGS.SECOND_WARNING)

    -- Second warning (15 seconds)
    SendNotification(-1, {
        title = "Vehicle Cleanup",
        description = "All vehicles will be deleted in 15 seconds. Please secure your vehicle.",
        type = "warning"
    })
    Wait(CLEANUP_TIMINGS.SECOND_WARNING - CLEANUP_TIMINGS.FINAL_WARNING)

    -- Final warning (5 seconds)
    SendNotification(-1, {
        title = "Vehicle Cleanup",
        description = "Final warning! 5 seconds until vehicle removal.",
        type = "warning"
    })
    Wait(CLEANUP_TIMINGS.FINAL_WARNING)

    -- Execute cleanup
    TriggerClientEvent("wld:delallveh", -1)

    -- Notify completion
    SendNotification(-1, {
        title = "Cleanup Complete",
        description = "All unused vehicles have been successfully removed.",
        type = "success"
    })

    -- Log completion
    SendWebhookNotification(
        "Cleanup Complete", 
        "The mass vehicle cleanup has been successfully completed.", 
        WEBHOOK_COLORS.SUCCESS
    )
end, false)