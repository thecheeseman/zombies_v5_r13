init()
{
	[[ level.logwrite ]]( "maps\\mp\\gametypes\\_ranks.gsc::init()", true );
	
	level.hunterRanks = [];
	level.zombieRanks = [];

	// addHunterRank( <rankName>, <rankString>, <startXP>, <endXP> )
	addHunterRank( "Enlisted", &"Enlisted", 0, 50 );
	addHunterRank( "Private", &"Private", 50, 100 );
	addHunterRank( "Private First Class", &"Private First Class", 100, 250 );
	addHunterRank( "Specialist", &"Specialist", 250, 500 );
	addHunterRank( "Sergeant", &"Sergeant", 500, 750 );
	addHunterRank( "Sergeant Major", &"Sergeant Major", 750, 1000 );
	addHunterRank( "2nd Lieutenant", &"2nd Lieutenant", 1000, 1500 );
	addHunterRank( "1st Lieutenant", &"1st Lieutenant", 1500, 2000 );
	addHunterRank( "Captain", &"Captain", 2000, 2500 );
	addHunterRank( "Major", &"Major", 2500, 3500 );
	addHunterRank( "Lieutenant Colonel", &"Lieutenant Colonel", 3500, 5000 );
	addHunterRank( "Colonel", &"Colonel", 5000, 7500 );
	addHunterRank( "Brigadier General", &"Brigadier General", 7500, 10000 );
	addHunterRank( "Major General", &"Major General", 10000, 15000 );
	addHunterRank( "Lieutenant General I", &"Lieutenant General I", 15000, 20000 );
	addHunterRank( "Lieutenant General II", &"Lieutenant General II", 20000, 25000 );
	addHunterRank( "General I", &"General I", 25000, 35000 );
	addHunterRank( "General II", &"General II", 35000, 50000 );
	addHunterRank( "General of the Army I", &"General of the Army I", 50000, 75000 );
	addHunterRank( "General of the Army II", &"General of the Army II", 75000, 100000 );
	addHunterRank( "Demi-god I", &"Demi-god I", 100000, 200000 );
	addHunterRank( "Demi-god II", &"Demi-god II", 200000, 300000 );
	addHunterRank( "Demi-god III", &"Demi-god III", 300000, 400000 );
	addHunterRank( "Demi-god IV", &"Demi-god IV", 400000, 500000 );
	addHunterRank( "God I", &"God I", 500000, 600000 );
	addHunterRank( "God II", &"God II", 600000, 700000 );
	addHunterRank( "God III", &"God III", 700000, 850000 );
	addHunterRank( "God IV", &"God IV", 850000, 1000000 );
	addHunterRank( "NOT CHUCK NORRIS I", &"NOT CHUCK NORRIS I", 1000000, 1500000 );
	addHunterRank( "NOT CHUCK NORRIS II", &"NOT CHUCK NORRIS II", 1500000, 2000000 );
	addHunterRank( "NOT CHUCK NORRIS III", &"NOT CHUCK NORRIS III", 2000000, 3000000 );
	addHunterRank( "NOT CHUCK NORRIS IV", &"NOT CHUCK NORRIS IV", 3000000, 4000000 );
	addHunterRank( "NOT CHUCK NORRIS V", &"NOT CHUCK NORRIS V", 4000000, 5000000 );
	addHunterRank( "FUUUUU!!1 I", &"FUUUUU!!1 I", 5000000, 6000000 );
	addHunterRank( "FUUUUU!!1 II", &"FUUUUU!!1 II", 6000000, 7000000 );
	addHunterRank( "FUUUUU!!1 III", &"FUUUUU!!1 III", 7000000, 8000000 );
	addHunterRank( "FUUUUU!!1 IV", &"FUUUUU!!1 IV", 8000000, 9000000 );
	addHunterRank( "FUUUUU!!1 V", &"FUUUUU!!1 V", 9000000, 10000000 );
	addHunterRank( "No-life I", &"No-life I", 10000000, 12500000 );
	addHunterRank( "No-life II", &"No-life II", 12500000, 15000000 );
	addHunterRank( "No-life III", &"No-life III", 15000000, 17500000 );
	addHunterRank( "No-life IV", &"No-life IV", 17500000, 20000000 );
	addHunterRank( "Good luck getting to 50mil", &"Good luck getting to 50mil", 20000000, 50000000 );
	addHunterRank( "Son of a...", &"Son of a...", 50000000, 100000000 );
	addHunterRank( "Just stop playing", &"Just stop playing", 100000000, 500000000 );
	addHunterRank( "Srsly, wtf mang", &"Srsly, wtf mang", 500000000, 1000000000 );
	addHunterRank( "RANK HACKER KURWA NAP", &"RANK HACKER KURWA NAP", 1000000000, 9999999999 );
	
	// addHunterRankPerks( <rankName>, <newhealth>, <stickynades>, <healthpacks>, <bodyarmor>, <exploarmor>, <immunitylevel> )
	addHunterRankPerks( "Enlisted", 100, 1, 1, 50, 50, 0, 0 );
	addHunterRankPerkCopy( "Private", "Enlisted" );
	addHunterRankPerkCopy( "Private First Class", "Enlisted" );
	addHunterRankPerkCopy( "Specialist", "Enlisted" );
	addHunterRankPerks( "Sergeant", 125, 1, 1, 50, 50, 0, 1 );
	addHunterRankPerkCopy( "Sergeant Major", "Sergeant" );
	addHunterRankPerks( "1st Lieutenant", 125, 2, 1, 0, 0, 0, 2 );
	addHunterRankPerkCopy( "2nd Lieutenant", "1st Lieutenant" );
	addHunterRankPerks( "Captain", 150, 2, 2, 0, 0, 0, 3 );
	addHunterRankPerkCopy( "Major", "Captain" );
	addHunterRankPerks( "Lieutenant Colonel", 175, 3, 2, 0, 0, 0, 3 );
	addHunterRankPerks( "Colonel", 175, 3, 2, 0, 0, 0, 4 );
	addHunterRankPerks( "Brigadier General", 200, 3, 2, 0, 0, 0, 4 );
	addHunterRankPerks( "Major General", 225, 3, 2, 0, 0, 0, 4 );
	addHunterRankPerks( "Lieutenant General I", 250, 3, 3, 0, 0, 0, 5 );
	addHunterRankPerks( "Lieutenant General II", 250, 3, 3, 0, 0, 0, 5 );
	addHunterRankPerks( "General I", 275, 3, 3, 0, 0, 0, 6 );
	addHunterRankPerks( "General II", 275, 3, 3, 0, 0, 0, 6 );
	addHunterRankPerks( "General of the Army I", 275, 4, 3, 0, 0, 0, 7 );
	addHunterRankPerks( "General of the Army II", 275, 4, 3, 0, 0, 0, 7 );
	addHunterRankPerks( "Demi-god I", 300, 4, 4, 0, 0, 1, 8 );
	addHunterRankPerks( "Demi-god II", 300, 5, 4, 0, 0, 1, 8 );
	addHunterRankPerks( "Demi-god III", 325, 5, 5, 0, 0, 2, 8 );
	addHunterRankPerks( "Demi-god IV", 325, 6, 5, 0, 0, 2, 8 );
	addHunterRankPerks( "God I", 350, 6, 6, 0, 0, 3, 9 );
	addHunterRankPerks( "God II", 350, 7, 6, 0, 0, 3, 9 );
	addHunterRankPerks( "God III", 375, 7, 7, 0, 0, 4, 9 );
	addHunterRankPerks( "God IV", 375, 8, 7, 0, 0, 4, 9 );
	addHunterRankPerks( "NOT CHUCK NORRIS I", 400, 8, 8, 0, 0, 5, 10 );
	addHunterRankPerks( "NOT CHUCK NORRIS II", 425, 9, 9, 0, 0, 5, 10 );
	addHunterRankPerks( "NOT CHUCK NORRIS III", 450, 10, 10, 0, 0, 5, 10 );
	addHunterRankPerks( "NOT CHUCK NORRIS IV", 475, 11, 11, 0, 0, 5, 10 );
	addHunterRankPerks( "NOT CHUCK NORRIS V", 500, 12, 12, 0, 0, 5, 10 );
	addHunterRankPerks( "FUUUUU!!1 I", 525, 13, 13, 0, 0, 5, 12 );
	addHunterRankPerks( "FUUUUU!!1 II", 550, 14, 14, 0, 0, 5, 12 );
	addHunterRankPerks( "FUUUUU!!1 III", 550, 15, 15, 0, 0, 5, 12 );
	addHunterRankPerks( "FUUUUU!!1 IV", 550, 17, 17, 0, 0, 5, 12 );
	addHunterRankPerks( "FUUUUU!!1 V", 550, 20, 20, 0, 0, 5, 12 );
	addHunterRankPerks( "No-life I", 550, 25, 25, 0, 0, 5, 15 );
	addHunterRankPerks( "No-life II", 550, 30, 30, 0, 0, 5, 15 );
	addHunterRankPerks( "No-life III", 550, 35, 35, 0, 0, 5, 15 );
	addHunterRankPerks( "No-life IV", 550, 40, 40, 0, 0, 5, 15 );
	addHunterRankPerks( "No-life V", 550, 45, 45, 0, 0, 5, 15 );
	addHunterRankPerks( "Good luck getting to 50mil", 550, 50, 50, 0, 0, 5, 50 );
	addHunterRankPerks( "Son of a...", 550, 75, 75, 0, 0, 5, 100 );
	addHunterRankPerks( "Just stop playing", 550, 100, 100, 0, 0, 5, 100 );
	addHunterRankPerks( "Srsly, wtf mang", 550, 200, 200, 0, 0, 5, 100 );
	addHunterRankPerks( "RANK HACKER KURWA NAP", 100, 0, 0, 0, 0, 0, 1 );

	// addZombieRank( <rankName>, <rankString>, <startXP>, <endXP )
	addZombieRank( "Innocent", &"Innocent", 0, 5 );
	addZombieRank( "Harmless", &"Harmless", 5, 10 );
	addZombieRank( "Menacing", &"Menacing", 10, 15 );
	addZombieRank( "Noxious", &"Noxious", 15, 20 );
	addZombieRank( "Malignant", &"Malignant", 20, 25 );
	addZombieRank( "Damaging", &"Damaging", 25, 30 );
	addZombieRank( "Sinister", &"Sinister", 30, 40 );
	addZombieRank( "Toxic", &"Toxic", 40, 50 );
	addZombieRank( "Crippling", &"Crippling", 50, 60 );
	addZombieRank( "Corroding", &"Corroding", 60, 75 );
	addZombieRank( "Ominous", &"Ominous", 75, 100 );
	addZombieRank( "Calamitous", &"Calamitous", 100, 125 );
	addZombieRank( "Ranksacker", &"Ranksacker", 125, 150 );
	addZombieRank( "Bomber", &"Bomber", 150, 175 );
	addZombieRank( "Cancer", &"Cancer", 175, 200 );
	addZombieRank( "Demolisher", &"Demolisher", 200, 250 );
	addZombieRank( "Vandal", &"Vandal", 250, 300 );
	addZombieRank( "Eradicator", &"Eradicator", 300, 350 );
	addZombieRank( "Savage", &"Savage", 350, 400 );
	addZombieRank( "Exterminator", &"Exterminator", 400, 450 );
	addZombieRank( "Slaughterer", &"Slaughterer", 450, 500 );
	addZombieRank( "Radiator", &"Radiator", 500, 600 );
	addZombieRank( "Butcher", &"Butcher", 600, 750 );
	addZombieRank( "Guerilla", &"Guerilla", 750, 1000 );
	addZombieRank( "Annihilator", &"Annihilator", 1000, 1250 );
	addZombieRank( "Liquidator", &"Liquidator", 1250, 1500 );
	addZombieRank( "Slayer", &"Slayer", 1500, 1750 );
	addZombieRank( "Hunter", &"Hunter", 1750, 2000 );
	addZombieRank( "Cannibal", &"Cannibal", 2000, 2250 );
	addZombieRank( "Ruthless", &"Ruthless", 2250, 2500 );
	addZombieRank( "Fuckin' Lethal", &"Fuckin' Lethal", 2500, 2750 );
	addZombieRank( "Unrelenting", &"Unrelenting", 2750, 3000 );
	addZombieRank( "Reaper", &"Reaper", 3000, 3250 );
	addZombieRank( "Evil", &"Evil", 3250, 3500 );
	addZombieRank( "Malefic", &"Malefic", 3500, 3750 );
	addZombieRank( "Devastating", &"Devastating", 3750, 4000 );
	addZombieRank( "Desecrator", &"Desecrator", 4000, 4250 );
	addZombieRank( "Smasher", &"Smasher", 4250, 4500 );
	addZombieRank( "Wrecker", &"Wrecker", 4500, 5000 );
	addZombieRank( "Extinguisher", &"Extinguisher", 5000, 550 );
	addZombieRank( "Decimator", &"Decimator", 5500, 6000 );
	addZombieRank( "Obliterator", &"Obliterator", 6000, 7000 );
	addZombieRank( "Depriver", &"Depriver", 7000, 8000 );
	addZombieRank( "Plunderer", &"Plunderer", 8000, 9000 );
	addZombieRank( "Marauder", &"Marauder", 9000, 10000 );
	addZombieRank( "Tormentor", &"Tormentor", 10000, 25000 );
	addZombieRank( "1337", &"1337", 25000, 50000 );
	addZombieRank( "Godly", &"Godly", 50000, 75000 );
	addZombieRank( "Monster", &"Monster", 75000, 100000 );
	addZombieRank( "FUCKING BRUCE LEE", &"FUCKING BRUCE LEE", 100000, 9999999999 );
	
	// addZombieRankPerks( <rankName>, <newhealth>, <damagemult>, <resilience>, <zomnadeammo> )
	addZombieRankPerks( "Innocent", 0, 1.1, 0.05, 2 );
	addZombieRankPerks( "Harmless", 0, 1.1, 0.05, 2 );
	addzombieRankPerks( "Menacing", 25, 1.1, 0.05, 3 );
	addzombieRankPerks( "Noxious", 25, 1.1, 0.05, 3 );
	addzombieRankPerks( "Malignant", 25, 1.1, 0.05, 3 );
	addzombieRankPerks( "Damaging", 25, 1.1, 0.05, 3 );
	addzombieRankPerks( "Sinister", 25, 1.1, 0.05, 3 );
	addzombieRankPerks( "Toxic", 25, 1.1, 0.05, 3 );
	addzombieRankPerks( "Crippling", 50, 1.1, 0.1, 4 );
	addzombieRankPerks( "Corroding", 75, 1.1, 0.1, 4 );
	addzombieRankPerks( "Ominous", 75, 1.1, 0.1, 4 );
	addzombieRankPerks( "Calamitous", 100, 1.1, 0.1, 5 );
	addzombieRankPerks( "Ranksacker", 100, 1.1, 0.1, 5 );
	addzombieRankPerks( "Bomber", 100, 1.1, 0.15, 5 );
	addzombieRankPerks( "Cancer", 100, 1.1, 0.15, 5 );
	addzombieRankPerks( "Demolisher", 150, 1.2, 0.15, 6 );
	addzombieRankPerks( "Vandal", 150, 1.2, 0.15, 6 );
	addzombieRankPerks( "Eradicator", 150, 1.2, 0.15, 6 );
	addzombieRankPerks( "Savage", 150, 1.2, 0.15, 6 );
	addzombieRankPerks( "Exterminator", 150, 1.2, 0.15, 6 );
	addzombieRankPerks( "Slaughterer", 150, 1.2, 0.15, 6 );
	addzombieRankPerks( "Radiator", 200, 1.3, 0.2, 7 );
	addzombieRankPerks( "Butcher", 200, 1.3, 0.2, 7 );
	addzombieRankPerks( "Guerilla", 200, 1.4, 0.25, 8 );
	addzombieRankPerks( "Annihilator", 300, 1.4, 0.25, 8 );
	addzombieRankPerks( "Liquidator", 300, 1.5, 0.25, 8 );
	addzombieRankPerks( "Slayer", 300, 1.5, 0.25, 8 );
	addzombieRankPerks( "Hunter", 300, 1.5, 0.3, 9 );
	addzombieRankPerks( "Cannibal", 400, 1.5, 0.3, 9 );
	addzombieRankPerks( "Ruthless", 400, 1.5, 0.3, 9 );
	addzombieRankPerks( "Fuckin' Lethal", 400, 1.6, 0.4, 10 );
	addzombieRankPerks( "Unrelenting", 400, 1.6, 0.4, 10 );
	addzombieRankPerks( "Reaper", 400, 1.6, 0.45, 12 );
	addzombieRankPerks( "Evil", 400, 1.7, 0.45, 12 );
	addzombieRankPerks( "Malefic", 500, 1.7, 0.5, 15 );
	addzombieRankPerks( "Devastating", 500, 1.7, 0.5, 15 );
	addzombieRankPerks( "Desecrator", 500, 1.8, 0.5, 15 );
	addzombieRankPerks( "Smasher", 500, 1.8, 0.5, 15 );
	addzombieRankPerks( "Wrecker", 500, 1.8, 0.5, 15 );
	addzombieRankPerks( "Extinguisher", 600, 1.9, 0.5, 15 );
	addzombieRankPerks( "Decimator", 600, 1.9, 0.5, 15 );
	addzombieRankPerks( "Obliterator", 700, 2.0, 0.5, 15 );
	addzombieRankPerks( "Depriver", 700, 2.0, 0.5, 15 );
	addzombieRankPerks( "Plunderer", 800, 2.0, 0.5, 15 );
	addzombieRankPerks( "Marauder", 900, 2.0, 0.5, 15 );
	addzombieRankPerks( "Tormentor", 1000, 2.5, 0.5, 15 );
	addzombieRankPerks( "1337", 1000, 2.5, 0.5, 15 );
	addzombieRankPerks( "Godly", 1000, 2.5, 0.5, 15 );
	addzombieRankPerks( "Monster", 1000, 2.5, 0.5, 15 );
	addzombieRankPerks( "FUCKING BRUCE LEE", 1000, 3, 0.5, 15 );
}

addHunterRank( rankName, rankString, startXP, endXP, perkFunction )
{
	precacheString( rankString );
	
	id = level.hunterRanks.size;
	level.hunterRanks[ id ] = spawnstruct();
	level.hunterRanks[ id ].id = id;
	level.hunterRanks[ id ].rankName = rankName;
	level.hunterRanks[ id ].rankString = rankString;
	level.hunterRanks[ id ].startXP = startXP;
	level.hunterRanks[ id ].endXP = endXP;
	
	if ( isDefined( perkFunction ) )
		level.hunterRanks[ id ].perkFunction = perkFunction;
}

addZombieRank( rankName, rankString, startXP, endXP, perkFunction )
{
	precacheString( rankString );
	
	id = level.zombieRanks.size;
	level.zombieRanks[ id ] = spawnstruct();
	level.zombieRanks[ id ].id = id;
	level.zombieRanks[ id ].rankName = rankName;
	level.zombieRanks[ id ].rankString = rankString;
	level.zombieRanks[ id ].startXP = startXP;
	level.zombieRanks[ id ].endXP = endXP;
	
	if ( isDefined( perkFunction ) )
		level.hunterRanks[ id ].perkFunction = perkFunction;
}

addHunterRankPerks( rankName, health, stickynades, healthpacks, bodyarmor, exploarmor, immunitylevel, ammobonus )
{
	perks = spawnstruct();
	perks.health = health;
	perks.stickynades = stickynades;
	perks.healthpacks = healthpacks;
	perks.bodyarmor = bodyarmor;
	perks.exploarmor = exploarmor;
	perks.immunitylevel = immunitylevel;
	perks.ammobonus = ammobonus;
	
	rank = getRankByName( "hunter", rankName );
	if ( isDefined( rank ) )
		level.hunterRanks[ rank.id ].rankPerks = perks;
}

addHunterRankPerkCopy( rankName, copy )
{
	copy = getRankByName( "hunter", copy );
	rank = getRankByName( "hunter", rankName );
	if ( isDefined( copy ) && isDefined( rank ) )
		level.hunterRanks[ rank.id ].rankPerks = copy.rankPerks;
}

addZombieRankPerks( rankName, health, damagemult, resilience, zomnadeammo )
{
	perks = spawnstruct();
	perks.health = health;
	perks.damagemult = damagemult;
	perks.resilience = resilience;
	perks.zomnadeammo = zomnadeammo;
	
	rank = getRankByName( "zombie", rankName );
	if ( isDefined( rank ) )
		level.zombieRanks[ rank.id ].rankPerks = perks;
}

addZombieRankPerkCopy( rankName, copy )
{
	copy = getRankByName( "zombie", copy );
	rank = getRankByName( "zombie", rankName );
	if ( isDefined( copy ) && isDefined( rankName ) )
		level.zombieRanks[ rank.id ].rankPerks = copy.rankPerks;
}

getRankByID( type, id )
{
	rank = undefined;
	if ( type == "hunter" )
		rank = level.hunterRanks[ id ];
	else if ( type == "zombie" )
		rank = level.zombieRanks[ id ];
		
	return rank;
}

getRankByName( type, name )
{
	rank = undefined;
	array = undefined;
	if ( type == "hunter" )
		array = level.hunterRanks;
	else if ( type == "zombie" )
		array = level.zombieRanks;
		
	for ( i = 0; i < array.size; i++ )
	{
		if ( array[ i ].rankName == name )
		{
			rank = array[ i ];
			break;
		}
	}
	
	return rank;
}

getRankByXP( type, value )
{
	rank = undefined;
	array = undefined;
	if ( type == "hunter" )
		array = level.hunterRanks;
	else if ( type == "zombie" )
		array = level.zombieRanks;
		
	for ( i = 0; i < array.size; i++ )
	{
		if ( value >= array[ i ].startXP && value < array[ i ].endXP )
		{
			rank = array[ i ];
			break;
		}
	}
	
	return rank;
}

giveHunterRankPerks()
{
	myRank = getRankByID( "hunter", self.rank );
	if ( isDefined( myRank ) && isDefined( myRank.rankPerks ) )
	{
		thesePerks = myRank.rankPerks;
		newhealth = thesePerks.health;
		self.stickynades = thesePerks.stickynades;
		self.healthpacks = thesePerks.healthpacks;
		self.maxhealthpacks = self.healthpacks;
		self.bodyarmor = thesePerks.bodyarmor;
		self.exploarmor = thesePerks.exploarmor;
		self.immunity = thesePerks.immunitylevel;
		self.ammobonus = thesePerks.ammobonus;
		
		if ( level.lasthunter ) 
			newhealth += 50;
			
		self.maxhealth = newhealth;
		
		if ( !level.gamestarted || level.lasthunter )
			self.health = self.maxhealth;
			
		self thread setHeadIcon();
	}
}

giveZomRankPerks()
{
	myRank = getRankByID( "zombie", self.zomrank );
	if ( isDefined( myRank ) && isDefined( myRank.rankPerks ) )
	{
		thesePerks = myRank.rankPerks;
		newhealth = thesePerks.health;
		self.damagemult = thesePerks.damagemult;
		self.resilience = thesePerks.resilience;
		self.zomnadeammo = thesePerks.zomnadeammo;
		
		self.maxhealth += newhealth;
		if ( level.firstzombie )
			self.maxhealth = 2000;
			
		self.health = self.maxhealth;
		
		if ( level.firstzombie )
			self setWeaponSlotAmmo( "grenade", self.zomnadeammo + 10 );
		else
			self setWeaponSlotAmmo( "grenade", self.zomnadeammo );
	}
}


/*	Zombie Ranks:
	0	- 0 K : Innocent
	1	- 5 K : Harmless
	2	- 10 K : Menacing
	3	- 15 K : Noxious
	4	- 20 K : Malignant
	5	- 25 K : Damaging
	6	- 30 K : Sinister
	7	- 40 K : Toxic
	8	- 50 K : Crippling
	9 	- 60 K : Corroding
	10	- 75 K : Ominous
	11	- 100 K : Calamitous
	12	- 125 K : Ranksacker
	13	- 150 K : Bomber
	14	- 175 K : Cancer
	15	- 200 K : Demolisher
	16	- 250 K : Vandal
	17	- 300 K : Eradicator
	18	- 350 K : Savage
	19	- 400 K : Exterminator
	20	- 450 K : Slaughterer
	21	- 500 K : Radiator
	22	- 600 K : Butcher
	23	- 750 K : Guerilla
	24	- 1000 K : Annihilator
	25	- 1250 K : Liquidator
	26	- 1500 K : Slayer
	27	- 1750 K : Hunter
	28 	- 2000 K : Cannibal
	29	- 2250 K : Ruthless
	30	- 2500 K : Fuckin' Lethal
	31	- 2750 K : Unrelenting
	32	- 3000 K : Reaper
	33	- 3250 K : Evil
	34	- 3500 K : Malefic
	35	- 3750 K : Devastating
	36	- 4000 K : Desecrator
	37	- 4250 K : Smasher
	38	- 4500 K : Wrecker
	39	- 5000 K : Extinguisher
	40	- 5500 K : Decimator
	41	- 6000 K : Obliterator
	42	- 7000 K : Depriver
	43	- 8000 K : Plunderer
	44	- 9000 K : Marauder
	45	- 10000 K : Tormentor
	46	- 25000 K : 1337
	47	- 50000 K : Godly
	48	- 75000 K : Monster
	49	- 100000 K : FUCKING BRUCE LEE
*/
/*
giveZomRankPerks()
{
	rank = self.zomrank;
	
	newhealth = 0;
		
	if ( rank >= 8 && rank < 11 )
		newhealth = 50;
	if ( rank >= 11 && rank < 15 )
		newhealth = 100;
	if ( rank >= 15 && rank < 18 )
		newhealth = 150;
	if ( rank >= 18 && rank < 21 )
		newhealth = 200;
	if ( rank >= 21 && rank < 24 )
		newhealth = 250;
	if ( rank >= 24 && rank < 28 )
		newhealth = 300;
	if ( rank >= 28 && rank < 32 )
		newhealth = 350;
	if ( rank >= 32 && rank < 36 )
		newhealth = 400;
	if ( rank >= 36 && rank < 39 )
		newhealth = 450;
	if ( rank >= 39 && rank < 45 )
		newhealth = 500;
	if ( rank >= 45 && rank < 49 )
		newhealth = 700;
	if ( rank >= 49 )
		newhealth = 1000;

	self.damagemult = 1.1;
	
	if ( rank >= 8 && rank < 16 )
		self.damagemult = 1.2;
	if ( rank >= 16 && rank < 21 )
		self.damagemult = 1.3;
	if ( rank >= 21 && rank < 25 )
		self.damagemult = 1.4;
	if ( rank >= 25 && rank < 28 )
		self.damagemult = 1.5;
	if ( rank >= 28 && rank < 34 )
		self.damagemult = 1.6;
	if ( rank >= 34 && rank < 39 )
		self.damagemult = 1.7;
	if ( rank >= 39 && rank < 42 )
		self.damagemult = 1.8;
	if ( rank >= 42 && rank < 45 )
		self.damagemult = 1.9;
	if ( rank >= 45 && rank < 47 )
		self.damagemult = 2.0;
	if ( rank >= 47 && rank < 49 )
		self.damagemult = 2.5;
	if ( rank >= 49 )
		self.damagemult = 3;
		
	if ( rank >= 8 && rank < 16 )
		self.resilience = 0.05;
	if ( rank >= 16 && rank < 21 )
		self.resilience = 0.10;
	if ( rank >= 21 && rank < 24 )
		self.resilience = 0.15;
	if ( rank >= 24 && rank < 28 )
		self.resilience = 0.20;
	if ( rank >= 28 && rank < 32 )
		self.resilience = 0.25;
	if ( rank >= 32 && rank < 36 )
		self.resilience = 0.30;
	if ( rank >= 36 && rank < 39 )
		self.resilience = 0.35;
	if ( rank >= 39 && rank < 45 )
		self.resilience = 0.40;
	if ( rank >= 45 && rank < 47 )
		self.resilience = 0.45;
	if ( rank >= 47 && rank < 49 )
		self.resilience = 0.50;
	if ( rank >= 49 )
		self.resilience = 0.60;
		
	self.maxhealth += newhealth;
	self.health = self.maxhealth;
}

*/
setHeadIcon()
{
	if ( isDefined( self.spamdelay ) )
		wait 3;
		
	icon = "gfx/hud/headicon@axis.tga";
	if ( self.rank >= 15 && self.rank < 21 )
		icon = "gfx/hud/headicon@allies.tga";
	if ( self.rank >= 21 )
		icon = "gfx/hud/headicon@re_objcarrier.tga";
		
	self.headicon = icon;
	self.statusicon = icon;
}