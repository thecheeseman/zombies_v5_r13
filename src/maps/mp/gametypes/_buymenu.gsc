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

init()
{
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_buymenu.gsc::init()", true );
	
	level.points = [];
	level.points[ "buy_armor_10" ] = 100;
	level.points[ "buy_armor_25" ] = 250;
	level.points[ "buy_armor_50" ] = 500;
	level.points[ "buy_explo_10" ] = 100;
	level.points[ "buy_explo_25" ] = 250;
	level.points[ "buy_explo_50" ] = 500;
	level.points[ "buy_damage_10" ] = 100;
	level.points[ "buy_damage_25" ] = 250;
	level.points[ "buy_healthpack" ] = 100;
	level.points[ "buy_proxy" ] = 100;
	level.points[ "buy_crate" ] = 100;
	level.points[ "buy_barrel" ] = 200;
	level.points[ "rocket" ] = 2500;
	level.points[ "mortar" ] = 5000;
	level.points[ "artillery" ] = 7500;
	level.points[ "gatlin" ] = 10000;
	level.points[ "airstrike" ] = 15000;
	level.points[ "carpetbomb" ] = 20000;
	level.points[ "nuke" ] = 25000;
	level.points[ "random" ] = 100;
	level.points[ "buy_panzer" ] = 1000;
	level.points[ "buy_flashnades" ] = 500;
	level.points[ "buy_nightvision" ] = 500;
	level.points[ "nothing" ] = 0;
	
	level.pointsnames = [];
	level.pointsnames[ "buy_armor_10" ] = "100 Armor";
	level.pointsnames[ "buy_armor_25" ] = "250 Armor";
	level.pointsnames[ "buy_armor_50" ] = "500 Armor";
	level.pointsnames[ "buy_explo_10" ] = "100 Explosion Armor";
	level.pointsnames[ "buy_explo_25" ] = "250 Explosion Armor";
	level.pointsnames[ "buy_explo_50" ] = "500 Explosion Armor";
	level.pointsnames[ "buy_damage_10" ] = "10% Damage Increase";
	level.pointsnames[ "buy_damage_25" ] = "25% Damage Increase";
	level.pointsnames[ "buy_healthpack" ] = "a Healthpack";
	level.pointsnames[ "buy_proxy" ] = "a Proxy";
	level.pointsnames[ "buy_crate" ] = "a Crate";
	level.pointsnames[ "buy_barrel" ] = "a Barrel";
	level.pointsnames[ "rocket" ] = "Rocket Attack";
	level.pointsnames[ "mortar" ] = "Mortar Strike";
	level.pointsnames[ "artillery" ] = "Artillery Barrage";
	level.pointsnames[ "airstrike" ] = "Airstrike";
	level.pointsnames[ "gatlin" ] = "a Gatlin Gun";
	level.pointsnames[ "carpetbomb" ] = "a Carpet Bomb";
	level.pointsnames[ "nuke" ] = "a Nuke";
	level.pointsnames[ "buy_panzer" ] = "a Panzerfaust";
	level.pointsnames[ "buy_flashnades" ] = "Flashbangs";
	level.pointsnames[ "buy_nightvision" ] = "Nightvision";
	level.pointsnames[ "nothing" ] = "absolutely nothing";

	level.potentialwinlist = [];
	level.potentialwinlist[ 0 ] = "buy_healthpack";
	level.potentialwinlist[ 1 ] = "buy_proxy";
	level.potentialwinlist[ 2 ] = "buy_damage_10";
	level.potentialwinlist[ 3 ] = "buy_damage_25";
	level.potentialwinlist[ 4 ] = "buy_armor_10";
	level.potentialwinlist[ 5 ] = "buy_armor_25";
	level.potentialwinlist[ 6 ] = "buy_armor_50";
	level.potentialwinlist[ 7 ] = "buy_explo_10";
	level.potentialwinlist[ 8 ] = "buy_explo_25";
	level.potentialwinlist[ 9 ] = "buy_explo_50";
	level.potentialwinlist[ 10 ] = "rocket";
	level.potentialwinlist[ 11 ] = "mortar";
	level.potentialwinlist[ 12 ] = "artillery";
	level.potentialwinlist[ 13 ] = "gatlin";
	level.potentialwinlist[ 14 ] = "airstrike";
	level.potentialwinlist[ 15 ] = "carpetbomb";
	level.potentialwinlist[ 16 ] = "nuke";

												// 66.43% of losing
	level.potentialwinlistprimes = [];			// 33.57% chance to win something
	level.potentialwinlistprimes[ 0 ] = 13;		// 7.69%
	level.potentialwinlistprimes[ 1 ] = 17;		// 5.88%
	level.potentialwinlistprimes[ 2 ] = 23;		// 4.34%
	level.potentialwinlistprimes[ 3 ] = 31;		// 3.22%
	level.potentialwinlistprimes[ 4 ] = 41;		// 2.43%
	level.potentialwinlistprimes[ 5 ] = 53;		// 1.88%
	level.potentialwinlistprimes[ 6 ] = 61;		// 1.63%
	level.potentialwinlistprimes[ 7 ] = 71;		// 1.41%
	level.potentialwinlistprimes[ 8 ] = 83;		// 1.20%
	level.potentialwinlistprimes[ 9 ] = 97;		// 1.03%
	level.potentialwinlistprimes[ 10 ] = 113;	// 0.88%
	level.potentialwinlistprimes[ 11 ] = 157;	// 0.63%
	level.potentialwinlistprimes[ 12 ] = 211;	// 0.47%
	level.potentialwinlistprimes[ 13 ] = 257;	// 0.38%
	level.potentialwinlistprimes[ 14 ] = 313;	// 0.31%
	level.potentialwinlistprimes[ 15 ] = 503;	// 0.19%
	level.potentialwinlistprimes[ 16 ] = 701;	// 0.14%
	
	precacheModel( "xmodel/barrel_black1" );
	precacheModel( "xmodel/crate_misc_red2" );
	
	level.barricades = 0;
}

buymenu( response )
{
	if ( self.pers[ "team" ] != "axis" )
		return;
		
	if ( self.sessionstate != "playing" )
		return;
		
	if ( !isDefined( level.points[ response ] ) )
	{
		self iPrintLnBold( "No such item exists." );
		return;
	}
	
	if ( self.points < level.points[ response ] )
	{
		self iPrintLnBold( "You don't have enough points to buy that item." );
		return;
	}
	
	if ( response == "random" )
	{
		self.points -= level.points[ response ];
		self thread doRandom();
	}
	else
	{
		if ( self doItem( response ) )
		{		
			self iprintlnbold( "You bought ^2" + level.pointsnames[ response ] + "^7 for " + level.points[ response ] + " points." );
			self.points -= level.points[ response ];
		} 
	}
}

doItem( response )
{
	switch ( response )
	{
		case "buy_armor_10":
			if ( self.bodyarmor >= 1500 )
			{
				self iprintlnbold( "You cannot hold any more ^2Body Armor^7!" );
				return false;
			}
			self.bodyarmor += 100;
			break;
		case "buy_armor_25":
			if ( self.bodyarmor >= 1500 )
			{
				self iprintlnbold( "You cannot hold any more ^2Body Armor^7!" );
				return false;
			}
			self.bodyarmor += 250;
			break;
		case "buy_armor_50":
			if ( self.bodyarmor >= 1500 )
			{
				self iprintlnbold( "You cannot hold any more ^2Body Armor^7!" );
				return false;
			}
			self.bodyarmor += 500;
			break;
		case "buy_explo_10":
			if ( self.exploarmor >= 1500 )
			{
				self iprintlnbold( "You cannot hold any more ^2Explosion Armor^7!" );
				return false;
			}
			self.exploarmor += 100;
			break;
		case "buy_explo_25":
			if ( self.exploarmor >= 1500 )
			{
				self iprintlnbold( "You cannot hold any more ^2Explosion Armor^7!" );
				return false;
			}
			self.exploarmor += 250;
			break;
		case "buy_explo_50":
			if ( self.exploarmor >= 1500 )
			{
				self iprintlnbold( "You cannot hold any more ^2Explosion Armor^7!" );
				return false;
			}
			self.exploarmor += 500;
			break;
		case "buy_damage_10":
			if ( self.damagearmor == 0.10 )
			{
				self iprintlnbold( "You already have ^210% Damage Increase^7." );
				return false;
			}
			if ( self.damagearmor > 0.10 )
			{
				self iprintlnbold( "You already have a HIGHER value Damage Increase." );
				return false;
			}
			
			self.damagearmor = 0.10;
			break;
		case "buy_damage_25":
			if ( self.damagearmor == 0.25 )
			{
				self iprintlnbold( "You already have ^225% Damage Increase^7." );
				return false;
			}
			
			self.damagearmor = 0.25;
			break;
		case "buy_healthpack":
			self.healthpacks++;
			break;
		case "buy_proxy":
			self.stickynades++;
			break;
		case "buy_crate":
		case "buy_barrel":
			if ( level.barricades > level.cvars[ "MAX_BARRICADES" ] )
			{
				self iPrintLnBold( "Too many barricades in map." );
				return false;
			}

			if ( isDefined( self.insidebarricade ) ) {
				self iPrintLnBold( "Please move out of your barricade before placing a new one." );
				return false;
			}
			
			self thread barricade( response );
			break;
		case "rocket":
		case "mortar":
		case "artillery":
		case "gatlin":
		case "airstrike":
		case "carpetbomb":
		case "nuke":
			self.powerup = response;
			self thread maps\mp\gametypes\_killstreaks::notifyPowerup();
			break;
		case "buy_panzer":
			self setWeaponSlotWeapon( "primaryb", "panzerfaust_mp" );
			self setWeaponSlotAmmo( "primaryb", 5 );
			self switchToWeapon( "panzerfaust_mp" );
			break;
		case "buy_flashnades":
			self.flashbangs = true;
			self setWeaponSlotWeapon( "grenade", "fraggrenade_mp" );
			if ( level.gamestarted ) 
				self setWeaponSlotAmmo( "grenade", self.stickynades );
			self switchToWeapon( "fraggrenade_mp" );
			break;
		case "buy_nightvision":
			self iPrintLn( "Nightvision is dumb, so don't use it" );
			return false;
			/*
			if ( self.nightvision )
			{
				self iPrintLnBold( "You already have Nightvision!" );
				self.points += level.points[ response ];
				return false;
			}
			
			self thread maps\mp\gametypes\_hud::nightvision();
			*/
			break;
	}
	
	return true;
}

doRandom()
{
	rnd = maps\mp\gametypes\_zombie::_randomInt( 10000 );
	
	self iPrintLnBold( "You spent 100 points for a random item and got..." );

	won = "nothing";
	for ( i = 0; i < level.potentialwinlistprimes.size; i++ ) {
		if ( rnd % level.potentialwinlistprimes[ i ] == 0 ) {
			won = level.potentialwinlist[ i ];
			break;
		}
	}

	self iPrintLnBold( "^2" + level.pointsnames[ won ] + "!" );
		
	if ( won != "nothing" )
		self thread doItem( won );
}

barricade( item )
{
	switch ( item )
	{
		case "buy_barrel":
			model = "xmodel/barrel_black1";
			clip = [];
			clip[ 0 ] = ( 0, 0, 40 );
			trigdistance = 40;
			break;
		case "buy_crate":
			model = "xmodel/crate_misc_red2";
			clip = [];
			clip[ 0 ] = ( 0, 0, 24 );
			trigdistance = 32;
			break;
	}
	
	if ( isDefined( model ) )
		self thread spawn_barricade( model, clip, trigdistance );
}

spawn_barricade( model, clip, trigdistance )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "spawn_spectator" );
	
	num = self.barricades.size;
	org = self.origin;
	totalmodels = 1;
	
	self.barricades[ num ] = spawnstruct();
	self.barricades[ num ].model = spawn( "script_model", org );
	self.barricades[ num ].model setModel( model );
	//self.barricades[ num ].model enablelinkto();
	wait 0.05;

	switch ( model ) {
		case "xmodel/barrel_black1":
			self.barricades[ num ].model setBounds( 4, 40 );
			break;
		case "xmodel/crate_misc_red2":
			self.barricades[ num ].model setBounds( 4, 24 );
			break;
	}
/*	
	self.barricades[ num ].clip = [];
	
	for ( i = 0; i < clip.size; i++ )
	{
		self.barricades[ num ].clip[ i ] = spawn( "script_model", org + clip[ i ] );
		self.barricades[ num ].clip[ i ] setModel( model );
		self.barricades[ num ].clip[ i ] linkto( self.barricades[ num ].model );
		self.barricades[ num ].clip[ i ] hide();
		totalmodels++;
		wait 0.05;
	}
	*/
	level.barricades += totalmodels;
	
	self.barricades[ num ].model thread maps\mp\gametypes\_physics::doPhysics();

	self.insidebarricade = true;
	
	while ( distance( self.origin, org ) < trigdistance )
		wait 0.05;

	self.insidebarricade = undefined;
		
	self.barricades[ num ].model setContents( 1 );
	self.barricades[ num ].model thread beDestroyed( self, model );
	//for ( i = 0; i < clip.size; i++ )
	//	self.barricades[ num ].clip[ i ] setContents( 1 );
}

cleanUp()
{
	totalmodels = 0;
	for ( i = 0; i < self.barricades.size; i++ )
	{
		if ( isDefined( self.barricades[ i ] ) ) {
			self.barricades[ i ] notify( "stop_physics" );
			self.barricades[ i ] notify( "stop destroy" );

			if ( isDefined( self.barricades[ i ].model ) )
				self.barricades[ i ].model delete();
		}

		totalmodels++;
		
		/*for ( j = 0; j < self.barricades[ i ].clip.size; j++ )
		{
			self.barricades[ i ].clip[ j ] delete();
			totalmodels++;
		}*/
	}
	
	level.barricades -= totalmodels;
}

beDestroyed( owner, type ) {
	self endon( "stop destroy" );

	self.health = 2000;
	if ( type == "xmodel/barrel_black1" )
		self.health = 5000;

	attacker = undefined;
	while ( self.health > 0 ) {
		wait 0.05;

		doHit = false;
    	attackerweapon = "enfield_mp";
	    players = getEntArray( "player", "classname" );
	    for ( i = 0; i < players.size; i++ ) {
	        if ( distance( self.origin, players[ i ].origin ) < 32 ) {
	            //if ( players[ i ].pers[ "team" ] == "allies" && players[ i ].sessionstate == "playing" && players[ i ] meleeButtonPressed() && !isDefined( players[ i ].meleedown ) ) {
	        	if ( players[ i ].sessionstate == "playing" && players[ i ] meleeButtonPressed() && !isDefined( players[ i ].meleedown ) ) {
	                attacker = players[ i ];
	                attacker thread maps\mp\gametypes\_classes::meleedowntrack();
	                attackerweapon = players[ i ] getCurrentWeapon();
	                doHit = true;
	                break;
	            }
	        }
	    }
    
	    if ( doHit ) {
	        damage = 0;
	        switch ( attackerweapon ) {
	            case "sten_mp":             damage = 35; break;
	            case "colt_mp":         
	            case "mk1britishfrag_mp":   damage = 50; break;
	            case "enfield_mp":  
	            case "springfield_mp":      damage = 150; break;
	            case "bren_mp":             damage = 200; break;
	            case "kar98k_mp":			damage = 200; break;
	        }

	        if ( damage == 0 )
	        	continue;

            self playSound( "melee_hit" );
            attacker thread maps\mp\gametypes\_zombie::showhit();
            
	        self.health -= damage * attacker.damagemult;

			attacker iPrintLn( "You did ^1" + (int)( damage * attacker.damagemult ) + "^7 damage to that barricade!" );
	        owner iPrintLn( attacker.name + "^7 did ^1" + (int)( damage * attacker.damagemult ) + "^7 damage to your barricade (^2" + self.health + "^7 HP remaining)!" );

	        if ( self.health < 0 )
	            self.health = 0;

	        if ( self.health == 0 ) {
	        	break;
	        }
	    }
	}

	if ( isDefined( attacker ) )
		iPrintLn( attacker.name + " ^7destroyed a barricade!" );

	self delete();
}
