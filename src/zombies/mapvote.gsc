init()
{
    precacheShader( "black" );
    precacheShader( "white" );
    precacheShader( "hudStopwatch" );
    precacheShader( "levelshots/unknownmap.dds" );
    precacheString( &"Time Left: " );
    precacheString( &"Vote in progress... please wait..." );
    precacheString( &"You have voted for: " );

    level.gametype = cvardef( "g_gametype", "", undefined, undefined, "string", false );
    level.mapname = getcvar( "mapname" );

/*
    mapvote struct setup
*/
    level.mapvote = spawnstruct();
    level.mapvote.time = cvardef( "mv_time", 20, 5, 30, "int" );
    level.mapvote.include_custom = cvardef( "mv_include_custom", 1, 0, 1, "int" );
    level.mapvote.maprotation = cvardef( "mv_maprotation", "", undefined, undefined, "string", true );

    level.mapvote.stockmaps = [];
    level.mapvote.stockmaps[ 0 ] = "mp_brecourt";
    level.mapvote.stockmaps[ 1 ] = "mp_carentan";
    level.mapvote.stockmaps[ 2 ] = "mp_chateau";
    level.mapvote.stockmaps[ 3 ] = "mp_dawnville";
    level.mapvote.stockmaps[ 4 ] = "mp_depot";
    level.mapvote.stockmaps[ 5 ] = "mp_harbor";
    level.mapvote.stockmaps[ 6 ] = "mp_hurtgen";
    level.mapvote.stockmaps[ 7 ] = "mp_pavlov";
    level.mapvote.stockmaps[ 8 ] = "mp_powcamp";
    level.mapvote.stockmaps[ 9 ] = "mp_railyard";
    level.mapvote.stockmaps[ 10 ] = "mp_rocket";
    level.mapvote.stockmaps[ 11 ] = "mp_ship";

    level.mapvote.custommaps = [];
    level.mapvote.selections = [];

    parse_map_rotation();
    pick_random_maps();
}

/*
    parse_map_rotation()
    Reads sv_maprotation and parses out 'gametype' and 'map'
    keywords, leaving behind only the map list
*/ 
parse_map_rotation() {
    if ( !level.mapvote.include_custom )
        return;

    // grab rotation
    mv_maprotation = strip( getCvar( "mv_maprotation" ) );
    if ( mv_maprotation == "" ) {
        return;
    }

    // parse rotation
    rot = explode( mv_maprotation, " " );
    maps = [];
    for ( i = 0; i < rot.size; i++ ) {
        // skip over stock maps
        skip = false;

        for ( j = 0; j < level.mapvote.stockmaps.size; j++ ) {
            stock = level.mapvote.stockmaps[ j ];
            if ( rot[ i ] == stock )
                skip = true;
        }

        if ( !skip )
            maps[ maps.size ] = rot[ i ];
    }

    level.mapvote.custommaps = maps;
}

/*
    pick_random_maps()
    Chooses three random maps from the rotation and then
    precaches their info

    Determines maps ahead of time based on the previous
    match's player count at the end of the game
*/
pick_random_maps() {
    maps = [];

    // TODO: sql
    playercount = 0;
    
    for ( i = 0; i < level.mapvote.stockmaps.size; i++ ) {
        map = level.mapvote.stockmaps[ i ];

        if ( map == level.mapname )
            continue;

        // limit map choice by playercount
        if ( playercount >= get_map_minimum_players( map ) )
            maps[ maps.size ] = map;
    }

    if ( level.mapvote.include_custom ) {
        for ( i = 0; i < level.mapvote.custommaps.size; i++ ) {
            map = level.mapvote.custommaps[ i ];

            if ( map == level.mapname )
                continue;

            // limit map choice by playercount
            if ( playercount >= get_map_minimum_players( map ) )
                maps[ maps.size ] = map;
        }
    }

    // shuffle the array a bunch
    for ( i = 0; i < 20; i++ ) {
        maps = arrayShuffle( maps );
    }

    add_selection( maps[ 0 ] );
    add_selection( maps[ 1 ] );
    add_selection( maps[ 2 ] );
    add_selection( "random" );
}

add_selection( mapname ) {
    s = spawnstruct();
    s.map_name = mapname;
    s.long_name = get_long_name( mapname );
    s.localized = get_localized_name( s.map_name );
    s.votes = 0;

    iPrintln( s.map_name );

    precacheString( get_localized_name( s.map_name ) );
    precacheShader( "levelshots/" + s.map_name + ".dds" );

    level.mapvote.selections[ level.mapvote.selections.size ] = s;
}

get_map_minimum_players( map ) {
    switch ( map ) {
        case "mp_brecourt":
        case "mp_rocket":
        case "mp_hurtgen":
        case "mp_ship":
        case "mp_vok_final_night":
        case "quaratine":
            return 8;
        case "alcatraz":
        case "cp_trainingday":
        case "cp_sewerzombies":
        case "cp_shipwreck":
        case "mp_dawnville":
            return 6;
        case "germantrainingbase":
        case "goldeneye_bunker":
        case "mp_depot":
        case "mp_neuville":
        case "mp_pavlov":
        case "mp_powcamp":
        case "cp_zombiebunkers":
        case "toybox_bloodbath":
            return 5;
        case "cp_apartments":
        case "cp_banana":
        case "cp_omahgawd":
        case "cp_trifles":
        case "cp_zombies":
        case "mp_carentan":
        case "mp_chateau":
        case "mp_harbor":
        case "mp_railyard":
        case "mp_stalingrad":
        case "mp_tigertown":
        case "simon_hai":
        default: 
            return 0;
    }
}

/*
    run_map_vote()
*/
run_map_vote() {
    // grab current list of players
    players = getEntArray( "player", "classname" );

    spawn_hud();

    // set map candidates
    level.mv_cand1 setText( level.mapvote.selections[ 0 ].localized );
    level.mv_cand2 setText( level.mapvote.selections[ 1 ].localized );
    level.mv_cand3 setText( level.mapvote.selections[ 2 ].localized );
    level.mv_cand4 setText( level.mapvote.selections[ 3 ].localized );

    hud_fade( "in", 1 );

    for ( i = 0; i < players.size; i++ ) {
        players[ i ] spawn_player_hud();
        players[ i ] player_hud_fade( "in", 1 );
    }

    wait 1;

    thread timer();

    for ( i = 0; i < players.size; i++ )
        players[ i ] thread player_vote();

    thread vote_logic( players );

    level waittill( "mapvote_voting_done" );

    for ( i = 0; i < players.size; i++ )
        players[ i ] player_hud_fade( "out", 1 );

    winner = 0;
    points = 0;
    for ( i = 0; i < level.mapvote.selections.size; i++ ) {
        sel = level.mapvote.selections[ i ];

        if ( sel.votes > points ) {
            winner = i;
            points = sel.votes;
        }
    }

    level.mv_notice fadeOverTime( 1 );
    level.mv_notice.alpha = 0;

    if ( winner != 0 ) {
        level.mv_cand1 fadeOverTime( 1 );   level.mv_cand1_votes fadeOverTime( 1 );
        level.mv_cand1.alpha = 0;           level.mv_cand1_votes.alpha = 0;
    } 
    if ( winner != 1 ) {
        level.mv_cand2 fadeOverTime( 1 );   level.mv_cand2_votes fadeOverTime( 1 );
        level.mv_cand2.alpha = 0;           level.mv_cand2_votes.alpha = 0;
    }
    if ( winner != 2 ) {
        level.mv_cand3 fadeOverTime( 1 );   level.mv_cand3_votes fadeOverTime( 1 );
        level.mv_cand3.alpha = 0;           level.mv_cand3_votes.alpha = 0;
    } 
    if ( winner != 3 ) {
        level.mv_cand4 fadeOverTime( 1 );   level.mv_cand4_votes fadeOverTime( 1 );
        level.mv_cand4.alpha = 0;           level.mv_cand4_votes.alpha = 0;
    }
}

timer() {
    stopwatch = newHudElem();
    stopwatch.alignx = "center";
    stopwatch.aligny = "middle";
    stopwatch.x = 320;
    stopwatch.y = 60;
    stopwatch setTimer( level.mapvote.time );
    stopwatch.fontscale = 2;
    stopwatch.color = ( 0, 1, 0 );

    wait level.mapvote.time;

    wait 1;

    stopwatch destroy();

    level notify( "mapvote_voting_done" );
}

vote_logic( players ) {
    wait 0.05;

    level endon( "ampvote_voting_done" );

    while ( true ) {
        for ( i = 0; i < level.mapvote.selections.size; i++ )
            level.mapvote.selections[ i ].votes = 0;

        for ( i = 0; i < players.size; i++ ) {
            if ( isDefined( players[ i ].mv_vote ) )
                level.mapvote.selections[ players[ i ].mv_vote ].votes++;
        }

        level.mv_cand1_votes setValue( level.mapvote.selections[ 0 ].votes );
        level.mv_cand2_votes setValue( level.mapvote.selections[ 1 ].votes );
        level.mv_cand3_votes setValue( level.mapvote.selections[ 2 ].votes );
        level.mv_cand4_votes setValue( level.mapvote.selections[ 3 ].votes );

        wait 0.1;
    }
}

player_vote() {
    level endon( "mapvote_voting_done" );

    self setClientCvar( "g_scriptmainmenu", "" );
    self closeMenu();

    loc = 0;
    has_voted = false;
    while ( true ) {
        wait 0.05;

        if ( self attackbuttonpressed() ) {
            if ( !has_voted ) {
                has_voted = true;

                self.mv_selector fadeOverTime( 0.2 );
                self.mv_selector.alpha = 0.4;
                
                self.mv_vote = 0;
            } else {
                self.mv_vote++;
            }

            if ( self.mv_vote == 4 )
                self.mv_vote = 0;

            self.mv_txt_ply_vote fadeOverTime( 0.1 );
            self.mv_txt_ply_vote.alpha = 0;

            self.mv_img fadeOverTime( 0.1 );
            self.mv_img.alpha = 0;

            self.mv_selector moveOverTime( 0.2 );
            self.mv_selector.y = 300 + ( self.mv_vote * 26 );

            wait 0.1;

            self.mv_txt_ply_vote fadeOverTime( 0.1 );
            self.mv_txt_ply_vote.alpha = 1;
            self.mv_txt_ply_vote setText( level.mapvote.selections[ self.mv_vote ].localized );

            self.mv_img fadeOverTime( 0.1 );
            self.mv_img.alpha = 1;

            if ( level.mapvote.selections[ self.mv_vote ].map_name == "random" )
                self.mv_img setShader( "levelshots/unknownmap.dds", 256, 192 );
            else
                self.mv_img setShader( "levelshots/" + level.mapvote.selections[ self.mv_vote ].map_name + ".dds", 256, 192 );

            wait 0.1;
        }

        while ( !self attackbuttonpressed() )
            wait 0.05;
    }
}

hud_fade( type, time ) {
    val = 1;
    if ( type == "out" )
        val = 0;

    level.mv_bg fadeOverTime( time );
    level.mv_bg_top fadeOverTime( time );
    level.mv_bg_bot fadeOverTime( time );
    level.mv_bg_midtop fadeOverTime( time );
    level.mv_bg_midbot fadeOverTime( time );
    level.mv_bg_left fadeOverTime( time );
    level.mv_bg_right fadeOverTime( time );
    level.mv_bg_rightmid fadeOverTime( time );

    level.mv_bg.alpha = val;
    level.mv_bg_top.alpha = val;
    level.mv_bg_bot.alpha = val;
    level.mv_bg_midtop.alpha = val;
    level.mv_bg_midbot.alpha = val;
    level.mv_bg_left.alpha = val;
    level.mv_bg_right.alpha = val;
    level.mv_bg_rightmid.alpha = val;

    wait time;

    level.mv_notice fadeOverTime( time );
    level.mv_lb_top fadeOverTime( time );
    level.mv_lb_bot fadeOverTime( time );
    level.mv_cand1 fadeOverTime( time );
    level.mv_cand1_votes fadeOverTime( time );
    level.mv_cand2 fadeOverTime( time );
    level.mv_cand2_votes fadeOverTime( time );
    level.mv_cand3 fadeOverTime( time );
    level.mv_cand3_votes fadeOverTime( time );
    level.mv_cand4 fadeOverTime( time );
    level.mv_cand4_votes fadeOverTime( time );

    level.mv_notice.alpha = val;
    level.mv_lb_top.alpha = val;
    level.mv_lb_bot.alpha = val;
    level.mv_cand1.alpha = val;
    level.mv_cand1_votes.alpha = val;
    level.mv_cand2.alpha = val;
    level.mv_cand2_votes.alpha = val;
    level.mv_cand3.alpha = val;
    level.mv_cand3_votes.alpha = val;
    level.mv_cand4.alpha = val;
    level.mv_cand4_votes.alpha = val;
}

spawn_hud() {
// background black
    level.mv_bg = spawn_hud_element();
    level.mv_bg.x = 320;
    level.mv_bg.y = 240;
    level.mv_bg setShader( "black", 260, 308 );
    level.mv_bg.sort = 10;
    level.mv_bg.alpha = 0;
// background black

    level.mv_notice = spawn_hud_element();
    level.mv_notice.x = 320;
    level.mv_notice.y = 216;
    level.mv_notice.fontscale = 1.25;
    level.mv_notice setText( &"Vote in progress... please wait..." );
    level.mv_notice.color = ( 0, 1 , 0 );
    level.mv_notice.sort = 12;
    level.mv_notice.alpha = 0;

// background white bars
    level.mv_bg_top = spawn_hud_element();;
    level.mv_bg_top.x = 320;
    level.mv_bg_top.y = 87;
    level.mv_bg_top setShader( "white", 256, 2 );
    level.mv_bg_top.sort = 50;
    level.mv_bg_top.alpha = 0;

    level.mv_bg_bot = spawn_hud_element();
    level.mv_bg_bot.x = 320;
    level.mv_bg_bot.y = 393;
    level.mv_bg_bot setShader( "white", 256, 2 );
    level.mv_bg_bot.sort = 50;
    level.mv_bg_bot.alpha = 0;

    level.mv_bg_midtop = spawn_hud_element();
    level.mv_bg_midtop.x = 320;
    level.mv_bg_midtop.y = 146;
    level.mv_bg_midtop setShader( "white", 256, 2 );
    level.mv_bg_midtop.sort = 50;
    level.mv_bg_midtop.alpha = 0;

    level.mv_bg_midbot = spawn_hud_element();
    level.mv_bg_midbot.x = 320;
    level.mv_bg_midbot.y = 286;
    level.mv_bg_midbot setShader( "white", 256, 2 );
    level.mv_bg_midbot.sort = 50;
    level.mv_bg_midbot.alpha = 0;

    level.mv_bg_left = spawn_hud_element();
    level.mv_bg_left.x = 191;
    level.mv_bg_left.y = 240;
    level.mv_bg_left setShader( "white", 2, 308 );
    level.mv_bg_left.sort = 50;
    level.mv_bg_left.alpha = 0;

    level.mv_bg_right = spawn_hud_element();
    level.mv_bg_right.x = 449;
    level.mv_bg_right.y = 240;
    level.mv_bg_right setShader( "white", 2, 308 );
    level.mv_bg_right.sort = 50;
    level.mv_bg_right.alpha = 0;

    level.mv_bg_rightmid = spawn_hud_element();
    level.mv_bg_rightmid.x = 416;
    level.mv_bg_rightmid.y = 340;
    level.mv_bg_rightmid setShader( "white", 2, 106 );
    level.mv_bg_rightmid.sort = 50;
    level.mv_bg_rightmid.alpha = 0;
// background white bars

// letterbox bars
    level.mv_lb_top = spawn_hud_element();
    level.mv_lb_top.x = 320;
    level.mv_lb_top.y = 116;
    level.mv_lb_top setShader( "black", 256, 60 );
    level.mv_lb_top.sort = 18;
    level.mv_lb_top.alpha = 0;

    level.mv_lb_bot = spawn_hud_element();
    level.mv_lb_bot.x = 320;
    level.mv_lb_bot.y = 316;
    level.mv_lb_bot setShader( "black", 256, 60 );
    level.mv_lb_bot.sort = 18;
    level.mv_lb_bot.alpha = 0;
// letterbox bars

    level.mv_img = newHudElem();
    level.mv_img.alignx = "center";
    level.mv_img.aligny = "middle";
    level.mv_img.x = 320;
    level.mv_img.y = 216;
    //level.mv_img setShader( "levelshots/mp_harbor.dds", 256, 256 );
    level.mv_img setShader( "black", 256, 192 );
    level.mv_img.sort = 15;
    level.mv_img.alpha = 0;

    level.mv_cand1 = spawn_hud_element();
    level.mv_cand1.x = 300;
    level.mv_cand1.y = 298;
    level.mv_cand1.sort = 40;
    level.mv_cand1.fontscale = 1.4;
    level.mv_cand1.alpha = 0;

    level.mv_cand1_votes = spawn_hud_element();
    level.mv_cand1_votes.x = 432;
    level.mv_cand1_votes.y = 298;
    level.mv_cand1_votes setValue( 0 );
    level.mv_cand1_votes.sort = 40;
    level.mv_cand1_votes.fontscale = 1.4;
    level.mv_cand1_votes.alpha = 0;

    level.mv_cand2 = spawn_hud_element();
    level.mv_cand2.x = 300;
    level.mv_cand2.y = 324;
    level.mv_cand2.sort = 40;
    level.mv_cand2.fontscale = 1.4;
    level.mv_cand2.alpha = 0;

    level.mv_cand2_votes = spawn_hud_element();
    level.mv_cand2_votes.x = 432;
    level.mv_cand2_votes.y = 324;
    level.mv_cand2_votes setValue( 0 );
    level.mv_cand2_votes.sort = 40;
    level.mv_cand2_votes.fontscale = 1.4;
    level.mv_cand2_votes.alpha = 0;

    level.mv_cand3 = spawn_hud_element();
    level.mv_cand3.x = 300;
    level.mv_cand3.y = 350;
    level.mv_cand3.sort = 40;
    level.mv_cand3.fontscale = 1.4;
    level.mv_cand3.alpha = 0;

    level.mv_cand3_votes = spawn_hud_element();
    level.mv_cand3_votes.x = 432;
    level.mv_cand3_votes.y = 350;
    level.mv_cand3_votes setValue( 0 );
    level.mv_cand3_votes.sort = 40;
    level.mv_cand3_votes.fontscale = 1.4;
    level.mv_cand3_votes.alpha = 0;

    level.mv_cand4 = spawn_hud_element();
    level.mv_cand4.x = 300;
    level.mv_cand4.y = 376;
    level.mv_cand4.sort = 40;
    level.mv_cand4.fontscale = 1.4;
    level.mv_cand4.alpha = 0;

    level.mv_cand4_votes = spawn_hud_element();
    level.mv_cand4_votes.x = 432;
    level.mv_cand4_votes.y = 376;
    level.mv_cand4_votes setValue( 0 );
    level.mv_cand4_votes.sort = 40;
    level.mv_cand4_votes.fontscale = 1.4;
    level.mv_cand4_votes.alpha = 0;
}

player_hud_fade( type, time ) {
    val = 1;
    if ( type == "out" )
        val = 0;

    self.mv_img fadeOverTime( time );
    self.mv_txt_voted_for fadeOverTime( time );
    self.mv_txt_ply_vote fadeOverTime( time );
    self.mv_selector fadeOverTime( time );

    self.mv_img.alpha = val;
    self.mv_txt_voted_for.alpha = val;
    self.mv_txt_ply_vote.alpha = val;

    // don't fade in
    if ( type == "in" )
        self.mv_selector.alpha = 0;
    else
        self.mv_selector.alpha = val;
}

spawn_player_hud() {
// these should be player HUD elems
// voted for img goes here
    self.mv_img = newClientHudElem( self );
    self.mv_img.alignx = "center";
    self.mv_img.aligny = "middle";
    self.mv_img.x = 320;
    self.mv_img.y = 216;
    //self.mv_img setShader( "levelshots/mp_harbor.dds", 256, 256 );
    self.mv_img setShader( "black", 256, 256 );
    self.mv_img.sort = 15;
    self.mv_img.alpha = 0;
// voted for img goes here

    self.mv_txt_voted_for = newClientHudElem( self );
    self.mv_txt_voted_for.alignx = "center";
    self.mv_txt_voted_for.aligny = "middle";
    self.mv_txt_voted_for.x = 320;
    self.mv_txt_voted_for.y = 102;
    self.mv_txt_voted_for.sort = 30;
    self.mv_txt_voted_for.fontscale = 1.5;
    self.mv_txt_voted_for setText( &"You have voted for: " );
    self.mv_txt_voted_for.alpha = 0;

    self.mv_txt_ply_vote = newClientHudElem( self );
    self.mv_txt_ply_vote.alignx = "center";
    self.mv_txt_ply_vote.aligny = "middle";
    self.mv_txt_ply_vote.x = 320;
    self.mv_txt_ply_vote.y = 126;
    self.mv_txt_ply_vote.sort = 30;
    self.mv_txt_ply_vote.fontscale = 2;
    self.mv_txt_ply_vote.color = ( 0, 1, 0 );
    self.mv_txt_ply_vote.alpha = 0;
// these should be player HUD elems

    self.mv_selector = newClientHudElem( self );
    self.mv_selector.alignx = "center";
    self.mv_selector.aligny = "middle";
    self.mv_selector.x = 320;
    self.mv_selector.y = 300;
    self.mv_selector setShader( "white", 256, 28 );
    self.mv_selector.color = ( 0, 1, 0 );
    self.mv_selector.sort = 35;
    self.mv_selector.alpha = 0;
}

spawn_hud_element() {
    elem = newHudElem();
    elem.alignx = "center";
    elem.aligny = "middle";

    return elem;
}

remove_hud() {
    if ( isDefined( level.mv_bg ) )             level.mv_bg destroy();
    if ( isDefined( level.mv_notice ) )         level.mv_notice destroy();
    if ( isDefined( level.mv_bg_top ) )         level.mv_bg_top destroy();
    if ( isDefined( level.mv_bg_bot ) )         level.mv_bg_bot destroy();
    if ( isDefined( level.mv_bg_midtop ) )      level.mv_bg_midtop destroy();
    if ( isDefined( level.mv_bg_midot ) )       level.mv_bg_midbot destroy();
    if ( isDefined( level.mv_bg_left ) )        level.mv_bg_left destroy();
    if ( isDefined( level.mv_bg_right ) )       level.mv_bg_right destroy();
    if ( isDefined( level.mv_bg_rightmid ) )    level.mv_bg_right destroy();
    if ( isDefined( level.mv_lb_top ) )         level.mv_lb_top destroy();
    if ( isDefined( level.mv_lb_bot ) )         level.mv_lb_bot destroy();
}

remove_player_hud() {
    if ( isDefined( self.mv_img ) )             self.mv_img destroy();
    if ( isDefined( self.mv_txt_voted_for) )    self.mv_txt_voted_for destroy();
    if ( isDefined( self.mv_txt_ply_vote ) )    self.mv_txt_ply_vote destroy();
    if ( isDefined( self.mv_selector ) )        self.mv_selector destroy();
}

/*
    other funcs
*/
blank() { }

// tmp
tolocalizedstring( text ) {
    return text;
}

// tmp
printconsole( text ) {
    iPrintLn( text );
}

strip(s) {
    if(!isDefined(s) || s == "")
        return "";

    resettimeout();

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

arrayShuffle(arr)
{
    for(i = 0; i < arr.size; i++) {
        // Store the current array element in a variable
        _tmp = arr[i];

        // Generate a random number
        rN = randomInt(arr.size);

        // Replace the current with the random
        arr[i] = arr[rN];
        // Replace the random with the current
        arr[rN] = _tmp;
    }
    return arr;
}

explode( s, delimiter, num )
{
    temparr = [];
    
    if ( !isDefined ( s ) || s == "" )
        return temparr;
        
    if ( !isDefined( num ) )
        num = 1024;
        
    j = 0;
    temparr[ j ] = "";  

    for ( i = 0; i < s.size; i++ )
    {
        if ( s[ i ] == delimiter && j < num )
        {
            j++;
            temparr[ j ] = "";
        }
        else
            temparr[ j ] += s[i];
    }
    return temparr;
}

cvardef(varname, vardefault, min, max, type, setifblank)
{
    if ( !isDefined( setifblank) )
        setifblank = true;

    if ( setifblank && getCvar( varname ) == "" )
        setCvar( varname, vardefault );

    switch(type)
    {
        case "int":
            if(getcvar(varname) == "")
                definition = vardefault;
            else
                definition = getcvarint(varname);
            break;
        case "float":
            if(getcvar(varname) == "")
                definition = vardefault;
            else
                definition = getcvarfloat(varname);
            break;
        case "string":
        default:
            if(getcvar(varname) == "")
                definition = vardefault;
            else
                definition = getcvar(varname);
            break;
    }

    if((type == "int" || type == "float") && min != "" && definition < min)
        definition = min;

    if((type == "int" || type == "float") && max != "" && definition > max)
        definition = max;

    return definition;
}

get_localized_name( map ) {
    switch ( map ) {
    // stock maps 1.5
        case "mp_bocage":
            mapname = &"Bocage";
            break;
        case "mp_brecourt":
            mapname = &"Brecourt";
            break;
        case "mp_carentan":
            mapname = &"Carentan";
            break;
        case "mp_chateau":
            mapname = &"Chateau";
            break;
        case "mp_dawnville":
            mapname = &"Dawnville";
            break;
        case "mp_depot":
            mapname = &"Depot";
            break;
        case "mp_harbor":
            mapname = &"Harbor";
            break;
        case "mp_hurtgen":
            mapname = &"Hurtgen";
            break;
        case "mp_neuville":
            mapname = &"Neuville";
            break;
        case "mp_pavlov":
            mapname = &"Pavlov";
            break;
        case "mp_powcamp":
            mapname = &"P.O.W Camp";
            break;
        case "mp_railyard":
            mapname = &"Railyard";
            break;
        case "mp_rocket":
            mapname = &"Rocket";
            break;
        case "mp_ship":
            mapname = &"Ship";
            break;
        case "mp_stalingrad":
            mapname = &"Stalingrad";
            break;
        case "mp_tigertown":
            mapname = &"Tigertown";
            break;

    // custom maps
        case "alcatraz":
            mapname = &"Alcatraz";
            break;
        case "cp_zombies":
            mapname = &"Zombies (CP)";
            break;
        case "cp_trifles":
            mapname = &"Trifles (CP)";
            break;
        case "cp_shipwreck":
            mapname = &"Shipwreck (CP)";
            break;
        case "cp_zombiebunkers":
            mapname = &"Zombie Bunkers (CP)";
            break;
        case "cp_omahgawd":
            mapname = &"omahgawd (CP)";
            break;
        case "simon_hai":
            mapname = &"Hai (Simon)";
            break;
        case "cp_sewerzombies":
            mapname = &"Sewer Zombies (CP)";
            break;
        case "cp_banana":
            mapname = &"Banana (CP)";
            break;
        case "cp_trainingday":
            mapname = &"Training Day (CP)";
            break;
        case "cp_apartments":
            mapname = &"Apartments (CP)";
            break;
        case "germantrainingbase":
            mapname = &"German Training Base";
            break;
        case "mp_vok_final_night":
            mapname = &"Valley of the Kings";
            break;
        case "quarantine":
            mapname = &"Quarantine";
            break;
        case "goldeneye_bunker":
            mapname = &"Goldeneye Bunker";
            break;
        case "toybox_bloodbath":
            mapname = &"Toybox";
            break;  
    //
        case "random":
            mapname = &"Random Map";
            break;
    //
        default:
            mapname = map;
            break;
    }

    return mapname;
}

get_long_name( map ) {
    switch ( map ) {
    // stock maps 1.5
        case "mp_bocage":
            mapname = "Bocage";
            break;
        case "mp_brecourt":
            mapname = "Brecourt";
            break;
        case "mp_carentan":
            mapname = "Carentan";
            break;
        case "mp_chateau":
            mapname = "Chateau";
            break;
        case "mp_dawnville":
            mapname = "Dawnville";
            break;
        case "mp_depot":
            mapname = "Depot";
            break;
        case "mp_harbor":
            mapname = "Harbor";
            break;
        case "mp_hurtgen":
            mapname = "Hurtgen";
            break;
        case "mp_neuville":
            mapname = "Neuville";
            break;
        case "mp_pavlov":
            mapname = "Pavlov";
            break;
        case "mp_powcamp":
            mapname = "P.O.W Camp";
            break;
        case "mp_railyard":
            mapname = "Railyard";
            break;
        case "mp_rocket":
            mapname = "Rocket";
            break;
        case "mp_ship":
            mapname = "Ship";
            break;
        case "mp_stalingrad":
            mapname = "Stalingrad";
            break;
        case "mp_tigertown":
            mapname = "Tigertown";
            break;

    // custom maps
        case "alcatraz":
            mapname = "Alcatraz";
            break;
        case "cp_zombies":
            mapname = "Zombies (CP)";
            break;
        case "cp_trifles":
            mapname = "Trifles (CP)";
            break;
        case "cp_shipwreck":
            mapname = "Shipwreck (CP)";
            break;
        case "cp_zombiebunkers":
            mapname = "Zombie Bunkers (CP)";
            break;
        case "cp_omahgawd":
            mapname = "omahgawd (CP)";
            break;
        case "simon_hai":
            mapname = "Hai (Simon)";
            break;
        case "cp_sewerzombies":
            mapname = "Sewer Zombies (CP)";
            break;
        case "cp_banana":
            mapname = "Banana (CP)";
            break;
        case "cp_trainingday":
            mapname = "Training Day (CP)";
            break;
        case "cp_apartments":
            mapname = "Apartments (CP)";
            break;
        case "germantrainingbase":
            mapname = "German Training Base";
            break;
        case "mp_vok_final_night":
            mapname = "Valley of the Kings";
            break;
        case "quarantine":
            mapname = "Quarantine";
            break;
        case "goldeneye_bunker":
            mapname = "Goldeneye Bunker";
            break;
        case "toybox_bloodbath":
            mapname = "Toybox";
            break;  
    //
        case "random":
            mapname = "Random Map";
            break;
    //
        default:
            mapname = map;
            break;
    }

    return mapname;
}
