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

    addPermissionSlot( 0, "guest" );
    addPermissionSlot( 1, "vip" );
    addPermissionSlot( 2, "admin" );
    addPermissionSlot( 3, "god" );

    addPermission( 2, "defeat_antispec", true );
}

addPermissionSlot( id, name ) {
    p = spawnstruct();
    p.id = id;
    p.name = name;
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

main() {

}

guest() {

}

vip() {

}

admin() {
    self.isadmin = true;
}

god() {
    self.isadmin = true;
}
