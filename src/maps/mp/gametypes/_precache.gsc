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
    level.precachedItems = [];

    level.precache = ::precache_runner;

    [[ level.precache ]]( "black", "shader" );
    [[ level.precache ]]( "white", "shader" );
}

dump_precache() {
    stringcount = 0;
    for ( i = 0; i < level.precachedItems.size; i++ ) {
        p = level.precachedItems[ i ];

        if ( p.type == "fx" ) {
            [[ level.logwrite ]]( "precache[ " + i + " ]\t:  level._effect[ \"" + p.name + "\" ] = loadFx( \"" + p.item + "\" )" );
        } else if ( p.type == "localized-string" ) {
            if ( isDefined( p.name ) )
                [[ level.logwrite ]]( "precache[ " + i + " ]\t:  precachestring( &\"" + p.name + "\" )" );
            else
                [[ level.logwrite ]]( "precache[ " + i + " ]\t:  precachestring( " + ( stringcount ) + " )" );
            stringcount++;
        } else {
            [[ level.logwrite ]]( "precache[ " + i + " ]\t:  precache" + p.type + "( \"" + p.item + "\" )" );
        }
    }
}   

precachedItem( item, type ) {
    for ( i = 0; i < level.precachedItems.size; i++ ) {
        p = level.precachedItems[ i ];

        // special checks for localized strings....
        if ( type == "localized-string" || p.type == "localized-string" ) {
            if ( p.type == type && p.item == item )
                return true;
        } else {
            if ( p.type == type && p.item == item )
                return true;
        }
    }

    return false;
}

precache_runner( item, type, name ) {   
    if ( !isDefined( item ) )
        return;

    if ( !isDefined( type ) ) {
        type = typeof( item );

        // try to guess type
        if ( type == "string" ) {
            // xmodel
            if ( [[ level.utility ]]( "startsWith", item, "xmodel/" ) ) {
                type = "model";
            } // shaderish.. could be headicon or statusicon but we'll just assume it's a shader
            else if ( [[ level.utility ]]( "startsWith", item, "gfx/" ) ) {
                type = "shader";
            } // weapon
            else if ( [[ level.utility ]]( "endsWith", item, "_mp" ) || [[ level.utility ]]( "startsWith", item, "item_" ) ) {
                type = "item";
            } // fx
            else if ( [[ level.utility ]]( "startsWith", item, "fx/" ) || [[ level.utility ]]( "endsWith", item, ".efx" ) ) {
                type = "fx";
            }
        }
    }

    // double precached?
    if ( precachedItem( item, type ) ) {
        if ( type != "localized-string" )
            [[ level.logwrite ]]( "maps\\mp\\gametypes\\_precache.gsc::precache_runner() -- tried to precache " + type + " \"" + item + "\" twice" );

        return;
    }

    switch ( type ) {
        case "model":               precacheModel( item ); break;
        case "shellshock":          precacheShellshock( item ); break;
        case "string":
            name = item;
            item = convert_string( name );
            type = "localized-string";
        case "localized-string":    precacheString( item ); break;
        case "shader":              precacheShader( item ); break;
        case "statusicon":          precacheStatusIcon( item ); break;
        case "headicon":            precacheHeadIcon( item ); break;
        case "item":                precacheItem( item ); break;
        case "menu":                precacheMenu( item ); break;
        case "fx":
            if ( !isDefined( name ) ) {
                tmp = item;
                lastloc = 0;
                for ( i = 0; i < tmp.size; i++ ) {
                    if ( tmp[ i ] == "/" )
                        lastloc = i;
                }

                end = tmp.size;
                if ( [[ level.utility ]]( "endsWith", tmp, ".efx" ) )
                    end = tmp.size - 4;

                name = "";
                for ( i = lastloc + 1; i < end; i++ ) 
                    name += tmp[ i ];

                level._effect[ name ] = loadfx( item );
            }
            else {
                level._effect[ name ] = loadfx( item );
            }

            break;
    }

    struct = spawnstruct();
    struct.item = item;
    struct.type = type;
    struct.name = name;

    level.precachedItems[ level.precachedItems.size ] = struct;
}
