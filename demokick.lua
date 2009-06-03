-- demokick.lua

-- JLarky <jlarky@gmail.com>
-- кикает со всей демократией


_, botname = VH:GetConfig("config", "hub_security")

function VH_OnParsedMsgChat(nick,data)
 if string.find(data, "^%.kick", 1) then
  nick2kick = data:match("^.kick (.+)$")
  if nick2kick then nick2kick=nick2kick else nick2kick="" end
  result, sIP = VH:GetUserIP(nick2kick)
    if string.len(sIP)>0 then
    	 SendMessageToUser(string.format("ok"..sIP), nick, botname)
	 return nil
	else
	 SendMessageToUser(string.format("Пользователя "..nick2kick.." нет или чё-то глючит"), nick, botname)
	 return nil
    end
 end
 return 1
end

function SendMessageToUser(data, nick, from)
	result, err = VH:SendDataToUser("<"..from.."> "..data.."|", nick)
	return 1
end

function SendPmMessageToUser(data, nick, from)
	result, err = VH:SendDataToUser("$To: "..nick.." From: "..from.." $<"..from.."> "..data.."|", nick)
	return 1
end
