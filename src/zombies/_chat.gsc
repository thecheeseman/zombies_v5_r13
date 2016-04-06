<<<<<<< HEAD
// Chat Commands Parser
// Usage: Call on init() on startGametype and Add commands to _cmds.gsc

init() {
=======
init()
{
>>>>>>> develop
	// load chat commands
	thread zombies\_cmds::init();
	
	printconsole("\nchat module loaded\n\n");
    for(;;) 
	{
        chatcmd = getCvar("IndyCommand");
        if (chatcmd != "")
		{
            setcvar("IndyCommand", "");
            thread parseChat(chatcmd);
        }

        wait .05;
    }

}

parseChat( msg )
{
	if (!isDefined(msg) || msg.size < 1)
		return;
	chatmsg = sttok(msg, ";");
	if (chatmsg.size < 1)
		return;
	id = (int)chatmsg[0];
	chat = chatmsg[1];
	
	chatcmd = sttok(chat, " ");
	//printconsole("\nchatcmd," + chatcmd[0]+"\n");
	
	player = getPlayerById(id);
	if (!isDefined(player) || !isDefined(level.chatcommand))
		return;
		
	if(isdefined(level.chatcommand[chatcmd[0]])) 
	{
		command = "";
		for(i = 1; i < chatcmd.size; i++) 
		{
			command += chatcmd[i] + " ";
			wait .05;
		}
<<<<<<< HEAD
		
		if ( level.chatcommand[ chatcmd[ 0 ] ].idrequired )
		{
			id = player getByAnyMeans( chatcmd[ 1 ] );
			
			// didn't work
			if ( !isDefined ( id ) )
				return;
				
			command = combineChatCommand ( chatcmd, " ", id );
			
		}
		else
			command = combineChatCommand ( chatcmd, " " );
		//printconsole("\ncommand arg is:" + command + "!\n"); 
		player [[ level.chatcommand[ chatcmd[ 0 ] ].call ]] ( command );
	}
	else
		player iprintln( "^1C^7ommand not found" );
}

// modified to not recognize names with numbers in them as id
atoi_mod( tok )
{
	// make sure tok <= 2 digits
	if ( tok.size > 2 )
		return undefined;
	
	tokString = maps\mp\gametypes\_admin::strreplacer( tok, "lower" );
	tokID = maps\mp\gametypes\_admin::atoi( tok );
	if ( !isDefined ( tokID ) )
		return undefined;
		
	tokCompare = tokID + "";
	if ( tokCompare != tokString )
		return undefined;

	return tokID;
}

getByAnyMeans ( tok )
{
	tok = strip ( tok );
	
	// check if id
	id = atoi_mod( tok );
	if ( isDefined( id ) ) {
		return id;
	}

	// nop, it's a string
	
	name = clean_string( tok );
	if ( name.size == 0 ) {
		self iprintln( "^1No ^7users found with: " + tok ); 
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
		self iprintln( "^1No ^7users found with: " + name );
		return undefined;
	}
	
	if ( found.size > 1 ) {
		self iprintln( "^2Multiple users found: " );
		for ( i = 0 ; i < found.size; i ++ ) {
			if ( isDefined( found[ i ] ) && isDefined( found[ i ] getEntityNumber() ) && isDefined( found[ i ].name ) )
				self iprintln( "^1" + found[ i ] getEntityNumber() + " ^5: ^7" + found[ i ].name );
			wait .05;
		}
		return undefined;
	}
	
	if ( isDefined( found[ 0 ] ) ) {
		//printconsole("\nfound player with id: " + found[0] getentitynumber() + "\n");
		return found[ 0 ] getEntityNumber();
	} 
		
	self iprintln( "^1No ^7users found with: " + name );
	return undefined;
}

clean_string ( str ) {
	lower = maps\mp\gametypes\_zombie::strreplacer(str, "lower");
	mono = maps\mp\gametypes\_zombie::monotone( lower );
	return maps\mp\gametypes\_zombie::monotone( mono );
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
		temp += str[i] + delim;
		wait .05;
	}
	return strip(temp);
=======
		player [[ level.chatcommand[chatcmd[0]].call]](command);
	}
	else
		player iprintln("^1Command not found");
>>>>>>> develop
}

getPlayerById(id)
{
	player = undefined;
	players = getEntArray("player", "classname");
	for (i = 0; i < players.size; i++)
	{
		if (isDefined(players[i]) && players[i] getEntityNumber() == id)
		{
			player = players[i];
			break;
		}
	}
	return player;
}

<<<<<<< HEAD
// original by php
add_chat_command( cmd, call, admin, info, idrequired ) {
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
	level.chatcommand[ cmd ].idrequired = idrequired;
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
=======
// taken from php
add_chat_command(cmd, call) 
{
	if(!isdefined(level.chatcommand)) 
	{
		level.chatcommand = [];
		level.chatcommandsize = 0;
	}
    level.chatcommand[cmd] = spawnstruct();
	level.chatcommand[cmd].call = call;
    level.chatcommandsize++;
>>>>>>> develop
}

StTok( s, delimiter )
{
	j = 0;
	temparr[ j ] = "";	

	for ( i = 0; i < s.size; i++ )
	{
		if ( s[ i ] == delimiter )
		{
			j++;
			temparr[ j ] = "";
		}
		else
			temparr[ j ] += s[i];
	}
	return temparr;
}

contains( sString, sOtherString )
{
     // loop through the string to check
    for ( i = 0; i < sString.size; i++ )
    {
		x = 0;
		tmp = "";
		
        // string to check against
        for ( j = 0; j < sOtherString.size; j++ )
        {
			cur = sOtherString[ j ];
			
			if ( ( i + j ) > sString.size )
				break;
				
			next = sString[ i + j ];
			
            if ( cur == next ) 
            {
				tmp += cur;
				x++;
                continue;
            }
			
			break;
        }
        
        // looped through entire string, found it
        if ( x == sOtherString.size && tmp == sOtherString )
            return true;
    }
    
    return false;
}