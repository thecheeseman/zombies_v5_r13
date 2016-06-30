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

/* USE THIS FILE FOR DEFAULT OR CUSTOM MOD/GAMETYPE ONLY */ 

/*
 Usage: Call on init() from gametype's Main() 
        Call on onConnect() from gametype's playerConnect()
*/

init () {
    // no.
    // load cheese's admin mod //
    //level._effect[ "zombieExplo" ] = loadfx( "fx/explosions/pathfinder_explosion.efx" );
    //thread admin::init();
	
    
	if ( getCvar( "godPassword" )== "" )
	{
		printconsole( "\n\n             -CoCo-\n -GOD PASSWORD NOT SET FOR CHAT COMMANDS-\n -MUST HAVE GOD PASSWORD SET: EXITING-\n\n" );
        level.disableCoCo = true;
		return;
	}
    
	thread callback::init();
    thread permissions::init();
}

onConnect ()
{        
    if ( !level.disableCoCo )
        self thread permissions::main();
}

/* USE THIS FILE FOR DEFAULT OR CUSTOM MOD/GAMETYPE ONLY */ 