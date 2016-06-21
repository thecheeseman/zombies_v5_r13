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
	[[ level.logwrite ]]( "zombies\\weather.gsc::init()", true );

	[[ level.precache ]]( "fx/atmosphere/thunderhead.efx" );
	[[ level.precache ]]( "fx/atmosphere/lowlevelburst.efx" );

    level.timeofday = "day";
    if ( _randomInt( 100 ) > 30 )
        level.timeofday = "night";

    level.darkness = 0;
	level.fogdist = 1500;
}

main() {
	// [mapname].gsc is called on the same frame as this script
	// wait a frame to override map's fog
	wait frame();

    [[ level.logwrite ]]( "zombies\\weather.gsc::main()", true );

    // find map center
    entities = getEntArray();
    
    xmin = entities[ 0 ].origin[ 0 ];
    xmax = xmin;
    ymin = entities[ 0 ].origin[ 1 ];
    ymax = ymin;
    zmin = entities[ 0 ].origin[ 2 ];
    zmax = zmin;
    
    for ( i = 0; i < entities.size; i++ ) {
        e = entities[ i ];
        if ( e.origin[ 0 ] > xmax )
            xmax = e.origin[ 0 ];
        if ( e.origin[ 1 ] > ymax )
            ymax = e.origin[ 2 ];
        if ( e.origin[ 2 ] > zmax )
            zmax = e.origin[ 2 ];
            
        if ( e.origin[ 0 ] < xmin )
            xmin = e.origin[ 0 ];
        if ( e.origin[ 1 ] < ymin )
            ymin = e.origin[ 2 ];
        if ( e.origin[ 2 ] < zmin )
            zmin = e.origin[ 2 ];    
    }
    
    x = (int)( xmax + xmin ) / 2;
    y = (int)( ymax + ymin ) / 2;
    z = (int)( zmax + zmin ) / 2;
    
    endz = z + 65536;
    trace = bullettrace( ( x, y, z ), ( x, y, endz ), false, undefined );
    if ( trace[ "fraction" ] != 1 ) 
        z = endz - ( 65536 * trace[ "fraction" ] ) - 100;
        
    level.center = ( x, y, z );
    // find map center

    setdefaultfog();
}

setdefaultfog() {
    if ( level.timeofday == "night" ) {
        level.darkness = 0.7;
        set_fog( "expfog", 0, 0.002, ( 0, 0, 0 ), 0 );

        if ( !level.mapended && level.mapname != "mp_ship" ) {
            if ( _randomInt( 100 ) > 50 )
                ambientPlay( "ambient_mp_chateau" );
            else
                ambientPlay( "ambient_mp_powcamp" );
        }
    } else {
        level.darkness = 0.1;

        switch ( level.mapname ) {
            // other stuff
            case "mp_brecourt":
                set_fog( "expfog", 0, 0.005, ( 0.32157, 0.39608, 0.1451 ), 0 ); // camo green
                break;
            case "mp_depot":
                set_fog( "expfog", 0, 0.0009, ( 0.69804, 0.6, 0.43137 ), 0 );   // dust
                break;
                
            // dusty maps
            case "mp_dawnville":
                set_fog( "expfog", 0, 0.0009, ( 0.69804, 0.6, 0.43137 ), 0 );   // dust
                create_hazard( "haboob" );
                break;
                
            // rainy maps
            case "mp_carentan":
            case "mp_chateau":
            case "mp_powcamp":
            case "mp_ship":
                level.darkness = 0.4; // :D
                set_fog( "expfog", 0, 0.001, ( 0.53725, 0.62745, 0.6902 ), 0 ); // bluey gray
                create_hazard( "rainstorm" );
                break;
                
            // snow maps
            case "mp_harbor":
            case "mp_hurtgen":
            case "mp_pavlov":
            case "mp_railyard":
            case "mp_rocket":
                set_fog( "expfog", 0, 0.0007, ( 1, 1, 1 ), 0 );
                create_hazard( "blizzard" );
                break;

            // custom maps with custom fog
            case "cp_zombies":
            case "cp_trifles":
            case "cp_sewerzombies":
                break;
            
            // otherwise, just revert to original
            default:
                level.darkness = 0.7;
                set_fog( "expfog", 0, 0.002, ( 0, 0, 0 ), 0 );

                if ( !level.mapended )
                    ambientPlay( "ambient_mp_chateau" );
                break;
        }
    }
}

set_fog( type, closeDist, farDist, color, transTime ) {
    if ( !isDefined( type ) || !isDefined( closeDist ) || !isDefined( farDist ) )
        return false;

    if ( !isDefined( color ) )
        color = ( 0, 0, 0 );

    if ( !isDefined( transTime ) )
        transTime = 0;

    switch ( type ) {
        case "cullfog":
            setCullFog( closeDist, farDist, color[ 0 ], color[ 1 ], color[ 2 ], transTime );
            break;
        case "expfog":
            setExpFog( farDist, color[ 0 ], color[ 1 ], color[ 2 ], transTime );
            break;
    }
}

create_hazard( sType ) {
    if ( !isDefined( sType ) )
        return false;
        
    hazard = create_weather_event( "blank" );
    
    switch ( sType ) {
        case "blizzard":
        case "haboob":
        case "rainstorm":
            hazard = create_weather_event( sType, 30, 150 );
            break;
        default:
            return;
            break;
    }
    
    thread run_hazard( hazard );
}

run_hazard( event ) {
    level endon( "end game" );
    
    lasteventtime = gettime();
    nexteventtime = lasteventtime + 300000;
    nexteventtime += ( _randomInt( 500 ) * 1000 );
    
    while ( true ) {
        // at least 3 minutes inbetween 
        if ( gettime() > nexteventtime ) {
            start_weather_event( event );
            
            wait 1;
            
            while ( level.weatherEvent )
                wait 1;
                
            lasteventtime = gettime();
            nexteventtime = lasteventtime + 150000;
            nexteventtime += ( _randomInt( 500 ) * 1000 );
        }
        
        wait 1;
    }
}

create_weather_event( sType, iTransitionTime, iLength ) {
    if ( !isDefined( sType ) || !isDefined( iTransitionTime ) || !isDefined( iLength ) )
        return false;
        
    event = spawnstruct();
    event.type = sType;
    event.starttime = iTransitionTime;
    event.length = iLength;
    event.haslightning = false;
        
    switch ( sType ) {
        case "haboob":
            event.fogtype = "expfog";
            event.fogcolor = ( 0.69804, 0.6, 0.43137 );
            event.fogdistfar = 0.0009;
            event.fogdistclose = 0.008;
            event.fogdistrandom = false;
            break;
        case "blizzard":
            event.fogtype = "expfog";
            event.fogcolor = ( 1, 1, 1 );
            event.fogdistfar = 0.0007;
            event.fogdistclose = 0.007;
            event.fogdistrandom = false;
            break;
        case "rainstorm":
            event.fogtype = "expfog";
            event.fogcolor = ( 0.53725, 0.62745, 0.6902 );
            event.fogdistfar = 0.001;
            event.fogdistclose = 0.004;
            event.fogdistrandom = false;
            event.haslightning = true;
            break;
        default:
            event.type = "blank";
            return false;
            break;
    }
    
    return event;
}

start_weather_event( event ) {
    if ( !isDefined( event ) || ( isDefined( event.type ) && event.type == "blank" ) )
        return false;
        
    if ( !isDefined( event.fogtype ) )
        event.fogtype = "cullfog";
        
    if ( !isDefined( level.weatherQueue ) )
        level.weatherQueue = [];
        
    if ( !isDefined( level.weatherEvent ) )
        level.weatherEvent = false;
        
    if ( !level.weatherEvent ) {        
        thread weather_event_runner( event );
        return;
    }
    
    level.weatherQueue[ level.weatherQueue.size ] = event;
}

weather_event_runner( event ) {
    level endon( "endgame" );

    level.weatherEvent = true;
    
    // transition to event's starting point
    set_fog( event.fogtype, 0, event.fogdistfar, event.fogcolor, event.starttime );
    wait ( event.starttime );
    
    if ( event.haslightning )
        thread lightning_runner( event );
    
    // transition to event itself
    set_fog( event.fogtype, 0, event.fogdistclose, event.fogcolor, event.starttime );
    wait ( event.starttime );

    // wait until event is over
    wait ( event.length );

    // transition back to start point
    set_fog( event.fogtype, 0, event.fogdistfar, event.fogcolor, event.starttime );
    wait ( event.starttime );
    
    level.weatherEvent = false;
    
    if ( level.weatherQueue.size > 0 ) {
        next = level.weatherQueue[ 0 ];
        
        for ( i = 1; i < level.weatherQueue.size; i++ )
            level.weatherQueue[ i - 1 ] = level.weatherQueue[ i ];
        level.weatherQueue[ i - 1 ] = undefined;
        
        thread weather_event_runner( next );
    }
}

lightning_runner( event ) {
    runtime = 0;
    waittime = 0;
    // transition in and out and the total length
    totaltime = ( event.starttime * 2 ) + event.length;
    while ( runtime < totaltime ) {
        if ( waittime == 0 ) {
            // lightning
            playfx( level._effect[ "lowlevelburst" ], level.center );
            waittime = _randomIntRange( 10, 30 );
        }
        
        wait 1;
        
        waittime--;
        runtime++;
    }
}
