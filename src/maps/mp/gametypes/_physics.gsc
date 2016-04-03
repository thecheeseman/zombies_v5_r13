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
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_physics.gsc::init()", true );
	level.gravity = getCvar( "g_gravity" );
}

doPhysics()
{
	self endon( "stop_physics" );
	
	while ( 1 )
	{
		thisorg = self.origin;
		
		trace = bullettrace( thisorg + ( 0, 0, 8 ), thisorg + ( 0, 0, -10000 ), false, self );
		if ( trace[ "fraction" ] == 1 )
		{
			dist = distance( thisorg, trace[ "position" ] );
			speed = dist / 384;
			
			self moveto( trace[ "position" ], speed, 0.5, 0.5 );
			self waittill( "movedone" );
		}
		
		wait 0.05;
	}
}