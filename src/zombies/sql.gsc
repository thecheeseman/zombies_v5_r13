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

init() {
    level.sql_error = ::sql_error;

    level.db = mysql_init();

    if ( level.db ) {
        // try and read from cvars
        level.db_hostname = getCvar( "db_hostname" );
        level.db_user =     getCvar( "db_user" );
        level.db_password = getCvar( "db_password" );
        level.db_database = getCvar( "db_database" );
        level.db_port =     getCvar( "db_port" );
        // try and read from cvars

        // defaults in case cvars are not set
        if ( level.db_hostname == "" )  level.db_hostname = "localhost";
        if ( level.db_user == "" )      level.db_user = "zombies";
        if ( level.db_password == "" )  level.db_password = "changeme";
        if ( level.db_database == "" )  level.db_database = "zombies";
        if ( level.db_port == "" ) 
            level.db_port = 3306;
        else
            level.db_port = getCvarInt( "db_port" );
        // defaults in case cvars are not set

        // try connect to db
        connid = mysql_real_connect( level.db, level.db_hostname, level.db_user, level.db_password, level.db_database, level.db_port );
        if ( connid != level.db ) {
            sql_error();
            return;
        }
    } else {
        printconsole( "[MySQL] Error instantiating MySQL\n" );
        return;
    }

    printconsole( "[MySQL] Successfully connected to database `" + level.db_database + "`!\n" );

// FIRST TIME CHECK
    if ( getCvar( "db_serverid" ) == "" ) 
        level.serverid = 1;
    else
        level.serverid = getCvarInt( "db_serverid" );

    if ( mysql_query( level.db, "SELECT zombies_build FROM zombies.server WHERE id=" + level.serverid ) ) {
        sql_error();
        return;
    }

    result = mysql_store_result( level.db );
    if ( !result ) {
        sql_error();
        return;
    }

    if ( mysql_num_rows( result ) == 0 ) {
        mysql_free_result( result );

        sql_first_time();
// FIRST TIME CHECK
    } else {
        // we only will fetch the first row
        // should probably implement a multiple server check but i'm too lazy.....
        row = mysql_fetch_row( result );
        if ( isDefined( row[ 0 ] ) ) {
            printconsole( "[MySQL] Build (" + row[ 0 ] + ") vs. Script (" + level.zombies_build + ")\n" );

            // check if there's an update for SQL stuff
            if ( row[ 0 ] == level.zombies_build ) {
                printconsole( "[MySQL] No update required!\n" );
            } else {
                printconsole( "[MySQL] Versions differ -- processing update...\n" );
                sql_update( level.serverid );
            }
        } else {
            printconsole( "[MySQL] Couldn't retrieve build information\n" );
        }

        mysql_free_result( result );

        // update some persistent info
        query = "UPDATE zombies.server SET ip_address='" + getCvar( "net_ip" ) + "', port=" + getCvarInt( "net_port" ) + ", hostname='" + getCvar( "sv_hostname" ) + "' WHERE id=" + level.serverid;
        if ( mysql_query( level.db, query ) ) {
            sql_error();
            return;
        }
    }
}

sql_error() {
    printconsole( "[MySQL] Error: " + mysql_error( level.db ) + "\n" );
}

// called from end of game
// TODO: call this on /map changes?
sql_close() {
    mysql_close( level.db );
}

/*
    sql_saveendgame()
    Update MySQL with _all_ of the saved data
*/
sql_saveendgame( winner ) {
    players = getEntArray( "player", "classname" );

    // update map_history 
    length = ( level.endtime - level.starttime ) / 1000;
    query = "INSERT INTO zombies.map_history (server_id, map_id, round_length, winner, players_at_end) VALUES (" + level.serverid + "," + level.mapinfo.id + ",";
    query += length + "," + "'" + winner + "'," + players.size + ")";
    if ( mysql_query( level.db, query ) ) {
        sql_error();
    }

    // save player's data first
    zombies\stats::saveAll();
    // save player's data first

    // map info
    zombies\weather::save_mapinfo();
    // map info
}

/*
    sql_update() allows us to auto update any SQL entries / changes in the database
    and propogate them without having to do messy sql queries manually

    atm it's just a placeholder and really just sets the version info
*/
sql_update( id ) {
    query = "UPDATE zombies.server SET ip_address='" + getCvar( "net_ip" ) + "', port=" + getCvarInt( "net_port" ) + ", hostname='" + getCvar( "sv_hostname" ) + "', ";
    query += "zomextended_build='" + getCvar( "zomextended_build" ) + "', zombies_build='" + level.zombies_build + "', zombies_last_updated='" + level.zombies_last_updated + "', ";
    query += "zombies_version='" + utilities::monotone( level.zombies_version )+ "', zombies_full_version='" + utilities::monotone( level.zombies_full_version_tag ) + "' ";
    query += "WHERE id=" + id;

    if ( mysql_query( level.db, query ) ) {
        sql_error();
        return;
    }

// new updates here
    switch ( level.zombies_build ) {
        default:
            query = "";
            break;
    }

    if ( query != "" ) {
        if ( mysql_query( level.db, query ) ) {
            sql_error();
            return;
        }   
    }
// new updates here

    printconsole( "[MySQL] Update completed!\n" );
}

/*
    first time initialisation of the server
*/
sql_first_time() {
    query = "INSERT INTO zombies.server (ip_address, port, hostname, zomextended_build, zombies_build, zombies_last_updated, zombies_version, zombies_full_version) VALUES (";
    query += "'" + getCvar( "net_ip" ) + "', " + getCvarInt( "net_port" ) + ", '" + getCvar( "sv_hostname" ) + "', '" + getCvar( "zomextended_build" ) + "', ";
    query += "'" + level.zombies_build + "', '" + level.zombies_last_updated + "', '" + utilities::monotone( level.zombies_version )+ "', '" + utilities::monotone( level.zombies_full_version_tag ) + "')";

    if ( mysql_query( level.db, query ) ) {
        sql_error();
        return;
    }
}