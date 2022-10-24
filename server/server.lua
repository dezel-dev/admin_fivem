--[[
    This file (server.lua) is created by @Dezel.
    Created the 13/04/2022 - 10:39.
    Directory : dezel/modules/addons/admin/server.
    
    This file is Protected by Dezel : 
    Edit, Modifyng or Copy code of this 
    file is completly forbade.
]]--

print("[^5DBase^7] (^1INFO^7) (^2SERVER^7) Admin Loaded!")

ESX = nil TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

items = {}

MySQL.ready(function()
    MySQL.Async.fetchAll("SELECT * FROM items", {}, function(result)
        for k, v in pairs(result) do
            items[k] = { label = v.label, name = v.name }
        end
    end)
end)

RegisterNetEvent('admin:getAdminData')
AddEventHandler('admin:getAdminData', function()
    xPlayer = ESX.GetPlayerFromId(source)
    data = {}
    data.group = xPlayer.getGroup()
    data.id = GetNumPlayerIdentifiers(source)
    data.name = xPlayer.getName()

    TriggerClientEvent('admin:getAdminData:return', source, data, items)
end)

RegisterNetEvent('admin:revive')
AddEventHandler('admin:revive', function(target)
    TriggerClientEvent("esx_ambulancejob:revive", target)
end)

RegisterNetEvent('admin:giveItem')
AddEventHandler('admin:giveItem', function(target, item, count)
    xPlayer = ESX.GetPlayerFromId(target)

    xPlayer.addInventoryItem(item, count)
end)

RegisterNetEvent('admin:giveItem2')
AddEventHandler('admin:giveItem2', function(target, item, count)
    xPlayer = ESX.GetPlayerFromId(target)

    xPlayer.addInventoryItem(item, count)
end)

RegisterNetEvent('admin:giveMoneyLiquid')
AddEventHandler('admin:giveMoneyLiquid', function(target, money)
    xPlayer = ESX.GetPlayerFromId(target)

    xPlayer.addMoney(money)
end)

RegisterNetEvent('admin:giveMoneyBank')
AddEventHandler('admin:giveMoneyBank', function(target, money)
    xPlayer = ESX.GetPlayerFromId(target)

    xPlayer.addAccountMoney('bank', tonumber(money))
end)

RegisterNetEvent('admin:giveMoneySale')
AddEventHandler('admin:giveMoneySale', function(target, money)
    xPlayer = ESX.GetPlayerFromId(target)

    xPlayer.addAccountMoney('black_money', tonumber(money))
end)

RegisterNetEvent('admin:setJob')
AddEventHandler('admin:setJob', function(target, job, grade)
    xPlayer = ESX.GetPlayerFromId(target)

    xPlayer.setJob(job, grade)
end)

RegisterNetEvent('admin:setName')
AddEventHandler('admin:setName', function(target, name)
    xPlayer = ESX.GetPlayerFromId(target)

    xPlayer.setName(name)
end)

RegisterNetEvent('admin:kick')
AddEventHandler('admin:kick', function(target, reason)
    xPlayer = ESX.GetPlayerFromId(target)

    xPlayer.kick(reason)
end)

RegisterNetEvent('admin:getInventory')
AddEventHandler('admin:getInventory', function(target)
    xPlayer = ESX.GetPlayerFromId(target)

    items = xPlayer.getInventory()

    TriggerClientEvent('admin:getInventory:return', source, items)
end)

RegisterNetEvent('admin:removeItem')
AddEventHandler('admin:removeItem', function(target, item, count)
    xPlayer = ESX.GetPlayerFromId(target)

    xPlayer.removeInventoryItem(item, count)
end)

RegisterNetEvent('admin:addReport')
AddEventHandler('admin:addReport', function(reason)
    xPlayer = ESX.GetPlayerFromId(source)
    name = xPlayer.getName()
    reason = reason

    MySQL.Async.execute("INSERT INTO reports (name, reason) VALUES (@name, @reason)", {
        ['@name'] = name,
        ['@reason'] = reason
    })
end)