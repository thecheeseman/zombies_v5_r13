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

/*
	If you do not have CoDExtended or don't want to run it, 
	just rename this file as something else and replace it with
	_stats_legacy.gsc
*/

/*
	stats/index.dat

	Just a basic list of GUIDs of all the players who have
	stats saved in their own files - to be used as a LUT for
	when players connect

	This is the only file actually "loaded" by the server on
	game start

	Comma-separated guid list

	Example:
	3457,
	123,
	6583,
	etc.
*/

/*
	stats/players/guid.dat

	These are each individual player's stats, stored in their
	own file and only read when that player has connected

	Colon-separated, comma-delimited - whitespace ignored

	File contents are as follows:
	guid: 123,
	playername: zombies.cheese,
	xp: 55000,
	rank: 10,
	zombiexp: 500,
	zombierank: 25,
	eof

	Valid fields:
	guid, playername, xp, rank, points, zombiexp, zombierank,
	kills, deaths, bashes, damage, headshots, assists,
	shotsfired, shotshit, eof
*/

main() {
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::main()", true );

	level.loadingstats = true;
	
	level.loadingmessage = newHudElem();
	level.loadingmessage.x = 320;
	level.loadingmessage.y = 200;
	level.loadingmessage.fontscale = 1;
	level.loadingmessage.alignx = "center";
	level.loadingmessage.aligny = "middle";
	level.loadingmessage setText( &"LOADING STATS" );
	level.loadingmessage.alpha = 1;

	level.statsLUT = [];

	

	// file loading logic
	lutname = "stats/index.dat";
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::main() -- load file " + lutname, true );

	if ( !fexists( lutname ) ) {
		handle = fopen( lutname, "w" );
		if ( handle != -1 ) {
			fwrite( "", handle );
			fclose( handle );
		}
	}

	handle = fopen( lutname, "r" );
	if ( handle != -1 ) {
		data = fread( fsize( handle ), handle );
		if ( !isDefined( data ) || data[ 0 ] == "" ) {
			[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::main() -- no stats found in file " + lutname );
		}

		[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::main() -- close file " + lutname, true );
		fclose( handle );

		arr = maps\mp\gametypes\_zombie::explode( data, "," );
		for ( i = 0; i < arr.size; i++ ) {
			guid = maps\mp\gametypes\_zombie::strreplacer( maps\mp\gametypes\_zombie::strip( arr[ i ] ), "onlynumbers" );
			level.statsLUT[ level.statsLUT.size ] = guid;
		}
	} else {
		fse( "problem reading " + lutname, true );
		[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::main() -- problem reading " + lutname );
	}

	// end file loading logic
	
	wait 1;
	
	level.loadingstats = false;
	level.loadingmessage destroy();

	level.statsvalidfields = [];

	addStatField( "guid" );
	addStatField( "playerName", "string" );

	// server related
	addStatField( "joins" );
	addStatField( "timePlayed" );

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
	addStatField( "sentryKills" );
	addStatField( "totalKills" );
	addStatField( "totalDeaths" );
	addStatField( "totalBashes" );
	addStatField( "totalDamage" );
	addStatField( "totalHeadshots" );
	addStatField( "totalAssists" );
	addStatField( "totalShotsFired" );
	addStatField( "totalShotsHit" );
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
	field.datname = datname;
	field.type = type;

	level.statsvalidfields[ id ] = field;
}

getStatField( fieldname ) {
	for ( i = 0; i < level.statsvalidfields.size; i++ ) {
		field = level.statsvalidfields[ i ];
		if ( maps\mp\gametypes\_zombie::toLower( field.name ) == maps\mp\gametypes\_zombie::toLower( fieldname ) ) {
			return field;
		}
	}

	return undefined;
}

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

saveAll() {
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ ) {
		players[ i ] saveMyStats();
		players[ i ] addToLUT();
	}

	writeLUT();
}

saveMyStats() {
	lutname = "stats/players/" + self.guid + ".dat";
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::saveMyStats() -- load file " + lutname, true );

	handle = fopen( lutname, "w" );
	if ( handle == -1 ) {
		fse( "problem opening file " + lutname );
		[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::saveMyStats() -- problem opening file " + lutname );
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
			case "playerName":
				continue;
				break;
		}

		data += s.name + ": " + self.stats[ s.name ] + ",\n";
	}

	data += "eof\n";
/*
	data = 	"guid: " + 					self.guid + ",\n";
	data += "xp: " + 					self.xp + ",\n";
	data += "rank: " + 					self.rank + ",\n";
	data += "points: " + 				self.points + ",\n";
	data += "zombieXP: " + 				self.zomxp + ",\n";
	data += "zombieRank: " + 			self.zomrank + ",\n";
	data += "kills: " +					self.stats[ "totalkills" ] + ",\n";
	data += "deaths: " +				self.stats[ "totaldeaths" ] + ",\n";
	data += "bashes: " +				self.stats[ "totalbashes" ] + ",\n";
	data += "damage: " +				self.stats[ "totaldamage" ] + ",\n";
	data += "headshots: " +				self.stats[ "totalheadshots" ] + ",\n";
	data += "assists: " +				self.stats[ "totalassists" ] + ",\n";
	data += "shotsFired: " +			self.stats[ "totalshotsfired" ] + ",\n";
	data += "shotsHit: " +				self.stats[ "totalshotshit" ] + ",\n";
	data += "jumperZombieKills: " +		self.stats[ "jumperzombiekills" ] + ",\n";
	data += "fastZombieKills: " +		self.stats[ "fastzombiekills" ] + ",\n";
	data += "poisonZombieKills: " +		self.stats[ "poisonzombiekills" ] + ",\n";
	data += "fireZombieKills: " +		self.stats[ "firezombiekills" ] + ",\n";
	data += "killsAsJumperZombie: " +	self.stats[ "killsasjumperzombie" ] + ",\n";
	data += "killsAsFastZombie: " +		self.stats[ "killsasfastzombie" ] + ",\n";
	data += "killsAsPoisonZombie: " +	self.stats[ "killsaspoisonzombie" ] + ",\n";
	data += "killsAsFireZombie: " +		self.stats[ "killsasfirezombie" ] + ",\n";
	data += "hpHealed: " +				self.stats[ "hphealed" ] + ",\n";
	data += "ammoHealed: " +			self.stats[ "ammohealed" ] + ",\n";
	data += "eof\n";
*/
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::saveMyStats() -- write data to file " + lutname, true );
	fwrite( data, handle );

	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::saveMyStats() -- close file " + lutname, true );
	fclose( handle );
}

getMyStats() {
	self.guid = maps\mp\gametypes\_zombie::getNumberedName( self.oldname );

	// quick check to prevent too much file io
	if ( !statLUTLookup( self.guid ) ) {
		return;
	}

	lutname = "stats/players/" + self.guid + ".dat";
	if ( !fexists( lutname ) ) {
		return;
	}

	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::getMyStats() -- open file " + lutname, true );
	handle = fopen( lutname, "r" );
	if ( handle != -1 ) {
		data = fread( fsize( handle ), handle );
		if ( !isDefined( data ) || data[ 0 ] == "" ) {
			fclose( handle );
			return;
		}

		[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::getMyStats() -- close file " + lutname, true );
		fclose( handle );

		fieldsnvalues = maps\mp\gametypes\_zombie::explode( data, "," );
		for ( i = 0; i < fieldsnvalues.size; i++ ) {
			fnv = fieldsnvalues[ i ];

			if ( fnv == "" )
				continue;

			arr = maps\mp\gametypes\_zombie::explode( fnv, ":" );
			field = maps\mp\gametypes\_zombie::strreplacer( maps\mp\gametypes\_zombie::strip( arr[ 0 ] ), "alphanumeric" );
			value = maps\mp\gametypes\_zombie::strreplacer( maps\mp\gametypes\_zombie::strip( arr[ 1 ] ), "alphanumeric" );

			if ( field == fnv && field != "eof" && field != "#" ) {
				//fse( "invalid formatting in file " + lutname );
				[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::getMyStats() -- invalid formatting in file " + lutname );
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
				[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::getMyStats() -- invalid stat field: " + field + " in file " + lutname );
				break;
			}

			// clean up any extraneous characters
			if ( fieldstruct.type == "int" || fieldstruct.type == "float" ) {
				value = maps\mp\gametypes\_zombie::strreplacer( value, "numeric" );
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
/*
			switch ( field ) {
				case "xp":					self.xp = 								(int) value; break;
				case "rank":				self.rank = 							(int) value; break;
				case "points":				self.points = 							(int) value; break;
				case "zombiexp":			self.zomxp = 							(int) value; break;
				case "zombierank":			self.zomrank = 							(int) value; break;
				case "kills":				self.stats[ "totalkills" ] =			(int) value; break;
				case "deaths":				self.stats[ "totaldeaths" ] =			(int) value; break;
				case "bashes":				self.stats[ "totalbashes" ] =			(int) value; break;
				case "damage":				self.stats[ "totaldamage" ] =			(int) value; break;
				case "headshots":			self.stats[ "totalheadshots" ] =		(int) value; break;
				case "assists":				self.stats[ "totalassists" ] =			(int) value; break;
				case "shotsfired":			self.stats[ "totalshotsfired" ] =		(int) value; break;
				case "shotshit":			self.stats[ "totalshotshit" ] =			(int) value; break;
				case "jumperzombiekills":	self.stats[ "jumperzombiekills" ] =		(int) value; break;
				case "fastzombiekills":		self.stats[ "fastzombiekills" ] =		(int) value; break;
				case "poisonzombiekills":	self.stats[ "poisonzombiekills" ] =		(int) value; break;
				case "firezombiekills":		self.stats[ "firezombiekills" ] =		(int) value; break;
				case "killsasjumperzombie":	self.stats[ "killsasjumperzombie" ] = 	(int) value; break;
				case "killsasfastzombie":	self.stats[ "killsasfastzombie" ] = 	(int) value; break;
				case "killsaspoisonzombie":	self.stats[ "killsaspoisonzombie" ] = 	(int) value; break;
				case "killsasfirezombie":	self.stats[ "killsasfirezombie" ] = 	(int) value; break;
				case "hphealed":			self.stats[ "hphealed" ] =				(int) value; break;
				default:										 				 	 break;
			}
*/
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
		[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::getMyStats() -- problem opening file " + lutname, true );
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
		logprint( "!!!!! fse: " + error + "\n" );
	} else {
		iPrintLn( "^1fse: ^7" + error );
		logprint( "fse: " + error + "\n" );
	}
}
