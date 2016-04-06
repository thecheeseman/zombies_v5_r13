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
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_ammoboxes.gsc::main()", true );
	
	precacheModel( "xmodel/crate_misc1" );
	precacheModel( "xmodel/crate_champagne3" );
	precacheModel( "xmodel/ammo_stielhandgranate1" );
	
	precacheShader( "white" );
	precacheShader( "black" );
	precacheShader( "gfx/hud/objective.tga" );
	
	precacheString( &"Hold [F] to get ammo/health" );
	
	locs = [];
	angs = [];
	supported = true;
	
	level.barsize = 288;
	level.planttime = 5;
	level.plantdist = 32;
	
	switch ( maps\mp\gametypes\_zombie::toLower( getCvar( "mapname" ) ) )
	{
		case "mp_brecourt":
			locs[ 0 ] = ( -2711, 1965, 34 );
			locs[ 1 ] = ( 1980, -2709, 38 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			break;
			
		case "mp_carentan":
			locs[ 0 ] = ( 1352, 1742, 144 );
			locs[ 1 ] = ( -594, 449, 0 );
			angs[ 0 ] = ( 0, -180, 0 );
			angs[ 1 ] = ( 0, -90, 0 );
			break;
			
		case "mp_chateau":
			locs[ 0 ] = ( 1725, -390, 144 );
			locs[ 1 ] = ( -1243, 1911, 140 );
			angs[ 0 ] = ( 0, -180, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			break;
			
		case "mp_dawnville":
			locs[ 0 ] = ( -641, -14969, -21 );
			locs[ 1 ] = ( 858, -18788, 32 );
			angs[ 0 ] = ( 0, 180, 0 );
			angs[ 1 ] = ( 0, -180, 0 );
			break;
			
		case "mp_depot":
			locs[ 0 ] = ( 418, 711, -23 );
			locs[ 1 ] = ( -2560, 196, -23 );
			angs[ 0 ] = ( 0, -180, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			break;
			
		case "mp_harbor":
			locs[ 0 ] = ( -9552, -6207, 0 );
			locs[ 1 ] = ( -11192, -7079, 0 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			break;
			
		case "mp_hurtgen":
			locs[ 0 ] = ( 117, -713, -193 );
			locs[ 1 ] = ( 5065, 1578, 101 );
			locs[ 2 ] = ( 1517, -4083, -223 );
			angs[ 0 ] = ( 0, 90, 0 );
			angs[ 1 ] = ( 0, 90, 0 );
			angs[ 2 ] = ( 0, 0, 0 );
			break;
			
		case "mp_pavlov":
			locs[ 0 ] = ( -9272, 12180, 103 );
			locs[ 1 ] = ( -8931, 9120, 10 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, -90, 0 );
			break;
			
		case "mp_powcamp":
			locs[ 0 ] = ( 727, 3948, 0 );
			locs[ 1 ] = ( 119, -983, 0 );
			angs[ 0 ] = ( 0, -90, 0 );
			angs[ 1 ] = ( 0, -90, 0 );
			break;
			
		case "mp_railyard":
			locs[ 0 ] = ( -1042, 2163, -55 );
			locs[ 1 ] = ( -1651, -1283, 248 );
			angs[ 0 ] = ( 0, 90, 0 );
			angs[ 1 ] = ( 0, 90, 0 );
			break;
		
		case "mp_rocket":
			locs[ 0 ] = ( 9236, 3603, 290 );
			locs[ 1 ] = ( 12080, 6244, 404 );
			locs[ 2 ] = ( 10668, 5905, 82 );
			angs[ 0 ] = ( 0, 180, 0 );
			angs[ 1 ] = ( 0, -180, 0 );
			angs[ 2 ] = ( 0, -90, 0 );
			break;
			
		case "mp_ship":
			locs[ 0 ] = ( 3687, 372, 760 );
			locs[ 1 ] = ( 5583, -128, 352 );
			angs[ 0 ] = ( 0, 90, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			break;
			
		case "cp_trifles":
			locs[ 0 ] = ( 1441, 1253, 8 );
			locs[ 1 ] = ( 6841, 1639, -28 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, 90, 0 );
			break;
			
		case "cp_zombies":
			locs[ 0 ] = ( -200, 831, 8 );
			locs[ 1 ] = ( 1142, -2359, 8 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, -90, 0 );
			break;
			
		case "cp_omahgawd":
			locs[ 0 ] = ( -35, 478, 8 );
			locs[ 1 ] = ( 332, -384, 304 );
			locs[ 2 ] = ( 379, 785, 304 );
			locs[ 3 ] = ( -535, 812, 304 );
			locs[ 4 ] = ( -570, -328, 304 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			angs[ 2 ] = ( 0, 0, 0 );
			angs[ 3 ] = ( 0, 0, 0 );
			angs[ 4 ] = ( 0, 0, 0 );
			break;
			
		case "cp_towerofdeath":
			locs[ 0 ] = ( -609, -35, 1419 );
			locs[ 1 ] = ( -610, 534, 3940 );
			angs[ 0 ] = ( 0, 90, 0 );
			angs[ 1 ] = ( 0, 90, 0 );
			break;
			
		case "cp_sewerzombies":
			locs[ 0 ] = ( 3260, -730, 304 );
			locs[ 1 ] = ( 1700, 3772, 304 );
			locs[ 2 ] = ( 3107, 2225, 312 );
			locs[ 3 ] = ( 1500, 224, 96 );
			locs[ 4 ] = ( -1437, 1666, 192 );
			locs[ 5 ] = ( 6250, -539, 96 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			angs[ 2 ] = ( 0, 0, 0 );
			angs[ 3 ] = ( 0, 0, 0 );
			angs[ 4 ] = ( 0, 0, 0 );
			angs[ 5 ] = ( 0, 0, 0 );
			break;
			
		case "simon_hai":
			locs[ 0 ] = ( -64, 120, 448 );
			locs[ 1 ] = ( 720, 176, 392 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			break;
			
		case "cp_banana":
			locs[ 0 ] = ( -98, 483, 40 );
			locs[ 1 ] = ( -140, -140, 472 );
			locs[ 2 ] = ( -105, -811, 40 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			angs[ 2 ] = ( 0, 0, 0 );
			break;
			
		case "cp_zombiebunkers":
			locs[ 0 ] = ( 1224, -1042, 16 );
			locs[ 1 ] = ( -1876, -1015, 16 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			break;
			
		case "cp_trainingday":
			locs[ 0 ] = ( -147, 502, 56 );
			locs[ 1 ] = ( -3309, 334, -191 );
			locs[ 2 ] = ( -4187, -394, -191 );
			locs[ 3 ] = ( -3139, -1278, -191 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			angs[ 2 ] = ( 0, 0, 0 );
			angs[ 3 ] = ( 0, 0, 0 );
			break;
			
		case "toybox_bloodbath":
			locs[ 0 ] = ( 1253, 301, 216 );
			locs[ 1 ] = ( -172, -1884, 220 );
			angs[ 0 ] = ( 0, 180, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			break;
			
		case "mp_tigertown":
			locs[ 0 ] = ( -1964, -3683, 184 );
			locs[ 1 ] = ( -526, -769, 32 );
			angs[ 0 ] = ( 0, 90, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			break;
			
		case "alcatraz":
			locs[ 0 ] = ( 1832, 566, 8 );
			locs[ 1 ] = ( -644, 4490, 8 );
			locs[ 2 ] = ( -1798, 1948, 8 );
			locs[ 3 ] = ( 646, 1785, 256 );
			angs[ 0 ] = ( 0, -90, 0 );
			angs[ 1 ] = ( 0, -90, 0 );
			angs[ 2 ] = ( 0, 0, 0 );
			angs[ 3 ] = ( 0, 0, 0 );
			break;
			
		case "mp_stalingrad":
			locs[ 0 ] = ( 4123, -2, -160 );
			locs[ 1 ] = ( 1885, -1304, 116 );
			angs[ 0 ] = ( 0, -90, 0 );
			angs[ 1 ] = ( 0, 120, 0 );
			break;
			
		case "mp_neuville":
			locs[ 0 ] = ( -15927, 2491, 152 );
			locs[ 1 ] = ( -13876, 5033, 0 );
			angs[ 0 ] = ( 0, 130, 0 );
			angs[ 1 ] = ( 0, 90, 0 );
			break;
			
		case "cp_apartments":
			locs[ 0 ] = ( -795, 335, 896 );
			locs[ 1 ] = ( -652, -81, 232 );
			locs[ 2 ] = ( 474, 3, 232 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, 0, 0 );
			angs[ 2 ] = ( 0, 0, 0 );
			break;
			
		case "quarantine":
			locs[ 0 ] = ( 293, -363, 4 );
			locs[ 1 ] = ( 1819, 1248, 128 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, -90, 0 );
			break;
			
		case "goldeneye_bunker":
			locs[ 0 ] = ( -1681, -1748, -39 );
			locs[ 1 ] = ( -316, -235, -51 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, 90, 0 );
			break;
			
		case "germantrainingbase":
			locs[ 0 ] = ( 1249, -407, 32 );
			locs[ 1 ] = ( 737, -888, 960 );
			angs[ 0 ] = ( 0, 90, 0 );
			angs[ 1 ] = ( 0, 90, 0 );
			break;
			
		case "mp_vok_final_night":
			locs[ 0 ] = ( 1845, 2198, 480 );
			locs[ 1 ] = ( -481, -1755, 848 );
			locs[ 2 ] = ( 5170, 5702, 320 );
			angs[ 0 ] = ( 0, 0, 0 );
			angs[ 1 ] = ( 0, 90, 0 );
			angs[ 2 ] = ( 0, -90, 0 );
			break;
			
		default:
			supported = false;
			break;
	}
	
	if ( supported )
		thread spawnAmmoboxes( locs, angs );
}

/*
	Total models used: 7
*/
spawnAmmoboxes( locs, angs )
{
	for ( i = 0; i < locs.size; i++ )
	{
		box = spawn( "script_model", locs[ i ] );
		box.angles = angs[ i ];
		box setModel( "xmodel/crate_misc1" );
		
		objective_add( i, "current", box.origin, "gfx/hud/objective.tga" );
		objective_team( i, "axis" );

		nadebox = spawn( "script_model", box.origin + ( 8, -4, 26 ) );
		nadebox.angles = box.angles;
		nadebox setModel( "xmodel/ammo_stielhandgranate1" );
		
		health = spawn( "script_model", box.origin + ( -8, 7, 26 ) );
		health.angles = box.angles + ( 0, 270, 0 );
		health setModel( "xmodel/health_medium" );
		
		colt = spawn( "script_model", box.origin + ( -11, -3, 26 ) );
		colt.angles = box.angles + ( 0, 0, 88 );
		colt setModel( "xmodel/weapon_colt45" );

		luger = spawn( "script_model", box.origin + ( -5, -9, 26 ) );
		luger.angles = box.angles + ( 0, 180, -88 );
		luger setModel( "xmodel/weapon_luger" );
		
		models = [];
		models[ 0 ] = box;
		models[ 1 ] = nadebox;
		models[ 2 ] = health;
		models[ 3 ] = colt;
		models[ 4 ] = luger;

		box thread watchAmmobox( i, models );
	}
}

watchAmmobox( num, models )
{
	level endon( "stop ammoboxes" );
	
	thread stop( num, models );
	
	while ( 1 )
	{
		players = getEntArray( "player", "classname" );
		for ( i = 0; i < players.size; i++ )
		{
			if ( distance( self.origin, players[ i ].origin ) < level.plantdist && players[ i ].pers[ "team" ] == "axis" && !players[ i ].gettingammo )
				players[ i ] thread getammo( self );
		}
		
		wait 0.1;
	}
}

stop( num, models )
{
	level waittill( "stop ammoboxes" );
	
	objective_delete( num );
	
	for ( i = 0; i < models.size; i++ )
		models[ i ] delete();
}

getammo( box )
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self.gettingammo = true;
	self.givenammo = false;
	
	while ( distance( box.origin, self.origin ) < level.plantdist && isAlive( self ) && !level.lasthunter )
	{	
		if ( !isDefined( self.ammonotice ) )
		{
			self.ammonotice = newClientHudElem( self );
			self.ammonotice.alignX = "center";
			self.ammonotice.alignY = "middle";
			self.ammonotice.x = 320;
			self.ammonotice.y = 320;
			self.ammonotice.alpha = 1;
			self.ammonotice setText( &"Hold [F] to get ammo/health" );
		}
		
		while ( !self.givenammo && self usebuttonpressed() && self isOnGround() && isAlive( self ) )
		{
			org = spawn( "script_origin", self.origin );
			if ( !isdefined( self.progressbackground ) )
			{
				self.progressbackground = newClientHudElem( self );				
				self.progressbackground.alignX = "center";
				self.progressbackground.alignY = "middle";
				self.progressbackground.x = 320;
				self.progressbackground.y = 385;
				self.progressbackground.alpha = 0.75;
			}
			self.progressbackground setShader( "black", ( level.barsize + 4 ), 12 );		

			if ( !isdefined( self.progressbar ) )
			{
				self.progressbar = newClientHudElem( self );				
				self.progressbar.alignX = "left";
				self.progressbar.alignY = "middle";
				self.progressbar.x = ( 320 - ( level.barsize / 2.0 ) );
				self.progressbar.y = 385;
				self.progressbar.alpha = 1;
			}
			self.progressbar setShader( "white", 0, 8 );
			self.progressbar scaleOverTime( level.planttime, level.barsize, 8 );
			
			self linkto( org );
			
			self.progresstime = 0;
			while( self useButtonPressed() && ( self.progresstime < level.planttime ) && isAlive( self ) )
			{
				self.progresstime += 0.05;
				wait 0.05;
			}
			
			org delete();
			
			if ( self.progresstime >= level.planttime )
			{			
				self.ammoboxuses++;
				
				if ( self.ammoboxuses < 3 )
					self iPrintLnBold( "You have " + ( 3 - self.ammoboxuses ) + " more free ammobox uses." );
				
				if ( self.ammoboxuses > 3 )
				{
					if ( self.points < 50 )
					{
						self iPrintLnBold( "You don't have enough points to get ammo." );
						continue;
					}
					
					self.points -= 50;
				}
				
				primarymax = maps\mp\gametypes\_zombie::getWeaponMaxWeaponAmmo( self.pers[ "weapon" ] );
				pistolmax = maps\mp\gametypes\_zombie::getWeaponMaxWeaponAmmo( "luger_mp" );
				primaryclip = maps\mp\gametypes\_zombie::getWeaponMaxClipAmmo( self.pers[ "weapon" ] );
				pistolclip = maps\mp\gametypes\_zombie::getWeaponMaxClipAmmo( "luger_mp" );
				
				bonus = self maps\mp\gametypes\_zombie::getAmmoBonusForRank();
				
				addprimary = self maps\mp\gametypes\_zombie::getWeaponMaxClipAmmo( self.pers[ "weapon" ] ) * bonus;
				addpistol = self maps\mp\gametypes\_zombie::getWeaponMaxClipAmmo( "luger_mp" ) * bonus;
				
				self setWeaponSlotAmmo( "primary", primarymax + addprimary );
				self setWeaponSlotAmmo( "pistol", pistolmax + addpistol );
				
				if ( self hasWeapon( "fraggrenade_mp" ) )
					self setWeaponSlotWeapon( "grenade", "fraggrenade_mp" );
				else
					self setWeaponSlotWeapon( "grenade", "stielhandgranate_mp" );
				
				if ( level.gamestarted ) {
					if ( self.class != "engineer" && self.class != "medic" && self.class != "support" ) 
						self setWeaponSlotAmmo( "grenade", self.stickynades );
				
					if ( self.healthpacks < self.maxhealthpacks )
						self.healthpacks++;
				}
				
				self.givenammo = true;
				
				self.health = self.maxhealth;
				
				self.progressbackground destroy();
				self.progressbar destroy();
				
				if ( isDefined( self.poisonhud ) )
					self.poisonhud destroy();
				
				self playSound( "weap_ammo_pickup" );
				
				self thread waitammo();
				break;
			}
			else
			{
				self.progressbackground destroy();
				self.progressbar destroy();
			}
		}
		
		wait 0.05;
	}
	
	if ( isDefined( self.ammonotice ) )
		self.ammonotice destroy();

	self.gettingammo = false;
}

waitammo()
{
	wait 6;
	self.givenammo = false;
}