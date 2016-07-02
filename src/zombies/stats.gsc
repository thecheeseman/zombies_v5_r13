/*
    Zombies, Version 5, Revision 13
    Copyright (C) 2016, DJ Hepburn

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

init() {
	[[ level.logwrite ]]( "zombies\\stats.gsc::init()", true );

	level.loadingstats = false;
	level.statsvalidfields = [];

	addStatField( "guid" );
	addStatField( "playerName", "string" );
	addStatField( "permissions" );

	// server related
	addStatField( "joins" );
	addStatField( "timePlayed" );
	addStatField( "timesAsLastHunter" );
	addStatField( "lastHunterKills" );

	// old system holdovers
	addStatField( "xp" );
	addStatField( "rank" );
	addStatField( "points" );
	// old system holdovers

	// rank related
	addStatField( "hunterXP" );
	addStatField( "hunterRank" );
	addStatField( "hunterPoints" );
	addStatField( "zombieXP" );
	addStatField( "zombieRank" );
	
	// general statistics
	addStatField( "kills" );
	addStatField( "deaths" );
	addStatField( "bashes" );
	addStatField( "damage" );
	addStatField( "headshots" );
	addStatField( "assists" );
	addStatField( "shotsFired" );
	addStatField( "shotsHit" );
	addStatField( "combatSentryKills" );
	addStatField( "sentryKills" ); 
	addStatField( "totalKills" );
	addStatField( "totalDeaths" );
	addStatField( "totalBashes" );
	addStatField( "totalDamage" );
	addStatField( "totalHeadshots" );
	addStatField( "totalAssists" );
	addStatField( "totalShotsFired" );
	addStatField( "totalShotsHit" );
	addStatField( "totalCombatSentryKills" );
	addStatField( "totalSentryKills" );

	// class related
	addStatField( "jumperZombieKills" );
	addStatField( "fastZombieKills" );
	addStatField( "poisonZombieKills" );
	addStatField( "fireZombieKills" );
	addStatField( "killsAsJumperZombie" );
	addStatField( "killsAsFastZombie" );
	addStatField( "killsAsPoisonZombie" );
	addStatField( "killsAsFireZombie" );
	addStatField( "hpHealed" );
	addStatField( "ammoHealed" );
	addStatField( "combatEngineerKills" );
	addStatField( "engineerKills" );
	addStatField( "combatMedicKills" );
	addStatField( "medicKills" );
	addStatField( "combatSupportKills" );
	addStatField( "supportKills" );
	addStatField( "combatSniperKills" );
	addStatField( "sniperKills" );
	addStatField( "reconKills" );
	addStatField( "killsAsCombatEngineer" );
	addStatField( "killsAsEngineer" );
	addStatField( "killsAsCombatMedic" );
	addStatField( "killsAsMedic" );
	addStatField( "killsAsCombatSupport" );
	addStatField( "killsAsSupport" );
	addStatField( "killsAsCombatSniper" );
	addStatField( "killsAsSniper" );
	addStatField( "killsAsRecon" );

	// end of file
	addStatField( "eof" );
}

addStatField( fieldname, type ) {
	// doublecheck if adding twice
	if ( isDefined( getStatField( fieldname ) ) ) {
		return;
	}

	if ( !isDefined( type ) ) {
		type = "int";
	}

	id = level.statsvalidfields.size;

	field = spawnstruct();
	field.id = id;
	field.name = fieldname;
	field.type = type;

	level.statsvalidfields[ id ] = field;
}

getStatField( fieldname ) {
	for ( i = 0; i < level.statsvalidfields.size; i++ ) {
		field = level.statsvalidfields[ i ];
		if ( field.name == fieldname ) {
			return field;
		}
	}

	return undefined;
}
/*
statLUTLookup( guid ) {
	for ( i = 0; i < level.statsLUT.size; i++ ) {
		stat = level.statsLUT[ i ];
		if ( guid == stat ) {
			return true;
		}
	}

	return false;
}

addToLUT() {
	if ( !statLUTLookup( self.guid ) ) {
		level.statsLUT[ level.statsLUT.size ] = self.guid;
	}
}

writeLUT() {
	lutname = "stats/index.dat";
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::writeLUT() -- load file" + lutname, true );

	handle = fopen( lutname, "w" );
	if ( handle == -1 ) {
		fse( "problem opening file " + lutname );
		[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::writeLUT() -- problem opening file" + lutname );
		return;
	}

	data = "";
	for ( i = 0; i < level.statsLUT.size; i++ ) {
		if ( level.statsLUT[ i ] != "" ) {
			data += level.statsLUT[ i ] + ",\n";
		}
	}

	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::writeLUT() -- write data to " + lutname, true );
	fwrite( data, handle );

	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::writeLUT() -- close file" + lutname, true );
	fclose( handle );
}
*/
saveAll() {
	players = utilities::getPlayersOnTeam( "any" );
	for ( i = 0; i < players.size; i++ ) {
		players[ i ] saveMyStats();
		//players[ i ] addToLUT();
	}

	//writeLUT();
}

saveMyStats() {
	lutname = "stats/players/" + self.guid + ".dat";
	[[ level.logwrite ]]( "zombies\\stats.gsc::saveMyStats() -- load file " + lutname, true );

	handle = fopen( lutname, "w" );
	if ( handle == -1 ) {
		fse( "problem opening file " + lutname );
		[[ level.logwrite ]]( "zombies\\stats.gsc::saveMyStats() -- problem opening file " + lutname );
		return;
	}

	self.stats[ "totalKills" ] += self.stats[ "kills" ];
	self.stats[ "totalDeaths" ] += self.stats[ "deaths" ];
	self.stats[ "totalBashes" ] += self.stats[ "bashes" ];
	self.stats[ "totalDamage" ] += self.stats[ "damage" ];
	self.stats[ "totalHeadshots" ] += self.stats[ "headshots" ];
	self.stats[ "totalAssists" ] += self.stats[ "assists" ];
	self.stats[ "totalShotsFired" ] += self.stats[ "shotsFired" ];
	self.stats[ "totalShotsHit" ] += self.stats[ "shotsHit" ];
	self.stats[ "totalCombatSentryKills" ] += self.stats[ "combatSentryKills" ];
	self.stats[ "totalSentryKills" ] += self.stats[ "sentryKills" ];

	self.stats[ "timePlayed" ] += (gettime() - self.timejoined) / 1000;

	self.stats[ "guid" ] = self.guid;
	self.stats[ "hunterXP" ] = self.xp;
	self.stats[ "hunterRank" ] = self.rank;
	self.stats[ "hunterPoints" ] = self.points;
	self.stats[ "zombieXP" ] = self.zomxp;
	self.stats[ "zombieRank" ] = self.zomrank;

	data = "";

	for ( i = 0; i < level.statsvalidfields.size; i++ ) {
		s = level.statsvalidfields[ i ];

		if ( s.name == "eof" )
			break;

		switch ( s.name ) {
			// skip
			case "xp":
			case "rank":
			case "points":
			case "kills":
			case "deaths":
			case "bashes":
			case "damage":
			case "headshots":
			case "assists":
			case "shotsFired":
			case "shotsHit":
			case "sentryKills":
			case "combatSentryKills":
			case "playerName":
				continue;
				break;
		}

		data += s.name + ": " + self.stats[ s.name ] + ",\n";
	}

	data += "eof\n";

	[[ level.logwrite ]]( "zombies\\stats.gsc::saveMyStats() -- write data to file " + lutname, true );
	fwrite( data, handle );

	[[ level.logwrite ]]( "zombies\\stats.gsc::saveMyStats() -- close file " + lutname, true );
	fclose( handle );
}

getMyStats() {
	self.guid = utilities::getNumberedName( self.oldname );

	// quick check to prevent too much file io
	//if ( !statLUTLookup( self.guid ) ) {
	//	return;
	//}

	lutname = "stats/players/" + self.guid + ".dat";
	if ( !fexists( lutname ) ) {
		return;
	}

	[[ level.logwrite ]]( "zombies\\stats.gsc::getMyStats() -- open file " + lutname, true );
	handle = fopen( lutname, "r" );
	if ( handle != -1 ) {
		data = freadfile( handle );
		if ( !isDefined( data ) || data[ 0 ] == "" ) {
			fclose( handle );
			return;
		}

		[[ level.logwrite ]]( "zombies\\stats.gsc::getMyStats() -- close file " + lutname, true );
		fclose( handle );

		fieldsnvalues = utilities::explode( data, "," );
		for ( i = 0; i < fieldsnvalues.size; i++ ) {
			fnv = fieldsnvalues[ i ];

			if ( fnv == "" )
				continue;

			arr = utilities::explode( fnv, ":" );
			field = utilities::strreplacer( utilities::strip( arr[ 0 ] ), "alphanumeric" );
			value = utilities::strreplacer( utilities::strip( arr[ 1 ] ), "alphanumeric" );

			if ( field == fnv && field != "eof" && field != "#" ) {
				//fse( "invalid formatting in file " + lutname );
				[[ level.logwrite ]]( "zombies\\stats.gsc::getMyStats() -- invalid formatting in file " + lutname );
				break;
			}

			// reached end of file
			if ( field == "eof" ) {	
				break;
			}

			// comments are allowed
			if ( field.size > 0 && field[ 0 ] == "#" ) {
				continue;
			}

			fieldstruct = getStatField( field );
			if ( !isDefined( fieldstruct ) ) {
				//fse( "invalid stat field: " + field + " in file " + lutname );
				[[ level.logwrite ]]( "zombies\\stats.gsc::getMyStats() -- invalid stat field: " + field + " in file " + lutname );
				break;
			}

			// clean up any extraneous characters
			if ( fieldstruct.type == "int" || fieldstruct.type == "float" ) {
				value = utilities::strreplacer( value, "numeric" );
			}

			switch ( field ) {
				// transition from old system
				case "xp":					self.stats[ "hunterXP" ] = 				(int) value; break;
				case "rank":				self.stats[ "hunterRank" ] = 			(int) value; break;
				case "points":				self.stats[ "hunterPoints" ] = 			(int) value; break;
				case "kills":				self.stats[ "totalKills" ] =			(int) value; break;
				case "deaths":				self.stats[ "totalDeaths" ] =			(int) value; break;
				case "bashes":				self.stats[ "totalBashes" ] =			(int) value; break;
				case "damage":				self.stats[ "totalDamage" ] =			(int) value; break;
				case "headshots":			self.stats[ "totalHeadshots" ] =		(int) value; break;
				case "assists":				self.stats[ "totalAssists" ] =			(int) value; break;
				case "shotsfired":			self.stats[ "totalShotsFired" ] =		(int) value; break;
				case "shotshit":			self.stats[ "totalShotsHit" ] =			(int) value; break;

				// new system
				default:
					switch ( fieldstruct.type ) {
						case "int":
							self.stats[ fieldstruct.name ] = (int) value;
							break;
						case "float":
							self.stats[ fieldstruct.name ] = (float) value;
							break;
						default:
							self.stats[ fieldstruct.name ] = value;
							break;
					}
					break;
			}
		}

		self.stats[ "playerName" ] = self.name;
		self.xp = self.stats[ "hunterXP" ];
		self.rank = self.stats[ "hunterRank" ];
		self.points = self.stats[ "hunterPoints" ];
		self.zomxp = self.stats[ "zombieXP" ];
		self.zomrank = self.stats[ "zombieRank" ];

		self.stats[ "joins" ]++;
	} else {
		fse( "problem opening file " + lutname );
		[[ level.logwrite ]]( "zombies\\stats.gsc::getMyStats() -- problem opening file " + lutname, true );
	}
}

resetStatsVars() {

}

setupPlayer() {
	self.stats = [];

	for ( i = 0; i < level.statsvalidfields.size; i++ ) {
		s = level.statsvalidfields[ i ];

		if ( s.name == "eof" ) 
			continue;

		switch ( s.type ) {
			case "string":
				self.stats[ s.name ] = "";
				break;
			default:
				self.stats[ s.name ] = 0;
				break;
		}
	}

	self thread getMyStats();
}

// file system error
fse( error, serious ) {
	if ( isDefined( serious ) && serious ) {
		iPrintLnBold( "^1fse: ^7" + error );
		printconsole( "!!!!! fse: " + error + "\n" );
	} else {
		iPrintLn( "^1fse: ^7" + error );
		printconsole( "fse: " + error + "\n" );
	}
}
