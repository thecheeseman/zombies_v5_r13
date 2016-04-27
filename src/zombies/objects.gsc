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
    removeNonTDM();
    removeWeapons();

    if ( getCvar( "mapname" ) != "toybox_bloodbath" )
        spawnpointname = "mp_teamdeathmatch_spawn";
    else
        spawnpointname = "mp_deathmatch_spawn";
    spawnpoints = getentarray( spawnpointname, "classname" );

    if ( spawnpoints.size > 0 ) {
        for( i = 0; i < spawnpoints.size; i++ )
            spawnpoints[ i ] placeSpawnpoint();
    } else { 
        maps\mp\_utility::error( "NO " + spawnpointname + " SPAWNPOINTS IN MAP" );
    }
}

removeNonTDM() {
    entities = getEntArray();

    for ( i = 0; i < entities.size; i++ ) {
        ent = entities[ i ];
        if ( isDefined( ent.script_gameobjectname ) ) {
            delete = true;

            if ( ent.script_gameobjectname == "tdm" )
                delete = false;

            if ( delete )
                ent delete();
        }
    }
}

removeWeapons()
{
    deletePlacedEntity( "mpweapon_m1carbine" );
    deletePlacedEntity( "mpweapon_m1garand" );
    deletePlacedEntity( "mpweapon_thompson" );
    deletePlacedEntity( "mpweapon_bar" );
    deletePlacedEntity( "mpweapon_springfield" );
    deletePlacedEntity( "mpweapon_enfield" );
    deletePlacedEntity( "mpweapon_sten" );
    deletePlacedEntity( "mpweapon_bren" );
    deletePlacedEntity( "mpweapon_mosinnagant" );
    deletePlacedEntity( "mpweapon_ppsh" );
    deletePlacedEntity( "mpweapon_mosinnagantsniper" );
    deletePlacedEntity( "mpweapon_kar98k" );
    deletePlacedEntity( "mpweapon_mp40" );
    deletePlacedEntity( "mpweapon_mp44" );
    deletePlacedEntity( "mpweapon_kar98k_scoped" );
    deletePlacedEntity( "mpweapon_fg42" );
    deletePlacedEntity( "mpweapon_panzerfaust" );
    deletePlacedEntity( "mpweapon_stielhandgranate" );
    deletePlacedEntity( "mpweapon_fraggrenade" );
    deletePlacedEntity( "mpweapon_mk1britishfrag" );
    deletePlacedEntity( "mpweapon_russiangrenade" );
    deletePlacedEntity( "mpweapon_colt" );
    deletePlacedEntity( "mpweapon_luger" );
    
    deletePlacedEntity( "item_ammo_stielhandgranate_closed" );
    deletePlacedEntity( "item_ammo_stielhandgranate_open" );
    deletePlacedEntity( "item_health" );
    deletePlacedEntity( "item_health_large" );
    deletePlacedEntity( "item_health_small" );
    
    deletePlacedEntity( "misc_mg42" );
    deletePlacedEntity( "misc_turret");
}

deletePlacedEntity( sEntityType )
{
    eEntities = getentarray( sEntityType, "classname" );
    for ( i = 0; i < eEntities.size; i++ )
        eEntities[ i ] delete();
}
