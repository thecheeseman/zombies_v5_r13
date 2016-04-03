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

main()
{
	level.loadingstats = true;
	
	level.loadingmessage = newHudElem();
	level.loadingmessage.x = 320;
	level.loadingmessage.y = 200;
	level.loadingmessage.fontscale = 1;
	level.loadingmessage.alignx = "center";
	level.loadingmessage.aligny = "middle";
	level.loadingmessage setText( &"LOADING STATS" );
	level.loadingmessage.alpha = 1;

	level.statslength = level.cvars[ "STAT_COUNT" ];

	level.stats = [];
	hunters = loadstats( "hunters" );
	level.stats[ "hunters" ] = maps\mp\gametypes\_zombie::explode( hunters, ";" );
	zombies = loadstats( "zombies" );
	level.stats[ "zombies" ] = maps\mp\gametypes\_zombie::explode( zombies, ";" );
	points = loadstats( "points" );
	level.stats[ "points" ] = maps\mp\gametypes\_zombie::explode( points, ";" );
	
	wait 1;
	
	level.loadingstats = false;
	level.loadingmessage destroy();
}

saveAll()
{
	thread saveHunterStats();
	thread saveZombieStats();
	thread savePoints();
}


getMyStats()
{
	self.guid = maps\mp\gametypes\_zombie::getNumberedName( self.oldname );
	stats = getPlayerStats( self.guid );

	if ( isDefined( stats ) )
	{
		array = maps\mp\gametypes\_zombie::explode( stats, "," );
		self.xp = (int)array[ 1 ];
		self.rank = (int)array[ 2 ];
	}
	
	zomstats = getZomPlayerStats( self.guid );
		
	if ( isDefined( zomstats ) )
	{
		array = maps\mp\gametypes\_zombie::explode( zomstats, "," );
		self.zomxp = (int)array[ 1 ];
		self.zomrank = (int)array[ 2 ];
	}
	
	points = getPointStats( self.guid );
	if ( isDefined( points ) )
	{
		array = maps\mp\gametypes\_zombie::explode( points, "," );
		self.points = (int)array[ 1 ];
	}
}

getPlayerStats( guid )
{
	array = level.stats[ "hunters" ];
	
	thisguysstats = undefined;
	for ( i = 0; i < array.size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( array[ i ], "," );
		if ( guid == miniarray[ 0 ] )
		{
			thisguysstats = array[ i ];
			break;
		}
	}
	
	return thisguysstats;
}

getZomPlayerStats( guid )
{
	array = level.stats[ "zombies" ];
	
	thisguysstats = undefined;
	for ( i = 0; i < array.size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( array[ i ], "," );
		if ( guid == miniarray[ 0 ] )
		{
			thisguysstats = array[ i ];
			break;
		}
	}
	
	return thisguysstats;
}

getPointStats( guid )
{
	array = level.stats[ "points" ];
	
	thisguysstats = undefined;
	for ( i = 0; i < array.size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( array[ i ], "," );
		if ( guid == miniarray[ 0 ] )
		{
			thisguysstats = array[ i ];
			break;
		}
	}
	
	return thisguysstats;
}

loadStats( team )
{	
	mystats = "";
	if ( team == "hunters" )
	{
		for ( i = 0; i < level.statslength; i++ )
		{
			v = getCvar( "stats" + i );
            if ( v != "" )
                mystats += v;

			wait 0.02;
		}
	}
	else if ( team == "zombies" )
	{	
		for ( i = 0; i < level.statslength; i++ )
		{
			v = getCvar( "zomstats" + i );
            if ( v != "" )
                mystats += v;
            
			wait 0.02;
		}
	}
	else if ( team == "points" )
	{
		for ( i = 0; i < level.statslength; i++ )
		{
			v = getCvar( "points" + i );
            if ( v != "" )
                mystats += v;
            
			wait 0.02;
		}
	}

	return mystats;
}

resetStatsVars()
{
/*
	setCvar( "points", "" );
	setCvar( "points2", "" );
	setCvar( "points3", "" );
	setCvar( "points4", "" );
	setCvar( "points5", "" );
	
	setCvar( "stats", "" );
	setCvar( "stats2", "" );
	setCvar( "stats3", "" );
	setCvar( "stats4", "" );
	setCvar( "stats5", "" );
	setCvar( "stats6", "" );
	setCvar( "stats7", "" );
	setCvar( "stats8", "" );
	setCvar( "stats9", "" );
	setCvar( "stats10", "" );
	setCvar( "stats11", "" );
	setCvar( "stats12", "" );
	setCvar( "stats13", "" );
	
	setCvar( "zomstats", "" );
	setCvar( "zomstats2", "" );
	setCvar( "zomstats3", "" );
	setCvar( "zomstats4", "" );
	setCvar( "zomstats5", "" );
	setCvar( "zomstats6", "" );
	setCvar( "zomstats7", "" );
	setCvar( "zomstats8", "" );
	setCvar( "zomstats9", "" );
	setCvar( "zomstats10", "" );	
*/
}

saveHunterStats()
{
	level.statshunters = newHudElem();
	level.statshunters.x = 320;
	level.statshunters.y = 360;
	level.statshunters.alignx = "center";
	level.statshunters.aligny = "middle";
	level.statshunters.alpha = 1;
	level.statshunters.fontscale = 0.9;
	level.statshunters setText( &"saving hunter stats..." );
	
	oldstats = level.stats[ "hunters" ];
	
	players = getEntArray( "player", "classname" );

	stats = [];
	for ( i = 0; i < level.statslength; i++ ) {
		stats[ i ] = "";
	}

	currentstat = 0;
	for ( i = 0; i < players.size; i++ )
	{
		playername = maps\mp\gametypes\_zombie::getNumberedName( players[ i ].oldname, true );

		if ( players[ i ].xp < 200 ) {
			continue;
		}

		while ( stats[ currentstat ].size > 1000 ) {
			currentstat++;
		}

		if ( currentstat > level.statslength ) {
			iPrintLnBold( "tell cheese about currentstat > level.statslength" );
			continue;
		}

		stats[ currentstat ] += playername + "," + players[ i ].xp + "," + players[ i ].rank + ";";
			
		wait 0.02;
	}

	currentstat = 0;
	for ( i = 0; i < oldstats.size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( oldstats[ i ], "," );
		found = false;
		
		for ( j = 0; j < players.size; j++ )
		{
			if ( maps\mp\gametypes\_zombie::getNumberedName( players[ j ].oldname, true ) == miniarray[ 0 ] )
			{
				found = true;
				break;
			}
		}
				
		if ( !found && ( isDefined( miniarray[ 1 ] ) && isDefined( miniarray[ 2 ] ) ) )
		{
			while ( stats[ currentstat ].size > 1000 ) {
				currentstat++;
			}

			if ( currentstat > level.statslength ) {
				iPrintLnBold( "tell cheese about currentstat > level.statslength" );
				continue;
			}

			stats[ currentstat ] += miniarray[ 0 ] + "," + miniarray[ 1 ] + "," + miniarray[ 2 ] + ";";
		}
		
		wait 0.02;
	}

	for ( i = 0; i < level.statslength; i++ ) {
		setCvar( "stats" + i, stats[ i ] );
	}
	
	level.statshunters destroy();
}		

saveZombieStats()
{
	level.statszombies = newHudElem();
	level.statszombies.x = 320;
	level.statszombies.y = 375;
	level.statszombies.alignx = "center";
	level.statszombies.aligny = "middle";
	level.statszombies.alpha = 1;
	level.statszombies.fontscale = 0.9;
	level.statszombies setText( &"saving zombie stats..." );
	
	oldzomstats = level.stats[ "zombies" ];
	
	players = getEntArray( "player", "classname" );

	zomstats = [];
	for ( i = 0; i < level.statslength; i++ ) {
		zomstats[ i ] = "";
	}

	currentstat = 0;
	for ( i = 0; i < players.size; i++ )
	{
		playername = maps\mp\gametypes\_zombie::getNumberedName( players[ i ].oldname, true );

		if ( players[ i ].zomxp < 1 ) {
			continue;
		}

		while ( zomstats[ currentstat ].size > 1000 ) {
			currentstat++;
		}

		if ( currentstat > level.statslength ) {
			iPrintLnBold( "tell cheese about currentstat > level.statslength" );
			continue;
		}

		zomstats[ currentstat ] += playername + "," + players[ i ].zomxp + "," + players[ i ].zomrank + ";";
			
		wait 0.02;
	}
	
	currentstat = 0;
	for ( i = 0; i < oldzomstats.size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( oldzomstats[ i ], "," );
		found = false;
		
		for ( j = 0; j < players.size; j++ )
		{
			if ( maps\mp\gametypes\_zombie::getNumberedName( players[ j ].oldname, true ) == miniarray[ 0 ] )
			{
				found = true;
				break;
			}
		}
	
		if ( !found && ( isDefined( miniarray[ 1 ] ) && isDefined( miniarray[ 2 ] ) ) )
		{
			while ( zomstats[ currentstat ].size > 1000 ) {
				currentstat++;
			}

			if ( currentstat > level.statslength ) {
				iPrintLnBold( "tell cheese about currentstat > level.statslength" );
				continue;
			}

			zomstats[ currentstat ] += miniarray[ 0 ] + "," + miniarray[ 1 ] + "," + miniarray[ 2 ] + ";";
		}
		
		wait 0.02;
	}

	for ( i = 0; i < level.statslength; i++ ) {
		setCvar( "zomstats" + i, zomstats[ i ] );
	}
	
	level.statszombies destroy();
}

savePoints()
{
	level.statspoints = newHudElem();
	level.statspoints.x = 320;
	level.statspoints.y = 390;
	level.statspoints.alignx = "center";
	level.statspoints.aligny = "middle";
	level.statspoints.alpha = 1;
	level.statspoints.fontscale = 0.9;
	level.statspoints setText( &"saving point stats..." );
	
	oldpoints = level.stats[ "points" ];
	
	players = getEntArray( "player", "classname" );

	points = [];
	for ( i = 0; i < level.statslength; i++ ) {
		points[ i ] = "";
	}

	currentstat = 0;
	for ( i = 0; i < players.size; i++ )
	{
		playername = maps\mp\gametypes\_zombie::getNumberedName( players[ i ].oldname, true );

		if ( players[ i ].points < 25 ) {
			continue;
		}

		while ( points[ currentstat ].size > 1000 ) {
			currentstat++;
		}

		if ( currentstat > level.statslength ) {
			iPrintLnBold( "tell cheese about currentstat > level.statslength" );
			continue;
		}

		points[ currentstat ] += playername + "," + players[ i ].points + ";";
		
		wait 0.02;
	}
	
	currentstat = 0;
	for ( i = 0; i < oldpoints.size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( oldpoints[ i ], "," );
		found = false;
		
		for ( j = 0; j < players.size; j++ )
		{
			if ( maps\mp\gametypes\_zombie::getNumberedName( players[ j ].oldname, true ) == miniarray[ 0 ] )
			{
				found = true;
				break;
			}
		}
	
		if ( !found && isDefined( miniarray[ 1 ] ) )
		{
			while ( points[ currentstat ].size > 1000 ) {
				currentstat++;
			}

			if ( currentstat > level.statslength ) {
				iPrintLnBold( "tell cheese about currentstat > level.statslength" );
				continue;
			}

			points[ currentstat ] += miniarray[ 0 ] + "," + miniarray[ 1 ] + ";";
		}
		
		wait 0.02;
	}

	for ( i = 0; i < level.statslength; i++ ) {
		setCvar( "points" + i, points[ i ] );
	}

	level.statspoints destroy();
}	