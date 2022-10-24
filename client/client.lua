ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

isAdminMode, admin, item, playerCount, vehicleCount, Items = false, {}, {}, 0, 0, 0, {}
filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }

RegisterNetEvent('admin:getAdminData:return')
AddEventHandler('admin:getAdminData:return', function(data, table)
    admin = data
    item = table
end)

RegisterNetEvent('admin:getInventory:return', function(data)

    for k in pairs(Items) do
        Items[k] = nil
    end

    for i=1, #data, 1 do
        if data[i].count > 0 then
            table.insert(Items, {
                label    = data[i].label,
                name    = data[i].name,
                amount   = data[i].count
            })
        end
    end
end)

index = {
    isAdminMode = false,
    isNoclip = false,
    isGodMode = false,
    isInvisible = false,
    isFastRun = false,
    filter = 1
}

index2 = {
    isGodMode = false,
    isFreeze = false,
}

adminMenu = function ()

    for k in pairs(GetActivePlayers()) do
        playerCount = playerCount + 1
    end

    local main = RageUI.CreateMenu("Admin", "Menu Principal");
    local parameters = RageUI.CreateSubMenu(main, "Admin", "Paramètres");
    local players = RageUI.CreateSubMenu(main, "Admin", "Joueurs");
    local vehicles = RageUI.CreateSubMenu(main, "Admin", "Véhicules");
    local items = RageUI.CreateSubMenu(parameters, "Admin", "Items");
    local playerAction = RageUI.CreateSubMenu(players, "Admin", "Actions Joueurs");
    local items2 = RageUI.CreateSubMenu(playerAction, "Admin", "Items");
    local inventory = RageUI.CreateSubMenu(playerAction, "Admin", "Inventaire");

    RageUI.Visible(main, not RageUI.Visible(main))

    while main do

        idPlayer = GetPlayerServerId(PlayerId())

        Citizen.Wait(0)

        RageUI.IsVisible(main, function()

            RageUI.Checkbox('Mode admin', '~g~Activer~s~/~r~Désactiver~s~ le mode admin', index.isAdminMode, {}, {
                onSelected = function(Index)
                    index.isAdminMode = Index
                end,

                onChecked = function()
                    isAdminMode = true
                    vehicleCount = 0
                    for i = 1, #GetVehicles(), 1 do
                        vehicleCount = vehicleCount + 1
                    end
                end,

                onUnChecked = function()
                    isAdminMode = false
                end
            })

            RageUI.Separator('Rang: ~r~' .. admin.group)

            RageUI.Line()

            if isAdminMode then

                RageUI.Button('Mes paramètres', 'Attribuez-vous des paramètres', {RightLabel = "~h~>"}, true, {
                }, parameters)
                RageUI.Button(('Gestion joueurs (~r~%s~s~)'):format(playerCount), 'Gestion des joueurs', {RightLabel = "~h~>"}, true, {
                }, players)
                RageUI.Button(('Gestions véhicules (~r~%s~s~)'):format(#GetVehicles()), 'Gestion des véhicules', {RightLabel = "~h~>"}, true, {
                }, vehicles)

            end

        end)

        RageUI.IsVisible(parameters, function()

            idToGive = idPlayer

            RageUI.Separator('Rang: ~r~' .. admin.group)

            RageUI.Line()

            RageUI.Separator(('ID : %s | Pseudo : %s'):format(idPlayer, admin.name))
            RageUI.Checkbox('Noclip', '~g~Activer~s~/~r~Désactiver~s~ le noclip', index.isNoclip, {}, {
                onSelected = function(Index)
                    index.isNoclip = Index
                end,

                onChecked = function()
                    ToggleNoClipMode()
                    ESX.ShowNotification('~g~Noclip activé')
                end,

                onUnChecked = function()
                    ToggleNoClipMode()
                    ESX.ShowNotification('~r~Noclip désactivé')
                end
            })
            RageUI.Checkbox('Godmode', '~g~Activer~s~/~r~Désactiver~s~ le godmode', index.isGodMode, {}, {
                onSelected = function(Index)
                    index.isGodMode = Index
                end,

                onChecked = function()
                    SetEntityInvincible(PlayerPedId(), true)
                    ESX.ShowNotification('~g~Godmode activé')
                end,

                onUnChecked = function()
                    SetEntityInvincible(PlayerPedId(), false)
                    ESX.ShowNotification('~r~Godmode désactivé')
                end
            })
            RageUI.Checkbox('Invisible', '~g~Activer~s~/~r~Désactiver~s~ le mode fantome', index.isInvisible, {}, {
                onSelected = function(Index)
                    index.isInvisible = Index
                end,

                onChecked = function()
                    SetEntityVisible(PlayerPedId(), false)
                    ESX.ShowNotification('~g~Mode fantome activé')
                end,

                onUnChecked = function()
                    SetEntityVisible(PlayerPedId(), true)
                    ESX.ShowNotification('~r~Mode fantome désactivé')
                end
            })
            RageUI.Checkbox('FastRun', '~g~Activer~s~/~r~Désactiver~s~ le Speedrun', index.isFastRun, {}, {
                onSelected = function(Index)
                    index.isFastRun = Index
                end,

                onChecked = function()
                    SetRunSprintMultiplierForPlayer(PlayerPedId(), 5.0)
                    ESX.ShowNotification('~g~Speedrun activé')
                end,

                onUnChecked = function()
                    SetRunSprintMultiplierForPlayer(PlayerPedId(), 1.0)
                    ESX.ShowNotification('~r~Speedrun désactivé')
                end
            })

            RageUI.Line()

            RageUI.Button('TP Marker', 'TP sur le marker', {}, true, {
                onSelected = function()
                    local blip = GetFirstBlipInfoId(8)
                    local blipX = 0.0
                    local blipY = 0.0

                    if (blip ~= 0) then
                        local coord = GetBlipCoords(blip)
                        blipX = coord.x
                        blipY = coord.y
                    end
                end
            })
            RageUI.Button('Revive', 'Vous réanimez', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    TriggerServerEvent('admin:revive', idPlayer)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('~g~Vous vous êtes réanimé')
                end
            })
            RageUI.Button('Soigner', 'Vous soignez', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    SetEntityHealth(PlayerPedId(), 200)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('~g~Vous vous êtes soigné')
                end
            })
            RageUI.Button('Suicide', 'Vous suicidez', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    SetEntityHealth(PlayerPedId(), 0)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('Vous vous êtes suicidé')
                end
            })

            RageUI.Line()

            RageUI.Button('Give Vehicle', 'Vous donnez un véhicule', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    model = Input("Entrez le modèle du véhicule", 50)
                    ESX.ShowNotification('Action en cours...')
                    local vehicle = GetHashKey(model)
                    if IsModelValid(vehicle) then
                        RequestModel(vehicle)
                        while not HasModelLoaded(vehicle) do
                            Citizen.Wait(0)
                        end
                        ESX.ShowNotification('Vous vous êtes donné un véhicule (~r~' .. model .. '~s~)')
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        local vehicle = CreateVehicle(vehicle, playerCoords, 0.0, true, false)
                        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
                        else
                        ESX.ShowNotification('~r~Ce modèle n\'existe pas')
                    end
                end
            })
            RageUI.Button('Give Item', 'Vous donnez un objet', {RightLabel = "~h~>"}, true, {
            }, items)
            RageUI.Button('Give Money (Liquide)', "Vous donnez de l'argent liquide", {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    amount = Input("Entrez l'argent", 10)
                    if tonumber(amount) == nil then
                        ESX.ShowNotification("~r~Quantité invalide")
                    elseif amount == nil then
                        ESX.ShowNotification("~r~Quantité invalide")
                    else
                        ESX.ShowNotification('Action en cours...')
                        ESX.ShowNotification("Vous vous êtes donné ~g~" .. amount .. "~s~$ en liquide")
                        TriggerServerEvent('admin:giveMoneyLiquid', idToGive, amount)
                    end
                end
            })
            RageUI.Button('Give Money (Bank)', "Vous donnez de l'argent banque", {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    amount = Input("Entrez l'argent", 10)
                    if tonumber(amount) == nil then
                        ESX.ShowNotification("~r~Quantité invalide")
                    elseif amount == nil then
                        ESX.ShowNotification("~r~Quantité invalide")
                    else
                        ESX.ShowNotification('Action en cours...')
                        ESX.ShowNotification("Vous vous êtes donné ~g~" .. amount .. "~s~$ en banque")
                        TriggerServerEvent('admin:giveMoneyBank', idToGive, amount)
                    end
                end
            })
            RageUI.Button('Give Money (Argent Sale)', "Vous donnez de l'argent sale", {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    amount = Input("Entrez l'argent", 10)
                    if tonumber(amount) == nil then
                        ESX.ShowNotification("~r~Quantité invalide")
                    elseif amount == nil then
                        ESX.ShowNotification("~r~Quantité invalide")
                    else
                        ESX.ShowNotification('Action en cours...')
                        ESX.ShowNotification("Vous vous êtes donné ~g~" .. amount .. "~s~$ en argent sale")
                        TriggerServerEvent('admin:giveMoneySale', idToGive, amount)
                    end
                end
            })

            RageUI.Line()

            RageUI.Button('Set Job', 'Vous donnez un job', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    job = Input("Entrez le job", 50)
                    grade = Input("Entrez le grade", 50)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification("Vous vous êtes donné le job ~g~" .. job .. "~s~ avec le grade ~g~" .. grade .. "~s~")
                    TriggerServerEvent('admin:setJob', idToGive, job, grade)
                end
            })
            RageUI.Button('Set Name', 'Vous donnez un nom', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    name = Input("Entrez le nom", 50)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification("Vous vous êtes donné le nom ~g~" .. name .. "~s~")
                    TriggerServerEvent('admin:setName', idToGive, name)
                end
            })
        end)

        RageUI.IsVisible(items, function()
            RageUI.List('Filtre', filterArray, index.filter, nil, {}, true, {
                onListChange = function(Index, Item)
                    index.filter = Index;
                end,
            })

            RageUI.Line()

            for id, itemInfos in pairs(item) do
                if starts(itemInfos.label:lower(), filterArray[index.filter]:lower()) then
                    RageUI.Button(itemInfos.label, "Vous donnez un objet", {RightLabel = "~h~>"}, true, {
                        onSelected = function()
                            quantity = Input("Entrez la quantité", 5)
                            if tonumber(quantity) == nil then
                                ESX.ShowNotification('~r~Quantité invalide')
                            elseif tonumber(quantity) == 0 then
                                ESX.ShowNotification('~r~Quantité invalide')
                            else
                                ESX.ShowNotification('Action en cours...')
                                ESX.ShowNotification('Vous vous êtes donné ~g~' .. quantity .. 'x~s~ ' .. itemInfos.label)
                                TriggerServerEvent('admin:giveItem', idToGive, itemInfos.name, quantity)
                            end
                        end
                    })
                end
            end
        end)

        RageUI.IsVisible(items2, function()
            RageUI.List('Filtre', filterArray, index.filter, nil, {}, true, {
                onListChange = function(Index, Item)
                    index.filter = Index;
                end,
            })

            RageUI.Line()

            for id, itemInfos in pairs(item) do
                if starts(itemInfos.label:lower(), filterArray[index.filter]:lower()) then
                    RageUI.Button(itemInfos.label, "Vous donnez un objet", {RightLabel = "~h~>"}, true, {
                        onSelected = function()
                            quantity = Input("Entrez la quantité", 5)
                            if tonumber(quantity) == nil then
                                ESX.ShowNotification('~r~Quantité invalide')
                            elseif tonumber(quantity) == 0 then
                                ESX.ShowNotification('~r~Quantité invalide')
                            else
                                ESX.ShowNotification('Action en cours...')
                                ESX.ShowNotification('Vous vous êtes donné ~g~' .. quantity .. 'x~s~ ' .. itemInfos.label)
                                TriggerServerEvent('admin:giveItem', idToGive, itemInfos.name, quantity)
                            end
                        end
                    })
                end
            end
        end)

        RageUI.IsVisible(players, function()
            RageUI.Separator('Rang: ~r~' .. admin.group)

            RageUI.Line()

            for _, playerId in ipairs(GetActivePlayers()) do
                name = GetPlayerName(playerId)
                id = GetPlayerServerId(playerId)
                RageUI.Button(('[~r~%s~s~] %s'):format(id, name), nil, {RightLabel = "~h~>"}, true, {
                    onSelected = function()
                        player = GetPlayerPed(playerId)
                        playerData = {}
                    end
                }, playerAction)
            end
        end)

        RageUI.IsVisible(playerAction, function()

            idToGive = id

            playerCoords = GetEntityCoords(player)

            RageUI.Separator('Rang: ~r~' .. admin.group)

            RageUI.Line()

            RageUI.Separator(('ID : %s | Joueur : %s'):format(idToGive, name))

            RageUI.Line()

            RageUI.Button('TP sur moi', nil, {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    SetEntityCoords(player, GetEntityCoords(PlayerPedId()))
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('Téléportation effectuée')
                end
            })
            RageUI.Button('TP sur lui', nil, {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    SetEntityCoords(PlayerPedId(), playerCoords)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('Téléportation effectuée')
                end
            })
            RageUI.Button('TP Maze Bank', nil, {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    SetEntityCoords(player, vector3(-72.82, -817.69, 326.16))
                    SetEntityCoords(PlayerPedId(), vector3(-72.82, -817.69, 326.16))
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('Téléportation effectuée')
                end
            })

            RageUI.Line()

            RageUI.Checkbox('Godmode', '~g~Activer~s~/~r~Désactiver~s~ le godmode', index2.isGodMode, {}, {
                onSelected = function(Index)
                    index2.isGodMode = Index
                end,

                onChecked = function()
                    SetEntityInvincible(player, true)
                    ESX.ShowNotification('~g~Godmode activé pour le joueur')
                end,

                onUnChecked = function()
                    SetEntityInvincible(player, false)
                    ESX.ShowNotification('~r~Godmode désactivé pour le joueur')
                end
            })
            RageUI.Checkbox('Freeze', '~g~Activer~s~/~r~Désactiver~s~ le freeze', index2.isFreeze, {}, {
                onSelected = function(Index)
                    index2.isFreeze = Index
                end,

                onChecked = function()
                    FreezeEntityPosition(player, true)
                    ESX.ShowNotification('~g~Freeze activé pour le joueur')
                end,

                onUnChecked = function()
                    FreezeEntityPosition(player, false)
                    ESX.ShowNotification('~r~Freeze désactivé pour le joueur')
                end
            })

            RageUI.Line()

            RageUI.Button('Revive', 'Revive le joueur', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    TriggerServerEvent('admin:revive', id)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('Joueur réanimé')
                end
            })
            RageUI.Button('Soigner', 'Soignez le joueur', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    SetEntityHealth(player, 200)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('Joueur soigné')
                end
            })
            RageUI.Button('Suicide', 'Tuez le joueur', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    SetEntityHealth(player, 0)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('Joueur tué')
                end
            })

            RageUI.Line()

            RageUI.Button('Give Vehicle', 'Vous donnez un véhicule', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    model = Input("Entrez le modèle du véhicule", 50)
                    ESX.ShowNotification('Action en cours...')
                    local vehicle = GetHashKey(model)
                    if IsModelValid(vehicle) then
                        RequestModel(vehicle)
                        while not HasModelLoaded(vehicle) do
                            Citizen.Wait(0)
                        end
                        ESX.ShowNotification('Vous lui avez donné un véhicule (~r~' .. model .. '~s~)')
                        local playerCoords = GetEntityCoords(player)
                        local vehicle = CreateVehicle(vehicle, playerCoords, 0.0, true, false)
                        SetPedIntoVehicle(player, vehicle, -1)
                    else
                        ESX.ShowNotification('~r~Ce modèle n\'existe pas')
                    end
                end
            })
            RageUI.Button('Give Item', 'Vous donnez un objet', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    idToGive = id
                end
            }, items2)
            RageUI.Button('Give Weapon', 'Vous donnez une arme', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    weapon = Input("Entrez le nom de l'arme", 50)
                    munition = Input("Entrez le nombre de munitions", 50)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('Vous lui avez donné une arme (~r~' .. weapon .. '~s~)')
                    GiveWeaponToPed(player, GetHashKey(weapon), munition, false, true)
                end
            })
            RageUI.Button('Give Money (Liquide)', "Vous donnez de l'argent liquide", {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    amount = Input("Entrez l'argent", 10)
                    if tonumber(amount) == nil then
                        ESX.ShowNotification("~r~Quantité invalide")
                    elseif amount == nil then
                        ESX.ShowNotification("~r~Quantité invalide")
                    else
                        ESX.ShowNotification("Vous vous êtes donné ~g~" .. amount .. "~s~$ en liquide")
                        TriggerServerEvent('admin:giveMoneyLiquid', idToGive, amount)
                    end
                end
            })
            RageUI.Button('Give Money (Bank)', "Vous donnez de l'argent banque", {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    amount = Input("Entrez l'argent", 10)
                    if tonumber(amount) == nil then
                        ESX.ShowNotification("~r~Quantité invalide")
                    elseif amount == nil then
                        ESX.ShowNotification("~r~Quantité invalide")
                    else
                        ESX.ShowNotification("Vous vous êtes donné ~g~" .. amount .. "~s~$ en banque")
                        TriggerServerEvent('admin:giveMoneyBank', idToGive, amount)
                    end
                end
            })
            RageUI.Button('Give Money (Argent Sale)', "Vous donnez de l'argent sale", {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    amount = Input("Entrez l'argent", 10)
                    if tonumber(amount) == nil then
                        ESX.ShowNotification("~r~Quantité invalide")
                    elseif amount == nil then
                        ESX.ShowNotification("~r~Quantité invalide")
                    else
                        ESX.ShowNotification("Vous vous êtes donné ~g~" .. amount .. "~s~$ en argent sale")
                        TriggerServerEvent('admin:giveMoneySale', idToGive, amount)
                    end
                end
            })

            RageUI.Line()

            RageUI.Button('Set Job', 'Vous donnez un job', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    job = Input("Entrez le job", 50)
                    grade = Input("Entrez le grade", 50)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('Vous avez donné un job (~r~' .. job .. '~s~)')
                    TriggerServerEvent('admin:setJob', idToGive, job, grade)
                end
            })
            RageUI.Button('Set Name', 'Vous donnez un nom', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    name = Input("Entrez le nom", 50)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('Vous avez donné un nom (~r~' .. name .. '~s~)')
                    TriggerServerEvent('admin:setName', idToGive, name)
                end
            })

            RageUI.Line()

            RageUI.Button("Voir l'inventaire", "Voir l'inventaire du joueur", {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    TriggerServerEvent('admin:getInventory', idToGive)
                end
            }, inventory)

            RageUI.Line()

            RageUI.Button('Kick', 'Kick ce joueur', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    reason = Input("Entrez la raison", 50)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('Vous avez kick ~r~' .. name .. '~s~ pour ~r~' .. reason .. '~s~')
                    TriggerServerEvent('admin:kick', idToGive, reason)
                end
            })
            RageUI.Button('Ban', 'Ban ce joueur', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    reason = Input("Entrez la raison", 50)
                    time = Input("Entrez le temps", 10)
                    ESX.ShowNotification('Action en cours...')
                    ESX.ShowNotification('Vous avez ban ~r~' .. name .. '~s~ pour ~r~' .. reason .. '~s~ pendant ~r~' .. time .. '~s~ jours')
                    ExecuteCommand(("sqlban %s %s %s"):format(idToGive, time, reason))
                end
            })
        end)

        RageUI.IsVisible(inventory, function()

            RageUI.Separator('Rang: ~r~' .. admin.group)

            RageUI.Line()

            for _, v in pairs(Items) do
                RageUI.Button(('[x~r~%s~s~] %s'):format(v.amount, v.label), '', {}, true, {
                    onSelected = function()
                        amount = Input("Entrez la quantité", 10)
                        TriggerServerEvent('admin:removeItem', idToGive, v.name, amount)
                        TriggerServerEvent('admin:getInventory', idToGive)
                    end
                })
            end

        end)

        RageUI.IsVisible(vehicles, function()

            if IsPedInAnyVehicle(PlayerPedId(), false) then
                vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            else
                vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 1000000.0, 0, 70)
                pos = GetEntityCoords(vehicle)
                DrawMarker(2, pos.x, pos.y, pos.z+2.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 255, 255, 255, false, true)
            end
            RageUI.Separator('Rang: ~r~' .. admin.group)

            RageUI.Line()

            RageUI.Button('Spawn Vehicle', 'Vous donnez un véhicule', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    model = Input("Entrez le modèle du véhicule", 50)
                    ESX.ShowNotification('Action en cours...')
                    local vehicle = GetHashKey(model)
                    if IsModelValid(vehicle) then
                        RequestModel(vehicle)
                        while not HasModelLoaded(vehicle) do
                            Citizen.Wait(0)
                        end
                        ESX.ShowNotification('Vous vous êtes donné un véhicule (~r~' .. model .. '~s~)')
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        local vehicle = CreateVehicle(vehicle, playerCoords, 0.0, true, false)
                        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    else
                        ESX.ShowNotification('~r~Ce modèle n\'existe pas')
                    end
                end
            })
            RageUI.Button('Réparer Vehicule', 'Réparez le véhicule', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    ESX.ShowNotification('Action en cours...')
                    SetVehicleFixed(vehicle)
                    SetVehicleDeformationFixed(vehicle)
                    SetVehicleDirtLevel(vehicle, 0.0)
                    SetVehicleEngineHealth(vehicle, 1000.0)
                    ESX.ShowNotification('Vous avez réparé le véhicule')
                end
            })
            RageUI.Button('Remplir le réservoir', 'Remplissez le réservoir', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    ESX.ShowNotification('Action en cours...')
                    SetVehicleFuelLevel(vehicle, false, 100.0)
                    ESX.ShowNotification('Vous avez rempli le réservoir')
                end
            })
            RageUI.Button('Upgrade Max Vehicle', nil, {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    ESX.ShowNotification('Action en cours...')
                    ESX.Game.SetVehicleProperties(vehicle, {
                        modEngine = 3,
                        modBrakes = 3,
                        modTransmission = 3,
                        modSuspension = 3,
                        modTurbo = true
                    })
                    ESX.ShowNotification('Vous avez upgrade le véhicule')
                end
            })

            RageUI.Line()

            RageUI.Button('Supprimer le véhicule', 'Supprimez le véhicule', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    ESX.ShowNotification('Action en cours...')
                    SetEntityAsMissionEntity(vehicle, true, true)
                    DeleteVehicle(vehicle)
                    ESX.ShowNotification('Vous avez supprimé le véhicule')
                end
            })
            RageUI.Button('Freeze le véhicule', 'Freeze le véhicule', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    ESX.ShowNotification('Action en cours...')
                    FreezeEntityPosition(vehicle, true)
                    ESX.ShowNotification('Vous avez freeze le véhicule')
                end
            })
            RageUI.Button('UnFreeze le véhicule', 'UnFreeze le véhicule', {RightLabel = "~h~>"}, true, {
                onSelected = function()
                    ESX.ShowNotification('Action en cours...')
                    FreezeEntityPosition(vehicle, false)
                    ESX.ShowNotification('Vous avez UnFreeze le véhicule')
                end
            })
        end)

        if not RageUI.Visible(main) and not RageUI.Visible(parameters) and not RageUI.Visible(items) and not RageUI.Visible(players) and not RageUI.Visible(playerAction) and not RageUI.Visible(items2) and not RageUI.Visible(vehicles) and not RageUI.Visible(inventory) then
            main = RMenu:DeleteType('main', true)
            parameters = RMenu:DeleteType('parameters', true)
            players = RMenu:DeleteType('players', true)
            items = RMenu:DeleteType('items', true)
            playerAction = RMenu:DeleteType('playerAction', true)
            items2 = RMenu:DeleteType('items2', true)
            vehicles = RMenu:DeleteType('vehicles', true)
            inventory = RMenu:DeleteType('inventory', true)
        end

    end
end

Keys.Register('F10', 'F10', 'Ouvrir le menu Admin', function()
    print('ok')
    vehicleCount = 0
    playerCount = 0
    for i = 1, #GetVehicles(), 1 do
        vehicleCount = vehicleCount + 1
    end
    TriggerServerEvent('admin:getAdminData')
    Wait(75)
    adminMenu()
end)

