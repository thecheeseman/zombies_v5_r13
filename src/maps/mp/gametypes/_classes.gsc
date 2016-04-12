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
    precacheModel( "xmodel/barrel_black1" );
    precacheModel( "xmodel/mg42_bipod" );
    precacheModel( "xmodel/mp_crate_misc_red1" );

    precacheString( &"Sentry status: " );
    precacheString( &"Sentry health: " );
    precacheString( &"Sentry kills: " );
    precacheString( &"Firing" );
    precacheString( &"Reloading" );
    precacheString( &"Disabled" );
    precacheString( &"Idle" );
    precacheString( &"Hold [{+activate}] to move turret" );
    precacheString( &"Invisibility status: " );
    precacheString( &"Ready" );
    precacheString( &"Recharging" );
    precacheString( &"Invisible" );
    precacheString( &"Cooldown" );

    level._effect[ "sentry_fire" ] = loadfx( "fx/muzzleflashes/mg42flash.efx" );
    level._effect[ "sentry_onfire" ] = loadfx( "fx/fire/barrelfire.efx" );
    level._effect[ "sentry_explode" ] = loadfx( "fx/explosions/pathfinder_explosion.efx" );
}

setup() {
    if ( self.pers[ "team" ] == "axis" ) {
        self.oldclass = self.class;

        switch ( self.pers[ "weapon" ] ) {
            // recon
            case "m1carbine_mp":
                self.class = "recon";

                self setMoveSpeedScale( 1.45 );

                self thread recon();
                break;
            // medic
            case "mp40_mp":
            case "thompson_mp":
                self.class = "medic";

                // immune to poison/fire damage < 200
                self.immunity = 2;

                if ( self.pers[ "weapon" ] == "mp40_mp" ) {
                    self.subclass = "combat";
                    self setMoveSpeedScale( 1.35 );
                    self.maxhealthpacks += 4;
                    self.healthpacks = self.maxhealthpacks;
                } else {
                    self.stickynades = 0;

                    self setMoveSpeedScale( 1.25 );
                    self thread healthbag();
                }

                self thread regen_health();

                self detach( self.hatmodel );
                self.hatmodel = "xmodel/USAirborneHelmet_Medic";
                self attach( self.hatmodel );
                break;
            // support
            case "mp44_mp":
            case "bar_mp":
                self.class = "support";

                if ( self.pers[ "weapon" ] == "mp44_mp" ) {
                    self.subclass = "combat";

                    self setMoveSpeedScale( 1.15 );
                    self.ammobonus += 5;
                    self.maxhealth += 100;
                    self.health = self.maxhealth;
                } else {
                    self setMoveSpeedScale( 1.1 );
                    self.stickynades = 0;

                    self thread ammobox();
                }

                break;
            // engineer
            case "kar98k_mp":
            case "m1garand_mp":
                self.class = "engineer";

                if ( self.pers[ "weapon" ] == "kar98k_mp" ) {
                    self.subclass = "combat";

                    self setMoveSpeedScale( 1.25 );
                } else {
                    self setMoveSpeedScale( 1.15 );
                }

                self thread sentry();
                break;
            // sniper
            case "kar98k_sniper_mp":
            case "springfield_mp":
                self.class = "sniper";

                self setMoveSpeedScale( 1.2 );

                if ( self.pers[ "weapon" ] == "kar98k_sniper_mp" ) {
                    self.subclass = "combat";
                }

                self thread sniper();
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
    while ( !level.lasthunter ) {
        if ( self useButtonPressed() && !self.jumpblocked && !self.gettingammo && !self isOnGround() ) 
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

    while ( !level.lasthunter ) {
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
    mypack hide();
    mypack setContents( 0 );
    
    self thread healthbag_destroy( mypack );
    self thread dohealing( mypack );
    
    while ( isAlive( self ) && !level.lasthunter )
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

healthbag_destroy( bag ) {
    self endon( "remove healthbag" );

    self waittill( "spawned" );
    self notify( "remove healthbag" );

    if ( isDefined( bag ) )
        bag delete();
}

dohealing( mypack )
{
    self endon( "remove healthbag" );

    healamount = 0;
    while ( isAlive( self ) )
    {
        wait 1;
        
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
                    players[ i ].health += 5;
                    if ( players[ i ].health > players[ i ].maxhealth )
                        players[ i ].health = players[ i ].maxhealth;

                    healamount += 5;
                    self.stats[ "hpHealed" ] += 5;

                    self iPrintLn( "You healed " + players[ i ].name + "^7 for ^25^7 HP!" );

                    if ( healamount % 25 == 0 ) {
                        self.xp += level.xpvalues[ "medic_heal" ];
                        self.score += level.xpvalues[ "medic_heal" ];
                        self iPrintLn( "^3+" + level.xpvalues[ "medic_heal" ] + " XP!" );
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
    mybox hide();
    mybox setContents( 0 );
    
    self thread ammobox_think( mybox );
    self thread ammobox_destroy( mybox );

    self endon( "remove ammobox" );
    
    while ( isAlive( self ) && !level.lasthunter )
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

ammobox_destroy( box ) {
    self endon( "remove ammobox" );

    self waittill( "spawned" );
    self notify( "remove ammobox" );

    if ( isDefined( box ) )
        box delete();
}

ammobox_think( box )
{
    self endon( "remove ammobox" );
    
    healamount = 0;
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
                    if ( ammogiven > 0 ) {
                        self iPrintLn( "You gave ^2" + ammogiven + "^7 ammo to " + players[ i ].name + "^7!" );
                        self.stats[ "ammoHealed" ] += ammogiven;
                    }

                    healamount++;
                    if ( healamount % 10 == 0 ) {
                        self.xp += level.xpvalues[ "support_heal" ];
                        self.score += level.xpvalues[ "support_heal" ];
                        self iPrintLn( "^3+" + level.xpvalues[ "support_heal" ] + " XP!" );
                        self thread maps\mp\gametypes\_zombie::checkRank();
                    }
                    //self.stats[ "ammoPoints" ] += (int)( ammogiven / 5 );
                    //self.stats[ "ammoGivenOut" ] += ammogiven;
                }
            }
        }
    }
}

//sentry() {}

sentry()
{   
    self iPrintLn( "Double tap ^2[{+activate}]^7 to place your sentry" );

    barrel = spawn( "script_model", self getOrigin() );
    barrel hide();
    barrel setContents( 0 );
    barrel setModel( "xmodel/barrel_black1" );

    self thread sentry_destroy( barrel );

    self endon( "remove sentry" );
    
    while ( isAlive( self ) )
    {  
        wait 0.05;
        
        barrel hide();
        
        if ( self getCurrentWeapon() != "stielhandgranate_mp" )
            continue;

        barrel show();
        traceDir = anglesToForward( self getPlayerAngles() );
        traceEnd = self.origin;
        traceEnd += maps\mp\_utility::vectorScale( traceDir, 80 );
        trace = bulletTrace( self.origin, traceEnd, false, self );

        pos = trace[ "position" ];
        barrel moveto( pos, 0.05 );
        barrel.angles = self.angles;
            
        // stoled from lev
        if ( self useButtonPressed() )
        {
            catch_next = false;
            lol = false;

            for ( i = 0; i <= 0.30; i += 0.02 )
            {
                if ( catch_next && self useButtonPressed() )
                {
                    lol = true;
                    break;
                }
                else if ( !( self useButtonPressed() ) )
                    catch_next = true;

                wait 0.03;
            }
            
            if ( lol )
                break;
        }
    }
    
    if ( !isAlive( self ) )
    {
        barrel delete();
        return;
    }
    
    trace = bullettrace( barrel.origin + ( 0, 0, 24 ), barrel.origin + ( 0, 0, -10000 ), false, self );
    barrel moveto( trace[ "position" ], 0.1 );
    
    self iprintln( "Sentry placed!" );
    
    self switchToWeapon( self getWeaponSlotWeapon( "primary" ) );
    self setWeaponSlotWeapon( "grenade", "none" );
    
    wait 0.15;

    while ( isAlive( self ) && maps\mp\gametypes\_zombie::distance2d( self.origin, barrel.origin ) < 40 )
        wait 0.05;

    if ( !isAlive( self ) )
    {
        barrel delete();
        return;
    }
    
    self thread sentry_think( barrel );
    self thread sentry_remove_on_death( barrel );
    self thread sentry_remove_on_spec( barrel );

    self thread watchmoveturret( barrel );
}

sentry_destroy( barrel ) {
    self endon( "remove sentry" );

    self waittill( "spawned" );
    self notify( "remove sentry" );

    if ( isDefined( barrel ) )
        barrel delete();
}

watchmoveturret( barrel ) {
    self endon( "remove sentry" );
    self endon( "death" );
    self endon( "disconnect" );

    while ( true ) {
        if ( distance( barrel.origin, self.origin ) < level.plantdist && !isDefined( self.moveturret ) )
            self thread moveturret( barrel );
        
        wait 0.1;
    }
}

moveturret( barrel ) {
    self endon( "death" );
    self endon( "disconnect" );
    
    breakout = false;
    self.moveturret = true;

    movetime = 3;
    while ( !breakout && isDefined( barrel ) && distance( barrel.origin, self.origin ) < 40 && isAlive( self ) && !level.lasthunter )
    {   
        if ( !isDefined( self.moveturretnotice ) )
        {
            self.moveturretnotice = newClientHudElem( self );
            self.moveturretnotice.alignX = "center";
            self.moveturretnotice.alignY = "middle";
            self.moveturretnotice.x = 320;
            self.moveturretnotice.y = 320;
            self.moveturretnotice.alpha = 1;
            self.moveturretnotice setText( &"Hold [F] to move turret" );
        }
        
        while ( self usebuttonpressed() && self isOnGround() && isAlive( self ) )
        {
            org = spawn( "script_origin", self.origin );
            if ( !isdefined( self.mtprogressbackground ) )
            {
                self.mtprogressbackground = newClientHudElem( self );             
                self.mtprogressbackground.alignX = "center";
                self.mtprogressbackground.alignY = "middle";
                self.mtprogressbackground.x = 320;
                self.mtprogressbackground.y = 365;
                self.mtprogressbackground.alpha = 0.75;
            }
            self.mtprogressbackground setShader( "black", ( level.barsize + 4 ), 12 );        

            if ( !isdefined( self.mtprogressbar ) )
            {
                self.mtprogressbar = newClientHudElem( self );                
                self.mtprogressbar.alignX = "left";
                self.mtprogressbar.alignY = "middle";
                self.mtprogressbar.x = ( 320 - ( level.barsize / 2.0 ) );
                self.mtprogressbar.y = 365;
                self.mtprogressbar.alpha = 1;
                self.mtprogressbar.sort = 10;
            }
            self.mtprogressbar setShader( "white", 0, 8 );
            self.mtprogressbar scaleOverTime( movetime, 288, 8 );
            
            self linkto( org );
            
            self.mtprogresstime = 0;
            while( self useButtonPressed() && ( self.mtprogresstime < movetime ) && isAlive( self ) )
            {
                self.mtprogresstime += 0.05;
                wait 0.05;
            }
            
            org delete();
            
            if ( self.mtprogresstime >= movetime )
            {           
                self thread actualmoveturret( barrel );
                breakout = true;
                break;
            }
            else
            {
                if ( isDefined( self.mtprogressbackground ) )
                    self.mtprogressbackground destroy();

                if ( isDefined( self.mtprogressbar ) ) 
                    self.mtprogressbar destroy();
            }
        }
        
        wait 0.05;
    }

    self.moveturret = undefined;
    
    if ( isDefined( self.moveturretnotice ) )
        self.moveturretnotice destroy();

    if ( isDefined( self.mtprogressbackground ) )
        self.mtprogressbackground destroy();

    if ( isDefined( self.mtprogressbar ) ) 
        self.mtprogressbar destroy();
}

actualmoveturret( barrel ) {
    self notify( "remove sentry" );

    wait 0.15;

    if ( isDefined( barrel ) )
        barrel delete();
    if ( isDefined( self.mg ) )
        self.mg delete();

    wait 0.15;

    self setWeaponSlotWeapon( "grenade", "stielhandgranate_mp" );
    self switchToWeapon( "stielhandgranate_mp" );

    wait 0.5;

    self thread sentry();
}

sentry_remove_on_death( barrel ) {    
    self endon( "remove sentry" );

    self waittill( "death" );
    self notify( "remove sentry" );

    if ( isDefined( barrel ) )
        barrel delete();
}

sentry_remove_on_spec( barrel ) {
    self endon( "remove sentry" );

    self waittill( "spawned" );
    self notify( "remove sentry" );

    if ( isDefined( barrel ) )
        barrel delete();
}

mg_remove( mg )
{
    self endon( "remove sentry" );

    self waittill( "death" );

    if ( isDefined( mg ) ) {
        mg delete();
        mg = undefined;
    }
}

mg_remove_on_disconnect( mg )
{
    self endon( "remove sentry" );

    self waittill( "disconnect" );

    if ( isDefined( mg ) ) {
        mg delete();
        mg = undefined;
    }
}

mg_remove_on_spec( mg )
{
    self endon( "remove sentry" );

    self waittill( "spawned" );

    if ( isDefined( mg ) ) {
        mg delete();
        mg = undefined;
    }
}

sentry_think( barrel )
{     
    self.mg = spawn( "script_model", barrel getOrigin() + ( 0, 0, 42 ) );
    self.mg setModel( "xmodel/mg42_bipod" );
    self.mg setContents( 1 );
    
    self thread mg_remove( self.mg );
    self thread mg_remove_on_disconnect( self.mg );
    self thread mg_remove_on_spec( self.mg );
    self thread sentry_hud( self.mg, self.pers[ "weapon" ] );
    self thread sentry_explode();
       
    self.mg.ammo = 50;

    if ( self.subclass == "combat" ) {
        self.mg.health = 500;
        self.mg.healthmax = 500;
    } else {
        self.mg.health = 1000;
        self.mg.healthmax = 1000;
    }

    self endon( "remove sentry" );
    
    while ( isAlive( self ) && isDefined( self.mg ) )
    {
        wait 0.03;
        
        self sentry_aim();
        self sentry_damage_detect();
    }
}

sentry_aim()
{
    if ( isDefined( self.mg.disabled ) )
        return;
        
    // do stuff here
    players = getEntArray( "player", "classname" );
    bestplayer = undefined;
    bestdist = level.fogdist - 250;
    if ( bestdist < 250 )
        bestdist = 250;

    for ( i = 0; i < players.size; i++ )
    {               
        if ( distance( self.mg.origin, players[ i ].origin ) < bestdist && players[ i ].pers[ "team" ] == "allies" && players[ i ].sessionstate == "playing" )
        {
            if ( isDefined( self.preferredtarget ) && self.preferredtarget == players[ i ] ) {
                bestplayer = players[ i ];
                break;
            }

            trace = bullettrace( self.mg.origin, players[ i ].origin + ( 0, 0, 60 ), true, players[ i ] );
            if ( trace[ "fraction" ] != 1 )
                continue;
                
            bestplayer = players[ i ];
            bestdist = distance( self.mg.origin, players[ i ].origin );
        }
    }
    
    if ( isDefined( bestplayer ) )
    {
        x = bestplayer maps\mp\gametypes\_zombie::getStance( true );
        trace = bullettrace( self.mg.origin, bestplayer.origin + ( 0, 0, x - 8 ), true, bestplayer );
        if ( trace[ "fraction" ] != 1 )
            return;
            
        self.mg.angles = vectorToAngles( vectorNormalize( ( bestplayer.origin + ( 0, 0, x - 20 ) ) - self.mg.origin ) );
        
        if ( !isDefined( self.mg.isfiring ) )
            self.mg thread sentry_fire( bestplayer, self, x );
    }
}

sentry_damage_detect()
{
    doHit = false;
    attackerweapon = "enfield_mp";
    players = getEntArray( "player", "classname" );
    attacker = undefined;
    for ( i = 0; i < players.size; i++ )
    {
        if ( distance( self.mg.origin, players[ i ].origin ) < 52 )
        {
            if ( players[ i ].pers[ "team" ] == "allies" && players[ i ].sessionstate == "playing" && players[ i ] meleeButtonPressed() && !isDefined( players[ i ].meleedown ) )
            {
                attacker = players[ i ];
                attacker thread meleedowntrack();
                attackerweapon = attacker getCurrentWeapon();
                doHit = true;
                break;
            }
            
            if ( players[ i ] == self )
            {
                if ( self meleeButtonPressed() && !isDefined( self.meleedown ) ) {
                    self thread meleedowntrack();

                    self.mg.health += 200;
                    if ( self.mg.health > self.mg.healthmax )
                        self.mg.health = self.mg.healthmax;
                }
            }
        }
    }
    
    if ( doHit )
    {
        damage = 0;
      
        switch ( attackerweapon ) {
            case "sten_mp":             damage = 35; break;
            case "colt_mp":         
            case "mk1britishfrag_mp":   damage = 50; break;
            case "enfield_mp":  
            case "springfield_mp":      damage = 150; break;
            case "bren_mp":             damage = 200; break;
        }

        if ( damage == 0 )
            return;

        self.mg playSound( "melee_hit" );
        attacker thread maps\mp\gametypes\_zombie::showhit();
        
        self.mg.health -= damage * attacker.damagemult;

        attacker iPrintLn( "You did ^1" + (int)( damage * attacker.damagemult ) + "^7 damage to that turret!" );
        self iPrintLn( attacker.name + "^7 did ^1" + (int)( damage * attacker.damagemult ) + " ^7damage to your turret!" );

        if ( self.mg.health < 0 )
            self.mg.health = 0;
            
        if ( self.mg.health == 0 )
            self thread sentry_disable();
    }
}   

meleedowntrack() {
    if ( !isDefined( self.meleedown ) )
        self.meleedown = true;

    while ( self meleeButtonPressed() )
        wait 0.05;

    currentWeapon = self getCurrentWeapon();

    waittime = 0.05;
    switch ( currentWeapon ) {
        case "sten_mp":
            waittime = 0.15;
            break;
        case "panzerfaust_mp":
            waittime = 0.5;
            break;
        case "mp40_mp":
            waittime = 0.6;
            break;
        case "bar_mp":
        case "bar_slow_mp":
        case "bren_mp":
        case "enfield_mp":
        case "fraggrenade_mp":
        case "kar98k_mp":
        case "kar98k_sniper_mp":
        case "luger_mp":
        case "m1carbine_mp":
        case "m1garand_mp":
        case "mk1britishfrag_mp":
        case "mosin_nagant_mp":
        case "mosin_nagant_sniper_mp":
        case "rgd-33russianfrag_mp":
        case "springfield_mp":
        case "stielhandgranate_mp":
            waittime = 0.65;
            break;
        case "colt_mp":
        case "thompson_mp":
        case "thompson_semi_mp":
            waittime = 0.7;
            break;
        case "fg42_mp":
        case "fg42_semi_mp":
        case "mp44_mp":
        case "mp44_semi_mp":
        case "ppsh_mp":
        case "ppsh_semi_mp":
            waittime = 0.75;
            break;
    }

    wait ( waittime );

    self.meleedown = undefined;
}

sentry_disable()
{
    self endon( "remove sentry" );

    if ( isDefined( self.mg.disabled ) )
        return;
        
    self.mg.disabled = true;
    
    while ( self.mg.health <= 0 )
    {
        playFx( level._effect[ "sentry_onfire" ], self.mg.origin + ( 0, 0, -8 ) );
        wait 0.3;
    }
    
    self.mg.disabled = undefined;
}

sentry_explode()
{
    self waittill( "remove sentry" );
    
    if ( !isDefined( self.moveturret ) )
        playFx( level._effect[ "sentry_explode" ], self.mg.origin );
}

sentry_fire( target, owner, x )
{
    if ( self.ammo == 0 )
    {
        if ( !isDefined( self.reloading ) )
            self thread sentry_reload( owner );
            
        return;
    }
        
    self.isfiring = true;
    
    // hurt with mg42_bipod_stand_mp :)
    stance = target maps\mp\gametypes\_zombie::getStance();

    self playSound( "weap_bren_fire" );
    playFxOnTag( level._effect[ "sentry_fire" ], self, "tag_flash" );
    
    trace = bullettrace( self.origin, target.origin + ( 0, 0, 16 ), false, undefined );
    trace2 = bullettrace( self.origin, target.origin + ( 0, 0, 40 ), false, undefined );
    trace3 = bullettrace( self.origin, target.origin + ( 0, 0, 60 ), false, undefined );

    hitloc = "torso_upper";
    if ( trace3[ "fraction" ] != 1 && trace2[ "fraction" ] == 1 )
        hitloc = "torso_lower";
    if ( trace3[ "fraction" ] != 1 && trace2[ "fraction" ] != 1 && trace[ "fraction" ] == 1 )
    {
        s = "left";
        if ( randomInt( 100 ) > 50 )
            s = "right";
            
        hitloc = s + "_leg_upper";
    }
    
    dist = distance( target.origin, self.origin );
    maxdist = 1024;
    distanceModifier = ( (maxdist/2) - dist ) / maxdist + 1;
    if ( dist > maxdist )
        distanceModifier = 0.5;

    damagemodifier = 1;
    if ( isDefined( owner.preferredtarget ) && owner.preferredtarget == target && self.subclass != "combat" )
        damagemodifier = 2;

    target maps\mp\gametypes\zombies::Callback_PlayerDamage( owner, owner, 7 * damagemodifier * distanceModifier, 0, "MOD_RIFLE_BULLET", "mg42_bipod_stand_mp", target.origin + ( 0, 0, x - 20 ), vectornormalize( target.origin - self.origin ), hitloc );

    wait 0.2;
    
    self.ammo--;
    
    // every 10th shot has a chance of lowering the health by 1-3 points
    if ( self.ammo % 10 == 0 && randomInt( 100 ) > 50 )
        self.health -= maps\mp\gametypes\_zombie::_randomIntRange( 1, 5 );
        
    self.isfiring = undefined;
}

sentry_reload( owner )
{
    self.reloading = true;
    
    self.timer = 11;
    self.timeup = 0;
    
    while ( self.timer > 0 )
    {
        wait 0.1;
        self.timer -= 0.1;
        self.timeup += 0.1;
    }

    self.timer = undefined;
    self.timeup = undefined;
    self.reloading = undefined;
    
    self.ammo = 50;
}

sentry_hud( mg, type )
{
    self endon( "disconnect" );
    
    self.sentry_hud_back = newClientHudElem( self );
    self.sentry_hud_back.x = 550;
    self.sentry_hud_back.y = 416;
    self.sentry_hud_back.alignx = "right";
    self.sentry_hud_back.aligny = "middle";
    self.sentry_hud_back.alpha = 0.7;
    self.sentry_hud_back setShader( "gfx/hud/hud@health_back.dds", 116, 10 );
    self.sentry_hud_back.sort = 10;
    
    self.sentry_hud_front = newClientHudElem( self );
    self.sentry_hud_front.x = 548;
    self.sentry_hud_front.y = 416;
    self.sentry_hud_front.alignx = "right";
    self.sentry_hud_front.aligny = "middle";
    self.sentry_hud_front.alpha = 0.8;
    self.sentry_hud_front setShader( "gfx/hud/hud@health_bar.dds", 112, 8 );
    self.sentry_hud_front.sort = 20;
    
    self.sentry_hud_notice = newClientHudElem( self );
    self.sentry_hud_notice.x = 492;
    self.sentry_hud_notice.y = 416;
    self.sentry_hud_notice.alignx = "center";
    self.sentry_hud_notice.aligny = "middle";
    self.sentry_hud_notice.alpha = 1;
    self.sentry_hud_notice.sort = 25;
    self.sentry_hud_notice.fontscale = 0.7;
    self.sentry_hud_notice.label = &"Sentry status: ";
    
    self.sentry_hud_health_back = newClientHudElem( self );
    self.sentry_hud_health_back.x = 550;
    self.sentry_hud_health_back.y = 404;
    self.sentry_hud_health_back.alignx = "right";
    self.sentry_hud_health_back.aligny = "middle";
    self.sentry_hud_health_back.alpha = 0.7;
    self.sentry_hud_health_back setShader( "gfx/hud/hud@health_back.dds", 116, 10 );
    self.sentry_hud_health_back.sort = 10;
    
    self.sentry_hud_health_front = newClientHudElem( self );
    self.sentry_hud_health_front.x = 548;
    self.sentry_hud_health_front.y = 404;
    self.sentry_hud_health_front.alignx = "right";
    self.sentry_hud_health_front.aligny = "middle";
    self.sentry_hud_health_front.alpha = 0.8;
    self.sentry_hud_health_front.color = ( 0, 0, 1 );
    self.sentry_hud_health_front setShader( "gfx/hud/hud@health_bar.dds", 112, 8 );
    self.sentry_hud_health_front.sort = 20;
    
    self.sentry_hud_health = newClientHudElem( self );
    self.sentry_hud_health.x = 492;
    self.sentry_hud_health.y = 404;
    self.sentry_hud_health.alignx = "center";
    self.sentry_hud_health.aligny = "middle";
    self.sentry_hud_health.alpha = 1;
    self.sentry_hud_health.sort = 25;
    self.sentry_hud_health.fontscale = 0.7;
    self.sentry_hud_health.label = &"Sentry health: ";
    
    self.sentry_hud_kills = newClientHudElem( self );
    self.sentry_hud_kills.x = 492;
    self.sentry_hud_kills.y = 392;
    self.sentry_hud_kills.alignx = "center";
    self.sentry_hud_kills.aligny = "middle";
    self.sentry_hud_kills.alpha = 1;
    self.sentry_hud_kills.sort = 25;
    self.sentry_hud_kills.fontscale = 0.7;
    self.sentry_hud_kills.label = &"Sentry kills: ";
    
    while ( isAlive( self ) && isDefined( self.mg ) )
    {       
        if ( isDefined( mg.isfiring ) )
        {
            self.sentry_hud_front.alpha = 0;
            self.sentry_hud_notice.color = ( 0, 1, 0 );
            self.sentry_hud_notice setText( &"Firing" );
        }        
        else if ( isDefined( mg.reloading ) )
        {
            self.sentry_hud_front.alpha = 1;
            self.sentry_hud_front.color = ( 1, 0, 0 );
            self.sentry_hud_front setShader( "white", mg.timeup * 10.2, 8 );
            self.sentry_hud_notice.color = ( 1, 1, 1 );
            self.sentry_hud_notice setText( &"Reloading" );
        }        
        else if ( isDefined( mg.disabled ) )
        {
            self.sentry_hud_front.alpha = 0;
            self.sentry_hud_notice.color = ( 1, 0, 0 );
            self.sentry_hud_notice setText( &"Disabled" );
        }
        else
        {
            self.sentry_hud_front.alpha = 0;
            self.sentry_hud_notice.color = ( 1, 1, 1 );
            self.sentry_hud_notice setText( &"Idle" );
        }            
        
        self.sentry_hud_health setValue( self.mg.health );
        if ( self.subclass == "combat" ) {
            self.sentry_hud_health_front setShader( "white", ( self.mg.health / 5 ) * 1.12, 8 );
            self.sentry_hud_kills setValue( self.stats[ "totalCombatSentryKills" ] + self.stats[ "combatSentryKills" ] );
        }
        else {
            self.sentry_hud_health_front setShader( "white", ( self.mg.health / 10 ) * 1.12, 8 );
            self.sentry_hud_kills setValue( self.stats[ "totalSentryKills" ] + self.stats[ "sentryKills" ] );
        }
        
        wait 0.1;
    }
    
    if ( isDefined( self.sentry_hud_back ) )            self.sentry_hud_back destroy();
    if ( isDefined( self.sentry_hud_front ) )           self.sentry_hud_front destroy();
    if ( isDefined( self.sentry_hud_notice ) )          self.sentry_hud_notice destroy();
    if ( isDefined( self.sentry_hud_health_back ) )     self.sentry_hud_health_back destroy();
    if ( isDefined( self.sentry_hud_health_front ) )    self.sentry_hud_health_front destroy();
    if ( isDefined( self.sentry_hud_health ) )          self.sentry_hud_health destroy();
    if ( isDefined( self.sentry_hud_kills ) )           self.sentry_hud_kills destroy();
}

sniper() {
    self.invis_hud_back = newClientHudElem( self );
    self.invis_hud_back.x = 550;
    self.invis_hud_back.y = 416;
    self.invis_hud_back.alignx = "right";
    self.invis_hud_back.aligny = "middle";
    self.invis_hud_back.alpha = 0.7;
    self.invis_hud_back setShader( "gfx/hud/hud@health_back.dds", 116, 10 );
    self.invis_hud_back.sort = 10;
    
    self.invis_hud_front = newClientHudElem( self );
    self.invis_hud_front.x = 548;
    self.invis_hud_front.y = 416;
    self.invis_hud_front.alignx = "right";
    self.invis_hud_front.aligny = "middle";
    self.invis_hud_front.alpha = 0.8;
    self.invis_hud_front setShader( "gfx/hud/hud@health_bar.dds", 112, 8 );
    self.invis_hud_front.sort = 20;
    self.invis_hud_front.color = ( 0, 0, 1 );
    
    self.invis_hud_notice = newClientHudElem( self );
    self.invis_hud_notice.x = 492;
    self.invis_hud_notice.y = 416;
    self.invis_hud_notice.alignx = "center";
    self.invis_hud_notice.aligny = "middle";
    self.invis_hud_notice.alpha = 1;
    self.invis_hud_notice.sort = 25;
    self.invis_hud_notice.fontscale = 0.7;
    self.invis_hud_notice.label = &"Invisibility status: ";

    self.hiddenhud = newClientHudElem( self );
    self.hiddenhud.x = 0;
    self.hiddenhud.y = 0;
    self.hiddenhud.color = ( 0, 0, 1 );
    self.hiddenhud.alpha = 0;
    self.hiddenhud setShader( "white", 640, 480 );
    self.hiddenhud.sort = 9999;

    self.invisible = false;

    self.invis_hud_notice setText( &"Ready" );

    if ( self.subclass == "combat" )
        self sniper_combat();
    else
        self sniper_support();

    self iPrintLn( "You are now visible!" );

    self.hiddenhud.alpha = 0;
    self detachall();
    self maps\mp\gametypes\_skins::setAllModels();

    self.invisible = false;

    if ( isDefined( self.hiddenhud ) )
        self.hiddenhud destroy();

    if ( isDefined( self.invis_hud_back ) )     
        self.invis_hud_back destroy();

    if ( isDefined( self.invis_hud_front ) )    
        self.invis_hud_front destroy();

    if ( isDefined( self.invis_hud_notice ) )   
        self.invis_hud_notice destroy();
}

sniper_combat() {
    self endon( "death" );
    self endon( "spawned" );
    self endon( "disconnect" );

    reloadtime = 10;
    reloading = false;
    timeup = 0;

    self iPrintLn( "Double tap [{+activate}] to go invisible!" );

    while ( isAlive( self ) && !level.lasthunter ) {
        wait 0.05;

        if ( timeup == ( reloadtime * 20 ) && reloading ) {
            reloading = false;
            timeup = 0;

            self iPrintLn( "Double tap [{+activate}] to go invisible!" );
            self.invis_hud_notice setText( &"Ready" );
            self.invis_hud_front.color = ( 0, 0, 1 );
        }

        if ( reloading ) {
            timeup++;
            self.invis_hud_front setShader( "white", (float)( (float)timeup / 20 ) * 11.2, 8 );
        }

        if ( self useButtonPressed() && !reloading )
        {
            catch_next = false;
            lol = false;

            for ( i = 0; i <= 0.30; i += 0.02 )
            {
                if ( catch_next && self useButtonPressed() )
                {
                    lol = true;
                    break;
                }
                else if ( !( self useButtonPressed() ) )
                    catch_next = true;

                wait 0.03;
            }
            
            if ( lol ) {
                timeup = ( reloadtime * 20 ) - ( self sniper_goinvisible( reloadtime, false ) );

                self.invis_hud_front.color = ( 1, 0, 0 );
                self.invis_hud_notice setText( &"Cooldown" );

                donetime = gettime();
                while ( ( gettime() - donetime ) < 5000 )
                    wait 0.05;

                reloading = true;
                self.invis_hud_notice setText( &"Recharging" );
            }
        }
    }
}

sniper_support() {
    self.hiddenhud = newClientHudElem( self );
    self.hiddenhud.x = 0;
    self.hiddenhud.y = 0;
    self.hiddenhud.color = ( 0, 0, 1 );
    self.hiddenhud.alpha = 0;
    self.hiddenhud setShader( "white", 640, 480 );
    self.hiddenhud.sort = 9999;

    self.invisible = false;

    self iPrintLn( "Stand still for 5 seconds to go invisible!" );

    lastorigin = self.origin;
    stoppedtime = gettime();
    moving = true;
    timehidden = 0;

    reloadtime = 55;
    reloading = false;
    timeup = 0;

    self endon( "death" );
    self endon( "spawned" );
    self endon( "disconnect" );

    while ( isAlive( self ) && !level.lasthunter ) {
        lastorigin = self.origin;

        wait 0.05;

        if ( ( timeup == reloadtime * 20 ) && reloading ) {
            reloading = false;
            timeup = 0;

            self iPrintLn( "Stand still for 5 seconds to go invisible!" );
            self.invis_hud_notice setText( &"Ready" );
            self.invis_hud_front.color = ( 0, 0, 1 );
        }

        if ( reloading ) {
            timeup++; 
            self.invis_hud_front setShader( "white", (float)( ( (float)timeup / 110 ) ) * 11.2, 8 );
        }

        // moving
        if ( self.origin != lastorigin ) {
            moving = true;
            stoppedtime = gettime();
            continue;
        }

        // fired or bashed
        if ( self attackbuttonpressed() || self meleebuttonpressed() ) {
            stoppedtime = gettime();
            continue;
        }

        // stopped moving
        if ( self isOnGround() && self.origin == lastorigin && moving ) {
            stoppedtime = gettime();
            moving = false;
        }

        // hasn't moved in 5 seconds
        if ( gettime() - stoppedtime > 5000 && !self.invisible && !reloading ) {
            timeup = ( reloadtime * 20 ) - ( self sniper_goinvisible( reloadtime, true ) );

            self.invis_hud_front.color = ( 1, 0, 0 );
            self.invis_hud_notice setText( &"Cooldown" );

            donetime = gettime();
            while ( ( gettime() - donetime ) < 5000 )
                wait 0.05;

            stoppedtime = gettime();
            reloading = true;
            self.invis_hud_notice setText( &"Recharging" );
        }
    }
}

sniper_goinvisible( time, trackmoving ) {
    if ( !isDefined( time ) )
        time = 25;

    if ( !isDefined( trackmoving ) )
        trackmoving = true;

    self iPrintLn( "You are now ^5invisible^7!" );
    self.invisible = true;

    self.invis_hud_notice setText( &"Invisible" );

    self.hiddenhud.alpha = 0.2;
    self detachall();
    self setModel( "" );

    lastorigin = self.origin;
    fired = false;

    timedown = time * 20;
    timeup = 0;

    self endon( "death" );
    self endon( "spawned" );
    self endon( "disconnect" );

    amount = (float)( (float)112 / (float)( time * 20 ) );
    clicksaway = 0;
    if ( amount < 1 && amount > 0 ) {
        clicksaway = (float)( (float)1 / amount );
    }

    while ( true ) {
        lastorigin = self.origin;

        wait 0.05;

        timeup++;
        timedown--;

        if ( self attackButtonPressed() || self meleeButtonPressed() ) {
            fired = true;
            break;
        }

        if ( ( trackmoving && self.origin != lastorigin ) || timedown == 0 ) {
            break;
        }

        if ( self useButtonPressed() )
        {
            catch_next = false;
            lol = false;

            for ( i = 0; i <= 0.30; i += 0.02 )
            {
                if ( catch_next && self useButtonPressed() )
                {
                    lol = true;
                    break;
                }
                else if ( !( self useButtonPressed() ) )
                    catch_next = true;

                wait 0.03;
            }
            
            if ( lol ) {
                break;
            }
        }

        if ( (int)( amount * timedown ) > 0 )
            self.invis_hud_front setShader( "white", (float)( amount * timedown ), 8 );
    }

    if ( timedown == 0 ) {
        self.invis_hud_front setShader( "white", 0, 8 );
    }

    if ( fired )
        wait 0.15;

    self iPrintLn( "You are now visible!" );
    self.invisible = false;

    self.hiddenhud.alpha = 0;
    self detachall();
    self maps\mp\gametypes\_skins::setAllModels();

    return timeup;
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
    
    while ( isAlive( self ) && self.ispoisoned )
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

    self.onfire = true;
    
    if ( self.pers[ "team" ] == "axis" )
        self thread firedeath( dude );
    
    while ( self.onfire )
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
    self iPrintLnBold( "You are on ^1fire^7!" );
    
    while ( self.onfire )
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

