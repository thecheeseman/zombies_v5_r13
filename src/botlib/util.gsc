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
