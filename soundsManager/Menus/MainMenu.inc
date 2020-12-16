public MainMenu(int client) {
	if(menuDisplay[client])
		return 
		
	Menu mvp_menu = new Menu(handlerMVP)
	 
	mvp_menu.SetTitle("ARENA.GGEZ.RO")
	
	mvp_menu.AddItem("", "MVP Player Sounds")
	mvp_menu.AddItem("", "No Scope Player Sounds")
	mvp_menu.AddItem("", "Premium Sounds")
	
	char string[30] 
    
	FormatEx(string, 30, "Volume: %f%", clinetVolume[client])
	mvp_menu.AddItem("", string);  

	FormatEx(string, 30, "%s Sunetele", soundsOn[client] ? "Dezactiveaza" : "Activeaza")
	mvp_menu.AddItem("", string);  
	
	mvp_menu.DisplayAt(client, 0, 0);

	menuDisplay[client] = true 
}

public handlerMVP(Menu menu, MenuAction action, int client, int param) {
	menuDisplay[client] = false
	if (action == MenuAction_Select) { 
        switch(param) {
       		case 0: MVPCategori(client, 0)
       		case 1: NoScopeSounds(client, 0)
			// case 2: PremiumSounds(client, 0)
            case 3: VolumeMenu(client)
       		case 4: {
       			soundsOn[client] = !soundsOn[client]
       			MainMenu(client)

       			char str[10]
       			FormatEx(str, 10, "%d", soundsOn[client])
       			SetClientCookie(client, CSoundsOn, str)
       		}
       		default: PrintToChat(client, "In curand")
      	} 
    }
	else if (action == MenuAction_Cancel) 
        delete menu 
}