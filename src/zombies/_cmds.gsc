
init()
{
	// Add commands here
	zombies\_chat::add_chat_command("!ebot", ::chatcmd_ebot);

    zombies\_chat::add_chat_command( "!spankme", ::spankme );
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
