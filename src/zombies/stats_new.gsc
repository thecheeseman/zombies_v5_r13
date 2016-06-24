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

	query = "DESCRIBE zombies.player_stats";
    if ( mysql_query( level.db, query ) ) {
        [[ level.sql_error ]]();
    } else {
    	result = mysql_store_result( level.db );
        if ( result ) {
            if ( mysql_num_rows( result ) ) {
                row = mysql_fetch_row( result );
                for ( i = 0; i < mysql_num_rows( result ); i++ ) {
                	if ( !isDefined( row ) )
                		break;

                	level.statsfields[ level.statsfields.size ] = row[ 0 ];
                	row = mysql_fetch_row( result );
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
	thread sql();
}

sql() {
	if ( !level.stats )
		return;
}
