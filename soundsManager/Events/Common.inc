public void OnPluginStart() {
	RegConsoleCmd("sm_sounds", CommandMVP)
	RegConsoleCmd("sm_mvp", CommandMVP)
	RegConsoleCmd("sm_mvpsound", CommandMVP)
	
	CMvpName = RegClientCookie("mvp_name", "", CookieAccess_Private)
	CSoundsOn = RegClientCookie("sounds_on", "", CookieAccess_Private)
	CNscName = RegClientCookie("noscope_name", "", CookieAccess_Private)
	
	HookEvent("player_death", Event_PlayerDeath)  
	
	for (new i = MaxClients; i > 0; --i) {
		if (!AreClientCookiesCached(i))
			continue
		
		OnClientCookiesCached(i)
	}
}

public void OnConfigsExecuted() {
	LoadConfig() 
}

public void OnClientPutInServer(int client) {
	if (IsValidClient(client) && !IsFakeClient(client))	
		OnClientCookiesCached(client)
		
	menuDisplay[client] = false
}

public void OnClientCookiesCached(int client) {
	if(!IsValidClient(client) && IsFakeClient(client))	
		return
		
	char scookie[1024]

	GetClientCookie(client, CMvpName, scookie, sizeof(scookie)) 
	if(!StrEqual(scookie, "")) {
		int id = FindMVPIDByName(scookie)
 
		Selected[client][0] = id 
		strcopy(NameMVP[client], sizeof(NameMVP[]), scookie) 
	}
	else if(StrEqual(scookie,""))	Format(NameMVP[client], sizeof(NameMVP[]), "") 
		
	GetClientCookie(client, CSoundsOn, scookie, sizeof(scookie)) 
	if(!StrEqual(scookie, "")) {
		soundsOn[client] = StringToInt(scookie) ? true : false
	}
	else if(StrEqual(scookie,""))	soundsOn[client] = true
	
	GetClientCookie(client, CNscName, scookie, sizeof(scookie))  
	if(!StrEqual(scookie, "")) {
		int id = FindMVPIDByName(scookie)
 
		Selected[client][1] = id 
		strcopy(NameNSC[client], sizeof(NameNSC[]), scookie) 
	}
	else if(StrEqual(scookie,""))	Format(NameNSC[client], sizeof(NameNSC[]), "") 

	GetClientCookie(client, CVolName, scookie, sizeof(scookie))
	if(!StrEqual(scookie, "")) {
		clinetVolume[client] = StringToFloat(scookie)
	}
	else if(StrEqual(scookie, "")) clinetVolume[client] = 1.0
}
  
