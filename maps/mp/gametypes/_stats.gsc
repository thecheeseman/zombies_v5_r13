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
			guid = maps\mp\gametypes\_zombie::strreplacer( maps\mp\gametypes\_zombie::strip( arr[ i ] ), "alphanumeric" );
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
	addStatField( "playername", "string" );
	addStatField( "xp" );
	addStatField( "rank" );
	addStatField( "points" );
	addStatField( "zombiexp" );
	addStatField( "zombierank" );
	addStatField( "kills" );
	addStatField( "deaths" );
	addStatField( "bashes" );
	addStatField( "damage" );
	addStatField( "headshots" );
	addStatField( "assists" );
	addStatField( "shotsfired" );
	addStatField( "shotshit" );
	addStatField( "eof" );
}

addStatField( fieldname, type ) {
	// doublecheck if adding twice
	if ( isDefined( getStatField( fieldname ) ) ) {
		return;
	}

	if ( !isDefined( type ) ) {
		type = "string";
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

	self.stats[ "totalkills" ] += self.stats[ "kills" ];
	self.stats[ "totaldeaths" ] += self.stats[ "deaths" ];
	self.stats[ "totalbashes" ] += self.stats[ "bashes" ];
	self.stats[ "totaldamage" ] += self.stats[ "damage" ];
	self.stats[ "totalheadshots" ] += self.stats[ "headshots" ];
	self.stats[ "totalassists" ] += self.stats[ "assists" ];
	self.stats[ "totalshotsfired" ] += self.shotsfired;
	self.stats[ "totalshotshit" ] += self.shotshit;

	data = 	"guid: " + 			self.guid + ",\n";
	data += "xp: " + 			self.xp + ",\n";
	data += "rank: " + 			self.rank + ",\n";
	data += "points: " + 		self.points + ",\n";
	data += "zombiexp: " + 		self.zomxp + ",\n";
	data += "zombierank: " + 	self.zomrank + ",\n";
	data += "kills: " +			self.stats[ "totalkills" ] + ",\n";
	data += "deaths: " +		self.stats[ "totaldeaths" ] + ",\n";
	data += "bashes: " +		self.stats[ "totalbashes" ] + ",\n";
	data += "damage: " +		self.stats[ "totaldamage" ] + ",\n";
	data += "headshots: " +		self.stats[ "totalheadshots" ] + ",\n";
	data += "assists: " +		self.stats[ "totalassists" ] + ",\n";
	data += "shotsfired: " +	self.stats[ "totalshotsfired" ] + ",\n";
	data += "shotshit: " +		self.stats[ "totalshotshit" ] + ",\n";
	data += "eof\n";

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

			arr = maps\mp\gametypes\_zombie::explode( fnv, ":" );
			field = maps\mp\gametypes\_zombie::strreplacer( maps\mp\gametypes\_zombie::strip( arr[ 0 ] ), "alphanumeric" );
			value = maps\mp\gametypes\_zombie::strreplacer( maps\mp\gametypes\_zombie::strip( arr[ 1 ] ), "alphanumeric" );

			if ( field == fnv && field != "eof" ) {
				fse( "invalid formatting in file " + lutname );
				[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::getMyStats() -- invalid formatting in file " + lutname );
				break;
			}

			// reached end of file
			if ( field == "eof" ) {
				break;
			}

			fieldstruct = getStatField( field );
			if ( !isDefined( fieldstruct ) ) {
				fse( "invalid stat field: " + field + " in file " + lutname );
				[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::getMyStats() -- invalid stat field: " + field + " in file " + lutname );
				break;
			}

			// clean up any extraneous characters
			if ( fieldstruct.type == "int" || fieldstruct.type == "float" ) {
				value = maps\mp\gametypes\_zombie::strreplacer( value, "numeric" );
			}

			switch ( field ) {
			/*
				guid, playername, xp, rank, points, zombiexp, zombierank,
				kills, deaths, damage, bashes, headshots, assists,
				shotsfired, shotshit, eof
			*/
				case "xp":			self.xp = 							(int) value; break;
				case "rank":		self.rank = 						(int) value; break;
				case "points":		self.points = 						(int) value; break;
				case "zombiexp":	self.zomxp = 						(int) value; break;
				case "zombierank":	self.zomrank = 						(int) value; break;
				case "kills":		self.stats[ "totalkills" ] =		(int) value; break;
				case "deaths":		self.stats[ "totaldeaths" ] =		(int) value; break;
				case "bashes":		self.stats[ "totalbashes" ] =		(int) value; break;
				case "damage":		self.stats[ "totaldamage" ] =		(int) value; break;
				case "headshots":	self.stats[ "totalheadshots" ] =	(int) value; break;
				case "assists":		self.stats[ "totalassists" ] =		(int) value; break;
				case "shotsfired":	self.stats[ "totalshotsfired" ] =	(int) value; break;
				case "shotshit":	self.stats[ "totalshotshit" ] =		(int) value; break;
				default:										 				 	 break;
			}
		}
	} else {
		fse( "problem opening file " + lutname );
		[[ level.logwrite ]]( "maps\\mp\\gametypes\\_stats.gsc::getMyStats() -- problem opening file " + lutname, true );
	}
}

resetStatsVars() {

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
