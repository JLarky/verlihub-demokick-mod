-- demokick.lua

-- JLarky <jlarky@gmail.com>
-- ������ �� ���� �����������


_, botname = VH:GetConfig("config", "hub_security")
vote_delay=60
max_votes =5
vote_time =180

function VH_OnParsedMsgChat(nick,data)
 if string.find(data, "^%.([un]*)kick", 1) then
  local nick2kick = data:match("^.kick (.+)$")
  local nick2unkick = data:match("^.unkick (.+)$")
  if nick2kick then 
   action=1
  elseif nick2unkick then
   action=-1
   nick2kick=nick2unkick
  else  
   action=0
   nick2kick=""
  end
  local nick2kick = string.lower(nick2kick)
  result, sIP = VH:GetUserIP(nick2kick)
  result, kIP = VH:GetUserIP(nick)
    if string.len(sIP)>0 then
	 --SendMessageToUser(string.format("�������� ������..."), nick, botname)
	 if not demo_kickers then demo_kickers = {};end
         if not demo_kickers[kIP] then demo_kickers[kIP] = {0, 0}; end
	 -- ������ � demo_kickers[kIP] � ��� �������� ����� ��� � ��������� ��� �����
	 local now = os.time()
	 local diff_time=os.difftime(now, demo_kickers[kIP][1])
	 -- demo_kickers[kIP]=now ���� ������ �����
	 -- ������ � diff_time ����� � �������� ����
	 
	 if not demo_kicked then demo_kicked = {} end
	 if not demo_kicked[nick2kick] then demo_kicked[nick2kick] = {} end
	 if diff_time<vote_delay then
    	  SendMessageToUser(string.format("������ ������� ����� ������ :) ������� "..(vote_delay-diff_time).." ������."), nick, botname)
	 else
	  if not (kIP == "217.197.6.21") then
	    demo_kickers[kIP]={now, action}
	  end
	  local signes = demo_kicked[nick2kick]
	  signes[nick]={now, action}
	  local i=0
  
	  for nick, blabla in pairs(signes) do
   	   if os.difftime(now, blabla[1]) < vote_time then -- 3*60
	    i=i+blabla[2]
	   end
	  end
	  
	  -- ����� � i ����� ���������� ��������� ������� _�������_ ������ �������� nick2kick
	  
	  --SendMessageToUser(string.format("�������: "..i), nick, botname)
	  if action==1 then
	  msg = "�� ���"
	  else
	  msg = "�� ������"
	  end
	  SendMessageToAll(string.format(msg.." ������������ "..nick2kick.." ������������(�) "..nick..". ����� �������: "..i.." �� "..max_votes.."."), botname)
	  
	  
	  if i >= max_votes then
	   result, iClass = VH:GetUserClass(nick2kick)
	   if iClass <6 then
	    VH:KickUser(botname, nick2kick, "��� ������ �����.")
	   end
	   demo_kicked[nick2kick]={}
	  end
	  demo_kicked[nick2kick]=signes
	 end
	 return nil
	else
	 SendMessageToUser(string.format("������������ "..nick2kick.." ��� ��� ��-�� ������"), nick, botname)
	 return nil
    end
 elseif string.find(data, "^%.p ", 1) then
 local nick2protect = string.lower(data:match("^.p (.+)$"))
 if not demo_kicked then demo_kicked = {} end
 if not demo_kicked[nick2protect] then demo_kicked[nick2protect] = {} end
  result, iClass = VH:GetUserClass(nick)
  if iClass == 10 then
   demo_kicked[nick2protect][nick]={os.time(), -10}
   SendMessageToAll(string.format(nick2protect.." ������� � �������� ����� "..nick.." ������ �� 10 �����, ��������� �������"), botname)
  end
  return nil
 end
 return 1
end

function SendMessageToUser(data, nick, from)
	result, err = VH:SendDataToUser("<"..from.."> "..data.."|", nick)
	return 1
end

function SendMessageToAll(data, from)
	result, err = VH:SendDataToAll("<"..from.."> "..data.."|", 0, 10)
	return 1
end

function SendPmMessageToUser(data, nick, from)
	result, err = VH:SendDataToUser("$To: "..nick.." From: "..from.." $<"..from.."> "..data.."|", nick)
	return 1
end
