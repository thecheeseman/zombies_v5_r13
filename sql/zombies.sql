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

DROP DATABASE IF EXISTS `zombies`;
DROP USER 'zombies'@'localhost';

CREATE DATABASE `zombies`;
CREATE USER 'zombies'@'localhost' IDENTIFIED BY 'changeme';     -- change this after import
GRANT ALL ON `zombies`.* TO `zombies`@`localhost`;

USE `zombies`;

/*
    Server Information
*/
DROP TABLE IF EXISTS `server`;
CREATE TABLE `server` (
    `id`                    tinyint(1) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `ip_address`            varchar(16) NOT NULL,
    `port`                  smallint unsigned NOT NULL DEFAULT 28960,
    `hostname`              varchar(32) NOT NULL,

    `zomextended_build`     varchar(64) NOT NULL,
    `zombies_build`         varchar(64) NOT NULL,
    `zombies_last_updated`  varchar(64) NOT NULL,
    `zombies_version`       varchar(64) NOT NULL,
    `zombies_full_version`  varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
    Maps
    Contains useful information for weather.gsc
*/
DROP TABLE IF EXISTS `maps`;
CREATE TABLE `maps` (
    `id`                smallint(3) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `map_name`          varchar(128) NOT NULL,
    `long_name`         varchar(256) NOT NULL,
    `is_stock_map`      tinyint(1) unsigned NOT NULL DEFAULT 0,
    `weather_type`      varchar(64) NOT NULL DEFAULT 'stock',
    `hazard`            varchar(64) NOT NULL DEFAULT 'none',
    `has_night`         tinyint(1) unsigned NOT NULL DEFAULT 1,
    -- `last_mode`         tinyint(1) unsigned NOT NULL DEFAULT 1,
    `override_fast_sky` tinyint(1) unsigned NOT NULL DEFAULT 1
    -- `amount_played`     smallint(4) unsigned NOT NULL DEFAULT 0,
    -- `seconds_played`    int(11) unsigned NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

    /*
        Stock maps
    */
    INSERT INTO `maps` 
        ( map_name,         long_name,      is_stock_map,   weather_type,   hazard,         has_night ) VALUES 
        ( 'mp_brecourt',    'Brecourt',     1,              'radioactive',  'none',         0 ), 
        ( 'mp_carentan',    'Carentan',     1,              'rainy',        'rainstorm',    1 ), 
        ( 'mp_chateau',     'Chateau',      1,              'rainy',        'rainstorm',    1 ),
        ( 'mp_dawnville',   'Dawnville',    1,              'dusty',        'haboob',       1 ),
        ( 'mp_depot',       'Depot',        1,              'dusty',        'haboob',       1 ),
        ( 'mp_harbor',      'Harbor',       1,              'snowy',        'blizzard',     1 ),
        ( 'mp_hurtgen',     'Hurtgen',      1,              'snowy',        'blizzard',     1 ),
        ( 'mp_pavlov',      'Pavlov',       1,              'snowy',        'blizzard',     1 ),
        ( 'mp_powcamp',     'POW Camp',     1,              'rainy',        'rainstorm',    1 ),
        ( 'mp_railyard',    'Railyard',     1,              'snowy',        'blizzard',     1 ),
        ( 'mp_rocket',      'Rocket',       1,              'snowy',        'blizzard',     1 ),
        ( 'mp_ship',        'Ship',         1,              'rainy',        'rainstorm',    1 );

    /* 
        Custom maps included in 
        zombiesmappack and zombiesSUMMERmappack
    */
    INSERT INTO `maps` 
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
        Custom maps included in
        zombiesmappack2016
    */
    INSERT INTO `maps`
        ( map_name,             long_name,              weather_type,   hazard,         has_night ) VALUES
        ( 'brecourt_winter',    'Brecourt (winter)',    'snowy',        'blizzard',     1 ),
        ( 'german_town',        'German Town',          'rainy',        'rainstorm',    1 ),
        ( 'mount35',            'Mount 35',             'snowy',        'blizzard',     1 ),
        ( 'mp_adlerstein',      'Adlerstein',           'foggy',        'haze',         1 ),
        ( 'mp_amberville',      'Amberville',           'rainy',        'rainstorm',    1 ),
        ( 'mp_bazolles_final',  'Bazolles',             'rainy',        'rainstorm',    1 ),
        ( 'mp_bunkermay_n',     'Bunker Mayhem',        'night',        'none',         1 ),
        ( 'mp_falaisevilla',    'Falaise Villa',        'rainy',        'rainstorm',    1 ),
        ( 'mp_maaloy_final',    'Maaloy',               'snowy',        'blizzard',     1 ),
        ( 'mp_wolfsquare_final','Wolfsquare',           'rainy',        'rainstorm',    1 ),
        ( 'mp_woodland',        'Woodlands',            'rainy',        'rainstorm',    1 ),
        ( 'nazifort2',          'Nazi Fort',            'dusty',        'haboob',       1 ),
        ( 'nuenen',             'Nuenen',               'rainy',        'rainstorm',    1 ),
        ( 'severnaya_bunker',   'Severnaya Bunker',     'snowy',        'none',         1 );

    /* 
        Custom for cp_omahgawd to not override r_fastsky :)
    */
    INSERT INTO `maps` ( map_name, long_name, weather_type, hazard, has_night, override_fast_sky ) VALUES
        ( 'cp_omahgawd', 'omahgawd (CP)', 'custom', 'none', 0, 0 );

/*
    Map History
    For use with intelligent map-vote and for statistics :)
*/
DROP TABLE IF EXISTS `map_history`;
CREATE TABLE `map_history` (
    `id`                smallint(3) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `server_id`         tinyint(1) unsigned NOT NULL,
    `map_id`            smallint(3) unsigned NOT NULL,
    `time_ended`        timestamp NOT NULL DEFAULT NOW(),
    `round_length`      smallint(6) unsigned NOT NULL,
    `winner`            varchar(16) NOT NULL,
    `players_at_end`    tinyint(2) unsigned NOT NULL,
    `last_mode`         tinyint(1) unsigned NOT NULL DEFAULT 1,

    FOREIGN KEY ( map_id ) REFERENCES maps( id ) ON DELETE CASCADE,
    FOREIGN KEY ( server_id ) REFERENCES server( id )
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
    Players
*/
DROP TABLE IF EXISTS `players`;
CREATE TABLE `players` (
    `id`                smallint(4) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,

    `name`              varchar(48) NOT NULL,
    `guid`              varchar(32) NOT NULL DEFAULT '',
    `old_guid`          smallint(6) unsigned NOT NULL DEFAULT 0, -- hold over from old version
    `use_password`      tinyint(1) unsigned DEFAULT 0,
    `password`          varchar(64) DEFAULT '',
    `ip_address`        int(11) unsigned NOT NULL,
    `permissions`       tinyint(1) NOT NULL DEFAULT 0,

    `name_list`         varchar(1024),      -- store up to 30 old names
    `ip_address_list`   varchar(1024),      -- store up to 60 old IP's

    `last_seen`         timestamp NOT NULL DEFAULT NOW(),
    `times_joined`      smallint(4) unsigned NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- auto generate a unique GUID for this player on INSERT
DROP TRIGGER IF EXISTS `ins_guid_md5`;
CREATE TRIGGER `ins_guid_md5` BEFORE INSERT ON `players` FOR EACH ROW SET NEW.guid = MD5( UUID() );

/*
    Achievements
*/
DROP TABLE IF EXISTS `achievements`;
CREATE TABLE `achievements` (
    `id`                smallint(4) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,

    `name`              varchar(32) NOT NULL,
    `long_name`         varchar(128) NOT NULL DEFAULT '',
    `description`       varchar(256) NOT NULL DEFAULT '',
    
    `xp_gained`         mediumint(6) unsigned NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

    /*
        Default achievements
    */
    INSERT INTO `achievements` 
    ( name,             long_name,                      description,                            xp_gained   ) VALUES 

-- generic achievements
    -- joined X amount of times                                                                 35,000 XP available
    ( 'joins_1',        'First-Timer',                  'Play Zombies for the first time!',     1000        ),
    ( 'joins_25',       'Casual Player',                'Join 25 times',                        1500        ),
    ( 'joins_100',      'Apprenticeship',               'Join 100 times',                       2500        ),
    ( 'joins_1000',     'Zombies Expert',               'Join 1,000 times',                     5000        ),
    ( 'joins_5000',     'Ultimate Pro',                 'Join 5,000 times',                     10000       ),
    ( 'joins_10000',    'Can\'t Give It Up',            'Join 10,000 times',                    15000       ),

    -- hours played                                                                             40,000 XP available
    ( 'hours_1',        'Gettin\' the Hang of This',    'Play for one hour',                    500         ),
    ( 'hours_10',       'Puttin\' in the Time',         'Play for 10 hours',                    1000        ),
    ( 'hours_24',       'Jack Bauer',                   'Play for 24 hours',                    1500        ),
    ( 'hours_48',       'Two-Day Man',                  'Play for 48 hours',                    2000        ),
    ( 'hours_120',      'Weekday Warrior',              'Play for 120 hours (5 days)',          2500        ),
    ( 'hours_168',      'Master of the Week',           'Play for 168 hours (7 days)',          3000        ),
    ( 'hours_336',      'Fortnight Foresight',          'Play for 336 hours (2 weeks)',         3500        ),
    ( 'hours_504',      'Time\'s on My Side',           'Play for 504 hours (3 weeks)',         4000        ),
    ( 'hours_672',      'Month-Long Fun',               'Play for 672 hours (one month)',       5000        ),
    ( 'hours_1344',     'Two-Month Anniversary',        'Play for 1,344 hours (two months)',    7500        ),
    ( 'hours_2016',     '2016',                         'Play for 2,016 hours (three months)',  9500        ),

    -- distance traveled                                                                        20,000 XP available
    ( 'distance_1',     'Run, Forrest, Run!',           'Run for one kilometer',                1000        ),
    ( 'distance_10',    'Long Distance Run Around',     'Run for 10 kilometers',                2500        ),
    ( 'distance_21',    'Half-Marathon',                'Run for 21 kilometers',                3500        ),
    ( 'distance_42',    'Run is Love, Run is Life',     'Run for 42 kilometers',                5000        ),
    ( 'distance_100',   'Ultra-Marathon',               'Run for 100 kilometers',               8000        ),

    -- medic heal amount                                                                        60,000 XP available
    ( 'heal_100',       'Patch Me Up!',                 'Heal 100 HP',                          100         ),
    ( 'heal_1000',      'What\'s Up Doc?',              'Heal 1,000 HP',                        500         ),
    ( 'heal_2500',      'Surgeon',                      'Heal 2,500 HP',                        1000        ),
    ( 'heal_5000',      'I\'m A Medical Professional',  'Heal 5,000 HP',                        2500        ),
    ( 'heal_10000',     'Medic!',                       'Heal 10,000 HP',                       4000        ),
    ( 'heal_25000',     'Dr. Band-Aid',                 'Heal 25,000 HP',                       6000        ),
    ( 'heal_50000',     'Alternative Medicine',         'Heal 50,000 HP',                       9000        ),
    ( 'heal_100000',    'Battlefield Medic',            'Heal 100,000 HP',                      12000       ),
    ( 'heal_1000000',   'Doc Zombie',                   'Heal 1,000,000 HP',                    24900       ),

-- specific
    -- others
    ( 'beam_me_up',     'Beam Me Up, Scotty!',          'Be dropped by an Admin',               1000        ),

    -- last one
    ( 'end',            'This Is The End',              'Complete all Achievements',            100000      );

/*
    Player Achievements
*/
DROP TABLE IF EXISTS `player_achievements`;
CREATE TABLE `player_achievements` (
    `id`                        smallint(4) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `player_id`                 smallint(4) unsigned NOT NULL,

-- generic achievements
    -- joined X amount of times
    `joins_10`                  tinyint(1) unsigned NOT NULL DEFAULT 0,
    `joins_25`                  tinyint(1) unsigned NOT NULL DEFAULT 0,
    `joins_100`                 tinyint(1) unsigned NOT NULL DEFAULT 0,
    `joins_1000`                tinyint(1) unsigned NOT NULL DEFAULT 0,
    `joins_5000`                tinyint(1) unsigned NOT NULL DEFAULT 0,

    -- hours played
    `hours_1`                   tinyint(1) unsigned NOT NULL DEFAULT 0,
    `hours_10`                  tinyint(1) unsigned NOT NULL DEFAULT 0,
    `hours_24`                  tinyint(1) unsigned NOT NULL DEFAULT 0,
    `hours_48`                  tinyint(1) unsigned NOT NULL DEFAULT 0,
    `hours_120`                 tinyint(1) unsigned NOT NULL DEFAULT 0,
    `hours_168`                 tinyint(1) unsigned NOT NULL DEFAULT 0,
    `hours_336`                 tinyint(1) unsigned NOT NULL DEFAULT 0,
    `hours_504`                 tinyint(1) unsigned NOT NULL DEFAULT 0,
    `hours_672`                 tinyint(1) unsigned NOT NULL DEFAULT 0,
    `hours_1344`                tinyint(1) unsigned NOT NULL DEFAULT 0,
    `hours_2016`                tinyint(1) unsigned NOT NULL DEFAULT 0,

    -- distance traveled
    `distance_1`                tinyint(1) unsigned NOT NULL DEFAULT 0,
    `distance_10`               tinyint(1) unsigned NOT NULL DEFAULT 0,
    `distance_21`               tinyint(1) unsigned NOT NULL DEFAULT 0,
    `distance_42`               tinyint(1) unsigned NOT NULL DEFAULT 0,
    `distance_100`              tinyint(1) unsigned NOT NULL DEFAULT 0,

    -- medic heal amount
    `heal_100`                  tinyint(1) unsigned NOT NULL DEFAULT 0,
    `heal_1000`                 tinyint(1) unsigned NOT NULL DEFAULT 0,
    `heal_2500`                 tinyint(1) unsigned NOT NULL DEFAULT 0,
    `heal_5000`                 tinyint(1) unsigned NOT NULL DEFAULT 0,
    `heal_10000`                tinyint(1) unsigned NOT NULL DEFAULT 0,
    `heal_25000`                tinyint(1) unsigned NOT NULL DEFAULT 0,
    `heal_50000`                tinyint(1) unsigned NOT NULL DEFAULT 0,
    `heal_100000`               tinyint(1) unsigned NOT NULL DEFAULT 0,
    `heal_1000000`              tinyint(1) unsigned NOT NULL DEFAULT 0,

-- specific
    -- others
    `beam_me_up`                tinyint(1) unsigned NOT NULL DEFAULT 0,

    -- last one
    `end`                       tinyint(1) unsigned NOT NULL DEFAULT 0,

    FOREIGN KEY ( player_id ) REFERENCES players( id ) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*
    Player Stats
*/
DROP TABLE IF EXISTS `player_stats`;
CREATE TABLE `player_stats` (
    `id`                        smallint(4) unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `player_id`                 smallint(4) unsigned NOT NULL,

    `seconds_played`            int(11) unsigned NOT NULL DEFAULT 0,

-- zombie stats
    `zombie_xp`                 smallint(6) NOT NULL DEFAULT 0,
    `zombie_rank`               tinyint(2) unsigned NOT NULL DEFAULT 0,

    `total_kills_as_zombie`     smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_deaths_as_zombie`    smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_bashes_as_zombie`    smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_damage_as_zombie`    int(11) unsigned NOT NULL DEFAULT 0,

    `kills_as_jumper_zombie`    smallint(6) unsigned NOT NULL DEFAULT 0,
    `kills_as_fast_zombie`      smallint(6) unsigned NOT NULL DEFAULT 0,
    `kills_as_poison_zombie`    smallint(6) unsigned NOT NULL DEFAULT 0,
    `kills_as_fire_zombie`      smallint(6) unsigned NOT NULL DEFAULT 0,

    `combat_engineer_kills`     smallint(6) unsigned NOT NULL DEFAULT 0,
    `engineer_kills`            smallint(6) unsigned NOT NULL DEFAULT 0,
    `combat_medic_kills`        smallint(6) unsigned NOT NULL DEFAULT 0,
    `medic_kills`               smallint(6) unsigned NOT NULL DEFAULT 0,
    `combat_support_kills`      smallint(6) unsigned NOT NULL DEFAULT 0,
    `support_kills`             smallint(6) unsigned NOT NULL DEFAULT 0,
    `sniper_kills`              smallint(6) unsigned NOT NULL DEFAULT 0,
    `recon_kills`               smallint(6) unsigned NOT NULL DEFAULT 0,
    
    `last_hunter_kills`         smallint(6) unsigned NOT NULL DEFAULT 0,

-- hunter stats
    `hunter_xp`                 mediumint(8) unsigned NOT NULL DEFAULT 0,
    `hunter_rank`               tinyint(2) unsigned NOT NULL DEFAULT 0,
    `hunter_points`             mediumint(8) unsigned NOT NULL DEFAULT 0,

    `total_kills_as_hunter`     smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_deaths_as_hunter`    smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_bashes_as_hunter`    smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_damage_as_hunter`    int(11) unsigned NOT NULL DEFAULT 0,
    `total_headshots`           smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_assists`             smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_shots_fired`         mediumint(8) unsigned NOT NULL DEFAULT 0,
    `total_shots_hit`           mediumint(8) unsigned NOT NULL DEFAULT 0,

    `jumper_zombie_kills`       smallint(6) unsigned NOT NULL DEFAULT 0,
    `fast_zombie_kills`         smallint(6) unsigned NOT NULL DEFAULT 0,
    `poison_zombie_kills`       smallint(6) unsigned NOT NULL DEFAULT 0,
    `fire_zombie_kills`         smallint(6) unsigned NOT NULL DEFAULT 0,

    `kills_as_combat_engineer`  smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_combat_sentry_kills` smallint(6) unsigned NOT NULL DEFAULT 0,
    `kills_as_engineer`         smallint(6) unsigned NOT NULL DEFAULT 0,        
    `total_sentry_kills`        smallint(6) unsigned NOT NULL DEFAULT 0,
    `kills_as_combat_medic`     smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_bleed_damage`        smallint(6) unsigned NOT NULL DEFAULT 0,     -- TODO
    `kills_as_medic`            smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_health_healed`       smallint(6) unsigned NOT NULL DEFAULT 0,
    `kills_as_combat_support`   smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_armor_buffed`        smallint(6) unsigned NOT NULL DEFAULT 0,     -- TODO
    `total_rage_mode_kills`     smallint(6) unsigned NOT NULL DEFAULT 0,     -- TODO
    `kills_as_support`          smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_ammo_given`          smallint(6) unsigned NOT NULL DEFAULT 0,
    `kills_as_sniper`           smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_invisible_time`      smallint(6) unsigned NOT NULL DEFAULT 0,     -- TODO
    `kills_as_recon`            smallint(6) unsigned NOT NULL DEFAULT 0,
    `total_double_jumps`        smallint(6) unsigned NOT NULL DEFAULT 0,     -- TODO
    `times_as_last_hunter`      smallint(6) unsigned NOT NULL DEFAULT 0,

    `kills_as_last_hunter`      smallint(6) unsigned NOT NULL DEFAULT 0,

    FOREIGN KEY ( player_id ) REFERENCES players( id ) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- auto INSERT new rows into zombies.player_stats / zombies.player_achievements when
-- a new player is added to zombies.players
DROP TRIGGER IF EXISTS `ins_player_create_stats`;

delimiter #
CREATE TRIGGER `ins_player_create_stats` AFTER INSERT ON `players` FOR EACH ROW 
BEGIN
    INSERT INTO `player_stats` ( player_id ) VALUES( NEW.id );
    INSERT INTO `player_achievements` ( player_id ) VALUES( NEW.id );
END#
delimiter ;

/*
    Settings
*/
/*
CREATE TABLE settings (
    `id`                    int NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `name` varchar( 128 )   NOT NULL,
    `type` varchar( 16 )    NOT NULL DEFAULT 'int',
    `value` varchar( 256 )  NOT NULL
);*/