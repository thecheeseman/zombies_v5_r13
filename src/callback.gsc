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
    // load chat commands
    level.chatCallback = ::add_chat_command;    
    
    thread commands::init();
    printconsole( "\n             -CoCo Successfully Loaded-\n\n" );
}

CodeCallback_PlayerCommand(cmd) {
    if( cmd.size <= 0 ) {
        creturn();
        return;
    }

    if ( isDefined( level.disableCoCo ) || !isDefined( level.chatcommand ) )
        return;
    
    if ( !isDefined( self ) || game[ "state" ] == "intermission" )
        return;
        
    // Check if player is muted
    if ( self.pers[ "muted" ] ) {
        self playerMsg( "You are muted!" );
        creturn();
        return;
    }
    
    // Custom suffixes for groups 
    if ( getCvarInt( "coco_suffix" ) > 0 && self.pers[ "permissions" ] > 0 && cmd[0] != "!" && self.pers[ "suffix" ] != "" ) {
        self suffixMsg( cmd );
        creturn();
    }
    
    if( cmd[0] != "!" )
        return;
    
    creturn();

    if ( !isDefined( self.pers[ "lastexecutetime" ] ) )
        self.pers[ "lastexecutetime" ] = gettime();
    else if ( getCvarInt( "coco_chatdelay" ) > 0 ) {
        // chat delay time
        chatdelay = getCvarFloat( "coco_chatdelay" ) * 1000;
        if ( ( gettime() - self.pers[ "lastexecutetime" ] ) < chatdelay )
            return;
    }

    arg = strip ( cmd );
    chatcmd = StTok( arg, " " ); //splits the spaces as seperate arguments
            
    if ( isDefined( level.chatcommand[ chatcmd[ 0 ] ] ) ) {
        if ( level.chatcommand[ chatcmd[ 0 ] ].permissions && !self checkPermissions( chatcmd[ 0 ] ) ) {
            self playerMsg( "You are not authorized to execute that command!" );
            return;
        }
        
        id = undefined;
        if ( level.chatcommand[ chatcmd[ 0 ] ].idrequired )
        {
            if ( !isDefined( chatcmd[ 1 ] ) ) {
                self playerMsg( "Check command usage... Player must be given!" );
                self.pers[ "lastexecutetime" ] = gettime();
                return;
            }
            id = self getByAnyMeans( chatcmd[ 1 ] );

            if ( !isDefined( id ) )
                return;
            
            player = getPlayerById ( id );
            if ( !isDefined( player ) )
                return;
                
            if ( level.chatcommand[ chatcmd[ 0 ] ].ignoreself > 0 && player == self ) {
                self playerMsg( "You can't execute " + chatcmd[ 0 ] + " on yourself dickhead!" ); 
                return;
            }
            
            if ( level.chatcommand[ chatcmd[ 0 ] ].permissions > 0 ) {
                permission = self checkPermissions( chatcmd[ 0 ], player, level.chatcommand[ chatcmd[ 0 ] ].idrequired );
                
                if ( !permission ) {
                    self playerMsg( "You do not have permission to execute commands on " + player.name);
                    return;
                }
            }
        }
        
        tok = combineChatCommand ( chatcmd, " ", id );
        command = chatcmd[ 0 ];
        
        
        // check for codam command -> transfers to codam command parser
        if ( level.chatcommand[ command ].ignoreself < 0 ) {
            self [[ level.chatcommand[ command ].call ]]( tok, command );
            return;
        }
        
        self [[ level.chatcommand[ command ].call ]]( tok );
        self.pers[ "lastexecutetime" ] = gettime();
        
    }
    else
        self playerMsg( level.cocoColor + "Command not found: ^7" + chatcmd[ 0 ] + " " + combineChatCommand( chatcmd, " " ));
}

// original by php
add_chat_command( cmd, call, permissions, info, idrequired, ignoreself ) {

    if ( !isDefined( level.chatcommand ) )
        level.chatcommand = [];
        
    if ( !isDefined( level.helpcommand ) )
        level.helpcommand = [];
        
    if ( !isDefined( info ) )
        info = "Info for command: " + cmd + " not found";
        
    if ( !isDefined( ignoreself ) )
        ignoreself = 0;
        
    level.helpcommand[ level.chatcommand.size ] = spawnstruct();
    level.helpcommand[ level.chatcommand.size ].cmd = cmd;
    level.helpcommand[ level.chatcommand.size ].info = info;
    level.helpcommand[ level.chatcommand.size ].permissions = permissions;
    
    level.chatcommand[ cmd ] = spawnstruct();
    level.chatcommand[ cmd ].call = call;
    level.chatcommand[ cmd ].id = level.chatcommand.size;
    level.chatcommand[ cmd ].permissions = permissions;
    level.chatcommand[ cmd ].info = info;
    level.chatcommand[ cmd ].idrequired = idrequired;
    level.chatcommand[ cmd ].ignoreself = ignoreself;
}

// modified to not recognize names with numbers in them as id
atoi_mod( tok ) {
    // make sure tok <= 2 digits
    if ( tok.size > 2 )
        return undefined;
    
    tokString = utilities::strreplacer( tok, "lower" );
    tokID = utilities::atoi( tok );
    if ( !isDefined ( tokID ) )
        return undefined;

    tokCompare = tokID + "";
    if ( tokCompare != tokString )
        return undefined;

    return tokID;
}

getByAnyMeans( tok ) {
    if ( !isDefined( tok ) )
        return undefined;
    tok = strip ( tok );
    
    // check if id
    id = atoi_mod( tok );
    if ( isDefined( id ) ) {
        if ( !isDefined( getPlayerById( id ) ) ) {
            self playerMsg( "No users found with id: " + tok ); 
            return undefined;
        }
        return id;
    }

    // nop, it's a string
    name = clean_string( tok );
    if ( name.size == 0 ) {
        self playerMsg( "No users found with name: " + tok ); 
        return undefined;
    }
    
    //printconsole("\ncleaned string:" + name + "\n");
    found = [];
    players = getEntArray( "player", "classname" );
    for ( i = 0; i < players.size; i++ ) {
        player = players[ i ];
        if ( isDefined( player.name ) ) {
            playerName =  clean_string( player.name );
            //printconsole("\ncleaned pstring:" + playerName + "\n");
            if ( contains( playerName, name ) ) {
                found [ found.size ] = player;
            }
        }
    }
    //printconsole("\nfound.size is " + found.size + "\n");
    if ( found.size < 1 ) {
        self playerMsg( "No players found with: " + name );
        return undefined;
    }
    
    if ( found.size > 1 ) {
        self playerMsg( "Multiple users found: " );
        for ( i = 0 ; i < found.size; i ++ ) {
            if ( isDefined( found[ i ] ) && isDefined( found[ i ] getEntityNumber() ) && isDefined( found[ i ].name ) )
                self playerMsg( "^1" + found[ i ] getEntityNumber() + " ^5: ^7" + found[ i ].name );
            wait .05;
        }
        return undefined;
    }
    
    if ( found.size > 0 && isDefined( found[ 0 ] ) ) {
        //printconsole("\nfound player with id: " + found[0] getentitynumber() + "\n");
        id = found[ 0 ] getEntityNumber();
        return id;
    } 

    self playerMsg( "No players found with name: " + name );
    return undefined;
}

checkPermissions( command, player, checkPerm ) {
    
    if ( self.pers[ "permissions" ] >= level.chatcommand[ command ].permissions ) {
        // player not involved in command
        if ( !isDefined( player ) )
            return true;
            
        // victim must have lower permissions
        if ( self.pers[ "permissions" ] >= player.pers[ "permissions" ] || checkPerm < 0 )
            return true;
    }
   
    return false;
}

combineChatCommand ( str, delim, id ) {
    start = 1;
    if ( isDefined( id ) ) {
        temp = id + " ";
        start = 2;
    }
    else
        temp = "";
        
    for(i = start; i < str.size; i++)  {
        temp += strip ( str[i] ) + delim;
        wait .05;
    }
    return strip(temp);
}



clean_string ( str ) {
    // fuck codextended's tolower -> crashes sometimes
    lower = utilities::lowercase( str );
    mono = utilities::monotone( lower );
    return utilities::monotone( mono );
}

getPlayerById( id ) {
    return utilities::getPlayerByID( id );
}

playerMsg( msg ) {
    self sendservercommand( "i \"^1^7" + level.cocoBot + ": " + level.cocoColor + msg+"\"" );
}

suffixMsg ( msg ) {
    prefix = "";
    if ( !isAlive ( self ) && self.sessionstate == "playing" ) {
        prefix = "(Dead)";
    }
    if ( !isAlive ( self ) && self.pers[ "team" ] == "spectator" ) {
        prefix = "(Spectator)";
    }
    sendservercommand( "i \"^1^7" + prefix + self.name + " ^7" + self.pers[ "suffix" ] +"^7: "+msg+"\"" );
}

StTok( s, delimiter ) {
    return utilities::explode( s, delimiter );
}

strip( s ) {
    return utilities::strip( s );
}

contains( sString, sOtherString ) {
    return utilities::contains( sString, sOtherString );
}

// untested shit
CodeCallback_EntityDamage( attacker, point, damage ) {
}

CodeCallback_EntityKilled( attacker, inflictor, damage, mod ) {
    
}

CodeCallback_EntityUse( activator ) {
    
}

CodeCallback_EntityTouch() {

}

CodeCallback_EntityThink() {

}

callbackVoid() {
}
