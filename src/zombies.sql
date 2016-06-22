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
    This is the SQL data for generating the necessary 
    Zombies SQL database. You definitely should change 
    the password from `changeme` to something more secure :)
*/

DROP DATABASE `zombies`;
DROP USER `zombies`@'localhost';

CREATE DATABASE `zombies`;
CREATE USER `zombies`@'localhost' IDENTIFIED BY 'changeme';     -- ! CHANGE THIS !
GRANT ALL ON `zombies`.* TO `zombies`@`localhost`;

/*
    Server Information
    This is really just for debug/print purposes
*/
CREATE TABLE server (
    `id`                    INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `ip_address`            VARCHAR( 16 ) NOT NULL,
    `port`                  INT NOT NULL,
    `hostname`              VARCHAR( 32 ) NOT NULL,

    `zomextended_build`     VARCHAR( 64 ) NOT NULL,
    `zombies_build`         VARCHAR( 64 ) NOT NULL,
    `zombies_last_updated`  VARCHAR( 64 ) NOT NULL,
    `zombies_version`       VARCHAR( 64 ) NOT NULL,
    `zombies_full_version`  VARCHAR( 128) NOT NULL
);

/*
    Maps
    Contains useful information for weather.gsc
*/
CREATE TABLE maps (
    `id`                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `map_name`          VARCHAR( 128 ) NOT NULL,
    `long_name`         VARCHAR( 256 ) NOT NULL,
    `weather_type`      VARCHAR( 64 ) NOT NULL DEFAULT 'stock',
    `hazard`            VARCHAR( 64 ) NOT NULL DEFAULT 'none',
    `has_night`         INT NOT NULL DEFAULT 1,
    `last_mode`         INT NOT NULL DEFAULT 1,
    `override_fast_sky` INT NOT NULL DEFAULT 1,
    `amount_played`     INT NOT NULL DEFAULT 0,
    `seconds_played`    INT NOT NULL DEFAULT 0
);

    /*
        Stock maps
    */
    INSERT INTO maps 
        ( map_name,         long_name,      weather_type,   hazard,         has_night ) VALUES 
        ( 'mp_brecourt',    'Brecourt',     'radioactive',  'none',         0 ), 
        ( 'mp_carentan',    'Carentan',     'rainy',        'rainstorm',    1 ), 
        ( 'mp_chateau',     'Chateau',      'rainy',        'rainstorm',    1 ),
        ( 'mp_dawnville',   'Dawnville',    'dusty',        'haboob',       1 ),
        ( 'mp_depot',       'Depot',        'dusty',        'haboob',       1 ),
        ( 'mp_harbor',      'Harbor',       'snowy',        'blizzard',     1 ),
        ( 'mp_hurtgen',     'Hurtgen',      'snowy',        'blizzard',     1 ),
        ( 'mp_pavlov',      'Pavlov',       'snowy',        'blizzard',     1 ),
        ( 'mp_powcamp',     'POW Camp',     'rainy',        'rainstorm',    1 ),
        ( 'mp_railyard',    'Railyard',     'snowy',        'blizzard',     1 ),
        ( 'mp_rocket',      'Rocket',       'snowy',        'blizzard',     1 ),
        ( 'mp_ship',        'Ship',         'rainy',        'rainstorm',    1 );

    /* 
        Custom maps included in 
        zombiesmappack and zombiesSUMMERmappack
    */
    INSERT INTO maps 
        ( map_name,             long_name,              weather_type,   hazard,         has_night ) VALUES 
        ( 'alcatraz',           'Alcatraz',             'rainy',        'rainstorm',    1 ),
        ( 'cp_apartments',      'Apartments (CP)',      'radioactive',  'none',         0 ),
        ( 'cp_banana',          'Banana (CP)',          'custom',       'none',         0 ),
        ( 'cp_sewerzombies',    'Sewer Zombies (CP)',   'custom',       'none',         0 ),
        ( 'cp_shipwreck',       'Shipwreck (CP)',       'rainy',        'rainstorm',    0 ),
        ( 'cp_trainingday',     'Training Day (CP)',    'rainy',        'rainstorm',    1 ),
        ( 'cp_trifles',         'Trifles (CP)',         'custom',       'none',         0 ),
        ( 'cp_zombiebunkers',   'Zombie Bunkers (CP)',  'rainy',        'rainstorm',    1 ),
        ( 'cp_zombies',         'Zombies (CP)',         'custom',       'none',         0 ),
        ( 'germantrainingbase', 'German Training Base', 'rainy',        'none',         1 ),
        ( 'goldeneye_bunker',   'GoldenEye Bunker',     'night',        'none',         1 ),
        ( 'mp_neuville',        'Neuville',             'rainy',        'rainstorm',    1 ),
        ( 'mp_stalingrad',      'Stalingrad',           'snowy',        'blizzard',     1 ),
        ( 'mp_tigertown',       'Tigertown',            'dusty',        'haboob',       1 ),
        ( 'mp_vok_final_night', 'Valley of the Kings',  'dusty',        'haboob',       1 ),
        ( 'quarantine',         'Quarantine',           'rainy',        'rainstorm',    1 ),
        ( 'simon_hai',          'Hai (Simon)',          'night',        'none',         1 ),
        ( 'toybox_bloodbath',   'Toybox',               'night',        'none',         1 );

    /* 
        Custom for cp_omahgawd to not override r_fastsky :)
    */
    INSERT INTO maps ( map_name, long_name, weather_type, hazard, has_night, override_fast_sky ) VALUES
        ( 'cp_omahgawd', 'omahgawd (CP)', 'custom', 'none', 0, 0 );

/*
    Map History
    For use with intelligent map-vote and for statistics :)
*/
CREATE TABLE map_history (
    `id`                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `map_id`            INT NOT NULL,
    `time_ended`        TIMESTAMP DEFAULT NOW(),
    `round_length`      INT NOT NULL,
    `winner`            VARCHAR( 64 ) NOT NULL,
    `players_at_end`    INT NOT NULL,

    FOREIGN KEY ( map_id ) REFERENCES maps( id ) ON DELETE CASCADE
);

/*
    Players
*/
CREATE TABLE players (
    `id`                INT NOT NULL AUTO_INCREMENT PRIMARY KEY,

    `name`              VARCHAR( 48 ) NOT NULL,
    `guid`              INT NOT NULL,         -- hold over from old version
    `ip_address`        VARCHAR( 16 ) NOT NULL,
    `permissions`       INT NOT NULL DEFAULT 0,

    `name_list`         VARCHAR( 1024 ),      -- store up to 30 old names
    `ip_address_list`   VARCHAR( 1024 ),      -- store up to 60 old IP's

    `last_seen`         TIMESTAMP NOT NULL DEFAULT NOW(),
    `times_joined`      INT NOT NULL DEFAULT 0
);

/*
    Player Achievements
*/
CREATE TABLE player_achievements (
    `id`            INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `player_id`     INT NOT NULL,

    FOREIGN KEY ( player_id ) REFERENCES players( id ) ON DELETE CASCADE
);

/*
    Player Stats
*/
CREATE TABLE player_stats (
    `id`                        INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `player_id`                 INT NOT NULL,

    -- generic
    `seconds_played`            INT NOT NULL DEFAULT 0,

    -- last hunter
    `times_as_last_hunter`      INT NOT NULL DEFAULT 0,
    `kills_as_last_hunter`      INT NOT NULL DEFAULT 0,
    `last_hunter_kills`         INT NOT NULL DEFAULT 0,

    -- rank
    `hunter_xp`                 INT NOT NULL DEFAULT 0,
    `hunter_rank`               INT NOT NULL DEFAULT 0,
    `hunter_points`             INT NOT NULL DEFAULT 0,
    `zombie_xp`                 INT NOT NULL DEFAULT 0,
    `zombie_rank`               INT NOT NULL DEFAULT 0,

    -- general stats
    `total_kills`               INT NOT NULL DEFAULT 0,
    `total_deaths`              INT NOT NULL DEFAULT 0,
    `total_bashes`              INT NOT NULL DEFAULT 0,
    `total_damage`              INT NOT NULL DEFAULT 0,
    `total_headshots`           INT NOT NULL DEFAULT 0,
    `total_assists`             INT NOT NULL DEFAULT 0,
    `total_shots_fired`         INT NOT NULL DEFAULT 0,
    `total_shots_hit`           INT NOT NULL DEFAULT 0,

    -- zombie stats
    `kills_as_jumper_zombie`    INT NOT NULL DEFAULT 0,
    `kills_as_fast_zombie`      INT NOT NULL DEFAULT 0,
    `kills_as_poison_zombie`    INT NOT NULL DEFAULT 0,
    `kills_as_fire_zombie`      INT NOT NULL DEFAULT 0,
    `combat_engineer_kills`     INT NOT NULL DEFAULT 0,
    `engineer_kills`            INT NOT NULL DEFAULT 0,
    `combat_medic_kills`        INT NOT NULL DEFAULT 0,
    `medic_kills`               INT NOT NULL DEFAULT 0,
    `combat_support_kills`      INT NOT NULL DEFAULT 0,
    `support_kills`             INT NOT NULL DEFAULT 0,
    `sniper_kills`              INT NOT NULL DEFAULT 0,
    `recon_kills`               INT NOT NULL DEFAULT 0,

    -- hunter stats
    `jumper_zombie_kills`       INT NOT NULL DEFAULT 0,
    `fast_zombie_kills`         INT NOT NULL DEFAULT 0,
    `poison_zombie_kills`       INT NOT NULL DEFAULT 0,
    `fire_zombie_kills`         INT NOT NULL DEFAULT 0,
    `kills_as_combat_engineer`  INT NOT NULL DEFAULT 0,
    `total_combat_sentry_kills` INT NOT NULL DEFAULT 0,
    `kills_as_engineer`         INT NOT NULL DEFAULT 0,        
    `total_sentry_kills`        INT NOT NULL DEFAULT 0,
    `kills_as_combat_medic`     INT NOT NULL DEFAULT 0,
    `total_bleed_damage`        INT NOT NULL DEFAULT 0,     -- TODO
    `kills_as_medic`            INT NOT NULL DEFAULT 0,
    `total_health_healed`       INT NOT NULL DEFAULT 0,
    `kills_as_combat_support`   INT NOT NULL DEFAULT 0,
    `total_armor_buffed`        INT NOT NULL DEFAULT 0,     -- TODO
    `total_rage_mode_kills`     INT NOT NULL DEFAULT 0,     -- TODO
    `kills_as_support`          INT NOT NULL DEFAULT 0,
    `total_ammo_given`          INT NOT NULL DEFAULT 0,
    `kills_as_sniper`           INT NOT NULL DEFAULT 0,
    `total_invisible_time`      INT NOT NULL DEFAULT 0,     -- TODO
    `kills_as_recon`            INT NOT NULL DEFAULT 0,
    `total_double_jumps`        INT NOT NULL DEFAULT 0,     -- TODO

    FOREIGN KEY ( player_id ) REFERENCES players( id ) ON DELETE CASCADE
);

/*
    Settings
*/
CREATE TABLE settings (
    `id`                    INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR( 128 )   NOT NULL,
    `type` VARCHAR( 16 )    NOT NULL DEFAULT 'int',
    `value` VARCHAR( 256 )  NOT NULL
);