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
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_hud.gsc::init()", true );

	precacheString( &"^2Game Cam" );
	precacheString( &"^1Zombi^7cam" );
	precacheString( &"^1Kills^7: " );
	precacheString( &"^1Bashes^7: " );
	precacheString( &"^1Deaths^7: " );
	precacheString( &"^1Damage^7: " );
	precacheString( &"^1Headshots^7: " );
	precacheString( &"^2Zombie Class^7: " );
	precacheString( &"^1Time Alive^7: " );
	precacheString( &"^1Zombie Rank^7: " );
	precacheString( &"^3Total Kills^7: " );
	//precacheString( &"^1Assists^7: " );
	
	precacheString( &"^2XP^7: " );
	precacheString( &"^3Points^7: " );
	precacheString( &"^1Rank^7: " );
	precacheString( &"^4Proximity Charges^7: " );
	precacheString( &"^5Health Packs^7: " );
	
	precacheString( &"Jumper" );
	precacheString( &"Fast" );
	precacheString( &"Poison" );
	precacheString( &"Fire" );
	
	precacheString( &"Cooking Grenade" );
	precacheString( &"^3XP^7: " );
	precacheString( &"Waiting for ^22 ^7players..." );
	precacheString( &"^1Headshots^7: " );
	precacheString( &"^2Saving ranks..." );
	precacheString( &"Progress: " );
	precacheString( &"^3Spectating is not allowed." );
	precacheString( &"^6Select your last hunter weapon." );
	precacheString( &"Yes" );
	precacheString( &"No" );
	precacheString( &"Fire Bomb ^1Available^7: " );
	precacheString( &"Poison Bomb ^2Available^7: " );
	precacheString( &"saving hunter stats..." );
	precacheString( &"saving zombie stats..." );
	precacheString( &"saving point stats..." );
	precacheString( &"Mega Jump Power" );
	precacheString( &"Delay Proxy Time: ^2Always On" );
	
	precacheShader( "gfx/hud/hud@ammocounterback.tga" );
	precacheShader( "gfx/icons/hud@steilhandgrenate.tga" );
	precacheShader( "gfx/hud/hud@health_cross.tga" );
	precacheString( &"|" );
	precacheString( &"^3+" );
	
	precacheString( &"^2Your Stats^7: " );
	precacheString( &"This Round: " );
	precacheString( &"All Time: " );
	precacheString( &"Gained XP: " );
	precacheString( &"Gained Kills: " );
	precacheString( &"Gained Points: " );
	precacheString( &"Shots Fired: " );
	precacheString( &"Shots Hit: " );
	precacheString( &"Accuracy: " );
	precacheString( &"All Time: " );
	precacheString( &"XP: " );
	precacheString( &"Kills: " );
	precacheString( &"Points: " );
	precacheString( &"Body Armor: " );
	precacheString( &"Explosion Armor: " );
	
	precacheShader( "gfx/effects/dark_smoke.tga" );
}

cleanUpHud()
{
	if ( isDefined( self.hud ) ) {
		if ( isDefined( self.hud[ "health" ] ) )		self.hud[ "health" ] destroy();
		if ( isDefined( self.hud[ "rank" ] ) )			self.hud[ "rank" ] destroy();
		if ( isDefined( self.hud[ "xp" ] ) )			self.hud[ "xp" ] destroy();
		if ( isDefined( self.hud[ "kills" ] ) )			self.hud[ "kills" ] destroy();
		if ( isDefined( self.hud[ "bashes" ] ) )		self.hud[ "bashes" ] destroy();
		if ( isDefined( self.hud[ "deaths" ] ) )		self.hud[ "deaths" ] destroy();
		if ( isDefined( self.hud[ "damage" ] ) )		self.hud[ "damage" ] destroy();
		if ( isDefined( self.hud[ "headshots" ] ) )		self.hud[ "headshots" ] destroy();
		if ( isDefined( self.hud[ "stickies" ] ) ) 		self.hud[ "stickies" ] destroy();
		if ( isDefined( self.hud[ "healthpacks" ] ) ) 	self.hud[ "healthpacks" ] destroy();
		if ( isDefined( self.hud[ "timealive" ] ) )		self.hud[ "timealive" ] destroy();
		if ( isDefined( self.hud[ "zombietype" ] ) ) 	self.hud[ "zombietype" ] destroy();
		if ( isDefined( self.hud[ "zombierank" ] ) )	self.hud[ "zombierank" ] destroy();
		if ( isDefined( self.hud[ "zombiekills" ] ) )	self.hud[ "zombiekills" ] destroy();
		if ( isDefined( self.hud[ "assists" ] ) )		self.hud[ "assists" ] destroy();
		if ( isDefined( self.hud[ "firebomb" ] ) )		self.hud[ "firebomb" ] destroy();
		if ( isDefined( self.hud[ "poisonbomb" ] ) )	self.hud[ "poisonbomb" ] destroy();
		if ( isDefined( self.hud[ "points" ] ) )		self.hud[ "points" ] destroy();
		if ( isDefined( self.hud[ "missmines" ] ) )		self.hud[ "missmines" ] destroy();
	
		if ( isDefined( self.hud[ "datahud_back" ] ) )	self.hud[ "datahud_back" ] destroy();
		if ( isDefined( self.hud[ "datahud_sep" ] ) )	self.hud[ "datahud_sep" ] destroy();
		if ( isDefined( self.hud[ "datahud_proxy" ] ) )	self.hud[ "datahud_proxy" ] destroy();
		if ( isDefined( self.hud[ "datahud_healthpacks" ] ) )	self.hud[ "datahud_healthpacks" ] destroy();
	}
	
	if ( isDefined( self.zombiehud )  )				self.zombiehud destroy();
	if ( isDefined( self.poisonhud ) )				self.poisonhud destroy();
	if ( isDefined( self.darkness ) )				self.darkness destroy();
	
	if ( isDefined( self.spechud ) )				self.spechud destroy();
	if ( isDefined( self.specnotice ) )				self.specnotice destroy();
	
	if ( isDefined( self.progressbar ) )			self.progressbar destroy();
	if ( isDefined( self.progressbackground ) )		self.progressbackground destroy();
	if ( isDefined( self.ammonotice ) )				self.ammonotice destroy();
	
	if ( isDefined( self.cookbar ) )				self.cookbar destroy();
	if ( isDefined( self.cookbarbackground ) )		self.cookbarbackground destroy();
	if ( isDefined( self.cookbartext ) )			self.cookbartext destroy();

	if ( isDefined( self.armorhud ) )				self.armorhud destroy();
	if ( isDefined( self.hitblip ) )				self.hitblip destroy();
	
	if ( isDefined( self.lasthunterhud ) )			self.lasthunterhud destroy();
	if ( isDefined( self.notice ) )					self.notice destroy();
	if ( isDefined( self.distancehud ) )			self.distancehud destroy();
	
	if ( isDefined( self.bloodyscreen ) ) {
		for ( i = 0; i < level.cvars[ "BLOOD_SPLATTER" ]; i++ ) {
			self.bloodyscreen[ i ] destroy();
		}

		self.bloodyscreen = undefined;
	}
	
	if ( isDefined( self.flashhud ) )				self.flashhud destroy();
	
	if ( isDefined( self.megajump_hud_back ) )		self.megajump_hud_back destroy();
	if ( isDefined( self.megajump_hud_notice ) )	self.megajump_hud_notice destroy();
	if ( isDefined( self.megajump_hud_front ) )		self.megajump_hud_front destroy();
	
	if ( isDefined( self.bodyarmor_hud_back ) )			self.bodyarmor_hud_back destroy();
	if ( isDefined( self.bodyarmor_hud_front ) )		self.bodyarmor_hud_front destroy();
	if ( isDefined( self.exploarmor_hud_back ) )	self.exploarmor_hud_back destroy();
	if ( isDefined( self.exploarmor_hud_front ) )	self.exploarmor_hud_front destroy();
	if ( isDefined( self.bodyarmor_text ) )			self.bodyarmor_text destroy();
	if ( isDefined( self.exploarmor_text ) )		self.exploarmor_text destroy();
	
	if ( isDefined( self.immunity_hud_back ) )		self.immunity_hud_back destroy();
	if ( isDefined( self.immunity_hud_front ) )		self.immunity_hud_front destroy();
	
	if ( isDefined( self.nightvis ) )				self.nightvis destroy();

	if ( isDefined( self.gc_topbar ) )		self.gc_topbar destroy();
	if ( isDefined( self.gc_bottombar ) ) 	self.gc_bottombar destroy();
	if ( isDefined( self.gc_title ) )		self.gc_title destroy();
	if ( isDefined( self.gc_timer ) )		self.gc_timer destroy();
	
	self thread maps\mp\gametypes\_zombie::FOVScale( 80 );
}

runHud()
{
	self addTextHud( "health", 567, 465, "center", "middle", 1, 0.8, 10, &"" );
/*
	self addTextHud( "kills", 630, 25, "right", "middle", 1, 0.8, 10, &"^1Kills^7: " );
	self addTextHud( "bashes", 630, 40, "right", "middle", 1, 0.8, 10, &"^1Bashes^7: " );
	self addTextHud( "deaths", 630, 55, "right", "middle", 1, 0.8, 10, &"^1Deaths^7: " );
	self addTextHud( "damage", 630, 70, "right", "middle", 1, 0.8, 10, &"^1Damage^7: " );
	self addTextHud( "headshots", 630, 85, "right", "middle", 1, 0.8, 10, &"^1Headshots^7: " );
	self addTextHud( "assists", 630, 100, "right", "middle", 1, 0.8, 10, &"^1Assists^7: " );
*/
	
	if ( self.pers[ "team" ] == "axis" )
	{
		self addTextHud( "xp", 630, 340, "right", "middle", 1, 1, 10, &"^2XP^7: " );
		self addTextHud( "points", 630, 360, "right", "middle", 1, 1, 10, &"^3Points^7: " );
		self addTextHud( "rank", 630, 380, "right", "middle", 1, 1, 10, &"^1Rank^7: " );
		//self addTextHud( "stickies", 630, 390, "right", "middle", 1, 1, 10, &"^4Proximity Charges^7: " );
		//self addTextHud( "healthpacks", 630, 410, "right", "middle", 1, 1, 10, &"^5Health Packs^7: " );
		
		self.hud[ "datahud_back" ] = newClientHudElem( self );
		self.hud[ "datahud_back" ].x = 638;
		self.hud[ "datahud_back" ].y = 410;
		self.hud[ "datahud_back" ].alignx = "right";
		self.hud[ "datahud_back" ].aligny = "middle";
		self.hud[ "datahud_back" ].alpha = 1;
		self.hud[ "datahud_back" ] setShader( "gfx/hud/hud@ammocounterback.tga", 81, 40 );
		self.hud[ "datahud_back" ].sort = 10;
		
		self.hud[ "datahud_sep" ] = newClientHudElem( self );
		self.hud[ "datahud_sep" ].x = 597.7;
		self.hud[ "datahud_sep" ].y = 408;
		self.hud[ "datahud_sep" ].alignx = "center";
		self.hud[ "datahud_sep" ].aligny = "middle";
		self.hud[ "datahud_sep" ].alpha = 1;
		self.hud[ "datahud_sep" ] setText( &"|" );
		self.hud[ "datahud_sep" ].sort = 10;
		
		self.hud[ "datahud_proxy" ] = newClientHudElem( self );
		self.hud[ "datahud_proxy" ].x = 576;
		self.hud[ "datahud_proxy" ].y = 410;
		self.hud[ "datahud_proxy" ].alignx = "right";
		self.hud[ "datahud_proxy" ].aligny = "middle";
		self.hud[ "datahud_proxy" ].alpha = 1;
		self.hud[ "datahud_proxy" ] setShader( "gfx/icons/hud@steilhandgrenate.tga", 12, 12 );
		self.hud[ "datahud_proxy" ].sort = 10;
		
		self.hud[ "stickies" ] = newClientHudElem( self );
		self.hud[ "stickies" ].x = 588;
		self.hud[ "stickies" ].y = 409;
		self.hud[ "stickies" ].alignx = "right";
		self.hud[ "stickies" ].aligny = "middle";
		self.hud[ "stickies" ].alpha = 1;
		self.hud[ "stickies" ].fontscale = 0.9;
		self.hud[ "stickies" ].sort = 10;
		
		self.hud[ "datahud_healthpacks" ] = newClientHudElem( self );
		self.hud[ "datahud_healthpacks" ].x = 628;
		self.hud[ "datahud_healthpacks" ].y = 410;
		self.hud[ "datahud_healthpacks" ].alignx = "right";
		self.hud[ "datahud_healthpacks" ].aligny = "middle";
		self.hud[ "datahud_healthpacks" ].alpha = 1;
		self.hud[ "datahud_healthpacks" ] setShader( "gfx/hud/hud@health_cross.tga", 8, 8 );
		self.hud[ "datahud_healthpacks" ].sort = 10;
		
		self.hud[ "healthpacks" ] = newClientHudElem( self );
		self.hud[ "healthpacks" ].x = 605;
		self.hud[ "healthpacks" ].y = 409;
		self.hud[ "healthpacks" ].alignx = "left";
		self.hud[ "healthpacks" ].aligny = "middle";
		self.hud[ "healthpacks" ].alpha = 1;
		self.hud[ "healthpacks" ].fontscale = 0.9;
		self.hud[ "healthpacks" ].sort = 10;
/*		
		self.xpshow = newClientHudElem( self );
		self.xpshow.x = 320;
		self.xpshow.y = 220;
		self.xpshow.alignx = "center";
		self.xpshow.aligny = "middle";
		self.xpshow.alpha = 0;
		self.xpshow.fontscale = 1;
		self.xpshow.label = &"^3+";
		self.xpshow.sort = 10;
*/	
//		self addTextHud( "timealive" , 630, 100, "right", "middle", 1, 0.8, 10, &"^1Time Alive^7: " );
		
		self.bodyarmor_hud_back = newClientHudElem( self );
		self.bodyarmor_hud_back.x = 320;
		self.bodyarmor_hud_back.y = 460;
		self.bodyarmor_hud_back.alignx = "center";
		self.bodyarmor_hud_back.aligny = "middle";
		self.bodyarmor_hud_back.alpha = 0;
		self.bodyarmor_hud_back setShader( "gfx/hud/hud@health_back.dds", 286, 6 );
		self.bodyarmor_hud_back.sort = 10;
		
		self.bodyarmor_hud_front = newClientHudElem( self );
		self.bodyarmor_hud_front.x = 320;
		self.bodyarmor_hud_front.y = 460;
		self.bodyarmor_hud_front.alignx = "center";
		self.bodyarmor_hud_front.aligny = "middle";
		self.bodyarmor_hud_front.color = ( 0, 0, 1 );
		self.bodyarmor_hud_front.alpha = 0;
		self.bodyarmor_hud_front setShader( "gfx/hud/hud@health_bar.dds", 282, 4 );
		self.bodyarmor_hud_front.sort = 20;
		
		self.bodyarmor_text = newClientHudElem( self );
		self.bodyarmor_text.x = 177;
		self.bodyarmor_text.y = 470;
		self.bodyarmor_text.alignx = "left";
		self.bodyarmor_text.aligny = "middle";
		self.bodyarmor_text.alpha = 0;
		self.bodyarmor_text.label = &"Body Armor: ";
		self.bodyarmor_text.fontscale = 0.9;
		
		self.exploarmor_hud_back = newClientHudElem( self );
		self.exploarmor_hud_back.x = 320;
		self.exploarmor_hud_back.y = 450;
		self.exploarmor_hud_back.alignx = "center";
		self.exploarmor_hud_back.aligny = "middle";
		self.exploarmor_hud_back.alpha = 0;
		self.exploarmor_hud_back setShader( "gfx/hud/hud@health_back.dds", 256, 6 );
		self.exploarmor_hud_back.sort = 10;
		
		self.exploarmor_hud_front = newClientHudElem( self );
		self.exploarmor_hud_front.x = 320;
		self.exploarmor_hud_front.y = 450;
		self.exploarmor_hud_front.alignx = "center";
		self.exploarmor_hud_front.aligny = "middle";
		self.exploarmor_hud_front.color = ( 1, 0.3, 0 );
		self.exploarmor_hud_front.alpha = 0;
		self.exploarmor_hud_front setShader( "gfx/hud/hud@health_bar.dds", 252, 4 );
		self.exploarmor_hud_front.sort = 20;
		
		self.exploarmor_text = newClientHudElem( self );
		self.exploarmor_text.x = 464;
		self.exploarmor_text.y = 470;
		self.exploarmor_text.alignx = "right";
		self.exploarmor_text.aligny = "middle";
		self.exploarmor_text.alpha = 0;
		self.exploarmor_text.label = &"Explosion Armor: ";
		self.exploarmor_text.fontscale = 0.9;
		
		self.immunity_hud_back = newClientHudElem( self );
		self.immunity_hud_back.x = 501;
		self.immunity_hud_back.y = 454;
		self.immunity_hud_back.alignx = "left";
		self.immunity_hud_back.aligny = "top";
		self.immunity_hud_back.alpha = 2;
		self.immunity_hud_back setShader( "gfx/hud/hud@health_back.dds", 130, 5 );
		self.immunity_hud_back.sort = 10;
		
		self.immunity_hud_front = newClientHudElem( self );
		self.immunity_hud_front.x = 502;
		self.immunity_hud_front.y = 455;
		self.immunity_hud_front.alignx = "left";
		self.immunity_hud_front.aligny = "top";
		self.immunity_hud_front.color = ( 1, 1, 0 );
		self.immunity_hud_front.alpha = 2;
		self.immunity_hud_front setShader( "gfx/hud/hud@health_bar.dds", 129, 3 );
		self.immunity_hud_front.sort = 20;

		self.darkness = newClientHudElem( self );
		self.darkness.x = 0;
		self.darkness.y = 0;
		self.darkness setShader( "black", 640, 480 );
		self.darkness.alpha = 0;
		self.darkness.sort = 9000;
		
		self thread darkness();
	}
	
	if ( self.pers[ "team" ] == "allies" )
	{
		if ( self.pers[ "weapon" ] == "bren_mp" )
		{
			self.zombiehud = newClientHudElem( self );
			self.zombiehud.x = 0;
			self.zombiehud.y = 0;
			self.zombiehud setShader( "white", 640, 480 );
			self.zombiehud.color = ( 1, 1, 0 );
			self.zombiehud.alpha = 0.1;
			self.zombiehud.archive = true;
		}
		else
		{
			self.zombiehud = newClientHudElem( self );
			self.zombiehud.x = 0;
			self.zombiehud.y = 0;
			self.zombiehud setShader( "white", 640, 480 );
			self.zombiehud.color = ( 1, 0, 0 );
			self.zombiehud.alpha = 0.1;
			self.zombiehud.archive = true;
		}
		
		if ( self.pers[ "weapon" ] == "sten_mp" )
			self maps\mp\gametypes\_zombie::FOVScale( 110 );
			
		self addTextHud( "zombierank", 630, 370, "right", "middle", 1, 1, 10, &"^1Zombie Rank^7: " );
		self addTextHud( "zombietype", 630, 390, "right", "middle", 1, 1, 10, &"^2Zombie Class^7: " );
		self addTextHud( "zombiekills", 630, 410, "right", "middle", 1, 1, 10, &"^3Total Kills^7: " );
		
		if ( self.pers[ "weapon" ] == "springfield_mp" )
			self addTextHud( "firebomb", 630, 350, "right", "middle", 1, 1, 10, &"Fire Bomb ^1Available^7: " );
		else if ( self.pers[ "weapon" ] == "bren_mp" )
			self addTextHud( "poisonbomb", 630, 350, "right", "middle", 1, 1, 10, &"Poison Bomb ^2Available^7: " );
		else if ( self.pers[ "weapon" ] == "sten_mp" )
			self addTextHud( "missmines", 630, 350, "right", "middle", 1, 1, 10, &"Delay Proxy Time: ^2Always On" );
	}
	
	self thread doHud();
}

addTextHud( name, x, y, alignX, alignY, alpha, fontScale, sort, label )
{
	self.hud[ name ] = newClientHudElem( self );
	self.hud[ name ].x = x;
	self.hud[ name ].y = y;
	self.hud[ name ].alignX = alignX;
	self.hud[ name ].alignY = alignY;
	self.hud[ name ].alpha = alpha;
	self.hud[ name ].fontScale = fontScale;
	self.hud[ name ].sort = sort;
	self.hud[ name ].label = label;
}

doHud()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "spawn_spectator" );
	
	if ( self.pers[ "team" ] == "axis" )
	{
		rank = maps\mp\gametypes\_ranks::getRankByID( "hunter", self.rank );
		self.hud[ "rank" ] setText( rank.rankString );
//		self.hud[ "timealive" ] setTimerUp( 0 );
	}
	
	if ( self.pers[ "team" ] == "allies" )
	{
		rank = undefined;
		switch ( self.pers[ "weapon" ] )
		{
			case "enfield_mp": rank = &"Jumper"; break;
			case "sten_mp": rank = &"Fast"; break;
			case "bren_mp": rank = &"Poison"; break;
			case "springfield_mp": rank = &"Fire"; break;
		}
		
		lolrank = maps\mp\gametypes\_ranks::getRankByID( "zombie", self.zomrank );
		self.hud[ "zombietype" ] setText( rank );
		self.hud[ "zombierank" ] setText( lolrank.rankString );
	}
		
	while ( isAlive( self ) )
	{
		self.hud[ "health" ] setValue( self.health );
		
		if ( self.pers[ "team" ] == "axis" )
		{
			self.hud[ "xp" ] setValue( self.xp );
			self.hud[ "stickies" ] setValue( self.stickynades );
			self.hud[ "healthpacks" ] setValue( self.healthpacks );
			self.hud[ "points" ] setValue( self.points );
			
			if ( self.bodyarmor > 0 )
			{
				if ( self.bodyarmor_hud_back.alpha == 0 )
				{
					self.bodyarmor_hud_back.alpha = 1;
					self.bodyarmor_hud_front.alpha = 1;
					self.bodyarmor_text.alpha = 1;
				}
				
				if ( self.bodyarmor > 1500 )
					self.bodyarmor = 1500;
					
				val = self.bodyarmor;
				if ( val > 282 )
					val = 282;
					
				self.bodyarmor_hud_front scaleOverTime( 0.5, 282, 4 );
				self.bodyarmor_hud_front setShader( "white", val, 4 );
				self.bodyarmor_text setValue( self.bodyarmor );
			}
			else if ( self.bodyarmor == 0 && self.bodyarmor_hud_back.alpha == 1 )
			{
				self.bodyarmor_hud_back.alpha = 0;
				self.bodyarmor_hud_front.alpha = 0;
				self.bodyarmor_text.alpha = 0;
			}
			
			if ( self.exploarmor > 0 )
			{
				if ( self.exploarmor_hud_back.alpha == 0 )
				{
					self.exploarmor_hud_back.alpha = 1;
					self.exploarmor_hud_front.alpha = 1;
					self.exploarmor_text.alpha = 1;
				}
				
				if ( self.exploarmor > 1500 )
					self.exploarmor = 1500;
				
				val = self.exploarmor;
				if ( val > 252 )
					val = 252;
					
				self.exploarmor_hud_front scaleOverTime( 0.5, 252, 4 );
				self.exploarmor_hud_front setShader( "white", val, 4 );
				self.exploarmor_text setValue( self.exploarmor );
			}
			else if ( self.exploarmor == 0 && self.exploarmor_hud_back.alpha == 1 )
			{
				self.exploarmor_hud_back.alpha = 0;
				self.exploarmor_hud_front.alpha = 0;
				self.exploarmor_text.alpha = 0;
			}
			
			imm = 0;
			if ( self.immunity == 1 )
				imm = 25;
			else if ( self.immunity == 2 )
				imm = 50;
			else if ( self.immunity == 3 )
				imm = 75;
			else if ( self.immunity == 4 )
				imm = 100;
			else if ( self.immunity == 5 )
				imm = 128;
				
			self.immunity_hud_front setShader( "white", imm, 4 );
		}
		else if ( self.pers[ "team" ] == "allies" )
		{
			self.hud[ "zombiekills" ] setValue( self.zomxp );
			
			if ( !isAlive( self ) ) {
				break;
			}
			
			if ( self.pers[ "weapon" ] == "springfield_mp" )
			{
				if ( self.firebombready )
					self.hud[ "firebomb" ] setText( &"Yes" );
				else
					self.hud[ "firebomb" ] setText( &"No" );
			}
			else if ( self.pers[ "weapon" ] == "bren_mp" )
			{
				if ( self.poisonbombready )
					self.hud[ "poisonbomb" ] setText( &"Yes" );
				else
					self.hud[ "poisonbomb" ] setText( &"No" );
			}
		}
/*			
		self.hud[ "kills" ] setValue( self.stats[ "kills" ] );
		self.hud[ "bashes" ] setValue( self.stats[ "bashes" ] );
		self.hud[ "deaths" ] setValue( self.stats[ "deaths" ] );
		self.hud[ "damage" ] setValue( (int)self.stats[ "damage" ] );
		self.hud[ "headshots" ] setValue( self.stats[ "headshots" ] );
		self.hud[ "assists" ] setValue( self.stats[ "assists" ] );
*/		
		wait 0.1;
	}
}

darkness()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "spawn_spectator" );
	
	while ( !level.gamestarted && isAlive( self ) )
		wait 1;
	
	i = 0.00;
	stop = false;
	while ( isAlive( self ) && self.pers[ "team" ] == "axis" && !level.lasthunter && !self.nightvision && !stop && i < 0.60 )
	{
		i += 0.01;
		self.darkness.alpha = i;
		
		for ( j = 0; j < 15; j++ ) {			
			wait 1;
		}
	}
}

giveXp( xp )
{
	if ( !isDefined( self.showingxp ) )
	{
		self.showingxp = true;
		
		self.xpshow fadeOverTime( 1 );
		self.xpshow.alpha = 1;
	}
	
	self.xpshow setValue( xp );
	
	wait 2;
	
	self.xpshow fadeOverTime( 1 );
	self.xpshow.alpha = 0;
	
	wait 1;
	
	self.showingxp = undefined;
}

endgamehud()
{
	offset = 250;
	
	level.stat_hud_bgnd = newHudElem();
	level.stat_hud_bgnd.archived = false;
	level.stat_hud_bgnd.alpha = .7;
	level.stat_hud_bgnd.x = 205;
	level.stat_hud_bgnd.y = offset + 17;
	level.stat_hud_bgnd.sort = 9000;
	level.stat_hud_bgnd.color = (0,0,0);
	level.stat_hud_bgnd setShader("white", 260, 140);
	
	level.stat_header = newHudElem();
	level.stat_header.archived = false;
	level.stat_header.alpha = .3;
	level.stat_header.x = 208;
	level.stat_header.y = offset + 19;
	level.stat_header.sort = 9001;
	level.stat_header setShader("white", 254, 21);
	
	level.stat_headerText = newHudElem();
	level.stat_headerText.archived = false;
	level.stat_headerText.x = 335;
	level.stat_headerText.y = offset + 21;
	level.stat_headerText.sort = 9998;
	level.stat_headerText.alignx = "center";
	level.stat_headerText.label = &"^2Your Stats^7: ";
	level.stat_headerText.fontscale = 1.3;

	level.stat_leftline = newHudElem();
	level.stat_leftline.archived = false;
	level.stat_leftline.alpha = .3;
	level.stat_leftline.x = 207;
	level.stat_leftline.y = offset + 19;
	level.stat_leftline.sort = 9001;
	level.stat_leftline setShader("white", 1, 135);
	
	level.stat_rightline = newHudElem();
	level.stat_rightline.archived = false;
	level.stat_rightline.alpha = .3;
	level.stat_rightline.x = 462;
	level.stat_rightline.y = offset + 19;
	level.stat_rightline.sort = 9001;
	level.stat_rightline setShader("white", 1, 135);
	
	level.stat_bottomline = newHudElem();
	level.stat_bottomline.archived = false;
	level.stat_bottomline.alpha = .3;
	level.stat_bottomline.x = 207;
	level.stat_bottomline.y = offset + 154;
	level.stat_bottomline.sort = 9001;
	level.stat_bottomline setShader("white", 256, 1);
	
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
	{
		player = players[ i ];
		
		player.stat_thisround = newClientHudElem( player );
		player.stat_thisround.alpha = 1;
		player.stat_thisround.x = 214;
		player.stat_thisround.y = offset + 45;
		player.stat_thisround.sort = 9001;
		player.stat_thisround.label = &"This Round: ";
		player.stat_thisround.fontscale = 0.9;
		
		player.stat_gainedxp = newClientHudElem( player );
		player.stat_gainedxp.alpha = 1;
		player.stat_gainedxp.x = 224;
		player.stat_gainedxp.y = offset + 60;
		player.stat_gainedxp.sort = 9001;
		player.stat_gainedxp.label = &"Gained XP: ";
		player.stat_gainedxp.fontscale = 0.9;	
		player.stat_gainedxp setValue( player.score );
		
		player.stat_gainedkills = newClientHudElem( player );
		player.stat_gainedkills.alpha = 1;
		player.stat_gainedkills.x = 224;
		player.stat_gainedkills.y = offset + 75;
		player.stat_gainedkills.sort = 9001;
		player.stat_gainedkills.label = &"Gained Kills: ";
		player.stat_gainedkills.fontscale = 0.9;	
		player.stat_gainedkills setValue( player.zomscore );
		
		player.stat_gainedpoints = newClientHudElem( player );
		player.stat_gainedpoints.alpha = 1;
		player.stat_gainedpoints.x = 224;
		player.stat_gainedpoints.y = offset + 90;
		player.stat_gainedpoints.sort = 9001;
		player.stat_gainedpoints.label = &"Gained Points: ";
		player.stat_gainedpoints.fontscale = 0.9;	
		player.stat_gainedpoints setValue( player.pointscore );
		
		player.stat_shotsfired = newClientHudElem( player );
		player.stat_shotsfired.alpha = 1;
		player.stat_shotsfired.x = 224;
		player.stat_shotsfired.y = offset + 105;
		player.stat_shotsfired.sort = 9001;
		player.stat_shotsfired.label = &"Shots Fired: ";
		player.stat_shotsfired.fontscale = 0.9;	
		player.stat_shotsfired setValue( player.shotsfired );
		
		player.stat_shotshit = newClientHudElem( player );
		player.stat_shotshit.alpha = 1;
		player.stat_shotshit.x = 224;
		player.stat_shotshit.y = offset + 120;
		player.stat_shotshit.sort = 9001;
		player.stat_shotshit.label = &"Shots Hit: ";
		player.stat_shotshit.fontscale = 0.9;	
		player.stat_shotshit setValue( player.shotshit );
		
		player.stat_accuracy = newClientHudElem( player );
		player.stat_accuracy.alpha = 1;
		player.stat_accuracy.x = 224;
		player.stat_accuracy.y = offset + 135;
		player.stat_accuracy.sort = 9001;
		player.stat_accuracy.label = &"Accuracy: ";
		player.stat_accuracy.fontscale = 0.9;	
		if ( player.shotshit > 0 ) {
			player.stat_accuracy setValue( ( player.shotsfired / player.shotshit ) );
		} else {
			player.stat_accuracy setValue( 0 );
		}
		
		player.stat_alltime = newClientHudElem( player );
		player.stat_alltime.alpha = 1;
		player.stat_alltime.x = 344;
		player.stat_alltime.y = offset + 45;
		player.stat_alltime.sort = 9001;
		player.stat_alltime.label = &"All Time: ";
		player.stat_alltime.fontscale = 0.9;
		
		player.stat_xptotal = newClientHudElem( player );
		player.stat_xptotal.alpha = 1;
		player.stat_xptotal.x = 364;
		player.stat_xptotal.y = offset + 60;
		player.stat_xptotal.sort = 9001;
		player.stat_xptotal.label = &"XP: ";
		player.stat_xptotal.fontscale = 0.9;
		player.stat_xptotal setValue( player.xp );
		
		player.stat_killtotal = newClientHudElem( player );
		player.stat_killtotal.alpha = 1;
		player.stat_killtotal.x = 364;
		player.stat_killtotal.y = offset + 75;
		player.stat_killtotal.sort = 9001;
		player.stat_killtotal.label = &"Kills: ";
		player.stat_killtotal.fontscale = 0.9;
		player.stat_killtotal setValue( player.zomxp );
		
		player.stat_pointstotal = newClientHudElem( player );
		player.stat_pointstotal.alpha = 1;
		player.stat_pointstotal.x = 364;
		player.stat_pointstotal.y = offset + 90;
		player.stat_pointstotal.sort = 9001;
		player.stat_pointstotal.label = &"Points: ";
		player.stat_pointstotal.fontscale = 0.9;
		player.stat_pointstotal setValue( player.points );
	}
}

endgamehud_cleanup()
{
	players = getEntArray( "player", "classname" );
	
	for ( i = 0; i < players.size; i++ )
	{
		player = players[ i ];
		
		if ( isDefined( player.stat_thisround ) )			player.stat_thisround destroy();
		if ( isDefined( player.stat_gainedxp ) )			player.stat_gainedxp destroy();
		if ( isDefined( player.stat_gainedkills ) )			player.stat_gainedkills destroy();
		if ( isDefined( player.stat_gainedpoints ) )		player.stat_gainedpoints destroy();
		if ( isDefined( player.stat_shotsfired ) ) 			player.stat_shotsfired destroy();
		if ( isDefined( player.stat_shotshit ) )			player.stat_shotshit destroy();
		if ( isDefined( player.stat_accuracy ) )			player.stat_accuracy destroy();
		if ( isDefined( player.stat_alltime ) )				player.stat_alltime destroy();
		if ( isDefined( player.stat_xptotal ) )				player.stat_xptotal destroy();
		if ( isDefined( player.stat_killtotal ) )			player.stat_killtotal destroy();
		if ( isDefined( player.stat_pointstotal ) )			player.stat_pointstotal destroy();
	}
}

nightvision()
{
	self.nightvision = true;
	/*
	self.nightvis = newClientHudElem( self );
	self.nightvis.x = 0;
	self.nightvis.y = 0;
	self.nightvis setShader( "gfx/effects/dark_smoke.tga", 640, 480 );
	self.nightvis.alpha = 0.2;
	self.nightvis.sort = 9001;
	//self.nightvis.color = ( 0, 1, 0 );*/
}