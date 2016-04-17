// Chat Commands Handler
// Usage: Check _chat.gsc

init() {

    // *DONE* partial name matching system-> remove id -requirement- for argument 

    // Add commands here
<<<<<<< HEAD
    // Arguments: <cmd> , <call> , <admin-required> , <info> , <id-required>
    thread [[ level.chatCallback  ]] ( "!ebot"           ,    ::chatcmd_ebot                          , 0 ,    "Trigger e^2BOT ^7commands: !eBOT [command]"        , 0     );
    thread [[ level.chatCallback  ]] ( "!login"          ,    ::chatcmd_login                         , 0 ,    "Access admin commands: !login [password]"          , 0     );
    
    thread [[ level.chatCallback  ]] ( "!help"           ,    ::chatcmd_help                          , 1 ,    "List of commands: !help <cmd>"                     , 0     );
    thread [[ level.chatCallback  ]] ( "!status"         ,    ::chatcmd_status                        , 1 ,    "Print players info: !status"                       , 0     );
    thread [[ level.chatCallback  ]] ( "!say"            ,    ::chatcmd_rconsay                       , 1 ,    "Talk as console: !say [msg]"                       , 0     );
    thread [[ level.chatCallback  ]] ( "!kick"           ,    ::chatcmd_kick                          , 1 ,    "Kick a player: !kick [player] <msg>"               , 1     );
    thread [[ level.chatCallback  ]] ( "!warn"           ,    ::chatcmd_warn                          , 1 ,    "Warn a player: !warn [player] <msg>"               , 1     );
    
    thread [[ level.chatCallback  ]] ( "!shout"          ,    maps\mp\gametypes\_admin::say           , 1 ,    "Shout a message: !shout [msg]"                     , 0     );
    thread [[ level.chatCallback  ]] ( "!endgame"        ,    maps\mp\gametypes\_admin::endGam        , 1 ,    "End the map: !endgame"                             , 0     );
    
    thread [[ level.chatCallback  ]] ( "!rename"         ,    maps\mp\gametypes\_admin::rename        , 1 ,    "Rename player: !rename [player] [name]"            , 1     );
    thread [[ level.chatCallback  ]] ( "!id"             ,    maps\mp\gametypes\_admin::getid         , 1 ,    "Get GUID: !id [player]"                            , 1     );
    thread [[ level.chatCallback  ]] ( "!moveguid"       ,    maps\mp\gametypes\_admin::move_guid     , 1 ,    "Change player's guid: !moveguid [player]"          , 1     );    
    thread [[ level.chatCallback  ]] ( "!kill"           ,    maps\mp\gametypes\_admin::kill          , 1 ,    "Kill a player: !kill [player]"                     , 1     );
    
    thread [[ level.chatCallback  ]] ( "!givewep"        ,    maps\mp\gametypes\_admin::giveWeap      , 1 ,    "Give a weapon: !give [player] [weapon]"            , 1     );
    thread [[ level.chatCallback  ]] ( "!drop"           ,    maps\mp\gametypes\_admin::drop          , 1 ,    "Drop a player: !drop [player] <height>"            , 1     );
    thread [[ level.chatCallback  ]] ( "!giveks"         ,    maps\mp\gametypes\_admin::giveks        , 1 ,    "Give a killstreak: !giveks [player] [killstreak]"  , 1     );
    thread [[ level.chatCallback  ]] ( "!givearmor"      ,    maps\mp\gametypes\_admin::givearmor     , 1 ,    "Give armor: !givearmor [player] [amount]"          , 1     );
    
    thread [[ level.chatCallback  ]] ( "!givexp"         ,    maps\mp\gametypes\_admin::giveXp        , 1 ,    "Give XP: !givexp [player] [amount]"                , 1     );
    thread [[ level.chatCallback  ]] ( "!givekills"      ,    maps\mp\gametypes\_admin::giveKills     , 1 ,    "Give Kills: !givekills [player] [amount]"          , 1     );
    thread [[ level.chatCallback  ]] ( "!givepoints"     ,    maps\mp\gametypes\_admin::givePoints    , 1 ,    "Give Points: !givepoints [player] [amount]"        , 1     );

    thread [[ level.chatCallback  ]] ( "!updatexp"       ,    maps\mp\gametypes\_admin::updatexp      , 1 ,    "Update XP stats: !updatexp [player]"               , 1     );
    thread [[ level.chatCallback  ]] ( "!updatekills"    ,    maps\mp\gametypes\_admin::updatekill    , 1 ,    "Update Kills stats: !updatekills [player]"         , 1     );
    
    thread [[ level.chatCallback  ]] ( "!spank"          ,    maps\mp\gametypes\_admin::spank         , 1 ,    "Spank a player: !spank [player] [time]"            , 1     );
    thread [[ level.chatCallback  ]] ( "!slap"           ,    maps\mp\gametypes\_admin::slap          , 1 ,    "Slap a player: !slap [player] [time]"              , 1     );
    thread [[ level.chatCallback  ]] ( "!givexp"         ,    maps\mp\gametypes\_admin::giveXp        , 1 ,    "Give XP: !givexp [player] [amount]"                , 1     );
    
    thread [[ level.chatCallback  ]] ( "!blind"          ,    maps\mp\gametypes\_admin::blind         , 1 ,    "Blind a player: !blind [player] [time]"            , 1     );
    thread [[ level.chatCallback  ]] ( "!forcespec"      ,    maps\mp\gametypes\_admin::forcespec     , 1 ,    "Move player to spec: !forcespec [player]"          , 1     );

    //thread [[ level.chatCallback  ]] ( "!toilet"       ,    maps\mp\gametypes\_admin::toilet        , 1 ,    "Make player a toilet: !toilet [player]"            , 1     );
    thread [[ level.chatCallback  ]] ( "!runover"        ,    maps\mp\gametypes\_admin::runover       , 1 ,    "Runover a player with tank: !runover [player]"     , 1     );
    
    thread [[ level.chatCallback  ]]( "!squash"          ,    maps\mp\gametypes\_admin::squash        , 1 ,    "Squash a player with tank: !squash [player]"       , 1     );
    thread [[ level.chatCallback  ]]( "!insult"          ,    maps\mp\gametypes\_admin::insult        , 1 ,    "Throw some insults: !insults [player]"             , 1     );
    thread [[ level.chatCallback  ]]( "!rape"            ,    maps\mp\gametypes\_admin::rape          , 1 ,    "Use with caution: !rape [player]"                  , 1     );
=======
    // Arguments: <cmd> , <call> , <permissions> , <info> , <id-required>
    thread [[ level.chatCallback  ]] ( "!ebot"          ,   ::chatcmd_ebot                          , 0 ,   "Trigger e^2BOT ^7commands: !eBOT [command]"        , 0     );
    thread [[ level.chatCallback  ]] ( "!login"         ,   ::chatcmd_login                         , 0 ,   "Access admin commands: !login [password]"          , 0     );
    
    thread [[ level.chatCallback  ]] ( "!help"          ,   ::chatcmd_help                          , 0 ,   "List of commands: !help <cmd>"                     , 0     );
    thread [[ level.chatCallback  ]] ( "!status"        ,   ::chatcmd_status                        , 1 ,   "Print players info: !status"                       , 0     );
    thread [[ level.chatCallback  ]] ( "!say"           ,   ::chatcmd_rconsay                       , 1 ,   "Talk as console: !say [msg]"                       , 0     );
    thread [[ level.chatCallback  ]] ( "!kick"          ,   ::chatcmd_kick                          , 1 ,   "Kick a player: !kick [player] <msg>"               , 1     );
    thread [[ level.chatCallback  ]] ( "!warn"          ,   ::chatcmd_warn                          , 1 ,   "Warn a player: !warn [player] <msg>"               , 1     );
    
    thread [[ level.chatCallback  ]] ( "!shout"         ,   maps\mp\gametypes\_admin::say           , 1 ,   "Shout a message: !shout [msg]"                     , 0     );
    thread [[ level.chatCallback  ]] ( "!endgame"       ,   maps\mp\gametypes\_admin::endGame       , 1 ,   "End the map: !endgame"                             , 0     );
    
    thread [[ level.chatCallback  ]] ( "!rename"        ,   maps\mp\gametypes\_admin::rename        , 1 ,   "Rename player: !rename [player] [name]"            , 1     );
    thread [[ level.chatCallback  ]] ( "!id"            ,   maps\mp\gametypes\_admin::getid         , 1 ,   "Get GUID: !id [player]"                            , 1     );
    thread [[ level.chatCallback  ]] ( "!moveguid"      ,   maps\mp\gametypes\_admin::move_guid     , 1 ,   "Change player's guid: !moveguid [player]"          , 1     );  
    thread [[ level.chatCallback  ]] ( "!kill"          ,   maps\mp\gametypes\_admin::kill          , 1 ,   "Kill a player: !kill [player]"                     , 1     );
    
    thread [[ level.chatCallback  ]] ( "!giveweap"      ,   maps\mp\gametypes\_admin::giveWeap      , 1 ,   "Give a weapon: !giveweap [player] [weapon]"        , 1     );
    thread [[ level.chatCallback  ]] ( "!drop"          ,   maps\mp\gametypes\_admin::drop          , 1 ,   "Drop a player: !drop [player] <height>"            , 1     );
    thread [[ level.chatCallback  ]] ( "!giveks"        ,   maps\mp\gametypes\_admin::giveks        , 1 ,   "Give a killstreak: !giveks [player] [killstreak]"  , 1     );
    thread [[ level.chatCallback  ]] ( "!givearmor" ,       maps\mp\gametypes\_admin::givearmor     , 1 ,   "Give armor: !givearmor [player] [amount]"          , 1     );
    
    thread [[ level.chatCallback  ]] ( "!givexp"        ,   maps\mp\gametypes\_admin::giveXp        , 1 ,   "Give XP: !givexp [player] [amount]"                , 1     );
    thread [[ level.chatCallback  ]] ( "!givekills"     ,   maps\mp\gametypes\_admin::giveKills     , 1 ,   "Give Kills: !givekills [player] [amount]"          , 1     );
    thread [[ level.chatCallback  ]] ( "!givepoints"    ,   maps\mp\gametypes\_admin::givePoints    , 1 ,   "Give Points: !givepoints [player] [amount]"        , 1     );

    thread [[ level.chatCallback  ]] ( "!updatexp"      ,   maps\mp\gametypes\_admin::updatexp      , 1 ,   "Update XP stats: !updatexp [player]"               , 1     );
    thread [[ level.chatCallback  ]] ( "!updatekills"   ,   maps\mp\gametypes\_admin::updatekills   , 1 ,   "Update Kills stats: !updatekills [player]"         , 1     );
    
    thread [[ level.chatCallback  ]] ( "!spank"         ,   maps\mp\gametypes\_admin::spank         , 1 ,   "Spank a player: !spank [player] [time]"            , 1     );
    thread [[ level.chatCallback  ]] ( "!slap"          ,   maps\mp\gametypes\_admin::slap          , 1 ,   "Slap a player: !slap [player] [time]"              , 1     );
    thread [[ level.chatCallback  ]] ( "!givexp"        ,   maps\mp\gametypes\_admin::giveXp        , 1 ,   "Give XP: !givexp [player] [amount]"                , 1     );
    
    thread [[ level.chatCallback  ]] ( "!blind"         ,   maps\mp\gametypes\_admin::blind         , 1 ,   "Blind a player: !blind [player] [time]"            , 1     );
    thread [[ level.chatCallback  ]] ( "!forcespec"     ,   maps\mp\gametypes\_admin::forcespec     , 1 ,   "Move player to spec: !forcespec [player]"          , 1     );

    //thread [[ level.chatCallback  ]] ( "!toilet"      ,   maps\mp\gametypes\_admin::toilet        , 1 ,   "Make player a toilet: !toilet [player]"            , 1     );
    thread [[ level.chatCallback  ]] ( "!runover"       ,   maps\mp\gametypes\_admin::runover       , 1 ,   "Runover a player with tank: !runover [player]"     , 1     );
    
    thread [[ level.chatCallback  ]]( "!squash"         ,   maps\mp\gametypes\_admin::squash        , 1 ,   "Squash a player with tank: !squash [player]"       , 1     );
    thread [[ level.chatCallback  ]]( "!insult"         ,   maps\mp\gametypes\_admin::insult        , 1 ,   "Throw some insults: !insults [player]"             , 1     );
    thread [[ level.chatCallback  ]]( "!rape"           ,   maps\mp\gametypes\_admin::rape          , 1 ,   "Use with caution: !rape [player]"                  , 1     );
>>>>>>> develop
    
}

chatcmd_ebot( tok ) {
    cmd = "eBOT " + tok;
    self setClientCvar( "name" , cmd );
}

adminCheck()
<<<<<<< HEAD
{    
=======
{   
>>>>>>> develop
    adminCvar = getCvar("adminIP");
    if ( adminCvar == "" )
        return;

    // check for multiple admins
    if ( callback::contains( adminCvar, " " ) )
        admins = StTok( adminCvar, " " );
    else
        admins[0] = adminCvar;

    for ( i = 0; i < admins.size; i++ ) {
        if ( self getIP() == admins[ i ] )
            self.pers[ "admin" ] = true;
        wait .05;
    }
        
        
}

chatcmd_login( tok ) {
    if ( tok == getCvar ( "adminPassword" ) ) {
        if ( isDefined ( self.pers[ "admin" ] ) ) {
            self playerMsg ( "Already Logged In!" );
            return;
        }
        
        admins = getCvar("adminIP");
        newCvar = admins+" "+self getIP();
        // first admin
        if (admins == "")
            newCvar = self getIP();
        setCvar("adminIP", newCvar);
        self.pers[ "admin" ] = 1;
        self playerMsg( "Login Successful!" );
        return;
    } 
    
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
    
    line = 10;
    linemsg = "";
    
    for ( i = 0; i < level.helpcommand.size; i++ ) {
        if ( i > 0 && i % line == 0 )
        {
            self playerMsg ( linemsg );
            linemsg = "";
        }
        
<<<<<<< HEAD
        if ( isDefined( level.helpcommand[ i ]) )
=======
        if ( isDefined( level.helpcommand[ i ]) && self.stats[ "permissions" ] >= level.helpcommand[ i ].permission )
>>>>>>> develop
            linemsg += level.helpcommand[ i ].cmd + "  ";
        
        wait .05;
    }
    
    if ( linemsg != "" )
        self playerMsg ( linemsg );
    
}

chatcmd_kick ( tok )
{
    args = StTok( tok, " ", 1 );
    kickmsg = "^3You have been kicked";
    if ( isDefined ( args[ 1 ] ) )
    {
        msg = args[ 1 ];
        kickmsg = "You have been kicked for: ^3" + msg;
    }
    
    player = getPlayerById( tok[ 0 ] );
    if ( isDefined ( player ) )
        player dropclient ( kickmsg );
}

chatcmd_warn ( tok )
{
    args = StTok( tok, " ", 1 );
    warnmsg = "^7You have been warned!";
    if ( isDefined ( args[ 1 ] ) )
        warnmsg = "^7You have been warned for: ^3"+args[ 1 ];
    //printconsole( args[1] );
    
    player = getPlayerById( tok[ 0 ] );
    if ( isDefined ( player ) )
        player playerMsg ( warnmsg );
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

playerMsg ( msg )
{
    self callback::playerMsg( msg );
}

StTok( s, delimiter, num ) {
    temparr = [];
    if ( !isDefined ( s ) || s == "" )
        return temparr;
    j = 0;
    if ( !isDefined( num ) )
        num = 1000;
<<<<<<< HEAD
    temparr[ j ] = "";    
=======
    temparr[ j ] = "";  
>>>>>>> develop

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