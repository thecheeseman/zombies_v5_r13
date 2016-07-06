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

weaponToInt( weap ) {
    switch ( weap ) {
        case "bar_mp":                      return 1;
        case "bar_slow_mp":                 return 2;
        case "bren_mp":                     return 3;
        case "colt_mp":                     return 4;
        case "enfield_mp":                  return 5;
        case "fg42_mp":                     return 6;
        case "fg42_semi_mp":                return 7;
        case "fraggrenade_mp":              return 8;
        case "kar98k_mp":                   return 9;
        case "kar98k_sniper_mp":            return 10;
        case "luger_mp":                    return 11;
        case "m1carbine_mp":                return 12;
        case "m1garand_mp":                 return 13;
        case "mg42_bipod_duck_mp":          return 14;
        case "mg42_bipod_prone_mp":         return 15;
        case "mg42_bipod_stand_mp":         return 16;
        case "mk1britishfrag_mp":           return 17;
        case "mosin_nagant_mp":             return 18;
        case "mosin_nagant_sniper_mp":      return 19;
        case "mp40_mp":                     return 20;
        case "mp44_mp":                     return 21;
        case "mp44_semi_mp":                return 22;
        case "panzerfaust_mp":              return 23;
        case "ppsh_mp":                     return 24;
        case "ppsh_semi_mp":                return 25;
        case "ptrs41_antitank_rifle_mp":    return 26;
        case "rgd-33russianfrag_mp":        return 27;
        case "springfield_mp":              return 28;
        case "sten_mp":                     return 29;
        case "stielhandgranate_mp":         return 30;
        case "thompson_mp":                 return 31;
        case "thompson_semi_mp":            return 32;
    }

    return 0;
}

botLogic() {
    self endon( "bot_death" );
    self endon( "bot_disconnect" );

    // TODO: make this actually work
    //self botlib\goal::removeAllGoals();
    //self botlib\goal::getNextGoal();

    STOP = 0;
    FORWARD = 1;
    BACKWARD = 2;
    RIGHT = 4;
    LEFT = 8;

    PRONE = 2;
    CROUCH = 1;
    STAND = 0;

    self.bot.hasgoal = false;
    self.bot.reachedgoal = false;

    fps = getCvarInt( "sv_fps" );
    stance = "stand";

    self bot_setweapon( weaponToInt( self getCurrentWeapon() ) );   // necessary for the brand new clientcmds 
                                                                    // otherwise it will look like they're not holding any weaps

    self.bot.hasplayer = false;
    self.bot.target = undefined;

    self setContents( 1 );

    frame = 0;
    while ( true ) {
        wait frame();

        frame++;

        if ( !self.bot.hasgoal ) {
            self.bot.goal = botlib\util::findRandomSpawnpoint();

            if ( !isDefined( self.bot.goal ) ) {
                iPrintLn( "no spawnpoints" );
                continue;
            }

            self.bot.hasgoal = true;
        }

        // reached goal
        if ( distance( self.bot.goal, self.origin ) < 24 ) {
            self.bot.hasgoal = false;
            self.bot.goal = undefined;

            self bot_move( STOP );
            iPrintLn( "reached goal" );
            continue;
        }

        if ( frame % 30 == 0 ) {
            if ( self.bot.hasplayer )
                continue;

            if ( !isDefined( self.bot.goal ) ) {
                iPrintLn( "no goal" );
                continue;
            }

            wait frame();
            frame++;

            wps = wp_getXClosest( self.origin, 20 );
            closestdist = 9999999;
            closestwp = undefined;
            for ( i = 0; i < wps.size; i++ ) {
                if ( isDefined( wps[ i ] ) ) {
                    z = wp_getById( wps[ i ] );
                    if ( distance( z[ "position" ], self.origin ) < 24 )
                        continue;

                    if ( distance( z[ "position" ], self.bot.goal ) < closestdist ) {
                        // can we see this wp?
                        if ( self botlib\util::canSee( z[ "position" ] ) ) {
                            closestwp = z[ "position" ];
                            closestdist = distance( z[ "position" ], self.bot.goal );
                        }
                    }
                }
            }

            if ( isDefined( closestwp ) ) {
                iPrintLn( "moving to closest wp " + closestwp );
                self botlib\util::setBotAngles( closestwp - self.origin, 0.5 );
                self bot_move( FORWARD );
            }
        }

        if ( frame % 15 == 0 ) {
            if ( !self.bot.hasplayer ) {
                players = botlib\util::getGoodPlayers();

                for ( i = 0; i < players.size; i++ ) {
                    if ( self botlib\util::canSeePlayer( players[ i ] ) && self botlib\util::isFacingTarget( players[ i ] ) ) {
                        self.bot.hasplayer = true;
                        self.bot.target = players[ i ];
                        break;
                    }
                }
            }

            if ( self.bot.hasplayer ) {
                if ( !self botlib\util::canSeePlayer( self.bot.target ) ) {
                    self.bot.hasplayer = false;
                    self.bot.target = undefined;
                    continue;
                }

                self botlib\util::setBotAngles( self.bot.target.origin - self.origin, 1.5 );

                if ( distance( self.origin, self.bot.target.origin ) < 64 ) {
                    self thread melee();
                }
            }

            if ( !isDefined( self.jumping ) ) {
                if ( stance == "stand" ) {
                    // check if we need to duck or maybe prone
                    traceEnd = self.origin + ( 0, 0, 60 );
                    traceEnd += vectorScale( traceDir, 16 );
                    trace = bulletTrace( self.origin + ( 0, 0, 60 ), traceEnd, true, self );

                    // try crouch
                    if ( trace[ "fraction" ] != 1 ) {
                        traceEnd = self.origin + ( 0, 0, 40 );
                        traceEnd += vectorScale( traceDir, 16 );
                        trace = bulletTrace( self.origin + ( 0, 0, 40 ), traceEnd, true, self );

                        if ( trace[ "fraction" ] == 1 ) {
                            //iPrintLn( "crouch" );
                            self bot_setstance( CROUCH );
                            stance = "crouch";
                        } else {
                            // check if we can prone maybe?
                            traceEnd = self.origin + ( 0, 0, 24 );
                            traceEnd += vectorScale( traceDir, 16 );
                            trace = bulletTrace( self.origin + ( 0, 0, 24 ), traceEnd, true, self );

                            if ( trace[ "fraction" ] == 1 ) {
                                //iPrintLn( "prone" );
                                self bot_setstance( PRONE );
                                stance = "prone";
                            }
                        }
                    }
                } else {
                    // can we stand up here?
                    trace = bullettrace( self.origin, self.origin + ( 0, 0, 72 ), true, self );
                    if ( trace[ "fraction" ] == 1 ) {
                        //iPrintLn( "stand" );
                        self bot_setstance( STAND );
                        stance = "stand";
                    }
                }
            }

            wait frame();
            frame++;
            
            traceDir = anglesToForward( self getPlayerAngles() );
            traceEnd = self.origin + ( 0, 0, 16 );
            traceEnd += vectorScale( traceDir, 16 );
            trace = bulletTrace( self.origin + ( 0, 0, 16 ), traceEnd, true, self );

            // obstructed by something, check if we can jump over it
            if ( trace[ "fraction" ] != 1 ) {
                traceEnd = self.origin + ( 0, 0, 41 );
                traceEnd += vectorScale( traceDir, 40 );
                trace = bulletTrace( self.origin + ( 0, 0, 41 ), traceEnd, true, self );

                // we can, so do so
                if ( trace[ "fraction" ] == 1 ) {
                    //self botcmd( "+gostand; wait 100; -gostand" );
                    // TODO: implement jump
                    //iPrintLn( "would jump here" );
                    self thread jump();
                } 
            }
        }
    }
}

melee() {
    if ( isDefined( self.meleeing ) )
        return;

    self.meleeing = true;

    self bot_melee();
    wait 1;
    self bot_melee( 0 );

    self.meleeing = undefined;
}

jump() {
    if ( isDefined( self.jumping ) )
        return;

    self.jumping = true;

    self bot_jump();
    wait 0.4;
    self bot_jump( 0 );

    self.jumping = undefined;
}
