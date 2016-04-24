// Chat Module 
init() {
    // load chat commands
    level.chatCallback = ::add_chat_command;    
    
    thread zombies\_cmds::init();
    printconsole( "\n\nChat Module Loaded\n\n" );
}

CodeCallback_PlayerCommand(cmd) {
    if( cmd.size <= 0 ) {
        creturn();
        return;
    }

    if ( !isDefined( self ) || !isDefined( level.chatcommand ) || game[ "state" ] == "intermission" )
        return;

    // Check if player is muted
    if ( self.muted ) {
        self playerMsg( "You are muted!" );
        creturn();
        return;
    }
    
    // Custom suffixes for groups 
    if ( getCvarInt( "zom_suffix" ) > 0 && self.permissions > 0 && cmd[0] != "!" ) {
        self suffixMsg( cmd );
        creturn();
    }
    
    if( cmd[0] != "!" )
        return;
    
    creturn();

    if ( !isDefined( self.lastexecutetime ) )
        self.lastexecutetime = gettime();
    else {
        // chat delay time
        if ( ( gettime() - self.lastexecutetime ) < 2000 )
            return;
    }

    arg = strip ( cmd );
    chatcmd = StTok( cmd, " " ); //splits the spaces as seperate arguments
            
    if ( isDefined( level.chatcommand[ chatcmd[ 0 ] ] ) ) {
        if ( level.chatcommand[ chatcmd[ 0 ] ].permissions && !self checkPermissions( chatcmd[ 0 ] ) ) {
            self playerMsg( "You are not authorized to execute that command!" );
            return;
        }
        
        id = undefined;
        if ( level.chatcommand[ chatcmd[ 0 ] ].idrequired )
        {
            id = self getByAnyMeans( chatcmd[ 1 ] );

            if ( !isDefined( id ) )
                return;
            
            player = getPlayerById ( id );
            if ( !isDefined( player ) )
                return;
                
            if ( level.chatcommand[ chatcmd[ 0 ] ].ignoreself && player == self ) {
                self playerMsg( "You can't execute " + chatcmd[ 0 ] + " on yourself dickhead!" ); 
                return;
            }
            
            if ( level.chatcommand[ chatcmd[ 0 ] ].permissions ) {
                permission = self checkPermissions( chatcmd[ 0 ], player, level.chatcommand[ chatcmd[ 0 ] ].idrequired );
                
                if ( !permission ) {
                    self playerMsg( "You do not have permission to execute commands on " + player.name);
                    return;
                }
            }
        }
        
        command = combineChatCommand ( chatcmd, " ", id );
        //printconsole("\ncommand arg is:" + command + "!\n"); 
        self [[ level.chatcommand[ chatcmd[ 0 ] ].call ]] ( command );
        self.lastexecutetime = gettime();
    }
    else
        self playerMsg( "^3Command not found: ^7" + chatcmd[ 0 ] + " " + combineChatCommand( chatcmd, " " ));
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
    
    tokString = [[ level.utility ]]( "strreplacer", tok, "lower" );
    tokID = [[ level.utility ]]( "atoi", tok );
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
        if ( isDefined( players[ i ] ) ) {
            playerName =  clean_string( players [ i ].name );
            //printconsole("\ncleaned pstring:" + playerName + "\n");
            if ( contains( playerName, name ) ) {
                player = players[ i ];
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
    
    if ( isDefined( found[ 0 ] ) ) {
        //printconsole("\nfound player with id: " + found[0] getentitynumber() + "\n");
        return found[ 0 ] getEntityNumber();
    } 
        
    self playerMsg( "No players found with name: " + name );
    return undefined;
}

checkPermissions( command, player, checkPerm ) {
    
    if ( self.permissions >= level.chatcommand[ command ].permissions ) {
        // player not involved in command
        if ( !isDefined( player ) )
            return true;
            
        // victim must have lower permissions
        if ( self.permissions >= player.permissions || checkPerm < 0 )
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
    lower = [[ level.utility ]]( "strreplacer", str, "lower");
    mono = maps\mp\gametypes\_zombie::monotone( lower );
    return maps\mp\gametypes\_zombie::monotone( mono );
}

getPlayerById( id ) {
    return [[ level.utility ]]( "getPlayerByID", id );
}

playerMsg( msg ) {
    self sendservercommand( "i \"^7[Zombot]: ^3"+msg+"\"" );
}

suffixMsg ( msg ) {
    sendservercommand( "i \"^1^7" + self.name + " ^7" + self.suffix +"^7: "+msg+"\"" );
}

StTok( s, delimiter ) {
    return [[ level.utility ]]( "explode", s, delimiter );
}

strip( s ) {
    return [[ level.utility ]]( "strip", s );
}

contains( sString, sOtherString ) {
    return [[ level.utility ]]( "contains", sString, sOtherString );
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
