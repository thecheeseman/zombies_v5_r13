init()
{
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
		player [[ level.chatcommand[chatcmd[0]].call]](command);
	}
	else
		player iprintln("^1Command not found");
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