int 
    soundCount, Selected[MAXPLAYERS + 1][2], 
    gSoundCateg[MAX_SOUNDS_COUNT + 1]

bool 
    soundsOn[MAXPLAYERS + 1] = true, 
    menuDisplay[MAXPLAYERS + 1] = false

char 
    Configfile[1024], 
	gSoundName[MAX_SOUNDS_COUNT + 1][1024], 
	gSoundFile[MAX_SOUNDS_COUNT + 1][1024], 
	NameNSC[MAXPLAYERS + 1][1024],
	NameMVP[MAXPLAYERS + 1][1024]

Handle 
	CMvpName,
	CSoundsOn,
	CNscName