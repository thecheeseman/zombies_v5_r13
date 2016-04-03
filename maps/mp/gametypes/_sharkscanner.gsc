main()
{
    [[ level.logwrite ]]( "maps\\mp\\gametypes\\_sharkscanner.gsc::main()", true );
	mapname = maps\mp\gametypes\_zombie::toLower( getCvar( "mapname" ) );
	switch ( mapname )
	{
		case "mp_harbor":
			thread scanner( -118 );
			thread harbor_fixes();
			break;
		case "mp_neuville":
			thread neuville_fixes();
			break;
		case "mp_ship":
			thread scanner( -318 );
			break;
		case "quarantine":
			thread scanner( -127 );
			break;
		case "alcatraz":
			thread scanner( -207 );
			break;
		case "toybox_bloodbath":
			thread toybox_fixes();
			break;
		case "cp_trifles":
			thread scanner( -400 );
			break;
	}
}

scanner( z )
{
	level endon( "intermission" );
	
	while ( true )
	{
		players = getEntArray( "player", "classname" );
		for ( i = 0; i < players.size; i++ )
		{
			if ( players[ i ].sessionstate != "playing" )
				continue;
				
			myorg = players[ i ] getOrigin();
			if ( myorg[ 2 ] <= z ) {
				players[ i ] kill_for_glitching();
			}
		}
		
		wait 0.05;
	}
}

kill_for_glitching()
{
    self iPrintLnBold( "Glitching is ^1NOT^7 allowed!" );
    iPrintLn( self.name + "^7 was killed for glitching!" );
    earthquake( 0.5, 3, self.origin + ( 0, 0, 12 ), 386 );
	playFx( level._effect[ "zombieExplo" ], self.origin );
    self suicide();
}

harbor_fixes()
{
    locs = [];
    locs[ 0 ] = ( -10064, -8613, 160 );
    locs[ 1 ] = ( -11821, -7503, 160 );
    locs[ 2 ] = ( -11853, -7976, 160 );
    
    for ( i = 0; i < locs.size; i++ )
        thread spawn_kill_trigger( locs[ i ], 56, 512 );
}

neuville_fixes() {
	thread spawn_kill_trigger( ( -16229, 1873, 68 ), 56, 512 );
}

toybox_fixes() {
	level endon( "intermission" );

	while ( true ) {
		players = getEntArray( "player", "classname" );
		for ( i = 0; i < players.size; i++ ) {
			if ( players[ i ].sessionstate != "playing" )
				continue;

			if ( players[ i ].origin[ 0 ] < -260 || players[ i ].origin[ 0 ] > 1320 || 
				 players[ i ].origin[ 1 ] > 390 || players[ i ].origin[ 1 ] < -2040 ) 
				players[ i ] kill_for_glitching();

			wait 0.05;
		}

		wait 0.1;
	}
}

spawn_kill_trigger( origin, maxdist, height )
{
    level endon( "intermission" );
    
    while ( true ) {
        players = getEntArray( "player", "classname" );
        for ( i = 0; i < players.size; i++ )
        {
        	if ( !isAlive( players[ i ] ) || players[ i ].sessionstate != "playing" )
        		continue;

            plyorg = ( players[ i ].origin[ 0 ], players[ i ].origin[ 1 ], 0 );
            org = ( origin[ 0 ], origin[ 1 ], 0 );
            dist = distance( plyorg, org );
            
            if ( dist < maxdist )
            {
                plyht = players[ i ].origin[ 2 ];
                orght = origin[ 2 ];
                
                if ( plyht >= orght && ( plyht <= orght + height ) )
                    players[ i ] kill_for_glitching();
            }
            wait 0.05;
        }
        
        wait 0.1;
    }
}
