public Action Event_PlayerDeath(Handle event, const char[] name, bool dontBroadcast) { 
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
							
							EmitSoundToClient(p[i], sound, SOUND_FROM_PLAYER, SNDCHAN_STATIC, SNDLEVEL_NONE, _, clinetVolume[p[i]]) 
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
						 
						EmitSoundToClient(p[i], sound, SOUND_FROM_PLAYER, SNDCHAN_STATIC, SNDLEVEL_NONE, _, clinetVolume[p[i]])
					}	
				
				} 
			}
				
		}
	}
}     