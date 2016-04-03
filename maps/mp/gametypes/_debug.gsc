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
}

// file system error
fse( error, serious ) {
    if ( isDefined( serious ) && serious ) {
        iPrintLnBold( "^1fse: ^7" + error );
        logprint( "!!!!! fse: " + error + "\n" );
    } else {
        iPrintLn( "^1fse: ^7" + error );
        logprint( "fse: " + error + "\n" );
    }
}
