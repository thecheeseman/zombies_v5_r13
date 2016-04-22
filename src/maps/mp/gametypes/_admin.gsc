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
    [[ level.logwrite ]]( "maps\\mp\\gametypes\\_admin.gsc::main()", true );

    [[ level.precache ]](  "xmodel/vehicle_tank_tiger" );

    level.specthread = maps\mp\gametypes\zombies::spawnSpectator;

    // Insults by Cato
    insults[0]  = "^1's mom is like a hardware store... 10 cents a screw.";
    insults[1]  = "^1. I'd like to see things from your point of view but I can't seem to get my head that far up my ass.";
    insults[2]  = "^1's mom is so poor, she once fought a blind squirrel for a peanut.";
    insults[3]  = "^1 is so stupid he tried to eat a crayon because it looked fruity!";
    insults[4]  = "^1 is so stupid he tought a 'quarter back' is a refund.";
    insults[5]  = "^1 is so poor he uses an ice cube as his A/C.";
    insults[6]  = "^1. If you were any more stupid, he'd have to be watered twice a week.";
    insults[7]  = "^1. I could make a monkey out of you, but why should I take all the credit?";
    insults[8]  = "^1. I heard you got a brain transplant and the brain rejected you!";
    insults[9]  = "^1. How did you get here? Did someone leave your cage open?";
    insults[10] = "^1 got more issues than National Geographic!";
    insults[11] = "^1. If you were my dog, I'd shave your butt and teach you to walk backwards.";
    insults[12] = "^1. You're the reason God created the middle finger.";
    insults[13] = "^1. I hear that when your mother first saw you, she decided to leave you on the front steps of a police station while she turned herself in.";
    insults[14] = "^1. Your IQ involves the square root of -1.";
    insults[15] = "^1. You know you're a bad gamer when you still miss with an aimbot.";
    insults[16] = "^1. You're such a nerd that your penis plugs into a flash drive.";
    insults[17] = "^1's mom is so FAT32, she wouldn't be accepted by NTFS!";
    insults[18] = "^1. You're not important - you're just an NPC!";
    insults[19] = "^1, you're so slow, is your ping at 999?";
    insults[20] = "^1. You're not optimized for life are you?";
    insults[21] = "^1. You must have been born on a highway because that's where most accidents happen.";
    insults[22] = "^1. Why don't you slip into something more comfortable... like a coma.";
    insults[23] = "^1. I had a nightmare. I dreamt I was you.";
    insults[24] = "^1. Lets play 'house'. You be the door and I'll slam you.";
    insults[25] = "^1, I'm gonna get you a condom. That way you can have protection when you go fuck yourself.";
    insults[26] = "^1. Roses are red, violets are blue, I have 5 fingers, the 3rd ones for you.";
    insults[27] = "^1. Ever since I saw you in your family tree, I've wanted to cut it down.";
    insults[28] = "^1, your village just called. They're missing an idiot.";
    insults[29] = "^1, I can't think of an insult stupid enough for you.";

    level.iC = 0;
    level.insults = [[ level.utility ]]( "arrayShuffle", insults );

    level.adminvars = [];

    addVar( "admin_endgame", ::endGame );
    addVar( "admin_giveweap", ::giveWeap );
    addVar( "admin_drop", ::drop );
    addVar( "admin_giveks", ::giveks );
    addVar( "admin_givearmor", ::givearmor );
    
    addVar( "admin_kill", ::kill );
    addVar( "admin_givexp", ::giveXp );
    addVar( "admin_givekills", ::giveKills );
    addVar( "admin_gp", ::givePoints );
    addVar( "admin_say", ::say );
    addVar( "admin_getid", ::getid );
    addVar( "admin_updatexp", ::updatexp );
    addVar( "admin_updatekills", ::updatekills );
    addVar( "admin_rename", ::rename );
    
    addVar( "admin_spank", ::spank );
    addVar( "admin_slap", ::slap );

    addVar( "admin_blind", ::blind );
    addVar( "admin_forcespec", ::forcespec );
    //addVar( "admin_toilet", ::toilet );
    addVar( "admin_runover", ::runover );
    addVar( "admin_squash", ::squash );
    addVar( "admin_insult", ::insult );
    addVar( "admin_rape", ::rape );

    addVar( "admin_moveguid", ::move_guid );
}

main() {
    thread watchVars();
}

addVar( varname, func ) {
    if ( !varExists( varname ) ) {
        v = spawnstruct();
        v.varname = varname;
        v.func = func;

        level.adminvars[ level.adminvars.size ] = v;
        setCvar( varname, "" );
    }
}

varExists( varname ) {
    for ( i = 0; i < level.adminvars.size; i++ ) {
        v = level.adminvars[ i ];
        if ( v.varname == varname )
            return true;
    }

    return false;
}

watchVars()
{
    while ( true ) {
        resettimeout();

        for ( i = 0; i < level.adminvars.size; i++ ) {
            v = level.adminvars[ i ];

            if ( getCvar( v.varname ) != "" )
            {
                thread [[ v.func ]]( getCvar( v.varname ) );
                setCvar( v.varname, "" );
            }
        }
                
        wait 0.05;
    }
}

endGame( value )
{
    thread maps\mp\gametypes\_zombie::endGame( "forced" );
}

kill( value )
{
    player = [[ level.utility ]]( "getPlayerByID", value );
    
    if ( isDefined( player ) )
    {
        player suicide();
        playFx( level._effect[ "zombieExplo" ], player.origin );
        
        iPrintLn( "^3The Admin killed ^7" + player.name + "^3!" );
    }
}

giveXp( value )
{
    array = [[ level.utility ]]( "explode", value, " " );
    
    if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
        return;
        
    player = [[ level.utility ]]( "getPlayerByID", array[ 0 ] );

    amount = [[ level.utility ]]( "atoi", array[ 1 ] );
    if ( !isDefined ( amount ) && isDefined( self ) )
    {
        self iprintln( "^1I^7nvalid XP Value^1!" );
        return;
    }
    
    if ( isDefined( player ) )
    {
        player.xp += amount;
        player thread maps\mp\gametypes\_zombie::checkRank();
    }
}

giveKills( value )
{
    array = [[ level.utility ]]( "explode", value, " " );
    
    if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
        return;
        
    player = [[ level.utility ]]( "getPlayerByID", array[ 0 ] );

    amount = [[ level.utility ]]( "atoi", array[ 1 ] );
    if ( !isDefined ( amount ) && isDefined( self ) )
    {
        self iprintln( "^1I^7nvalid Kill Value^1!" );
        return;
    }
    
    if ( isDefined( player ) )
    {
        player.zomxp += amount;
        player thread maps\mp\gametypes\_zombie::checkRank();
    }
}

givePoints( value )
{
    array = [[ level.utility ]]( "explode", value, " " );
    
    if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
        return;
        
    player = [[ level.utility ]]( "getPlayerByID", array[ 0 ] );
    
    amount = [[ level.utility ]]( "atoi", array[ 1 ] );
    if ( !isDefined ( amount ) && isDefined( self ) )
    {
        self iprintln( "^1I^7nvalid Point Value^1!" );
        return;
    }
    
    if ( isDefined( player ) )
        player.points += amount;
}

updateXP( value )
{
    array = [[ level.utility ]]( "explode", value, " " );
    
    if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
        return;
        
    id = [[ level.utility ]]( "atoi", array[ 0 ] );
    if ( !isDefined ( id ) && isDefined( self ) )
    {
        self iprintln( "^1I^7nvalid ID^1!" );
        return;
    }
    amount = [[ level.utility ]]( "atoi", array[ 1 ] );
    if ( !isDefined ( amount ) && isDefined( self ) )
    {
        self iprintln( "^1I^7nvalid XP Value^1!" );
        return;
    }
    for ( i = 0; i < level.stats[ "hunters" ].size; i++ )
    {
        miniarray = [[ level.utility ]]( "explode", level.stats[ "hunters" ][ i ], "," );
        if ( id == miniarray[ 0 ] )
        {
            miniarray[ 1 ] += amount;
            
            string = miniarray[ 0 ] + "," + miniarray[ 1 ] + "," + miniarray[ 2 ];
            level.stats[ "hunters" ][ i ] = string;
            break;
        }
    }
}

updateKills( value )
{
    array = [[ level.utility ]]( "explode", value, " " );
    
    if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
        return;
        
    id = [[ level.utility ]]( "atoi", array[ 0 ] );
    if ( !isDefined ( id ) && isDefined( self ) )
    {
        self iprintln( "^1I^7nvalid ID^1!" );
        return;
    }
    amount = [[ level.utility ]]( "atoi", array[ 1 ] );
    if ( !isDefined ( amount ) && isDefined( self ) )
    {
        self iprintln( "^1I^7nvalid Kill Value^1!" );
        return;
    }
    for ( i = 0; i < level.stats[ "zombies" ].size; i++ )
    {
        miniarray = [[ level.utility ]]( "explode", level.stats[ "zombies" ][ i ], "," );
        if ( id == miniarray[ 0 ] )
        {
            miniarray[ 1 ] += amount;
            
            string = miniarray[ 0 ] + "," + miniarray[ 1 ] + "," + miniarray[ 2 ];
            level.stats[ "zombies" ][ i ] = string;
            break;
        }
    }
}

giveWeap( value )
{
    array = [[ level.utility ]]( "explode", value, " " );
    
    if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
        return;
        
    player = [[ level.utility ]]( "getPlayerByID", array[ 0 ] );
    weapon = array[ 1 ];
    slot = "primaryb";
    
    if ( isDefined( array[ 2 ] ) )
        slot = array[ 2 ];
        
    player setWeaponSlotWeapon( slot, weapon );
    player setWeaponSlotAmmo( slot, 9999 );
    player switchToWeapon( weapon );
}

say( value )
{
    iPrintLnBold( value );
}

getid( value )
{
    player = [[ level.utility ]]( "getPlayerByID", value );
    
    if ( isDefined( player ) )
        self iprintlnbold( player.name + " = " + [[ level.utility ]]( "getNumberedName", player.name ) );
        
}

drop( value )
{
    array = [[ level.utility ]]( "explode", value, " " );
    height = 512;
    
    if ( !isDefined( array[ 0 ] ) )
        return;
        
    if ( isDefined( array[ 1 ] ) )
    {
        height = [[ level.utility ]]( "atoi", array[ 1 ] );
        if ( !isDefined ( height ) && isDefined( self ) )
        {
            self iprintln( "^1I^7nvalid Height^1!" );
            return;
        }
    }
    
    player = [[ level.utility ]]( "getPlayerByID", array[ 0 ] );
    
    if ( isDefined( player ) )
    {
        player endon( "disconnect" );
        
        player.drop = spawn( "script_origin", player.origin );
        player linkto( player.drop );
        
        player.drop movez( height, 2 );
        wait 2;
        player unlink();
        player.drop delete();
        
        iPrintLn( "^3The admin DROPPED ^7" + player.name + "^3!" );
    }
}

spank( value )
{
    array = [[ level.utility ]]( "explode", value, " " );
    time = 30;
    
    if ( !isDefined( array[ 0 ] ) )
        return;
        
    if ( isDefined( array[ 1 ] ) )
    {
        time = [[ level.utility ]]( "atoi", array[ 1 ] );
        if ( !isDefined ( time ) && isDefined( self ) )
        {
            self iprintln( "^1I^7nvalid Time^1!" );
            return;
        }
    }
        
    player = [[ level.utility ]]( "getPlayerByID", array[ 0 ] );

    if ( isDefined( player ) )
    {   
        iPrintLn( "^3The admin SPANKED ^7" + player.name + "^3!" );
            
        player shellshock( "default", time / 2 );
        for( i = 0; i < time; i++ )
        {
            player playSound( "melee_hit" );
            player setClientCvar( "cl_stance", 2 );
            wait randomFloat( 0.5 );
        }
        player shellshock( "default", 1 );
    }
}

slap( value )
{
    array = [[ level.utility ]]( "explode", value, " " );
    dmg = 10;
    
    if ( !isDefined( array[ 0 ] ) )
        return;
    
    if ( isDefined( array[ 1 ] ) )
    {
        dmg = [[ level.utility ]]( "atoi", array[ 1 ] );
        if ( !isDefined ( dmg ) && isDefined( self ) )
        {
            self iprintln( "^1I^7nvalid Damage Value^1!" );
            return;
        }
    }
    
    player = [[ level.utility ]]( "getPlayerByID", array[ 0 ] );

    if ( isDefined( player ) )
    {
        eInflictor = player;
        eAttacker = player;
        iDamage = dmg;
        iDFlags = 0;
        sMeansOfDeath = "MOD_PROJECTILE";
        sWeapon = "panzerfaust_mp";
        vPoint = ( player.origin + ( 0, 0, -1 ) );
        vDir = vectorNormalize( player.origin - vPoint );
        sHitLoc = "none";
        psOffsetTime = 0;

        player playSound( "melee_hit" );
        player finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
        
        iPrintLn( "^3The admin SLAPPED ^7" + player.name + "^7!" );
    }
}

giveks( value )
{
    array = [[ level.utility ]]( "explode", value, " " );
    
    if ( !isDefined( array[ 0 ] ) && !isDefined( array[ 1 ] ) )
        return;
        
    player = [[ level.utility ]]( "getPlayerByID", array[ 0 ] );
    ks = array[ 1 ];
    
    if ( isDefined( player ) )
    {
        player.powerup = ks;
        player thread maps\mp\gametypes\_killstreaks::notifyPowerup();
    }
}

rename( value )
{
    array = [[ level.utility ]]( "explode", value, " " );

    if ( !isDefined( array[ 0 ] ) && !isDefined( array[ 1 ] ) )
        return;
        
    player = [[ level.utility ]]( "getPlayerByID", array[ 0 ] );
    
    if ( isDefined( player ) )
    {
        newname = "";
        for ( i = 1; i < 10; i++ )
        {
            if ( isDefined( array[ i ] ) )
            {
                newname += " ";
                newname += array[ i ];
            }
        }
        
        player setClientCvar( "name", newname );
    }
}

givearmor( value )
{
    array = [[ level.utility ]]( "explode", value, " " );

    if ( !isDefined( array[ 0 ] ) || !isDefined( array[ 1 ] ) )
        return;
    
    armor = [[ level.utility ]]( "atoi", array[ 1 ] );
    if ( !isDefined ( armor ) && isDefined( self ) )
    {
        self iprintln( "^1I^7nvalid Value^1!" );
        return;
    }
    
    player = [[ level.utility ]]( "getPlayerByID", array[ 0 ] );
    
    if ( isDefined( player ) )
    {   
        if ( array[ 1 ] == "bodyarmor" )
            player.bodyarmor = armor;
        else if ( array[ 1 ] == "exploarmor" )
            player.exploarmor = armor;
    }
}

blind( value )
{
    array = [[ level.utility ]]( "explode", value, " " );
    
    if ( !isDefined( array[ 0 ] ) )
        return;
    
    time = 10;
    player = [[ level.utility ]]( "getPlayerByID", array[ 0 ] );
    if ( isDefined( array[ 1 ] ) )
        time = [[ level.utility ]]( "atoi", array[ 1 ] );
    
    if( isDefined( player ) )
    {
        iPrintLn( "^3The admin BLINDED ^7" + player.name + "^3!" );
        half = time / 2;
        
        player shellshock( "default", time ); 
        player.blindscreen = newClientHudElem( player );
        player.blindscreen.x = 0;
        player.blindscreen.y = 0;
        player.blindscreen.alpha = 1;
        player.blindscreen setShader( "white", 640, 480 );
        
        wait half;
        
        player.blindscreen fadeOverTime( half );
        player.blindscreen.alpha = 0;
        wait time;
        player.blindscreen destroy();
    }
}

forcespec( value )
{
    player = [[ level.utility ]]( "getPlayerByID", value );
    if( isDefined( player ) )
    {
        player thread [[ level.specthread ]]();
        iPrintLn( "^3The admin FORCED ^7" + player.name + "^3 to spectator." );
    }
}

toilet( value )
{ 
    player = [[ level.utility ]]( "getPlayerByID", value );
    if( isDefined( player ) )
    {
        player detachall();
        player takeAllWeapons();
        player setmodel( "xmodel/toilet" );

        iPrintLn( "^3The admin turned ^7" + player.name + "^3 into a toilet!" );

        isSet3rdPerson = false;

        while(player.sessionstate == "playing") {
            if(!isSet3rdPerson) {
                player setClientCvar("cg_thirdperson", "1");
                isSet3rdPerson = true;
            }
            wait 0.05;  
        }
        player setClientCvar("cg_thirdperson", "0");
    }
}

insult(value)
{
    player = [[ level.utility ]]( "getPlayerByID", value );
    if(!isDefined(player))
        return;

    // Check if all the insults have been displayed
    if(level.iC >= (level.insults.size - 1)) {
        // If it is, print the last insult
        iPrintLnBold(player.name + level.insults[level.insults.size - 1]);
        // Shuffle the array again so we don't got the same list of insults
        level.insults = [[level.utility]]("arrayShuffle", level.insults);
        // Reset the insult counter
        level.iC = 0;
    } else {
        iPrintLnBold(player.name + level.insults[level.iC]);
        level.iC++;
    }
}

runover( value )
{
    player = [[ level.utility ]]( "getPlayerByID", value );
    if( isDefined( player ) )
    {
        lol = spawn( "script_origin", player getOrigin() );
        player linkto( lol );
        tank = spawn( "script_model", player getOrigin() + ( -512, 0, -256 ) );
        tank setmodel( "xmodel/vehicle_tank_tiger" );
        angles = vectortoangles( player getOrigin() - ( tank.origin + ( 0, 0, 256 ) ) );
        tank.angles = angles;
        tank playloopsound( "tiger_engine_high" );
        tank movez( 256, 1 );
        wait 1;
        tank movex( 1024, 5 );
        wait 1.8;
        iPrintLn( "^7" + player.name + "^3 was RUN OVER by a tank!" );
        player suicide();
        wait 3.2;
        tank movez( -256, 1 );
        wait 1;
        tank stoploopsound();
        tank delete();
        lol delete();
    }
}

squash( value )
{
    player = [[ level.utility ]]( "getPlayerByID", value );
    
    if( isDefined( player ) )
    {
        lol = spawn( "script_model", player getOrigin() );
        player linkto( lol );
        thing = spawn( "script_model", player getOrigin() + ( 0, 0, 1024 ) );
        thing setmodel( "xmodel/vehicle_russian_barge" );
        thing movez( -1024, 2 );
        wait 2;
        iPrintLn( "^3The admin SQUASHED ^7" + player.name + "^3 with a russian barge!" );
        player suicide();
        thing movez( -512, 5 );
        wait 5;
        thing delete();
        lol delete();
    }
}

rape( value ) {
    player = [[ level.utility ]]( "getPlayerByID", value );
    
    if ( isDefined( player ) ) {
        dumas = spawn( "script_model", ( 0, 0, 0 ) );
        dumas setmodel( "xmodel/playerbody_russian_conscript" );
        
        player thread forceprone();
        
        iPrintLnBold( player.name + "^3 is getting RAPED by dumas!" );

        player endon( "spawned" );
        player endon( "disconnect" );
        
        while ( isAlive( player ) ) {
            tracedir = anglestoforward( player getPlayerAngles() );
            traceend = player.origin;
            traceend += maps\mp\_utility::vectorscale( tracedir, -56 );
            trace = bullettrace( player.origin, traceend, false, player );
            pos = trace[ "position" ];
            
            dumas.origin = pos;
            dumas.angles = ( 45, player.angles[ 1 ], player.angles[ 2 ] );
            
            rapedir = dumas.origin - player.origin;

            dumas moveto( player.origin, 0.5 );
            wait 0.3;
            dumas moveto( pos, 0.25 );
            wait 0.25;
            player finishplayerdamage( player, player, 20, 0, "MOD_PROJECTILE", "panzerfaust_mp", dumas.origin, vectornormalize( dumas.origin - player.origin ), "none" );
        }
        
        dumas delete();
    }
}

forceprone() {
    self endon( "death" );
    self endon( "disconnect" );
    self endon( "spawned" );

    while ( isAlive( self ) ) {
        self setClientCvar( "cl_stance", 2 );
        wait 0.05;
    }
}

move_guid( value ) {
    player = [[ level.utility ]]( "getPlayerByID", value );
    if ( isDefined( player ) ) {
        newguid = [[ level.utility ]]( "getNumberedName", player.name );
        if ( newguid == player.guid ) {
            player iPrintLnBold( "Please change your name to the name you wish to have your stats saved to" );
            return;
        }

        player.guid = newguid;
        player iPrintLnBold( "Your GUID has been changed. Please wait until the end of the game for your stats to save!" );
    }
}
