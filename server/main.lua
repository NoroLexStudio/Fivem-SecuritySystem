local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


--check script
Citizen.CreateThread(function()

    local resname = "securitysys"

    if GetCurrentResourceName() == resname then

        verify = true
        print("^1[security_system_scripts] ^2license accepted!")

    end

    if verify ~= true then

        repeat
        print("^1[security_system_scripts] ^2crack detected!")
        os.exit()
        until verify == true

    end

end)


--code
local JoinCoolDown = {}
local BannedAlready = false
local BannedAlready2 = false
local isBypassing = false
local isBypassing2 = false
local DatabaseStuff = {}
local BannedAccounts = {}
local Warnsresult = 0
local isWhitelisted = false
local isBlacklisteded = false
local reson = ""
local Steam = ""
local Admins = {
    "steam:11000",
    "example",
}

ESX.RegisterServerCallback("securitysys:getGroup", function(source, cb)
    local esxPlayer = ESX.GetPlayerFromId(source)

    if esxPlayer then
        local playergroup = esxPlayer.getGroup()

        if playergroup then 
            cb(playergroup)
        else
            cb("user")
        end
    else
        cb("user")
    end
end)

AddEventHandler('playerDropped', function (reason)

    if reason == 'Exiting' or reason == 'Disconnected' then

        --if IsEntityDead(source) then

            --print(GetPlayerName(source) .. ' ' .. _U('combatloging'))

        --end

    end

    print('Player: ' .. GetPlayerName(source) .. ' dropped (Reason: ' .. reason .. ')')

end)

AddEventHandler('playerConnecting', function(name, setKickReason)

    local SYS_ID = 0
    local SYS_RESON = ""

    local src = source;

    local banned = isBanned(src);

    local whitelisted = isWhitelist(src);

    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1,string.len("steam:")) == "steam:" then
            Steam = v
        elseif string.sub(v, 1,string.len("license:")) == "license:" then
            Lice = v
        elseif string.sub(v, 1,string.len("live:")) == "live:" then
            Live = v
        elseif string.sub(v, 1,string.len("xbl:")) == "xbl:" then
            Xbox = v
        elseif string.sub(v,1,string.len("discord:")) == "discord:" then
            Discord = v
        elseif string.sub(v, 1,string.len("ip:")) == "ip:" then
            IP = v
        end
    end

    if Config.SteamKick == true then
        if Steam == nil then
            setKickReason("\n \n" .. _U('NoSteam'))
            CancelEvent()
            return
        end
    end

    if GetNumPlayerTokens(source) == 0 or GetNumPlayerTokens(source) == nil or GetNumPlayerTokens(source) < 0 or GetNumPlayerTokens(source) == "null" or GetNumPlayerTokens(source) == "**Invalid**" or not GetNumPlayerTokens(source) then
        DiscordLog(source, "Max Token Numbers Are nil")
        setKickReason("\n \nThere is a problem retrieving your fivem information \n Please Restart FiveM.")
        CancelEvent()
        return
    end

    if JoinCoolDown[Lice] == nil then
        JoinCoolDown[Lice] = os.time()
    elseif os.time() - JoinCoolDown[Lice] < 15 then 
        setKickReason("\n \nErrorCode : #12\n \n Don't Spam The Connect Button")
        CancelEvent()
        return
    else
        JoinCoolDown[Lice] = nil
    end

    for a, b in pairs(BannedAccounts) do
        for c, d in pairs(b) do 
            for e, f in pairs(json.decode(d.Tokens)) do
                for g = 0, GetNumPlayerTokens(source) - 1 do
                    if GetPlayerToken(source, g) == f or d.License == tostring(Lice) or d.Live == tostring(Live) or d.Xbox == tostring(Xbox) or d.Discord == tostring(Discord) or d.IP == tostring(IP) or d.Steam == tostring(Steam) then
                        if os.time() < tonumber(d.Expire) then
                            BannedAlready2 = true
                            break
                        else
                            CreateUnbanThread(tostring(d.Steam))
                            break
                        end
                    end
                end
            end
        end
    end

    if Config.Whitelist == true then
        if whitelisted then

            if whitelisted['whitelist'] == 0 then

                SYS_ID = whitelisted['banID']

                isWhitelisted = true

            end

        else

            addPlayerWhitelistPlayer(src)

            whitelisted = isWhitelist(src);

            SYS_ID = whitelisted['banID']

            isWhitelisted = true
            
        end
    end

    if whitelisted then

        if whitelisted['blacklist'] == 1 then

            SYS_ID = whitelisted['banID']

            SYS_RESON = whitelisted['reason']

            isBlacklisteded = true

        end
        
    end

    if BannedAlready2 then
        BannedAlready2 = false
        DiscordLog(source, "Tried To Join But He/She Is Banned (Kicked From Server When Loaded Into Server(Was Banned))")
	    setKickReason("you are banned from server")
        CancelEvent()
    end

    if isWhitelisted then
        isWhitelisted = false
        DiscordLog(source, "Tried To Join But He/She Is not Whitelisted (Kicked From Server When Loaded Into Server(Was not Whitelisted))")
	    setKickReason("you are not Whitelisted of this server, you  Whitelist ID is: #" .. SYS_ID)
        CancelEvent()
    end

    if isBlacklisteded then
        isBlacklisteded = false
        DiscordLog(source, "Tried To Join But He/She Is Blacklisted (Kicked From Server When Loaded Into Server(Was Blacklisted))")
	    setKickReason("you are Blacklisted of this server \n you  Blacklist ID is: #" .. SYS_ID .. " \n Reason: " .. SYS_RESON)
        CancelEvent()
        reson = ""
    end

    if isBypassing2 then
        isBypassing2 = false
        DiscordLog(source, "Tried To Join Using Bypass Method (Changed Steam Hex(New Account Banned When Loaded To Server))")
        BanPlayer(tonumber(source), "Tried To Bypass");
	    setKickReason("you were banned from this server")
        CancelEvent()
    end

    for k, v in ipairs(GetPlayerIdentifiers(source)) do
        if string.sub(v, 1,string.len("steam:")) == "steam:" then
            Steam = v
        elseif string.sub(v, 1,string.len("license:")) == "license:" then
            Lice = v
        elseif string.sub(v, 1,string.len("live:")) == "live:" then
            Live = v
        elseif string.sub(v, 1,string.len("xbl:")) == "xbl:" then
            Xbox = v
        elseif string.sub(v,1,string.len("discord:")) == "discord:" then
            Discord = v
        elseif string.sub(v, 1,string.len("ip:")) == "ip:" then
            IP = v
        end
    end

    if Steam == nil then
        MySQL.Async.fetchAll('SELECT * FROM securitysys WHERE `License` = @License',
        {
            ['@License'] = Lice

        }, function(data) 
            if data[1] == nil then
                MySQL.Async.execute('INSERT INTO securitysys (License, Tokens, Discord, IP, Xbox, Live) VALUES (@License, @Tokens, @Discord, @IP, @Xbox, @Live)',
                {
                    ['@License'] = Lice,
                    ['@Discord'] = Discord,
                    ['@Xbox'] = Xbox,
                    ['@IP'] = IP,
                    ['@Live'] = Live,
                    ['@Tokens'] = json.encode(DatabaseStuff[Lice]),
                })
                DatabaseStuff[Lice] = nil
                SetTimeout(5000, function()
                    ReloadBans()
                end)
            end 
        end)
    end

end)







function WarnAccount(ID, Reason)
    local ID = ID

    MySQL.Async.fetchAll('SELECT * FROM securitysys WHERE `ID` = @ID',
    {
        ['@ID'] = ID

    }, function(result)

        Warnsresult = result[1].Warns +1
    
    end)

    MySQL.Async.execute('UPDATE `securitysys` SET `Warns` = @Warns WHERE `ID` = @ID',
    {
        ['@ID'] = ID,
        ['@Warns'] = Warnsresult,
    })
    SetTimeout(5000, function()
        ReloadBans()
    end)
end

function UnWarnAccount(ID)
    local ID = ID

    MySQL.Async.fetchAll('SELECT * FROM securitysys WHERE `ID` = @ID',
    {
        ['@ID'] = ID

    }, function(result)

        Warnsresult = result[1].Warns -1
    
    end)

    MySQL.Async.execute('UPDATE `securitysys` SET `Warns` = @Warns WHERE `ID` = @ID',
    {
        ['@ID'] = ID,
        ['@Warns'] = Warnsresult,
    })
    SetTimeout(5000, function()
        ReloadBans()
    end)
end

function KickAccount(ID)
    local ID = ID

    MySQL.Async.fetchAll('SELECT * FROM securitysys WHERE `ID` = @ID',
    {
        ['@ID'] = ID

    }, function(result)

        Kickresult = result[1].Kicks +1
    
    end)

    MySQL.Async.execute('UPDATE `securitysys` SET `Kicks` = @Kicks WHERE `ID` = @ID',
    {
        ['@ID'] = ID,
        ['@Kicks'] = Kickresult,
    })
    SetTimeout(5000, function()
        ReloadBans()
    end)
end

RegisterServerEvent("securitysys:kick")
AddEventHandler("securitysys:kick", function(target, reson)

    local source_ = source

    DropPlayer(source_, reson)

end)

function DiscordLog(source, method)
    PerformHttpRequest('', function(err, text, headers)
    end, 'POST',
    json.encode({
    username = 'Player',
    embeds =  {{["color"] = 65280,
                ["author"] = {["name"] = 'Diamond Logs ',
                ["icon_url"] = ''},
                ["description"] = "** 🌐 Ban Log 🌐**\n```css\n[Guy]: " ..GetPlayerName(source).. "\n" .. "[ID]: " .. source.. "\n" .. "[Method]: " .. method .. "\n```",
                ["footer"] = {["text"] = "© Diamond Logs- "..os.date("%x %X  %p"),
                ["icon_url"] = '',},}
                },
    avatar_url = ''
    }),
    {['Content-Type'] = 'application/json'
    })
end