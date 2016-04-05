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
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_admin.gsc::main()", true );
	if ( level.debug )
	{
		thread watchVar( "admin_endgame", ::endGame );
		thread watchVar( "admin_giveweap", ::giveWeap );
		thread watchVar( "admin_drop", ::drop );
		thread watchVar( "admin_giveks", ::giveks );
		thread watchVar( "admin_givearmor", ::givearmor );
	}
	
	thread watchVar( "admin_kill", ::kill );
	thread watchVar( "admin_givexp", ::giveXp );
	thread watchVar( "admin_givekills", ::giveKills );
	thread watchVar( "admin_gp", ::givePoints );
	thread watchVar( "admin_say", ::say );
	thread watchVar( "admin_getid", ::getid );
	thread watchVar( "admin_updatexp", ::updatexp );
	thread watchVar( "admin_updatekills", ::updatekills );
	thread watchVar( "admin_rename", ::rename );
	
	thread watchVar( "admin_spank", ::spank );
	thread watchVar( "admin_slap", ::slap );
}

watchVar( varname, func )
{
	setCvar( varname, "" );
	
	while ( 1 )
	{
		if ( getCvar( varname ) != "" )
		{
			thread [[ func ]]( getCvar( varname ) );
			setCvar( varname, "" );
		}
			
		wait 0.05;
	}
}

endGame( value )
{
	thread maps\mp\gametypes\_zombie::endGame( "forced" );
}

kill( value )
{
	player = maps\mp\gametypes\_zombie::getPlayerByID( value );
	
	if ( isDefined( player ) )
	{
		player suicide();
		playFx( level._effect[ "zombieExplo" ], player.origin );
		
		iPrintLn( "^3The Admin killed ^7" + player.name + "^3!" );
	}
}

giveXp( value )
{
	array = maps\mp\gametypes\_zombie::explode( value, " " );
	
	if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
		return;
		
	player = maps\mp\gametypes\_zombie::getPlayerByID( array[ 0 ] );
	amount = (int)array[ 1 ];
	
	if ( isDefined( player ) )
	{
		player.xp += amount;
		player thread maps\mp\gametypes\_zombie::checkRank();
	}
}

giveKills( value )
{
	array = maps\mp\gametypes\_zombie::explode( value, " " );
	
	if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
		return;
		
	player = maps\mp\gametypes\_zombie::getPlayerByID( array[ 0 ] );
	amount = (int)array[ 1 ];
	
	if ( isDefined( player ) )
	{
		player.zomxp += amount;
		player thread maps\mp\gametypes\_zombie::checkRank();
	}
}

givePoints( value )
{
	array = maps\mp\gametypes\_zombie::explode( value, " " );
	
	if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
		return;
		
	player = maps\mp\gametypes\_zombie::getPlayerByID( array[ 0 ] );
	amount = (int)array[ 1 ];
	
	if ( isDefined( player ) )
		player.points += amount;
}

updateXP( value )
{
	array = maps\mp\gametypes\_zombie::explode( value, " " );
	
	if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
		return;
		
	id = (int)array[ 0 ];
	amount = (int)array[ 1 ];
	
	for ( i = 0; i < level.stats[ "hunters" ].size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( level.stats[ "hunters" ][ i ], "," );
		if ( id == miniarray[ 0 ] )
		{
			miniarray[ 1 ] += amount;
			
			string = miniarray[ 0 ] + "," + miniarray[ 1 ] + "," + miniarray[ 2 ];
			level.stats[ "hunters" ][ i ] = string;
			break;
		}
	}
}

updateKills( value )
{
	array = maps\mp\gametypes\_zombie::explode( value, " " );
	
	if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
		return;
		
	id = (int)array[ 0 ];
	amount = (int)array[ 1 ];
	
	for ( i = 0; i < level.stats[ "zombies" ].size; i++ )
	{
		miniarray = maps\mp\gametypes\_zombie::explode( level.stats[ "zombies" ][ i ], "," );
		if ( id == miniarray[ 0 ] )
		{
			miniarray[ 1 ] += amount;
			
			string = miniarray[ 0 ] + "," + miniarray[ 1 ] + "," + miniarray[ 2 ];
			level.stats[ "zombies" ][ i ] = string;
			break;
		}
	}
}

giveWeap( value )
{
	array = maps\mp\gametypes\_zombie::explode( value, " " );
	
	if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
		return;
		
	player = maps\mp\gametypes\_zombie::getPlayerByID( array[ 0 ] );
	weapon = array[ 1 ];
	slot = "primaryb";
	
	if ( isDefined( array[ 2 ] ) )
		slot = array[ 2 ];
		
	player setWeaponSlotWeapon( slot, weapon );
	player setWeaponSlotAmmo( slot, 9999 );
	player switchToWeapon( weapon );
}

say( value )
{
	iPrintLnBold( value );
}

getid( value )
{
	player = maps\mp\gametypes\_zombie::getPlayerByID( value );
	
	if ( isDefined( player ) )
		iprintlnbold( player.name + " = " + maps\mp\gametypes\_zombie::getNumberedName( player.name ) );
		
}

drop( value )
{
	array = maps\mp\gametypes\_zombie::explode( value, " " );
	height = 512;
	
	if ( !isDefined( array[ 0 ] ) )
		return;

	player = maps\mp\gametypes\_zombie::getPlayerByID( array[ 0 ] );
	if ( isDefined( array[ 1 ] ) )
		height = (int)array[ 1 ];
	
	if ( isDefined( player ) )
	{
		player endon( "disconnect" );
		
		player.drop = spawn( "script_origin", player.origin );
		player linkto( player.drop );
		
		player.drop movez( height, 2 );
		wait 2;
		player unlink();
		player.drop delete();
		
		iPrintLn( "^3The admin DROPPED ^7" + player.name + "^3!" );
	}
}

spank( value )
{
	array = maps\mp\gametypes\_zombie::explode( value, " " );
	time = 30;
	
	if ( !isDefined( array[ 0 ] ) )
		return;
		
	player = maps\mp\gametypes\_zombie::getPlayerByID( array[ 0 ] );
	if ( isDefined( array[ 1 ] ) )
		time = (int)array[ 1 ];
		
	if ( isDefined( player ) )
	{
		iPrintLn( "^3The admin SPANKED ^7" + player.name + "^3!" );
			
		player shellshock( "default", time / 2 );
		for( i = 0; i < time; i++ )
		{
			player playSound( "melee_hit" );
			player setClientCvar( "cl_stance", 2 );
			wait randomFloat( 0.5 );
		}
		player shellshock( "default", 1 );
	}
}

slap( value )
{
	array = maps\mp\gametypes\_zombie::explode( value, " " );
	dmg = 10;
	
	if ( !isDefined( array[ 0 ] ) )
		return;
		
	player = maps\mp\gametypes\_zombie::getPlayerByID( array[ 0 ] );
	if ( isDefined( array[ 1 ] ) )
		dmg = (int)array[ 1 ];
		
	if ( isDefined( player ) )
	{
		eInflictor = player;
		eAttacker = player;
		iDamage = dmg;
		iDFlags = 0;
		sMeansOfDeath = "MOD_PROJECTILE";
		sWeapon = "panzerfaust_mp";
		vPoint = ( player.origin + ( 0, 0, -1 ) );
		vDir = vectorNormalize( player.origin - vPoint );
		sHitLoc = "none";
		psOffsetTime = 0;

		player playSound( "melee_hit" );
		player finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
		
		iPrintLn( "^3The admin SLAPPED ^7" + player.name + "^7!" );
	}
}

giveks( value )
{
	array = maps\mp\gametypes\_zombie::explode( value, " " );
	
	if ( !isDefined( array[ 0 ] ) && !isDefined( array[ 1 ] ) )
		return;
		
	player = maps\mp\gametypes\_zombie::getPlayerByID( array[ 0 ] );
	ks = array[ 1 ];
	
	if ( isDefined( player ) )
	{
		player.powerup = ks;
		player thread maps\mp\gametypes\_killstreaks::notifyPowerup();
	}
}

rename( value )
{
	array = maps\mp\gametypes\_zombie::explode( value, " " );

	if ( !isDefined( array[ 0 ] ) && !isDefined( array[ 1 ] ) )
		return;
		
	player = maps\mp\gametypes\_zombie::getPlayerByID( array[ 0 ] );
	
	if ( isDefined( player ) )
	{
		newname = "";
		for ( i = 1; i < 10; i++ )
		{
			if ( isDefined( array[ i ] ) )
			{
				newname += " ";
				newname += array[ i ];
			}
		}
		
		player setClientCvar( "name", newname );
	}
}

givearmor( value )
{
	array = maps\mp\gametypes\_zombie::explode( value, " " );

	if ( !isDefined( array[ 0 ] ) && !isDefined( array[ 1 ] ) && !isDefined( array[ 2 ] ) )
		return;
		
	player = maps\mp\gametypes\_zombie::getPlayerByID( array[ 0 ] );
	
	if ( isDefined( player ) )
	{
		if ( array[ 1 ] == "bodyarmor" )
			player.bodyarmor = (int)array[ 2 ];
		else if ( array[ 1 ] == "exploarmor" )
			player.exploarmor = (int)array[ 2 ];
	}
}