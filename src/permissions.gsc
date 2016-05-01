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

/* Modified for CoCo- original from cheese */

init() {

    level.permissions = [];
    
    level.permission_ips = "0 vipIP modIP adminIP godIP";
    level.permission_pws = "0 vipPassword modPassword adminPassword godPassword";
    
    addPermissionSlot( 0, "guest"   , ::guest        );
    addPermissionSlot( 1, "vip"     , ::groupAssign  );
    addPermissionSlot( 2, "mod"     , ::groupAssign  );
    addPermissionSlot( 3, "admin"   , ::groupAssign  );
    addPermissionSlot( 4, "god"     , ::groupAssign  );
    
    // load custom gametype permissions flags if no CoDaM //
    if ( getCvar( "coco_codam" ) == "" ) {
        custom\permissions::init();
    }
    
}

addPermissionSlot( id, name, call ) {
    p = spawnstruct();
    p.id = id;
    p.name = name;
    p.call = call;
    p.permissions = [];

    level.permissions[ id ] = p;
}

getPermissionSlot( id ) {
    if ( !isDefined( level.permissions[ id ] ) )
        return undefined;

    return level.permissions[ id ];
}

addPermission( id, permission, value ) {
    slot = getPermissionSlot( id );
    if ( !isDefined( slot ) )
        return;

    i = slot.permissions.size;
    p = spawnstruct();
    p.name = permission;
    p.value = value;

    slot.permissions[ i ] = p;
    level.permissions[ slot.id ] = slot;
}

getPermission( slot, permission ) {
    if ( !isDefined( slot ) )
        return undefined;

    for ( i = 0; i < slot.permissions.size; i++ ) {
        p = slot.permissions[ i ];

        if ( p.name == permission )
            return p;
    }

    return undefined;
}

hasPermission( permission ) {
    slot = getPermissionSlot( self.stats[ "permissions" ] );
    if ( !isDefined( slot ) )
        return false;

    if ( !hasPermissionAvailable( slot, permission ) )
        return false;

    p = getPermission( slot, permission );
    if ( p.value )
        return true;

    return false;
}

hasPermissionAvailable( slot, permission ) {
    if ( !isDefined( slot ) )
        return false;

    if ( isDefined( getPermission( slot, permission ) ) )
        return true;

    return false;
}

Array ( str ) {
    return utilities::explode( str, " " );
}

main() {
    if ( !isDefined( self.pers[ "suffix" ] ) )
        self.pers[ "suffix" ] = "";
    if ( !isDefined( self.pers[ "muted" ] ) )
        self.pers["muted"] = 0;
    if ( !isDefined( self.pers[ "permissions" ] ) )
        self.pers[ "permissions" ] = 0;

    ips = Array( level.permission_ips );

    for ( i = 1; i < ips.size; i++ ) {
        cvar = getCvar( ips[ i ] );
        newCvar = "";
        if ( cvar == "" )
            continue;

        // check for multiple admins
        if ( callback::contains( cvar, " " ) )
            admins = callback::StTok( cvar, " " );
        else
            admins[ 0 ] = cvar;

        for (k = 0; k < admins.size; k++ ) {
            if ( self getIP() == admins[ k ] ) {
                self.pers[ "permissions" ] = i;
                self.pers[ "suffix" ] = getSuffix( i );
                break;
            }
            wait .05;
        }
        
    }

}

getSuffix( id ) {
    suffixCvar = getCvar( "customSuffix" );
    
    if ( suffixCvar != "" ) {
        if ( utilities::contains( suffixCvar, " " ) )
            customs = utilities::explode( suffixCvar, " " );
        else
            customs[ 0 ] = suffixCvar;
            
        for (i = 0; i < customs.size; i++ ) {
            key = utilities::explode( customs[ i ], ";" );
            if ( self getIP() == key[ 0 ] ) {
                suffix = key[ 1 ];
                break;
            }
            wait .05;
        }
        
        if ( isDefined( suffix ) )
            return suffix;
    }
    // default suffix
    cvar = level.permissions[ id ].name + "Suffix";
    return getCvar( cvar );
}

guest( group ) {

}

groupAssign( group ) {
    
    self.pers[ "suffix" ] = getCvar( group + "Suffix" );
    ips = getCvar( group + "Suffix" );
    updateCvar = ips + " " + self getIP();
    
    if ( ips == "" )
        updateCvar = self getIP();
        
    setCvar( (group + "IP"), updateCvar );
}