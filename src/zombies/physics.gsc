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
	[[ level.logwrite ]]( "zombies\\physics.gsc::init()", true );
	level.gravity = getCvarInt( "g_gravity" );
}

doPhysics( owner )
{
	self endon( "stop_physics" );
    level endon( "intermission" );
	
	while ( true ) {
		thisorg = self.origin;
		
		trace = bullettrace( thisorg + ( 0, 0, 1 ), thisorg + ( 0, 0, -10000 ), true, self );
		if ( trace[ "fraction" ] > 0.0001 ) {
            owner iprintln( "Dropping barricade to ground..." );
            
			dist = distance( thisorg, trace[ "position" ] );
			speed = sqrt( ( dist * 2 ) / getCvarInt( "g_gravity" ) );

            accel = ( speed / 1.3 ) - 0.05;
            if ( accel < 0 )
                accel = 0;

            decel = 0.05;
            if ( speed < frame() ) {
                decel = 0;
                speed = frame();
            }
			
			self moveto( trace[ "position" ], speed, accel, decel );
			self waittill( "movedone" );
		}
		
		wait 0.5;
	}
}