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
    Zombies 
*/

main()
{
    zombies\debug::init();
    [[ level.logwrite ]]( "VV---------- mod.gsc::Main() ----------VV" );
    
    zombies\precache::init();
    
    precache();

    zombies\config::init();
    
    botlib\main::init();
    modules\modules::init();
    zombies\objects::init();
    zombies\killstreaks::init();
    zombies\buymenu::init();
    zombies\mapvote::init();
    zombies\ammoboxes::init();
    zombies\admin::init();
    zombies\extra::init();
    zombies\weather::init();
    zombies\hud::init();
    zombies\stats::init();
    zombies\ranks::init();
    zombies\classes::init();
    zombies\skins::init();

    zombies\config::main();
    zombies\ammoboxes::main();
    zombies\admin::main();   
    zombies\extra::main();
    zombies\weather::main();
    zombies\sharkscanner::main();
    botlib\main::main();

    [[ level.logwrite ]]( "^^---------- mod.gsc::Main() ----------^^" );

    zombies\precache::dump_precache();
}

precache()
{
    [[ level.precache ]]( "gfx/hud/headicon@re_objcarrier.tga",     "headicon" );
    [[ level.precache ]]( "gfx/hud/headicon@re_objcarrier.tga",     "statusicon" );
    [[ level.precache ]]( "gfx/hud/headicon@axis.tga",              "statusicon" );
    [[ level.precache ]]( "gfx/hud/headicon@allies.tga",            "statusicon" );
    [[ level.precache ]]( "gfx/hud/hud@death_m1carbine.tga",        "statusicon" );
    [[ level.precache ]]( "gfx/hud/hud@objective_bel.tga" );
    [[ level.precache ]]( "gfx/hud/hud@objectivegoal.tga" );
    [[ level.precache ]]( "gfx/hud/hud@fire_ready.tga" );
    [[ level.precache ]]( "gfx/hud/headicon@axis.tga" );
    [[ level.precache ]]( "gfx/hud/headicon@allies.tga" );
    [[ level.precache ]]( "killiconmelee", "shader" );
    [[ level.precache ]]( "killicondied", "shader" );
    [[ level.precache ]]( "killiconheadshot", "shader" );
    [[ level.precache ]]( "killiconsuicide", "shader" );
    [[ level.precache ]]( "gfx/impact/flesh_hit1.tga" );
    [[ level.precache ]]( "gfx/impact/flesh_hit2.tga" );
    [[ level.precache ]]( "gfx/hud/hud@health_back.dds" );
    [[ level.precache ]]( "gfx/hud/hud@health_bar.dds" );
    
    [[ level.precache ]]( "fg42_mp" );
    [[ level.precache ]]( "panzerfaust_mp" );
    
    [[ level.precache ]]( "weapon_russian",                         "menu" );
    
    [[ level.precache ]]( "default",                                "shellshock" );
    [[ level.precache ]]( "groggy",                                 "shellshock" );

    [[ level.precache ]]( "^3Spectating is not allowed." );
    [[ level.precache ]]( "Waiting for ^22 ^7players..." );

    [[ level.precache ]]( "Medic!" );
    [[ level.precache ]]( "Need ammo!" );

    [[ level.precache ]]( "xmodel/health_large" );
    [[ level.precache ]]( "xmodel/gear_russian_load_coat" );
    [[ level.precache ]]( "xmodel/gear_russian_ppsh_coat" );
    [[ level.precache ]]( "xmodel/gear_russian_pack_ocoat" );
    
    [[ level.precache ]]( "fx/fire/tinybon.efx",                    "fx", "zombieFire" );
    [[ level.precache ]]( "fx/explosions/pathfinder_explosion.efx", "fx", "zombieExplo" );
    [[ level.precache ]]( "fx/impacts/flesh_hit.efx",               "fx", "fleshhit" );
    [[ level.precache ]]( "fx/impacts/flesh_hit5g.efx",             "fx", "fleshhit2" );
    [[ level.precache ]]( "fx/explosions/grenade3.efx",             "fx", "bombexplosion" );
    [[ level.precache ]]( "fx/explosions/explosion1.efx" );
    [[ level.precache ]]( "fx/explosions/v2_exlosion.efx",          "fx", "v2" );
    [[ level.precache ]]( "fx/smoke/aftermath1.efx",                "fx", "aftermath" );    
    [[ level.precache ]]( "fx/smoke/cratersmoke.efx" );
    [[ level.precache ]]( "fx/fire/stage1.efx" );

// dropped from gametype.gsc
    game[ "allies" ] = "british";
    game[ "axis" ] = "german";

    if ( !isDefined( game[ "layoutimage" ] ) ) {
        level.mapname = utilities::toLower( getCvar( "mapname" ) );
        switch ( level.mapname ) {
            case "mp_brecourt":
            case "mp_carentan":
            case "mp_chateau":
            case "mp_dawnville":
            case "mp_depot":
            case "mp_harbor":
            case "mp_hurtgen":
            case "mp_pavlov":
            case "mp_powcamp":
            case "mp_railyard":
            case "mp_rocket":
            case "mp_ship":
                game[ "layoutimage" ] = level.mapname;
                ambientPlay( "ambient_" + level.mapname );
                break;
            default:
                game[ "layoutimage" ] = "default";
                break;
        }
    }

    layoutname = "levelshots/layouts/hud@layout_" + game[ "layoutimage" ];
    setCvar( "scr_layoutimage", layoutname );
    makeCvarServerInfo( "scr_layoutimage", "" );

    game[ "menu_team" ] =               "team_" + game["allies"] + game["axis"];
    game[ "menu_weapon_allies" ] =      "weapon_" + game["allies"];
    game[ "menu_weapon_axis" ] =        "weapon_americangerman";
    game[ "menu_viewmap" ] =            "viewmap";
    game[ "menu_callvote" ] =           "callvote";
    game[ "menu_quickcommands" ] =      "quickcommands";
    game[ "menu_quickstatements" ] =    "quickstatements";
    game[ "menu_quickresponses" ] =     "quickresponses";
    game[ "headicon_allies" ] =         "gfx/hud/headicon@allies.tga";
    game[ "headicon_axis" ] =           "gfx/hud/headicon@axis.tga";

    [[ level.precache ]]( layoutname );

    [[ level.precache ]]( &"MPSCRIPT_PRESS_ACTIVATE_TO_RESPAWN" );
    [[ level.precache ]]( &"MPSCRIPT_KILLCAM" );

    [[ level.precache ]]( game[ "menu_team" ], "menu" );
    [[ level.precache ]]( game[ "menu_weapon_allies" ], "menu" );
    [[ level.precache ]]( game[ "menu_weapon_axis" ], "menu" );
    [[ level.precache ]]( game[ "menu_viewmap" ], "menu" );
    [[ level.precache ]]( game[ "menu_callvote" ], "menu" );
    [[ level.precache ]]( game[ "menu_quickcommands" ], "menu" );
    [[ level.precache ]]( game[ "menu_quickstatements" ], "menu" );
    [[ level.precache ]]( game[ "menu_quickresponses" ], "menu" );

    [[ level.precache ]]( "hudScoreboard_mp", "shader" );
    [[ level.precache ]]( "gfx/hud/hud@mpflag_spectator.tga" );
    [[ level.precache ]]( "gfx/hud/hud@status_dead.tga", "statusicon");
    [[ level.precache ]]( "gfx/hud/hud@status_connecting.tga", "statusicon" );
    [[ level.precache ]]( game[ "headicon_allies" ], "headicon");
    [[ level.precache ]]( game[ "headicon_axis" ], "headicon" );
    [[ level.precache ]]( "item_health" );
// dropped from gametype.gsc

    if ( level.mapname == "mp_ship" )
        [[ level.precache ]]( "xmodel/vehicle_german_yacht_static" );

    level.voices[ "german" ] = 3;
    level.voices[ "american" ] = 7;
    level.voices[ "russian" ] = 4;
    level.voices[ "british" ] = 5;

    if ( !isDefined( game[ "state" ] ) )
        game[ "state" ] = "playing";

    level.mapended = false;
    level.healthqueue = [];
    level.healthqueuecurrent = 0;    
    level.zombiepicked = false; 
    level.lastKiller = undefined;
    level.firstzombie = false;
    level.lasthunter = false;
    level.gamestarted = false;
    level.stickynades = 0;
    level.uav = false;
    level.nuked = false;
    level.revision = 13;

    setarchive( true );
}

startGame()
{
    [[ level.logwrite ]]( "zombies\\mod.gsc::startGame()", true );

    setCvar( "g_teamname_axis", "^6Hunters" );
    setCvar( "g_teamname_allies", "^1Zombies" );
    
    level.waitnotice = newHudElem();
    level.waitnotice.x = 320;
    level.waitnotice.y = 240;
    level.waitnotice.alignX = "center";
    level.waitnotice.alignY = "middle";
    level.waitnotice setText( &"Waiting for ^22 ^7players..." );
    level.waitnotice.alpha = 0.75;
    
    thread rotateIfEmpty();
    
    while ( true ) {
        ePlayers = utilities::getPlayersOnTeam( "axis" );
        if ( ePlayers.size > 1 )
            break;
            
        wait 1;
    }
    
    level notify( "starting game" );
    
    level.waitnotice destroy();

    level.clock = newHudElem();
    level.clock.x = 320;
    level.clock.y = 20;
    level.clock.alignX = "center";
    level.clock.alignY = "middle";
    level.clock.font = "bigfixed";
    level.clock.color = ( 1, 1, 1 );
    level.clock setTimer( level.cvars[ "PREGAME_TIME" ] );
    if ( level.cvars[ "PREGAME_TIME" ] > 60 ) {
        wait level.cvars[ "PREGAME_TIME" ] - 60;
        level.clock fadeOverTime( 60 );
        level.clock.color = ( 1, 0, 0 );
        wait 60;
    } else {
        level.clock fadeOverTime( level.cvars[ "PREGAME_TIME" ] );
        level.clock.color = ( 1, 0, 0 );
    
        wait ( level.cvars[ "PREGAME_TIME" ] );
    }
    
    level.clock destroy();
    level.gamestarted = true;

    pickZombie();
    level.firstzombie = true;
        
    wait 2;

    players = getEntArray( "player", "classname" );
    timeshift = (float) ( (float) players.size / (float) 16 );
    if ( timeshift > 1 )    timeshift = 1;
    if ( timeshift < 0.3 )  timeshift = 0.3;

    level.timelimit *= timeshift;
    
    level.starttime = getTime();

    level.clock = newHudElem();
    level.clock.x = 320;
    level.clock.y = 20;
    level.clock.alignX = "center";
    level.clock.alignY = "middle";
    level.clock.font = "bigfixed";
    level.clock.color = ( 0, 0.75, 0 );
    level.clock setTimer( level.timelimit * 60 );
    
    thread gameLogic();
}

rotateIfEmpty()
{
    level endon( "starting game" );
    
    time = 0;
    
    while ( time < 1200 ) {
        time++;
        wait 1;
    }
    
    [[ level.logwrite ]]( "zombies\\mod.gsc::rotateIfEmpty() -- exiting because empty" );
    exitLevel( false );
}

pickZombie()
{
    zom = undefined;
    guys = utilities::getPlayersOnTeam( "axis" );
    lasthunter = getCvar( "lasthunter" );

    // no hunters?
    if ( guys.size == 0 ) {
        return;
    }
    
    for ( i = 0; i < guys.size; i++ )
    {
        if ( guys[ i ].guid == lasthunter )
            zom = guys[ i ];
    }
    
    if ( isDefined( zom ) )
    {
        iPrintLnBold( zom.name + "^7 was the last ^6Hunter^7, he's now the first ^1Zombie^7!" );
        zom.nonotice = true;
        zom thread makeZombie();
        wait 0.05;
        setCvar( "lastzom", zom.guid );
        return;
    }
    
    int = utilities::_randomInt( guys.size );
    zom = guys[ int ];
    while ( zom.guid == getCvar( "lastzom" ) )
    {
        iPrintLnBold( zom.name + "^7 was the ^1Zombie^7 last time... picking someone else..." );
        wait 2;
        int = utilities::_randomInt( guys.size );
        zom = guys[ int ];
    }
    
    iPrintLnBold( zom.name + "^7 was randomly selected to be the ^1Zombie^7!" );
    zom.nonotice = true;
    zom thread makeZombie();
    wait 0.05;
    setCvar( "lastzom", zom.guid );
}

endGame( winner )
{
    [[ level.logwrite ]]( "zombies\\mod.gsc::endGame( " + winner + " )", true );
    game[ "state" ] = "endgame";
    level notify( "endgame" );
    level notify( "intermission" );
    
    level.mapended = true;
    
    if ( !level.lasthunter )
        setCvar( "lasthunter", "" );
    
    if ( isDefined( level.clock ) )
        level.clock destroy();
    
    if ( winner == "zombies" )
        iPrintLnBold( "^1Zombies have killed all the Hunters!" );
    else if ( winner == "hunters" )
        iPrintLnBold( "^6Hunters have survived!" );
    else if ( winner == "forced" )
        iPrintLnBold( "^1Admin forced end game!" );
    else if ( winner == "nuke" )
        iPrintLnBold( "^3Nuke killed everyone!" );
        
    ambientStop( 3 );
    wait 3;
    
    if ( winner == "hunters" )
    {
        setCvar( "lasthunter", "" );
        
        hunters = utilities::getPlayersOnTeam( "axis" );
        iPrintLnBold( "Surviving Hunters get a ^6" + level.xpvalues[ "HUNTER_WIN" ] + "^7 XP bonus!" );
        
        for ( i = 0; i < hunters.size; i++ )
        {
            hunters[ i ].xp += level.xpvalues[ "HUNTER_WIN" ];
            hunters[ i ].score += level.xpvalues[ "HUNTER_WIN" ];
            hunters[ i ].points += level.pointvalues[ "HUNTER_WIN" ];
            hunters[ i ] thread zombies\ranks::checkRank();
        }
        
        wait 1;
    }
    
    if ( winner == "nuke" && !level.lasthunter )
        setCvar( "lasthunter", "" );
    
    players = getentarray( "player", "classname" );
    if ( players.size > 0 ) {
        if ( winner == "zombies" && isDefined( level.lastkiller ) )
        {
            for(i = 0; i < players.size; i++)
            {
                player = players[i];
                player closeMenu();
                player setClientCvar( "g_scriptMainMenu", "main" );
                player thread GameCam( level.lastKiller getEntityNumber(), 2 );
            }
            
            wait 4.5;
            
            utilities::slowMo( 3.5 );
        }

        if ( winner == "zombies" || winner == "nuke" )
            ambientPlay( "codtheme", 15 );
        else
            ambientPlay( "pegasusbridge_credits", 15 );

        for ( i = 0; i < players.size; i++ )
        {
            if ( isAlive( players[ i ] ) ) {
                players[ i ] thread gameCamRemove();
            }
            
            players[ i ] [[ level.callbackSpawnSpectator ]]();
            players[ i ].org = spawn( "script_origin", players[ i ].origin );
            players[ i ] linkto( players[ i ].org );
        }
        
        if ( !level.nuked )
            setCullFog( 0, 7500, 0, 0, 0, 3 );
        
        thread zombies\stats::saveAll();
        thread zombies\hud::endgamehud();

        centerImage = newHudElem();
        centerImage.x = 320;
        centerImage.y = 105;
        centerImage.alignX = "center";
        centerImage.alignY = "middle";
        centerImage.alpha = 0;
        centerImage.sort = 10;

        // look, i know this doesn't need to be in its own scope
        // but it makes me sleep better at night, okay?
        {
            utilities::cleanScreen();
            iPrintLnBold( "Best ^2Hunters ^7& ^1Zombies" );
            
            wait 3;

            guy = getBest( "hunter" );
            if ( isDefined( guy ) ) {
                centerImage thread fadeIn( 0.5, "gfx/hud/headicon@axis.tga" );
                utilities::cleanScreen();
                iPrintlnBold( "^2Best Hunter: " );
                iPrintlnBold( guy.name + " ^7- ^1" + guy.score );

                wait 2.5;
                centerImage thread fadeOut( 0.5 );
                wait 0.5;
            }

            guy = getBest( "zombie" );
            if ( isDefined( guy ) ) {
                centerImage thread fadeIn( 0.5, "gfx/hud/headicon@allies.tga" );
                utilities::cleanScreen();
                iPrintlnBold( "^1Best Zombie: " );
                iPrintlnBold( guy.name + " ^7- ^1" + guy.deaths );

                wait 2.5;
                centerImage thread fadeOut( 0.5 );
                wait 0.5;
            }
            
            guy = getMost( "kills" );
            if ( isDefined( guy ) ) {
                centerImage thread fadeIn( 0.5, "killicondied" );
                utilities::cleanScreen();
                iPrintlnBold( "^3Most Kills: " );
                iPrintlnBold( guy.name + " - ^1" + guy.stats[ "kills" ] );
                
                wait 2.5;
                centerImage thread fadeOut( 0.5 );
                wait 0.5;
            }

            guy = getMost( "assists" );
            if ( isDefined( guy ) ) {
                centerImage thread fadeIn( 0.5, "gfx/hud/hud@health_cross.tga" );
                utilities::cleanScreen();
                iPrintlnBold( "^4Most Assists: " );
                iPrintlnBold( guy.name + " - ^1" + guy.stats[ "assists" ] );
                
                wait 2.5;
                centerImage thread fadeOut( 0.5 );
                wait 0.5;
            }

            guy = getMost( "bashes" );
            if ( isDefined( guy ) ) {
                centerImage thread fadeIn( 0.5, "killiconmelee" );
                utilities::cleanScreen();
                iPrintlnBold( "^5Most Bashes: " );
                iPrintlnBold( guy.name + " - ^1" + guy.stats[ "bashes" ] );

                wait 2.5;
                centerImage thread fadeOut( 0.5 );
                wait 0.5;
            }

            guy = getMost( "headshots" );
            if ( isDefined( guy ) ) {
                centerImage thread fadeIn( 0.5, "killiconheadshot" );
                utilities::cleanScreen();
                iPrintlnBold( "^6Most Headshots: " );
                iPrintlnBold( guy.name + " - " + guy.stats[ "headshots" ] );
                
                wait 2.5;
                centerImage thread fadeOut( 0.5 );
                wait 0.5;
            }
            
            centerImage destroy();
            utilities::cleanScreen();
        }
        
        thread zombies\mapvote::Initialize();
        level waittill( "VotingComplete" );
            
        thread zombies\hud::endgamehud_cleanup();
        
        game[ "state" ] = "intermission";
        
        players = getEntArray( "player", "classname" );
        for ( i = 0; i < players.size; i++ )
            players[ i ] [[ level.callbackspawnIntermission ]]();
            
        setCullFog( 0, 1, 0, 0, 0, 7 );
        
        ambientStop( 10 );
        wait 10;
    }

    [[ level.logwrite ]]( "zombies\\mod.gsc::endGame( " + winner + " ) -- exiting level", true );
    exitLevel( false );
}

gameLogic()
{
    level endon( "endgame" );
    level endon( "intermission" );
    
    time = 0;
    while ( 1 )
    {
        resettimeout();

        zombies = utilities::getPlayersOnTeam( "allies" );
        hunters = utilities::getPlayersOnTeam( "axis" );
        
        if ( zombies.size == 0 && hunters.size > 0 )
        {
            pickZombie();
            wait 0.05;
        }
            
        if ( zombies.size == 1 && !level.firstzombie )
            level.firstzombie = true;
        if ( zombies.size > 1 && level.firstzombie )
            level.firstzombie = false;
        
        if ( hunters.size == 1 && !level.lasthunter && zombies.size > 1 )
        {
            level.lasthunter = true;
            guy = hunters[ 0 ];
            
            guy thread lastHunter();
        }
        
        if ( level.nuked )
            break;
        
        if ( hunters.size == 0 )
        {
            thread endGame( "zombies" );
            break;
        }
        
        wait 0.05;
        time += 0.05;

        // check timelimit
        if ( time % 20 == 0 ) {
            timepassed = ( ( getTime() - level.starttime ) / 1000 ) / 60.0;
            if ( timepassed >= level.timelimit ) {
                level.mapended = true;
                thread endGame( "hunters" );
                break;
            }
        }
    }
    
    wait 3;
    
    if ( !level.mapended )
    {
        zombies = utilities::getPlayersOnTeam( "allies" );
        hunters = utilities::getPlayersOnTeam( "axis" );
        
        if ( hunters.size == 0 )
        {
            thread endGame( "zombies" );
            return;
        }

        if ( level.nuked )
            return;
        
        [[ level.logwrite ]]( "zombies\\mod.gsc::gameLogic() -- server hung up??" );
        iPrintLnBold( "Server hung up... switching maps..." );
        wait 5;
        exitLevel( false );
    }
}

gameCam( playerNum, delay )
{
    self endon( "disconnect" );
    self endon( "spawned" );

    if ( playerNum < 0 )
        return;
        
    self.sessionstate = "spectator";
    self.spectatorclient = playerNum;
    self.archivetime = delay + 7;

    wait 0.05;
        
    if ( !isDefined( self.gc_topbar ) )
    {
        self.gc_topbar = newClientHudElem( self );
        self.gc_topbar.archived = false;
        self.gc_topbar.x = 0;
        self.gc_topbar.y = 0;
        self.gc_topbar.alpha = 0.75;
        self.gc_topbar.sort = 1000;
        self.gc_topbar setShader( "black", 640, 112 );
    }

    if ( !isDefined( self.gc_bottombar ) )
    {
        self.gc_bottombar = newClientHudElem( self );
        self.gc_bottombar.archived = false;
        self.gc_bottombar.x = 0;
        self.gc_bottombar.y = 368;
        self.gc_bottombar.alpha = 0.75;
        self.gc_bottombar.sort = 1000;
        self.gc_bottombar setShader( "black", 640, 112 );
    }
}

gameCamRemove()
{
    if ( isDefined( self.gc_topbar ) )      self.gc_topbar destroy();
    if ( isDefined( self.gc_bottombar ) )   self.gc_bottombar destroy();
    if ( isDefined( self.gc_title ) )       self.gc_title destroy();
    if ( isDefined( self.gc_timer ) )       self.gc_timer destroy();
    
    self.spectatorclient = -1;
    self.archivetime = 0;
    self.sessionstate = "dead";
}

onConnect()
{
    [[ level.logwrite ]]( "zombies\\mod.gsc:onConnect() -- " + self.name + " connected (" + self getip() + ")" );

    if ( self.name == "Unknown Soldier" || self.name == "UnnamedPlayer" )
        self setClientCvar( "name", "I^1<3^7ZOMBAIS^1" + gettime() );
        
    self.oldname = self.name;
    
    self.rank = 0;
    self.xp = 0;
    self.killstreak = 0;
    self.zomrank = 0;
    self.zomxp = 0;
    self.points = 0;

    self.timejoined = gettime();
    
    self.iszombie = false;
    self.zombietype = "none";
    self.gettingammo = false;
    self.givenammo = false;
    self.nonotice = false;
    self.islasthunter = false;
    self.changeweapon = false;
    self.immune = false;
    self.isadmin = false;
    
    self.damagemult = 0;
    self.resilience = 0;
    self.jumpmult = 0;
    self.stickynadecount = 0;
    self.stickynades = 0;
    self.healthpacks = 0;
    self.maxhealthpacks = 0;
    self.bodyarmor = 0;
    self.exploarmor = 0;
    self.damagearmor = 0;
    self.ammoboxuses = 0;
    self.megajump = 0;
    self.zomscore = 0;
    self.pointscore = 0;
    self.immunity = 0;
    self.zomnadeammo = 0;
    self.ammobonus = 0;
    self.specialmodel = false;
    self.lasthittime = 0;
    self.class = "default";
    self.subclass = "none";
    self.invisible = false;
    self.flashbangs = false;
    
    self.ispoisoned = false;
    self.onfire = false;
    self.isnew = true;
    self.powerup = undefined;
    self.missmines = false;
    self.rocketattack = false;
    self.nationality = "none";
    self.lastattackers = [];
    self.painsound = undefined;
    self.firebombready = true;
    self.firebombed = false;
    self.poisonbombready = true;
    self.modelchanged = false;
    self.nightvision = false;
    self.preferredtarget = undefined;
    self.specplayer = undefined;
    self.hasplacedsentry = false;
    self.currentlyhassentry = false;
    self.lastsentrytime = gettime();
    
    self.barricades = [];

    //  load coco permissions- merged to avoid issues in future // 
    self thread permissions::main();
    self zombies\stats::setupPlayer();
    
    if ( utilities::toLower( getCvar( "mapname" ) ) == "cp_omahgawd" || utilities::toLower( getCvar( "mapname" ) ) == "cp_banana" )
        self setClientCvar( "r_fastsky", 0 );
    else
        self setClientCvar( "r_fastsky", 1 );
        
    self thread extraKeys();
}

onDisconnect()
{
    [[ level.logwrite ]]( "zombies\\mod.gsc::onDisconnect() -- " + self.name + " disconnected (" + self getip() + ")", true );

    thread zombies\buymenu::cleanUp( self getEntityNumber() );
}

spawnPlayer()
{
    [[ level.logwrite ]]( "zombies\\mod.gsc::spawnPlayer() -- spawned player " + self.name + " (" + self getip() + ")", true );

    self.killstreak = 0;
    self.ispoisoned = false;
    self.onfire = false;
    self.gettingammo = false;
    self.givenammo = false;
    self.nonotice = false;
    self.immune = false;
    self.stickynades = 0;
    self.stickynadecount = 0;
    self.healthpacks = 0;
    self.powerup = undefined;
    self.armored = false;
    self.damagemult = 1;
    self.resilience = 0;
    self.jumpmult = 2;
    self.missmines = false;
    self.rocketattack = false;
    self.lastattackers = [];
    self.painsound = undefined;
    self.firebombed = false;
    self.bodyarmor = 0;
    self.exploarmor = 0;
    self.damagearmor = 0;
    self.ammoboxuses = 0;
    self.megajump = 0;
    self.immunity = 0;
    self.nightvision = false;
    self.zomnadeammo = 0;
    self.ammobonus = 0;
    self.specialmodel = false;
    self.lasthittime = 0;
    self.class = "default";
    self.subclass = "none";
    self.invisible = false;
    self.flashbangs = false;
    self.preferredtarget = undefined;
    self.specplayer = undefined;
    self.hasplacedsentry = false;
    self.currentlyhassentry = false;
    self.lastsentrytime = gettime();

    if ( isDefined( self.spechud ) || isDefined( self.specnotice ) )
    {
        self.spechud destroy();
        self.specnotice destroy();
    }
        
    if ( self.pers[ "team" ] == "axis" )
    {
        if ( self.iszombie )
        {
            self.iszombie = false;
            self.zombietype = "none";
        }

        self thread timeAlive();
        self thread whatscooking();
        self thread shotsfired();

        self zombies\ranks::giveHunterRankPerks();
        
        self.headiconteam = "axis";
    }
    else if ( self.pers[ "team" ] == "allies" )
    {
        if ( !self.iszombie )
            self.iszombie = true;
            
        self setWeaponSlotAmmo( "primary", 0 );
        self setWeaponSlotAmmo( "pistol", 0 );
        self setWeaponSlotClipAmmo( "primary", 0 );
        self setWeaponSlotClipAmmo( "pistol", 0 );

        self zombies\ranks::giveZomRankPerks();

        if ( self.headicon != "" )
        {
            self.headicon = "";
            self.headiconteam = "";
        }
    }

    self zombies\skins::main();
    self zombies\classes::setup();

    if ( self.pers[ "team" ] == "axis" ) {
        self ammoLimiting();

        if ( self.class == "sniper" || self.class == "recon" || 
           ( self.class == "support" && self.subclass == "combat" ) ||
           ( self.class == "medic" && self.subclass == "combat" ) )
            self thread stickynades();
    } else {
        if ( level.firstzombie ) {
            self.maxhealth = 2000;
            self.health = self.maxhealth;
        }
    }
    
    if ( self.isnew )
    {
        self.isnew = false;
        self thread zombies\config::welcomeMessage();
    }

    self thread zombies\hud::runHud();
    
    if ( level.debug )
        self utilities::showpos();
}

spawnSpectator()
{
    [[ level.logwrite ]]( "zombies\\mod.gsc::spawnSpectator() -- spawned spectator " + self.name + " (" + self getip() + ")", true );
    self notify( "spawn_spectator" );
    
    self.ispoisoned = false;
    self.onfire = false;
    self.iszombie = false;
    self.gettingammo = false;
    self.givenammo = false;
    self.zombietype = "none";
    
    self.pers[ "savedmodel" ] = undefined;
    
    self thread zombies\hud::cleanUpHud();
    self thread zombies\buymenu::cleanUp();
    
    if ( getCvar( "zom_antispec" ) == "1" && !level.mapended && !self zombies\permissions::hasPermission( "defeat_antispec" ) )
        self thread antispec();
}

antispec() {
    if ( isDefined( self.spechud ) ) 
        self.spechud destroy();

    if ( isDefined( self.specnotice ) )
        self.specnotice destroy();

    if ( !isDefined( self.specplayer ) ) {
        self.spechud = newClientHudElem( self );
        self.spechud.sort = -2;
        self.spechud.x = 0;
        self.spechud.y = 0;
        self.spechud setShader( "black", 640, 480 );
        self.spechud.alpha = 1;
        self.spechud.archived = false;
        
        self.specnotice = newClientHudElem( self );
        self.specnotice.sort = -1;
        self.specnotice.x = 320;
        self.specnotice.y = 220;
        self.specnotice.alignx = "center";
        self.specnotice.aligny = "middle";
        self.specnotice setText( &"^3Spectating is not allowed." );
        self.specnotice.alpha = 1;
        self.spechud.archived = false;
    }

    level endon( "intermission" );

    while ( self.sessionstate == "spectator" ) {
        if ( isDefined( self.specplayer ) )
            self.spectatorclient = self.specplayer;
        else 
            self.spectatorclient = self getEntityNumber();
        wait 0.05;
    }

    if ( isDefined( self.spechud ) ) 
        self.spechud destroy();

    if ( isDefined( self.specnotice ) )
        self.specnotice destroy();
}

spawnIntermission()
{
    [[ level.logwrite ]]( "zombies\\mod.gsc::spawnIntermission() -- spawned intermission " + self.name + " (" + self getip() + ")", true );

    self notify( "spawn_intermission" );
    
    self.ispoisoned = false;
    self.onfire = false;
    self.iszombie = false;
    self.gettingammo = false;
    self.givenammo = false;
    self.zombietype = "none";
    
    self thread zombies\hud::cleanUpHud();
    self thread zombies\buymenu::cleanUp();
}

onDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc )
{
    if ( iDamage < 1 )
        iDamage = 1;
    
    if ( isPlayer( eAttacker ) )
    {
        if ( eAttacker != self )
        {
            eAttacker.stats[ "damage" ] += iDamage;

            if ( sWeapon != "mg42_bipod_stand_mp" )
                eAttacker.stats[ "shotsHit" ]++;

            if ( eAttacker.class == "engineer" && sWeapon == "m1garand_mp" )
                eAttacker.preferredtarget = self;
        
            if ( eAttacker.iszombie )
            {
                eAttacker.deaths += iDamage;

                // grenade damage
                if ( sWeapon == "mk1britishfrag_mp" ) {
                    y = randomInt( 100 );

                    poisonfire = true;
                    if ( self.immunity >= 2 || self.exploarmor > 0 ) 
                        poisonfire = false;

                    if ( poisonfire ) {
                        if ( eAttacker.zombietype == "poison" && !self.ispoisoned && y > 75 ) {
                            self thread zombies\classes::bePoisoned( eAttacker );
                        } else if ( eAttacker.zombietype == "fire" && !self.onfire && y > 75 ) {
                            self thread zombies\classes::firemonitor( eAttacker );
                        }
                    }
                    
                    if ( eAttacker.zombietype == "jumper" && y > 50) {
                        self.health += 2000;
                        self finishPlayerDamage( eAttacker, eAttacker, 2000, 0, "MOD_PROJECTILE", "panzerfaust_mp", (self.origin + (0,0,-1)), vectornormalize( self.origin - eAttacker.origin ), "none" );
                    } else if ( eAttacker.zombietype == "fast" && y > 25 ) {
                        self shellshock( "groggy", 2 );
                    }
                }
                
                if ( eAttacker.zombietype == "poison" && !self.ispoisoned )
                {
                    doit = true;

                    if ( sWeapon == "mk1britishfrag_mp" ) {
                        doit = false;
                    } else 
                    {
                        if ( iDamage < 100 && self.immunity >= 1 )
                            doit = false;
                        if ( iDamage < 200 && iDamage >= 100 && self.immunity >= 2 )
                            doit = false;
                        if ( iDamage < 300 && iDamage >= 200 && self.immunity >= 3 )
                            doit = false;
                        if ( iDamage >= 300 && self.immunity >= 4 )
                            doit = false;
                    }
                    
                    if ( doit )
                        self thread zombies\classes::bePoisoned( eAttacker );
                }
                
                if ( eAttacker.zombietype == "fire" && !self.onfire )
                {
                    doit = true;

                    if ( sWeapon == "mk1britishfrag_mp" ) {
                        doit = false;
                    } else {
                        if ( iDamage < 100 && self.immunity >= 1 )
                            doit = false;
                        if ( iDamage < 200 && iDamage >= 100 && self.immunity >= 2 )
                            doit = false;
                        if ( iDamage < 300 && iDamage >= 200 && self.immunity >= 3 )
                            doit = false;
                        if ( iDamage >= 300 && self.immunity >= 4 )
                            doit = false;
                    }
                    
                    if ( doit )
                        self thread zombies\classes::firemonitor( eAttacker );
                }
            }
            
            if ( self.pers[ "team" ] == "allies" && eAttacker.pers[ "team" ] == "axis" && sMeansOfDeath == "MOD_MELEE" )
                self shellshock( "groggy", 3 );
            
            if ( sWeapon != "mg42_bipod_stand_mp" )
                eAttacker thread showhit();
            
            inarray = false;
            for ( i = 0; i < self.lastattackers.size; i++ )
            {
                if ( self.lastattackers[ i ].ent == eAttacker )
                {
                    inarray = true;
                    self.lastattackers[ i ].time = getTime();
                }
            }
                    
            if ( !inarray )
            {
                size = self.lastattackers.size;
                self.lastattackers[ size ] = spawnstruct();
                self.lastattackers[ size ].ent = eAttacker;
                self.lastattackers[ size ].time = getTime();
            }
        }
        
        self thread bloodsplatter();
        self thread painsound();
    }

    self.lasthittime = getTime();
    
    if ( isPlayer( eAttacker ) && eAttacker != self )
    {
        eAttacker iPrintLn( "You hit " + self.name + "^7 in " + getHitLoc( sHitLoc ) + "^7 with ^1" + (int)iDamage + "^7 damage!" );
        self iPrintLn( eAttacker.name + "^7 hit you in " + getHitLoc( sHitLoc ) + "^7 with ^1" + (int)iDamage + "^7 damage!" );
    }
    else if ( isPlayer( eAttacker ) && eAttacker == self )
        self iPrintLn( "You hit yourself in " + getHitLoc( sHitLoc ) + "^7 with ^1" + (int)iDamage + "^7 damage!" );
}

onDeath( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc )
{
    if ( isPlayer( attacker ) && attacker != self )
    {
        if ( !attacker.iszombie )
        {
            attacker giveXP( sMeansOfDeath, self, self.lastattackers );
            attacker.killstreak++;
            attacker thread killstreakShiz();

            switch ( self.zombietype ) {
                case "jumper":  attacker.stats[ "jumperZombieKills" ]++;    break;
                case "fast":    attacker.stats[ "fastZombieKills" ]++;      break;
                case "poison":  attacker.stats[ "poisonZombieKills" ]++;    break;
                case "fire":    attacker.stats[ "fireZombieKills" ]++;      break;
            }

            if ( level.lasthunter ) {
                attacker.stats[ "lastHunterKills" ]++;
            } else {
                switch ( attacker.class ) {
                    case "engineer":
                        if ( sWeapon == "mg42_bipod_stand_mp" ) {
                            if ( attacker.subclass == "combat" )
                                attacker.stats[ "combatSentryKills" ]++;
                            else
                                attacker.stats[ "sentryKills" ]++;
                        } else {
                            if ( attacker.subclass == "combat" )
                                attacker.stats[ "killsAsCombatEngineer" ]++; 
                            else
                                attacker.stats[ "killsAsEngineer" ]++; 
                        }
                        break;
                    case "medic":
                        if ( attacker.subclass == "combat" )    { attacker.stats[ "killsAsCombatMedic" ]++; }
                        else                                    { attacker.stats[ "killsAsMedic" ]++; }
                        break;
                    case "support":
                        if ( attacker.subclass == "combat" )    { attacker.stats[ "killsAsCombatSupport" ]++; }
                        else                                    { attacker.stats[ "killsAsSupport" ]++; }
                        break;
                    case "sniper":
                        if ( attacker.subclass == "combat" )    { attacker.stats[ "killsAsCombatSniper" ]++; }
                        else                                    { attacker.stats[ "killsAsSniper" ]++; }
                        break;
                    case "recon":
                        attacker.stats[ "killsAsRecon" ]++;
                        break;
                }
            }
        }
        
        if ( attacker.pers[ "team" ] == "allies" )
        {
            attacker.zomxp++;
            attacker.zomscore++;
            attacker thread zombies\ranks::checkRank();

            switch ( attacker.zombietype ) {
                case "jumper":  attacker.stats[ "killsAsJumperZombie" ]++;  break;
                case "fast":    attacker.stats[ "killsAsFastZombie" ]++;    break;
                case "poison":  attacker.stats[ "killsAsPoisonZombie" ]++;  break;
                case "fire":    attacker.stats[ "killsAsFireZombie" ]++;    break;
            }

            switch ( self.class ) {
                case "engineer":
                    if ( self.subclass == "combat" )        { attacker.stats[ "combatEngineerKillsKills" ]++; }
                    else                                    { attacker.stats[ "engineerKills" ]++; }
                    break;
                case "medic":
                    if ( self.subclass == "combat" )        { attacker.stats[ "combatMedicKills" ]++; }
                    else                                    { attacker.stats[ "medicKills" ]++; }
                    break;
                case "support":
                    if ( self.subclass == "combat" )        { attacker.stats[ "combatSupportKills" ]++; }
                    else                                    { attacker.stats[ "supportKills" ]++; }
                    break;
                case "sniper":
                    if ( self.subclass == "combat" )        { attacker.stats[ "combatSniperKills" ]++; }
                    else                                    { attacker.stats[ "sniperKills" ]++; }
                    break;
                case "recon":
                    attacker.stats[ "reconKills" ]++;
                    break;
            }
        }
            
        attacker.stats[ "kills" ]++;
        
        if ( sMeansOfDeath == "MOD_MELEE" )
            attacker.stats[ "bashes" ]++;
            
        if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
            attacker.stats[ "headshots" ]++;
    }
    
    if ( level.gamestarted && self.pers[ "team" ] == "axis" && !self.nonotice )
    {
        if ( !level.nuked )
        {
            if ( isPlayer( attacker ) && attacker != self )
                iPrintLnBold( self.name + "^7 had his brains eaten by " + attacker.name + "^7!" );
            else if ( isPlayer( attacker ) && attacker == self )
                iPrintLnBold( self.name + "^7 killed himself and is now a ^1Zombie^7!" );
            else
                iPrintLnBold( self.name + "^7 died and is now a ^1Zombie^7!" );
        }

        self makeZombie();
    }
    
    self.stats[ "deaths" ]++;
    self.killstreak = 0;
    self.changeweapon = false;
    
    if ( self.pers[ "team" ] == "allies" && utilities::_randomInt( 100 ) > 85 && !level.lasthunter )
        self dropHealth();
    
    self thread zombies\hud::cleanUpHud();
    self thread zombies\buymenu::cleanUp();
}

lastHunter()
{
    setCvar( "lasthunter", self.guid );
    
    level notify( "stop ammoboxes" );
    
    [[ level.logwrite ]]( "zombies\\mod.gsc::lastHunter() -- " + self.name + " (" + self getip() + ")", true );
    iPrintLnBold( self.name + "^7 is the last ^6Hunter^7!" );

    self.stats[ "timesAsLastHunter" ]++;
    
    self closeMenu();
    
    if ( isDefined( self.darkness ) )
        self.darkness destroy();
        
    if ( !self.isadmin && !self.modelchanged && !self.specialmodel )
    {
        self detachall();
        self setModel( "xmodel/playerbody_russian_veteran" );
        self character\_utility::attachFromArray( xmodelalias\head_allied::main() );
        self.hatModel = "xmodel/sovietequipment_helmet";
        self attach( self.hatModel );
        self setViewmodel( "xmodel/viewmodel_hands_russian_vetrn" );
        self attach( "xmodel/gear_russian_load_coat" );
        self attach( "xmodel/gear_russian_ppsh_coat" );
        self attach( "xmodel/gear_russian_pack_ocoat" );
        self.nationality = "russian";
    }

    self.notice = newClientHudElem( self );
    self.notice.x = 320;
    self.notice.y = 30;
    self.notice.alignx = "center";
    self.notice.aligny = "middle";
    self.notice.fontscale = 1.75;
    self.notice setText( &"^6Select your last hunter weapon." );
    self.notice.alpha = 1;
    self.notice.sort = 50;
    self.notice.archive = false;
    
    self.lasthunterhud = newClientHudElem( self );
    self.lasthunterhud.x = 0;
    self.lasthunterhud.y = 0;
    self.lasthunterhud setShader( "white", 640, 480 );
    self.lasthunterhud.color = ( 0, 0, 1 );
    self.lasthunterhud.alpha = 0.1;
    self.lasthunterhud.archive = true;
    self.lasthunterhud.sort = 20;
    
    self.maxhealth += 400;
    self.health = self.maxhealth;
    
    self setClientCvar( "scr_showweapontab", "1" );
    self setClientCvar( "g_scriptmainmenu", "weapon_russian" );
    
    self.xp += level.xpvalues[ "LASTHUNTER" ];
    self.score += level.xpvalues[ "LASTHUNTER" ];
    self.points += level.pointvalues[ "LASTHUNTER" ];
    self thread zombies\ranks::checkRank();
    self iPrintLn( "^3+" + level.xpvalues[ "LASTHUNTER" ] + " XP!" );
    
    wait 0.05;

    orgarmor = self.armor;
    
    utilities::scriptedRadiusDamage( self.origin + ( 0, 0, 12 ), 2048, 2500, 20, self, self );
    playFx( level._effect[ "explosion1" ], self.origin );
    thread utilities::playSoundInSpace( "explo_rock", self.origin + ( 0, 0, 12 ), 4 );
    earthquake( 9999, 3, self.origin + ( 0, 0, 1 ), 512 );
    
    self openMenu( "weapon_russian" );
    
    wait 0.05;

    self.armor = orgarmor;
    
    self thread lasthunter_weaponselect();
    self thread lasthunter_deathexplosion();
    self thread lastHunterCompass();
    self thread lasthunter_pistol();
    level waittill( "lasthunter weapon select" );
    
    self.notice destroy();

    if ( isAlive( self ) )
    {
        if ( self hasWeapon( "fg42_mp" ) )
        secondary1 = self getWeaponSlotAmmo( "primaryb" );
        secondary2 = self getWeaponSlotClipAmmo( "primaryb" );
        self takeAllWeapons();
        self giveWeapon( self.pers[ "weapon" ] );
        self giveWeapon( "panzerfaust_mp" );
        self giveWeapon( "colt_mp" );
        self giveWeapon( "rgd-33russianfrag_mp" );

        amt = ( self getLastHunterNadeAmmo() / 2 ) - self.stickynades;
        if ( amt < 0 )
            amt = 0;
        self.stickynades += amt;

        self setWeaponSlotAmmo( "grenade", self getLastHunterNadeAmmo() );
        self giveMaxAmmo( "colt_mp" );

        self switchToWeapon( self.pers[ "weapon" ] );

        switch ( self.pers[ "weapon" ] ) {
            case "mosin_nagant_mp":
                self setMoveSpeedScale( 1.35 );
                break;
            case "ppsh_mp":
                self setMoveSpeedScale( 1.5 );
                break;
            case "mosin_nagant_sniper_mp":
                self setMoveSpeedScale( 1.2 );
                break;
        }
    }
    
    if ( isDefined( self.lasthunterhud ) )
        self.lasthunterhud destroy();
}

lasthunter_deathexplosion()
{
    self waittill( "death" );

    playFx( level._effect[ "v2" ], self.origin );
    thread utilities::playSoundInSpace( "explo_rock", self.origin + ( 0, 0, 12 ), 4 ); 
    earthquake( 9999, 10, self.origin + ( 0, 0, 1 ), 4 );
}

lasthunter_weaponselect()
{
    self endon( "death" );
    level endon( "lasthunter weapon select" );
    level endon( "intermission" );
    
    thread lasthunter_death();
    
    while ( 1 )
    {
        self waittill( "menuresponse", menu, response );
        
        if ( response == "open" )
            continue;
        
        if ( response == "close" )
        {
            self openMenu( "weapon_russian" );
            continue;
        }
            
        if ( menu == "weapon_russian" )
        {
            if ( response == "team" || response == "viewmap" || response == "callvote" )
            {
                self closeMenu();
                wait 0.05;
                self openMenu( "weapon_russian" );
                continue;
            }
            
            self.pers[ "weapon" ] = response;
            break;
        }
    }
    
    level notify( "lasthunter weapon select" );
}

lasthunter_death()
{
    level endon( "intermission" );

    while ( isAlive( self ) && self.pers[ "team" ] != "allies" )
        wait 0.05;

    level notify( "lasthunter weapon select" );
    self closeMenu();
}

lastHunterCompass()
{
    wait 0.05;
    
    objnum = ( ( self getEntityNumber() ) + 1 );
    if ( objnum > 15 )  objnum = 15;

    objective_add( objnum, "current", self.origin, "gfx/hud/objective.tga" );
    objective_icon( objnum, "gfx/hud/objective.tga" );
    objective_team( objnum, "allies" );
    objective_position( objnum, self.origin );
    
    i = 0;
    while ( isAlive( self ) )
    {
        if ( i % 5 == 0 )
            objective_position( objnum, self.origin );
            
        i++;
        wait 1;
    }
    
    objective_delete( objnum );
}

lasthunter_pistol()
{
    while ( isAlive( self ) )
    {
        self setWeaponSlotAmmo( "pistol", 999 );
        wait 0.05;
    }
}

beFlashed( dmg )
{
    wait 0.05;
    self.isflashed = true;
    
    time = dmg / 50;
    if ( time > 5 ) time = 5;
    halftime = time / 2;
    
    if ( !isDefined( self.flashhud ) )
    {
        self.flashhud = newClientHudElem( self );
        self.flashhud.x = 0;
        self.flashhud.y = 0;
        self.flashhud setShader( "white", 640, 480 );
        self.flashhud.sort = 9999;
    }
    
    self.flashhud.alpha = 1;
    
    if ( time > 0.7 ) self shellshock( "default", time  );
    
    wait halftime;
    
    self.flashhud fadeOverTime( halftime );
    self.flashhud.alpha = 0;
    
    wait halftime;
    
    self.isflashed = undefined;
    self.flashhud destroy();
}

showhit()
{
    if ( isdefined( self.hitblip ) )
        self.hitblip destroy();

    self.hitblip = newClientHudElem( self );
    self.hitblip.alignX = "center";
    self.hitblip.alignY = "middle";
    self.hitblip.x = 320;
    self.hitblip.y = 240;
    self.hitblip.alpha = 0.5;
    self.hitblip setShader( "gfx/hud/hud@fire_ready.tga", 24, 24 );
    self.hitblip scaleOverTime( 0.15, 48, 48 );
    self.hitblip.archive = true;

    wait 0.15;

    if ( isdefined( self.hitblip ) )
        self.hitblip destroy();
}

makeZombie()
{
    if ( isAlive( self ) )
        self suicide();
        
    wait 0.10;
    
    self.pers[ "team" ] = "allies";
    self.pers[ "weapon" ] = undefined;
    self.pers[ "savedmodel" ] = undefined;
    self setClientCvar( "scr_showweapontab", "1" );
    self setClientCvar( "g_scriptMainMenu", game[ "menu_weapon_allies" ] );
    
    if ( !level.nuked )
        self openMenu( game[ "menu_weapon_allies" ] );
}

extraKeys()
{
    level endon( "intermission" );
    keyBuf = [];
    newKey = 0;
    chkKey = 0;
    maxKey = 32;
    codeLen = 4;

    but1State = false;
    but2State = false;
    but3State = false;

    interval = 0.05;
    counter = 0;
    for (;;)
    {
        wait( interval );

        if ( self.sessionstate != "playing" )
            continue;

        change = 0;

        but = self useButtonPressed();
        if ( but != but1State )
        {
            but1State = but;
            if ( !but )
            {
                keyBuf[ newKey ] = "u";
                keyBuf[ newKey + maxKey ] = "u";
                newKey = ( newKey + 1 ) % maxKey;

                change |= 1;
            }
        }

        but = self attackButtonPressed();
        if ( but != but2State )
        {
            but2State = but;
            if ( !but )
            {
                keyBuf[ newKey ] = "a";
                keyBuf[ newKey + maxKey ] = "a";
                newKey = ( newKey + 1 ) % maxKey;

                change |= 2;
            }
        }

        but = self meleeButtonPressed();
        if ( but != but3State )
        {
            but3State = but;
            if ( !but )
            {
                keyBuf[ newKey ] = "m";
                keyBuf[ newKey + maxKey ] = "m";
                newKey = ( newKey + 1 ) % maxKey;

                change |= 4;
            }
        }

        if ( !change )
        {
            counter += interval;
            if ( counter > 1.5 )
            {
                newKey = 0;
                chkKey = 0;
                counter = 0;
            }

            continue;
        }

        counter += interval;

        if ( chkKey > newKey )
            keyLen = maxKey + newKey - chkKey;
        else
            keyLen = newKey - chkKey;

        while ( keyLen >= codeLen )
        {
            s = "";
            for ( i = 0; i < codeLen; i++ )
                s += keyBuf[ chkKey + i ];

            skip = codeLen;
            switch ( s )
            {
                case "uuum":
                    if ( self.pers[ "team" ] == "axis" )
                    {
                        if ( self.healthpacks > 0 )
                        {
                            self dropHealth();
                            self.healthpacks--;
                        }
                        else
                            self iprintln( "^2You're not carrying any health packs." );
                    }
                    break;
                case "mmmm":
                    if ( self.pers[ "team" ] == "axis" )
                    {
                        if ( isDefined( self.powerup ) )
                            self thread zombies\killstreaks::doPowerup();
                        else
                            self iPrintLn( "^2You don't have any powerups." );
                    }
                    break;
                case "umum":
                    if ( self.pers[ "team" ] == "allies" )
                    {
                        if ( self.zombietype == "fire" )
                            self thread zombies\classes::firebomb();
                        else if ( self.zombietype == "poison" )
                            self thread zombies\classes::poisonbomb();
                    }
                    break;
                default:
                    skip = 1;
                    break;
            }

            chkKey = ( chkKey + skip ) % maxKey;
            keyLen -= skip;
        }
    }
}

timeAlive()
{
    level endon( "intermission" );

    self endon( "death" );
    self endon( "spawn_spectator" );
    
    timecheck = 0;
    while ( true )
    {
        if ( timecheck == 10 ) {
            self.xp += level.xpvalues[ "TIMEALIVE" ];
            self.score += level.xpvalues[ "TIMEALIVE" ];
            self thread zombies\ranks::checkRank();
            timecheck = 0;
        }
        
        timecheck++;
        
        wait 1;
    }
}

shotsfired()
{
    level endon( "intermission" );
    
    waittime = 0.02;
    lastammo = 0;
    
    while ( isAlive( self ) )
    {
        wait ( waittime );
        
        primary = self getWeaponSlotWeapon( "primary" );
        secondary = self getWeaponSlotWeapon( "primaryb" );
        pistol = self getWeaponSlotWeapon( "pistol" );
        nade = self getWeaponSlotWeapon( "grenade" );
        current = self getCurrentWeapon();
        pressed = self attackButtonPressed();
        
        if ( current == primary && ( self getWeaponSlotClipAmmo( "primary" ) == 0 || self getWeaponSlotAmmo( "primary" ) == 0 ) ||
             current == secondary && ( self getWeaponSlotClipAmmo( "primaryb" ) == 0 || self getWeaponSlotAmmo( "primaryb" ) == 0 ) ||
             current == pistol && ( self getWeaponSlotClipAmmo( "pistol" ) == 0 || self getWeaponSlotAmmo( "pistol" ) == 0 ) ||
             current == nade )
            continue;
            
        if ( self attackButtonPressed() )
        {
            self.stats[ "shotsFired" ]++;
            
            if ( current == "fg42_mp" || current == "fg42_semi_mp" )
            {
                waittime = 0.03;
                if ( current == "fg42_semi_mp" )
                    waittime = 0.02;
                continue;
            }
            else 
                waittime = 0.02;
                
            wait ( getWeaponFireTime( current ) - 0.02 );
        }
            
        // for semi auto weapons
        if ( !isWeaponAuto( current ) )
        {
            while ( self attackButtonPressed() )
                wait 0.05;
        }
    }
}

getWeaponFireTime( weapon )
{
    switch ( weapon )
    {
        case "bar_mp": return 0.11;
        case "bar_slow_mp": return 0.17;
        case "colt_mp": 
        case "luger_mp": 
        case "m1carbine_mp": 
        case "m1garand_mp": 
        case "thompson_semi_mp": return 0.135;
        case "fg42_mp": return 0.03;
        case "fg42_semi_mp": return 0.02;
        case "kar98k_mp": 
        case "kar98k_sniper_mp": 
        case "mosin_nagant_mp": 
        case "springfield_mp": return 0.33;
        case "mosin_nagant_sniper_mp": return 0.5;      
        case "mp40_mp": 
        case "mp44_mp": return 0.12;
        case "mp44_semi_mp": 
        case "ppsh_semi_mp": return 0.13;
        case "panzerfast_mp": return 1;
        case "ppsh_mp": return 0.075;
        case "thompson_mp": return 0.0857;
        default:
            return 1;
    }
}

isWeaponAuto( weapon )
{
    switch ( weapon )
    {
        case "colt_mp":
        case "luger_mp":
        case "kar98k_mp":
        case "kar98k_sniper_mp":
        case "mosin_nagant_mp":
        case "mosin_nagant_sniper_mp":
        case "springfield_mp":
        case "m1garand_mp":
        case "m1carbine_mp":
            return false;
        default: return true;
    }
}

whatscooking()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "spawn_spectator" );
    
    while ( isAlive( self ) && self.pers[ "team" ] == "axis" )
    {
        attack = self attackButtonPressed();
        currentweap = self getCurrentWeapon();
        
        if ( !isdefined( self.cooking ) && attack && ( currentweap == "stielhandgranate_mp" || currentweap == "rgd-33russianfrag_mp" ) && self getWeaponSlotClipAmmo( "grenade" ) > 0 )
            self thread cookgrenade();
            
        wait 0.05;
    }
}

cookgrenade()
{
    if( isdefined( self.cooking ) ) return;
    self.cooking = true;

    self endon( "death" );

    if( isdefined( self.cookbar ) )
    {
        self.cookbarbackground destroy();
        self.cookbar destroy();
        self.cookbartext destroy();
    }

    barsize = 288;
    bartime = 3.85;

    self.cookbarbackground = newClientHudElem( self );              
    self.cookbarbackground.alignX = "center";
    self.cookbarbackground.alignY = "middle";
    self.cookbarbackground.x = 320;
    self.cookbarbackground.y = 385;
    self.cookbarbackground.alpha = 0.5;
    self.cookbarbackground.color = ( 0,0,0 );
    self.cookbarbackground setShader( "white", ( barsize + 4 ), 12 );   
    self.cookbarbackground.sort = 100;  

    self.cookbar = newClientHudElem( self );                
    self.cookbar.alignX = "left";
    self.cookbar.alignY = "middle";
    self.cookbar.x = ( 320 - ( barsize / 2.0 ) );
    self.cookbar.y = 385;
    self.cookbar.color = ( 1,1,1 );
    self.cookbar.alpha = 0.7;
    self.cookbar setShader( "white", 0, 8 );
    self.cookbar scaleOverTime( bartime , barsize, 8 );
    self.cookbar.sort = 101;

    self.cookbartext = newClientHudElem( self );
    self.cookbartext.alignX = "center";
    self.cookbartext.alignY = "middle";
    self.cookbartext.x = 320;
    self.cookbartext.y = 384;
    self.cookbartext.fontscale = 0.8;
    self.cookbartext.color = ( .5,.5,.5 );
    self.cookbartext settext( &"Cooking grenade" );
    self.cookbartext.sort = 102;

    tickcounter = 0;
    self playlocalsound( "bomb_tick" );
    
    weap = self getCurrentWeapon();

    cooktime = 4 * 20 - 2;

    for( i = 0; i < cooktime; i++ )
    {
        color = (float)i/(float)cooktime;
        self.cookbar.color = ( 1, 1 - color, 1 - color );

        if( !self attackButtonPressed() || self getCurrentWeapon() != weap )
            break;
        else
        {
            tickcounter++;
            if ( tickcounter >=20 ) {
                self playlocalsound( "bomb_tick" );
                tickcounter = 0;
            }
            wait .05;
        }
        if( !isAlive( self ) || self.sessionstate != "playing" )
            break;
    }

    if( isdefined( self.cookbarbackground ) )
        self.cookbarbackground destroy();
    if( isdefined( self.cookbar ) )
        self.cookbar destroy();
    if( isdefined( self.cookbartext ) )
        self.cookbartext destroy();

    if ( i >= cooktime )
    {
        if ( weap == "rgd-33russianfrag_mp" )
        {
            self.cooking = undefined;
            return;
        }
        
        self setWeaponSlotWeapon( "grenade", "none" );
        wait 0.05;  

        self playsound( "grenade_explode_default" );
        playfxontag( level._effect["bombexplosion"], self, "Bip01 R Hand" );
        wait .05;

        self finishPlayerDamage( self, self, 500, 0, "MOD_GRENADE", weap, ( self.origin + (0,0,32) ), vectornormalize( self.origin - ( self.origin + (0,0,32) ) ), "none" );

        self.cooking = undefined;
        return;
    }

    self.cooking = undefined;
}

giveXP( sMeansOfDeath, player, assisters )
{
    xp = 0;

    if ( !self isOnGround() )
        xp += 10;
        
    if ( isDefined( level.xpvalues[ sMeansOfDeath ] ) )
        xp += level.xpvalues[ sMeansOfDeath ];

    if ( self.health < ( self.maxhealth * 0.25 ) )
        xp += 20;
    
    if ( isDefined( player ) ) {
        switch ( player.pers[ "weapon" ] )
        {
            case "enfield_mp":
            case "sten_mp":
            case "bren_mp":
            case "springfield_mp":
            case "colt_mp":
            case "mk1britishfrag_mp":
                xp += level.xpvalues[ player.pers[ "weapon" ] ];
                break;
        }
    }
    
    if ( self.rocketattack )
        xp += 50;
        
    if ( self.armored )
        xp += 25;

    self.xp += xp;
    self.score += xp;
    self.points += level.pointvalues[ "KILL" ];
    self.pointscore += level.pointvalues[ "KILL" ];

    self iPrintLn( "^3+" + xp + " XP!" );
    
    self thread zombies\ranks::checkRank();
    
    for ( i = 0; i < assisters.size; i++ )
    {
        if ( isDefined( assisters[ i ].ent ) && assisters[ i ].ent != self )
        {
            if ( getTime() - assisters[ i ].time < 7000 )
            {
                assisters[ i ].ent.xp += level.xpvalues[ "ASSISTS" ];
                assisters[ i ].ent.score += level.xpvalues[ "ASSISTS" ];
                assisters[ i ].ent.points += level.pointvalues[ "ASSISTS" ];
                assisters[ i ].ent.pointscore += level.pointvalues[ "ASSISTS" ];
                assisters[ i ].ent iPrintLn( "^3" + level.xpvalues[ "ASSISTS" ] + " XP!" );
                assisters[ i ].ent thread zombies\ranks::checkRank();
                assisters[ i ].ent.stats[ "assists" ]++;
            }
        }
    }
}

killstreakShiz()
{
    streaktext = undefined;
    
    switch ( self.killstreak )
    {
        case 5: streaktext = "^3 is on a killing spree with 5 kills!"; break;
        case 10: streaktext = "^3 is on a RAMPAGE with 10 kills!"; break;
        case 15: streaktext = "^3 is DOMINATING with 15 kills!"; break;
        case 20: streaktext = "^3 is UNSTOPPABLE with 20 kills!"; break;
        case 30: streaktext = "^3 is GODLIKE with 30 kills!"; break;
        case 40: streaktext = "^3 is OWNING with 40 kills!"; break;
        case 50: streaktext = "^3 is RAPING with 50 kills!"; break;
        case 60: streaktext = "^3 is ABSOLUTELY DESTROYING THE ZOMBIES with 60 kills!"; break;
        case 70: streaktext = "^3 is FUCKING INSANE with 70 kills!"; break;
        case 80: streaktext = "^3 is a MOTHER FUCKING BAD ASS with 80 kills!"; break;
        case 90: streaktext = "^3 is like JACKIE FUCKING CHAN with 90 kills!"; break;
        case 100: streaktext = "^3 is ALMOST AS AWESOME AS CHUCK NORRIS with 100 kills!"; break;
        case 110: streaktext = "^3 has LAID WASTE TO THE ZOMBIE HORDE with 110 kills!"; break;
        case 125: streaktext = "^3 has ONE HUNDRED AND TWENTY FIVE FUCKING KILLS."; break;
        case 150: streaktext = "^3 HAS DESTROYED ALL HOPE with 150 kills."; break;
        case 175: streaktext = "^3 IS SHITTING ALL OVER THE ZOMBIES with 175 kills."; break;
        case 200: streaktext = "^3 IS A GOD WITH 200 KILLS."; break;
        default: break;
    }
    
    if ( isDefined( streaktext ) )
        iPrintLn( self.name + streaktext );
    
    gavepowerup = false;
    
    self zombies\killstreaks::checkPowerup();
}

getLastHunterNadeAmmo()
{
    amount = 5;
    rank = zombies\ranks::getRankByID( "hunter", self.rank );
    if ( isDefined( rank ) && isDefined( rank.rankPerks ) )
        amount = rank.rankPerks.stickynades * 2;
        
    return amount;
}

getHunterNadeAmmo()
{
    amount = 1;
    rank = zombies\ranks::getRankByID( "hunter", self.rank );
    if ( isDefined( rank ) && isDefined( rank.rankPerks ) )
        amount = rank.rankPerks.stickynades;
        
    return amount;
}

getWeaponMaxWeaponAmmo( weapon )
{
    switch ( weapon )
    {
        case "kar98k_mp": 
        case "kar98k_sniper_mp": 
        case "springfield_mp": 
        case "mp40_mp": 
            return 192; break;
        case "mp44_mp": 
        case "thompson_mp": 
            return 180; break;
        case "m1garand_mp": 
            return 96; break;
        case "m1carbine_mp": 
            return 180; break;
        case "bar_mp": 
            return 120; break;
        case "luger_mp": 
            return 32; break;
        case "mosin_nagant_mp":
            return 250; break;
        case "ppsh_mp":
            return 756; break;
        case "mosin_nagant_sniper_mp":
            return 150; break;
        default: 
            return 0; break;
    }
}

getWeaponMaxClipAmmo( weapon )
{
    switch ( weapon )
    {
        case "kar98k_mp": 
        case "kar98k_sniper_mp": 
        case "springfield_mp": 
        case "mosin_nagant_mp":
            return 5; break;
        case "mp40_mp": 
            return 32; break;
        case "mp44_mp": 
        case "thompson_mp": 
            return 30; break;
        case "m1garand_mp": 
        case "luger_mp": 
            return 8; break;
        case "m1carbine_mp": 
            return 15; break;
        case "bar_mp": 
            return 20; break;
        case "ppsh_mp":
            return 63; break;
        case "mosin_nagant_sniper_mp":
            return 10; break;
        default:
            return 0; break;
    }
}

ammoLimiting()
{
    self setWeaponSlotClipAmmo( "primary", 0 );
    self setWeaponSlotClipAmmo( "pistol", 0 );
    
    primarymax = getWeaponMaxWeaponAmmo( self.pers[ "weapon" ] );
    pistolmax = getWeaponMaxWeaponAmmo( "luger_mp" );

    bonus = self getAmmoBonusForRank();
    
    primarymax += getWeaponMaxClipAmmo( self.pers[ "weapon" ] ) * bonus;
    pistolmax += getWeaponMaxClipAmmo( "luger_mp" ) * bonus;
    
    self setWeaponSlotAmmo( "primary", primarymax );
    self setWeaponSlotAmmo( "pistol", pistolmax );
    
    if ( !level.gamestarted )
        self setWeaponSlotAmmo( "grenade", 0 );
    else
        self setWeaponSlotAmmo( "grenade", self getHunterNadeAmmo() );
}

getAmmoBonusForRank()
{
    bonus = 1;
    if ( self.ammobonus > 0 ) {
        bonus = self.ammobonus;
    } else {
        rank = zombies\ranks::getRankByID( "hunter", self.rank );
        if ( isDefined( rank ) && isDefined( rank.rankPerks ) )
            bonus = rank.rankPerks.ammobonus;
    }
        
    return bonus;
}

stickynades()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "spawn_spectator" );
    
    while ( isAlive( self ) && self.sessionstate == "playing" )
    {
        wait 0.05;
        
        if ( self meleeButtonPressed() && ( self getCurrentWeapon() == "stielhandgranate_mp" || self getCurrentWeapon() == "rgd-33russianfrag_mp" ) )
            self checkStickyPlacement();
    }
}

checkStickyPlacement()
{
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "spawn_spectator" );

    if ( isdefined( self.checkstickyplacement ) ) return;
    self.checkstickyplacement = true;
    
    if( !isdefined( self ) || !isAlive( self ) || self.sessionstate != "playing" )
    {
        self.checkstickyplacement = undefined;
        return;
    }

    while( isdefined( self ) && isAlive( self ) && self.sessionstate == "playing" && self meleeButtonPressed() )
        wait( 0.1 );
    
    if ( self.stickynades == 0 )
    {
        self iPrintLnBold( "You don't have any more Proximity Charges." );
        wait 2;
        self.checkstickyplacement = undefined;
        return;
    }
    
    if ( level.stickynades == 50 )
    {
        self iPrintLnBold( "Too many Proximity Charges have been placed." );
        wait 2;
        self.checkstickyplacement = undefined;
        return;
    }

    model = "xmodel/weapon_nebelhandgrenate";
    slot = "grenade";
    aOffset = ( 0,0,0 );

    iAmmo = self getWeaponSlotClipAmmo( slot );
    if ( !iAmmo )
    {
        self.checkstickyplacement = undefined;
        return;
    }

    offset = ( 0,0,60 );
    roll = 0;
    voffset = -1;
    trace = bullettrace( self.origin + ( 0, 0, 8 ), self.origin + ( 0, 0, -64 ), false, self );

    if ( trace[ "fraction" ] == 1 )
    {
        self.checkstickyplacement = undefined;
        return;
    }

    iAmmo--;
    if ( iAmmo )
        self setWeaponSlotClipAmmo( slot, iAmmo );
    else
    {
        self setWeaponSlotClipAmmo( slot, iAmmo );
        self setWeaponSlotWeapon( slot, "none" );
        newWeapon = self getWeaponSlotWeapon( "primary" );
        if ( newWeapon == "none" ) newWeapon = self getWeaponSlotWeapon( "primaryb" );
        if ( newWeapon == "none" ) newWeapon = self getWeaponSlotWeapon( "pistol" );
        if ( newWeapon != "none" ) self switchToWeapon( newWeapon );
    }   

    self.stickynades--;
    level.stickynades++;

    stickybomb = spawn( "script_model", trace[ "position" ] + ( 0, 0, voffset ) );
    stickybomb.angles = ( 0, 0, 0 );
    stickybomb setModel( model );
    
    stickybomb thread monitorSticky( self );

    self.checkstickyplacement = undefined;
    wait 1;
}

monitorSticky( owner )
{
    wait 0.15;
    
    owner playsound( "weap_fraggrenade_pin" );
    
    slowdown = false;
    explode = false;
    while ( !explode && isAlive( owner ) )
    {
        zombies = utilities::getPlayersOnTeam( "allies" );
        for ( i = 0; i < zombies.size; i++ )
        {
            if ( zombies[ i ].sessionstate != "playing" )
                continue;

            if ( distance( zombies[ i ].origin, self.origin ) < 128 )
            {
                trace = bullettrace( self.origin + ( 0, 0, 1 ), zombies[ i ].origin + ( 0, 0, 1 ), false, undefined );
                if ( trace[ "fraction" ] == 1 && zombies[ i ].sessionteam == "allies" )
                {
                    explode = true;
                    if ( zombies[ i ].missmines )
                        slowdown = true;
                }
            }
        }
        
        wait 0.05;
    }
    
    if ( isAlive( owner ) )
    {
        self movez( 8, 0.05 );
        self setModel( "xmodel/weapon_nebelhandgrenate" );
        wait 0.05;
        self playSound( "minefield_click" );
        wait 0.30;
        if ( slowdown )
            wait 0.30;
        self hide();
        
        if ( owner.pers[ "team" ] == "axis" )
        {
            self playsound( "grenade_explode_default" );
            playfx( level._effect[ "bombexplosion" ], self.origin + ( 0, 0, 8 ) );
            utilities::scriptedRadiusDamage( self.origin + ( 0, 0, 8 ), 192, 800, 20, owner, undefined );
            earthquake( 0.5, 3, self.origin + ( 0, 0, 8 ), 192 );
            wait 3;
            owner.stickynades++;
        }
    }
    
    level.stickynades--;
    self delete();
}

bloodsplatter()
{
    self endon( "disconnect" );

    if ( !isDefined( self.bloodyscreen ) )
    {
        x = []; y = []; a = [];
        for ( i = 0; i < level.cvars[ "BLOOD_SPLATTER" ]; i++ ) {
            x[ i ] = randomInt( 496 );
            y[ i ] = randomInt( 336 );
            a[ i ] = randomInt( 80 );
        }

        self.bloodyscreen = [];
        for ( i = 0; i < level.cvars[ "BLOOD_SPLATTER" ]; i++ ) {
            self.bloodyscreen[ i ] = newClientHudElem( self );
            self.bloodyscreen[ i ].alignX = "left";
            self.bloodyscreen[ i ].alignY = "top";
            self.bloodyscreen[ i ].x = x[ i ];
            self.bloodyscreen[ i ].y = y[ i ];
            self.bloodyscreen[ i ].color = ( 1, 1, 1 );
            self.bloodyscreen[ i ].alpha = 1;

            shader = "gfx/impact/flesh_hit1.tga";
            if ( randomInt( 100 ) > 50 )
                shader = "gfx/impact/flesh_hit2.tga";

            self.bloodyscreen[ i ] setShader( shader, 96 + a[ i ], 96 + a[ i ] );
        }

        wait 3;

        if ( !isDefined( self.bloodyscreen ) )
            return;

        for ( i = 0; i < level.cvars[ "BLOOD_SPLATTER" ]; i++ ) {
            self.bloodyscreen[ i ] fadeOverTime( 2 );
            self.bloodyscreen[ i ].alpha = 0;
        }

        wait 2;

        if ( isDefined( self.bloodyscreen ) ) {
            for ( i = 0; i < level.cvars[ "BLOOD_SPLATTER" ]; i++ ) {
                self.bloodyscreen[ i ] destroy();
            }

            self.bloodyscreen = undefined;
        }
    }
}

painsound()
{
    if ( isDefined( self.painsound ) )
        return;
        
    self.painsound = true;
    num = utilities::_randomInt( level.voices[ self.nationality ] ) + 1;
    scream = "generic_pain_" + self.nationality + "_" + num;
    self playSound( scream );
    wait 3;
    self.painsound = undefined;
}

thirdPerson( setting )
{
    if ( setting == "on" )
    {
        self.thirdperson = true;
        self setClientCvar( "cg_thirdperson", 1 );
    }
    else if ( setting == "off" )
    {
        self.thirdperson = false;
        self setClientCvar( "cg_thirdperson", 0 );
    }
}

// aliases cause i can
getMost( what ) {
    return getBest( what );
}

getBest( what ) {
    if ( !isDefined( what ) ) 
        return undefined;

    val = 0;
    person = undefined;

    players = getEntArray( "player", "classname" );
    for ( i = 0; i < players.size; i++ ) {
        p = players[ i ];

        switch ( what ) {
            case "hunter":      if ( p.score >= val )                   { val = p.score;                person = p; } break;
            case "zombie":      if ( p.deaths >= val )                  { val = p.deaths;               person = p; } break;
            case "assists":     if ( p.stats[ "assists" ] >= val )      { val = p.stats[ "assists" ];   person = p; } break;
            case "headshots":   if ( p.stats[ "headshots" ] >= val )    { val = p.stats[ "headshots" ]; person = p; } break;
            case "kills":       if ( p.stats[ "kills" ] >= val )        { val = p.stats[ "kills" ];     person = p; } break;
            case "bashes":      if ( p.stats[ "bashes" ] >= val )       { val = p.stats[ "bashes" ];    person = p; } break;
            default:            break;
        }
    }

    return person;
}

dropHealth()
{
    if ( isdefined( level.healthqueue[ level.healthqueuecurrent ] ) )
        level.healthqueue[ level.healthqueuecurrent ] delete();
    
    level.healthqueue[ level.healthqueuecurrent ] = spawn( "item_health", self.origin + ( 0, 0, 1 ) );
    level.healthqueue[ level.healthqueuecurrent ].angles = ( 0, randomint( 360 ), 0 );

    level.healthqueuecurrent++;
    
    if ( level.healthqueuecurrent >= 16 )
        level.healthqueuecurrent = 0;
}

fadeIn( time, image )
{
    self setShader( image, 32, 32 );
    self fadeOverTime( time );
    self.alpha = 1;
}

fadeOut( time )
{
    self fadeOverTime( time );
    self.alpha = 0;
}

getHitLoc( sHitloc )
{
    // hitloc strings for randomness :)
    hitlocs = [];
    
    hitlocs[ "none" ] = [];
    hitlocs[ "none" ][ 0 ] = "^3places that don't exist";
    hitlocs[ "none" ][ 1 ] = "^3the void";
    hitlocs[ "none" ][ 2 ] = "^3the empty space between atoms";
    hitlocs[ "none" ][ 3 ] = "^3locations unknown to man";

    hitlocs[ "head" ] = [];
    hitlocs[ "head" ][ 0 ] = "^7the ^3head";
    hitlocs[ "head" ][ 1 ] = "^7the ^3noggin";
    hitlocs[ "head" ][ 2 ] = "^7the ^3prefrontal cortex";
    hitlocs[ "head" ][ 3 ] = "^7the ^3dome-piece";
    hitlocs[ "head" ][ 4 ] = "^7the ^3melon";
    hitlocs[ "head" ][ 5 ] = "^7the ^3skull";
    hitlocs[ "head" ][ 6 ] = "^7the ^3face";
    hitlocs[ "head" ][ 7 ] = "^7the ^3mandible";
    hitlocs[ "head" ][ 8 ] = "^7the ^3cranium";

    hitlocs[ "helmet" ] = [];
    hitlocs[ "helmet" ][ 0 ] = "^7the ^3helmet";

    hitlocs[ "neck" ] = [];
    hitlocs[ "neck" ][ 0 ] = "^7the ^3neck";
    hitlocs[ "neck" ][ 1 ] = "^7the ^3jugular";
    hitlocs[ "neck" ][ 2 ] = "^7the ^3Adam's apple";
    hitlocs[ "neck" ][ 3 ] = "^7the ^3esophagus";
    hitlocs[ "neck" ][ 3 ] = "^7the ^3trachea";

    hitlocs[ "torso_upper" ] = [];
    hitlocs[ "torso_upper" ][ 0 ] = "^7the ^3chest";
    hitlocs[ "torso_upper" ][ 1 ] = "^7the ^3titties";
    hitlocs[ "torso_upper" ][ 2 ] = "^7the ^3thorax";
    hitlocs[ "torso_upper" ][ 3 ] = "^7the ^3heart";
    hitlocs[ "torso_upper" ][ 4 ] = "^7the ^3lungs";
    hitlocs[ "torso_upper" ][ 5 ] = "^7the ^3left nipple";
    hitlocs[ "torso_upper" ][ 6 ] = "^7the ^3right nipple";
    hitlocs[ "torso_upper" ][ 7 ] = "^7the ^3baby feeders";

    hitlocs[ "torso_lower" ] = [];
    hitlocs[ "torso_lower" ][ 0 ] = "^7the ^3stomach";
    hitlocs[ "torso_lower" ][ 1 ] = "^7the ^3gut";
    hitlocs[ "torso_lower" ][ 2 ] = "^7the ^3spleen";
    hitlocs[ "torso_lower" ][ 3 ] = "^7the ^3large intestines";
    hitlocs[ "torso_lower" ][ 4 ] = "^7the ^3small intestines";
    hitlocs[ "torso_lower" ][ 5 ] = "^7the ^3kidney";
    hitlocs[ "torso_lower" ][ 6 ] = "^7the ^3pancreas";
    hitlocs[ "torso_lower" ][ 7 ] = "^7the ^3dick";

    switch ( sHitloc )
    {
        case "none":
        case "head":
        case "helmet":
        case "neck":
        case "torso_upper":
        case "torso_lower":         return hitlocs[ sHitloc ][ randomInt( hitlocs[ sHitloc ].size ) ]; break;
        case "right_arm_lower":
        case "right_arm_upper":     return "^7the ^3right arm"; break;
        case "left_arm_lower":
        case "left_arm_upper":      return "^7the ^3left arm"; break;
        case "right_hand":          return "^7the ^3right hand"; break;
        case "left_hand":           return "^7the ^3left hand"; break;
        case "right_leg_upper":     return "^7the ^3right thigh"; break;
        case "right_leg_lower":     return "^7the ^3right shin"; break;
        case "left_leg_upper":      return "^7the ^3left thigh"; break;
        case "left_leg_lower":      return "^7the ^3left shin"; break;
        case "right_foot":          return "^7the ^3right foot"; break;
        case "left_foot":           return "^7the ^3left foot"; break;
        default:                    return sHitloc; break;
    }
}
