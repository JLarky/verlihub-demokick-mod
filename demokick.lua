-- demokick.lua

-- JLarky <jlarky@gmail.com>
-- ������ �� ���� �����������


_, botname = VH:GetConfig("config", "hub_security")

function VH_OnParsedMsgChat(nick,data)
 if string.find(data, "^%.kick", 1) then
  nick2kick = data:match("^.kick (.+)$")
  result, sIP = VH:GetUserIP(nick2kick)
    if result then
    	 SendMessageToUser(string.format("ok"), nick, botname)
	else
	 SendMessageToUser(string.format("������������ "..nick2kick.." ��� ��� ��-�� ������"), nick, botname)
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
