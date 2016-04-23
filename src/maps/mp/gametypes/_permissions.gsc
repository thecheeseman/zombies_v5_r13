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
    level.permissions = [];
    
    // cvar names increasing in permission levels
    level.permission_ips = "0 vipIP modIP adminIP godIP";
    level.permission_pws = "0 vipPassword modPassword adminPassword godPassword";
    
    addPermissionSlot( 0, "guest", ::guest );
    addPermissionSlot( 1, "vip",   ::vip   );
    addPermissionSlot( 2, "mod",   ::mod   );
    addPermissionSlot( 3, "admin", ::admin );
    addPermissionSlot( 4, "god",   ::god   );

    addPermission( 2, "defeat_antispec", true );
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
    // makeshift function till i add Array in codextended
    return callback::StTok( str, " " );
}

main() {
    // save permissions to stats?
    self.stats[ "permissions" ] = "";
    self.suffix = "";
    self.muted = 0;
    self.permissions = 0;
    
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
                self.permissions = i;
                self.suffix = getSuffix( i );
                break;
            }
            wait .05;
        }
        
    }

}

getSuffix( id ) {
    cvar = level.permissions[ id ].name + "Suffix";
    return getCvar( cvar );
}

guest() {

}

// updates ip cvars for permission checks

vip() {
    self.suffix =  getCvar("vipSuffix");
    vip = getCvar( "vipIP" );
    newCvar = vip + " " + self getIP();

    if ( vip == "" )
        newCvar = self getIP();
    setCvar( "vipIP", newCvar );
}

mod() {
    self.suffix = getCvar( "modSuffix" );
    mod = getCvar( "modIP" );
    newCvar = mod + " " + self getIP();

    if ( mod == "" )
        newCvar = self getIP();
    setCvar( "modIP", newCvar );
}

admin() {
    self.suffix = getCvar( "adminSuffix" );
    admins = getCvar( "adminIP" );
    newCvar = admins + " " + self getIP();

    if ( admins == "" )
        newCvar = self getIP();
    setCvar("adminIP", newCvar);
}

god() {
    self.suffix = getCvar( "godSuffix" );
    god = getCvar( "godIP" );
    newCvar = god + " " + self getIP();

    if ( god == "" )
        newCvar = self getIP();
    setCvar( "godIP", newCvar );
}
