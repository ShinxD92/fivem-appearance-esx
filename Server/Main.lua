ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('Skin:Server:SaveSkin')
AddEventHandler('Skin:Server:SaveSkin', function(appearance)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(appearance),
		['@identifier'] = xPlayer.identifier
	})
end)

ESX.RegisterServerCallback('Skin:Server:GetPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user, appearance = users[1]

		local jobSkin = {
			skin_male   = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user.skin then
			appearance = json.decode(user.skin)
		end

		cb(appearance, jobSkin)
	end)
end)
