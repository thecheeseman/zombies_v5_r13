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
    precacheModel( "xmodel/USAirborneHelmet_Medic" );
}

setup() {
    if ( self.pers[ "team" ] == "axis" ) {
        switch ( self.pers[ "weapon" ] ) {
            case "kar98k_mp":
            case "m1garand_mp":
                self.class = "engineer";

                self setMoveSpeedScale( 1.15 );
                break;
            case "mp40_mp":
            case "thompson_mp":
                self.class = "medic";

                self setMoveSpeedScale( 1.3 );

                self detach( self.hatmodel );
                self.hatmodel = "xmodel/USAirborneHelmet_Medic";
                self attach( self.hatmodel );

                self thread regen_health();
                self thread healthbag();
                break;
            case "mp44_mp":
            case "bar_mp":
                self.class = "support";

                self setMoveSpeedScale( 1.1 );

                self thread ammobox();
                break;
            case "kar98k_sniper_mp":
            case "springfield_mp":
                self.class = "sniper";

                self setMoveSpeedScale( 1.2 );
                break;
            // recon
            case "m1carbine_mp":
                self.class = "recon";

                self setMoveSpeedScale( 1.4 );

                self thread recon();
                break;
        }
        
    } else {
        switch ( self.pers[ "weapon" ] ) {
            case "enfield_mp":
                self.zombietype = "jumper";
                self setMoveSpeedScale( 1.3 );
                self thread superJump();
                break;
            case "sten_mp":
                self.zombietype = "fast";
                self setMoveSpeedScale( 1.75 );
                self thread fastZombie();
                break;
            case "bren_mp":
                self.zombietype = "poison";
                self setMoveSpeedScale( 1.1 );
                self thread poisonZombie();
                break;
            case "springfield_mp":
                self.zombietype = "fire";
                self setMoveSpeedScale( 1.2 );
                self thread fireZombie();
                break;
        }
    }
}


recon() {
    doublejumped = false;
    self.jumpblocked = false;
    airjumps = 0;

    self endon( "death" );
    self endon( "disconnect" );
    self endon( "spawned" );
    while ( !level.lasthunter & self.class == "recon" ) {
        if ( self useButtonPressed() && !self.jumpblocked && !self isOnGround() ) 
        {
            if ( !self isOnGround() )
                airjumps++;
                
            if ( airjumps == 1 ) {
                airjumps = 0;
                self thread blockjump();
            }

            for ( i = 0; i < 2; i++ ) 
            {
                self.health += 100;
                self finishPlayerDamage(self, self, 100, 0, "MOD_PROJECTILE", "panzerfaust_mp", (self.origin + (0,0,-1)), vectornormalize(self.origin - (self.origin + (0,0,-1))), "none");
            }
            wait 1;
        }
        wait 0.05;
    }
}

regen_health()
{   
    self endon( "death" );
    self endon( "disconnected" );
    self endon( "spawned" );

    while ( !level.lasthunter && self.class == "medic" ) {
        // got hurt somehow
        if ( self.health < self.maxhealth && self.lasthittime + 3000 < gettime() )
            self.health++;
            
        wait 0.5;
    }
}

healthbag()
{
    mypack = spawn( "script_model", self getOrigin() );
    mypack setModel( "xmodel/health_large" );
    mypack setContents( 0 );
    
    self thread dohealing( mypack );
    
    while ( isAlive( self ) && self.class == "medic" && !level.lasthunter )
    {  
        wait 0.05;
        
        mypack hide();
        
        if ( self getCurrentWeapon() != "stielhandgranate_mp" ) {
            mypack.origin = self.origin + ( 0, 0, 36 );
            continue;
        }

        mypack show();
        traceDir = anglesToForward( self.angles );
        traceEnd = self.origin + ( 0, 0, 36 );
        traceEnd += maps\mp\_utility::vectorscale( traceDir, 16 );
        trace = bulletTrace( self.origin + ( 0, 0, 36 ), traceEnd, false, mypack );

        pos = trace[ "position" ];
        mypack moveto( pos, 0.05 );
        mypack.angles = self.angles;
    }

    self notify( "remove healthbag" );
    mypack delete();
}

dohealing( mypack )
{
    self endon( "remove healthbag" );

    healamount = 0;
    while ( isAlive( self ) && self.class == "medic" )
    {
        wait 0.25;
        
        if ( self getCurrentWeapon() != "stielhandgranate_mp" )
            continue;
            
        //players = [[ level.call ]]( "get_good_players" );
        players = getEntArray( "player", "classname" );
        for ( i = 0; i < players.size; i++ )
        {
            if ( players[ i ].sessionstate == "playing" && players[ i ].pers[ "team" ] == "axis" && distance( mypack.origin, players[ i ].origin ) < 56 )
            {
                if ( players[ i ].ispoisoned )
                {
                    players[ i ].ispoisoned = false;
                    //self.stats[ "infectionsHealed" ]++;
                }
                if ( players[ i ].onfire )
                {
                    players[ i ].onfire = false;
                    players[ i ] thread medic_fire_timeout();
                    //self.stats[ "firesPutOut" ]++;
                }
                    
                if ( players[ i ] != self && players[ i ].health < players[ i ].maxhealth )
                {
                    players[ i ].health++;
                    healamount++;

                    if ( healamount % 25 == 0 ) {
                        self.xp += level.xpvalues[ "medic_heal" ];
                        self.score += level.xpvalues[ "medic_heal" ];
                        iPrintLn( "^3+" + level.xpvalues[ "medic_heal" ] + " XP!" );
                        self thread maps\mp\gametypes\_zombie::checkRank();
                    }
                    //self.stats[ "healPoints" ]++;
                }
            }
        } 
    }
}

medic_fire_timeout()
{
    self.firetimeout = true;
    wait 1;
    self.firetimeout = undefined;
}

ammobox()
{  
    boxmodels = [];
    //boxmodels[ 0 ] = "xmodel/crate_misc1";
    //boxmodels[ 1 ] = "xmodel/crate_misc_red1";
    //boxmodels[ 2 ] = "xmodel/crate_misc_green1";
    boxmodels[ 0 ] = "xmodel/crate_champagne3";
    modeli = 0;
    
    mybox = spawn( "script_model", self getOrigin() );
    mybox setModel( boxmodels[ modeli ] );
    mybox setContents( 0 );
    
    self thread ammobox_think( mybox );
    
    while ( isAlive( self ) && self.class == "support" && !level.lasthunter )
    {  
        wait 0.05;
        
        mybox hide();
        
        if ( self getCurrentWeapon() != "stielhandgranate_mp" ) {
            mybox.origin = self.origin;
            continue;
        }

        mybox show();
        traceDir = anglesToForward( self.angles );
        traceEnd = self.origin + ( 0, 0, 36 );
        traceEnd += maps\mp\_utility::vectorscale( traceDir, 48 );
        trace = bulletTrace( self.origin + ( 0, 0, 36 ), traceEnd, false, mybox );

        pos = trace[ "position" ];
        mybox moveto( pos, 0.05 );
        mybox.angles = self.angles;
    }
    
    self notify( "remove ammobox" );
    mybox delete();
}

ammobox_think( box )
{
    self endon( "remove ammobox" );
    
    while ( isAlive( self ) )
    {
        wait 0.5;
        
        if ( self getCurrentWeapon() != "stielhandgranate_mp" )
            continue;
            
        players = getEntArray( "player", "classname" );
        for ( i = 0; i < players.size; i++ )
        {
            if ( distance( box.origin, players[ i ].origin ) < 64 && players[ i ].pers[ "team" ] == "axis" && players[ i ].sessionstate == "playing" )
            {
                // stolen from kill3r's mod
                // this way is better suited for this version of zombies, since we're not actually giving health anymore
                oldamountpri = players[ i ] getWeaponSlotAmmo( "primary" );
                oldamountprib = players[ i ] getWeaponSlotAmmo( "primaryb" );
                oldamountpistol = players[ i ] getWeaponSlotAmmo( "pistol" );
                oldamountgrenade = players[ i ] getWeaponSlotAmmo( "grenade" );
                
                maxpri = maps\mp\gametypes\_zombie::getWeaponMaxWeaponAmmo( players[ i ] getWeaponSlotWeapon( "primary" ) );
                maxprib = maps\mp\gametypes\_zombie::getWeaponMaxWeaponAmmo( players[ i ] getWeaponSlotWeapon( "primaryb" ) );
                maxpistol = maps\mp\gametypes\_zombie::getWeaponMaxWeaponAmmo( players[ i ] getWeaponSlotWeapon( "pistol" ) );
                maxgrenade = players[ i ] maps\mp\gametypes\_zombie::getHunterNadeAmmo();

                if ( players[ i ].class == "engineer" || players[ i ].class == "medic" || players[ i ].class == "support" || !level.gamestarted )
                    maxgrenade = oldamountgrenade;

                bonus = self maps\mp\gametypes\_zombie::getAmmoBonusForRank();

                maxpri += maps\mp\gametypes\_zombie::getWeaponMaxClipAmmo( players[ i ] getWeaponSlotWeapon( "primary" ) ) * bonus;
                maxprib += maps\mp\gametypes\_zombie::getWeaponMaxClipAmmo( players[ i ] getWeaponSlotWeapon( "primaryb" ) ) * bonus;
                maxpistol += maps\mp\gametypes\_zombie::getWeaponMaxClipAmmo( players[ i ] getWeaponSlotWeapon( "pistol" ) ) * bonus;
               
                // do we even need ammo?
                if ( oldamountpri >= maxpri && oldamountprib >= maxprib && oldamountpistol >= maxpistol && oldamountgrenade >= maxgrenade )
                    continue;
                
                players[ i ] playlocalsound( "weap_pickup" );
                self playlocalsound( "weap_pickup" );

                if ( oldamountpri < maxpri )
                {
                    if ( players[ i ] getWeaponSlotWeapon( "primary" ) != "panzerfaust_mp" ) 
                        players[ i ] setWeaponSlotAmmo( "primary", ( oldamountpri + 5 ) );
                    else
                        players[ i ] setWeaponSlotAmmo( "primary", ( oldamountpri + 1 ) );
                }
                if ( oldamountprib < maxprib )
                    players[ i ] setWeaponSlotAmmo( "primaryb", ( oldamountprib + 5 ) );
                if ( oldamountpistol < maxpistol )
                    players[ i ] setWeaponSlotAmmo( "pistol", ( oldamountpistol + 5 ) );
                if ( oldamountgrenade < maxgrenade )
                    players[ i ] setWeaponSlotAmmo( "grenade", ( oldamountgrenade + 1 ) );
                    
                newamountpri = players[ i ] getWeaponSlotAmmo( "primary" );
                newamountprib = players[ i ] getWeaponSlotAmmo( "primaryb" );
                newamountpistol = players[ i ] getWeaponSlotAmmo( "pistol" );
                
                ammogiven = ( newamountpri - oldamountpri ) + ( newamountprib - oldamountprib ) + ( newamountpistol - oldamountpistol );
                if ( players[ i ] getWeaponSlotWeapon( "primary" ) == "panzerfaust_mp" )
                    ammogiven -= ( newamountpri - oldamountpri );
                    
                if ( players[ i ] != self )
                {
                    //self.stats[ "ammoPoints" ] += (int)( ammogiven / 5 );
                    //self.stats[ "ammoGivenOut" ] += ammogiven;
                }
            }
        }
    }
}

superJump()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "end_respawn" );
    
    self iPrintLn( "Zombie perk: ^2Super jump" );
    
    self.maxhealth = 800;
    self.health = self.maxhealth;
    
    wait 1;

    doublejumped = false;
    self.jumpblocked = false;
    airjumps = 0;
    while ( isAlive( self ) ) {
        if ( self useButtonPressed() && !self.jumpblocked ) 
        {
            if ( !self isOnGround() )
                airjumps++;
                
            if ( airjumps == 2 ) {
                airjumps = 0;
                self thread blockjump();
            }

            for ( i = 0; i < 2; i++ ) 
            {
                self.health += level.cvars[ "JUMPER_DAMAGE" ];
                self finishPlayerDamage(self, self, level.cvars[ "JUMPER_DAMAGE" ], 0, "MOD_PROJECTILE", "panzerfaust_mp", (self.origin + (0,0,-1)), vectornormalize(self.origin - (self.origin + (0,0,-1))), "none");
            }
            wait 1;
        }
        wait 0.05;
    }
}

blockjump() 
{
    self.jumpblocked = true;
    
    while ( isAlive( self ) && !self isOnGround() )
        wait 0.05;
        
    self.jumpblocked = false;
}

fastZombie()
{
    self iPrintLn( "Zombie perk: ^2Super speed/bash" );
    
    self.maxhealth = 500;
    self.health = self.maxhealth;
    self.missmines = true;
}

poisonZombie()
{
    self iPrintLn( "Zombie perk: ^2Poison" );
    
    self.maxhealth = 1000;
    self.health = self.maxhealth;
}

poisonbomb()
{
    if ( !self.poisonbombready )
    {
        self iPrintLn( "^1You cannot activate Poison Bomb at this time." );
        wait 1;
        return;
    }
    
    self thread poisonbombwait();
    
    self suicide();
    
    maps\mp\gametypes\_zombie::scriptedRadiusDamage( self.origin + ( 0, 0, 12 ), 386, level.cvars[ "BOMB_DAMAGE_MAX" ], level.cvars[ "BOMB_DAMAGE_MIN" ], self );
    earthquake( 0.5, 3, self.origin + ( 0, 0, 12 ), 386 );
    playFx( level._effect[ "aftermath" ], self.origin );
    thread maps\mp\gametypes\_zombie::playSoundInSpace( "explo_rock", self.origin + ( 0, 0, 12 ), 4 );

    players = getEntArray( "player", "classname" );
    for ( i = 0; i < players.size; i++ )
    {
        if ( players[ i ] != self && ( distance( self.origin, players[ i ].origin ) < 256 && players[ i ].pers[ "team" ] == "axis" && !players[ i ].ispoisoned && !players[ i ].immune ) )
        {
            trace = bullettrace( self.origin, players[ i ].origin + ( 0, 0, 16 ), false, undefined );
            trace2 = bullettrace( self.origin, players[ i ].origin + ( 0, 0, 40 ), false, undefined );
            trace3 = bullettrace( self.origin, players[ i ].origin + ( 0, 0, 60 ), false, undefined );
            if ( trace[ "fraction" ] != 1 && trace2[ "fraction" ] != 1 && trace3[ "fraction" ] != 1 )
                continue;
                
            players[ i ] thread bePoisoned( self );
        }
    }
}

poisonbombwait()
{
    self endon( "disconnect" );
    
    self.poisonbombready = false;
    wait ( level.cvars[ "BOMB_TIME" ] * 60 );
    self.poisonbombready = true;
}

bePoisoned( dude )
{
    if ( self.bodyarmor > 0 )
        return;

    if ( self.ispoisoned )
        return;

    self.ispoisoned = true;
        
    self.poisonhud = newClientHudElem( self );
    self.poisonhud.x = 0;
    self.poisonhud.y = 0;
    self.poisonhud setShader( "white", 640, 480 );
    self.poisonhud.color = ( 0, 1, 0 );
    self.poisonhud.alpha = 0.1;
    self.poisonhud.sort = 1;
    
    self iPrintLnBold( "You have been ^2poisoned^7!" );
    
    while ( isAlive( self ) )
    {
        oldhealth = self.health;
        
        dmg = (int)( 5 * dude.damagemult );
        
        self finishPlayerDamage( dude, dude, dmg, 0, "MOD_MELEE", "bren_mp", self.origin, ( 0, 0, 0 ), "none" );
        
        wait 2;
        
        if ( self.health > oldhealth )
            break;
    }
    
    if ( isDefined( self.poisonhud ) )
        self.poisonhud destroy();

    self.ispoisoned = false;
}

fireZombie()
{
    self endon( "disconnect" );
    self endon( "end_respawn" );
    
    self iPrintLn( "Zombie perk: ^2Fire" );
    
    self.maxhealth = 700;
    self.health = self.maxhealth;
    
    self thread firemonitor( self );
    
    self waittill( "death" );
    
    if ( self.firebombed )
        return;
    
    maps\mp\gametypes\_zombie::scriptedRadiusDamage( self.origin + ( 0, 0, 12 ), 192, 75, 20, self );
    earthquake( 0.25, 3, self.origin + ( 0, 0, 12 ), 192 );
    playFx( level._effect[ "zombieExplo" ], self.origin );
}

firebomb()
{
    if ( !self.firebombready )
    {
        self iPrintLn( "^1You cannot activate Fire Bomb at this time." );
        wait 1;
        return;
    }
        
    self.firebombed = true;
    
    self thread firebombwait();
    
    self suicide();
    
    maps\mp\gametypes\_zombie::scriptedRadiusDamage( self.origin + ( 0, 0, 12 ), 386, level.cvars[ "BOMB_DAMAGE_MAX" ], level.cvars[ "BOMB_DAMAGE_MIN" ], self );
    earthquake( 0.5, 3, self.origin + ( 0, 0, 12 ), 386 );
    playFx( level._effect[ "zombieExplo" ], self.origin );
    
    players = getEntArray( "player", "classname" );
    for ( i = 0; i < players.size; i++ )
    {
        if ( players[ i ] != self && ( distance( self.origin, players[ i ].origin ) < 256 && players[ i ].pers[ "team" ] == "axis" && !players[ i ].onfire && !players[ i ].immune ) )
        {
            trace = bullettrace( self.origin, players[ i ].origin + ( 0, 0, 16 ), false, undefined );
            trace2 = bullettrace( self.origin, players[ i ].origin + ( 0, 0, 40 ), false, undefined );
            trace3 = bullettrace( self.origin, players[ i ].origin + ( 0, 0, 60 ), false, undefined );
            if ( trace[ "fraction" ] != 1 && trace2[ "fraction" ] != 1 && trace3[ "fraction" ] != 1 )
                continue;
                
            players[ i ] thread firemonitor( self );
        }
    }
}

firebombwait()
{
    self endon( "disconnect" );
    
    self.firebombready = false;
    wait ( level.cvars[ "BOMB_TIME" ] * 60 );
    self.firebombready = true;
}

firemonitor( dude )
{
    if ( self.bodyarmor > 0 )
        return;

    if ( self.onfire )
        return;
        
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "end_respawn" );
    self endon( "stopfire" );
    self endon( "spawn_spectator" );
    
    if ( self.pers[ "team" ] == "axis" )
        self thread firedeath( dude );
    
    while ( 1 )
    {
        playFx( level._effect[ "zombieFire" ], self.origin + ( 0, 0, 32 ) );
        
        players = getEntArray( "player", "classname" );
        for ( i = 0; i < players.size; i++ )
        {
            if ( players[ i ] != self && ( distance( self.origin, players[ i ].origin ) < 36 && !players[ i ].onfire && !players[ i ].immune ) )
                players[ i ] thread firemonitor( dude );
        }
        
        wait 0.2;
    }
}

firedeath( dude )
{
    if ( self.onfire )
        return;
    
    self.onfire = true;
    self iPrintLnBold( "You are on ^1fire^7!" );
    
    while ( isAlive( self ) )
    {
        oldhealth = self.health;
        
        dmg = (int)( 3 * dude.damagemult );
        
        self finishPlayerDamage( dude, dude, dmg, 0, "MOD_MELEE", "springfield_mp", self.origin, ( 0, 0, 0 ), "none" );
        
        wait 1;
        
        if ( self.health > oldhealth )
            break;
    }
    
    self notify( "stopfire" );
    self.onfire = false;
}

