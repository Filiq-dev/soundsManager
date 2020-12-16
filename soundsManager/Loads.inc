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
		    categ[10],
            filepath[1024],
            soundpath[1024]
    
		do {
			kv.GetSectionName(name, sizeof(name))
			kv.GetString("file", file, sizeof(file)) 
			kv.GetString("categorie", categ, sizeof(categ))
			
			strcopy(gSoundName[soundCount], sizeof(gSoundName[]), name)
			strcopy(gSoundFile[soundCount], sizeof(gSoundFile[]), file) 
			
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