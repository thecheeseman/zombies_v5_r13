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
	[[ level.logwrite ]]( "zombies\\stats.gsc::init()", true );

	level.statsfields = [];
	level.stats = true;

    // retrieve all the possible stat fields from SQL 
	query = "DESCRIBE zombies.player_stats";
    if ( mysql_query( level.db, query ) ) {
        [[ level.sql_error ]]();
    } else {
    	result = mysql_store_result( level.db );
        if ( result ) {
            if ( mysql_num_rows( result ) ) {
                row = mysql_fetch_field( result );
                for ( i = 0; i < mysql_num_fields( result ); i++ ) {
                	if ( !isDefined( row ) )
                		break;

                    add = true;

                    // ignore certain rows
                    switch ( row[ 0 ] ) {
                        case "id":
                        case "player_id":
                            add = false;
                            break;
                    }

                    if ( add )
                	   level.statsfields[ level.statsfields.size ] = row[ 0 ];

                	row = mysql_fetch_fields( result );
                }
            }

            mysql_free_result( result );
        } else {
            [[ level.sql_error ]]();
        }
    }

    if ( level.statsfields.size == 0 ) {
    	level.stats = false;
    	printconsole( "[stats.gsc] Problem populating statsfields, disabling stats..." );
    	return;
    }
}

saveAll() {

}

setupPlayer() {
	if ( !level.stats )
		return;

    self.old_guid = utilities::getNumberedName( self.oldname );

    // select by IP or old system
    query = "SELECT * FROM zombies.players WHERE ip_address=INET_ATON('" + self getip() + "') OR old_guid=" + self.old_guid;
    if ( mysql_query( level.db, query ) ) {
        [[ level.sql_error ]]();
    } else {
        result = mysql_store_result( level.db );
        if ( result ) {
            if ( mysql_num_rows( result ) ) {
                // welcome back
                row = mysql_fetch_row( result );
            } else {
                // didn't find them by IP or old name, so either 
                // a) they are new
                // b) they haven't been transitioned to the new system yet

                filename = "stats/players/" + self.old_guid + ".dat";
                if ( fexists( filename ) ) {
                    // haven't been transitioned yet
                    query = "INSERT INTO zombies.players (name, old_guid, ip_address) VALUES('" + self.name + "', " + self.old_guid + ", INET_ATON('" + self getip() + "'))";

                    if ( mysql_query( level.db, query ) ) {
                        [[ level.sql_error ]]();
                    }
                } else {
                    // brand new
                }
            }

            mysql_free_result( result );
        } else {
            [[ level.sql_error ]]();
        }
    }
}
