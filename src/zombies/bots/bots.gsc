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
    level.botmap = false;

    wpfile = "waypoints/" + level.mapname + ".wp";
    if ( wp_init( wpfile ) )
        level.botmap = true;
}

main() {
    if ( !level.botmap )
        return;

    return;

    players = getEntArray( "player", "classname" );
    while ( players.size == 0 ) {
        players = getEntArray( "player", "classname" );
        wait 0.05;
    }

    wait 2;

    bot = addtestclient();

    wait 0.5;

    if ( isPlayer( bot ) ) {
        bot notify( "menuresponse", "team_britishgerman", "axis" );
        wait 0.5;
        bot notify( "menuresponse", "weapon_americangerman", "kar98k_mp" );
        wait 0.5;

        zom detachall();
    }
}