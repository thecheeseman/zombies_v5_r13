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

//
// init()
// initialise all bot related settings
//
init() {
    level.botmap = false;
    level.bot_allowconnect = false;

// callbacks
    level.bot_connect       = ::onConnect;
    level.bot_disconnect    = ::onDisconnect;
    level.bot_damage        = ::onDamage;
    level.bot_killed        = ::onKilled;
// callbacks

    // load waypoints file into zomextended
    wpfile = "waypoints/" + getCvar( "mapname" ) + ".wp";
    if ( wp_init( wpfile ) )
        level.botmap = true;

// config
    level.bot_obituary = false;

    if ( getCvar( "bot_count" ) == "" )
        setCvar( "bot_count", 1 );
    level.bot_count = getCvarInt( "bot_count" );

    // bot count is determined by privateClients
    // this is because with zomextended, bots will _always_ join private slots
    // so they don't take up any regular player slots
    if ( getCvar( "sv_privateClients" ) == "" )
        setCvar( "bot_countmax", getCvarInt( "sv_maxclients" ) / 3 );
    else
        setCvar( "bot_countmax", getCvarInt( "sv_privateClients" ) );
    level.bot_countMax = getCvarInt( "bot_countmax" );

    if ( level.bot_countMax > 4 )
        level.bot_countMax -= 4;

    if ( level.bot_count > level.bot_countMax )
        level.bot_count = level.bot_countMax;

    // current number of active bots
    level.bot_countCurrent = 0;

    level.bot_countKillsAndDeaths = false;

    level.bot_fallDamageMin = 256;
    level.bot_fallDamageMax = 512;

    level.bot_friendlyFire = true;
// config

    // don't bother initialising anything else 
    // unless we actually have waypoints
    if ( !level.botmap )
        return;

// globals
    //
    // goal priorities
    // stack-based system
    // highest priorities get factored first
    // filter through until all priorties have been met, cycle
    //
    level.kBOT_GP_NONE = 0;         // delete goal
    level.kBOT_GP_LOWEST = 1;       
    level.kBOT_GP_LOW = 2;          // default spots like spawnpoints
    level.kBOT_GP_NORM = 4;         // common spots on maps
    level.kBOT_GP_HIGH = 8;
    level.kBOT_GP_HIGHEST = 16;     // player priority spots
    //

    //
    // goal types
    //
    level.kBOT_GT_GENERIC = 0;      // generic goal
    level.kBOT_GT_SPAWNPOINT = 1;   
    level.kBOT_GT_COMMON_SPOT = 2;
    level.kBOT_GT_ENTITY = 4;
    level.kBOT_GT_PLAYER = 8;
    //

    //
    // bot state
    // tells the game what the bot is doing 
    //
    level.kBOT_BS_INIT = 0;         // init state
    level.kBOT_BS_IDLE = 1;         // signals we need a goal
    level.kBOT_BS_SPAWNING = 2;     // set when bot is spawning
    level.kBOT_BS_CHASEGOAL = 4;    // chasing a goal
    level.kBOT_BS_CHASEPLAYER = 8;  // chasing a player
    level.kBOT_BS_DEAD = 16;        // no longer living, final state
    //
// globals
}

//
// main()
// entry point for gamecode
//
main() {
    if ( !level.botmap )
        return;

    // kick any hold-over bots
    players = getEntArray( "player", "classname" );
    for ( i = 0; i < players.size; i++ ) {
        if ( players[ i ] isBot() )
            players[ i ] kickBot();
    }

    wait 5;

    // temporary for now
    players = getEntArray( "player", "classname" );
    while ( players.size == 0 ) {
        players = getEntArray( "player", "classname" );
        wait 1;
    }

    level.bot_allowconnect = true;

    for ( i = 0; i < level.bot_count; i++ ) {
        bot = addBot();
        if ( !isDefined( bot ) ) {
            printConsole( "unable to add bot for some reason\n" );
            continue;
        }

        bot setupBot();
        bot thread spawnBot();

        level.bot_countCurrent++;

        wait 0.5;
    }

    level.bot_allowconnect = false;
}

//
// addBot()
// adds a bot
//
addBot() {
    bot = addTestClient();

    wait 0.5;

    if ( isPlayer( bot ) ) 
        return bot;
    else
        return undefined;
}

//
// setupBot()
// sets up the bot with proper variables and such
//
setupBot() {
//
    self renameBot( "a zombie" );
    self setClientCvar( "name", "a zombie" );
//

    self.bot = spawnstruct();

// control
    self.bot.n = undefined;
//

// goals
    self.bot.goals = [];
    self.bot.goals_needsort = false;    // whether or not the goal array needs priority sorting
    self.bot.currentgoal = undefined;
    self.bot.currentgoalentity = undefined;
// goals

// persistant awareness
    self.bot.pa = spawnstruct();
    self.bot.pa.players = [];
    self.bot.pa.entities = [];
// persistant awareness
}

//
// spawnBot()
// callback
//
spawnBot() {
    self.pers[ "team" ] = "allies";
    self.pers[ "weapon" ] = "enfield_mp";

//
    wait frame();
//

    self notify( "spawned" );

    resettimeout();

    self.sessionteam = self.pers[ "team" ];
    self.sessionstate = "playing";
    self.spectatorclient = -1;
    self.archivetime = 0;
    self.statusicon = "";

    spawnpointname = "mp_teamdeathmatch_spawn";
    spawnpoints = getEntArray( spawnpointname, "classname" );
    spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnpoints );

    if ( isdefined( spawnpoint ) )
        self spawn( spawnpoint.origin, spawnpoint.angles );
    else
        maps\mp\_utility::error( "NO " + spawnpointname + " SPAWNPOINTS IN MAP" );

    self.maxhealth = 100;
    self.health = self.maxhealth;

    //self zombies\skins::main();
    self detachall();
    self zombies\skins::setPlayerModel( zombies\skins::getPlayerModels( "british" ) );
    
    self giveWeapon( self.pers[ "weapon" ] );
    self setSpawnWeapon( self.pers[ "weapon" ] );
    self setWeaponSlotClipAmmo( "primary", 0 );
    self setWeaponSlotAmmo( "primary", 0 );

    if ( isDefined( self.bot.n ) )
        self.bot.n delete();

    //self.bot.n = spawn( "script_origin", self getOrigin() );
    //self linkto( self.bot.n );

    self thread botlib\ai::botLogic();
}

//
// onConnect()
// callback
//
onConnect() {
    if ( !level.bot_allowconnect ) {
        self kickBot();
        return;
    }

    if ( !level.botmap )
        return;

    self.statusicon = "gfx/hud/hud@status_connecting.tga";
    self waittill( "begin" );
    self.statusicon = "";
}

//
// onDisconnect()
// callback
//
onDisconnect() {
    self notify( "bot_disconnect" );
}

//
// onDamage()
// callback
//
onDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc ) {
    if ( isDefined( self.cb_damage ) ) {
        [[ self.cb_damage ]]( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc );
        return;
    }

    if ( isPlayer( eAttacker ) && eAttacker.pers[ "team" ] == self.pers[ "team" ] && !level.bot_friendlyFire )
        return;

    self botlib\util::setBotAngles( eAttacker.origin - self.origin, 2 );
    self.bot.hasplayer = true;
    self.bot.target = eAttacker;

    // Don't do knockback if the damage direction was not specified
    if ( !isDefined( vDir ) )
        iDFlags |= level.iDFLAGS_NO_KNOCKBACK;

    // Make sure at least one point of damage is done
    if ( iDamage < 1 )
            iDamage = 1;

    self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc );
}

//
// onKilled()
// callback
//
onKilled( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc ) {
    self notify( "bot_death" );

    if ( isDefined( self.cb_killed ) ) {
        [[ self.cb_killed ]]( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc );
        return;
    }

    // If the player was killed by a head shot, let players know it was a head shot kill
    if ( sHitLoc == "head" && sMeansOfDeath != "MOD_MELEE" )
        sMeansOfDeath = "MOD_HEAD_SHOT";
        
    // send out an obituary message to all clients about the kill
    if ( level.bot_obituary )
        obituary( self, eAttacker, sWeapon, sMeansOfDeath );
    
    self.sessionstate = "dead";
    self.statusicon = "gfx/hud/hud@status_dead.tga";
    self.headicon = "";

    if ( level.bot_countKillsAndDeaths )
        self.deaths++;

    // stop if map ended on death
    if ( level.mapended )
        return;

    body = self clonePlayer();

    delay = 2;  // Delay the player becoming a spectator till after he's done dying
    wait delay; // ?? Also required for Callback_PlayerKilled to complete before respawn/killcam can execute

    // respawn immediately
    self thread spawnBot();
}

Callback_BotThink() {

}
