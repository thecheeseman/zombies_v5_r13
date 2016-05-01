/*
    The MIT License (MIT)

    Copyright (c) 2016 Indy

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    More information can be acquired at https://opensource.org/licenses/MIT
*/

init() {
    if ( getCvar( "availablemaps" ) == "" )
        setCvar( "availablemaps", "mp_brecourt mp_harbor mp_carentan mp_depot mp_dawnville mp_railyard mp_powcamp mp_pavlov mp_rocket mp_hurtgen mp_ship mp_chateau" );
        
    // bot setup
    level.cocoBot = getCvar( "coco_botname" );
    level.cocoColor = getCvar( "coco_messagecolor" );
    if ( level.cocoColor == "" )
        level.cocoColor = "^3";
     
    // Permisions:
    // 0 = Guest 1 = VIP 2 = Moderator 3 = Admin 4 = God 

    // Arguments: <cmd> , <call> , <permissions> , <info> , <id-requirement[1]>, <ignore-self [1] | codam-command [-1]> 
    // Guest Commands //
    thread [[ level.chatCallback ]] ( "!login"         ,   ::chatcmd_login          , 0 ,  "Access admin commands: !login [password]"          , 0      );
    thread [[ level.chatCallback ]] ( "!ebot"          ,   ::chatcmd_ebot           , 0 ,  "Trigger e^2BOT ^7commands: !eBOT [command]"        , 0      );
    thread [[ level.chatCallback ]] ( "!help"          ,   ::chatcmd_help           , 0 ,  "List of commands: !help <cmd>"                     , 0      );
    thread [[ level.chatCallback ]] ( "!alias"         ,   ::chatcmd_alias          , 0 ,  "List of aliases: !alias <cmd>"                     , 0      );
    thread [[ level.chatCallback ]] ( "!tell"          ,   ::chatcmd_tell           , 0 ,  "Private message a player: !tell [player] [msg]"    , -1 , 1 );
    thread [[ level.chatCallback ]] ( "!reply"         ,   ::chatcmd_reply          , 0 ,  "Message last messaged player: !reply [msg]"        , 0      );
    thread [[ level.chatCallback ]] ( "!name"          ,   ::chatcmd_name           , 0 ,  "Rename yourself: !name [name]"                     , 0      );
    
    // VIP Commands //
    thread [[ level.chatCallback ]] ( "!fuck"          ,   ::vip_fuck               , 1 ,  "Appreciate another player: !fuck [player]"         , -1     );
    thread [[ level.chatCallback ]] ( "!trout"         ,   ::vip_trout              , 1 ,  "Slap another player: !trout [player]"              , -1     );
    thread [[ level.chatCallback ]] ( "!poke"          ,   ::vip_poke               , 1 ,  "Poke another player: !poke [player]"               , -1     );
    thread [[ level.chatCallback ]] ( "!rainbow"       ,   ::vip_rainbow            , 1 ,  "Color messages, the fancy way: !rainbow [msg]"     ,  0     );
    
    // Mod Commands //
    thread [[ level.chatCallback ]] ( "!status"        ,   ::chatcmd_status         , 2 ,  "Print players info: !status"                       , 0      );
    thread [[ level.chatCallback ]] ( "!mute"          ,   ::chatcmd_mute           , 2 ,  "Mute a player: !mute [player]"                     , 1 , 1  );
    thread [[ level.chatCallback ]] ( "!unmute"        ,   ::chatcmd_unmute         , 2 ,  "Unmute a muted player: !unmute [player]"           , 1 , 1  );
    thread [[ level.chatCallback ]] ( "!warn"          ,   ::chatcmd_warn           , 2 ,  "Warn a player: !warn [player] <msg>"               , 1 , 1  );
    thread [[ level.chatCallback ]] ( "!spectate"      ,   ::spectate_player        , 2 ,  "Spectate player: !spectate [player]"               , 1 , 1  );
    
    // Admin Commands //
    thread [[ level.chatCallback ]] ( "!say"           ,   ::chatcmd_rconsay        , 3 ,  "Talk as console: !say [msg]"                       , 0      );
    thread [[ level.chatCallback ]] ( "!kick"          ,   ::chatcmd_kick           , 3 ,  "Kick a player: !kick [player] <msg>"               , 1 , 1  );
    thread [[ level.chatCallback ]] ( "!shout"         ,   admin::say               , 3 ,  "Shout a message: !shout [msg]"                     , 0      );
    thread [[ level.chatCallback ]] ( "!endgame"       ,   admin::endGame           , 3 ,  "End the map: !endgame"                             , 0      );
    thread [[ level.chatCallback ]] ( "!suffix"       ,    ::vip_suffix             , 3 ,  "Toggle or change your Suffix: !suffix <tag>"       , 0     );
    
    thread [[ level.chatCallback ]] ( "!rename"        ,   admin::rename            , 3 ,  "Rename player: !rename [player] [name]"            , 1 , 1  ); 
    thread [[ level.chatCallback ]] ( "!kill"          ,   admin::kill              , 3 ,  "Kill a player: !kill [player]"                     , 1 , 1  );
    
    thread [[ level.chatCallback ]] ( "!giveweap"      ,   admin::giveWeap          , 3 ,  "Give a weapon: !giveweap [player] [weapon]"        , 1      );
    thread [[ level.chatCallback ]] ( "!drop"          ,   admin::drop              , 3 ,  "Drop a player: !drop [player] <height>"            , 1      );
    
    thread [[ level.chatCallback ]] ( "!spank"         ,   admin::spank             , 3 ,  "Spank a player: !spank [player] [time]"            , 1      );
    thread [[ level.chatCallback ]] ( "!slap"          ,   admin::slap              , 3 ,  "Slap a player: !slap [player] [time]"              , 1      );
    thread [[ level.chatCallback ]] ( "!blind"         ,   admin::blind             , 3 ,  "Blind a player: !blind [player] [time]"            , 1      );

    thread [[ level.chatCallback ]] ( "!runover"       ,   admin::runover           , 3 ,  "Runover a player with tank: !runover [player]"     , 1      );
    thread [[ level.chatCallback ]] ( "!squash"        ,   admin::squash            , 3 ,  "Squash a player with tank: !squash [player]"       , 1      );
    thread [[ level.chatCallback ]] ( "!insult"        ,   admin::insult            , 3 ,  "Throw some insults: !insults [player]"             , 1      );
    thread [[ level.chatCallback ]] ( "!rape"          ,   admin::rape              , 3 ,  "Use with caution: !rape [player]"                  , 1      );
    
    // CoDaM Commands
    if ( getCvar( "coco_codam" ) != "" ) {
    
    thread [[ level.chatCallback ]] ( "!noclan"        ,   ::chatcmd_codam          , 3 ,  "Move non-clan players to team: !noclan [team]"     , 0 , -1 );
    thread [[ level.chatCallback ]] ( "!swapteams"     ,   ::chatcmd_codam          , 3 ,  "Swap teams: !swapteams"                            , 0 , -1 );
    thread [[ level.chatCallback ]] ( "!swapclans"     ,   ::chatcmd_codam          , 3 ,  "Swap clans: !swapclans"                            , 0 , -1 );
    thread [[ level.chatCallback ]] ( "!axisclan"      ,   ::chatcmd_codam          , 3 ,  "Force a clan to Axis: !axisclan [tag]"             , 0 , -1 );
    thread [[ level.chatCallback ]] ( "!alliedclan"    ,   ::chatcmd_codam          , 3 ,  "Force a clan to Allies: !alliedclan [tag]"         , 0 , -1 );
    thread [[ level.chatCallback ]] ( "!disarm"        ,   ::chatcmd_codam          , 3 ,  "Disarm a player: !disarm [player]"                 , 1 , -1 );
    thread [[ level.chatCallback ]] ( "!matrix"        ,   ::chatcmd_codam          , 3 ,  "Channel your inner Neo: !matrix"                   , 0 , -1 );
    thread [[ level.chatCallback ]] ( "!force"         ,   ::chatcmd_codam          , 3 ,  "Force a player to team: !force [team] [player]"    , 1 , -1 );
    thread [[ level.chatCallback ]] ( "!forcespec"     ,   ::chatcmd_codam          , 3 ,  "Force player to spec: !forcespec [player]"         , 1 , -1 );
    thread [[ level.chatCallback ]] ( "!burn"          ,   ::chatcmd_codam          , 3 ,  "Burn a player: !burn [player]"                     , 1 , -1 );
    thread [[ level.chatCallback ]] ( "!explode"       ,   ::chatcmd_codam          , 3 ,  "Explode a player: !explode [player]"               , 1 , -1 );
    thread [[ level.chatCallback ]] ( "!mortar"        ,   ::chatcmd_codam          , 3 ,  "Mortar a player: !mortar [player]"                 , 1 , -1 );
    thread [[ level.chatCallback ]] ( "!cow"           ,   ::chatcmd_codam          , 3 ,  "Cow a player: !cow [player]"                       , 1 , -1 );
    thread [[ level.chatCallback ]] ( "!teamlock"      ,   ::chatcmd_codam          , 3 ,  "Lock teams or player: !teamlock <player>"          , 0 , -1 );
    thread [[ level.chatCallback ]] ( "!teamunlock"    ,   ::chatcmd_codam          , 3 ,  "Unlock teams or player: !teamunlock <player>"      , 0 , -1 );
    thread [[ level.chatCallback ]] ( "!matchsetup"    ,   ::chatcmd_codam          , 3 ,  "Setup a match: !matchsetup"                        , 0 , -1 );
    thread [[ level.chatCallback ]] ( "!matchstart"    ,   ::chatcmd_codam          , 3 ,  "Start a match: !matchstart"                        , 0 , -1 );
    thread [[ level.chatCallback ]] ( "!matchstop"     ,   ::chatcmd_codam          , 3 ,  "Stop a match: !matchstop"                          , 0 , -1 );
    thread [[ level.chatCallback ]] ( "!forcevote"     ,   ::chatcmd_codam          , 3 ,  "Start a mapvote: !forcevote"                       , 0 , -1 );
    
    } else printconsole( "\n             -CoCo CoDaM Commands Disabled- \n" );
    
    // By cheesy
    thread [[ level.chatCallback ]] ( "!restart"       ,   ::map_restart            , 3 ,  "Restart map: !restart"                             , 0      );
    thread [[ level.chatCallback ]] ( "!map"           ,   ::switch_map             , 3 ,  "Change map: !map [mapname]"                        , 0      );

    // God Commands //
    thread [[ level.chatCallback ]] ( "!resetlogins"   ,   ::chatcmd_resetlogins    , 4 ,   "Resets ALL current logins: !resetlogins"          , 0      );
    thread [[ level.chatCallback ]] ( "!resetplayer"   ,   ::chatcmd_resetplayer    , 4 ,   "Clear player permissions: !resetplayer [player]"  , 1      );
    thread [[ level.chatCallback ]] ( "!resetgroup"    ,   ::chatcmd_resetgroup     , 4 ,   "Clear group logins: !resetgroup [group]"          , 0      );
    
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
    addAlias( "!resetlogins"  , "!rlog"    );
    addAlias( "!resetplayer"  , "!rpl"     );
    addAlias( "!resetgroup"   , "!rgr"     );
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

chatcmd_codam ( tok, command ) {
    
    if ( tok != "" && ( command == "!teamlock" || command == "!teamunlock" ) ) {
        arg = utilities::explode( tok, " " );
        id = self callback::getByAnyMeans( arg[ 0 ] );
        if ( !isDefined( id ) )
            return;
        
        cmd = strFrom( command, 1, command.size );
        str = cmd + " " + id;
        setCvar( "command", str );
    }
    // alias cuz ez
    if ( command == "!forcespec" ) {
        command = "!forceallspec";
    }
    
    cmd = strFrom( command, 1, command.size );
    str = cmd + " " + tok;
    setCvar( "command", str );
}

chatcmd_help ( tok ) {
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
        if ( !isDefined( level.helpcommand[ i ] ) || self.pers[ "permissions" ] < level.helpcommand[ i ].permissions )
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
   
    passwords = Array( level.permission_pws );
    // Set each time for on the fly password changes
    
    login = false;
    //if ( isDefined ( self.pers[ "permissions" ] ) )
    //    self playerMsg( "Already Logged In!" );
    for ( i = 1; i < passwords.size; i++ ) {
        //printconsole( "\n" + passwords[i] + ": " + getCvar ( passwords[ i ] ) + "\n" );
        if ( getCvar( passwords[i] ) != "" && tok == getCvar( passwords[i] ) ) {
            if ( isDefined ( level.permissions ) )
                self [[ level.permissions[ i ].call ]]( level.permissions[ i ].name );
            self.pers[ "permissions" ] = i;
            login = true;
            self playerMsg( "Logged in sucessfully as " + level.permissions[ i ].name + "!" );
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
        linemsg += "^7" + name + " " + level.cocoColor + "[" + id + "]   ";
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
        if ( !isDefined( level.helpcommand[ i ].alias ) || self.pers[ "permissions" ] < level.helpcommand[ i ].permissions )
            continue;
            
        if ( num > 0 && num % line == 0 ) {
            self playerMsg ( linemsg );
            linemsg = "";
        }
        
        if ( isDefined( level.helpcommand[ i ]) )
            linemsg += level.cocoColor + level.helpcommand[ i ].cmd + ":^7" + level.helpcommand[ i ].alias + " ";
        
        num ++;
        wait .05;
    }
    
    if ( linemsg != "" )
        self playerMsg ( linemsg );
    
}

chatcmd_kick ( tok ) {
    args = StTok( tok, " ", 1 );
    kickmsg = level.cocoColor + "You have been kicked";
    if ( isDefined ( args[ 1 ] ) ) {
        msg = args[ 1 ];
        kickmsg = "You have been kicked for: " + level.cocoColor + msg;
    }
    
    player = getPlayerById( args[ 0 ] );
    if ( isDefined ( player ) )
        player dropclient ( kickmsg );
}

chatcmd_warn ( tok ) {
    args = StTok( tok, " ", 1 );
    warnmsg = "^7You have been warned!";
    if ( isDefined ( args[ 1 ] ) )
        warnmsg = "^7You have been warned for: " + level.cocoColor + args[ 1 ];
    //printconsole( args[1] );
    
    player = getPlayerById( args[ 0 ] );
    if ( isDefined ( player ) )
        player playerMsg ( warnmsg );
}

chatcmd_mute ( tok ) {
    player = getPlayerById( tok );
    if ( isDefined ( player ) && player != self ) {
        player.pers[ "muted" ] = true;
        player playerMsg( "You have been muted by " + self.name );
    }
}

chatcmd_unmute ( tok ) {
    player = getPlayerById( tok );
    if ( isDefined ( player ) && player.muted ) {
        player.pers[ "muted" ] = false;
        player playerMsg( "You have been unmuted by " + self.name );
    }
}

chatcmd_resetplayer ( tok ) {
    player = getPlayerById( tok );
    if ( isDefined ( player ) && player != self ) {
        player.pers[ "permissions" ] = 0;
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
        if ( self != players[ i ] && isDefined( players[ i ] ) && players[ i ].pers[ "permissions" ] == id )
           players[ i ].pers[ "permissions" ] = 0;
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
           players[ i ].pers[ "permissions" ] = 0;
    }
    
    // reset all logins
    ips = Array( level.permission_ips );
    
    for ( i = 1; i < ips.size; i++ ) {
        if ( isDefined( ips[ i ] ) )
            setCvar( ips[ i ], "" );
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
                self.pers[ "lastContact" ] = player;
                self sendservercommand( "i \"^1^7"+ level.cocoColor + "[PM^5->^7" + player.name + level.cocoColor + "]  ^7" + self.name + " " + self.pers[ "suffix" ] + "^7: " + msg + "\"" );
                player privateMsg( msg, self, level.cocoColor + "[PM]" );
                return;
            }
        }
    }
    
    self playerMsg( "Please enter specified arguments: !tell [player] [message]" );
}

chatcmd_reply( tok ) {
    if ( !isDefined( self.pers[ "lastContact" ] ) || tok == "" ) {
        self playerMsg( "Previous contact not found!" );
        return;
    }
    self sendservercommand( "i \"^1^7" + level.cocoColor + "[PM^5->^7" + self.pers[ "lastContact" ].name + level.cocoColor +  "]  ^7" + self.name + " " + self.pers[ "suffix" ] + "^7: " + tok + "\"" );
    self.pers[ "lastContact" ] privateMsg( tok, self, level.cocoColor + "[PM]" );
}

privateMsg( msg, from, prefix ) {
    self sendservercommand( "i \"^1^7" + prefix + " ^7" + from.name + " " + from.pers[ "suffix" ] + "^7: " + msg + "\"" );
}

glorifyVar( name ) {
    return utilities::seperateVarName( name );
}

map_restart( tok ) {
    setCvar( "sv_maprotationcurrent", "" );
    sendservercommand( "i \"^1^7" + level.cocoBot + ": " + level.cocoColor + "Restarting map...\"" );

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

        setCvar( "sv_maprotationcurrent", " gametype " + getCvar( "g_gametype") + " map " + map );
        sendservercommand( "i \"^1^7" + level.cocoBot + ": " + level.cocoColor + "Switching map to " + map + "...\"" );

        wait 3;

        exitLevel( false );
    }
}

spectate_player( tok ) {
    player = getPlayerById( tok );
    if ( isDefined ( player ) && player.sessionstate == "playing" && player != self ) {
        self.specplayer = player getEntityNumber();
        wait 0.05;
        self [[ level.callbackSpawnSpectator ]]();
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
        if ( self.pers[ "permissions" ] < player.pers[ "permissions" ] ) {
            victim = self.name;
            inflictor = player.name;
        }
        serverMsg( inflictor + " " + level.cocoColor + msgs[ randomInt( msgs.size ) ] + " " + victim + " " + level.cocoColor + sufMsgs[ randomInt( sufMsgs.size ) ] );
    }
}

vip_trout( tok ) {
    player = getPlayerById( tok );
    if ( isDefined( player ) ) {
        if ( player == self ) {
            serverMsg( self.name + " " + level.cocoColor + "slaps himself with his limp dick" );
            return;
        }
        serverMsg( self.name + " " + level.cocoColor + "slaps " + player.name + " " + level.cocoColor + "around a bit with a large trout." );
    }
}

vip_poke( tok ) {
    player = getPlayerById( tok );
    if ( !isDefined( player ) )
        return;

    if ( player == self ) {
        serverMsg( self.name + " " + level.cocoColor + "poked himself in the eye!" );
        return;
    }
    
    self playerMsg( "You poked " + player.name + level.cocoColor + "!" );
    player playerMsg( self.name + " " + level.cocoColor + "poked you!" );
}

vip_rainbow ( tok ) {
    colorMsg = colorMsg( tok );
    self privateMsg( colorMsg, self, "" );
}

vip_suffix ( tok ) {
    // remove dupe ips and reset to default
    self clearSuffix();
    
    if ( tok == "" ) {
        if ( self.pers[ "suffix" ] == "" ) {
            cvar = level.permissions[ self.pers[ "permissions" ] ].name + "Suffix";
            self.pers["suffix"] = getCvar( cvar );
            self playerMsg( "Suffix has been toggled to default!" );
            return;
        }
        
        self.pers[ "suffix" ] = "";
        self playerMsg( "Suffix has been toggled off!" );
        return;
    }

    if ( tok == "reset" ) {
        cvar = level.permissions[ self.pers[ "permissions" ] ].name + "Suffix";
        self.pers[ "suffix" ] = getCvar( cvar );
        self playerMsg( "Suffix has been reset to default!" );
        return;
    }
    
    // clean input
    temp = "";
    for ( i = 0; i < tok.size; i++ ) {
        if ( tok[ i ] != " " && tok[ i ] != ";" )
            temp += tok[ i ];
    }
    tok = temp;
    
    wait .05;
    
    self playerMsg( "Suffix has been changed to: ^7" + tok );
    self.pers[ "suffix" ] = "[" + tok + "^7]";
    suffix = getCvar( "customSuffix" );
    newCvar = suffix + " " + self getIP() + ";" + self.pers[ "suffix" ];

    if ( suffix == "" )
        newCvar = self getIP() + ";" + tok;
    setCvar( "customSuffix", newCvar );
}

clearSuffix() {
    // check for dups and clear suffix
    customSuffix = getCvar( "customSuffix" );
    if ( customSuffix != "" ) {
        key = StTok( customSuffix, " " );
        temp = "";
        for ( i = 0; i < key.size; i++ ) {
            args = StTok( key[ i ], ";" );
            if ( args[ 0 ] != self getIP() ) {
                temp += key[ i ] + " ";
            }
        }
        setCvar( "customSuffix", temp );
    }
}

colorMsg ( msg ) {
    temp = "";
    for ( i = 0; i < msg.size; i++ ) {
        if ( msg[ i ] == " " ) {
            temp += " ";
            continue;
        }
        
        randColor = "^" + utilities::_randomIntRange( 1, 7 );
        temp += randColor + msg[ i ]; 
        wait .05;
    }
    return temp;
}

getid( tok ) {
    player = getPlayerById( tok );
    if ( isDefined( player ) ) {
        guid = utilities::getNumberedName( player.name );
        self playerMsg( player.name + "^7's ID is " + guid );
    }
}

Array( str, delim )
{
    if ( !isDefined( delim ) )
        return StTok( str, " " );
    return StTok( str, delim );
}

strFrom ( str, start, end ) {
    temp = "";
    for ( i = start; i < end; i++ ) {
        if ( isDefined( str[ i ] ) ) 
            temp += str[ i ];
    }
    return temp;
}

getPlayerById( id ) {
    return utilities::getPlayerByID( id );
}

playerMsg( msg ) {
    self callback::playerMsg( msg );
}

serverMsg( msg ) {
    sendservercommand( "i \"^1^7" + level.cocoBot + ": " + level.cocoColor +msg+"\"" );
}

StTok( s, delimiter, num ) {
    return utilities::explode( s, delimiter, num );
}