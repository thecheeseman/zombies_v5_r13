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
    level.callbackStartGameType =       ::Callback_StartGameType;
    level.callbackPlayerConnect =       ::Callback_PlayerConnect;
    level.callbackPlayerDisconnect =    ::Callback_PlayerDisconnect;
    level.callbackPlayerDamage =        ::Callback_PlayerDamage;
    level.callbackPlayerKilled =        ::Callback_PlayerKilled;

    level.callbackSpawnPlayer =         ::spawnPlayer;
    level.callbackSpawnSpectator =      ::spawnSpectator;
    level.callbackSpawnIntermission =   ::spawnIntermission;

    maps\mp\gametypes\_callbacksetup::SetupCallbacks();

    zombies\mod::main();
}

Callback_StartGameType()
{
    zombies\_teams::precache();
    zombies\_teams::scoreboard();
    zombies\_teams::initGlobalCvars();
    zombies\_teams::restrictPlacedWeapons();

    setClientNameMode( "auto_change" );
    
    thread zombies\mod::startGame();
    
    if ( level.debug ) thread addBotClients();
}

Callback_PlayerConnect()
{
    if ( self isBot() ) {
        self [[ level.bot_connect ]]();
        return;
    }

    self.statusicon = "gfx/hud/hud@status_connecting.tga";
    self waittill("begin");
    self.statusicon = "";

    iprintln( self.name + "^7 joined the game." );
/*
    self.loadingstats = true;

    self.swait = newClientHudElem( self );
    self.swait setShader( "black", 640, 480 );
*/
    self thread zombies\mod::onConnect();
/*
    while ( self.loadingstats )
        wait frame();

    self.swait destroy();
*/
    if ( game[ "state" ] == "intermission" ) {
        self spawnIntermission();
        return;
    }
    
    if ( game[ "state" ] == "endgame" ) {
        self.pers[ "team" ] = "spectator";
        self spawnSpectator();
        self.org = spawn( "script_origin", self.origin );
        self linkto( self.org );
        self setClientCvar( "g_scriptMainMenu", "main" );
        return;
    }

    self setClientCvar( "g_scriptMainMenu", game[ "menu_team" ] );
    self setClientCvar( "scr_showweapontab", "0" );

    self openMenu( game[ "menu_team" ] );

    self.pers[ "team" ] = "spectator";
    self.sessionteam = "spectator";

    spawnSpectator();

    self thread zombies\menu::playerHandler();
 }

Callback_PlayerDisconnect()
{
    if ( self isBot() ) {
        self [[ level.bot_disconnect ]]();
        return;
    }

    iprintln( self.name + "^7 left the game." );
    
    self thread zombies\mod::onDisconnect();
}

Callback_PlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc)
{
    if ( self isBot() ) {
        self [[ level.bot_damage ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc );
        return;
    }

    if(self.sessionteam == "spectator")
        return;
        
    if ( isPlayer( eAttacker ) && sWeapon == "fraggrenade_mp" ) {
        self thread zombies\mod::beFlashed( iDamage );
        return;
    }
        
    if ( isPlayer( eAttacker ) && eAttacker != self && eAttacker.pers[ "team" ] == self.pers[ "team" ] ) {
        if ( sWeapon == "stielhandgranate_mp" && eAttacker.class == "medic" && eAttacker.subclass == "none" ) {
            if ( self.health < self.maxhealth ) {
                eAttacker iPrintLn( "You healed " + self.name + "^7 for ^225^7 HP!" );
                self.health += 25;
                if ( self.health > self.maxhealth )
                    self.health = self.maxhealth;

                eAttacker.stats[ "hpHealed" ] += 25;
                eAttacker.xp += level.xpvalues[ "medic_heal" ];
                eAttacker.score += level.xpvalues[ "medic_heal" ];
                eAttacker iPrintLn( "^3+" + level.xpvalues[ "medic_heal" ] + " XP!" );
                eAttacker thread zombies\ranks::checkRank();
            }
        }
        return;
    }

    if ( isPlayer( eInflictor ) && eInflictor != self && eInflictor.pers[ "team" ] == self.pers[ "team" ] )
        return;

    if ( isPlayer( eAttacker ) && eAttacker == self && self.pers[ "team" ] == "axis" && level.lasthunter && ( sWeapon != "mosin_nagant_sniper_mp" && sWeapon != "rgd-33russianfrag_mp" && sWeapon != "panzerfaust_mp" ) )
        return;

    if ( sMeansOfDeath == "MOD_FALLING" && self.iszombie && self.zombietype == "jumper" ) {
        if ( !level.cvars[ "JUMPER_FALLDAMAGE" ] )
            return;

        iDamage *= 0.25;
    }

    if ( isPlayer( eAttacker ) && eAttacker.sessionteam == "spectator" && ( sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" ) )
        return;

    if ( isPlayer( eAttacker ) && eAttacker.pers[ "team" ] == "allies" && sWeapon == "stielhandgranate_mp" )
        return;

    if(!isDefined(vDir))
        iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

    if ( isPlayer( self ) && self.rocketattack )
        iDFlags |= level.iDFLAGS_NO_KNOCKBACK;
    
    if ( isPlayer( eAttacker ) && eAttacker.pers[ "team" ] == "axis" && level.lasthunter && sWeapon == "colt_mp" && sMeansOfDeath == "MOD_MELEE" )
        iDamage *= 4;
        
    if(iDamage < 1)
        iDamage = 1;
        
    if ( sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE" ) {
        switch ( sWeapon ) {
            case "m1carbine_mp":
                iDamage *= 3;
                break;
            case "kar98k_mp":
            case "mp40_mp":
            case "thompson_mp":
                iDamage *= 2;
                break;
            case "kar98k_sniper_mp":
            case "springfield_mp":
            case "ppsh_mp":
            case "ppsh_semi_mp":
                iDamage = self.health + 10;
                break;
        }
    }

    if ( isPlayer( eAttacker ) && eAttacker != self ) {
        if ( eAttacker.pers[ "team" ] == "axis" && sWeapon == "mp44_mp" && 
            ( sHitLoc != "right_hand" && sHitLoc != "left_hand" && sHitLoc != "right_foot" && sHitLoc != "left_foot" ) ) {
            iDamage = 115;
        }

        if ( eAttacker.pers[ "team" ] == "axis" && sWeapon == "bar_mp" && 
            ( sHitLoc != "right_hand" && sHitLoc != "left_hand" && sHitLoc != "right_foot" && sHitLoc != "left_foot" ) ) {
            iDamage = 100;
        }

        if ( eAttacker.pers[ "team" ] == "allies" && sWeapon == "springfield_mp" )
            iDamage /= 4;
            
        if ( eAttacker.pers[ "team" ] == "axis" && eAttacker.damagearmor > 0 )
            iDamage += ( iDamage * eAttacker.damagearmor );
            
        if ( eAttacker.pers[ "team" ] == "axis" && self.resilience > 0 && sHitLoc != "head" )   
            iDamage -= ( iDamage * self.resilience );
        
        if ( eAttacker.pers[ "team" ] == "allies" )
            iDamage *= eAttacker.damagemult;
        /*  
        if ( eAttacker.pers[ "team" ] == "allies" && self.bodyarmor > 0 && ( sMeansOfDeath != "MOD_GRENADE" && sMeansOfDeath != "MOD_GRENADE_SPLASH" && sMeansOfDeath != "MOD_EXPLOSION" && sMeansOfDeath != "MOD_EXPLOSION_SPLASH" ) )
            iDamage -= ( iDamage * self.bodyarmor );
            
        if ( eAttacker.pers[ "team" ] == "allies" && self.exploarmor > 0 && ( sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSION" || sMeansOfDeath == "MOD_EXPLOSION_SPLASH" ) )
            iDamage -= ( iDamage * self.exploarmor );
        */
            
        if ( eAttacker.pers[ "team" ] == "axis" && level.lasthunter && sWeapon == "mosin_nagant_mp" )
            iDamage = self.health;
            
        if ( eAttacker.pers[ "team" ] == "axis" && level.lasthunter && sWeapon == "mosin_nagant_sniper_mp" && sMeansOfDeath == "MOD_MELEE" )
            iDamage = self.health;

        if ( eAttacker.pers[ "team" ] == "axis" && eAttacker.class == "sniper" && eAttacker.invisible )
            iDamage *= 2;
    }
    
    if ( isPlayer( eAttacker ) && eAttacker.pers[ "team" ] == "axis" && sMeansOfDeath == "MOD_MELEE" )
        iDamage /= 0.50;
    
    orgdamage = iDamage;
    if ( isPlayer( eAttacker ) && self.pers[ "team" ] == "axis" ) {
        if ( self.bodyarmor > 0 && ( sMeansOfDeath != "MOD_GRENADE" && sMeansOfDeath != "MOD_GRENADE_SPLASH" && sMeansOfDeath != "MOD_EXPLOSION" && sMeansOfDeath != "MOD_EXPLOSION_SPLASH" ) ) {
            if ( iDamage > self.bodyarmor ) {
                passthru = iDamage - self.bodyarmor;
                self.bodyarmor = 0;
                
                iDamage = passthru;
            } else {
                self.bodyarmor -= iDamage;
                iDamage = 0;
            }
        }
        
        if ( self.exploarmor > 0 && ( sMeansOfDeath == "MOD_GRENADE" || sMeansOfDeath == "MOD_GRENADE_SPLASH" || sMeansOfDeath == "MOD_EXPLOSION" || sMeansOfDeath == "MOD_EXPLOSION_SPLASH" ) ) {
            if ( iDamage > self.exploarmor ) {
                passthru = iDamage - self.exploarmor;
                self.exploarmor = 0;
                
                iDamage = passthru;
            } else {
                self.exploarmor -= iDamage;
                iDamage = 0;
            }
        }
    }
    
    if ( isPlayer( eAttacker ) && eAttacker == self && self.pers[ "team" ] == "axis" && level.lasthunter && ( sWeapon == "mosin_nagant_sniper_mp" || sWeapon == "rgd-33russianfrag_mp" || sWeapon == "panzerfaust_mp" ) )
        self.health += iDamage;

    self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc);
    
    self thread zombies\mod::onDamage( eInflictor, eAttacker, orgdamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc );
}

Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc)
{
    if ( self isBot() ) {
        self [[ level.bot_killed ]]( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc );
        return;
    }
    
    self endon("spawned");
    
    if(self.sessionteam == "spectator")
        return;

    if(sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE")
        sMeansOfDeath = "MOD_HEAD_SHOT";
        
    obituary(self, attacker, sWeapon, sMeansOfDeath);
    
    self.sessionstate = "dead";
    self.statusicon = "gfx/hud/hud@status_dead.tga"; 
    self.headicon = "";

    doKillcam = true;
    attackerNum = -1;
    if(isPlayer(attacker))
    {
        if(attacker == self)
        {
            doKillcam = false;
                
            attackerNum = self getEntityNumber();
            
            if(isdefined(attacker.reflectdamage))
                clientAnnouncement(attacker, &"MPSCRIPT_FRIENDLY_FIRE_WILL_NOT"); 
        }
        else
        {
            attackerNum = attacker getEntityNumber();

            teamscore = getTeamScore(attacker.pers["team"]);
            teamscore++;
            setTeamScore(attacker.pers["team"], teamscore);
        }

        lpattacknum = attacker getEntityNumber();
        lpattackname = attacker.name;
        lpattackerteam = attacker.pers["team"];
    }
    else
    {
        doKillcam = false;
    }

    if(level.mapended)
        return;
        
    if ( isPlayer( attacker ) )
        level.lastKiller = attacker;
    
    if ( sMeansOfDeath == "MOD_HEAD_SHOT" && self.iszombie )
    {
        self detach( self.headmodel , "" );
        playfxontag( level._effect[ "fleshhit" ], self, "Bip01 Head" );
        playfxontag( level._effect[ "fleshhit2" ], self, "Bip01 Neck" );
    }
        
    self thread zombies\mod::onDeath( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc );
    
    body = self cloneplayer();

    delay = 2;
    wait delay;

    if ( !level.mapended )
    {
        if(doKillcam)
            self thread killcam(attackerNum, delay);
        else
            self thread respawn();
    }
}

spawnPlayer()
{
    self notify("spawned");
    self notify("end_respawn");
    
    resettimeout();

    self.sessionteam = self.pers["team"];
    self.sessionstate = "playing";
    self.spectatorclient = -1;
    self.archivetime = 0;
    self.reflectdamage = undefined;
    
    if ( self.pers[ "team" ] == "allies" )
    {
        spawnpoints = getentarray( "mp_teamdeathmatch_spawn", "classname" );
        if ( getCvar( "mapname" ) == "toybox_bloodbath" )
            spawnpoints = getentarray( "mp_deathmatch_spawn", "classname" );
            
        spawnpoint = zombies\spawnlogic::getSpawnpoint_NearTeam(spawnpoints);
    }
    else if ( self.pers[ "team" ] == "axis" )
    {
        spawnpoints = getentarray( "mp_deathmatch_spawn", "classname" );
        spawnpoint = zombies\spawnlogic::getSpawnpoint_Random(spawnpoints);
    }
    
    if(isdefined(spawnpoint))
        self spawn(spawnpoint.origin, spawnpoint.angles);
    else
        maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");

    self.statusicon = "";
    self.maxhealth = 100;
    self.health = self.maxhealth;
    
    zombies\_teams::loadout();
    
    self giveWeapon(self.pers["weapon"]);
    self giveMaxAmmo(self.pers["weapon"]);
    self setSpawnWeapon(self.pers["weapon"]);
    
    if(self.pers["team"] == "allies")
        self setClientCvar("cg_objectiveText", &"");
    else if(self.pers["team"] == "axis")
        self setClientCvar("cg_objectiveText", &"");

    self thread zombies\mod::spawnPlayer();
}

spawnSpectator(origin, angles)
{
    self notify("spawned");
    self notify("end_respawn");

    resettimeout();

    self.sessionstate = "spectator";
    self.spectatorclient = -1;
    self.archivetime = 0;
    self.reflectdamage = undefined;

    if(self.pers["team"] == "spectator")
        self.statusicon = "";
    
    if(isdefined(origin) && isdefined(angles))
        self spawn(origin, angles);
    else
    {
        if ( getCvar( "mapname" ) != "toybox_bloodbath" )
            spawnpointname = "mp_teamdeathmatch_intermission";
        else
            spawnpointname = "mp_deathmatch_intermission";
            
        spawnpoints = getentarray(spawnpointname, "classname");
        spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
    
        if(isdefined(spawnpoint))
            self spawn(spawnpoint.origin, spawnpoint.angles);
        else
            maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
    }
    
    self thread zombies\mod::spawnSpectator();
}

spawnIntermission()
{
    self notify("spawned");
    self notify("end_respawn");

    resettimeout();

    self.sessionstate = "intermission";
    self.spectatorclient = -1;
    self.archivetime = 0;
    self.reflectdamage = undefined;

    if ( getCvar( "mapname" ) != "toybox_bloodbath" )
        spawnpointname = "mp_teamdeathmatch_intermission";
    else
        spawnpointname = "mp_deathmatch_intermission";
        
    spawnpoints = getentarray(spawnpointname, "classname");
    spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
    
    if(isdefined(spawnpoint))
        self spawn(spawnpoint.origin, spawnpoint.angles);
    else
        maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
        
    self thread zombies\mod::spawnIntermission();
}

respawn()
{
    if(!isdefined(self.pers["weapon"]))
        return;

    self endon("end_respawn");
    
    if(getcvarint("scr_forcerespawn") > 0)
    {
        self thread waitForceRespawnTime();
        self thread waitRespawnButton();
        self waittill("respawn");
    }
    else
    {
        self thread waitRespawnButton();
        self waittill("respawn");
    }
    
    self thread spawnPlayer();
}

waitForceRespawnTime()
{
    self endon("end_respawn");
    self endon("respawn");
    
    wait getcvarint("scr_forcerespawn");
    self notify("respawn");
}

waitRespawnButton()
{
    self endon("end_respawn");
    self endon("respawn");
    
    wait 0;

    self.respawntext = newClientHudElem(self);
    self.respawntext.alignX = "center";
    self.respawntext.alignY = "middle";
    self.respawntext.x = 320;
    self.respawntext.y = 70;
    self.respawntext.archived = false;
    self.respawntext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

    thread removeRespawnText();
    thread waitRemoveRespawnText("end_respawn");
    thread waitRemoveRespawnText("respawn");

    while(self useButtonPressed() != true)
        wait .05;
    
    self notify("remove_respawntext");

    self notify("respawn"); 
}

removeRespawnText()
{
    self waittill("remove_respawntext");

    if(isdefined(self.respawntext))
        self.respawntext destroy();
}

waitRemoveRespawnText(message)
{
    self endon("remove_respawntext");

    self waittill(message);
    self notify("remove_respawntext");
}

killcam(attackerNum, delay)
{
    self endon("spawned");

    if(attackerNum < 0)
        return;

    self.sessionstate = "spectator";
    self.spectatorclient = attackerNum;
    self.archivetime = delay + 7;

    wait 0.05;

    if(self.archivetime <= delay)
    {
        self.spectatorclient = -1;
        self.archivetime = 0;
        self.sessionstate = "dead";
    
        self thread respawn();
        return;
    }

    if(!isdefined(self.kc_topbar))
    {
        self.kc_topbar = newClientHudElem(self);
        self.kc_topbar.archived = false;
        self.kc_topbar.x = 0;
        self.kc_topbar.y = 0;
        self.kc_topbar.alpha = 0.5;
        self.kc_topbar setShader("black", 640, 112);
    }

    if(!isdefined(self.kc_bottombar))
    {
        self.kc_bottombar = newClientHudElem(self);
        self.kc_bottombar.archived = false;
        self.kc_bottombar.x = 0;
        self.kc_bottombar.y = 368;
        self.kc_bottombar.alpha = 0.5;
        self.kc_bottombar setShader("black", 640, 112);
    }

    if(!isdefined(self.kc_title))
    {
        self.kc_title = newClientHudElem(self);
        self.kc_title.archived = false;
        self.kc_title.x = 320;
        self.kc_title.y = 40;
        self.kc_title.alignX = "center";
        self.kc_title.alignY = "middle";
        self.kc_title.sort = 1;
        self.kc_title.fontScale = 3.5;
    }
    self.kc_title setText(&"^1Zombi^7cam");

    if(!isdefined(self.kc_skiptext))
    {
        self.kc_skiptext = newClientHudElem(self);
        self.kc_skiptext.archived = false;
        self.kc_skiptext.x = 320;
        self.kc_skiptext.y = 70;
        self.kc_skiptext.alignX = "center";
        self.kc_skiptext.alignY = "middle";
        self.kc_skiptext.sort = 1; 
    }
    self.kc_skiptext setText(&"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN");

    if(!isdefined(self.kc_timer))
    {
        self.kc_timer = newClientHudElem(self);
        self.kc_timer.archived = false;
        self.kc_timer.x = 320;
        self.kc_timer.y = 428;
        self.kc_timer.alignX = "center";
        self.kc_timer.alignY = "middle";
        self.kc_timer.fontScale = 3.5;
        self.kc_timer.sort = 1;
    }
    self.kc_timer setTenthsTimer(self.archivetime - delay);

    self thread spawnedKillcamCleanup();
    self thread waitSkipKillcamButton();
    self thread waitKillcamTime();
    self waittill("end_killcam");

    self removeKillcamElements();

    self.spectatorclient = -1;
    self.archivetime = 0;
    self.sessionstate = "dead";

    self thread respawn();
}

waitKillcamTime()
{
    self endon("end_killcam");
    
    wait (self.archivetime - 0.05);
    self notify("end_killcam");
}

waitSkipKillcamButton()
{
    self endon("end_killcam");
    
    while(self useButtonPressed())
        wait .05;

    while(!(self useButtonPressed()))
        wait .05;
    
    self notify("end_killcam"); 
}

removeKillcamElements()
{
    if(isdefined(self.kc_topbar))
        self.kc_topbar destroy();
    if(isdefined(self.kc_bottombar))
        self.kc_bottombar destroy();
    if(isdefined(self.kc_title))
        self.kc_title destroy();
    if(isdefined(self.kc_skiptext))
        self.kc_skiptext destroy();
    if(isdefined(self.kc_timer))
        self.kc_timer destroy();
}

spawnedKillcamCleanup()
{
    self endon("end_killcam");

    self waittill("spawned");
    self removeKillcamElements();
}

addBotClients()
{
    wait 5;
    
    for(;;)
    {
        if(getCvarInt("scr_numbots") > 0)
            break;
        wait 1;
    }
    
    iNumBots = getCvarInt("scr_numbots");
    for(i = 0; i < iNumBots; i++)
    {
        ent[i] = addtestclient();
        wait 0.5;

        if(isPlayer(ent[i]))
        {/*
            if(i & 1)
            {
                ent[i] notify("menuresponse", game["menu_team"], "axis");
                wait 0.5;
                ent[i] notify("menuresponse", game["menu_weapon_axis"], "kar98k_mp");
            }
            else
            {*/
                ent[i] notify("menuresponse", game["menu_team"], "axis");
                wait 0.5;
                ent[i] notify("menuresponse", game["menu_weapon_axis"], "mp40_mp");
            /*}*/
        }
    }
}
