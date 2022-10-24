--[[
    This file (function.lua) is created by @Dezel.
    Created the 18/05/2022 - 12:14.
    Directory : resources/[Dezel]/dezel_admin/shared.
    
    This file is Protected by Dezel : 
    Edit, Modifyng or Copy code of this 
    file is completly forbade.
]]--

function getRankDisplay(rank)
    local ranks = {
        ["_dev"] = "~r~[Dev] ~s~",
        ["superadmin"] = "~r~[S.Admin] ~s~",
        ["admin"] = "~r~[Admin] ~s~",
    }
    return ranks[rank] or ""
end

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

function Input(reason, max)
    local txt = nil
    AddTextEntry("CREATOR_TXT", reason)
    DisplayOnscreenKeyboard(1, "CREATOR_TXT", '', "", '', '', '', max)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        txt = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
    else
        Citizen.Wait(1)
    end
    return txt
end

local SettingsButton = {
    Rectangle = { Y = 0, Width = 431, Height = 38 },
    Text = { X = 8, Y = 3, Scale = 0.33 },
}

function RageUILine()
    local CurrentMenu = RageUI.CurrentMenu
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            local Option = RageUI.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                RenderSprite("RageUIline", "GUNWARE", CurrentMenu.X + SettingsButton.Text.X + 15.0, CurrentMenu.Y + (SettingsButton.Text.Y + 5.0) + CurrentMenu.SubtitleHeight + RageUI.ItemOffset, 380, 18, 255, 255, 255, 255, 255)
                RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height
                if (CurrentMenu.Index == Option) then
                    if (RageUI.LastControl) then
                        CurrentMenu.Index = Option - 1
                        if (CurrentMenu.Index < 1) then
                            CurrentMenu.Index = RageUI.CurrentMenu.Options
                        end
                    else
                        CurrentMenu.Index = Option + 1
                    end
                end
            end
            RageUI.Options = RageUI.Options + 1
        end
    end
end

function GetVehicles()
    local vehicles = {}

    for vehicle in EnumerateVehicles() do
        table.insert(vehicles, vehicle)
    end

    return vehicles
end

function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function ClosestPed()
    local closestPed = 0

    for ped in EnumeratePeds() do
        local distanceCheck = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(ped), true)
        if distanceCheck <= 15.0 then
            closestPed = ped
            break
        end
    end

    return closestPed
end

function Draw3DText(x,y,z,scale, text)
    local onScreen,_x,_y = World3dToScreen2d(x,y,z)
    local px,py,pz = table.unpack(GetGameplayCamCoord())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

    if onScreen then

        -- Formalize the text
        SetTextColour(255, 255, 255, 255)
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextCentre(true)
        if dropShadow then
            SetTextDropshadow(10, 100, 100, 100, 255)
        end

        -- Calculate width and height
        BeginTextCommandWidth("STRING")
        AddTextComponentString(text)
        local height = GetTextScaleHeight(1*scale, 1)
        local width = EndTextCommandGetWidth(1)

        -- Diplay the text
        SetTextEntry("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(_x, _y)

        DrawRect(_x, _y+scale/45, width*1.2, height, 0, 0, 0 , 150)
    end
end