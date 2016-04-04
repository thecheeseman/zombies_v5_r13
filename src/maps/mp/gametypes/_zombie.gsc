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

/*
	Zombies 
*/

Main()
{
	maps\mp\gametypes\_debug::init();
	[[ level.logwrite ]]( "VV---------- _zombie.gsc::Main() ----------VV" );

	precache();
	
	thread maps\mp\gametypes\_config::main();
	thread maps\mp\gametypes\_killstreaks::init();
	thread maps\mp\gametypes\_buymenu::init();
	thread maps\mp\gametypes\_mapvote::init();
	thread maps\mp\gametypes\_ammoboxes::main();
	thread maps\mp\gametypes\_admin::main();
	thread maps\mp\gametypes\_extra::main();
	thread maps\mp\gametypes\_weather::main();
	thread maps\mp\gametypes\_sharkscanner::main();
	thread maps\mp\gametypes\_hud::init();
	thread maps\mp\gametypes\_stats::main();
	thread maps\mp\gametypes\_ranks::init();
    thread maps\mp\gametypes\_skins::init();
	thread zombies\modules::init();
	
	thread weaponremoval();

	[[ level.logwrite ]]( "^^---------- _zombie.gsc::Main() ----------^^" );
}

precache()
{
	precacheShader( "white" );
	precacheShader( "black" );
	
	precacheHeadIcon( "gfx/hud/headicon@re_objcarrier.tga" );
	precacheHeadIcon( "gfx/hud/headicon@axis.tga" );
	precacheHeadIcon( "gfx/hud/headicon@allies.tga" );
	precacheStatusIcon( "gfx/hud/headicon@re_objcarrier.tga" );
	precacheStatusIcon( "gfx/hud/headicon@axis.tga" );
	precacheStatusIcon( "gfx/hud/headicon@allies.tga" );
	precacheShader( "gfx/hud/hud@objective_bel.tga" );
	precacheShader( "gfx/hud/hud@objectivegoal.tga" );
	precacheShader( "gfx/hud/hud@fire_ready.tga" );
	precacheShader( "gfx/hud/headicon@axis.tga" );
	precacheShader( "gfx/hud/headicon@allies.tga" );
	precacheShader( "gfx/hud/hud@health_cross.tga" );
	precacheShader( "killiconmelee" );
	precacheShader( "killicondied" );
	precacheShader( "killiconheadshot" );
	precacheShader( "killiconsuicide" );
	precacheShader( "gfx/impact/flesh_hit1.tga" );
	precacheShader( "gfx/impact/flesh_hit2.tga" );
	precacheShader( "gfx/hud/hud@health_back.dds" );
	precacheShader( "gfx/hud/hud@health_bar.dds" );
	
	precacheItem( "fg42_mp" );
	precacheItem( "panzerfaust_mp" );
	
	precacheMenu( "weapon_russian" );
	
	precacheShellshock( "default" );
	precacheShellshock( "groggy" );
	
	precacheModel( "xmodel/playerbody_russian_veteran" );
	precacheModel( "xmodel/sovietequipment_helmet" );
	precacheModel( "xmodel/viewmodel_hands_russian_vetrn" );
	precacheModel( "xmodel/gear_russian_load_coat" );
	precacheModel( "xmodel/gear_russian_ppsh_coat" );
	precacheModel( "xmodel/gear_russian_pack_ocoat" );
	
	precacheModel( "xmodel/playerbody_russian_conscript" );
	precacheModel( "xmodel/head_pavlov" );
	precacheModel( "xmodel/equipment_pavlov_ushanka" );
	precacheModel( "xmodel/viewmodel_hands_russian" );
	precacheModel( "xmodel/gear_russian_commisar" );
	precacheModel( "xmodel/playerbody_german_kriegsmarine" );
	precacheModel( "xmodel/head_price" );
	precacheModel( "xmodel/equipment_british_beret_green" );
	precacheModel( "xmodel/viewmodel_hands_kriegsmarine" );
	precacheModel( "xmodel/gear_british_price" );
	precacheModel( "xmodel/playerbody_american_airborne" );
	precacheModel( "xmodel/head_moody" );
	precacheModel( "xmodel/equipment_us_helmet_scrim" );
	precacheModel( "xmodel/viewmodel_hands_us" );
	precacheModel( "xmodel/gear_us_moody" );

	if ( getMapWeather() == "winter" )
	{
		mptype\american_airborne_winter::precache();
		game["axis_model2"] = mptype\american_airborne_winter::main;
	}
	else
	{
		mptype\american_airborne::precache();
		game["axis_model2"] = mptype\american_airborne::main;
	}
	
	level._effect[ "zombieFire" ] = loadFx( "fx/fire/tinybon.efx" );
	level._effect[ "zombieExplo" ] = loadfx( "fx/explosions/pathfinder_explosion.efx" );
	level._effect[ "fleshhit" ] = loadfx( "fx/impacts/flesh_hit.efx" );
	level._effect[ "fleshhit2" ] = loadfx( "fx/impacts/flesh_hit5g.efx" );
	level._effect[ "bombexplosion" ]= loadfx( "fx/explosions/grenade3.efx" );
	level._effect[ "explosion1" ] = loadfx( "fx/explosions/explosion1.efx" );
	level._effect[ "v2" ] = loadfx( "fx/explosions/v2_exlosion.efx" );
	level._effect[ "aftermath" ] = loadfx( "fx/smoke/aftermath1.efx" );	
	level._effect[ "cratersmoke" ] = loadfx( "fx/smoke/cratersmoke.efx" );
	level._effect[ "stage1" ] = loadfx( "fx/fire/stage1.efx" );
	
	level.voices[ "german" ] = 3;
	level.voices[ "american" ] = 7;
	level.voices[ "russian" ] = 4;
	level.voices[ "british" ] = 5;
	
	level.lastKiller = undefined;
	level.firstzombie = false;
	level.lasthunter = false;
	level.gamestarted = false;
	level.stickynades = 0;
	level.uav = false;
	level.nuked = false;
	level.revision = 13;
}

weaponremoval()
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

startGame()
{
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_zombie.gsc::startGame()", true );

	setCvar( "g_teamname_axis", "^6Hunters" );
	setCvar( "g_teamname_allies", "^1Zombies" );
	
	level.waitnotice = newHudElem();
	level.waitnotice.x = 320;
	level.waitnotice.y = 240;
	level.waitnotice.alignX = "center";
	level.waitnotice.alignY = "middle";
	level.waitnotice setText( &"Waiting for ^22 ^7players..." );
	level.waitnotice.alpha = 0.75;
	
	thread rotateIfEmpty();
	
	while ( 1 )
	{
		ePlayers = getPlayersOnTeam( "axis" );
		if ( ePlayers.size > 1 )
			break;
			
		wait 1;
	}
	
	level notify( "starting game" );
	
	level.waitnotice destroy();

	level.clock = newHudElem();
	level.clock.x = 320;
	level.clock.y = 20;
	level.clock.alignX = "center";
	level.clock.alignY = "middle";
	level.clock.font = "bigfixed";
	level.clock.color = ( 1, 1, 1 );
	level.clock setTimer( level.cvars[ "PREGAME_TIME" ] );
	level.clock fadeOverTime( level.cvars[ "PREGAME_TIME" ] );
	level.clock.color = ( 1, 0, 0 );
	
	wait ( level.cvars[ "PREGAME_TIME" ] );
	
	level.clock destroy();
	level.gamestarted = true;

	pickZombie();
	level.firstzombie = true;
		
	wait 2;

	players = getEntArray( "player", "classname" );
	timeshift = (float) ( (float) players.size / (float) 12 );
	if ( timeshift > 1 )	timeshift = 1;
	if ( timeshift < 0.4 )	timeshift = 0.4;

	level.timelimit *= timeshift;
	
	level.starttime = getTime();
	level.clock = newHudElem();
	level.clock.x = 320;
	level.clock.y = 20;
	level.clock.alignX = "center";
	level.clock.alignY = "middle";
	level.clock.font = "bigfixed";
	level.clock.color = ( 0, 0.75, 0 );
	level.clock setTimer( level.timelimit * 60 );
	
	thread gameLogic();
}

rotateIfEmpty()
{
	level endon( "starting game" );
	
	time = 0;
	
	while ( time < 1200 )
	{
		time++;
		wait 1;
	}
	
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_zombie.gsc::rotateIfEmpty() -- exiting because empty" );
	exitLevel( false );
}

pickZombie()
{
	zom = undefined;
	guys = getPlayersOnTeam( "axis" );
	lasthunter = getCvar( "lasthunter" );
	
	for ( i = 0; i < guys.size; i++ )
	{
		if ( monotone( guys[ i ].name ) == lasthunter )
			zom = guys[ i ];
	}
	
	if ( isDefined( zom ) )
	{
		iPrintLnBold( cleanString( zom.name ) + "^7 was the last ^6Hunter^7, he's now the first ^1Zombie^7!" );
		zom.nonotice = true;
		zom thread makeZombie();
		wait 0.05;
		setCvar( "lastzom", monotone( zom.name ) );
		return;
	}
	
	int = _randomInt( guys.size );
	zom = guys[ int ];
	while ( monotone( zom.name ) == getCvar( "lastzom" ) )
	{
		iPrintLnBold( cleanString( zom.name ) + "^7 was the ^1Zombie^7 last time... picking someone else..." );
		wait 2;
		int = _randomInt( guys.size );
		zom = guys[ int ];
	}
	
	iPrintLnBold( cleanString( zom.name ) + "^7 was randomly selected to be the ^1Zombie^7!" );
	zom.nonotice = true;
	zom thread makeZombie();
	wait 0.05;
	setCvar( "lastzom", monotone( zom.name ) );
}

endGame( winner )
{
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_zombie.gsc::endGame( " + winner + " )", true );
	game[ "state" ] = "endgame";
	level notify( "endgame" );
	level notify( "intermission" );
	
	level.mapended = true;
	
	if ( !level.lasthunter )
		setCvar( "lasthunter", "" );
	
	level.clock destroy();
	
	thread maps\mp\gametypes\_stats::resetStatsVars();
	
	if ( winner == "zombies" )
		iPrintLnBold( "^1Zombies have killed all the Hunters!" );
	else if ( winner == "hunters" )
		iPrintLnBold( "^6Hunters have survived!" );
	else if ( winner == "forced" )
		iPrintLnBold( "^1Admin forced end game!" );
	else if ( winner == "nuke" )
		iPrintLnBold( "^3Nuke killed everyone!" );
		
	wait 3;
	
	if ( winner == "hunters" )
	{
		setCvar( "lasthunter", "" );
		
		hunters = getPlayersOnTeam( "axis" );
		iPrintLnBold( "Surviving Hunters get a ^6" + level.xpvalues[ "HUNTER_WIN" ] + "^7 XP bonus!" );
		
		for ( i = 0; i < hunters.size; i++ )
		{
			hunters[ i ].xp += level.xpvalues[ "HUNTER_WIN" ];
			hunters[ i ].score += level.xpvalues[ "HUNTER_WIN" ];
			hunters[ i ].points += level.pointvalues[ "HUNTER_WIN" ];
			hunters[ i ] thread checkRank();
		}
		
		wait 1;
	}
	
	if ( winner == "nuke" && !level.lasthunter )
		setCvar( "lasthunter", "" );
	
	players = getentarray( "player", "classname" );
	
	if ( winner == "zombies" )
	{
		for(i = 0; i < players.size; i++)
		{
			player = players[i];
			player closeMenu();
			player setClientCvar( "g_scriptMainMenu", "main" );
			player thread GameCam( level.lastKiller getEntityNumber(), 2 );
		}
		
		wait 4.5;
		
		slowMo( 3.5 );
	}

	for ( i = 0; i < players.size; i++ )
	{
		if ( isAlive( players[ i ] ) ) {
			players[ i ] thread gameCamRemove();
		}
		
		players[ i ] maps\mp\gametypes\zombies::spawnSpectator();
		players[ i ].org = spawn( "script_origin", players[ i ].origin );
		players[ i ] linkto( players[ i ].org );
	}
	
	if ( !level.nuked )
		setCullFog( 0, 7500, 0, 0, 0, 3 );
	
	thread maps\mp\gametypes\_stats::saveAll();
	thread maps\mp\gametypes\_hud::endgamehud();

	centerImage = newHudElem();
	centerImage.x = 320;
	centerImage.y = 105;
	centerImage.alignX = "center";
	centerImage.alignY = "middle";
	centerImage.alpha = 0;
	centerImage.sort = 10;

	// look, i know this doesn't need to be in its own scope
	// but it makes me sleep better at night, okay?
	{
		cleanScreen();
		iPrintLnBold( "Best ^2Hunters ^7& ^1Zombies" );
		
		wait 3;

		guy = getBest( "hunter" );
		if ( isDefined( guy ) ) {
			centerImage thread fadeIn( 0.5, "gfx/hud/headicon@axis.tga" );
			cleanScreen();
			iPrintlnBold( "^2Best Hunter: " );
			iPrintlnBold( cleanString( guy.name ) + " ^7- ^1" + guy.score );

			wait 2.5;
			centerImage thread fadeOut( 0.5 );
			wait 0.5;
		}

		guy = getBest( "zombie" );
		if ( isDefined( guy ) ) {
			centerImage thread fadeIn( 0.5, "gfx/hud/headicon@allies.tga" );
			cleanScreen();
			iPrintlnBold( "^1Best Zombie: " );
			iPrintlnBold( cleanString( guy.name ) + " ^7- ^1" + guy.deaths );

			wait 2.5;
			centerImage thread fadeOut( 0.5 );
			wait 0.5;
		}
		
		guy = getMost( "kills" );
		if ( isDefined( guy ) ) {
			centerImage thread fadeIn( 0.5, "killicondied" );
			cleanScreen();
			iPrintlnBold( "^3Most Kills: " );
			iPrintlnBold( cleanString( guy.name ) + " - ^1" + guy.stats[ "kills" ] );
			
			wait 2.5;
			centerImage thread fadeOut( 0.5 );
			wait 0.5;
		}

		guy = getMost( "assists" );
		if ( isDefined( guy ) ) {
			centerImage thread fadeIn( 0.5, "gfx/hud/hud@health_cross.tga" );
			cleanScreen();
			iPrintlnBold( "^4Most Assists: " );
			iPrintlnBold( cleanString( guy.name ) + " - ^1" + guy.stats[ "assists" ] );
			
			wait 2.5;
			centerImage thread fadeOut( 0.5 );
			wait 0.5;
		}

		guy = getMost( "bashes" );
		if ( isDefined( guy ) ) {
			centerImage thread fadeIn( 0.5, "killiconmelee" );
			cleanScreen();
			iPrintlnBold( "^5Most Bashes: " );
			iPrintlnBold( cleanString( guy.name ) + " - ^1" + guy.stats[ "bashes" ] );

			wait 2.5;
			centerImage thread fadeOut( 0.5 );
			wait 0.5;
		}

		guy = getMost( "headshots" );
		if ( isDefined( guy ) ) {
			centerImage thread fadeIn( 0.5, "killiconheadshot" );
			cleanScreen();
			iPrintlnBold( "^6Most Headshots: " );
			iPrintlnBold( cleanString( guy.name ) + " - " + guy.stats[ "headshots" ] );
			
			wait 2.5;
			centerImage thread fadeOut( 0.5 );
			wait 0.5;
		}
		
		centerImage destroy();
		cleanScreen();
	}
	
	thread maps\mp\gametypes\_mapvote::Initialize();
	level waittill( "VotingComplete" );
		
	thread maps\mp\gametypes\_hud::endgamehud_cleanup();
	
	game[ "state" ] = "intermission";
	
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
		players[ i ] maps\mp\gametypes\zombies::spawnIntermission();
		
	setCullFog( 0, 1, 0, 0, 0, 7 );
	
	wait 10;
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_zombie.gsc::endGame( " + winner + " ) -- exiting level", true );
	exitLevel( false );
}

gameLogic()
{
	level endon( "endgame" );
	level endon( "intermission" );
	
	while ( 1 )
	{
		zombies = getPlayersOnTeam( "allies" );
		hunters = getPlayersOnTeam( "axis" );
		
		if ( zombies.size == 0 && hunters.size > 0 )
		{
			pickZombie();
			wait 0.05;
		}
			
		if ( zombies.size == 1 && !level.firstzombie )
			level.firstzombie = true;
		if ( zombies.size > 1 && level.firstzombie )
			level.firstzombie = false;
		
		if ( hunters.size == 1 && !level.lasthunter && zombies.size > 1 )
		{
			level.lasthunter = true;
			guy = hunters[ 0 ];
			
			guy thread lastHunter();
		}
		
		if ( level.nuked )
			break;
		
		if ( hunters.size == 0 )
		{
			thread endGame( "zombies" );
			break;
		}
		
		wait 0.05;
	}
	
	wait 3;
	
	if ( !level.mapended )
	{
		zombies = getPlayersOnTeam( "allies" );
		hunters = getPlayersOnTeam( "axis" );
		
		if ( hunters.size == 0 )
		{
			thread endGame( "zombies" );
			return;
		}

		if ( level.nuked )
			return;
		
		[[ level.logwrite ]]( "maps\\mp\\gametypes\\_zombie.gsc::gameLogic() -- server hung up??" );
		iPrintLnBold( "Server hung up... switching maps..." );
		wait 5;
		exitLevel( false );
	}
}

gameCam( playerNum, delay )
{
	self endon( "disconnect" );
	self endon( "spawned" );

	if ( playerNum < 0 )
		return;
		
	self.sessionstate = "spectator";
	self.spectatorclient = playerNum;
	self.archivetime = delay + 7;

	wait 0.05;
		
	if ( !isDefined( self.gc_topbar ) )
	{
		self.gc_topbar = newClientHudElem( self );
		self.gc_topbar.archived = false;
		self.gc_topbar.x = 0;
		self.gc_topbar.y = 0;
		self.gc_topbar.alpha = 0.75;
		self.gc_topbar.sort = 1000;
		self.gc_topbar setShader( "black", 640, 112 );
	}

	if ( !isDefined( self.gc_bottombar ) )
	{
		self.gc_bottombar = newClientHudElem( self );
		self.gc_bottombar.archived = false;
		self.gc_bottombar.x = 0;
		self.gc_bottombar.y = 368;
		self.gc_bottombar.alpha = 0.75;
		self.gc_bottombar.sort = 1000;
		self.gc_bottombar setShader( "black", 640, 112 );
	}
}

gameCamRemove()
{
	if ( isDefined( self.gc_topbar ) )		self.gc_topbar destroy();
	if ( isDefined( self.gc_bottombar ) ) 	self.gc_bottombar destroy();
	if ( isDefined( self.gc_title ) )		self.gc_title destroy();
	if ( isDefined( self.gc_timer ) )		self.gc_timer destroy();
	
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.sessionstate = "dead";
}

onConnect()
{
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_zombie.gsc:onConnect() -- " + self.name + " connected (" + self getip() + ")" );

	if ( self.name == "Unknown Soldier" )
		self setClientCvar( "name", "I^1<3^7ZOMBAIS^1" + gettime() );
		
	self.oldname = self.name;
	
	self.rank = 0;
	self.xp = 0;
	self.killstreak = 0;
	self.zomrank = 0;
	self.zomxp = 0;
	self.points = 0;
	
	self.stats = [];
	self.stats[ "kills" ] = 0;
	self.stats[ "deaths" ] = 0;
	self.stats[ "bashes" ] = 0;
	self.stats[ "damage" ] = 0;
	self.stats[ "headshots" ] = 0;
	self.stats[ "assists" ] = 0;
	self.stats[ "totalkills" ] = 0;
	self.stats[ "totaldeaths" ] = 0;
	self.stats[ "totalbashes" ] = 0;
	self.stats[ "totaldamage" ] = 0;
	self.stats[ "totalheadshots" ] = 0;
	self.stats[ "totalassists" ] = 0;
	self.stats[ "totalshotsfired" ] = 0;
	self.stats[ "totalshotshit" ] = 0;
	
	self thread maps\mp\gametypes\_stats::getMyStats();
	
	self.iszombie = false;
	self.zombietype = "none";
	self.gettingammo = false;
	self.givenammo = false;
	self.nonotice = false;
	self.islasthunter = false;
	self.changeweapon = false;
	self.immune = false;
	self.isadmin = false;
	
	self.damagemult = 0;
	self.resilience = 0;
	self.jumpmult = 0;
	self.stickynadecount = 0;
	self.stickynades = 0;
	self.healthpacks = 0;
	self.maxhealthpacks = 0;
	self.bodyarmor = 0;
	self.exploarmor = 0;
	self.damagearmor = 0;
	self.ammoboxuses = 0;
	self.megajump = 0;
	self.shotsfired = 0;
	self.shotshit = 0;
	self.zomscore = 0;
	self.pointscore = 0;
	self.immunity = 0;
	self.zomnadeammo = 0;
	self.ammobonus = 0;
	self.specialmodel = false;
	
	self.ispoisoned = false;
	self.onfire = false;
	self.isnew = true;
	self.powerup = undefined;
	self.missmines = false;
	self.rocketattack = false;
	self.nationality = "none";
	self.lastattackers = [];
	self.painsound = undefined;
	self.firebombready = true;
	self.firebombed = false;
	self.poisonbombready = true;
	self.modelchanged = false;
	self.nightvision = false;
	
	self.barricades = [];
	
	if ( toLower( getCvar( "mapname" ) ) == "cp_omahgawd" || toLower( getCvar( "mapname" ) ) == "cp_banana" )
		self setClientCvar( "r_fastsky", 0 );
	else
		self setClientCvar( "r_fastsky", 1 );
		
	self thread extraKeys();
}

onDisconnect()
{
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_zombie.gsc::onDisconnect() -- " + self.name + " disconnected (" + self getip() + ")", true );
}

spawnPlayer()
{
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_zombie.gsc::spawnPlayer() -- spawned player " + self.name + " (" + self getip() + ")", true );

	self.killstreak = 0;
	self.ispoisoned = false;
	self.onfire = false;
	self.gettingammo = false;
	self.givenammo = false;
	self.nonotice = false;
	self.immune = false;
	self.stickynades = 0;
	self.stickynadecount = 0;
	self.healthpacks = 0;
	self.powerup = undefined;
	self.armored = false;
	self.damagemult = 1;
	self.resilience = 0;
	self.jumpmult = 2;
	self.missmines = false;
	self.rocketattack = false;
	self.lastattackers = [];
	self.painsound = undefined;
	self.firebombed = false;
	self.bodyarmor = 0;
	self.exploarmor = 0;
	self.damagearmor = 0;
	self.ammoboxuses = 0;
	self.megajump = 0;
	self.shotsfired = 0;
	self.shotshit = 0;
	self.immunity = 0;
	self.nightvision = false;
	self.zomnadeammo = 0;
	self.ammobonus = 0;
	self.specialmodel = false;
	
	if ( isDefined( self.spechud ) || isDefined( self.specnotice ) )
	{
		self.spechud destroy();
		self.specnotice destroy();
	}
	
	self thread maps\mp\gametypes\_hud::runHud();
	
	if ( self.pers[ "team" ] == "axis" )
	{
		if ( self.iszombie )
		{
			self.iszombie = false;
			self.zombietype = "none";
		}

		self setupClasses();
		
		self thread ammoLimiting();
		self thread maps\mp\gametypes\_ranks::giveHunterRankPerks();
		self thread stickynades();
		self thread timeAlive();
		self thread whatscooking();
		self thread shotsfired();
		
		self.headiconteam = "axis";
	}
	else if ( self.pers[ "team" ] == "allies" )
	{
		if ( !self.iszombie )
			self.iszombie = true;
			
		self setWeaponSlotAmmo( "primary", 0 );
		self setWeaponSlotAmmo( "pistol", 0 );
		self setWeaponSlotClipAmmo( "primary", 0 );
		self setWeaponSlotClipAmmo( "pistol", 0 );
		
		self setupClasses();

		if ( self.headicon != "" )
		{
			self.headicon = "";
			self.headiconteam = "";
		}
			
		self thread maps\mp\gametypes\_ranks::giveZomRankPerks();
	}
	
	if ( self.isnew )
	{
		self.isnew = false;
		self thread maps\mp\gametypes\_config::welcomeMessage();
	}
	
	if ( level.debug )
		self thread showpos();
}

spawnSpectator()
{
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_zombie.gsc::spawnSpectator() -- spawned spectator " + self.name + " (" + self getip() + ")", true );
	self notify( "spawn_spectator" );
	
	self.ispoisoned = false;
	self.onfire = false;
	self.iszombie = false;
	self.gettingammo = false;
	self.givenammo = false;
	self.zombietype = "none";
	
	self.pers[ "savedmodel" ] = undefined;
	
	self thread cleanUpHud();
	self thread maps\mp\gametypes\_buymenu::cleanUp();
	
	if ( getCvar( "zom_antispec" ) == "1" && !level.mapended )
	{
		self.spechud = newClientHudElem( self );
		self.spechud.sort = -1;
		self.spechud.x = 0;
		self.spechud.y = 0;
		self.spechud setShader( "black", 640, 480 );
		self.spechud.alpha = 1;
		self.spechud.archived = false;
		
		self.specnotice = newClientHudElem( self );
		self.specnotice.sort = -2;
		self.specnotice.x = 320;
		self.specnotice.y = 220;
		self.specnotice.alignx = "center";
		self.specnotice.aligny = "middle";
		self.specnotice setText( &"^3Spectating is not allowed." );
		self.specnotice.alpha = 1;
		self.spechud.archived = false;
	}
}

spawnIntermission()
{
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_zombie.gsc::spawnIntermission() -- spawned intermission " + self.name + " (" + self getip() + ")", true );

	self notify( "spawn_intermission" );
	
	self.ispoisoned = false;
	self.onfire = false;
	self.iszombie = false;
	self.gettingammo = false;
	self.givenammo = false;
	self.zombietype = "none";
	
	self thread cleanUpHud();
	self thread maps\mp\gametypes\_buymenu::cleanUp();
}

onDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc )
{
	if ( iDamage < 1 )
		iDamage = 1;
	
	if ( isPlayer( eAttacker ) && eAttacker != self )
	{
		if ( eAttacker != self )
		{
			eAttacker.stats[ "damage" ] += iDamage;
			eAttacker.shotshit++;
		
			if ( eAttacker.iszombie )
			{
				eAttacker.deaths += iDamage;

				// grenade damage
				if ( sWeapon == "mk1britishfrag_mp" ) {
					doit = true;

					if ( ( self.immunity > 2 || self.exploarmor > 0 ) )
						doit = false;

					y = randomInt( 100 );
					iPrintLn( y );

					if ( y < 75 )
						doit = false;

					if ( doit ) {
						if ( eAttacker.zombietype == "poison" && !self.ispoisoned ) {
							self thread bePoisoned( eAttacker );
						} else if ( eAttacker.zombietype == "fire" && !self.onfire ) {
							self thread firemonitor( eAttacker );
						} else if ( eAttacker.zombietype == "jumper" ) {
							// apply velocity here
							//self setVelocity( vectornormalize( eAttacker.origin - self.origin ) );
							self.health += 2000;
							self finishPlayerDamage( eAttacker, eAttacker, 2000, 0, "MOD_PROJECTILE", "panzerfaust_mp", (self.origin + (0,0,-1)), vectornormalize( self.origin - eAttacker.origin ), "none" );
						} else if ( eAttacker.zombietype == "fast" ) {
							// apply slow speed here
							self shellshock( "groggy", 2 );
						}
					}
				}
				
				if ( eAttacker.zombietype == "poison" && !self.ispoisoned )
				{
					doit = true;

					if ( sWeapon == "mk1britishfrag_mp" ) {
						doit = false;
					} else 
					{
						if ( iDamage < 100 && self.immunity > 1 )
							doit = false;
						if ( iDamage < 200 && iDamage >= 100 && self.immunity > 2 )
							doit = false;
						if ( iDamage < 300 && iDamage >= 200 && self.immunity > 3 )
							doit = false;
						if ( iDamage >= 300 && self.immunity > 4 )
							doit = false;
					}
					
					if ( doit )
						self thread bePoisoned( eAttacker );
				}
				
				if ( eAttacker.zombietype == "fire" && !self.onfire )
				{
					doit = true;

					if ( sWeapon == "mk1britishfrag_mp" ) {
						doit = false;
					} else {
						if ( iDamage < 100 && self.immunity > 1 )
							doit = false;
						if ( iDamage < 200 && iDamage >= 100 && self.immunity > 2 )
							doit = false;
						if ( iDamage < 300 && iDamage >= 200 && self.immunity > 3 )
							doit = false;
						if ( iDamage >= 300 && self.immunity > 4 )
							doit = false;
					}
					
					if ( doit )
						self thread firemonitor( eAttacker );
				}
			}
			
			if ( self.pers[ "team" ] == "allies" && eAttacker.pers[ "team" ] == "axis" && sMeansOfDeath == "MOD_MELEE" )
				self shellshock( "groggy", 3 );
			
			eAttacker thread showhit();
			
			inarray = false;
			for ( i = 0; i < self.lastattackers.size; i++ )
			{
				if ( self.lastattackers[ i ].ent == eAttacker )
				{
					inarray = true;
					self.lastattackers[ i ].time = getTime();
				}
			}
					
			if ( !inarray )
			{
				size = self.lastattackers.size;
				self.lastattackers[ size ] = spawnstruct();
				self.lastattackers[ size ].ent = eAttacker;
				self.lastattackers[ size ].time = getTime();
			}
		}
		
		self thread bloodsplatter();
		self thread painsound();
	}
	
	if ( isPlayer( eAttacker ) && eAttacker != self )
	{
		eAttacker iPrintLn( "You hit " + self.name + "^7 in " + getHitLoc( sHitLoc ) + "^7 with ^1" + (int)iDamage + "^7 damage!" );
		self iPrintLn( eAttacker.name + "^7 hit you in " + getHitLoc( sHitLoc ) + "^7 with ^1" + (int)iDamage + "^7 damage!" );
	}
	else if ( isPlayer( eAttacker ) && eAttacker == self )
		self iPrintLn( "You hit yourself in " + getHitLoc( sHitLoc ) + "^7 with ^1" + (int)iDamage + "^7 damage!" );
	
	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackname = "";
			lpattackerteam = "world";
		}

		if(isdefined(reflect)) 
		{  
			lpattacknum = lpselfnum;
			lpattackname = lpselfname;
			lpattackerteam = lpattackerteam;
		}
	}
}

onDeath( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc )
{
	if ( isPlayer( attacker ) && attacker != self )
	{
		if ( !attacker.iszombie )
		{
			attacker giveXP( sMeansOfDeath, self, self.lastattackers );
			attacker.killstreak++;
			attacker thread killstreakShiz();
		}
		
		if ( attacker.pers[ "team" ] == "allies" )
		{
			attacker.zomxp++;
			attacker.zomscore++;
			attacker thread checkRank();
		}
			
		attacker.stats[ "kills" ]++;
		
		if ( sMeansOfDeath == "MOD_MELEE" )
			attacker.stats[ "bashes" ]++;
			
		if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
			attacker.stats[ "headshots" ]++;
	}
	
	if ( level.gamestarted && self.pers[ "team" ] == "axis" && !self.nonotice )
	{
		if ( !level.nuked )
		{
			if ( isPlayer( attacker ) && attacker != self )
				iPrintLnBold( cleanString( self.name ) + "^7 had his brains eaten by " + cleanString( attacker.name ) + "^7!" );
			else if ( isPlayer( attacker ) && attacker == self )
				iPrintLnBold( cleanString( self.name ) + "^7 killed himself and is now a ^1Zombie^7!" );
			else
				iPrintLnBold( cleanString( self.name ) + "^7 died and is now a ^1Zombie^7!" );
		}

		self makeZombie();
	}
	
	self.stats[ "deaths" ]++;
	self.killstreak = 0;
	self.changeweapon = false;
	
	if ( self.pers[ "team" ] == "allies" && _randomInt( 100 ) > 85 && !level.lasthunter )
		self dropHealth();
	
	self thread cleanUpHud();
	self thread maps\mp\gametypes\_buymenu::cleanUp();
}

lastHunter()
{
	setCvar( "lasthunter", monotone( self.name ) );
	
	level notify( "stop ammoboxes" );
	
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_zombie.gsc::lastHunter() -- " + self.name + " (" + self getip() + ")", true );
	iPrintLnBold( cleanString( self.name ) + "^7 is the last ^6Hunter^7!" );
	
	self closeMenu();
	
	if ( isDefined( self.darkness ) )
		self.darkness destroy();
		
	if ( !self.isadmin && !self.modelchanged && !self.specialmodel )
	{
		self detachall();
		self setModel( "xmodel/playerbody_russian_veteran" );
		self character\_utility::attachFromArray( xmodelalias\head_allied::main() );
		self.hatModel = "xmodel/sovietequipment_helmet";
		self attach( self.hatModel );
		self setViewmodel( "xmodel/viewmodel_hands_russian_vetrn" );
		self attach( "xmodel/gear_russian_load_coat" );
		self attach( "xmodel/gear_russian_ppsh_coat" );
		self attach( "xmodel/gear_russian_pack_ocoat" );
		self.nationality = "russian";
	}

	self.notice = newClientHudElem( self );
	self.notice.x = 320;
	self.notice.y = 30;
	self.notice.alignx = "center";
	self.notice.aligny = "middle";
	self.notice.fontscale = 1.75;
	self.notice setText( &"^6Select your last hunter weapon." );
	self.notice.alpha = 1;
	self.notice.sort = 50;
	self.notice.archive = false;
	
	self.lasthunterhud = newClientHudElem( self );
	self.lasthunterhud.x = 0;
	self.lasthunterhud.y = 0;
	self.lasthunterhud setShader( "white", 640, 480 );
	self.lasthunterhud.color = ( 0, 0, 1 );
	self.lasthunterhud.alpha = 0.1;
	self.lasthunterhud.archive = true;
	self.lasthunterhud.sort = 20;
	
	self.maxhealth += 50;
	self.health = self.maxhealth;
	
	self setClientCvar( "scr_showweapontab", "1" );
	self setClientCvar( "g_scriptmainmenu", "weapon_russian" );
	
	self.xp += level.xpvalues[ "LASTHUNTER" ];
	self.score += level.xpvalues[ "LASTHUNTER" ];
	self.points += level.pointvalues[ "LASTHUNTER" ];
	self thread checkRank();
	self iPrintLn( "^3+" + level.xpvalues[ "LASTHUNTER" ] + " XP!" );
	
	wait 0.05;
	
	scriptedRadiusDamage( self.origin + ( 0, 0, 12 ), 2048, 2500, 20, self, self );
	playFx( level._effect[ "explosion1" ], self.origin );
	thread playSoundInSpace( "explo_rock", self.origin + ( 0, 0, 12 ), 4 );
	earthquake( 9999, 3, self.origin + ( 0, 0, 1 ), 512 );
	
	self openMenu( "weapon_russian" );
	
	wait 0.05;
	
	self thread lasthunter_weaponselect();
	self thread lasthunter_deathexplosion();
	self thread lastHunterCompass();
	self thread lasthunter_pistol();
	level waittill( "lasthunter weapon select" );
	
	self.notice destroy();

	if ( isAlive( self ) )
	{
		if ( self hasWeapon( "fg42_mp" ) )
		secondary1 = self getWeaponSlotAmmo( "primaryb" );
		secondary2 = self getWeaponSlotClipAmmo( "primaryb" );
		self takeAllWeapons();
		self giveWeapon( self.pers[ "weapon" ] );
		self giveWeapon( "panzerfaust_mp" );
		self giveWeapon( "colt_mp" );
		self giveWeapon( "rgd-33russianfrag_mp" );
		
		self setWeaponSlotAmmo( "grenade", self getLastHunterNadeAmmo() );
		self giveMaxAmmo( "colt_mp" );

		self switchToWeapon( self.pers[ "weapon" ] );
	}
	
	if ( isDefined( self.lasthunterhud ) )
		self.lasthunterhud destroy();
}

lasthunter_deathexplosion()
{
	self waittill( "death" );

	playFx( level._effect[ "v2" ], self.origin );
	thread playSoundInSpace( "explo_rock", self.origin + ( 0, 0, 12 ), 4 );	
	earthquake( 9999, 10, self.origin + ( 0, 0, 1 ), 4 );
}

lasthunter_weaponselect()
{
	self endon( "death" );
	level endon( "lasthunter weapon select" );
	
	thread lasthunter_death();
	
	while ( 1 )
	{
		self waittill( "menuresponse", menu, response );
		
		if ( response == "open" )
			continue;
		
		if ( response == "close" )
		{
			self openMenu( "weapon_russian" );
			continue;
		}
			
		if ( menu == "weapon_russian" )
		{
			if ( response == "team" || response == "viewmap" || response == "callvote" )
			{
				self closeMenu();
				wait 0.05;
				self openMenu( "weapon_russian" );
				continue;
			}
			
			self.pers[ "weapon" ] = response;
			break;
		}
	}
	
	level notify( "lasthunter weapon select" );
}

lasthunter_death()
{
	while ( isAlive( self ) && self.pers[ "team" ] != "allies" )
		wait 0.05;

	level notify( "lasthunter weapon select" );
	self closeMenu();
}

lastHunterCompass()
{
	wait 0.05;
	
	objnum = ( ( self getEntityNumber() ) + 1 );
	if ( objnum > 15 )	objnum = 15;

	objective_add( objnum, "current", self.origin, "gfx/hud/objective.tga" );
	objective_icon( objnum, "gfx/hud/objective.tga" );
	objective_team( objnum, "allies" );
	objective_position( objnum, self.origin );
	
	i = 0;
	while ( isAlive( self ) )
	{
		if ( i % 5 == 0 )
			objective_position( objnum, self.origin );
			
		i++;
		wait 1;
	}
	
	objective_delete( objnum );
}

lasthunter_pistol()
{
	while ( isAlive( self ) )
	{
		self setWeaponSlotAmmo( "pistol", 999 );
		wait 0.05;
	}
}

beFlashed( dmg )
{
	wait 0.05;
	self.isflashed = true;
	
	time = dmg / 50;
	if ( time > 5 )	time = 5;
	halftime = time / 2;
	
	if ( !isDefined( self.flashhud ) )
	{
		self.flashhud = newClientHudElem( self );
		self.flashhud.x = 0;
		self.flashhud.y = 0;
		self.flashhud setShader( "white", 640, 480 );
		self.flashhud.sort = 9999;
	}
	
	self.flashhud.alpha = 1;
	
	if ( time > 0.7 ) self shellshock( "default", time  );
	
	wait halftime;
	
	self.flashhud fadeOverTime( halftime );
	self.flashhud.alpha = 0;
	
	wait halftime;
	
	self.isflashed = undefined;
	self.flashhud destroy();
}

showhit()
{
	if ( isdefined( self.hitblip ) )
		self.hitblip destroy();

	self.hitblip = newClientHudElem( self );
	self.hitblip.alignX = "center";
	self.hitblip.alignY = "middle";
	self.hitblip.x = 320;
	self.hitblip.y = 240;
	self.hitblip.alpha = 0.5;
	self.hitblip setShader( "gfx/hud/hud@fire_ready.tga", 24, 24 );
	self.hitblip scaleOverTime( 0.15, 48, 48 );
	self.hitblip.archive = true;

	wait 0.15;

	if ( isdefined( self.hitblip ) )
		self.hitblip destroy();
}

makeZombie()
{
	if ( isAlive( self ) )
		self suicide();
		
	wait 0.10;
	
	self.pers[ "team" ] = "allies";
	self.pers[ "weapon" ] = undefined;
	self.pers[ "savedmodel" ] = undefined;
	self setClientCvar( "scr_showweapontab", "1" );
	self setClientCvar( "g_scriptMainMenu", game[ "menu_weapon_allies" ] );
	
	if ( !level.nuked )
		self openMenu( game[ "menu_weapon_allies" ] );
}

extraKeys()
{
	keyBuf = [];
	newKey = 0;
	chkKey = 0;
	maxKey = 32;
	codeLen = 4;

	but1State = false;
	but2State = false;
	but3State = false;

	interval = 0.05;
	counter = 0;
	for (;;)
	{
		wait( interval );

		if ( self.sessionstate != "playing" )
			continue;

		change = 0;

		but = self useButtonPressed();
		if ( but != but1State )
		{
			but1State = but;
			if ( !but )
			{
				keyBuf[ newKey ] = "u";
				keyBuf[ newKey + maxKey ] = "u";
				newKey = ( newKey + 1 ) % maxKey;

				change |= 1;
			}
		}

		but = self attackButtonPressed();
		if ( but != but2State )
		{
			but2State = but;
			if ( !but )
			{
				keyBuf[ newKey ] = "a";
				keyBuf[ newKey + maxKey ] = "a";
				newKey = ( newKey + 1 ) % maxKey;

				change |= 2;
			}
		}

		but = self meleeButtonPressed();
		if ( but != but3State )
		{
			but3State = but;
			if ( !but )
			{
				keyBuf[ newKey ] = "m";
				keyBuf[ newKey + maxKey ] = "m";
				newKey = ( newKey + 1 ) % maxKey;

				change |= 4;
			}
		}

		if ( !change )
		{
			counter += interval;
			if ( counter > 1.5 )
			{
				newKey = 0;
				chkKey = 0;
				counter = 0;
			}

			continue;
		}

		counter += interval;

		if ( chkKey > newKey )
			keyLen = maxKey + newKey - chkKey;
		else
			keyLen = newKey - chkKey;

		while ( keyLen >= codeLen )
		{
			s = "";
			for ( i = 0; i < codeLen; i++ )
				s += keyBuf[ chkKey + i ];

			skip = codeLen;
			switch ( s )
			{
				case "uuum":
					if ( self.pers[ "team" ] == "axis" )
					{
						if ( self.healthpacks > 0 )
						{
							self dropHealth();
							self.healthpacks--;
						}
						else
							self iprintln( "^2You're not carrying any health packs." );
					}
					break;
				case "mmmm":
					if ( self.pers[ "team" ] == "axis" )
					{
						if ( isDefined( self.powerup ) )
							self thread maps\mp\gametypes\_killstreaks::doPowerup();
						else
							self iPrintLn( "^2You don't have any powerups." );
					}
					break;
				case "umum":
					if ( self.pers[ "team" ] == "allies" )
					{
						if ( self.zombietype == "fire" )
							self thread firebomb();
						else if ( self.zombietype == "poison" )
							self thread poisonbomb();
					}
					break;
				default:
					skip = 1;
					break;
			}

			chkKey = ( chkKey + skip ) % maxKey;
			keyLen -= skip;
		}
	}
}

timeAlive()
{
	level endon( "intermission" );

	self endon( "death" );
	self endon( "spawn_spectator" );
	
	timecheck = 0;
	while ( true )
	{
		if ( timecheck == 10 ) {
			self.xp += level.xpvalues[ "TIMEALIVE" ];
			self.score += level.xpvalues[ "TIMEALIVE" ];
			self thread checkRank();
			timecheck = 0;
		}
		
		timecheck++;
		
		wait 1;
	}
}

shotsfired()
{
	level endon( "intermission" );
	
	waittime = 0.02;
	lastammo = 0;
	
	while ( isAlive( self ) )
	{
		wait ( waittime );
		
		primary = self getWeaponSlotWeapon( "primary" );
		secondary = self getWeaponSlotWeapon( "primaryb" );
		pistol = self getWeaponSlotWeapon( "pistol" );
		nade = self getWeaponSlotWeapon( "grenade" );
		current = self getCurrentWeapon();
		pressed = self attackButtonPressed();
		
		if ( current == primary && ( self getWeaponSlotClipAmmo( "primary" ) == 0 || self getWeaponSlotAmmo( "primary" ) == 0 ) ||
			 current == secondary && ( self getWeaponSlotClipAmmo( "primaryb" ) == 0 || self getWeaponSlotAmmo( "primaryb" ) == 0 ) ||
			 current == pistol && ( self getWeaponSlotClipAmmo( "pistol" ) == 0 || self getWeaponSlotAmmo( "pistol" ) == 0 ) ||
			 current == nade )
			continue;
			
		if ( self attackButtonPressed() )
		{
			self.shotsfired++;
			
			if ( current == "fg42_mp" || current == "fg42_semi_mp" )
			{
				waittime = 0.03;
				if ( current == "fg42_semi_mp" )
					waittime = 0.02;
				continue;
			}
			else 
				waittime = 0.02;
				
			wait ( getWeaponFireTime( current ) - 0.02 );
		}
			
		// for semi auto weapons
		if ( !isWeaponAuto( current ) )
		{
			while ( self attackButtonPressed() )
				wait 0.05;
		}
	}
}

getWeaponFireTime( weapon )
{
	switch ( weapon )
	{
		case "bar_mp": return 0.11;
		case "bar_slow_mp": return 0.17;
		case "colt_mp": 
		case "luger_mp": 
		case "m1carbine_mp": 
		case "m1garand_mp": 
		case "thompson_semi_mp": return 0.135;
		case "fg42_mp": return 0.03;
		case "fg42_semi_mp": return 0.02;
		case "kar98k_mp": 
		case "kar98k_sniper_mp": 
		case "mosin_nagant_mp": 
		case "springfield_mp": return 0.33;
		case "mosin_nagant_sniper_mp": return 0.5;		
		case "mp40_mp": 
		case "mp44_mp": return 0.12;
		case "mp44_semi_mp": 
		case "ppsh_semi_mp": return 0.13;
		case "panzerfast_mp": return 1;
		case "ppsh_mp": return 0.075;
		case "thompson_mp": return 0.0857;
		default:
			return 1;
	}
}

isWeaponAuto( weapon )
{
	switch ( weapon )
	{
		case "colt_mp":
		case "luger_mp":
		case "kar98k_mp":
		case "kar98k_sniper_mp":
		case "mosin_nagant_mp":
		case "mosin_nagant_sniper_mp":
		case "springfield_mp":
		case "m1garand_mp":
		case "m1carbine_mp":
			return false;
		default: return true;
	}
}

whatscooking()
{
	self endon( "death" );
	
	while ( isAlive( self ) && self.pers[ "team" ] == "axis" )
	{
		attack = self attackButtonPressed();
		currentweap = self getCurrentWeapon();
		
		if ( !isdefined( self.cooking ) && attack && ( currentweap == "stielhandgranate_mp" || currentweap == "rgd-33russianfrag_mp" ) && self getWeaponSlotClipAmmo( "grenade" ) > 0 )
			self thread cookgrenade();
			
		wait 0.05;
	}
}

cookgrenade()
{
	if( isdefined( self.cooking ) ) return;
	self.cooking = true;

	self endon( "death" );

	if( isdefined( self.cookbar ) )
	{
		self.cookbarbackground destroy();
		self.cookbar destroy();
		self.cookbartext destroy();
	}

	barsize = 288;
	bartime = 3.85;

	self.cookbarbackground = newClientHudElem( self );				
	self.cookbarbackground.alignX = "center";
	self.cookbarbackground.alignY = "middle";
	self.cookbarbackground.x = 320;
	self.cookbarbackground.y = 385;
	self.cookbarbackground.alpha = 0.5;
	self.cookbarbackground.color = ( 0,0,0 );
	self.cookbarbackground setShader( "white", ( barsize + 4 ), 12 );	
	self.cookbarbackground.sort = 100;	

	self.cookbar = newClientHudElem( self );				
	self.cookbar.alignX = "left";
	self.cookbar.alignY = "middle";
	self.cookbar.x = ( 320 - ( barsize / 2.0 ) );
	self.cookbar.y = 385;
	self.cookbar.color = ( 1,1,1 );
	self.cookbar.alpha = 0.7;
	self.cookbar setShader( "white", 0, 8 );
	self.cookbar scaleOverTime( bartime , barsize, 8 );
	self.cookbar.sort = 101;

	self.cookbartext = newClientHudElem( self );
	self.cookbartext.alignX = "center";
	self.cookbartext.alignY = "middle";
	self.cookbartext.x = 320;
	self.cookbartext.y = 384;
	self.cookbartext.fontscale = 0.8;
	self.cookbartext.color = ( .5,.5,.5 );
	self.cookbartext settext( &"Cooking grenade" );
	self.cookbartext.sort = 102;

	tickcounter = 0;
	self playlocalsound( "bomb_tick" );
	
	weap = self getCurrentWeapon();

	cooktime = 4 * 20 - 2;

	for( i = 0; i < cooktime; i++ )
	{
		color = (float)i/(float)cooktime;
		self.cookbar.color = ( 1, 1 - color, 1 - color );

		if( !self attackButtonPressed() || self getCurrentWeapon() != weap )
			break;
		else
		{
			tickcounter++;
			if ( tickcounter >=20 ) {
				self playlocalsound( "bomb_tick" );
				tickcounter = 0;
			}
			wait .05;
		}
		if( !isAlive( self ) || self.sessionstate != "playing" )
			break;
	}

	if( isdefined( self.cookbarbackground ) )
		self.cookbarbackground destroy();
	if( isdefined( self.cookbar ) )
		self.cookbar destroy();
	if( isdefined( self.cookbartext ) )
		self.cookbartext destroy();

	if ( i >= cooktime )
	{
		if ( weap == "rgd-33russianfrag_mp" )
		{
			self.cooking = undefined;
			return;
		}
		
		self setWeaponSlotWeapon( "grenade", "none" );
		wait 0.05;	

		self playsound( "grenade_explode_default" );
		playfxontag( level._effect["bombexplosion"], self, "Bip01 R Hand" );
		wait .05;

		self finishPlayerDamage( self, self, 500, 0, "MOD_GRENADE", weap, ( self.origin + (0,0,32) ), vectornormalize( self.origin - ( self.origin + (0,0,32) ) ), "none" );

		self.cooking = undefined;
		return;
	}

	self.cooking = undefined;
}

giveXP( sMeansOfDeath, player, assisters )
{
	xp = 0;

	if ( !self isOnGround() )
		xp += 10;
		
	if ( isDefined( level.xpvalues[ sMeansOfDeath ] ) )
		xp += level.xpvalues[ sMeansOfDeath ];

	if ( self.health < ( self.maxhealth * 0.25 ) )
		xp += 20;
		
	switch ( player.pers[ "weapon" ] )
	{
		case "enfield_mp":
		case "sten_mp":
		case "bren_mp":
		case "springfield_mp":
		case "colt_mp":
		case "mk1britishfrag_mp":
			xp += level.xpvalues[ player.pers[ "weapon" ] ];
			break;
	}
	
	if ( self.rocketattack )
		xp += 50;
		
	if ( self.armored )
		xp += 25;

	self.xp += xp;
	self.score += xp;
	self.points += level.pointvalues[ "KILL" ];
	self.pointscore += level.pointvalues[ "KILL" ];
	
	self thread checkRank();
	
	for ( i = 0; i < assisters.size; i++ )
	{
		if ( isDefined( assisters[ i ].ent ) && assisters[ i ].ent != self )
		{
			if ( getTime() - assisters[ i ].time < 7000 )
			{
				assisters[ i ].ent.xp += level.xpvalues[ "ASSISTS" ];
				assisters[ i ].ent.score += level.xpvalues[ "ASSISTS" ];
				assisters[ i ].ent.points += level.pointvalues[ "ASSISTS" ];
				assisters[ i ].ent.pointscore += level.pointvalues[ "ASSISTS" ];
				assisters[ i ].ent iPrintLn( "^3" + level.xpvalues[ "ASSISTS" ] + " XP!" );
				assisters[ i ].ent thread checkRank();
				assisters[ i ].ent.stats[ "assists" ]++;
			}
		}
	}
}

checkRank()
{
	currentrank = undefined;
	newrank = undefined;

	if ( self.pers[ "team" ] == "axis" )
	{
		currentrank = self.rank;
		rank = maps\mp\gametypes\_ranks::getRankByXP( "hunter", self.xp );
		newrank = rank.id;
	}

	if ( self.pers[ "team" ] == "allies" )
	{
		currentrank = self.zomrank;
		rank = maps\mp\gametypes\_ranks::getRankByXP( "zombie", self.zomxp );
		newrank = rank.id;
	}
	

	if ( ( isDefined( currentrank ) && isDefined( newrank ) ) && newrank != currentrank )
		self rankUp( newrank );
}

rankUp( newrank )
{
	if ( self.pers[ "team" ] == "axis" )
	{
		self.rank = newrank;
		rank = maps\mp\gametypes\_ranks::getRankByID( "hunter", newrank );
		
		ranktext = rank.rankString;
		hudtext = rank.rankName;

		if ( isDefined( self.hud[ "rank" ] ) ) {
			self.hud[ "rank" ] setText( ranktext );
		}
	}
	else if ( self.pers[ "team" ] == "allies" )
	{
		self.zomrank = newrank;
		rank = maps\mp\gametypes\_ranks::getRankByID( "zombie", newrank );
		
		ranktext = rank.rankString;
		hudtext = rank.rankName;

		if ( isDefined( self.hud[ "zombierank" ] ) ) {
			self.hud[ "zombierank" ] setText( ranktext );
		}
	}
	
	self iPrintLnBold( "You have been promoted to ^2" + hudtext + "^7!" );
	self playLocalSound( "explo_plant_no_tick" );
	
	if ( self.pers[ "team" ] == "axis" )
	{
		self.changeweapon = true;
		
		self iPrintLn( "^2You can change your weapon." );
		
		self thread maps\mp\gametypes\_ranks::giveHunterRankPerks();
		
		self.points += level.pointvalues[ "RANKUP" ];
	}
	
	if ( self.pers[ "team" ] == "allies" )
		self thread maps\mp\gametypes\_ranks::giveZomRankPerks();
}

killstreakShiz()
{
	streaktext = undefined;
	
	switch ( self.killstreak )
	{
		case 5:	streaktext = "^3 is on a killing spree with 5 kills!"; break;
		case 10: streaktext = "^3 is on a RAMPAGE with 10 kills!"; break;
		case 15: streaktext = "^3 is DOMINATING with 15 kills!"; break;
		case 20: streaktext = "^3 is UNSTOPPABLE with 20 kills!"; break;
		case 30: streaktext = "^3 is GODLIKE with 30 kills!"; break;
		case 40: streaktext = "^3 is OWNING with 40 kills!"; break;
		case 50: streaktext = "^3 is RAPING with 50 kills!"; break;
		case 60: streaktext = "^3 is ABSOLUTELY DESTROYING THE ZOMBIES with 60 kills!"; break;
		case 70: streaktext = "^3 is FUCKING INSANE with 70 kills!"; break;
		case 80: streaktext = "^3 is a MOTHER FUCKING BAD ASS with 80 kills!"; break;
		case 90: streaktext = "^3 is like JACKIE FUCKING CHAN with 90 kills!"; break;
		case 100: streaktext = "^3 is ALMOST AS AWESOME AS CHUCK NORRIS with 100 kills!"; break;
		case 125: streaktext = "^3 has ONE HUNDRED AND TWENTY FIVE FUCKING KILLS."; break;
		case 150: streaktext = "^3 HAS DESTROYED ALL HOPE with 150 kills."; break;
		case 200: streaktext = "^3 IS A GOD WITH 200 KILLS."; break;
		default: break;
	}
	
	if ( isDefined( streaktext ) )
		iPrintLn( self.name + streaktext );
	
	gavepowerup = false;
	
	self maps\mp\gametypes\_killstreaks::checkPowerup();
}

setupClasses()
{
	if ( self.pers[ "team" ] == "axis" ) {
		switch ( self.pers[ "weapon" ] ) {
			case "kar98k_mp":
			case "m1garand_mp":
				self setMoveSpeedScale( 1.15 );
				break;
			case "mp40_mp":
			case "thompson_mp":
				self setMoveSpeedScale( 1.3 );
				break;
			case "mp44_mp":
			case "bar_mp":
				self setMoveSpeedScale( 1.0 );
				break;
			case "kar98k_sniper_mp":
			case "springfield_mp":
				self setMoveSpeedScale( 1.05 );
				break;
			case "m1carbine_mp":
				self setMoveSpeedScale( 1.5 );
				break;
		}
		
	} else {
		switch ( self.pers[ "weapon" ] ) {
			case "enfield_mp":
				self.zombietype = "jumper";
				self setMoveSpeedScale( 1.15 );
				self thread superJump();
				break;
			case "sten_mp":
				self.zombietype = "fast";
				self setMoveSpeedScale( 1.75 );
				self thread fastZombie();
				break;
			case "bren_mp":
				self.zombietype = "poison";
				self setMoveSpeedScale( 1.0 );
				self thread poisonZombie();
				break;
			case "springfield_mp":
				self.zombietype = "fire";
				self setMoveSpeedScale( 1.15 );
				self thread fireZombie();
				break;
		}
	}
}

superJump()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "end_respawn" );
	
	self iPrintLn( "Zombie perk: ^2Super jump" );
	
	self.maxhealth = 800;
	self.health = self.maxhealth;
	
	wait 1;

    doublejumped = false;
    self.jumpblocked = false;
    airjumps = 0;
	while ( isAlive( self ) ) {
		if ( self useButtonPressed() && !self.jumpblocked ) 
        {
            if ( !self isOnGround() )
                airjumps++;
                
            if ( airjumps == 2 ) {
                airjumps = 0;
                self thread blockjump();
            }

			for ( i = 0; i < 2; i++ ) 
            {
				self.health += level.cvars[ "JUMPER_DAMAGE" ];
				self finishPlayerDamage(self, self, level.cvars[ "JUMPER_DAMAGE" ], 0, "MOD_PROJECTILE", "panzerfaust_mp", (self.origin + (0,0,-1)), vectornormalize(self.origin - (self.origin + (0,0,-1))), "none");
			}
			wait 1;
		}
		wait 0.05;
	}
}

blockjump() 
{
    self.jumpblocked = true;
    
    while ( isAlive( self ) && !self isOnGround() )
        wait 0.05;
        
    self.jumpblocked = false;
}

fastZombie()
{
	self iPrintLn( "Zombie perk: ^2Super speed/bash" );
	
	self.maxhealth = 500;
	self.health = self.maxhealth;
	self.missmines = true;
}

poisonZombie()
{
	self iPrintLn( "Zombie perk: ^2Poison" );
	
	self.maxhealth = 1000;
	self.health = self.maxhealth;
}

poisonbomb()
{
	if ( !self.poisonbombready )
	{
		self iPrintLn( "^1You cannot activate Poison Bomb at this time." );
		wait 1;
		return;
	}
	
	self thread poisonbombwait();
	
	self suicide();
	
	scriptedRadiusDamage( self.origin + ( 0, 0, 12 ), 386, level.cvars[ "BOMB_DAMAGE_MAX" ], level.cvars[ "BOMB_DAMAGE_MIN" ], self );
	earthquake( 0.5, 3, self.origin + ( 0, 0, 12 ), 386 );
	playFx( level._effect[ "aftermath" ], self.origin );
	thread playSoundInSpace( "explo_rock", self.origin + ( 0, 0, 12 ), 4 );

	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[ i ] != self && ( distance( self.origin, players[ i ].origin ) < 256 && players[ i ].pers[ "team" ] == "axis" && !players[ i ].ispoisoned && !players[ i ].immune ) )
		{
			trace = bullettrace( self.origin, players[ i ].origin + ( 0, 0, 16 ), false, undefined );
			trace2 = bullettrace( self.origin, players[ i ].origin + ( 0, 0, 40 ), false, undefined );
			trace3 = bullettrace( self.origin, players[ i ].origin + ( 0, 0, 60 ), false, undefined );
			if ( trace[ "fraction" ] != 1 && trace2[ "fraction" ] != 1 && trace3[ "fraction" ] != 1 )
				continue;
				
			players[ i ] thread bePoisoned( self );
		}
	}
}

poisonbombwait()
{
	self endon( "disconnect" );
	
	self.poisonbombready = false;
	wait ( level.cvars[ "BOMB_TIME" ] * 60 );
	self.poisonbombready = true;
}

bePoisoned( dude )
{
	if ( self.bodyarmor > 0 )
		return;

	if ( self.ispoisoned )
		return;

	self.ispoisoned = true;
		
	self.poisonhud = newClientHudElem( self );
	self.poisonhud.x = 0;
	self.poisonhud.y = 0;
	self.poisonhud setShader( "white", 640, 480 );
	self.poisonhud.color = ( 0, 1, 0 );
	self.poisonhud.alpha = 0.1;
	self.poisonhud.sort = 1;
	
	self iPrintLnBold( "You have been ^2poisoned^7!" );
	
	while ( isAlive( self ) )
	{
		oldhealth = self.health;
		
		dmg = (int)( 5 * dude.damagemult );
		
		self finishPlayerDamage( dude, dude, dmg, 0, "MOD_MELEE", "bren_mp", self.origin, ( 0, 0, 0 ), "none" );
		
		wait 2;
		
		if ( self.health > oldhealth )
			break;
	}
	
	if ( isDefined( self.poisonhud ) )
		self.poisonhud destroy();

	self.ispoisoned = false;
}

fireZombie()
{
	self endon( "disconnect" );
	self endon( "end_respawn" );
	
	self iPrintLn( "Zombie perk: ^2Fire" );
	
	self.maxhealth = 700;
	self.health = self.maxhealth;
	
	self thread firemonitor( self );
	
	self waittill( "death" );
	
	if ( self.firebombed )
		return;
	
	scriptedRadiusDamage( self.origin + ( 0, 0, 12 ), 192, 75, 20, self );
	earthquake( 0.25, 3, self.origin + ( 0, 0, 12 ), 192 );
	playFx( level._effect[ "zombieExplo" ], self.origin );
}

firebomb()
{
	if ( !self.firebombready )
	{
		self iPrintLn( "^1You cannot activate Fire Bomb at this time." );
		wait 1;
		return;
	}
		
	self.firebombed = true;
	
	self thread firebombwait();
	
	self suicide();
	
	scriptedRadiusDamage( self.origin + ( 0, 0, 12 ), 386, level.cvars[ "BOMB_DAMAGE_MAX" ], level.cvars[ "BOMB_DAMAGE_MIN" ], self );
	earthquake( 0.5, 3, self.origin + ( 0, 0, 12 ), 386 );
	playFx( level._effect[ "zombieExplo" ], self.origin );
	
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[ i ] != self && ( distance( self.origin, players[ i ].origin ) < 256 && players[ i ].pers[ "team" ] == "axis" && !players[ i ].onfire && !players[ i ].immune ) )
		{
			trace = bullettrace( self.origin, players[ i ].origin + ( 0, 0, 16 ), false, undefined );
			trace2 = bullettrace( self.origin, players[ i ].origin + ( 0, 0, 40 ), false, undefined );
			trace3 = bullettrace( self.origin, players[ i ].origin + ( 0, 0, 60 ), false, undefined );
			if ( trace[ "fraction" ] != 1 && trace2[ "fraction" ] != 1 && trace3[ "fraction" ] != 1 )
				continue;
				
			players[ i ] thread firemonitor( self );
		}
	}
}

firebombwait()
{
	self endon( "disconnect" );
	
	self.firebombready = false;
	wait ( level.cvars[ "BOMB_TIME" ] * 60 );
	self.firebombready = true;
}

firemonitor( dude )
{
	if ( self.bodyarmor > 0 )
		return;

	if ( self.onfire )
		return;
		
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "end_respawn" );
	self endon( "stopfire" );
	self endon( "spawn_spectator" );
	
	self.onfire = true;
	
	if ( self.pers[ "team" ] == "axis" )
		self thread firedeath( dude );
	
	while ( 1 )
	{
		playFx( level._effect[ "zombieFire" ], self.origin + ( 0, 0, 32 ) );
		
		players = getEntArray( "player", "classname" );
		for ( i = 0; i < players.size; i++ )
		{
			if ( players[ i ] != self && ( distance( self.origin, players[ i ].origin ) < 36 && !players[ i ].onfire && !players[ i ].immune ) )
				players[ i ] thread firemonitor( dude );
		}
		
		wait 0.2;
	}
}

firedeath( dude )
{
	self iPrintLnBold( "You are on ^1fire^7!" );
	
	while ( isAlive( self ) )
	{
		oldhealth = self.health;
		
		dmg = (int)( 3 * dude.damagemult );
		
		self finishPlayerDamage( dude, dude, dmg, 0, "MOD_MELEE", "springfield_mp", self.origin, ( 0, 0, 0 ), "none" );
		
		wait 1;
		
		if ( self.health > oldhealth )
			break;
	}
	
	self notify( "stopfire" );
	self.onfire = false;
}

cleanUpHud()
{
	self maps\mp\gametypes\_hud::cleanUpHud();
}

getLastHunterNadeAmmo()
{
	amount = 5;
	rank = maps\mp\gametypes\_ranks::getRankByID( "hunter", self.rank );
	if ( isDefined( rank ) && isDefined( rank.rankPerks ) )
		amount = rank.rankPerks.stickynades * 2;
		
	return amount;
}

getHunterNadeAmmo()
{
	amount = 1;
	rank = maps\mp\gametypes\_ranks::getRankByID( "hunter", self.rank );
	if ( isDefined( rank ) && isDefined( rank.rankPerks ) )
		amount = rank.rankPerks.stickynades;
		
	return amount;
}

getWeaponMaxWeaponAmmo( weapon )
{
	switch ( weapon )
	{
		case "kar98k_mp": 
		case "kar98k_sniper_mp": 
		case "springfield_mp": 
		case "mp40_mp": 
			return 192; break;
		case "mp44_mp": 
		case "thompson_mp": 
			return 180; break;
		case "m1garand_mp": 
			return 96; break;
		case "m1carbine_mp": 
			return 120; break;
		case "bar_mp": 
			return 120; break;
		case "luger_mp": 
			return 32; break;
		case "mosin_nagant_mp":
			return 250; break;
		case "ppsh_mp":
			return 756; break;
		case "mosin_nagant_sniper_mp":
			return 150; break;
		default: 
			return 0; break;
	}
}

getWeaponMaxClipAmmo( weapon )
{
	switch ( weapon )
	{
		case "kar98k_mp": 
		case "kar98k_sniper_mp": 
		case "springfield_mp": 
		case "mosin_nagant_mp":
			return 5; break;
		case "mp40_mp": 
			return 32; break;
		case "mp44_mp": 
		case "thompson_mp": 
			return 30; break;
		case "m1garand_mp": 
		case "luger_mp": 
			return 8; break;
		case "m1carbine_mp": 
			return 15; break;
		case "bar_mp": 
			return 20; break;
		case "ppsh_mp":
			return 63; break;
		case "mosin_nagant_sniper_mp":
			return 10; break;
		default:
			return 0; break;
	}
}

ammoLimiting()
{
	self setWeaponSlotClipAmmo( "primary", 0 );
	self setWeaponSlotClipAmmo( "pistol", 0 );
	
	primarymax = getWeaponMaxWeaponAmmo( self.pers[ "weapon" ] );
	pistolmax = getWeaponMaxWeaponAmmo( "luger_mp" );
	primaryclip = getWeaponMaxClipAmmo( self.pers[ "weapon" ] );
	pistolclip = getWeaponMaxClipAmmo( "luger_mp" );
	
	bonus = self getAmmoBonusForRank();
	
	addprimary = getWeaponMaxClipAmmo( self.pers[ "weapon" ] ) * bonus;
	addpistol = getWeaponMaxClipAmmo( "luger_mp" ) * bonus;
	
	self setWeaponSlotAmmo( "primary", primarymax + addprimary );
	self setWeaponSlotAmmo( "pistol", pistolmax + addpistol );
	
	if ( !level.gamestarted )
		self setWeaponSlotAmmo( "grenade", 0 );
	else
		self setWeaponSlotAmmo( "grenade", self getHunterNadeAmmo() );
}

getAmmoBonusForRank()
{
	bonus = 1;
	rank = maps\mp\gametypes\_ranks::getRankByID( "hunter", self.rank );
	if ( isDefined( rank ) && isDefined( rank.rankPerks ) )
		bonus = rank.rankPerks.ammobonus;
		
	return bonus;
}

stickynades()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "spawn_spectator" );
	
	while ( isAlive( self ) && self.sessionstate == "playing" )
	{
		wait 0.05;
		
		if ( self meleeButtonPressed() && ( self getCurrentWeapon() == "stielhandgranate_mp" || self getCurrentWeapon() == "rgd-33russianfrag_mp" ) )
			self checkStickyPlacement();
	}
}

checkStickyPlacement()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "spawn_spectator" );

	if ( isdefined( self.checkstickyplacement ) ) return;
	self.checkstickyplacement = true;
	
	if( !isdefined( self ) || !isAlive( self ) || self.sessionstate != "playing" )
	{
		self.checkstickyplacement = undefined;
		return;
	}

	while( isdefined( self ) && isAlive( self ) && self.sessionstate == "playing" && self meleeButtonPressed() )
		wait( 0.1 );
	
	if ( self.stickynades == 0 )
	{
		self iPrintLnBold( "You don't have any more Proximity Charges." );
		wait 2;
		self.checkstickyplacement = undefined;
		return;
	}
	
	if ( level.stickynades == 50 )
	{
		self iPrintLnBold( "Too many Proximity Charges have been placed." );
		wait 2;
		self.checkstickyplacement = undefined;
		return;
	}

	model = "xmodel/weapon_nebelhandgrenate";
	slot = "grenade";
	aOffset = ( 0,0,0 );

	iAmmo = self getWeaponSlotClipAmmo( slot );
	if ( !iAmmo )
	{
		self.checkstickyplacement = undefined;
		return;
	}

	offset = ( 0,0,60 );
	roll = 0;
	voffset = -1;
	trace = bullettrace( self.origin + ( 0, 0, 8 ), self.origin + ( 0, 0, -64 ), false, self );

	if ( trace[ "fraction" ] == 1 )
	{
		self.checkstickyplacement = undefined;
		return;
	}

	iAmmo--;
	if ( iAmmo )
		self setWeaponSlotClipAmmo( slot, iAmmo );
	else
	{
		self setWeaponSlotClipAmmo( slot, iAmmo );
		self setWeaponSlotWeapon( slot, "none" );
		newWeapon = self getWeaponSlotWeapon( "primary" );
		if ( newWeapon == "none" ) newWeapon = self getWeaponSlotWeapon( "primaryb" );
		if ( newWeapon == "none" ) newWeapon = self getWeaponSlotWeapon( "pistol" );
		if ( newWeapon != "none" ) self switchToWeapon( newWeapon );
	}	

	self.stickynades--;
	level.stickynades++;

	stickybomb = spawn( "script_model", trace[ "position" ] + ( 0, 0, voffset ) );
	stickybomb.angles = ( 0, 0, 0 );
	stickybomb setModel( model );
	
	stickybomb thread monitorSticky( self );

	self.checkstickyplacement = undefined;
	wait 1;
}

monitorSticky( owner )
{
	wait 0.15;
	
	owner playsound( "weap_fraggrenade_pin" );
	
	slowdown = false;
	explode = false;
	while ( !explode && isAlive( owner ) )
	{
		zombies = getPlayersOnTeam( "allies" );
		for ( i = 0; i < zombies.size; i++ )
		{
			if ( distance( zombies[ i ].origin, self.origin ) < 128 )
			{
				trace = bullettrace( self.origin + ( 0, 0, 1 ), zombies[ i ].origin + ( 0, 0, 1 ), false, undefined );
				if ( trace[ "fraction" ] == 1 && zombies[ i ].sessionteam == "allies" )
				{
					explode = true;
					if ( zombies[ i ].missmines )
						slowdown = true;
				}
			}
		}
		
		wait 0.05;
	}
	
	if ( isAlive( owner ) )
	{
		self movez( 8, 0.05 );
		self setModel( "xmodel/weapon_nebelhandgrenate" );
		wait 0.05;
		self playSound( "minefield_click" );
		wait 0.30;
		if ( slowdown )
			wait 0.30;
		self hide();
		
		if ( owner.pers[ "team" ] == "axis" )
		{
			self playsound( "grenade_explode_default" );
			playfx( level._effect[ "bombexplosion" ], self.origin + ( 0, 0, 8 ) );
			scriptedRadiusDamage( self.origin + ( 0, 0, 8 ), 192, 800, 20, owner, undefined );
			earthquake( 0.5, 3, self.origin + ( 0, 0, 8 ), 192 );
			wait 3;
			owner.stickynades++;
		}
	}
	
	level.stickynades--;
	self delete();
}

nameChange()
{
	self endon( "disconnect" );
	
	oldname = self.name;
	for ( ;; )
	{
		if ( self.name != oldname )
		{
			logprint( "N;" + oldname + " changed their name to " + self.name + ".\n" );
			oldname = self.name;
		}
		
		wait 1;
	}
}

bloodsplatter()
{
	self endon( "disconnect" );

	if ( !isDefined( self.bloodyscreen ) )
	{
		x = []; y = []; a = [];
		for ( i = 0; i < level.cvars[ "BLOOD_SPLATTER" ]; i++ ) {
			x[ i ] = randomInt( 496 );
			y[ i ] = randomInt( 336 );
			a[ i ] = randomInt( 80 );
 		}

		self.bloodyscreen = [];
		for ( i = 0; i < level.cvars[ "BLOOD_SPLATTER" ]; i++ ) {
			self.bloodyscreen[ i ] = newClientHudElem( self );
			self.bloodyscreen[ i ].alignX = "left";
			self.bloodyscreen[ i ].alignY = "top";
 			self.bloodyscreen[ i ].x = x[ i ];
 			self.bloodyscreen[ i ].y = y[ i ];
 			self.bloodyscreen[ i ].color = ( 1, 1, 1 );
 			self.bloodyscreen[ i ].alpha = 1;

 			shader = "gfx/impact/flesh_hit1.tga";
 			if ( randomInt( 100 ) > 50 )
 				shader = "gfx/impact/flesh_hit2.tga";

			self.bloodyscreen[ i ] setShader( shader, 96 + a[ i ], 96 + a[ i ] );
 		}

		wait 3;

		if ( !isDefined( self.bloodyscreen ) )
			return;

		for ( i = 0; i < level.cvars[ "BLOOD_SPLATTER" ]; i++ ) {
			self.bloodyscreen[ i ] fadeOverTime( 2 );
			self.bloodyscreen[ i ].alpha = 0;
		}

		wait 2;

		if ( isDefined( self.bloodyscreen ) ) {
			for ( i = 0; i < level.cvars[ "BLOOD_SPLATTER" ]; i++ ) {
				self.bloodyscreen[ i ] destroy();
			}

			self.bloodyscreen = undefined;
		}
	}
}

painsound()
{
	if ( isDefined( self.painsound ) )
		return;
		
	self.painsound = true;
	num = _randomInt( level.voices[ self.nationality ] ) + 1;
	scream = "generic_pain_" + self.nationality + "_" + num;
	self playSound( scream );
	wait 3;
	self.painsound = undefined;
}

setAllClientCvars( cvar, value )
{
	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ )
		players[ i ] setClientCvar( cvar, value );
}

fastMo( length )
{
	if ( length <= 1 )
		return;
	newlength = length - 1;
	
	for ( i = 1.0; i < 1.5; i += 0.05 )
	{
		setCvar( "timescale", i );
		setAllClientCvars( "timescale", i );
		wait 0.05;
	}
	
	setCvar( "timescale", 1.5 );
	setAllClientCvars( "timescale", 1.5 );
	
	wait ( newlength );
	
	for ( i = 0; i > 1.0; i -= 0.05 )
	{
		setCvar( "timescale", i );
		setAllClientCvars( "timescale", i );
		wait 0.05;
	}
	
	setCvar( "timescale", 1.0 );
	setAllClientCvars( "timescale", 1.0 );
}

slowMo( length )
{
	if ( length <= 1 )
		return;
	newlength = length - 1;
	
	for ( i = 1.0; i > 0.5; i -= 0.05 )
	{
		setCvar( "timescale", i );
		setAllClientCvars( "timescale", i );
		wait 0.05;
	}
	
	setCvar( "timescale", 0.5 );
	setAllClientCvars( "timescale", 0.5 );
	
	wait ( newlength );
	
	for ( i = 0.5; i < 1.0; i += 0.05 )
	{
		setCvar( "timescale", i );
		setAllClientCvars( "timescale", i );
		wait 0.05;
	}
	
	setCvar( "timescale", 1.0 );
	setAllClientCvars( "timescale", 1.0 );
}

thirdPerson( setting )
{
	if ( setting == "on" )
	{
		self.thirdperson = true;
		self setClientCvar( "cg_thirdperson", 1 );
	}
	else if ( setting == "off" )
	{
		self.thirdperson = false;
		self setClientCvar( "cg_thirdperson", 0 );
	}
}

FOVScale( value )
{
	self setClientCvar( "cg_fov", value );
}

toLower( str )
{
	return ( mapChar( str, "U-L" ) );
}

toUpper( str )
{
	return ( mapChar( str, "L-U" ) );
}

mapChar( str, conv )
{
	if ( !isdefined( str ) || ( str == "" ) )
		return ( "" );

	switch ( conv )
	{
	  case "U-L":	case "U-l":	case "u-L":	case "u-l":
		from = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		to   = "abcdefghijklmnopqrstuvwxyz";
		break;
	  case "L-U":	case "L-u":	case "l-U":	case "l-u":
		from = "abcdefghijklmnopqrstuvwxyz";
		to   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		break;
	  default:
	  	return ( str );
	}

	s = "";
	for ( i = 0; i < str.size; i++ )
	{
		ch = str[ i ];

		for ( j = 0; j < from.size; j++ )
			if ( ch == from[ j ] )
			{
				ch = to[ j ];
				break;
			}

		s += ch;
	}

	return ( s );
}

strreplacer( sString, sType ) {
    switch ( sType ) {
    	case "alphanumeric":
    		out = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890-=+_/*!@#$%^&*(){}[];'.~` ";
    		in = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890-=+_/*!@#$%^&*(){}[];'.~` ";
    		bIgnoreExtraChars = true;
    		break;
        case "lower":
            out = "abcdefghijklmnopqrstuvwxyz";
            in = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            bIgnoreExtraChars = false;
            break;
        case "upper":
            in = "abcdefghijklmnopqrstuvwxyz";
            out = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            bIgnoreExtraChars = false;
            break;
        case "numeric":
            in = "0123456789.-";
            out = "0123456789.-";
            bIgnoreExtraChars = true;
            break;
        case "vector":
            in = "0123456789.-,()";
            out = "0123456789.-,()";
            bIgnoreExtraChars = true;
            break;
        default:
            return sString;
            break;
    }
        
    sOut = "";
    for ( i = 0; i < sString.size; i++ ) {
        bFound = false;
        cChar = sString[ i ];
        for ( j = 0; j < in.size; j++ ) {
            if ( in[ j ] == cChar ) {
                sOut += out[ j ];
                bFound = true;
                break;
            }
        }
        
        if ( !bFound && !bIgnoreExtraChars )
            sOut += cChar;
    }
    
    return sOut;
}

monotone( str )
{
	if ( !isdefined( str ) || ( str == "" ) )
		return ( "" );

	_s = "";

	_colorCheck = false;
	for ( i = 0; i < str.size; i++ )
	{
		ch = str[ i ];
		if ( _colorCheck )
		{
			_colorCheck = false;

			switch ( ch )
			{
			  case "0":
			  case "1":
			  case "2":
			  case "3":
			  case "4":
			  case "5":
			  case "6":
			  case "7":
			  	break;
			  default:
			  	_s += ( "^" + ch );
			  	break;
			}
		}
		else
		if ( ch == "^" )
			_colorCheck = true;
		else
			_s += ch;
	}

	return ( _s );
}

cleanString( str, ignorespaces )
{
	if ( !isDefined( str ) || str == "" )
		return "";
		
	newstr = "";
	
	for ( i = 0; i < str.size; i++ )
	{
		ch = str[ i ];
		
		if ( isDefined( ignorespaces ) && ignorespaces && ch == " " )
			continue;
			
		if ( !isDigit( ch ) && !isChar( ch ) && !isSymbol( ch ) && ch != " " )
			continue;
			
		newstr += ch;
	}

	return newstr;
}

scriptedRadiusDamage( origin, range, maxdamage, mindamage, attacker, ignore )
{
	players = getEntArray( "player", "classname" );
	inrange = [];
	
	for ( i = 0; i < players.size; i++ )
	{
		if ( distance( origin, players[ i ].origin ) < range )
		{
			if ( isDefined( ignore ) && players[ i ] == ignore )
				continue;
				
			if ( players[ i ].sessionstate != "playing" )
				continue;
				
			inrange[ inrange.size ] = players[ i ];
		}
	}

	for ( i = 0; i < inrange.size; i++ )
	{
		damage = 0;
		
		dist = distance( origin, inrange[ i ].origin );
		
		dmult = ( range - dist ) / range;
		if ( dmult >= 1 ) dmult = 0.99;
		if ( dmult <= 0 ) dmult = 0.01;
			
		damage = maxdamage * dmult;

		trace = bullettrace( origin, inrange[ i ].origin + ( 0, 0, 16 ), false, undefined );
		trace2 = bullettrace( origin, inrange[ i ].origin + ( 0, 0, 40 ), false, undefined );
		trace3 = bullettrace( origin, inrange[ i ].origin + ( 0, 0, 60 ), false, undefined );
		if ( trace[ "fraction" ] != 1 && trace2[ "fraction" ] != 1 && trace3[ "fraction" ] != 1 )
			continue;
			
		hitloc = "torso_upper";
		if ( trace3[ "fraction" ] != 1 && trace2[ "fraction" ] == 1 )
			hitloc = "torso_lower";
		if ( trace3[ "fraction" ] != 1 && trace2[ "fraction" ] != 1 && trace[ "fraction" ] == 1 )
		{
			s = "left";
			if ( _randomInt( 100 ) > 50 )
				s = "right";
				
			hitloc = s + "_leg_upper";
		}
			
		inrange[ i ] thread maps\mp\gametypes\zombies::Callback_PlayerDamage( attacker, attacker, damage, 0, "MOD_GRENADE_SPLASH", "defaultweapon_mp", origin, vectornormalize( inrange[ i ].origin - origin ), hitloc );
	}
}

getPlayersOnTeam( team )
{
	players = getEntArray( "player", "classname" );

	if ( team == "hunters" ) team = "axis";
	if ( team == "zombies" ) team = "allies";
	
	guys = [];
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[ i ].pers[ "team" ] == team || team == "any" )
			guys[ guys.size ] = players[ i ];
	}
	
	return guys;
}

cleanScreen()
{
	for( i = 0; i < 5; i++ )
	{
		iPrintlnBold( " " );
	}
}

// aliases cause i can
getMost( what ) {
	return getBest( what );
}

getBest( what ) {
	if ( !isDefined( what ) ) 
		return undefined;

	val = 0;
	person = undefined;

	players = getEntArray( "player", "classname" );
	for ( i = 0; i < players.size; i++ ) {
		p = players[ i ];

		switch ( what ) {
			case "hunter":		if ( p.score >= val ) 					{ val = p.score; 				person = p; } break;
			case "zombie":		if ( p.deaths >= val )					{ val = p.deaths; 				person = p; } break;
			case "assists":		if ( p.stats[ "assists" ] >= val )		{ val = p.stats[ "assists" ]; 	person = p; } break;
			case "headshots":	if ( p.stats[ "headshots" ] >= val )	{ val = p.stats[ "headshots" ]; person = p; } break;
			case "kills":		if ( p.stats[ "kills" ] >= val )		{ val = p.stats[ "kills" ];		person = p; } break;
			case "bashes":		if ( p.stats[ "bashes" ] >= val )		{ val = p.stats[ "bashes" ]; 	person = p; } break;
			default:			break;
		}
	}

	return person;
}

deletePlacedEntity( sEntityType )
{
	eEntities = getentarray( sEntityType, "classname" );
	for ( i = 0; i < eEntities.size; i++ )
		eEntities[ i ] delete();
}

dropHealth()
{
	if ( isdefined( level.healthqueue[ level.healthqueuecurrent ] ) )
		level.healthqueue[ level.healthqueuecurrent ] delete();
	
	level.healthqueue[ level.healthqueuecurrent ] = spawn( "item_health", self.origin + ( 0, 0, 1 ) );
	level.healthqueue[ level.healthqueuecurrent ].angles = ( 0, randomint( 360 ), 0 );

	level.healthqueuecurrent++;
	
	if ( level.healthqueuecurrent >= 16 )
		level.healthqueuecurrent = 0;
}

getPlayerByID( iID )
{
	eGuy = undefined;
	ePlayers = getEntArray( "player", "classname" );
	for ( i = 0; i < ePlayers.size; i++ )
	{
		if ( !isPlayer( ePlayers[ i ] ) )
			continue;

		if ( ePlayers[ i ] getEntityNumber() == iID )
		{
			eGuy = ePlayers[ i ];
			break;
		}
	}
			
	return eGuy;
}

isChar( cChar )
{
	bIsChar = false;
	
	switch ( toLower( cChar ) )
	{
		case "a":	case "b":	case "c":
		case "d":	case "e":	case "f":
		case "g":	case "h":	case "i":
		case "j":	case "k":	case "l":
		case "m":	case "n":	case "o":
		case "p":	case "q":	case "r":
		case "s":	case "t":	case "u":
		case "v":	case "w":	case "x":
		case "y":	case "z":
			bIsChar = true;
			break;
		default:
			break;
	}
	
	return bIsChar;
}

isDigit( cDigit )
{
	bIsDigit = false;
	switch ( cDigit )
	{
		case "0":	case "1":	case "2":
		case "3":	case "4": 	case "5":
		case "6": 	case "7": 	case "8":
		case "9":
			bIsDigit = true;
			break;
		default:
			break;
	}
	
	return bIsDigit;
}

isSymbol( cChar )
{
	bIsSymbol = false;
	switch ( cChar )
	{
		case "-":	case ">":	case "<":
		case "(":	case ")":	case "!":
		case "@":	case "#":	case "$":
		case "%":	case "&":	case "*":
		case "[":	case "]":	case "{":
		case "}":	case ":":	case ".":
		case "?":	case "^":	case "+":
		case "/":	case "~":	case "`":
		case ";":	
			bIsSymbol = true;
			break;
		default:
			break;
	}
	
	return bIsSymbol;
}

explode( s, delimiter )
{
	j = 0;
	temparr[ j ] = "";	

	for ( i = 0; i < s.size; i++ )
	{
		if ( s[ i ] == delimiter )
		{
			j++;
			temparr[ j ] = "";
		}
		else
			temparr[ j ] += s[i];
	}
	return temparr;
}

strip(s) {
	if(!isDefined(s) || s == "")
		return "";

	s2 = "";
	s3 = "";

	i = 0;
	while(i < s.size && s[i] == " ")
		i++;

	if(i == s.size)
		return "";
	
	for(; i < s.size; i++) {
		s2 += s[i];
	}

	i = s2.size-1;
	while(s2[i] == " " && i > 0)
		i--;

	for(j = 0; j <= i; j++) {
		s3 += s2[j];
	}
		
	return s3;
}

getNumberedName( str, ignorespaces )
{
	if ( !isDefined( str ) || str == "" )
		return "";
		
	int = 0;
	colors = 0;
	symbols = 0;
	
	for ( i = 0; i < str.size; i++ )
	{
		ch = str[ i ];
		
		if ( isDefined( ignorespaces ) && ignorespaces && ch == " " )
			continue;
			
		if ( !isDigit( ch ) && !isChar( ch ) && !isSymbol( ch ) )
			continue;
			
		if ( ch == "^" )
			colors++;
			
		if ( isSymbol( ch ) && ch != "^" )
			symbols++;
			
		int += charToDigit( ch );
	}
	
	if ( str.size % 2 == 0 )
		int += str.size;
	else
		int -= str.size;
		
	int += ( colors * 10 );
	int += ( symbols * 30 );
	
	return int;
}

charToDigit( ch )
{
	switch ( ch )
	{
		case "a":	return 100; break;	case "b":	return 101; break;
		case "c":	return 102; break;	case "d":	return 103; break;
		case "e":	return 104; break;	case "f":	return 105; break;
		case "g":	return 106; break;	case "h":	return 107; break;
		case "i":	return 108; break;	case "j":	return 109; break;
		case "k":	return 110; break;	case "l":	return 111; break;
		case "m":	return 112; break;	case "n":	return 113; break;
		case "o":	return 114; break;	case "p":	return 115; break;
		case "q":	return 116; break;	case "r":	return 117; break;
		case "s":	return 118; break;	case "t":	return 119; break;
		case "u":	return 120; break;	case "v":	return 121; break;
		case "w":	return 122; break;	case "x":	return 123; break;
		case "y":	return 124; break;	case "z":	return 125; break;
		case "0":	return 126; break;	case "1":	return 127; break;
		case "2":	return 128; break;	case "3":	return 129; break;
		case "4":	return 130; break;	case "5":	return 131; break;
		case "6":	return 132; break;	case "7":	return 133; break;
		case "8":	return 134; break;	case "9":	return 135; break;
		case "-":	return 136; break; 	case ">":	return 137; break;
		case "<":	return 138; break; 	case "(":	return 139; break; 	
		case ")":	return 140; break; 	case "!":	return 141; break; 	
		case "@":	return 142; break; 	case "#":	return 143; break; 	
		case "$":	return 144; break; 	case "%":	return 145; break; 	
		case "&":	return 146; break; 	case "*":	return 147; break; 	
		case "[":	return 148; break; 	case "]":	return 149; break; 	
		case "{":	return 150; break; 	case "}":	return 151; break; 	
		case ":":	return 152; break; 	case ".":	return 153; break; 	
		case "?":	return 154; break; 	case "^":	return 155; break;
		case "A":	return 156; break;	case "B":	return 156; break;
		case "C":	return 157; break;	case "D":	return 158; break;
		case "E":	return 159; break;	case "F": 	return 160; break;
		case "G":	return 161; break;	case "H":	return 162; break;
		case "I":	return 163; break;	case "J":	return 164; break;
		case "K":	return 165; break;	case "L":	return 166; break;
		case "M":	return 167; break;	case "N":	return 168; break;
		case "O":	return 169; break;	case "P":	return 170; break;
		case "Q":	return 171; break;	case "R":	return 172; break;
		case "S":	return 173; break;	case "T":	return 174; break;
		case "U":	return 175; break;	case "V":	return 176; break;
		case "W":	return 177; break;	case "X":	return 178; break;
		case "Y":	return 179; break;	case "Z":	return 180; break;
		case "/":	return 181; break; 	case "+":	return 182; break;
		case "~":	return 182; break;	case "`":	return 183; break;
	}
}

playSoundInSpace( sAlias, vOrigin, iTime )
{
	oOrg = spawn( "script_model", vOrigin );
	wait 0.05;
	oOrg playSound( sAlias );
	
	wait ( iTime );
	
	oOrg delete();
}

getMapWeather()
{
	sMapName = toLower( getCvar( "mapname" ) );
	
	switch ( sMapName )
	{
		case "mp_harbor":
		case "mp_pavlov":
		case "mp_hurtgen":
		case "mp_rocket":
		case "mp_railyard":
		case "mp_stalingrad":
			return "winter"; break;
	}
	
	return "normal";
}

setPlayerModel()
{
	self maps\mp\gametypes\_skins::main();
}

fadeIn( time, image )
{
	self setShader( image, 32, 32 );
	self fadeOverTime( time );
	self.alpha = 1;
}

fadeOut( time )
{
	self fadeOverTime( time );
	self.alpha = 0;
}

getHitLoc( sHitloc )
{
	switch ( sHitloc )
	{
		case "none": return "^3places that don't exist"; break;
		case "head": return "^7the ^3head"; break;
		case "helmet": return "^7the ^3helmet"; break;
		case "neck": return "^7the ^3neck"; break;
		case "torso_upper": return "^7the ^3chest"; break;
		case "torso_lower": return "^7the ^3stomach"; break;
		case "right_arm_lower":
		case "right_arm_upper": 
			return "^7the ^3right arm"; break;
		case "left_arm_lower":
		case "left_arm_upper":
			return "^7the ^3left arm"; break;
		case "right_hand": return "^7the ^3right hand"; break;
		case "left_hand": return "^7the ^3left hand"; break;
		case "right_leg_upper": return "^7the ^3right thigh"; break;
		case "right_leg_lower": return "^7the ^3right shin"; break;
		case "left_leg_upper": return "^7the ^3left thigh"; break;
		case "left_leg_lower": return "^7the ^3left shin"; break;
		case "right_foot": return "^7the ^3right foot"; break;
		case "left_foot": return "^7the ^3left foot"; break;
		default:
			return sHitloc; break;
	}
}

_randomInt( iMax )
{
	oArray = [];
	
	for ( i = 0; i < 100; i++ ) 
		oArray[ i ] = randomInt( iMax );
	
	for ( k = 0; k < 50; k++ )
	{
		for ( i = 0; i < oArray.size; i++ )
		{
			j = randomInt( oArray.size );
			oElem = oArray[ i ];
			oArray[ i ] = oArray[ j ];
			oArray[ j ] = oElem;
		}
	}
	
	return oArray[ randomInt( oArray.size ) ];
}

showPos()
{
	while ( isAlive( self ) )
	{
		if ( self meleebuttonpressed() )
		{
			self iprintln( "^5(^7" + self.origin[ 0 ] + ", " + self.origin[ 1 ] + ", " + self.origin[ 2 ] + "^5)^7 " + self.angles[ 1 ] );
			wait 1;
		}
		
		wait 0.05;
	}
}