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

init() {
    [[ level.logwrite ]]( "maps\\mp\\gametypes\\_skins.gsc::init()", true );

    level.playermodels = [];

// allied faces
    allied_faces = [];
    allied_faces[ 0 ] = "basehead_01";
    allied_faces[ 1 ] = "basehead2_02";
    allied_faces[ 2 ] = "basehead3_03";
    allied_faces[ 3 ] = "basehead4_04";
    allied_faces[ 4 ] = "basehead5_05";
    allied_faces[ 5 ] = "basehead_06";
    allied_faces[ 6 ] = "basehead_07";
    allied_faces[ 7 ] = "basehead2_08";
    allied_faces[ 8 ] = "basehead3_09";
    allied_faces[ 9 ] = "basehead4_a_10";
    allied_faces[ 10 ] = "basehead5_a_01";
    allied_faces[ 11 ] = "basehead_a_02";
    allied_faces[ 12 ] = "basehead2_a_03";
    allied_faces[ 13 ] = "basehead3_a_04";
    allied_faces[ 14 ] = "basehead4_a_05";
    allied_faces[ 15 ] = "basehead5_a_06";
    allied_faces[ 16 ] = "basehead_a_07";
    allied_faces[ 17 ] = "basehead_a_08";
    allied_faces[ 18 ] = "basehead2_a_09";
    allied_faces[ 19 ] = "basehead3_a_10";
    precacheModelArray( allied_faces );
// allied faces

// axis faces
    axis_faces = [];
    axis_faces[ 0 ] = "basehead_axis_a_01";
    axis_faces[ 1 ] = "basehead_axis_a_02";
    axis_faces[ 2 ] = "basehead_axis_a_03";
    axis_faces[ 3 ] = "basehead_axis_a_04";
    axis_faces[ 4 ] = "basehead_axis_a_05";
    axis_faces[ 5 ] = "basehead_axis_a_06";
    axis_faces[ 6 ] = "basehead_axis_a_07";
    axis_faces[ 7 ] = "basehead_axis_a_08";
    axis_faces[ 8 ] = "basehead_axis_a_09";
    axis_faces[ 9 ] = "basehead_axis_a_10";
    axis_faces[ 10 ] = "basehead_axis_b_01";
    axis_faces[ 11 ] = "basehead_axis_b_09";
    axis_faces[ 12 ] = "basehead_axis_b_02";
    axis_faces[ 13 ] = "basehead_axis_b_03";
    axis_faces[ 14 ] = "basehead_axis_b_05";
    axis_faces[ 15 ] = "basehead_axis_b_04";
    axis_faces[ 16 ] = "basehead_axis_b_06";
    axis_faces[ 17 ] = "basehead_axis_b_07";
    axis_faces[ 18 ] = "basehead_axis_b_08";
    axis_faces[ 19 ] = "basehead_axis_b_10";
    precacheModelArray( axis_faces );
// axis faces

// american airborne
    american_airborne_hats = [];
    american_airborne_hats[ 0 ] = "USAirborneHelmet";
    precacheModelArray( american_airborne_hats );

    american_airborne_gear = [];
    american_airborne_gear[ 0 ] = "gear_US_load1";
    american_airborne_gear[ 1 ] = "gear_US_load2";
    american_airborne_gear[ 2 ] = "gear_US_load3";
    american_airborne_gear[ 3 ] = "gear_US_bandolier";
    american_airborne_gear[ 4 ] = "gear_US_ammobelt";
    american_airborne_gear[ 5 ] = "gear_US_frntgnrc";
    american_airborne_gear[ 6 ] = "gear_US_frntknklknfe";
    precacheModelArray( american_airborne_gear );

    addPlayerModel( "american",  "playerbody_american_airborne",             "normal",      "viewmodel_hands_us",                   allied_faces,   american_airborne_hats,         american_airborne_gear );
    addPlayerModel( "american",  "playerbody_american_airborne_winter",      "winter",      "viewmodel_hands_uswinter",             allied_faces,   american_airborne_hats,         american_airborne_gear );
// american airborne

// british airborne
    british_airborne_hats = [];
    british_airborne_hats[ 0 ] = "helmet_british_airborne";
    precacheModelArray( british_airborne_hats );

    british_airborne_gear = [];
    british_airborne_gear[ 0 ] = "gear_british_air";
    precacheModelArray( british_airborne_gear );

    addPlayerModel( "british",   "playerbody_british_airborne",              "normal",      "viewmodel_hands_british_air",          allied_faces,   british_airborne_hats,          british_airborne_gear );
// british airborne

// british commando
    british_commando_hats = [];
    british_commando_hats[ 0 ] = "equipment_british_beret_red";
    british_commando_hats[ 1 ] = "equipment_british_beret_green";
    precacheModelArray( british_commando_hats );

    british_commando_gear = [];
    british_commando_gear[ 0 ] = "gear_british_shirt";
    british_commando_gear[ 1 ] = "gear_british_vest";
    precacheModelArray( british_commando_gear );

    addPlayerModel( "british",   "playerbody_british_commando",              "normal",      "viewmodel_hands_british",              allied_faces,   british_commando_hats,          british_commando_gear );
    addPlayerModel( "british",   "playerbody_british_commando_winter",       "winter",      "viewmodel_hands_british",              allied_faces,   british_commando_hats,          british_commando_gear );
// british commando

// german fallschirmjager
    german_fallschirmjager_hats = [];
    german_fallschirmjager_hats[ 0 ] = "germanFallschirmHelmet";
    german_fallschirmjager_hats[ 1 ] = "gear_german_helmet_falshrm_camo";
    german_fallschirmjager_hats[ 2 ] = "gear_german_helmet_falshrm_blk";
    precacheModelArray( german_fallschirmjager_hats );

    german_fallschirmjager_gear = [];
    german_fallschirmjager_gear[ 0 ] = "gear_german_load1_falshrm";
    german_fallschirmjager_gear[ 1 ] = "gear_german_load2_falshrm";
    german_fallschirmjager_gear[ 2 ] = "gear_german_load3_falshrm";
    german_fallschirmjager_gear[ 3 ] = "gear_german_bandolier";
    precacheModelArray( german_fallschirmjager_gear );

    addPlayerModel( "german",    "playerbody_german_fallschirmjagercamo",    "normal",      "viewmodel_hands_fallschirmjager",      axis_faces,     german_fallschirmjager_hats,    german_fallschirmjager_gear );
    addPlayerModel( "german",    "playerbody_german_fallschirmjagergrey",    "normal",      "viewmodel_hands_fallschirmjager_grey", axis_faces,     german_fallschirmjager_hats,    german_fallschirmjager_gear );
// german fallschirmjager

// german kriegsmarine
//addPlayerModel( "german",    "playerbody_german_kriegsmarine",           "normal" );
// german kriegsmarine

// german waffen
    german_waffen_hats = [];
    german_waffen_hats[ 0 ] = "gear_german_helmet_waffen";
    german_waffen_hats[ 1 ] = "germanhelmet";
    precacheModelArray( german_waffen_hats );

    german_waffen_gear = [];
    german_waffen_gear[ 0 ] = "gear_german_k98_waffen";
    german_waffen_gear[ 1 ] = "gear_german_load3_w";
    german_waffen_gear[ 2 ] = "gear_german_load4_w";
    german_waffen_gear[ 3 ] = "gear_german_load5_w";
    precacheModelArray( german_waffen_gear );

    addPlayerModel( "german",    "playerbody_german_waffen",                 "normal",      "viewmodel_hands_waffen",               axis_faces,     german_waffen_hats,             german_waffen_gear );
    addPlayerModel( "german",    "playerbody_german_waffen_winter",          "winter",      "viewmodel_hands_waffen_winter",        axis_faces,     german_waffen_hats,             german_waffen_gear );
// german waffen

// german wehrmacht
    german_wehrmacht_hats = [];
    german_wehrmacht_hats[ 0 ] = "germanhelmet";
    german_wehrmacht_hats[ 1 ] = "germanhelmet_winter";
    precacheModelArray( german_wehrmacht_hats );

    german_wehrmacht_gear = [];
    german_wehrmacht_gear[ 0 ] = "gear_german_k98_w";
    german_wehrmacht_gear[ 1 ] = "gear_german_load1_w";
    german_wehrmacht_gear[ 2 ] = "gear_german_load2_w";
    german_wehrmacht_gear[ 3 ] = "gear_german_load3_w";
    german_wehrmacht_gear[ 4 ] = "gear_german_load4_w";
    german_wehrmacht_gear[ 5 ] = "gear_german_load5_w";
    precacheModelArray( german_wehrmacht_gear );

    addPlayerModel( "german",    "playerbody_german_wehrmacht",              "normal",      "viewmodel_hands_whermact",             axis_faces,     german_wehrmacht_hats,          german_wehrmacht_gear );
    addPlayerModel( "german",    "playerbody_german_wehrmacht_winter",       "winter",      "viewmodel_hands_whermact_winter",      axis_faces,     german_wehrmacht_hats,          german_wehrmacht_gear );
// german wehrmacht

// russian conscript
    russian_conscript_hats = [];
    russian_conscript_hats[ 0 ] = "sovietequipment_sidecap";
    precacheModelArray( russian_conscript_hats );

    russian_conscript_gear = [];
    russian_conscript_gear[ 0 ] = "gear_russian_load_ocoat";
    russian_conscript_gear[ 1 ] = "gear_russian_ppsh_ocoat";
    russian_conscript_gear[ 2 ] = "gear_russian_pack_ocoat";
    precacheModelArray( russian_conscript_gear );

    addPlayerModel( "russian",   "playerbody_russian_conscript",             "normal",      "viewmodel_hands_russian",              allied_faces,   russian_conscript_hats,         russian_conscript_gear );
    addPlayerModel( "russian",   "playerbody_russian_conscript_winter",      "winter",      "viewmodel_hands_russian",              allied_faces,   russian_conscript_hats,         russian_conscript_gear );
// russian conscript

// russian veteran
    russian_veteran_hats = [];
    russian_veteran_hats[ 0 ] = "sovietequipment_helmet";
    precacheModelArray( russian_veteran_hats );

    russian_veteran_gear = [];
    russian_veteran_gear[ 0 ] = "gear_russian_load_ocoat";
    russian_veteran_gear[ 1 ] = "gear_russian_ppsh_ocoat";
    russian_veteran_gear[ 2 ] = "gear_russian_pack_ocoat";

    addPlayerModel( "russian",   "playerbody_russian_veteran",               "normal",      "viewmodel_hands_russian_vetrn",        allied_faces,   russian_veteran_hats,           russian_veteran_gear );
    addPlayerModel( "russian",   "playerbody_russian_veteran_winter",        "winter",      "viewmodel_hands_russian_vetrn",        allied_faces,   russian_veteran_hats,           russian_veteran_gear  );
// russian veteran

    // cheese
    precacheModel( "xmodel/head_Price" );
    precacheModel( "xmodel/gear_british_price" );

    // crazypanzer
    precacheModel( "xmodel/head_Pavlov" );
    precacheModel( "xmodel/equipment_pavlov_ushanka" );
    
}

precacheModelArray( array ) {
    if ( !isDefined( array ) ) {
        return undefined;
    }

    for ( i = 0; i < array.size; i++ ) {
        precacheModel( "xmodel/" + array[ i ] );
    }
}

getPlayerModels( nationality ) {
    models = [];

    weather = "normal";
    if ( maps\mp\gametypes\_weather::isWinterMap( getCvar( "mapname" ) ) ) {
        weather = "winter";
    }

    for ( i = 0; i < level.playermodels.size; i++ ) {
        m = level.playermodels[ i ];

        if ( m.nationality == nationality && m.weather == weather ) {
            models[ models.size ] = m;
        }
    }

    return models;
}

getPlayerModelByBodyName( bodyname ) {
    if ( !isDefined( bodyname) ) {
        return undefined;
    }

    for ( i = 0; i < level.playermodels.size; i++ ) {
        s = level.playermodels[ i ];

        if ( s.bodyname == bodyname )
            return s;
    }

    return undefined;
}

addPlayerModel( nationality, body, weather, viewmodel, headlist, hatlist, gearlist ) {
    if ( !isDefined( getPlayerModelByBodyName( body ) ) ) {
        precacheModel( "xmodel/" + body );
        precacheModel( "xmodel/" + viewmodel );

        s = spawnstruct();
        s.nationality = nationality;
        s.bodyname = body;
        s.weather = weather;
        s.viewmodel = viewmodel;
        s.headlist = headlist;
        s.hatlist = hatlist;
        s.gearlist = gearlist;

        level.playermodels[ level.playermodels.size ] = s;
    }
}

setPlayerModel( models ) {
    if ( !isDefined( models ) ) {
        iPrintLn( "tried to set model with undefined model arr" );
        return;
    }

    if ( models.size == 0 ) {
        iPrintLn( "no models returned???" );
        return;
    }

    mymodel = models[ randomInt( models.size ) ];
    self setModel( "xmodel/" + mymodel.bodyname );
    self.headmodel = "xmodel/" + mymodel.headlist[ randomInt( mymodel.headlist.size ) ];
    self attach( self.headmodel );
    self setViewModel( "xmodel/" + mymodel.viewmodel );
    self.nationality = mymodel.nationality;

    // no hats or gear for zombies ;)
    if ( self.pers[ "team" ] == "axis" ) {
        self.hatmodel = "xmodel/" + mymodel.hatlist[ randomInt( mymodel.hatlist.size ) ];
        self attach( self.hatmodel );

        if ( randomInt( 100 ) > 50 ) {
            self attach( "xmodel/" + mymodel.gearlist[ randomInt( mymodel.gearlist.size ) ] );
        }
    }
}

main() {
    self detachall();

    // special check beforehand for any cool peeps
    if ( self.pers[ "team" ] == "axis" ) {
        switch ( self.guid ) {
            // cheese
            case 2508:
                self.specialmodel = true;

                self setModel( "xmodel/playerbody_british_commando" );
                self attach( "xmodel/head_Price" );
                self.hatmodel = "xmodel/equipment_british_beret_red";
                self attach( self.hatmodel );
                self setViewmodel( "xmodel/viewmodel_hands_british" );
                self attach( "xmodel/gear_british_price" );
                self.nationality = "british";
                break;
            // crazypanzer
            case 3914:
                self.specialmodel = true;

                self setModel( "xmodel/playerbody_russian_conscript" );
                self attach( "xmodel/head_Pavlov" );
                self.hatmodel = "xmodel/equipment_pavlov_ushanka";
                self attach( self.hatmodel );
                self setViewmodel( "xmodel/viewmodel_hands_russian" );
                self attach( "xmodel/gear_russian_load_ocoat" );
                self attach( "xmodel/gear_russian_ppsh_ocoat" );
                self attach( "xmodel/gear_russian_pack_ocoat" );
                self.nationality = "russian";
                break;
            // everyone else
            default:
                break;
        }
    }

    if ( !self.specialmodel ) {
        // zombies
        if ( self.pers[ "team" ] == "allies" ) {
            self setPlayerModel( getPlayerModels( "british" ) );
        } else {
            flip = randomInt( 100 );

            if ( flip >= 80 ) {
                self setPlayerModel( getPlayerModels( "russian" ) );
            } else if ( flip < 80 && flip > 40 ) {
                self setPlayerModel( getPlayerModels( "german" ) );
            } else {
                self setPlayerModel( getPlayerModels( "american" ) );
            }
        }
    }
/*
    if ( !self.specialmodel ) {
        
        if(self.pers["team"] == "allies")
        {
            self [[game["allies_model"] ]]();
            self.nationality = "british";
        }
        else if(self.pers["team"] == "axis")
        {
            if ( randomInt( 100 ) > 50 )
            {
                self [[game["axis_model"] ]]();
                self.nationality = "german";
            }
            else
            {
                self [[game["axis_model2"] ]]();
                self.nationality = "american";
            }
        }

        self.pers[ "savedmodel" ] = maps\mp\_utility::saveModel();
    }
*/
}
