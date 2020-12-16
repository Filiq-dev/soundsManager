// plugin started from https://github.com/rogeraabbccdd/CSGO-MVP
 
#include <sourcemod>
#include <clientprefs>
#include <sdktools>   



#define MAX_SOUNDS_COUNT 1000

public Plugin myinfo = 
{
	name = "Sounds System",
	author = "Filiq_",
	description = "",
	version = "0.0.4",
	url = ""
}

#include "soundsManager/Variables.inc" 

#include "soundsManager/Events/Common.inc"
#include "soundsManager/Events/Death.inc" 

#include "soundsManager/Commands.inc"
#include "soundsManager/Menus/MVPMenu.inc"
#include "soundsManager/Menus/NSC.inc"
#include "soundsManager/Menus/MainMenu.inc"
 
#include "soundsManager/Loads.inc"
#include "soundsManager/Utils.inc"