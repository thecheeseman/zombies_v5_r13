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
    level.logfile = "zombies_debug.log";
    level.logwrite = ::logwrite;

    level.pendatic = true;

    [[ level.logwrite ]]( "maps\\mp\\gametypes\\_debug.gsc::init()", true );
}

/*  
    Replace the function below with this if you don't want
    CoDExtended functionality
*/

/*
logwrite( data ) {
    logprint( data + "\n" );
}
*/

logwrite( data, pendantic ) {
    if ( !isDefined( pendatic ) ) {
        pendantic = false;
    }

    // don't print stupid shit unless i want it
    if ( pendantic && !level.pendatic ) {
        return;
    }

    handle = fopen( level.logfile, "a" );
    if ( handle == -1 ) {
        fse( "problem opening file " + level.logfile );
        return;
    }

    fulldata = "" + (float)( gettime() / 1000 ) + "\t" + data + "\n";

    fwrite( fulldata, handle );
    fclose( handle );

    //printconsole( "debug: " + data + "\n" );
}

// file system error
fse( error, serious ) {
    if ( isDefined( serious ) && serious ) {
        iPrintLnBold( "^1fse: ^7" + error );
        printconsole( "!!!!! fse: " + error + "\n" );
    } else {
        iPrintLn( "^1fse: ^7" + error );
        printconsole( "fse: " + error + "\n" );
    }
}
