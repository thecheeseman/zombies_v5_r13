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