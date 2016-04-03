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

/*
	Extra stuff in stock maps, models, fx, etc.
*/

main()
{
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_extra.gsc::main()", true );
	precacheModel( "xmodel/vehicle_russian_barge" );
	precacheModel( "xmodel/vehicle_tank_tiger_d" );
	precacheModel( "xmodel/playerbody_russian_conscript" );
	precacheModel( "xmodel/tombstone1" );
	
	models = [];
	fx = [];
	supported = true;
	
	switch ( maps\mp\gametypes\_zombie::toLower( getCvar( "mapname" ) ) )
	{
		case "mp_brecourt":
			models = addModel( models, "xmodel/vehicle_tank_tiger_d", ( -1691, -4034, 112 ), ( 0, 65, 0 ) );
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( -2665, 2139, 66 ), ( 0, -68, 0 ) );
			models = addModel( models, "xmodel/tombstone1", ( -2634, 2066, 52 ), ( 0, -68, 0 ) );
			break;
			
		case "mp_chateau":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( 3081, 601, 131 ), ( 0, -166, 0 ) );
			models = addModel( models, "xmodel/tombstone1", ( 3101, 513, 132 ), ( 0, -168, 0 ) );
			break;
			
		case "mp_carentan":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( 2009, -1423, 21 ), ( 0, 162, 0 ) );
			models = addModel( models, "xmodel/tombstone1", ( 1927, -1489, 9 ), ( 0, 158, 0 ) );
			break;
			
		case "mp_dawnville":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( 2722, -16275, -59 ), ( 0, 172, 0 ) );
			models = addModel( models, "xmodel/tombstone1", ( 2635, -16338, -69 ), ( 0, 172, 0 ) );
			break;
			
		case "mp_depot":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( -2986, 238, -23 ), ( 0, 70, 0 ) );
			models = addModel( models, "xmodel/tombstone1", ( -3035, 256, -23 ), ( 0, 66, 0 ) );
			break;
			
		case "mp_harbor":
			models = addModel( models, "xmodel/vehicle_russian_barge", ( -6675, -6348, -119 ), ( 0, -88, 0 ) );
			models = addModel( models, "xmodel/vehicle_russian_barge", ( -7390, -6365, -119 ), ( 0, -88, 0 ) );
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( -9798, -5353, 64 ), ( 0, -27, 0 ) );
			models = addModel( models, "xmodel/tombstone1", ( -9701, -5366, 64 ), ( 0, -36, 0 ) );
			break;
			
		case "mp_hurtgen":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( 2284, -5561, 111 ), ( 0, 71, 0 ) );
			models = addModel( models, "xmodel/tombstone1", ( 2367, -5590, 124 ), ( 0, 67, 0 ) );
			break;
			
		case "mp_pavlov":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( -9620, 12451, 32 ), ( 0, -157, 0 ) );
			models = addModel( models, "xmodel/tombstone1", ( -9567, 12522, 33 ), ( 0, -157, 0 ) );
			break;
			
		case "mp_powcamp":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( -2228, 3848, 2 ), ( 0, -6, 0 ) );
			models = addModel( models, "xmodel/tombstone1", ( -2237, 3775, 2 ), ( 0, -2, 0 ) );
			break;
			
		case "mp_railyard":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( 807, 762, 304 ), ( 0, -162, 0 ) );
			models = addModel( models, "xmodel/tombstone1", ( 833, 671, 304 ), ( 0, -171, 0 ) );
			break;
			
		case "mp_rocket":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( 12289, 1695, 618 ), ( 0, 99, 0 ) );
			break;
			
		case "mp_ship":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( 4992, 65, 2224 ), ( 0, -180, 0 ) );
			break;
			
		case "mp_neuville":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( -11787, 2121, -71 ), ( 0, -145, 0 ) );
			models = addModel( models, "xmodel/tombstone1", ( -11705, 2128, -68 ), ( 0, -145, 0 ) );
			break;
			
		case "mp_stalingrad":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( 3953, 308, 300 ), ( 0, -90, 0 ) );
			break;
			
		case "quarantine":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( 4392, -809, 0 ), ( 0, 180, 0 ) );
			models = addModel( models, "xmodel/tombstone1", ( 4392, -726, 0 ), ( 0, 180, 0 ) );
			break;
			
		case "mp_vok_final_night":
			models = addModel( models, "xmodel/playerbody_russian_conscript", ( -1195, 7661, 865 ), ( 0, -40, 0 ) );
			models = addModel( models, "xmodel/tombstone1", ( -1088, 7662, 867 ), ( 0, -40, 0 ) );
			break;
			
		default:
			supported = false;
			break;
	}
	
	if ( supported )
	{
		spawnModels( models );
		spawnFx( fx );
	}
}

addModel( array, model, origin, angles )
{
	mod = spawnstruct();
	mod.model = model;
	mod.origin = origin;
	mod.angles = angles;
	
	array[ array.size ] = mod;
	return array;
}

addFx( array, id, origin, waittime )
{
	fx = spawnstruct();
	fx.id = id;
	fx.origin = origin;
	fx.waittime = waittime;
	
	array[ array.size ] = fx;
	return array;
}

spawnModels( array )
{
	if ( !array.size )
		return;
		
	for ( i = 0; i < array.size; i++ )
	{
		model = spawn( "script_model", ( 0, 0, 0 ) );
		model.origin = array[ i ].origin;
		model.angles = array[ i ].angles;
		model setModel( array[ i ].model );
	}
}

spawnFx( array )
{
	if ( !array.size )
		return;
		
	for ( i = 0; i < array.size; i++ )
	{
		id = array[ i ].id;
		pos = array[ i ].origin;
		waittime = array[ i ].waittime;
		
		thread maps\mp\_fx::loopfxthread( id, pos, waittime );
	}
}