// Chat Commands Handler

// todo: better alias system
// todo: command logging for mods+
// todo: !stats

init() {
    if ( getCvar( "availablemaps" ) == "" )
        setCvar( "availablemaps", "mp_brecourt mp_harbor mp_carentan mp_depot mp_dawnville mp_railyard mp_powcamp mp_pavlov mp_rocket mp_hurtgen mp_ship mp_chateau" );
        
    // Permisions:
    // 0 = Guest 1 = VIP 2 = Moderator 3 = Admin 4 = God 

    // Add commands here
    // Arguments: <cmd> , <call> , <permissions> , <info> , <id-requirement>, <ignore-self>
    
    // Guest Commands //
    thread [[ level.chatCallback ]] ( "!login"         ,   ::chatcmd_login                         , 0 ,  "Access admin commands: !login [password]"          , 0      );
    thread [[ level.chatCallback ]] ( "!ebot"          ,   ::chatcmd_ebot                          , 0 ,  "Trigger e^2BOT ^7commands: !eBOT [command]"        , 0      );
    thread [[ level.chatCallback ]] ( "!help"          ,   ::chatcmd_help                          , 0 ,  "List of commands: !help <cmd>"                     , 0      );
    thread [[ level.chatCallback ]] ( "!alias"         ,   ::chatcmd_alias                         , 0 ,  "List of aliases: !alias <cmd>"                     , 0      );
    thread [[ level.chatCallback ]] ( "!tell"          ,   ::chatcmd_tell                          , 0 ,  "Private message a player: !tell [player] [msg]"    , -1 , 1 );
    thread [[ level.chatCallback ]] ( "!reply"         ,   ::chatcmd_reply                         , 0 ,  "Message last messaged player: !reply [msg]"        , 0      );
    thread [[ level.chatCallback ]] ( "!stats"         ,   ::zom_stats                             , 0 ,  "Get your current stats: !stats"                    , 0      );
    
    thread [[ level.chatCallback ]] ( "!name"          ,   ::chatcmd_name                          , 0 ,  "Rename yourself: !name [name]"                     , 0      );
    thread [[ level.chatCallback ]] ( "!buy"           ,   ::buymenu                               , 0 ,  "Buy an item: !buy [item]"                          , 0      );
    thread [[ level.chatCallback ]] ( "!random"        ,   ::buymenu_rnd                           , 0 ,  "Buy a random item: !random"                        , 0      );
    thread [[ level.chatCallback ]] ( "!healthpack"    ,   ::buymenu_hp                            , 0 ,  "Buy a health pack: !healthpack"                    , 0      );
    
    // VIP Commands //
    thread [[ level.chatCallback ]] ( "!fuck"          ,   ::vip_fuck                              , 1 ,  "Appreciate another player: !fuck [player]"         , -1     );
    thread [[ level.chatCallback ]] ( "!trout"         ,   ::vip_trout                             , 1 ,  "Slap another player: !trout [player]"              , -1     );
    thread [[ level.chatCallback ]] ( "!poke"          ,   ::vip_poke                              , 1 ,  "Poke another player: !poke [player]"               , -1     );
    thread [[ level.chatCallback ]] ( "!rainbow"       ,   ::vip_rainbow                           , 1 ,  "Color messages, the fancy way: !rainbow [msg]"     ,  0     );
    
    // Mod Commands //
    thread [[ level.chatCallback ]] ( "!status"        ,   ::chatcmd_status                        , 2 ,  "Print players info: !status"                       , 0      );
    thread [[ level.chatCallback ]] ( "!mute"          ,   ::chatcmd_mute                          , 2 ,  "Mute a player: !mute [player]"                     , 1 , 1  );
    thread [[ level.chatCallback ]] ( "!unmute"        ,   ::chatcmd_unmute                        , 2 ,  "Unmute a muted player: !unmute [player]"           , 1 , 1  );
    thread [[ level.chatCallback ]] ( "!warn"          ,   ::chatcmd_warn                          , 2 ,  "Warn a player: !warn [player] <msg>"               , 1 , 1  );
    thread [[ level.chatCallback ]] ( "!spectate"      ,   ::spectate_player                       , 2 ,  "Spectate player: !spectate [player]"               , 1 , 1  );
    
    // Admin Commands //
    thread [[ level.chatCallback ]] ( "!say"           ,   ::chatcmd_rconsay                       , 3 ,  "Talk as console: !say [msg]"                       , 0      );
    thread [[ level.chatCallback ]] ( "!kick"          ,   ::chatcmd_kick                          , 3 ,  "Kick a player: !kick [player] <msg>"               , 1 , 1  );
    thread [[ level.chatCallback ]] ( "!shout"         ,   maps\mp\gametypes\_admin::say           , 3 ,  "Shout a message: !shout [msg]"                     , 0      );
    thread [[ level.chatCallback ]] ( "!endgame"       ,   maps\mp\gametypes\_admin::endGame       , 3 ,  "End the map: !endgame"                             , 0      );
    
    thread [[ level.chatCallback ]] ( "!rename"        ,   maps\mp\gametypes\_admin::rename        , 3 ,  "Rename player: !rename [player] [name]"            , 1 , 1  );
    thread [[ level.chatCallback ]] ( "!id"            ,   ::getid                                 , 3 ,  "Get GUID: !id [player]"                            , 1      );
    thread [[ level.chatCallback ]] ( "!moveguid"      ,   maps\mp\gametypes\_admin::move_guid     , 3 ,  "Change player's guid: !moveguid [player]"          , 1      );  
    thread [[ level.chatCallback ]] ( "!kill"          ,   maps\mp\gametypes\_admin::kill          , 3 ,  "Kill a player: !kill [player]"                     , 1 , 1  );
    
    thread [[ level.chatCallback ]] ( "!giveweap"      ,   maps\mp\gametypes\_admin::giveWeap      , 3 ,  "Give a weapon: !giveweap [player] [weapon]"        , 1      );
    thread [[ level.chatCallback ]] ( "!drop"          ,   maps\mp\gametypes\_admin::drop          , 3 ,  "Drop a player: !drop [player] <height>"            , 1      );
    thread [[ level.chatCallback ]] ( "!giveks"        ,   maps\mp\gametypes\_admin::giveks        , 3 ,  "Give a killstreak: !giveks [player] [killstreak]"  , 1      );
    thread [[ level.chatCallback ]] ( "!givearmor" ,       maps\mp\gametypes\_admin::givearmor     , 3 ,  "Give armor: !givearmor [player] [amount]"          , 1      );
   
    thread [[ level.chatCallback ]] ( "!givexp"        ,   maps\mp\gametypes\_admin::giveXp        , 3 ,  "Give XP: !givexp [player] [amount]"                , 1      );
    thread [[ level.chatCallback ]] ( "!givekills"     ,   maps\mp\gametypes\_admin::giveKills     , 3 ,  "Give Kills: !givekills [player] [amount]"          , 1      );
    thread [[ level.chatCallback ]] ( "!givepoints"    ,   maps\mp\gametypes\_admin::givePoints    , 3 ,  "Give Points: !givepoints [player] [amount]"        , 1      );
    thread [[ level.chatCallback ]] ( "!updatexp"      ,   maps\mp\gametypes\_admin::updatexp      , 3 ,  "Update XP stats: !updatexp [player]"               , 1      );
    thread [[ level.chatCallback ]] ( "!updatekills"   ,   maps\mp\gametypes\_admin::updatekills   , 3 ,  "Update Kills stats: !updatekills [player]"         , 1      );
    
    thread [[ level.chatCallback ]] ( "!spank"         ,   maps\mp\gametypes\_admin::spank         , 3 ,  "Spank a player: !spank [player] [time]"            , 1      );
    thread [[ level.chatCallback ]] ( "!slap"          ,   maps\mp\gametypes\_admin::slap          , 3 ,  "Slap a player: !slap [player] [time]"              , 1      );
    thread [[ level.chatCallback ]] ( "!givexp"        ,   maps\mp\gametypes\_admin::giveXp        , 3 ,  "Give XP: !givexp [player] [amount]"                , 1      );
    thread [[ level.chatCallback ]] ( "!blind"         ,   maps\mp\gametypes\_admin::blind         , 3 ,  "Blind a player: !blind [player] [time]"            , 1      );
    thread [[ level.chatCallback ]] ( "!forcespec"     ,   maps\mp\gametypes\_admin::forcespec     , 3 ,  "Move player to spec: !forcespec [player]"          , 1      );

    thread [[ level.chatCallback ]] ( "!runover"       ,   maps\mp\gametypes\_admin::runover       , 3 ,  "Runover a player with tank: !runover [player]"     , 1      );
    thread [[ level.chatCallback ]] ( "!squash"        ,   maps\mp\gametypes\_admin::squash        , 3 ,  "Squash a player with tank: !squash [player]"       , 1      );
    thread [[ level.chatCallback ]] ( "!insult"        ,   maps\mp\gametypes\_admin::insult        , 3 ,  "Throw some insults: !insults [player]"             , 1      );
    thread [[ level.chatCallback ]] ( "!rape"          ,   maps\mp\gametypes\_admin::rape          , 3 ,  "Use with caution: !rape [player]"                  , 1      );

    thread [[ level.chatCallback ]] ( "!restart"       ,   ::map_restart                           , 3 ,  "Restart map: !restart"                             , 0      );
    thread [[ level.chatCallback ]] ( "!map"           ,   ::switch_map                            , 3 ,  "Change map: !map [mapname]"                        , 0      );

    // God Commands //
    thread [[ level.chatCallback ]] ( "!resetlogins"   ,   ::chatcmd_resetlogins                  , 4 ,   "Resets ALL current logins and cvars: !resetlogins"  , 0  );
    thread [[ level.chatCallback ]] ( "!resetplayer"   ,   ::chatcmd_resetplayer                  , 4 ,   "Resets player's permisions: !resetplayer [player]"  , 1  );
    thread [[ level.chatCallback ]] ( "!resetgroup"    ,   ::chatcmd_resetgroup                   , 4 ,   "Resets group's logins: !resetgroup [group]"         , 0  );
    
    // Aliases // 
    addAlias( "!login"        , "!log"     );
    addAlias( "!help"         , "!? !h"    );
    addAlias( "!alias"        , "!a"       );
    addAlias( "!tell"         , "!msg !t"  );
    addAlias( "!reply"        , "!r"       );
    addAlias( "!say"          , "!s"       );
    addAlias( "!status"       , "!st"      );
    addAlias( "!fuck"         , "!f"       ); 
    addAlias( "!poke"         , "!p"       );
    addAlias( "!trout"        , "!tr"      );
    addAlias( "!rainbow"      , "!rb"      );
    addAlias( "!shout"        , "!sh"      );
    addAlias( "!slap"         , "!sl"      );
    addAlias( "!spank"        , "!sp"      );
    addAlias( "!mute"         , "!m"       );
    addAlias( "!unmute"       , "!um"      );
    addAlias( "!kick"         , "!k"       );
    addAlias( "!kill"         , "!ki"      );
    addAlias( "!warn"         , "!w"       );
    addAlias( "!spectate"     , "!spec"    );
    addAlias( "!endgame"      , "!eg"      );
    addAlias( "!forcespec"    , "!fs"      );
    addAlias( "!giveweap"     , "!gwp"     );
    addAlias( "!givexp"       , "!gxp"     );
    addAlias( "!givepoints"   , "!gpt"     );
    addAlias( "!givekills"    , "!gki"     );
    addAlias( "!giveks"       , "!gks"     );
    addAlias( "!givearmor"    , "!garm"    );
    addAlias( "!updatexp"     , "!uxp"     );
    addAlias( "!updatekills"  , "!uki"     );
    addAlias( "!resetlogins"  , "!rlog"    );
    addAlias( "!resetplayer"  , "!rpl"     );
    addAlias( "!resetgroup"   , "!rgr"     );
    addAlias( "!buy"          , "!b"       );
    addAlias( "!random"       , "!rnd"     );
    addAlias( "!healthpack"   , "!hp"      );
}

addAlias( command, alias ) {
    if ( !isDefined( level.chatcommand[ command ] ) )
        return;

    level.helpcommand[ getCommandID( command ) ].alias = alias;
    level.chatcommand[ command ].alias = alias;
    
    aliases = StTok( alias, " " );
    for ( i = 0; i < aliases.size; i++ )
        level.chatcommand[ aliases[ i ] ] = level.chatcommand[ command ];

    //printconsole( "\ncommand id " + getCommandID( command ) + ": command size " + level.chatcommand.size + "\n");
}

getCommandID( command ) {
    id = 0;
    //printconsole( "\nlevel.helpcommand.size = " + level.helpcommand.size + "\n" );
    for ( i = 0; i < level.helpcommand.size; i++ ) {
        if ( isDefined ( level.helpcommand[ i ].cmd ) && command == level.helpcommand[ i ].cmd ) {
            id = i;
            break;
        }
    }
    return id;
}

chatcmd_help( tok ) {
    // specific command help
    if ( tok.size > 1 )
    {
        cmd = "!" + tok;
        if ( isDefined( level.chatcommand[ cmd ] ) ) {
            self playerMsg( level.chatcommand[ cmd ].info );
        }
        return;
    }
    
    line = 7;
    linemsg = "";
    num = 0;
    for ( i = 0; i < level.helpcommand.size; i++ ) {
        if ( !isDefined( level.helpcommand[ i ] ) || self.permissions < level.helpcommand[ i ].permissions )
            continue;
            
        if ( num > 0 && num % line == 0 )
        {
            self playerMsg ( linemsg );
            linemsg = "";
        }
        
        if ( isDefined( level.helpcommand[ i ] ) )
            linemsg += level.helpcommand[ i ].cmd + "  ";
        
        num ++;
        wait .05;
    }
    
    if ( linemsg != "" )
        self playerMsg ( linemsg );
}

chatcmd_ebot( tok ) {
    cmd = "eBOT " + tok;
    self setClientCvar( "name" , cmd );
}

chatcmd_login( tok ) {
    tok = callback::strip( tok );
    if ( tok == "" ) {
        self playerMsg( "Please enter a password: !login [password]" );
        return;
    }
   
    // Different passwords for each permission level till mysql integration
    passwords = Array( level.permission_pws );
    // Set each time for on the fly password changes
    
    login = false;
    //if ( isDefined ( self.permissions ) )
    //    self playerMsg( "Already Logged In!" );
    for ( i = 1; i < passwords.size; i++ ) {
        //printconsole( "\n" + passwords[i] + ": " + getCvar ( passwords[ i ] ) + "\n" );
        if ( getCvar( passwords[i] ) != "" && tok == getCvar( passwords[i] ) ) {
            if ( isDefined ( level.permissions ) )
                self [[ level.permissions[i].call ]]();
            self.permissions = i;
            login = true;
            self playerMsg( "Logged in sucessfully as " + ucfirst( level.permissions[i].name ) + "!" );
            break;
        }
    }

    if ( !login )
        self playerMsg( "Login Unsuccessful!" );
}

chatcmd_status ( tok ) {
    line = 5;
    linemsg = "";
    players = getEntArray( "player", "classname" );
    for (i = 0; i < players.size; i++) {
        name = players[ i ].name;
        id = players[ i ] getEntityNumber();
        if ( i > 0 && i % line == 0 )
        {
            self playerMsg ( linemsg );
            linemsg = "";
        }
        linemsg += "^7" + name + " ^3[" + id + "]   ";
        wait .05;
    }
        
    if ( linemsg != "" )
        self playerMsg ( linemsg );
}

chatcmd_rconsay ( tok ) {
    sendservercommand("i \"^7[ "+self.name+" ]: "+tok+"\"");
}

chatcmd_alias ( tok ) {
    // specific command help
    if ( tok.size > 1 ) {
        cmd = "!" + tok;
        if ( isDefined( level.chatcommand[ cmd ] ) && isDefined( level.chatcommand[ cmd ].alias ) ) {
            self playerMsg( "Alias of " + cmd + ": ^7" + level.chatcommand[ cmd ].alias );
        }
        return;
    }
    
    line = 5;
    linemsg = "";
    
    num = 0;
    for ( i = 0; i < level.helpcommand.size; i++ ) {
        if ( !isDefined( level.helpcommand[ i ].alias ) || self.permissions < level.helpcommand[ i ].permissions )
            continue;
            
        if ( num > 0 && num % line == 0 ) {
            self playerMsg ( linemsg );
            linemsg = "";
        }
        
        if ( isDefined( level.helpcommand[ i ]) )
            linemsg += "^3" + level.helpcommand[ i ].cmd + ":^7" + level.helpcommand[ i ].alias + " ";
        
        num ++;
        wait .05;
    }
    
    if ( linemsg != "" )
        self playerMsg ( linemsg );
    
}

chatcmd_kick ( tok ) {
    args = StTok( tok, " ", 1 );
    kickmsg = "^3You have been kicked";
    if ( isDefined ( args[ 1 ] ) ) {
        msg = args[ 1 ];
        kickmsg = "You have been kicked for: ^3" + msg;
    }
    
    player = getPlayerById( args[ 0 ] );
    if ( isDefined ( player ) )
        player dropclient ( kickmsg );
}

chatcmd_warn ( tok ) {
    args = StTok( tok, " ", 1 );
    warnmsg = "^7You have been warned!";
    if ( isDefined ( args[ 1 ] ) )
        warnmsg = "^7You have been warned for: ^3"+args[ 1 ];
    //printconsole( args[1] );
    
    player = getPlayerById( args[ 0 ] );
    if ( isDefined ( player ) )
        player playerMsg ( warnmsg );
}

chatcmd_mute ( tok ) {
    player = getPlayerById( tok );
    if ( isDefined ( player ) && player != self ) {
        player.muted = true;
        player playerMsg( "You have been muted by " + self.name );
    }
}

chatcmd_unmute ( tok ) {
    player = getPlayerById( tok );
    if ( isDefined ( player ) && player.muted ) {
        player.muted = false;
        player playerMsg( "You have been unmuted by " + self.name );
    }
}

chatcmd_resetplayer ( tok ) {
    player = getPlayerById( tok );
    if ( isDefined ( player ) && player != self ) {
        player.permissions = 0;
        self playerMsg("Permissions have been reset for " + player.name);
    }
}

chatcmd_resetgroup ( tok ) {
    if ( tok == "" ) {
        self playerMsg( "Unspecified group" );
        return;
    }
    
    id = getGroupID( tok );
    if ( !isDefined( id ) ) {
        self playerMsg( "Unknown group: " + tok );
        return;
    }
    
    ipCvar = tolower( tok ) + "IP";
    setCvar( ipCvar, "" );
    
    players = getEntArray( "player", "classname" );
    
    for ( i = 0; i < players.size; i++ ) {
        if ( self != players[ i ] && isDefined( players[ i ] ) && players[ i ].permissions == id )
           players[ i ].permissions = 0;
    }
    self playerMsg( "All logins have been reset for group: " + tok );
}

getGroupID ( group ) {
    id = undefined;
    for ( i = 0; i < level.permissions.size; i++ ) {
        if ( isDefined( level.permissions[ i ] ) && level.permissions[ i ].name == group ) {
            id = i;
            break;
        }
    }
    return id;
}

chatcmd_resetlogins ( tok ) {

    // reset player permissions except self
    players = getEntArray( "player", "classname" );
    for ( i = 0; i < players.size; i++ ) {
        if ( self != players[ i ] && isDefined( players[ i ] ) )
           players[ i ].permissions = 0;
    }
    
    // reset ip and pw cvars
    ips = Array( level.permission_ips );
    pws = Array( level.permission_pws );
    
    for ( i = 1; i < ips.size; i++ ) {
        if ( isDefined( ips[ i ] ) )
            setCvar( ips[ i ], "" );
    }
    
    for ( i = 1; i < pws.size; i++ ) {
        if ( isDefined( pws[ i ] ) )
            setCvar( pws[ i ], "" );
    }
    
    self playerMsg( "All logins reset!" );
}

chatcmd_name( tok ) {
    self setClientCvar( "name", tok );
}

chatcmd_tell( tok ) {
    if ( tok != "" ) {
        args = StTok( tok, " ", 1 );
        if ( isDefined ( args[ 1 ] ) ) {
            player = getPlayerById( args[ 0 ] );
            if ( isDefined ( player ) ) {
                msg = args[ 1 ];
                self.lastContact = player;
                self privateMsg( tok, self, "^5-> ^3[PM]" );
                player privateMsg( tok, self, "^3[PM]" );
                return;
            }
        }
    }
    
    self playerMsg( "Please enter specified arguments: !tell [player] [message]" );
}

chatcmd_reply( tok ) {
    if ( !isDefined( self.lastContact ) || tok == "" ) {
        self playerMsg( "Previous contact not found!" );
        return;
    }
    self privateMsg( tok, self, "^5-> ^3[PM]" );
    self.lastContact privateMsg( tok, self, "^3[PM]" );
}

privateMsg( msg, from, prefix ) {
    self sendservercommand( "i \"^1^7" + prefix + " ^7" + from.name + " " + from.suffix + "^7: ^3" + msg + "\"" );
}

zom_stats ( tok ) {
    // todo //
}

buymenu( tok ) {
    if ( tok == "" ) {
        self playerMsg( "Buy Menu -- Available items" );
        self playerMsg( "armor (100, 250, 500), explosionarmor (100, 250, 500 or just 'explo'), damage (10 or 25)" );
        self playerMsg( "healthpack (hp), proxy, crate, barrel, panzerfaust, flashbangs, rocket, mortar, artillery" );
        self playerMsg( "gatlin, airstrike, carpetbomb, nuke, or random" );
        return;
    }

    item = tok;
    switch ( item ) {
        case "armor":
        case "armor100":            item = "buy_armor_10"; break;
        case "armor250":            item = "buy_armor_25"; break;
        case "armor500":            item = "buy_armor_50"; break;
        case "explo":
        case "explo100":
        case "explosionarmor":  
        case "explosionarmor100":   item = "buy_explo_10"; break;
        case "explo250":
        case "explosionarmor250":   item = "buy_explo_25"; break;
        case "explo500":
        case "explosionarmor500":   item = "buy_explo_50"; break;
        case "dmg":
        case "dmg10":
        case "damage":
        case "damage10":            item = "buy_damage_10"; break;
        case "dmg25":
        case "damage25":            item = "buy_damage_25"; break;
        case "hp":
        case "health":
        case "healthpack":          item = "buy_healthpack"; break;
        case "proxy":               item = "buy_proxy"; break;
        case "crate":               item = "buy_crate"; break;
        case "barrel":              item = "buy_barrel"; break;
        case "panzer":
        case "panzerfaust":         item = "buy_panzer"; break;
        case "flashbangs":          item = "buy_flashnades"; break;
        case "random":
        case "rocket":
        case "mortar":
        case "artillery":
        case "gatlin":
        case "airstrike":
        case "carpetbomb":
        case "nuke":                break;
        default:                    self playerMsg( "Buy Menu -- unknown item: " + item ); return; break;
    }

    self maps\mp\gametypes\_buymenu::buymenu( item );
}

buymenu_rnd( tok ) {
    self maps\mp\gametypes\_buymenu::buymenu( "random" );
}

buymenu_hp( tok ) {
    self maps\mp\gametypes\_buymenu::buymenu( "buy_healthpack" );
}

map_restart( tok ) {
    setCvar( "sv_maprotationcurrent", "" );
    sendservercommand( "i \"^7[Zombot]: ^3Restarting map...\"" );

    wait 3;

    exitLevel( false );
}

switch_map( tok ) {
    if ( tok == "" )
        return;

    tok = tolower( tok );
    maps = Array( getCvar( "availablemaps" ) );
    found = [];
    for ( i = 0; i < maps.size; i++ ) {
        if ( callback::contains( maps[ i ], tok ) ) {
            found[ found.size ] = maps[ i ];
        }
    }

    if ( found.size < 1 ) {
        self playerMsg( "Unknown map: " + tok );
        return;
    }

    if ( found.size > 1 ) {
        self playerMsg( "Multiple maps found: " );

        maplist = "";
        first = true;
        for ( i = 0; i < found.size; i++ ) {
            if ( !first ) {
                maplist += ", " + found[ i ];
            }
            else {
                first = false;
                maplist += found[ i ];
            }
        }

        self playerMsg( maplist );
        return;
    }

    if ( isDefined( found[ 0 ] ) ) {
        map = found[ 0 ];

        setCvar( "sv_maprotationcurrent", " gametype zombies map " + map );
        sendservercommand( "i \"^7[Zombot]: ^3Switching map to " + map + "...\"" );

        wait 3;

        exitLevel( false );
    }
}

spectate_player( tok ) {
    player = getPlayerById( tok );
    if ( isDefined ( player ) && player.sessionstate == "playing" && player != self ) {
        self.specplayer = player getEntityNumber();
        wait 0.05;
        self maps\mp\gametypes\zombies::spawnSpectator();
    }
}

vip_fuck( tok ) {
    player = getPlayerById( tok );
    if ( isDefined ( player ) ) {
        if ( player == self ) {
            self playerMsg( "If you want to fuck yourself, get off CoD and rub one out." );
            return;
        }
        
        msgs = Array( "brutally raped,repeatedly mauled,precisely tucked,fucked up,gracefully shagged,slowly screwed,casually nailed,widened the butthole of,cleaned the asshole of,walloped", "," );
        sufMsgs = Array( "for being a little bitch.,like a bitch they are.,on the floor.,under the sink.,at their mum's.,in public.,over dinner.,with a club.,with love.,with appreciation.,for being loyal.,for appreciating.,in a heartbeat.,for being a retard.,FOR SPARTA!,in front of their dog.,with their dog.", "," );
        victim = player.name;
        inflictor = self.name;
        if ( self.permissions < player.permissions ) {
            victim = self.name;
            inflictor = player.name;
        }
        serverMsg( inflictor + " ^3" + msgs[ randomInt( msgs.size ) ] + " " + victim + " ^3" + sufMsgs[ randomInt( sufMsgs.size ) ] );
    }
}

vip_trout( tok ) {
    player = getPlayerById( tok );
    if ( isDefined( player ) ) {
        if ( player == self ) {
            serverMsg( self.name + " ^3slaps himself with his limp dick" );
            return;
        }
        serverMsg( self.name + " ^3slaps " + player.name + " ^3around a bit with a large trout." );
    }
}

vip_poke( tok ) {
    player = getPlayerById( tok );
    if ( !isDefined( player ) )
        return;

    if ( player == self ) {
        serverMsg( self.name + " ^3poked himself in the eye!" );
        return;
    }
    
    self playerMsg( "You poked " + player.name + "^3!" );
    player playerMsg( self.name + " ^3poked you!" );
}

vip_rainbow ( tok ) {
    colorMsg = colorMsg( tok );
    self privateMsg( colorMsg, self, "" );
}

colorMsg ( msg ) {
    temp = "";
    for ( i = 0; i < msg.size; i++ ) {
        if ( msg[ i ] == " " ) {
            temp += " ";
            continue;
        }
        
        randColor = "^" + [[ level.utility ]]( "_randomIntRange", 1, 7 );
        temp += randColor + msg[ i ]; 
        wait .05;
    }
    return temp;
}

getid( tok ) {
    player = getPlayerById( tok );
    if ( isDefined( player ) ) {
        guid = [[ level.utility ]]( "getNumberedName", player.name );
        self playerMsg( player.name + "^7's ID is " + guid );
    }
}

Array( str, delim )
{
    if ( !isDefined( delim ) )
        return StTok( str, " " );
    return StTok( str, delim );
}

getPlayerById( id ) {
    return [[ level.utility ]]( "getPlayerByID", id );
}

playerMsg( msg ) {
    self callback::playerMsg( msg );
}

serverMsg( msg ) {
    sendservercommand( "i \"^7[Zombot]: ^3"+msg+"\"" );
}

StTok( s, delimiter, num ) {
    return [[ level.utility ]]( "explode", s, delimiter, num );
}