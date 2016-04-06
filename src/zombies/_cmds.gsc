// Chat Commands Handler
// Usage: Check _chat.gsc

<<<<<<< HEAD
init() {

	// *DONE* partial name matching system-> remove id -requirement- for argument 

	// Add commands here
	// Arguments: <cmd> , <call> , <admin-required> , <info> , <id-required>
	thread [[ level.chatCallback  ]] ( "!ebot"			, 	::chatcmd_ebot							, 0 ,	"Trigger e^2BOT ^7commands"	, 0		);
	thread [[ level.chatCallback  ]] ( "!login"			, 	::chatcmd_login							, 0 ,	"Access admin commands"		, 0		);
	
	thread [[ level.chatCallback  ]] ( "!help"			, 	::chatcmd_help							, 1 ,	"List of commands"			, 0 	);
	thread [[ level.chatCallback  ]] ( "!status" 		, 	::chatcmd_status  						, 1 ,	"Print players info"		, 0 	);
	thread [[ level.chatCallback  ]] ( "!say" 			,	::chatcmd_rconsay 						, 1 ,	"Talk as console"			, 0 	);
	
	thread [[ level.chatCallback  ]] ( "!shout" 		,	maps\mp\gametypes\_admin::say 			, 1 ,	"Shout a message"			, 0		);
	thread [[ level.chatCallback  ]] ( "!rename" 		, 	maps\mp\gametypes\_admin::rename 		, 1 ,	"Rename player"				, 1 	);
	thread [[ level.chatCallback  ]] ( "!id" 			, 	maps\mp\gametypes\_admin::getid 		, 1 ,	"Get GUID"					, 0		);
	thread [[ level.chatCallback  ]] ( "!kill" 			, 	maps\mp\gametypes\_admin::kill 			, 1 ,	"Kill player"				, 1 	);
	thread [[ level.chatCallback  ]] ( "!endgame"   	,	maps\mp\gametypes\_admin::endGame 		, 1 ,	"End the map"				, 0 	);
	
	thread [[ level.chatCallback  ]] ( "!givewep" 	, 		maps\mp\gametypes\_admin::giveWeap  	, 1 ,	"Give a weapon"				, 1 	);
	thread [[ level.chatCallback  ]] ( "!drop" 		, 		maps\mp\gametypes\_admin::drop 			, 1 ,	"Drop a player"				, 1 	);
	thread [[ level.chatCallback  ]] ( "!giveks" 	,		maps\mp\gametypes\_admin::giveks 		, 1 ,	"Give a killstreak"			, 1 	);
	thread [[ level.chatCallback  ]] ( "!givearmor" , 		maps\mp\gametypes\_admin::givearmor 	, 1 ,	"Give armor"				, 1 	);

	thread [[ level.chatCallback  ]] ( "!givexp" 		, 	maps\mp\gametypes\_admin::giveXp 		, 1 ,	"Give XP"					, 1 	);
	thread [[ level.chatCallback  ]] ( "!givekills" 	, 	maps\mp\gametypes\_admin::giveKills		, 1 ,	"Give Kills"				, 1 	);
	thread [[ level.chatCallback  ]] ( "!givepoints"	, 	maps\mp\gametypes\_admin::givePoints 	, 1 ,	"Give Points"				, 1 	);

	thread [[ level.chatCallback  ]] ( "!updatexp" 		, 	maps\mp\gametypes\_admin::updatexp 		, 1 ,	"Update XP"					, 1 	);
	thread [[ level.chatCallback  ]] ( "!updatekills" 	, 	maps\mp\gametypes\_admin::updatekills 	, 1 ,	"Update Kills"				, 1 	);
	
	thread [[ level.chatCallback  ]]( "!spank"			,	maps\mp\gametypes\_admin::spank			, 1 ,	"Spank a player"			, 1 	);
	thread [[ level.chatCallback  ]]( "!slap"			, 	maps\mp\gametypes\_admin::slap			, 1 ,	"Slap a player"				, 1 	);
	
=======
init()
{
	// Add commands here
	zombies\_chat::add_chat_command("!ebot", ::chatcmd_ebot);

    zombies\_chat::add_chat_command( "!spankme", ::spankme );
>>>>>>> develop
}

chatcmd_ebot(tok)
{
	cmd = "eBOT " + tok;
	self setClientCvar("name", cmd);
}

spankme(a) {
    iPrintLn( self.name + "^7 spanked themselves!" );
    
    time = 30;
    self shellshock( "default", time / 2 );
    for( i = 0; i < time; i++ )
    {
        self playSound( "melee_hit" );
        self setClientCvar( "cl_stance", 2 );
        wait randomFloat( 0.5 );
    }
    self shellshock( "default", 1 );
}
