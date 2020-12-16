public MVPCategori(int client, int start) {
	Menu menu = new Menu(MVPCategoriHandler)
	
	menu.AddItem("", "Rap/Trap")
	menu.AddItem("", "Manele") 
	
	menu.ExitBackButton = true
	menu.DisplayAt(client, 0, 0)
}

public MVPCategoriHandler(Menu menu, MenuAction action, int client, int param) {
	if(action == MenuAction_Select)
        MVPMenu(client, 0, param + 1) 
	else if (action == MenuAction_Cancel && param == MenuCancel_ExitBack)
		MainMenu(client)
}

public MVPMenu(int client, int start, int categorie) {
	Menu mvp_menu = new Menu(handlerMVPMenu)
	 
	mvp_menu.SetTitle("Alegeti melodia care v-a canta MVP.")

	mvp_menu.AddItem("", "Dezactiveaza")
	
	char string[100]
	for(int i = 1; i < soundCount; i++) {
		if(gSoundCateg[i] == categorie) {
			if(Selected[client][0] == FindMVPIDByName(gSoundName[i])) {
				FormatEx(string, 100, "%s - Selectat", gSoundName[i])
				mvp_menu.AddItem(gSoundName[i], string)
			} 
			else mvp_menu.AddItem(gSoundName[i], gSoundName[i])
		}	
	}
	mvp_menu.ExitBackButton = true
	mvp_menu.DisplayAt(client, start, 0)
}

public handlerMVPMenu(Menu menu, MenuAction action, int client,int param) {
	if(action == MenuAction_Select) {
		char mvp_name[1024]
		GetMenuItem(menu, param, mvp_name, sizeof(mvp_name))
		
		if(StrEqual(mvp_name, ""))
            Selected[client][0] = 0
		else { 
 			int id = FindMVPIDByName(mvp_name)
			Selected[client][0] = id
			strcopy(NameMVP[client], sizeof(NameMVP[]), mvp_name)
			SetClientCookie(client, CMvpName, mvp_name)
		}
		MVPMenu(client, menu.Selection, gSoundCateg[FindMVPIDByName(mvp_name)])
	}
	else if (action == MenuAction_Cancel && param == MenuCancel_ExitBack)
		MVPCategori(client, 0)
}
