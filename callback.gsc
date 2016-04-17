init() {
	// load chat commands
	level.chatCallback = ::add_chat_command;	
	
	thread zombies\_cmds::init();
	printconsole( "\nchat module loaded\n\n" );
}

CodeCallback_PlayerCommand(cmd) {
	if( cmd.size <= 0 ) {
		creturn();
		return;
	}
	if( cmd[0] != "!" )
		return;
	
	creturn();

	arg = strip ( cmd );
	chatcmd = StTok( cmd, " " ); //splits the spaces as seperate arguments
	
	//printconsole( "\nchatcmd," + chatcmd[ 0 ]+"\n" );
	
	if ( !isDefined( self ) || !isDefined( level.chatcommand ) )
		return;
		
	if ( isDefined( level.chatcommand[ chatcmd[ 0 ] ] ) ) {
		if ( level.chatcommand[ chatcmd[ 0 ] ].admin && !isDefined( self.pers[ "admin" ] ) ) {
			self playerMsg( "You are not authorized to execute that command!" );
			return;
		}
		
		if ( level.chatcommand[ chatcmd[ 0 ] ].idrequired )
		{
			id = self getByAnyMeans( chatcmd[ 1 ] );
			
			// didn't work
			if ( !isDefined ( id ) )
				return;
				
			command = combineChatCommand ( chatcmd, " ", id );
			
		}
		else
			command = combineChatCommand ( chatcmd, " " );
		//printconsole("\ncommand arg is:" + command + "!\n"); 
		self [[ level.chatcommand[ chatcmd[ 0 ] ].call ]] ( command );
	}
	else
		self playerMsg( "^3Command not found: ^7" + chatcmd[ 0 ] + " " + combineChatCommand( chatcmd, " " ));
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

callbackVoid()
{
}

playerMsg( msg ) {
	self sendservercommand( "i \"^7[Zombot]: ^3"+msg+"\"" );
}

// modified to not recognize names with numbers in them as id
atoi_mod( tok )
{
	// make sure tok <= 2 digits
	if ( tok.size > 2 )
		return undefined;
	
	tokString = maps\mp\gametypes\_zombie::strreplacer( tok, "lower" );
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
	if ( !isDefined(tok) || tok == "" )
		return undefined;
	tok = strip ( tok );
	
	// check if id
	id = atoi_mod( tok );
	if ( isDefined( id ) ) {
		return id;
	}

	// nop, it's a string
	
	name = clean_string( tok );
	if ( name.size == 0 ) {
		self playerMsg( "No users found with: " + tok ); 
		return undefined;
	}
	
	//printconsole("\ncleaned string:" + name + "\n");
	found = [];
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ ) {
		if ( isDefined( players[ i ] ) ) {
			playerName =  clean_string( players [ i ].name );
			printconsole("\ncleaned pstring:" + playerName + "\n");
			if ( contains( playerName, name ) ) {
				player = players[ i ];
				found [ found.size ] = player;
			}
		}
	}
	//printconsole("\nfound.size is " + found.size + "\n");
	if ( found.size < 1 ) {
		self playerMsg( "No users found with: " + name );
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
		
	self playerMsg( "No users found with: " + name );
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
		temp += strip ( str[i] ) + delim;
		wait .05;
	}
	return strip(temp);
}

// original by php
add_chat_command( cmd, call, admin, info, idrequired ) {
	if ( !isDefined( level.chatcommand ) )
		level.chatcommand = [];
	if ( !isDefined( level.helpcommand ) )
		level.helpcommand = [];
	if (!isDefined(info))
		info = "Info for command: " + cmd + " not found";
		
	level.helpcommand[ level.chatcommand.size ] = spawnstruct();
	level.helpcommand[ level.chatcommand.size ].cmd = cmd;
	level.helpcommand[ level.chatcommand.size ].info = info;
	
    level.chatcommand[ cmd ] = spawnstruct();
	level.chatcommand[ cmd ].call = call;
	level.chatcommand[ cmd ].admin = admin;
	level.chatcommand[ cmd ].info = info;
	level.chatcommand[ cmd ].idrequired = idrequired;
}

strip(s) {
	if(!isDefined(s) || s == "")
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

contains( sString, sOtherString )
{
	if ( sOtherString.size > sString.size )
		return false;
	
	//printconsole( sOtherString.size + ", sString size " + sString.size + "\n" );
    // loop through the string to check
    for ( i = 0; i < sString.size; i++ )
    {
		x = 0;
		tmp = "";
		
        // string to check against
        for ( j = 0; j < sOtherString.size; j++ )
        {
			cur = sOtherString[ j ];
			
			if ( ( i + j ) >= sString.size )
				break;
				
			//printconsole( "cur = " + sOtherString[j] + " j: " + j +"\n");
				
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