---@author Dezel

fx_version 'adamant'
games { 'gta5' };
lua54 'yes'

shared_scripts {
	'cfg.lua',
	'shared/*.lua',
	"ui/RMenu.lua",
	"ui/menu/RageUI.lua",
	"ui/menu/Menu.lua",
	"ui/menu/MenuController.lua",
	"ui/components/*.lua",
	"ui/menu/elements/*.lua",
	"ui/menu/items/*.lua",
	"ui/menu/panels/*.lua",
	"ui/menu/panels/*.lua",
	"ui/menu/windows/*.lua",
}
server_script {
	'@oxmysql/lib/MySQL.lua',
	'server/**/*.lua',
}
client_script 'client/**/*.lua'