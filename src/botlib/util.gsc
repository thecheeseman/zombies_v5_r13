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

//
// botcheck( ply )
// checks if level.botmap is true, and then
// if <ply> is defined,
// checks if <ply> is indeed a bot (or alive)
//
botcheck( ply, aliveCheck ) {
    if ( !level.botmap )
        return false;

    if ( isDefined( ply ) && isPlayer( ply ) ) {
        if ( !ply isBot() )
            return false;

        if ( isDefined( aliveCheck ) && aliveCheck && 
            !isAlive( ply ) || ply.sessionstate != "playing" )
            return false;
    }

    return true;
}

//
//
//
getEyePos() {
    return self getEye() + ( 0, 0, 20 );
}

//
//
//
isFacingTarget( target ) {
    if ( !isDefined( target ) ) {
        return false;
    }

    dir = vectorNormalize( target.origin - self.origin );
    forward = anglesToForward( self getPlayerAngles() );
    dot = _vectorDot( dir, forward );

    if ( dot > 0.25 ) {
        return true;
    }

    return false;
}

//
//
//
canTraceTo( location ) {
    trace = bullettrace( self getEyePos(), location, false, self );
    if ( trace[ "fraction" ] == 1 )
        return true;

    return false;
}

//
//
//
canSee( location ) {
    if ( !canTraceTo( location ) ) 
        return false;

    return true;
}

//
//
//
canSeePlayer( ply ) {
    if ( !canTraceTo( ply getEyePos() ) )
        return false;

    return true;
}

//
//
//
findRandomSpawnpoint() {
    spn = [];

    spn[ spn.size ] = "mp_teamdeathmatch_spawn";
    spn[ spn.size ] = "mp_deathmatch_spawn";
    spn[ spn.size ] = "mp_searchanddestroy_spawn_allied";
    spn[ spn.size ] = "mp_searchanddestroy_spawn_axis";
    spn[ spn.size ] = "mp_retrieval_spawn_allied";
    spn[ spn.size ] = "mp_retrieval_spawn_axis";

    spawnpoints = undefined;
    for ( i = 0; i < spn.size; i++ ) {
        spawnpointname = spn[ i ];
        spawnpoints = getEntArray( spawnpointname, "classname" );

        if ( spawnpoints.size > 0 )
            break;
    }

    if ( !isDefined( spawnpoints ) || spawnpoints.size == 0 )
        maps\mp\_utility::error( "NO SPAWNPOINTS IN MAP" );

    spawnpoint = spawnpoints[ randomInt( spawnpoints.size ) ];

    // drop to ground
    trace = bullettrace( spawnpoint.origin, spawnpoint.origin + ( 0, 0, -10000 ), false, self );
    return trace[ "position" ];
}

//
//
//
getGoodPlayers() {
    players = getEntArray( "player", "classname" );
    good = [];

    for ( i = 0; i < players.size; i++ ) {
        if ( players[ i ].sessionstate != "playing" )
            continue;

        if ( !isAlive( players[ i ] ) )
            continue;

        if ( players[ i ].pers[ "team" ] != "axis" )
            continue;

        good[ good.size ] = players[ i ];
    }

    return good;
}

//
//
//
setBotAngles( angles, lerpspeed ) {
    //vectorToAngles(VectorNormalize(VectorSmooth(anglesToForward(self getplayerangles()), VectorNormalize(tempWp-self.origin), 0.5))));
    self setPlayerAngles( vectorToAngles( vectorNormalize( vectorSmooth( anglesToForward( self getPlayerAngles() ), vectorNormalize( angles ), lerpspeed ) ) ) );
}

//
//
//
vectorSmooth( x, y, factor ) {
    recip = 1.0 - factor;

    return ( vectorScale( x, recip ) + vectorScale( y, factor ) );
}
