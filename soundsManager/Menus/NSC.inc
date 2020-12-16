public NoScopeSounds(int client, int start) {
	Menu mvp_menu = new Menu(handlerNSCMenu)
	 
	mvp_menu.SetTitle("Alegeti melodia care v-a canta la No-Scope.")
	
	mvp_menu.AddItem("", "Dezactiveaza")
	
	char string[100]
	for(int i = 1; i < soundCount; i++) {
		if(gSoundCateg[i] == 3) {
			if(Selected[client][1] == FindMVPIDByName(gSoundName[i])) {
				FormatEx(string, 100, "%s - Selectat", gSoundName[i])
				mvp_menu.AddItem(gSoundName[i], string); 
			} 
			else mvp_menu.AddItem(gSoundName[i], gSoundName[i])
		}	
	}
	mvp_menu.ExitBackButton = true
	mvp_menu.DisplayAt(client, start, 0)
}

public handlerNSCMenu(Menu menu, MenuAction action, int client,int param)  {
	if(action == MenuAction_Select) {
		char mvp_name[1024]
		GetMenuItem(menu, param, mvp_name, sizeof(mvp_name))
		
		if(StrEqual(mvp_name, "")) 
			Selected[client][1] = 0
		else { 
 			int id = FindMVPIDByName(mvp_name)
			Selected[client][1] = id
			strcopy(NameNSC[client], sizeof(NameNSC[]), mvp_name)
			SetClientCookie(client, CNscName, mvp_name)
		}
		NoScopeSounds(client, 0)
	}
	else if (action == MenuAction_Cancel && param == MenuCancel_ExitBack)
		MainMenu(client)
}
