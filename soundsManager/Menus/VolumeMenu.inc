
public VolumeMenu(int client) {
    Menu vMenu = new Menu(handlerVolume)

    vMenu.SetTitle("Volume")
 
    vMenu.AddItem("0.2", "20%");
    vMenu.AddItem("0.4", "40%");
    vMenu.AddItem("0.6", "60%");
    vMenu.AddItem("0.8", "80%");
    vMenu.AddItem("1.0", "100%");

    vMenu.DisplayAt(client, 0, 0);
}

public handlerVolume(Menu menu, MenuAction action, int client, int param) {
    if(action == MenuAction_Select) { 
        char volume[100]

        GetMenuItem(menu, param, volume, sizeof(volume)) 

        clinetVolume[client] = StringToFloat(volume)
    
        SetClientCookie(client, CVolName, volume)
    }
}