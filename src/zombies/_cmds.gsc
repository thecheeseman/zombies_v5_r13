// Chat Commands Handler
// Usage: Check _chat.gsc

// todo: better alias system

init() {

    // Permisions:
    // 0 = Guest 1 = VIP 2 = Moderator 3 = Admin 4 = God 

    // Add commands here
    // Arguments: <cmd> , <call> , <permissions> , <info> , <id-required>
    
    // Guest Commands //
    thread [[ level.chatCallback  ]] ( "!login"         ,   ::chatcmd_login                         , 0 ,   "Access admin commands: !login [password]"          , 0     );
    thread [[ level.chatCallback  ]] ( "!ebot"          ,   ::chatcmd_ebot                          , 0 ,   "Trigger e^2BOT ^7commands: !eBOT [command]"        , 0     );
    thread [[ level.chatCallback  ]] ( "!help"          ,   ::chatcmd_help                          , 0 ,   "List of commands: !help <cmd>"                     , 0     );
    thread [[ level.chatCallback  ]] ( "!alias"         ,   ::chatcmd_alias                         , 0 ,   "List of aliases: !alias <cmd>"                     , 0     );
    
    thread [[ level.chatCallback ]]( "!name"            ,   ::chatcmd_name                          , 0 ,   "Rename yourself: !name [name]"                     , 0     );
    thread [[ level.chatCallback ]]( "!buy"             ,   ::buymenu                               , 0 ,   "Buy an item: !buy [item]"                          , 0     );
    thread [[ level.chatCallback ]]( "!random"          ,   ::buymenu_rnd                           , 0 ,   "Buy a random item: !random"                        , 0     );
    thread [[ level.chatCallback ]]( "!healthpack"      ,   ::buymenu_hp                            , 0 ,   "Buy a health pack: !healthpack"                    , 0     );
    
    // TODO: VIP Commands //
    
    // Mod Commands //
    thread [[ level.chatCallback  ]] ( "!status"        ,   ::chatcmd_status                        , 2 ,   "Print players info: !status"                       , 0     );
    thread [[ level.chatCallback  ]] ( "!mute"          ,   ::chatcmd_mute                          , 2 ,   "Mute a player: !mute [player]"                     , 1     );
    thread [[ level.chatCallback  ]] ( "!unmute"        ,   ::chatcmd_unmute                        , 2 ,   "Unmute a muted player: !unmute [player]"           , 1     );
    thread [[ level.chatCallback  ]] ( "!warn"          ,   ::chatcmd_warn                          , 2 ,   "Warn a player: !warn [player] <msg>"               , 1     );
    
    // Admin Commands //
    thread [[ level.chatCallback  ]] ( "!say"           ,   ::chatcmd_rconsay                       , 3 ,   "Talk as console: !say [msg]"                       , 0     );
    thread [[ level.chatCallback  ]] ( "!kick"          ,   ::chatcmd_kick                          , 3 ,   "Kick a player: !kick [player] <msg>"               , 1     );
    thread [[ level.chatCallback  ]] ( "!shout"         ,   maps\mp\gametypes\_admin::say           , 3 ,   "Shout a message: !shout [msg]"                     , 0     );
    thread [[ level.chatCallback  ]] ( "!endgame"       ,   maps\mp\gametypes\_admin::endGame       , 3 ,   "End the map: !endgame"                             , 0     );
    
    thread [[ level.chatCallback  ]] ( "!resetlogins"    ,   ::chatcmd_resetlogins                  , 4 ,   "Resets current logins and cvars: !resetlogins"     , 0     );
    thread [[ level.chatCallback  ]] ( "!rename"        ,   maps\mp\gametypes\_admin::rename        , 3 ,   "Rename player: !rename [player] [name]"            , 1     );
    thread [[ level.chatCallback  ]] ( "!id"            ,   maps\mp\gametypes\_admin::getid         , 3 ,   "Get GUID: !id [player]"                            , 1     );
    thread [[ level.chatCallback  ]] ( "!moveguid"      ,   maps\mp\gametypes\_admin::move_guid     , 3 ,   "Change player's guid: !moveguid [player]"          , 1     );  
    thread [[ level.chatCallback  ]] ( "!kill"          ,   maps\mp\gametypes\_admin::kill          , 3 ,   "Kill a player: !kill [player]"                     , 1     );
    
    thread [[ level.chatCallback  ]] ( "!giveweap"      ,   maps\mp\gametypes\_admin::giveWeap      , 3 ,   "Give a weapon: !giveweap [player] [weapon]"        , 1     );
    thread [[ level.chatCallback  ]] ( "!drop"          ,   maps\mp\gametypes\_admin::drop          , 3 ,   "Drop a player: !drop [player] <height>"            , 1     );
    thread [[ level.chatCallback  ]] ( "!giveks"        ,   maps\mp\gametypes\_admin::giveks        , 3 ,   "Give a killstreak: !giveks [player] [killstreak]"  , 1     );
    thread [[ level.chatCallback  ]] ( "!givearmor" ,       maps\mp\gametypes\_admin::givearmor     , 3 ,   "Give armor: !givearmor [player] [amount]"          , 1     );
   
    thread [[ level.chatCallback  ]] ( "!givexp"        ,   maps\mp\gametypes\_admin::giveXp        , 3 ,   "Give XP: !givexp [player] [amount]"                , 1     );
    thread [[ level.chatCallback  ]] ( "!givekills"     ,   maps\mp\gametypes\_admin::giveKills     , 3 ,   "Give Kills: !givekills [player] [amount]"          , 1     );
    thread [[ level.chatCallback  ]] ( "!givepoints"    ,   maps\mp\gametypes\_admin::givePoints    , 3 ,   "Give Points: !givepoints [player] [amount]"        , 1     );

    thread [[ level.chatCallback  ]] ( "!updatexp"      ,   maps\mp\gametypes\_admin::updatexp      , 3 ,   "Update XP stats: !updatexp [player]"               , 1     );
    thread [[ level.chatCallback  ]] ( "!updatekills"   ,   maps\mp\gametypes\_admin::updatekills   , 3 ,   "Update Kills stats: !updatekills [player]"         , 1     );
    
    thread [[ level.chatCallback  ]] ( "!spank"         ,   maps\mp\gametypes\_admin::spank         , 3 ,   "Spank a player: !spank [player] [time]"            , 1     );
    thread [[ level.chatCallback  ]] ( "!slap"          ,   maps\mp\gametypes\_admin::slap          , 3 ,   "Slap a player: !slap [player] [time]"              , 1     );
    thread [[ level.chatCallback  ]] ( "!givexp"        ,   maps\mp\gametypes\_admin::giveXp        , 3 ,   "Give XP: !givexp [player] [amount]"                , 1     );
    
    thread [[ level.chatCallback  ]] ( "!blind"         ,   maps\mp\gametypes\_admin::blind         , 3 ,   "Blind a player: !blind [player] [time]"            , 1     );
    thread [[ level.chatCallback  ]] ( "!forcespec"     ,   maps\mp\gametypes\_admin::forcespec     , 3 ,   "Move player to spec: !forcespec [player]"          , 1     );

    //thread [[ level.chatCallback  ]] ( "!toilet"      ,   maps\mp\gametypes\_admin::toilet        , 3 ,   "Make player a toilet: !toilet [player]"            , 1     );
    thread [[ level.chatCallback  ]] ( "!runover"       ,   maps\mp\gametypes\_admin::runover       , 3 ,   "Runover a player with tank: !runover [player]"     , 1     );
    thread [[ level.chatCallback  ]]( "!squash"         ,   maps\mp\gametypes\_admin::squash        , 3 ,   "Squash a player with tank: !squash [player]"       , 1     );
    thread [[ level.chatCallback  ]]( "!insult"         ,   maps\mp\gametypes\_admin::insult        , 3 ,   "Throw some insults: !insults [player]"             , 1     );
    thread [[ level.chatCallback  ]]( "!rape"           ,   maps\mp\gametypes\_admin::rape          , 3 ,   "Use with caution: !rape [player]"                  , 1     );
    
    // TODO: God Commands //
    
    // Aliases todo- multiple aliases? // 
    addAlias( "!login", "!log" );
    addAlias( "!alias", "!al" );
    addAlias( "!say", "!s" );
    addAlias( "!status", "!st" );
    addAlias( "!shout", "!sh" );
    addAlias( "!slap", "!sl" );
    addAlias( "!spank", "!sp" );
    addAlias( "!mute", "!m" );
    addAlias( "!unmute", "!um" );
    addAlias( "!help", "!? !h" );
    addAlias( "!kick", "!k" );
    addAlias( "!kill", "!ki" );
    addAlias( "!warn", "!w" );
    addAlias( "!endgame", "!eg" );
    addAlias( "!forcespec", "!fs" );
    addAlias( "!giveweap", "!gwp" );
    addAlias( "!givexp", "!gxp" );
    addAlias( "!givepoints", "!gpt" );
    addAlias( "!givekills", "!gki" );
    addAlias( "!giveks", "!gks" );
    addAlias( "!givearmor", "!garm" );
    addAlias( "!updatexp", "!uxp" );
    addAlias( "!updatekills", "!uki" );
    addAlias( "!resetlogins", "!rlog" );
    addAlias( "!buy", "!b" );
    addAlias( "!random", "!rnd" );
    addAlias( "!healthpack", "!hp" );
}

addAlias( command, alias ) {
    if ( !isDefined( level.chatcommand[ command ] ) )
        return;

    cmd = level.chatcommand[ command ];
    level.chatcommand[ alias ] = cmd;
    level.chatcommand[ command ].alias = alias;
    level.helpcommand[ getCommandID( command ) ].alias = alias;
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

Array( str )
{
    // makeshift function till i add Array in codextended
    return StTok( str, " " );
}

chatcmd_login( tok ) {
    tok = callback::strip( tok );
    if ( tok == "" ) {
        self playerMsg( "Password not defined!" );
        return;
    }
   
    // Different passwords for each permission level till mysql integration
    passwords = Array( level.permission_pws );
    // Set each time for on the fly password changes
    
    login = false;
    //if ( isDefined ( self.permissions ) )
    //    self playerMsg( "Already Logged In!" );
    for ( i = 1; i < passwords.size; i++ ) {
        printconsole( "\n" + passwords[i] + ": " + getCvar ( passwords[ i ] ) + "\n" );
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
    sendservercommand("h \"^7[ "+self.name+" ]: "+tok+"\"");
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
            linemsg += "^3" + level.helpcommand[ i ].cmd + ": ^7" + level.helpcommand[ i ].alias + "  ";
        
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
    
    player = getPlayerById( tok[ 0 ] );
    if ( isDefined ( player ) )
        player dropclient ( kickmsg );
}

chatcmd_warn ( tok ) {
    args = StTok( tok, " ", 1 );
    warnmsg = "^7You have been warned!";
    if ( isDefined ( args[ 1 ] ) )
        warnmsg = "^7You have been warned for: ^3"+args[ 1 ];
    //printconsole( args[1] );
    
    player = getPlayerById( tok[ 0 ] );
    if ( isDefined ( player ) )
        player playerMsg ( warnmsg );
}

chatcmd_mute ( tok ) {
    player = getPlayerById( tok[ 0 ] );
    if ( isDefined ( player ) ) {
        player.muted = true;
        player playerMsg( "You have been muted by " + self.name );
    }
}

chatcmd_unmute ( tok ) {
    player = getPlayerById( tok[ 0 ] );
    if ( isDefined ( player ) && player.muted ) {
        player.muted = false;
        player playerMsg( "You have been unmuted by " + self.name );
    }
}

chatcmd_resetlogins ( tok ) {

    // reset player permissions except self
    players = getEntArray( "player", "classname" );
    for (i = 0; i < players.size; i++) {
        if ( self != players[ i ] && isDefined( players[ i ] ) )
           self.permissions = 0;
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

chatcmd_name ( tok ) {
    self setClientCvar( "name", tok );
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

getPlayerById( id ) {
    player = undefined;
    players = getEntArray( "player", "classname" );
    for ( i = 0; i < players.size; i++ ) {
        if ( isDefined( players[ i ] ) && players[ i ] getEntityNumber() == id ) {
            player = players[ i ];
            break;
        }
    }
    return player;
}

playerMsg ( msg ) {
    self callback::playerMsg( msg );
}

StTok( s, delimiter, num ) {
    temparr = [];
    if ( !isDefined ( s ) || s == "" )
        return temparr;
    j = 0;
    if ( !isDefined( num ) )
        num = 1000;

    temparr[ j ] = "";  

    for ( i = 0; i < s.size; i++ ) {
        if ( s[ i ] == delimiter && j < num ) {
            j++;
            temparr[ j ] = "";
        }
        else
            temparr[ j ] += s[i];
    }
    return temparr;
}