init() {
	// load chat commands
	level.chatCallback = ::add_chat_command;	
	
	thread zombies\_cmds::init();
	printconsole( "\nchat module loaded\n\n" );
	
	// monitor cvar
	for( ;; ) {
        chatcmd = getCvar( "IndyCommand" );
        if ( chatcmd != "" ) {
            setcvar( "IndyCommand", "" );
            thread parseChat( chatcmd );
        }

        wait .05;
    }

}

parseChat( msg ) {
	if ( !isDefined( msg ) || msg.size < 1 )
		return;
		
	chatmsg = sttok( msg, ";" );
	if ( chatmsg.size < 1 )
		return;
		
	id = (int) chatmsg[ 0 ];
	chat = strip( chatmsg[ 1 ] );
	
	chatcmd = sttok( chat, " " );
	//printconsole( "\nchatcmd," + chatcmd[ 0 ]+"\n" );
	
	player = getPlayerById( id );
	if ( !isDefined( player ) || !isDefined( level.chatcommand ) )
		return;
		
	if ( isDefined( level.chatcommand[ chatcmd[ 0 ] ] ) ) {
		if ( level.chatcommand[ chatcmd[ 0 ] ].admin && !isDefined( player.pers[ "admin" ] ) ) {
			iprintln( "You are ^1not ^7authorized to ^2execute ^7that command^1!" );
			return;
		}
		
		command = arrToString ( chatcmd, " " );
		player [[ level.chatcommand[ chatcmd[ 0 ] ].call ]] ( command );
	}
	else
		player iprintln( "^1C^7ommand not found" );
}

arrToString ( str, delim ) {
	temp = "";
	for(i = 1; i < str.size; i++)  {
		if (i == str.size-1)
			temp += str[i];
		else
			temp += str[i] + delim;
		wait .05;
	}
	return temp;
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

// original by php
add_chat_command( cmd, call, admin, info ) {
	if ( !isDefined( level.chatcommand ) )
		level.chatcommand = [];
	if ( !isDefined( level.helpcommand ) )
		level.helpcommand = [];
	
	level.helpcommand[ level.chatcommand.size ] = spawnstruct();
	level.helpcommand[ level.chatcommand.size ].cmd = cmd;
	level.helpcommand[ level.chatcommand.size ].info = info;
	
    level.chatcommand[ cmd ] = spawnstruct();
	level.chatcommand[ cmd ].call = call;
	level.chatcommand[ cmd ].admin = admin;
}

ltrim ( str ) {
	temp = "";
	check = true;
	
	for ( i = 0; i < str.size; i++ ) {
		if ( str [ i ] == " " && check )
			continue;
		else {
			temp += str [ i ];
			check = false;
		}
	}
	
	return temp;
}


strip(s) {
	if(s == "")
		return "";

	s2 = "";
	s3 = "";

	i = 0;
	while(i < s.size && s[i] == " ")
		i++;

	if(i == s.size)
		return "";
	
	for(; i < s.size; i++) {
		s2 += s[i];
	}

	i = s2.size-1;
	while(s2[i] == " " && i > 0)
		i--;

	for(j = 0; j <= i; j++) {
		s3 += s2[j];
	}
		
	return s3;
}

StTok( s, delimiter ) {
	j = 0;
	temparr[ j ] = "";	

	for ( i = 0; i < s.size; i++ ) {
		if ( s[ i ] == delimiter ) {
			j++;
			temparr[ j ] = "";
		}
		else
			temparr[ j ] += s[i];
	}
	return temparr;
}