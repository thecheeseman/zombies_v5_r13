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
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_weather.gsc::main()", true );
	level._effect[ "thunderhead" ] = loadfx( "fx/atmosphere/thunderhead.efx" );
	level._effect[ "cloudflash" ] = loadfx( "fx/atmosphere/lowlevelburst.efx" );

	level.fogdist = 1500;
}

main() {	
	mapname = maps\mp\gametypes\_zombie::toLower( getCvar( "mapname" ) );
	
	override = true;
	switch ( mapname )
	{
		case "cp_zombies":
		case "cp_trifles":
		case "cp_sewerzombies":
			override = false;
			break;
	}
	
	if ( override )
		thread dofog( mapname );
}

dofog( mapname )
{
	min = 600;
	max = 2200;
	r = 0;
	g = 0;
	b = 0;
	
	switch ( mapname )
	{
		case "mp_brecourt":
		case "mp_dawnville":
		case "mp_hurtgen":
		case "mp_rocket":
		case "mp_ship":
			max = 2600;
			break;

		case "mp_chateau":
		case "mp_powcamp":
		case "simon_hai":
		case "goldeneye_bunker":
			max = 2200;
			break;
		
		case "mp_vok_final_night":
			max = 2700;
			break;
			
		case "cp_apartments":
			max = 1400;
			min = 650;
			r = .45;
			g = .85;
			b = .15;
			break;
	}
	
	setCullFog( 0, max, r, g, b, 0 );
	
	wait 5;
	
	while ( !level.gamestarted )
		wait 1;
	
	level.fogdist = max;
    currentfog = max;
    fogpersec = (float)( max / ( level.timelimit * 60 * 0.6 ) );

    level endon( "endgame" );

    while ( currentfog > min ) {
        currentfog -= fogpersec;
        level.fogdist = currentfog;
	    setCullFog( 0, currentfog, r, g, b, 1 );
	    wait 1;
    }
}

debugfog()
{
	while ( 1 )
	{
		if ( getCvar( "fog" ) != "" )
		{
			rawr = maps\mp\gametypes\_zombie::explode( getCvar( "fog" ), " " );
			setCullFog( rawr[ 0 ], rawr[ 1 ], rawr[ 2 ], rawr[ 3 ], rawr[ 4 ], 1 );
			setCvar( "fog", "" );
		}
		
		wait 0.05;
	}
}

isWinterMap( map ) {
	if ( !isDefined( map ) ) {
		return false;
	}

	switch ( map ) {
		case "mp_harbor":
		case "mp_hurtgen":
		case "mp_pavlov":
		case "mp_railyard":
		case "mp_rocket":
		case "mp_stalingrad":
			return true;
			break;
		default:
			return false;
			break;
	}
}

lightning()
{
	level endon( "intermission" );
	
	while ( 1 )
	{
		wait randomFloat( 15.0 );
		
		ranX = randomInt( 512 );
		ranY = randomInt( 512 );
		if ( randomInt( 1000 ) > 500 )
			ranX *= -1;
		if ( randomInt( 1000 ) < 500 )
			ranY *= -1;
			
		pos = center + ( ranX, ranY, 512 );
			
		playFx( level._effect[ "cloudflash" ], pos );
	}
}

do_cloudflashes() 
{
	while ( 1 ) 
	{
		wait randomfloat( 15.0 );

		ranX = randomInt( 512 );
		ranY = randomInt( 512 );
		if ( randomInt( 1000 ) > 500 )
			ranX *= -1;
		if ( randomInt( 1000 ) < 500 )
			ranY *= -1;
			
		pos = center + ( ranX, ranY, 2048 );
		
		thread lightningBolt( pos );
	}
}

lightningBolt( v ) 
{
	x = v[ 0 ];
	y = v[ 1 ];
	z = 2048;
	l = v[ 2 ];
	arcs = randomint( 7 ) + 3;
	positive = true;
	
	for ( a = 0; a < arcs; a++ ) 
	{
		arcvariant = randomint( 7 ) + 1;
		avFloat = (float)arcvariant / 10;
		len = randomint( 1024 ) + 1024;
		offset = z - len;
		inc = randomint( 2 ) + 1;
		inc = inc * 10;
		
		if ( positive )
			positive = false;
		else 
		{
			inc = inc * -1;
			positive = true;
		}
		
		for ( z = z; z > offset; z -= 15 ) 
		{
			thread drawlightning( ( x, y, z ) );
			y += inc;
			wait .001;
		}
		
		l = l - len;
	}
	wait .05;
}


drawlightning( v ) 
{
	playfx( level._effect["cloudflash"] , v );
}

findmapdimensions()
{
	entitytypes = getentarray();

	iMaxX = entitytypes[0].origin[0];
	iMinX = iMaxX;
	iMaxY = entitytypes[0].origin[1];
	iMinY = iMaxY;
	iMaxZ = entitytypes[0].origin[2];
	iMinZ = iMaxZ;

	for(i = 1; i < entitytypes.size; i++)
	{
		if (entitytypes[i].origin[0]>iMaxX)
			iMaxX = entitytypes[i].origin[0];

		if (entitytypes[i].origin[1]>iMaxY)
			iMaxY = entitytypes[i].origin[1];

		if (entitytypes[i].origin[2]>iMaxZ)
			iMaxZ = entitytypes[i].origin[2];

		if (entitytypes[i].origin[0]<iMinX)
			iMinX = entitytypes[i].origin[0];

		if (entitytypes[i].origin[1]<iMinY)
			iMinY = entitytypes[i].origin[1];

		if (entitytypes[i].origin[2]<iMinZ)
			iMinZ = entitytypes[i].origin[2];
	}

	iX = (int)(iMaxX + iMinX)/2;
	iY = (int)(iMaxY + iMinY)/2;
	iZ = (int)(iMaxZ + iMinZ)/2;

	iTraceend = iZ;
	iTracelength = 50000;
	iTracestart = iTraceend + iTracelength;
	trace = bulletTrace((iX,iY,iTracestart),(iX,iY,iTraceend), false, undefined);
	if(trace["fraction"] != 1)
	{
		iMaxZ = iTracestart - (iTracelength * trace["fraction"]) - 100;
	} 

	iTraceend = iX;
	iTracelength = 100000;
	iTracestart = iTraceend + iTracelength;
	trace = bulletTrace((iTracestart,iY,iZ),(iTraceend,iY,iZ), false, undefined);
	if(trace["fraction"] != 1)
	{
		iMaxX = iTracestart - (iTracelength * trace["fraction"]) - 100;
	} 
	
	iTraceend = iY;
	iTracelength = 100000;
	iTracestart = iTraceend + iTracelength;
	trace = bulletTrace((iX,iTracestart,iZ),(iX,iTraceend,iZ), false, undefined);
	if(trace["fraction"] != 1)
	{
		iMaxY = iTracestart - (iTracelength * trace["fraction"]) - 100;
	} 

	iTraceend = iX;
	iTracelength = 100000;
	iTracestart = iTraceend - iTracelength;
	trace = bulletTrace((iTracestart,iY,iZ),(iTraceend,iY,iZ), false, undefined);
	if(trace["fraction"] != 1)
	{
		iMinX = iTracestart + (iTracelength * trace["fraction"]) + 100;
	} 

	iTraceend = iY;
	iTracelength = 100000;
	iTracestart = iTraceend - iTracelength;
	trace = bulletTrace((iX,iTracestart,iZ),(iX,iTraceend,iZ), false, undefined);
	if(trace["fraction"] != 1)
	{
		iMinY = iTracestart + (iTracelength * trace["fraction"]) + 100;
	} 

	iTraceend = iZ;
	iTracelength = 50000;
	iTracestart = iTraceend - iTracelength;
	trace = bulletTrace((iX,iY,iTracestart),(iX,iY,iTraceend), false, undefined);
	if(trace["fraction"] != 1)
	{
		iMinZ = iTracestart + (iTracelength * trace["fraction"]) + 100;
	}
	
	level.vMax = (iMaxX, iMaxY, iMaxZ);
	level.vMin = (iMinX, iMinY, iMinZ);
}