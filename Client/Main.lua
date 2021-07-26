ESX = nil
local playerLoaded = false
local firstSpawn = true

Citizen.CreateThread(function()
  while ESX == nil do
      TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
      Citizen.Wait(0)
  end
end)

function openSkinMenu()
    local config = {
      ped = true,
      headBlend = true,
      faceFeatures = true,
      headOverlays = true,
      components = true,
      props = true,
    }
  
    exports['fivem-appearance']:startPlayerCustomization(function(appearance)
      if (appearance) then
          TriggerServerEvent('Skin:Server:SaveSkin', appearance)
       end
    end, config)
end

AddEventHandler('esx:onPlayerSpawn', function()
    Citizen.CreateThread(function()
        while not playerLoaded do
            Citizen.Wait(100)
        end

        if firstSpawn then
          ESX.TriggerServerCallback('Skin:Server:GetPlayerSkin', function(appearance, jobSkin)
            if appearance == nil then
                Citizen.Wait(200)
				    else
                exports['fivem-appearance']:setPlayerAppearance(appearance)
            end
          end)
          firstSpawn = false
        end
    end)
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    playerLoaded = true
end)

RegisterNetEvent('Skin:Client:OpenMenu')
AddEventHandler('Skin:Client:OpenMenu', function()
    openSkinMenu()
end)

RegisterCommand('customization', function()
  local config = {
    ped = true,
    headBlend = true,
    faceFeatures = true,
    headOverlays = true,
    components = true,
    props = true,
  }

  exports['fivem-appearance']:startPlayerCustomization(function(appearance)
    if (appearance) then
      print('Saved')
    else
      print('Canceled')
    end
  end, config)
end, false)

RegisterNetEvent("Clothes:Client:Load", function()
    ESX.TriggerServerCallback("Skin:Server:GetPlayerSkin", function(appearance, jobSkin) 
        if appearance == nil then
            Citizen.Wait(200)
        else
          exports['fivem-appearance']:setPlayerAppearance(appearance)
        end
    end)
end)

RegisterCommand("resetskin", function()
    TriggerEvent("Clothes:Client:Load")
end)
