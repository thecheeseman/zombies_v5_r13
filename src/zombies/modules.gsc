init() {
    // just add other things externally here
	// load chat commands
	level.chatCallback = ::add_chat_command;	
	
	thread zombies\_cmds::init();
	printconsole( "\nchat module loaded\n\n" );
	
}

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