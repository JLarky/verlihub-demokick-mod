make: demokick.lua

demokick.lua : demokick.utf
	iconv -t cp1251 demokick.utf -o demokick.lua
