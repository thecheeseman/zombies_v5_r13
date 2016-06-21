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
    [[ level.logwrite ]]( "zombies\\config.gsc::init()", true );

    [[ level.precache ]]( toLocalizedString( level.zombies_full_version_tag ) );
    [[ level.precache ]]( "Mod by ^3Cheese" );
    [[ level.precache ]]( "Steam^2:^7 thecheeseman999" );
    [[ level.precache ]]( "^5http^7:^5//^71.1^1zom^7bies.com" );

    level.iCVAR_ARCHIVE     = 1;
    level.iCVAR_USERINFO    = 2;
    level.iCVAR_SERVERINFO  = 4;
    level.iCVAR_SYSTEMINFO  = 8;
    level.iCVAR_INIT        = 16;
    level.iCVAR_LATCH       = 32;
    level.iCVAR_ROM         = 64;
    level.iCVAR_CHEAT       = 512;
    level.iCVAR_NORESTART   = 1024;

    setCvarOpt( "^1Zom^7bies",      "by ^3Cheese",                  level.iCVAR_SERVERINFO | level.iCVAR_ROM | level.iCVAR_NORESTART );
    setCvarOpt( "z.build",          level.zombies_build,            level.iCVAR_SERVERINFO | level.iCVAR_ROM | level.iCVAR_NORESTART );
    setCvarOpt( "z.lastupdated",    level.zombies_last_updated,     level.iCVAR_SERVERINFO | level.iCVAR_ROM | level.iCVAR_NORESTART );
    setCvarOpt( "z.version",        level.zombies_version,          level.iCVAR_SERVERINFO | level.iCVAR_ROM | level.iCVAR_NORESTART );

    level.servermessages = [];
    level.welcomemessages = [];
    
    setupValues();
    setupServerMessages();
    setupWelcomeMessages();
}

main() {
    [[ level.logwrite ]]( "zombies\\config.gsc::main()", true );

    thread logo();
    thread runServerMessages();
}

logo() {
    level.logo = newHudElem();
    level.logo.x = 15;
    level.logo.y = 15;
    level.logo.alignx = "left";
    level.logo.aligny = "middle";
    level.logo.fontscale = 0.9;
    level.logo.archived = true;

    while ( 1 )
    {
        level.logo.alpha = 0;
        level.logo setText( toLocalizedString( level.zombies_full_version_tag ) );
        level.logo fadeOverTime( 2 );
        level.logo.alpha = 1;
        
        wait 8;
        
        level.logo fadeOverTime( 2 );
        level.logo.alpha = 0;
        
        wait 2;
        
        level.logo setText( &"Mod by ^3Cheese" );
        level.logo fadeOverTime( 2 );
        level.logo.alpha = 1;
        
        wait 8;
        
        level.logo fadeOverTime( 2 );
        level.logo.alpha = 0;
        
        wait 2;
        
        level.logo setText( &"Steam^2:^7 thecheeseman999" );
        level.logo fadeOverTime( 2 );
        level.logo.alpha = 1;
        
        wait 8;

        level.logo fadeOverTime( 2 );
        level.logo.alpha = 0;
        
        wait 2;
        
        level.logo setText( &"^5https^7:^5//^71.1^1zom^7bies.com" );
        level.logo fadeOverTime( 2 );
        level.logo.alpha = 1;
        
        wait 8;
        
        level.logo fadeOverTime( 2 );
        level.logo.alpha = 0;
        
        wait 2;
    }
}

setupValues()
{
    level.debug =                               (int)cvardef( "zom_debug", 0, 0, 1, "int" );

    level.antispec =                            (int)cvardef( "zom_antispec", 1, 0, 1, "int", true );

    level.timelimit =                           (float)cvardef( "zom_timelimit", 30, 0, 1140, "float", true );
    level.scorelimit = 0;

    setcvar("scr_forcerespawn", "0");
    
    setcvar("scr_friendlyfire", "0");
    level.drawfriend =                          (int)cvardef( "scr_drawfriend", 0, 0, 1, "int", true );

    level.allowvote =                           (int)cvardef( "scr_allow_vote", 0, 0, 1, "int", true );

    level.xpvalues = [];
    level.pointvalues = [];
    level.cvars = [];

    level.cvars[ "STAT_COUNT" ] =               (int)cvardef( "zom_stat_count", 15, 0, 100, "int" );

    increase = 1;
    level.doublepointday =                      (int)cvardef( "zom_xp_doublepointday", 0, 0, 1, "int" );
    if ( level.doublepointday ) {
        increase = 2;
    }
        
    level.xpvalues[ "MOD_EXPLOSIVE" ] =         ( (int)cvardef( "zom_xp_explosive", 25, 0, 100000, "int" ) )        * increase;
    level.xpvalues[ "MOD_EXPLOSIVE_SPLASH" ] =  ( (int)cvardef( "zom_xp_explosive_splash", 25, 0, 100000, "int" ) ) * increase;
    level.xpvalues[ "MOD_GRENADE" ] =           ( (int)cvardef( "zom_xp_grenade", 25, 0, 100000, "int" ) )          * increase;
    level.xpvalues[ "MOD_GRENADE_SPLASH" ] =    ( (int)cvardef( "zom_xp_grenade_splash", 25, 0, 100000, "int" ) )   * increase;
    level.xpvalues[ "MOD_HEAD_SHOT" ] =         ( (int)cvardef( "zom_xp_headshot", 20, 0, 100000, "int" ) )         * increase;
    level.xpvalues[ "MOD_MELEE" ] =             ( (int)cvardef( "zom_xp_melee", 30, 0, 100000, "int" ) )            * increase;
    level.xpvalues[ "MOD_PROJECTILE" ] =        ( (int)cvardef( "zom_xp_projectile", 25, 0, 100000, "int" ) )       * increase;
    level.xpvalues[ "MOD_PROJECTILE_SPLASH" ] = ( (int)cvardef( "zom_xp_projectile_splash", 25, 0, 100000, "int" ) )* increase;
    level.xpvalues[ "MOD_RIFLE_BULLET" ] =      ( (int)cvardef( "zom_xp_rifle_bullet", 10, 0, 100000, "int" ) )     * increase;
    level.xpvalues[ "MOD_PISTOL_BULLET" ] =     ( (int)cvardef( "zom_xp_pistol_bullet", 20, 0, 100000, "int" ) )    * increase;
    level.xpvalues[ "ASSISTS" ] =               ( (int)cvardef( "zom_xp_assists", 10, 0, 100000, "int" ) )          * increase;
    level.xpvalues[ "HUNTER_WIN" ] =            ( (int)cvardef( "zom_xp_hunter_win", 5000, 0, 100000, "int" ) )     * increase;
    level.xpvalues[ "LASTHUNTER" ] =            ( (int)cvardef( "zom_xp_lasthunter", 1000, 0, 100000, "int" ) )     * increase;
    level.xpvalues[ "TIMEALIVE" ] =             ( (int)cvardef( "zom_xp_timealive", 10, 0, 100000, "int" ) )        * increase;
    level.xpvalues[ "enfield_mp" ] =            ( (int)cvardef( "zom_xp_enfield_mp", 25, 0, 100000, "int" ) )       * increase;
    level.xpvalues[ "sten_mp" ] =               ( (int)cvardef( "zom_xp_sten_mp", 10, 0, 100000, "int" ) )          * increase;
    level.xpvalues[ "bren_mp" ] =               ( (int)cvardef( "zom_xp_bren_mp", 35, 0, 100000, "int" ) )          * increase;
    level.xpvalues[ "springfield_mp" ] =        ( (int)cvardef( "zom_xp_springfield_mp", 20, 0, 100000, "int" ) )   * increase;
    level.xpvalues[ "colt_mp" ] =               ( (int)cvardef( "zom_xp_colt_mp", 10, 0, 100000, "int" ) )          * increase;
    level.xpvalues[ "mk1britishfrag_mp" ] =     ( (int)cvardef( "zom_xp_mk1britishfrag_mp", 10, 0, 100000, "int" ) )* increase;
    level.xpvalues[ "medic_heal" ] =            ( (int)cvardef( "zom_xp_medic_heal", 25, 0, 100000, "int" ) )       * increase;
    level.xpvalues[ "support_heal" ] =          ( (int)cvardef( "zom_xp_support_heal", 10, 0, 100000, "int" ) )     * increase;
    
    level.pointvalues[ "KILL" ] =               ( (int)cvardef( "zom_point_kill", 25, 0, 100000, "int" ) )          * increase;
    level.pointvalues[ "ASSISTS" ] =            ( (int)cvardef( "zom_point_assists", 10, 0, 100000, "int" ) )       * increase;
    level.pointvalues[ "HUNTER_WIN" ] =         ( (int)cvardef( "zom_point_hunter_win", 500, 0, 100000, "int" ) )   * increase;
    level.pointvalues[ "LASTHUNTER" ] =         ( (int)cvardef( "zom_point_lasthunter", 100, 0, 100000, "int" ) )   * increase;
    level.pointvalues[ "RANKUP" ] =             ( (int)cvardef( "zom_point_rankup", 25, 0, 100000, "int" ) )        * increase;
    
    level.cvars[ "BOMB_DAMAGE_MAX" ] =          (int)cvardef( "zom_bomb_damage_max", 75, 0, 100000, "int" );
    level.cvars[ "BOMB_DAMAGE_MIN" ] =          (int)cvardef( "zom_bomb_damage_min", 10, 0, 100000, "int" );
    level.cvars[ "BOMB_TIME" ] =                (int)cvardef( "zom_bomb_time", 8, 0, 100000, "int" );
    
    level.cvars[ "MAX_BARRICADES" ] =           (int)cvardef( "zom_max_barricades", 200, 0, 10000, "int" );

    level.cvars[ "JUMPER_DAMAGE" ] =            (int)cvardef( "zom_jumper_damage", 200, 0, 100000, "int" );
    level.cvars[ "JUMPER_FALLDAMAGE" ] =        (int)cvardef( "zom_jumper_falldamage", 1, 0, 1, "int" );

    level.cvars[ "BLOOD_SPLATTER" ] =           (int)cvardef( "zom_bloodsplatter", 4, 0, 10, "int" );

    level.cvars[ "PREGAME_TIME" ] =             (int)cvardef( "zom_pregame_time", 60, 0, 300, "int" );

    level.cvars[ "SERVERMESSAGE_TIME" ] =       (int)cvardef( "zom_servermessage_time", 60, 20, 300, "int" );
}

setupServerMessages()
{
    i = 1;
    while ( getCvar( "zom_servermessage" + i ) != "" )
    {
        level.servermessages[ i - 1 ] = getCvar( "zom_servermessage" + i );
        i++;
    }
}

runServerMessages()
{
    if ( level.servermessages.size == 0 )
        return;
        
    level endon( "endgame" );
    level endon( "intermission" );
        
    i = 0;
    while ( 1 )
    {
        if ( i > level.servermessages.size )
            i = 0;
            
        if ( isDefined( level.servermessages[ i ] ) ) {
            iPrintLn( level.servermessages[ i ] );
        }
            
        wait level.cvars[ "SERVERMESSAGE_TIME" ];
        
        i++;
    }
}

setupWelcomeMessages()
{
    i = 1;
    while ( getCvar( "zom_welcomemessage" + i ) != "" )
    {
        level.welcomemessages[ i - 1 ] = getCvar( "zom_welcomemessage" + i );
        i++;
    }
}

welcomeMessage()
{
    for ( i = 0; i < level.welcomemessages.size; i++ )
    {
        if ( isDefined( level.welcomemessages[ i ] ) ) {
            self iPrintLnBold( level.welcomemessages[ i ] );
        }
        
        wait 2;
    }
}

/*
USAGE OF "cvardef"
cvardef replaces the multiple lines of code used repeatedly in the setup areas of the script.
The function requires 5 parameters, and returns the set value of the specified cvar
Parameters:
    varname - The name of the variable, i.e. "scr_teambalance", or "scr_dem_respawn"
        This function will automatically find map-sensitive overrides, i.e. "src_dem_respawn_mp_brecourt"

    vardefault - The default value for the variable.  
        Numbers do not require quotes, but strings do.  i.e.   10, "10", or "wave"

    min - The minimum value if the variable is an "int" or "float" type
        If there is no minimum, use "" as the parameter in the function call

    max - The maximum value if the variable is an "int" or "float" type
        If there is no maximum, use "" as the parameter in the function call

    type - The type of data to be contained in the vairable.
        "int" - integer value: 1, 2, 3, etc.
        "float" - floating point value: 1.0, 2.5, 10.384, etc.
        "string" - a character string: "wave", "player", "none", etc.
*/
cvardef(varname, vardefault, min, max, type, setifblank)
{
    if ( !isDefined( setifblank) )
        setifblank = true;

    if ( setifblank && getCvar( varname ) == "" )
        setCvar( varname, vardefault );

    switch(type)
    {
        case "int":
            if(getcvar(varname) == "")
                definition = vardefault;
            else
                definition = getcvarint(varname);
            break;
        case "float":
            if(getcvar(varname) == "")
                definition = vardefault;
            else
                definition = getcvarfloat(varname);
            break;
        case "string":
        default:
            if(getcvar(varname) == "")
                definition = vardefault;
            else
                definition = getcvar(varname);
            break;
    }

    if((type == "int" || type == "float") && min != "" && definition < min)
        definition = min;

    if((type == "int" || type == "float") && max != "" && definition > max)
        definition = max;

    return definition;
}