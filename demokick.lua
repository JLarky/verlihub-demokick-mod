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
    	 SendMessageToUser(string.format("начинаем кикать..."), nick, botname)
	 if not demo_kickers then demo_kickers = {};end
         if not demo_kickers[nick] then demo_kickers[nick] = 0; end
	 -- теперь в demo_kickers[nick] у нас написано когда чел в последний раз кикал
	 local now = os.time()
	 local diff_time=os.difftime(now, demo_kickers[nick])
	 -- demo_kickers[nick]=now надо делать позже
	 -- теперь в diff_time врем€ с прошлого кика
	 
	 if not demo_kicked then demo_kicked = {} end
	 if not demo_kicked[nick2kick] then demo_kicked[nick2kick] = {} end
	 if diff_time<10 then 
    	  SendMessageToUser(string.format(" икать слишком часто вредно :) "..diff_time), nick, botname)
	 else
	  demo_kickers[nick]=now
	  local signes = demo_kicked[nick2kick]
	  signes[nick]=now
	  local i=0
	  
	  for nick, time in pairs(signes) do 
	   if os.difftime(now, time) < 100 then
	    i=i+1
	   end
	  end
	  
	  -- здесь в i будет количество человеков которые _недавно_ хотели забанить nick2kick
	  
	  SendMessageToUser(string.format("убивцев: "..i), nick, botname)
	 end
	 return nil
	else
	 SendMessageToUser(string.format("ѕользовател€ "..nick2kick.." нет или чЄ-то глючит"), nick, botname)
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
