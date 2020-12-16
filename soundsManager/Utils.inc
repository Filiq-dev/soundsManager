
stock bool IsValidClient(int client) {
    return client > 0 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client);
}

stock int FindMVPIDByName(char [] name) {
	int id = 0
	
	for(int i = 1; i <= soundCount; i++) 
        if(StrEqual(gSoundName[i], name))	id = i
	
	return id
}

stock void FakePrecacheSound(const char[] szPath) {
    AddToStringTable(FindStringTable("soundprecache"), szPath)
}