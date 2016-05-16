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
    Extra stuff in stock maps, models, fx, etc.
*/

init()
{
    [[ level.logwrite ]]( "zombies\\extra.gsc::init()", true );
    
    if ( level.mapname == "mp_brecourt" )   [[ level.precache ]]( "xmodel/vehicle_tank_tiger_d" );
    if ( level.mapname == "mp_harbor" )     [[ level.precache ]]( "xmodel/vehicle_russian_barge" );
    if ( level.mapname == "mp_rocket" )     [[ level.precache ]]( "xmodel/gib_concrete1small" );

    [[ level.precache ]]( "xmodel/playerbody_russian_conscript" );
    [[ level.precache ]]( "xmodel/tombstone1" );
    [[ level.precache ]]( "xmodel/stalin_statue" );
}

main() {    
    [[ level.logwrite ]]( "zombies\\extra.gsc::main()", true );

    models = [];
    fx = [];
    supported = true;
    
    switch ( level.mapname )
    {
        case "mp_brecourt":
            models = addModel( models, "xmodel/vehicle_tank_tiger_d",           ( -1691, -4034, 112 ),  ( 0, 65, 0 ) );
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( -2665, 2139, 66 ),    ( 0, -68, 0 ) );
            models = addModel( models, "xmodel/tombstone1",                     ( -2634, 2066, 52 ),    ( 0, -68, 0 ) );
            models = addModel( models, "xmodel/stalin_statue",                  ( 1070, -209, 137 ),    ( 0, -138, 0 ) );
            break;
            
        case "mp_chateau":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( 3081, 601, 131 ),     ( 0, -166, 0 ) );
            models = addModel( models, "xmodel/tombstone1",                     ( 3101, 513, 132 ),     ( 0, -168, 0 ) );
            models = addModel( models, "xmodel/stalin_statue",                  ( 217, 2734, 198 ),     ( 0, -134, 0 ) );
            break;
            
        case "mp_carentan":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( 2009, -1423, 21 ),    ( 0, 162, 0 ) );
            models = addModel( models, "xmodel/tombstone1",                     ( 1927, -1489, 9 ),     ( 0, 158, 0 ) );
            models = addModel( models, "xmodel/stalin_statue",                  ( -860, 3127, -48 ),    ( 0, -70, 0 ) );
            break;
            
        case "mp_dawnville":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( 2722, -16275, -59 ),  ( 0, 172, 0 ) );
            models = addModel( models, "xmodel/tombstone1",                     ( 2635, -16338, -69 ),  ( 0, 172, 0 ) );
            models = addModel( models, "xmodel/stalin_statue",                  ( 2853, -19373, 188 ),  ( 0, 171, 0 ) );
            break;
            
        case "mp_depot":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( -2986, 238, -23 ),    ( 0, 70, 0 ) );
            models = addModel( models, "xmodel/tombstone1",                     ( -3035, 256, -23 ),    ( 0, 66, 0 ) );
            models = addModel( models, "xmodel/stalin_statue",                  ( 348, 2248, -36 ),     ( 0, 176, 0 ) );
            break;
            
        case "mp_harbor":
            models = addModel( models, "xmodel/vehicle_russian_barge",          ( -6675, -6348, -119 ), ( 0, -88, 0 ) );
            models = addModel( models, "xmodel/vehicle_russian_barge",          ( -7390, -6365, -119 ), ( 0, -88, 0 ) );
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( -9798, -5353, 64 ),   ( 0, -27, 0 ) );
            models = addModel( models, "xmodel/tombstone1",                     ( -9701, -5366, 64 ),   ( 0, -36, 0 ) );
            models = addModel( models, "xmodel/stalin_statue",                  ( -12018, -8686, 0 ),   ( 0, 33, 0 ) );
            break;
            
        case "mp_hurtgen":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( 2284, -5561, 111 ),   ( 0, 71, 0 ) );
            models = addModel( models, "xmodel/tombstone1",                     ( 2367, -5590, 124 ),   ( 0, 67, 0 ) );
            models = addModel( models, "xmodel/stalin_statue",                  ( -571, 4651, 0 ),      ( 0, -60, 0 ) );
            break;
            
        case "mp_pavlov":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( -9620, 12451, 32 ),   ( 0, -157, 0 ) );
            models = addModel( models, "xmodel/tombstone1",                     ( -9567, 12522, 33 ),   ( 0, -157, 0 ) );
            models = addModel( models, "xmodel/stalin_statue",                  ( -12880, 10418, -25 ), ( 0, -13, 0 ) );
            break;
            
        case "mp_powcamp":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( -2228, 3848, 2 ),     ( 0, -6, 0 ) );
            models = addModel( models, "xmodel/tombstone1",                     ( -2237, 3775, 2 ),     ( 0, -2, 0 ) );
            models = addModel( models, "xmodel/stalin_statue",                  ( 2558, 6509, 181 ),    ( 0, -122, 0 ) );
            break;
            
        case "mp_railyard":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( 807, 762, 304 ),      ( 0, -162, 0 ) );
            models = addModel( models, "xmodel/tombstone1",                     ( 833, 671, 304 ),      ( 0, -171, 0 ) );
            models = addModel( models, "xmodel/stalin_statue",                  ( -3081, -1876, 329 ),  ( 0, 81, 0 ) );
            break;
            
        case "mp_rocket":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( 12289, 1695, 618 ),   ( 0, 99, 0 ) );
            models = addModel( models, "xmodel/stalin_statue",                  ( 7817, 7372, 682 ),    ( 0, -74, 0 ) );
            models = addModel( models, "xmodel/gib_concrete1small",             ( 10681, 4442, 382 ),   ( 0, 180, 180 ), true, 24, 32 );

            thread guysbashing();
            break;
            
        case "mp_ship":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( 4992, 65, 2224 ),     ( 0, -180, 0 ) );
            models = addModel( models, "xmodel/stalin_statue",                  ( 7964, -635, -305 ),   ( 0, -165, 0 ) );
            break;
            
        case "mp_neuville":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( -11787, 2121, -71 ),  ( 0, -145, 0 ) );
            models = addModel( models, "xmodel/tombstone1",                     ( -11705, 2128, -68 ),  ( 0, -145, 0 ) );
            break;
            
        case "mp_stalingrad":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( 3953, 308, 300 ),     ( 0, -90, 0 ) );
            break;
            
        case "quarantine":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( 4392, -809, 0 ),      ( 0, 180, 0 ) );
            models = addModel( models, "xmodel/tombstone1",                     ( 4392, -726, 0 ),      ( 0, 180, 0 ) );
            break;
            
        case "mp_vok_final_night":
            models = addModel( models, "xmodel/playerbody_russian_conscript",   ( -1195, 7661, 865 ),   ( 0, -40, 0 ) );
            models = addModel( models, "xmodel/tombstone1",                     ( -1088, 7662, 867 ),   ( 0, -40, 0 ) );
            break;
            
        default:
            supported = false;
            break;
    }
    
    if ( supported )
    {
        spawnModels( models );
        spawnFx( fx );
    }
}

addModel( array, model, origin, angles, hascontents, mins, maxs )
{
    mod = spawnstruct();
    mod.model = model;
    mod.origin = origin;
    mod.angles = angles;

    mod.hascontents = false;
    if ( isDefined( hascontents ) )
        mod.hascontents = hascontents;

    if ( isDefined( mins ) )
        mod.mins = mins;
    if ( isDefined( maxs ) )
        mod.maxs = maxs;
    
    array[ array.size ] = mod;
    return array;
}

addFx( array, id, origin, waittime )
{
    fx = spawnstruct();
    fx.id = id;
    fx.origin = origin;
    fx.waittime = waittime;
    
    array[ array.size ] = fx;
    return array;
}

spawnModels( array )
{
    if ( !array.size )
        return;
        
    for ( i = 0; i < array.size; i++ )
    {
        model = spawn( "script_model", ( 0, 0, 0 ) );
        model.origin = array[ i ].origin;
        model.angles = array[ i ].angles;
        model setModel( array[ i ].model );

        if ( array[ i ].hascontents )
            model setContents( 1 );

        if ( isDefined( array[ i ].mins ) && isDefined( array[ i ].maxs ) )
            model setBounds( array[ i ].mins, array[ i ].maxs );
    }
}

spawnFx( array )
{
    if ( !array.size )
        return;
        
    for ( i = 0; i < array.size; i++ )
    {
        id = array[ i ].id;
        pos = array[ i ].origin;
        waittime = array[ i ].waittime;
        
        thread maps\mp\_fx::loopfxthread( id, pos, waittime );
    }
}

guysbashing() {
/*
    cheese = spawn( "script_model", ( 10545, 4420, 408 ) );
    cheese.angles = ( 0, -90, 0 );
    cheese setModel( "xmodel/playerbody_british_commando" );
    cheese attach( "xmodel/head_Price" );
    cheese attach( "xmodel/equipment_british_beret_red" );
    cheese attach( "xmodel/gear_british_price" );

    cp = spawn( "script_model", ( 10545, 4380, 408 ) );
    cp.angles = ( 0, 90, 0 );
    cp setModel( "xmodel/playerbody_russian_conscript" );

    cphead = spawn( "script_model", cp.origin + ( 0, 0, 60 ) );
    cphead.angles = ( 0, 90, 0 );
    cphead setModel( "xmodel/head_Pavlov" );
    cphead attach( "xmodel/equipment_pavlov_ushanka" );
    cp attach( "xmodel/gear_russian_load_ocoat" );
    cp attach( "xmodel/gear_russian_ppsh_ocoat" );
    cp attach( "xmodel/gear_russian_pack_ocoat" );*/

    wait 5;

//
    level.bot_allowconnect = true;
    cheesebot = addtestclient();
    wait 0.5;
    if ( !isDefined( cheesebot ) ) {
        level.bot_allowconnect = false;
        return;
    }

    cpbot = addtestclient();
    wait 0.5;
    if ( !isDefined( cpbot ) ) {
        level.bot_allowconnect = false;
        return;
    }
    level.bot_allowconnect = false;
//

    cheesebot setupbotrealquick( "cheesebot", "kar98k_sniper_mp", 2508, ( 10545, 4450, 408 ), ( 0, -90, 0 ) );
    wait 0.5;
    cpbot setupbotrealquick( "cpbot", "bar_mp", 3914, ( 10560, 4431, 408 ), ( 0, 180, 0 ) );
    wait 0.5;

    cpbot.enraged = false;
    cpbot.ragemeter = 0;
    cpbot.cb_damage = ::dmg_cp;

    cheesebot thread godmode();
    cpbot thread godmode();

    cheesebot thread flyaround();
    cpbot thread watchintensely();
}


playanim( panim ) {
    index = get_animation_index( panim );
    self setint( 112, index, 1 );
    self setint( 120, index, 1 );
}

setupbotrealquick( name, weapon, guid, org, angs ) {
    self renameBot( name );
    self setClientCvar( "name", name );

    self.guid = guid;

    self.pers[ "team" ] = "axis";
    self.pers[ "weapon" ] = weapon;
    self.sessionteam = self.pers[ "team" ];
    self.sessionstate = "playing";
    self.spectatorclient = -1;
    self.archivetime = 0;

    self spawn( org, angs );
    self.statusicon = "";
    self.maxhealth = 100;
    self.health = self.maxhealth;

    self zombies\skins::main();

    self giveWeapon( self.pers[ "weapon" ] );
    self setSpawnWeapon( self.pers[ "weapon" ] );
    self setWeaponSlotClipAmmo( "primary", 0 );
    self setWeaponSlotAmmo( "primary", 0 );

    self.node = spawn( "script_origin", org );
    self linkto( self.node );
    self setPlayerAngles( angs );

    self.cb_damage = ::blank_dmg;
    self.cb_killed = ::blank_killed;

// these are all here just to prevent game code from breaking
// because bots don't actually have any "stats" or "ranks"
    self.oldname = name;
    rnk = zombies\ranks::getRankByXP( "hunter", 1000000000 );
    self.rank = rnk.id;
    self.xp = 1000000000;
    self.killstreak = 0;
    self.zomrank = 0;
    self.zomxp = 0;
    self.points = 0;
    self.pointscore = 0;
    self.class = "support";
    self.subclass = "none";
    self.damagearmor = 0;
    self.damagemult = 0;
    self.invisible = false;
    self.iszombie = false;
    self.rocketattack = false;
    self.armored = false;
    self zombies\stats::setupPlayer();
//
//
}

godmode() {
    self endon( "remove bot" );

    while ( true ) {
        self.health = self.maxhealth;
        wait frame();
    }
}

flyaround() {
    flyorg = [];
    flyorg[ 0 ] = ( 10686, 4335, 432 );
    flyorg[ 1 ] = ( 10513, 4335, 432 );
    flyorg[ 2 ] = ( 10513, 4513, 432 );
    flyorg[ 3 ] = ( 10693, 4513, 432 );

    self playanim( "pb_chicken_dance_crouch" );
    self.node.origin = flyorg[ 0 ];

    current = 0;
    while ( true ) {
        next = randomInt( flyorg.size );
        while ( next == current ) {
            next = randomInt( flyorg.size );
            wait frame();
        }

        current = next;

        angstonext = vectorToAngles( flyorg[ next ] - self.node.origin );
        self setPlayerAngles( angstonext );

        self.node moveto( flyorg[ next ], 3 );
        wait 3;

        for ( i = 0; i < 90; i++ ) {
            self setPlayerAngles( ( 0, i * 4, 0 ) );
            wait frame();
        }
    }
}

watchintensely() {
    self playanim( "pb_stand_shoot_walk_forward_unarmed" );

    orgs = [];
    orgs[ orgs.size ] = ( 10605, 4312, 408 );
    orgs[ orgs.size ] = ( 10493, 4424, 408 );
    orgs[ orgs.size ] = ( 10597, 4535, 408 );
    orgs[ orgs.size ] = ( 10716, 4395, 408 );

    while ( true ) {
        wait 0.1;

        if ( self.enraged )
            continue;

        players = utilities::getPlayersOnTeam( "any" );

        closestdist = 99999999;
        closest = undefined;
        for ( i = 0; i < players.size; i++ ) {
            if ( distance( players[ i ].origin, self.node.origin ) < closestdist ) {
                closestdist = distance( players[ i ].origin, self.node.origin );
                closest = players[ i ];
            }
        }

        if ( isDefined( closest ) && closest.sessionstate == "playing" && !closest.invisible ) {
            // check if there's a closer origin we can get to
            closestorg = undefined;
            closestorgdist = 99999999;
            for ( i = 0; i < orgs.size; i++ ) {
                if ( distance( closest.origin, orgs[ i ] ) < closestorgdist ) {
                    closestorgdist = distance( closest.origin, orgs[ i ] );
                    closestorg = orgs[ i ];
                }
            }

            if ( isDefined( closestorg ) && distance( closestorg, self.node.origin ) > 24 ) {
                t = distance( closestorg, self.node.origin ) / 140;
                a = 0.2;
                if ( a * 2 > t ) a -= t;
                if ( a < 0 ) a = 0;
                self.node moveto( closestorg, t, a, a );
            }

            z = 60;
            if ( closest getStance() == "crouch" )
                z = 40;
            else if ( closest getStance() == "prone" )
                z = 12;

            trace = bullettrace( self.node.origin + ( 0, 0, 60 ), closest.origin + ( 0, 0, z ), true, self );
            if ( trace[ "fraction" ] != 1 )
                continue;

            angs = vectorToAngles( ( closest.origin ) - self.node.origin );
            self setPlayerAngles( angs );
        }
    }
}

dmg_cp( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc ) {
    if ( isPlayer( eAttacker ) ) {
        if ( self.ragemeter > 1000 ) {
            if ( self.enraged ) 
                self notify( "stop rage" );

            self thread becomeenraged( eAttacker );
            iPrintLnBold( eAttacker.name + "^7 has enraged cpbot!" );

            self.ragemeter = 0;
        } else {
            if ( !self.enraged ) {
                msgs = [];
                msgs[ msgs.size ] = "Careful! You might enrage cpbot!";
                msgs[ msgs.size ] = "Watch out! cpbot might attack!";
                msgs[ msgs.size ] = "Keep going and you'll enrage cpbot!";
                msgs[ msgs.size ] = "cpbot doesn't tolerate such behaviour!";
                msgs[ msgs.size ] = "cpbot is liable to snap if you continue!";
                msgs[ msgs.size ] = "If you don't stop soon, cpbot will destroy you!";
                msgs[ msgs.size ] = "cpbot will attack without mercy!";
                msgs[ msgs.size ] = "Careful! cpbot is extremely deadly!";

                eAttacker iPrintLnBold( msgs[ randomInt( msgs.size ) ] );
                self.ragemeter += iDamage;

                self finishPlayerDamage( eInflictor, eAttacker, 1, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc );
            }
        }
    }
}

becomeenraged( ply ) {
    self endon( "stop rage" );

    orgs = [];
    orgs[ orgs.size ] = ( 10605, 4312, 408 );
    orgs[ orgs.size ] = ( 10493, 4424, 408 );
    orgs[ orgs.size ] = ( 10597, 4535, 408 );
    orgs[ orgs.size ] = ( 10716, 4395, 408 );

    self.enraged = true;

    wait 1;

    waiting = false;
    while ( true ) {
        wait frame();

        if ( !isAlive( ply ) || ply.sessionstate != "playing" )
            break;

        // check if there's a closer origin we can get to
        closestorg = undefined;
        closestorgdist = 99999999;
        for ( i = 0; i < orgs.size; i++ ) {
            if ( distance( ply.origin, orgs[ i ] ) < closestorgdist ) {
                closestorgdist = distance( ply.origin, orgs[ i ] );
                closestorg = orgs[ i ];
            }
        }

        if ( isDefined( closestorg ) && distance( closestorg, self.node.origin ) > 24 ) {
            t = distance( closestorg, self.node.origin ) / 140;
            a = 0.2;
            if ( a * 2 > t ) a -= t;
            if ( a < 0 ) a = 0;
            self.node moveto( closestorg, t, a, a );
        }

        if ( !waiting ) {
            self playanim( "pb_stand_shoot_walk_forward_unarmed" );
            waiting = true;
            continue;
        }

        if ( ply.invisible )
            continue;

        z = 60;
        if ( ply getStance() == "crouch" )
            z = 40;
        else if ( ply getStance() == "prone" )
            z = 12;
        trace = bullettrace( self.node.origin + ( 0, 0, 60 ), ply.origin + ( 0, 0, z ), true, self );
        if ( trace[ "fraction" ] != 1 )
            continue;

        waiting = false;
        angs = vectorToAngles( ( ply.origin ) - self.node.origin );
        self setPlayerAngles( angs );

        if ( ply.invisible )
            continue;

        if ( !isAlive( ply ) || ply.sessionstate != "playing" )
            break;

        self playanim( "pb_stand_alert" );
        wait frame();
        self playanim( "pt_stand_shoot_auto_ads" );
        wait frame();

        if ( ply.invisible )
            continue;

        if ( !isAlive( ply ) || ply.sessionstate != "playing" )
            break;

        self.node playSound( "weap_bar_fire" );
        playFxOnTag( level._effect[ "sentry_fire" ], self, "tag_weapon_right" );

        ply finishPlayerDamage( self, self, 25, 0, "MOD_RIFLE_BULLET", "bar_mp", ( 0, 0, 60 ), ( ply.origin - self.origin ), "torso_upper" );

        wait 0.1;
    }

    self.enraged = false;

    self playanim( "pb_stand_shoot_walk_forward_unarmed" );
}

blank_dmg( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc ) { }
blank_killed( eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc ) { }
