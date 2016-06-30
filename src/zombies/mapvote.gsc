/*
    Zombies, Version 5, Revision 13
    Copyright (C) 2016, DJ Hepburn

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

init()
{
    [[ level.precache ]]( "hudStopwatch", "shader" );
    [[ level.precache ]]( "levelshots/unknownmap.dds" );
    [[ level.precache ]]( &"Time Left: " );
    [[ level.precache ]]( &"Vote in progress... please wait..." );
    [[ level.precache ]]( &"You have voted for: " );
    [[ level.precache ]]( &"Winner: " );

    level.mapvote = spawnstruct();
    level.mapvote.time =                zombies\config::cvardef( "mv_time", 20, 5, 30, "int" );
    level.mapvote.include_custom =      zombies\config::cvardef( "mv_include_custom", 0, 0, 1, "int" );
    level.mapvote.maprotation =         zombies\config::cvardef( "mv_maprotation", "", undefined, undefined, "string", true );
    level.mapvote.candidate_amount =    zombies\config::cvardef( "mv_candidate_amount", 4, 4, 6, "int" );   // hard-coded for now, but we can change it later to be dynamic

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

    level.mapvote.randommap = undefined;

    parse_map_rotation();
    pick_maps();
}

/*
    main()
*/
main() {
    // grab current list of players
    players = getEntArray( "player", "classname" );

    spawn_hud();

    // set map candidates
    for ( i = 0; i < level.mapvote.candidate_amount; i++ )
        level.mv_candidate[ i ] setText( level.mapvote.selections[ i ].localized );

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

    // TODO: add special case for tie-breaker
    winner = 0;
    points = 0;
    for ( i = 0; i < level.mapvote.selections.size; i++ ) {
        sel = level.mapvote.selections[ i ];

        if ( sel.votes > points ) {
            winner = i;
            points = sel.votes;
        }
    }

    for ( i = 0; i < 4; i++ ) {
        level.mv_candidate[ i ] fadeOverTime( 1 );
        level.mv_candidate[ i ].alpha = 0;
        level.mv_candidate_votes[ i ] fadeOverTime( 1 );
        level.mv_candidate_votes[ i ].alpha = 0;
    }

    wait 1;

    if ( level.mapvote.selections[ winner ].map_name == "random" )
        level.mv_img setShader( "levelshots/unknownmap.dds", 256, 192 );
    else
        level.mv_img setShader( "levelshots/" + level.mapvote.selections[ winner ].map_name + ".dds", 256, 192 );
    level.mv_img fadeOverTime( 0.2 );
    level.mv_img.alpha = 1;

    level.mv_txt_winner_is fadeOverTime( 0.2 );
    level.mv_txt_winner_is.alpha = 1;

    level.mv_txt_winner setText( level.mapvote.selections[ winner ].localized );
    level.mv_txt_winner fadeOverTime( 0.2 );
    level.mv_txt_winner.alpha = 1;

    level.mv_candidate[ winner ] fadeOverTime( 0.2 );
    level.mv_candidate[ winner ].alpha = 1;
    level.mv_candidate_votes[ winner ] fadeOverTime( 0.2 );
    level.mv_candidate_votes[ winner ].alpha = 1;

    wait 5;

    level.mv_img fadeOverTime( 1 );
    level.mv_img.alpha = 0;

    level.mv_txt_winner_is fadeOverTime( 1 );
    level.mv_txt_winner_is.alpha = 0;

    level.mv_txt_winner fadeOverTime( 1 );
    level.mv_txt_winner.alpha = 0;

    level.mv_candidate[ winner ] fadeOverTime( 1 );
    level.mv_candidate[ winner ].alpha = 0;
    level.mv_candidate_votes[ winner ] fadeOverTime( 1 );
    level.mv_candidate_votes[ winner ].alpha = 0;

    wait 1;

    level.mv_lb_top destroy();
    level.mv_lb_bot destroy();

    hud_fade( "out", 1, true );

    wait 1;

    remove_hud();

    for ( i = 0; i < players.size; i++ )
        players[ i ] remove_player_hud();

    // if the winner is random map, use it
    if ( level.mapvote.selections[ winner ].map_name == "random" ) {
        if ( isDefined( level.mapvote.randommap ) ) {
            setCvar( "sv_maprotationcurrent", " map " + level.mapvote.randommap );
        } else {
            // just select a random stock map
            setCvar( "sv_maprotationcurrent", " map " + level.mapvote.stockmaps[ randomInt( level.mapvote.stockmaps.size ) ] );
        }
    } else {
        setCvar( "sv_maprotationcurrent", " map " + level.mapvote.selections[ winner ].map_name );
    }

    level notify( "mapvote_done" );
}

/*
    parse_map_rotation()
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
    rot = utilities::explode( mv_maprotation, " " );
    maps = [];
    for ( i = 0; i < rot.size; i++ ) {
        if ( rot[ i ] == "" )
            continue;

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
    pick_maps()
    Chooses three maps from the rotation and then
    precaches their info

    Determines maps ahead of time based on the previous
    match's player count at the end of the game
*/
pick_maps() {
    maps = [];
    mostplayed = [];    // option #1 - random selection from the top 3 most played maps
    middleplayed = [];  // option #2 - random selection from the middle tier of played maps
    leastplayed = [];   // option #3 - random selection from the bottom 3 played maps

    // grab the second to last map we played
    lastmap = undefined;
    query = "SELECT m.map_name FROM zombies.map_history mh, zombies.maps m WHERE mh.map_id = m.id ORDER BY time_ended DESC LIMIT 1";
    if ( mysql_query( level.db, query ) ) {
        [[ level.sql_error ]]();
        pick_rotation_fallback();
        return;
    }

    result = mysql_store_result( level.db );
    if ( !result ) {
        [[ level.sql_error ]]();
        pick_rotation_fallback();
        return;
    }

    if ( mysql_num_rows( result ) ) {
        row = mysql_fetch_row( result );
        if ( isDefined( row ) ) {
            lastmap = row[ 0 ];
        }
    }

    mysql_free_result( result );
    
    // grab the list of maps sorted by how often they've been played
    query = "SELECT m.map_name FROM zombies.maps AS m LEFT JOIN zombies.map_history AS mh ON mh.map_id = m.id AND mh.server_id = '" + level.serverid + "'";
    if ( !level.mapvote.include_custom ) {
        query += " WHERE m.is_stock_map = '1'";
    }

    query += " GROUP BY m.map_name ORDER BY COUNT(*) DESC";

    if ( mysql_query( level.db, query ) ) {
        [[ level.sql_error ]]();
        pick_rotation_fallback();  // if we can't grab MySQL info, just pick random maps from the rotation
        return;
    }

    result = mysql_store_result( level.db );
    if ( !result ) {
        [[ level.sql_error ]]();
        pick_rotation_fallback();
        return;
    }

    if ( mysql_num_rows( result ) == 0 ) {
        printconsole( "[mapvote.gsc] No rows in the `maps` table!\n" );
        pick_rotation_fallback();
        return;
    }

    row = mysql_fetch_row( result );
    for ( i = 0; i < mysql_num_rows( result ); i++ ) {
        if ( !isDefined( row ) )
            break;

        skip = false;

        // don't add the current map to the list
        if ( row[ 0 ] == level.mapname )
            skip = true;

        // don't add second to last map
        if ( isDefined( lastmap ) && row[ 0 ] == lastmap )
            skip = true;            

        if ( !skip )
            maps[ maps.size ] = row[ 0 ];

        row = mysql_fetch_row( result );
    }

    mysql_free_result( result );

    if ( maps.size == 0 ) {
        printconsole( "[mapvote] Didn't add any maps to maps array!\n" );
        pick_rotation_fallback();
        return;
    }

    // sort maps
    for ( i = 0; i < maps.size; i++ ) {
        if ( i < 3 ) 
            mostplayed[ mostplayed.size ] = maps[ i ];
        else if ( i >= ( maps.size - 3 ) )
            leastplayed[ leastplayed.size ] = maps[ i ];
        else
            middleplayed[ middleplayed.size ] = maps[ i ];
    }

    opt1 = mostplayed[ randomInt( mostplayed.size ) ];
    opt2 = middleplayed[ randomInt( middleplayed.size ) ];
    opt3 = leastplayed[ randomInt( leastplayed.size ) ];

    add_selection( opt1 );
    add_selection( opt2 );
    add_selection( opt3 );

    // remove the #2 option from the random pool
    availablernd = [];
    for ( i = 0; i < middleplayed.size; i++ ) {
        if ( middleplayed[ i ] == opt2 )
            continue;

        availablernd[ availablernd.size ] = middleplayed[ i ];
    }

    add_selection( "random" );

    if ( availablernd.size > 0 )
        level.mapvote.randommap = availablernd[ randomInt( availablernd.size ) ];
    else
        level.mapvote.randommap = undefined;
}

pick_rotation_fallback() {
    maps = [];
    playercount = 16;
    
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
        maps = utilities::arrayShuffle( maps );
    }

    for ( i = 0; i < level.mapvote.candidate_amount - 1; i++ ) {
        add_selection( maps[ i ] );
    }

    availablernd = [];
    for ( i = 0; i < maps.size; i++ ) {
        for ( j = 0; j < level.mapvote.selections.size; j++ ) {
            if ( maps[ i ] == level.mapvote.selections[ j ].map_name )
                continue;
        }

        availablernd[ availablernd.size ] = maps[ i ];
    }

    add_selection( "random" );

    if ( availablernd.size > 0 )
        level.mapvote.randommap = availablernd[ randomInt( availablernd.size ) ];
    else
        level.mapvote.randommap = undefined;
}

/*
    add_selection()
*/
add_selection( mapname ) {
    s = spawnstruct();
    s.map_name = mapname;
    s.long_name = get_long_name( mapname );
    s.localized = toLocalizedString( s.long_name );
    s.votes = 0;

    [[ level.precache ]]( s.localized );
    [[ level.precache ]]( "levelshots/" + s.map_name + ".dds" );

    level.mapvote.selections[ level.mapvote.selections.size ] = s;
}

/*
    timer()
*/
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

    wait 1; // so we can see it reach 0:00

    stopwatch destroy();

    level notify( "mapvote_voting_done" );
}

/*
    vote_logic()
    handle's global vote info
*/
vote_logic( players ) {
    wait 0.05;

    level endon( "mapvote_voting_done" );

    while ( true ) {
        for ( i = 0; i < level.mapvote.selections.size; i++ )
            level.mapvote.selections[ i ].votes = 0;

        for ( i = 0; i < players.size; i++ ) {
            if ( !isDefined( players[ i ] ) )
                continue;
            
            if ( isDefined( players[ i ].mv_vote ) )
                level.mapvote.selections[ players[ i ].mv_vote ].votes++;
        }

        level.mv_candidate_votes[ 0 ] setValue( level.mapvote.selections[ 0 ].votes );
        level.mv_candidate_votes[ 1 ] setValue( level.mapvote.selections[ 1 ].votes );
        level.mv_candidate_votes[ 2 ] setValue( level.mapvote.selections[ 2 ].votes );
        level.mv_candidate_votes[ 3 ] setValue( level.mapvote.selections[ 3 ].votes );

        wait 0.1;
    }
}

/*
    player_vote()
    handle's each player's vote and hud updates
*/
player_vote() {
    self endon( "disconnect" );
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

            if ( self.mv_vote == level.mapvote.candidate_amount )
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

/*
    spawn_hud()
    global hud
*/
spawn_hud() {
    // black background
    level.mv_bg =               spawn_hud_element( "global", 320, 240, 10, 0 );
    level.mv_bg setShader( "black", 260, 308 );

    // final winner image
    level.mv_img =              spawn_hud_element( "global", 320, 216, 15, 0 );
    level.mv_img setShader( "black", 256, 192 );

    // letterbox bars
    level.mv_lb_top =           spawn_hud_element( "global", 320, 116, 18, 0 );
    level.mv_lb_top setShader( "black", 256, 60 );
    level.mv_lb_bot =           spawn_hud_element( "global", 320, 316, 18, 0 );
    level.mv_lb_bot setShader( "black", 256, 60 );

    // Winner:
    level.mv_txt_winner_is =    spawn_hud_element( "global", 320, 102, 30, 0, 1.5 );
    level.mv_txt_winner_is setText( &"Winner: " );

    // map winner
    level.mv_txt_winner =       spawn_hud_element( "global", 320, 126, 30, 0, 2, ( 0, 1, 0 ) );

    // background white bars
    level.mv_bg_top =           spawn_hud_element( "global", 320, 87, 50, 0 );
    level.mv_bg_top setShader( "white", 256, 2 );
    level.mv_bg_bot =           spawn_hud_element( "global", 320, 393, 50, 0 );
    level.mv_bg_bot setShader( "white", 256, 2 );
    level.mv_bg_midtop =        spawn_hud_element( "global", 320, 146, 50, 0 );
    level.mv_bg_midtop setShader( "white", 256, 2 );
    level.mv_bg_midbot =        spawn_hud_element( "global", 320, 286, 50, 0 );
    level.mv_bg_midbot setShader( "white", 256, 2 );
    level.mv_bg_left =          spawn_hud_element( "global", 191, 240, 50, 0 );
    level.mv_bg_left setShader( "white", 2, 308 );
    level.mv_bg_right =         spawn_hud_element( "global", 449, 240, 50, 0 );
    level.mv_bg_right setShader( "white", 2, 308 );
    level.mv_bg_rightmid =      spawn_hud_element( "global", 416, 340, 50, 0 );
    level.mv_bg_rightmid setShader( "white", 2, 106 );

    level.mv_candidate = [];
    level.mv_candidate_votes = [];

    for ( i = 0; i < level.mapvote.candidate_amount; i++ ) {
        level.mv_candidate[ i ] =       spawn_hud_element( "global", 300, ( 298 + ( 26 * i ) ), 40, 0, 1.4 );
        level.mv_candidate_votes[ i ] = spawn_hud_element( "global", 432, ( 298 + ( 26 * i ) ), 40, 0, 1.4 );
        level.mv_candidate_votes[ i ] setValue( 0 );
    }
}

/*
    spawn_player_hud()
    per player
*/
spawn_player_hud() {
    // img for player vote
    self.mv_img =           self spawn_hud_element( "client", 320, 216, 15, 0 );
    self.mv_img setShader( "black", 256, 256 );

    // text
    self.mv_txt_voted_for = self spawn_hud_element( "client", 320, 102, 30, 0, 1.5 );
    self.mv_txt_voted_for setText( &"You have voted for: " );
    self.mv_txt_ply_vote =  self spawn_hud_element( "client", 320, 126, 30, 0, 2, ( 0, 1, 0 ) );

    // selector
    self.mv_selector =      self spawn_hud_element( "client", 320, 300, 35, 0, undefined, ( 0, 1, 0 ) );
    self.mv_selector setShader( "white", 256, 28 );
}

/*
    spawn_hud_element()
*/
spawn_hud_element( type, x, y, sort, alpha, fontscale, colour ) {
    if ( !isDefined( type ) )       type = "global";
    if ( !isDefined( x ) )          x = 0;
    if ( !isdefined( y ) )          y = 0;
    if ( !isDefined( sort ) )       sort = 1;
    if ( !isDefined( alpha ) )      alpha = 1;
    if ( !isDefined( fontscale ) )  fontscale = 1;
    if ( !isDefined( colour ) )     colour = ( 1, 1, 1 );

    if ( type == "client" )
        elem = newClientHudElem( self );
    else
        elem = newHudElem();

    elem.x = x;
    elem.y = y;
    elem.alignx = "center";
    elem.aligny = "middle";
    elem.sort = sort;
    elem.alpha = alpha;
    elem.fontscale = fontscale;
    elem.color = colour;

    return elem;
}

/*
    hud_fade()
    global hud fade in/out
*/
hud_fade( type, time, waitatend ) {
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

    if ( !isDefined( waitatend ) )
        wait time;

    if ( isDefined( level.mv_lb_top ) ) {
        level.mv_lb_top fadeOverTime( time );
        level.mv_lb_bot fadeOverTime( time );
        level.mv_lb_top.alpha = val;
        level.mv_lb_bot.alpha = val;
    }

    for ( i = 0; i < level.mapvote.candidate_amount; i++ ) {
        level.mv_candidate[ i ] fadeOverTime( time );
        level.mv_candidate[ i ].alpha = val;
        level.mv_candidate_votes[ i ] fadeOverTime( time );
        level.mv_candidate_votes[ i ].alpha = val;
    }

    if ( isDefined( waitatend ) && waitatend )
        wait time;
}

/*
    player_hud_fade()
    player hud fade in/out
*/
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

/*
    remove_hud()
*/
remove_hud() {
    if ( isDefined( level.mv_bg ) )             level.mv_bg destroy();
    if ( isDefined( level.mv_bg_top ) )         level.mv_bg_top destroy();
    if ( isDefined( level.mv_bg_bot ) )         level.mv_bg_bot destroy();
    if ( isDefined( level.mv_bg_midtop ) )      level.mv_bg_midtop destroy();
    if ( isDefined( level.mv_bg_midbot ) )      level.mv_bg_midbot destroy();
    if ( isDefined( level.mv_bg_left ) )        level.mv_bg_left destroy();
    if ( isDefined( level.mv_bg_right ) )       level.mv_bg_right destroy();
    if ( isDefined( level.mv_bg_rightmid ) )    level.mv_bg_rightmid destroy();
    if ( isDefined( level.mv_lb_top ) )         level.mv_lb_top destroy();
    if ( isDefined( level.mv_lb_bot ) )         level.mv_lb_bot destroy();

    if ( isDefined( level.mv_img ) )            level.mv_img destroy();
    if ( isDefined( level.mv_txt_winner_is ) )  level.mv_txt_winner_is destroy();
    if ( isDefined( level.mv_txt_winner ) )     level.mv_txt_winner destroy();

    for ( i = 0; i < level.mapvote.candidate_amount; i++ ) {
        if ( isDefined( level.mv_candidate[ i ] ) )         level.mv_candidate[ i ] destroy();
        if ( isDefined( level.mv_candidate_votes[ i ] ) )   level.mv_candidate_votes[ i ] destroy();
    }
}

/*
    remove_player_hud()
*/
remove_player_hud() {
    if ( isDefined( self.mv_img ) )             self.mv_img destroy();
    if ( isDefined( self.mv_txt_voted_for) )    self.mv_txt_voted_for destroy();
    if ( isDefined( self.mv_txt_ply_vote ) )    self.mv_txt_ply_vote destroy();
    if ( isDefined( self.mv_selector ) )        self.mv_selector destroy();
}

/*
    other funcs
*/
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
