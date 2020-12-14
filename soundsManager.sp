// plugin started from https://github.com/rogeraabbccdd/CSGO-MVP


#include "include/multi1v1.inc"
#include "multi1v1/generic.sp"
#include "multi1v1/version.sp"
#include <sourcemod>
#include <clientprefs>
#include <sdktools>  

#define MAX_SOUNDS_COUNT 1000

public Plugin myinfo = 
{
	name = "Sounds System",
	author = "Filiq_",
	description = "",
	version = "0.3.3",
	url = ""
}

int soundCount, Selected[MAXPLAYERS + 1][2], gSoundCateg[MAX_SOUNDS_COUNT + 1]
bool soundsOn[MAXPLAYERS + 1] = true, menuDisplay[MAXPLAYERS + 1] = false

char 
    Configfile[1024], 
	gSoundName[MAX_SOUNDS_COUNT + 1][1024], 
	gSoundFile[MAX_SOUNDS_COUNT + 1][1024],
	gSoundFlags[MAX_SOUNDS_COUNT + 1][AdminFlags_TOTAL], 
	NameNSC[MAXPLAYERS + 1][1024],
	NameMVP[MAXPLAYERS + 1][1024];

Handle 
	CMvpName,
	CSoundsOn,
	CNscName

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

public void OnConfigsExecuted() 
	LoadConfig() 

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
}
  
public Action Event_PlayerDeath(Handle event, const String name[ ], bool dontBroadcast) { 
	new victim = GetClientOfUserId(GetEventInt(event, "userid"))
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker")) 

	if(Selected[attacker][1] != 0 || Selected[attacker][0] != 0){ 
		if(IsValidClient(attacker) && IsValidClient(victim) && victim != attacker) {
			char 
                Weapon[64],
                sound[1024]

			GetEventString(event, "weapon", Weapon, sizeof(Weapon)) 
		
			if((StrContains(Weapon, "awp") != -1 || StrContains(Weapon, "ssg08") != -1) && Selected[attacker][1] != 0) {
				Format(sound, sizeof(sound), "*/%s", gSoundFile[Selected[attacker][1]])
				
				if(GetEntProp( attacker, Prop_Data, "m_iFOV" ) == 0) {
					int p[2]

					p[0] = attacker 
					p[1] = victim
				 
					for(int i = 0; i < 2; i++) {
						if(soundsOn[p[i]] == true) {  
							ClientCommand(p[i], "playgamesound Music.StopAllMusic")
							ClientCommand(p[i], "playgamesound Music.StopAllMusic")
							
							EmitSoundToClient(p[i], sound, SOUND_FROM_PLAYER, SNDCHAN_STATIC, SNDLEVEL_NONE, _, 1.0) 
						}	
					
					} 
					PrintToChatAll( "*\x03 %N\x02 noscoped\x04 %N\x01! Git rekt n00b!", attacker, victim) 
				} 
			} else if(Selected[attacker][0] != 0) {
				Format(sound, sizeof(sound), "*/%s", gSoundFile[Selected[attacker][0]])
				
				int p[2]

				p[0] = attacker 
				p[1] = victim

				for(int i = 0; i < 2; i++) {
					if(soundsOn[p[i]] == true) {  
						PrintHintText(p[i], "%N's sound %s", attacker, gSoundName[Selected[attacker][0]]);
						ClientCommand(p[i], "playgamesound Music.StopAllMusic")
						ClientCommand(p[i], "playgamesound Music.StopAllMusic")
						 
						EmitSoundToClient(p[i], sound, SOUND_FROM_PLAYER, SNDCHAN_STATIC, SNDLEVEL_NONE, _, 1.0)
					}	
				
				} 
			}
				
		}
	}
}

public Action CommandMVP(int client, int args) 
	MainMenu(client)

public MainMenu(int client) {
	if(menuDisplay[client])
		return 
		
	Menu mvp_menu = new Menu(handlerMVP)
	 
	mvp_menu.SetTitle("ARENA.GGEZ.RO")
	
	mvp_menu.AddItem("", "MVP Player Sounds")
	mvp_menu.AddItem("", "No Scope Player Sounds")
	mvp_menu.AddItem("", "Premium Sounds")
	
	char string[30]

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
       		case 3: {
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

void LoadConfig() {
	BuildPath(Path_SM, Configfile, 1024, "configs/sounds.cfg")
	
	if(!FileExists(Configfile))
		SetFailState("Can not find config file \"%s\"!", Configfile)
	
	KeyValues kv = CreateKeyValues("SOUNDS")
	kv.ImportFromFile(Configfile)
	
	soundCount = 1

	if(kv.GotoFirstSubKey()) {
		char 
            name[1024],
		    file[1024],
		    flag[AdminFlags_TOTAL],
		    categ[10],
            filepath[1024],
            soundpath[1024]
    
		do {
			kv.GetSectionName(name, sizeof(name))
			kv.GetString("file", file, sizeof(file))
			kv.GetString("flag", flag, sizeof(flag), "")
			kv.GetString("categorie", categ, sizeof(categ))
			
			strcopy(gSoundName[soundCount], sizeof(gSoundName[]), name)
			strcopy(gSoundFile[soundCount], sizeof(gSoundFile[]), file)
			strcopy(gSoundFlags[soundCount], sizeof(gSoundFlags[]), flag)
			
			gSoundCateg[soundCount] = StringToInt(categ)
				 
			Format(filepath, sizeof(filepath), "sound/%s", gSoundFile[soundCount])
			AddFileToDownloadsTable(filepath)
			 
			Format(soundpath, sizeof(soundpath), "*/%s", gSoundFile[soundCount])
			FakePrecacheSound(soundpath)
			
			soundCount++
		}
		while (kv.GotoNextKey())
	}
	
	kv.Rewind()
	delete kv
} 

int FindMVPIDByName(char [] name) {
	int id = 0
	
	for(int i = 1; i <= soundCount; i++) 
        if(StrEqual(gSoundName[i], name))	id = i
	
	return id
}

stock void FakePrecacheSound(const char[] szPath)
    AddToStringTable(FindStringTable("soundprecache"), szPath)