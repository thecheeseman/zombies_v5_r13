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
    [[ level.logwrite ]]( "zombies\\ranks.gsc::init()", true );
    
    level.hunterRanks = [];
    level.zombieRanks = [];

//  addHunterRanks( rankName,                   startXP,    endXP )
    addHunterRank( "Enlisted",                  0,          100 );
    addHunterRank( "Private",                   100,        293 );
    addHunterRank( "Private First Class",       293,        656 );
    addHunterRank( "Lance Corporal",            656,        1314 );
    addHunterRank( "Corporal",                  1314,       2476 );
    addHunterRank( "Sergeant",                  2476,       4467 );
    addHunterRank( "Master Sergeant",           4467,       7788 );
    addHunterRank( "Sergeant Major",            7788,       13179 );
    addHunterRank( "2nd Lieutenant",            13179,      21715 );
    addHunterRank( "1st Lieutenant",            21715,      34904 );
    addHunterRank( "Captain",                   34904,      54816 );
    addHunterRank( "Major",                     54816,      84214 );
    addHunterRank( "Lieutenant Colonel",        84124,      126706 );
    addHunterRank( "Colonel",                   126706,     186890 );
    addHunterRank( "Brigadier General",         186890,     270497 );
    addHunterRank( "Major General",             270497,     384525 );
    addHunterRank( "Lieutenant General",        384525,     537337 );
    addHunterRank( "General",                   537337,     738737 );
    addHunterRank( "General of the Army",       738737,     1000000 );
    addHunterRank( "Demi-god",                  1000000,    1333858 );
    addHunterRank( "God",                       1333858,    1754435 );
    addHunterRank( "NOT CHUCK NORRIS",          1754435,    2277136 );
    addHunterRank( "FUUUUU!!1",                 2277136,    2918486 );
    addHunterRank( "No Life",                   2918486,    3695928 );
    addHunterRank( "Just Stop Playing",         3695928,    4627587 );
    addHunterRank( "Srsly, wtf mang",           4627587,    5732010 );
    addHunterRank( "Holy fuck tits",            5732010,    7027883 );
    addHunterRank( "You're kidding me",         7027883,    8853852 );
    addHunterRank( "Fuck me in my asshole",     8853852,    10267741 );
    addHunterRank( "IM THE SUPERVISOR",         10267741,   12247287 );
    addHunterRank( "Bagets I",                  12247287,   14488890 );
    addHunterRank( "Bagets II",                 14488890,   17007902 );
    addHunterRank( "Bagets III",                17007902,   19818332 );
    addHunterRank( "Bagets IV",                 19818332,   22932702 );
    addHunterRank( "Bagets V",                  22932702,   26361929 );
    addHunterRank( "God of Zombies",            26361929,   30000000 );
    addHunterRank( "Ultimum Ordinis Venator",   30000000,   2147483647 );

//  addHunterRankPerks( rankName,                           |stickynades    |exploarmor             |ammobonus
//                                                              |healthpacks        |speedmod    
//                                                   |health        |bodyarmor              |damagemod
    addHunterRankPerks( "Enlisted",                  175,   2,  2,  325,    325,    1,      1,      1 );
    addHunterRankPerks( "Private",                   185,   2,  2,  315,    315,    1,      1,      1 );
    addHunterRankPerks( "Private First Class",       195,   2,  2,  305,    305,    1,      1,      1.5 );
    addHunterRankPerks( "Lance Corporal",            210,   2,  2,  290,    290,    1.02,   1.05,   2 );
    addHunterRankPerks( "Corporal",                  235,   2,  3,  265,    265,    1.02,   1.05,   2.5 );
    addHunterRankPerks( "Sergeant",                  260,   2,  3,  240,    240,    1.02,   1.05,   3 );
    addHunterRankPerks( "Master Sergeant",           285,   3,  3,  215,    215,    1.02,   1.05,   3.5 );   
    addHunterRankPerks( "Sergeant Major",            310,   3,  3,  190,    190,    1.05,   1.09,   4 );
    addHunterRankPerks( "2nd Lieutenant",            340,   3,  4,  160,    160,    1.05,   1.09,   4.5 );
    addHunterRankPerks( "1st Lieutenant",            365,   3,  4,  135,    135,    1.05,   1.09,   5 );
    addHunterRankPerks( "Captain",                   390,   4,  4,  110,    110,    1.05,   1.09,   5.5 );
    addHunterRankPerks( "Major",                     415,   4,  4,  95,     95,     1.08,   1.13,   6 );
    addHunterRankPerks( "Lieutenant Colonel",        440,   4,  4,  60,     60,     1.08,   1.13,   6.5 );
    addHunterRankPerks( "Colonel",                   465,   4,  5,  35,     35,     1.08,   1.13,   7 );
    addHunterRankPerks( "Brigadier General",         480,   4,  5,  20,     20,     1.08,   1.13,   7.5 );
    addHunterRankPerks( "Major General",             505,   4,  5,  0,      0,      1.12,   1.18,   8 );
    addHunterRankPerks( "Lieutenant General",        530,   5,  5,  0,      0,      1.12,   1.18,   8.5 );
    addHunterRankPerks( "General",                   555,   5,  6,  0,      0,      1.12,   1.18,   9 );
    addHunterRankPerks( "General of the Army",       580,   6,  6,  0,      0,      1.12,   1.18,   9.5 );
    addHunterRankPerks( "Demi-god",                  610,   6,  7,  0,      0,      1.15,   1.22,   10 );
    addHunterRankPerks( "God",                       640,   7,  7,  0,      0,      1.15,   1.22,   10.5 );
    addHunterRankPerks( "NOT CHUCK NORRIS",          670,   7,  7,  0,      0,      1.15,   1.22,   11 );
    addHunterRankPerks( "FUUUUU!!1",                 700,   7,  7,  0,      0,      1.15,   1.22,   11.5 );
    addHunterRankPerks( "No Life",                   700,   7,  7,  0,      0,      1.15,   1.22,   12 );
    addHunterRankPerks( "Just Stop Playing",         700,   7,  7,  0,      0,      1.15,   1.22,   12.5 );
    addHunterRankPerks( "Srsly, wtf mang",           700,   7,  7,  0,      0,      1.15,   1.22,   13 );
    addHunterRankPerks( "Holy fuck tits",            700,   7,  7,  0,      0,      1.15,   1.22,   13.5 );
    addHunterRankPerks( "You're kidding me",         700,   7,  7,  0,      0,      1.15,   1.22,   14 );
    addHunterRankPerks( "Fuck me in my asshole",     700,   7,  7,  0,      0,      1.15,   1.22,   14.5 );
    addHunterRankPerks( "IM THE SUPERVISOR",         700,   7,  7,  0,      0,      1.15,   1.22,   15 );
    addHunterRankPerks( "Bagets I",                  700,   7,  7,  0,      0,      1.15,   1.22,   15.5 );
    addHunterRankPerks( "Bagets II",                 700,   7,  7,  0,      0,      1.15,   1.22,   16 );
    addHunterRankPerks( "Bagets III",                700,   7,  7,  0,      0,      1.15,   1.22,   16.5 );
    addHunterRankPerks( "Bagets IV",                 700,   7,  7,  0,      0,      1.15,   1.22,   17 );
    addHunterRankPerks( "Bagets V",                  700,   7,  7,  0,      0,      1.15,   1.22,   17.5 );
    addHunterRankPerks( "God of Zombies",            700,   7,  7,  0,      0,      1.15,   1.22,   18 );
    addHunterRankPerks( "Ultimum Ordinis Venator",   700,   7,  7,  0,      0,      1.15,   1.22,   20 );
/*
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
*/
    // addZombieRank( rankName, startXP, endXP )
    addZombieRank( "Innocent",                      0,      1 );
    addZombieRank( "Harmless",                      1,      2 );
    addZombieRank( "Menacing",                      2,      6 );
    addZombieRank( "Noxious",                       6,      11 );
    addZombieRank( "Malignant",                     11,     19 );
    addZombieRank( "Damaging",                      19,     31 );
    addZombieRank( "Sinister",                      31,     47 );
    addZombieRank( "Toxic",                         47,     70 );
    addZombieRank( "Crippling",                     70,     98 );
    addZombieRank( "Corroding",                     98,     134 );
    addZombieRank( "Ominous",                       134,    178 );
    addZombieRank( "Calamitous",                    178,    230 );
    addZombieRank( "Ranksacker",                    230,    289 );
    addZombieRank( "Bomber",                        289,    357 );
    addZombieRank( "Cancer",                        357,    433 );
    addZombieRank( "Demolisher",                    433,    517 );
    addZombieRank( "Vandal",                        517,    607 );
    addZombieRank( "Eradicator",                    607,    704 );
    addZombieRank( "Savage",                        704,    808 );
    addZombieRank( "Exterminator",                  808,    911 );
    addZombieRank( "Bush Did",                      911,    912 );
    addZombieRank( "Slaughterer",                   912,    1031 );
    addZombieRank( "Radiator",                      1031,   1149 );
    addZombieRank( "Butcher",                       1149,   1272 );
    addZombieRank( "Guerilla",                      1272,   1398 );
    addZombieRank( "Annihilator",                   1398,   1527 );
    addZombieRank( "Liquidator",                    1527,   1659 );
    addZombieRank( "Slayer",                        1659,   1793 );
    addZombieRank( "Hunter",                        1793,   1930 );
    addZombieRank( "Cannibal",                      1930,   2068 );
    addZombieRank( "Ruthless",                      2068,   2208 );
    addZombieRank( "Fuckin' Lethal",                2208,   2349 );
    addZombieRank( "Unrelenting",                   2349,   2492 );
    addZombieRank( "Reaper",                        2492,   2635 );
    addZombieRank( "Evil",                          2635,   2780 );
    addZombieRank( "Malefic",                       2780,   2925 );
    addZombieRank( "Devastating",                   2925,   3071 );
    addZombieRank( "Desecrator",                    3071,   3218 );
    addZombieRank( "Smasher",                       3218,   3365 );
    addZombieRank( "Wrecker",                       3365,   3512 );
    addZombieRank( "Extinguisher",                  3512,   3660 );
    addZombieRank( "Decimator",                     3660,   3808 );
    addZombieRank( "Obliterator",                   3808,   3957 );
    addZombieRank( "Depriver",                      3957,   4105 );
    addZombieRank( "Plunderer",                     4105,   4254 );
    addZombieRank( "Marauder",                      4254,   4403 );
    addZombieRank( "Tormentor",                     4403,   4552 );
    addZombieRank( "1337",                          4552,   4702 );
    addZombieRank( "Godly",                         4702,   4851 );
    addZombieRank( "Monster",                       4851,   5000 );
    addZombieRank( "Harbinger of your Salvation",   5000,   10000 );
    addZombieRank( "FUCKING BRUCE LEE",             10000,  2147483647 );
    
    // addZombieRankPerks( <rankName>, <newhealth>, <damagemult>, <resilience>, <zomnadeammo> )
    addZombieRankPerks( "Innocent",                     750,    1.1, 0.05,  5 );
    addZombieRankPerks( "Harmless",                     750,    1.1, 0.05,  5 );
    addZombieRankPerks( "Menacing",                     775,    1.1, 0.05,  5 );
    addZombieRankPerks( "Noxious",                      775,    1.1, 0.05,  5 );
    addZombieRankPerks( "Malignant",                    800,    1.1, 0.05,  6 );
    addZombieRankPerks( "Damaging",                     800,    1.1, 0.05,  6 );
    addZombieRankPerks( "Sinister",                     825,    1.1, 0.05,  6 );
    addZombieRankPerks( "Toxic",                        825,    1.1, 0.05,  6 );
    addZombieRankPerks( "Crippling",                    850,    1.1, 0.1,   7 );
    addZombieRankPerks( "Corroding",                    850,    1.1, 0.1,   7 );
    addZombieRankPerks( "Ominous",                      875,    1.1, 0.1,   7 );
    addZombieRankPerks( "Calamitous",                   875,    1.1, 0.1,   7 );
    addZombieRankPerks( "Ranksacker",                   900,    1.1, 0.1,   8 );
    addZombieRankPerks( "Bomber",                       900,    1.1, 0.15,  8 );
    addZombieRankPerks( "Cancer",                       925,    1.1, 0.15,  8 );
    addZombieRankPerks( "Demolisher",                   925,    1.2, 0.15,  8 );
    addZombieRankPerks( "Vandal",                       950,    1.2, 0.15,  9 );
    addZombieRankPerks( "Eradicator",                   950,    1.2, 0.15,  9 );
    addZombieRankPerks( "Savage",                       975,    1.2, 0.15,  9 );
    addZombieRankPerks( "Exterminator",                 975,    1.2, 0.15,  9 );
    addZombieRankPerks( "Bush Did",                     911,    1.2, 0.15,  9 );
    addZombieRankPerks( "Slaughterer",                  1000,   1.2, 0.15,  10 );
    addZombieRankPerks( "Radiator",                     1000,   1.3, 0.2,   10 );
    addZombieRankPerks( "Butcher",                      1025,   1.3, 0.2,   10 );
    addZombieRankPerks( "Guerilla",                     1025,   1.4, 0.25,  10 );
    addZombieRankPerks( "Annihilator",                  1050,   1.4, 0.25,  11 );
    addZombieRankPerks( "Liquidator",                   1050,   1.5, 0.25,  11 );
    addZombieRankPerks( "Slayer",                       1075,   1.5, 0.25,  11 );
    addZombieRankPerks( "Hunter",                       1075,   1.5, 0.3,   11 );
    addZombieRankPerks( "Cannibal",                     1100,   1.5, 0.3,   12 );
    addZombieRankPerks( "Ruthless",                     1100,   1.5, 0.3,   12 );
    addZombieRankPerks( "Fuckin' Lethal",               1125,   1.6, 0.4,   12 );
    addZombieRankPerks( "Unrelenting",                  1125,   1.6, 0.4,   12 );
    addZombieRankPerks( "Reaper",                       1150,   1.6, 0.45,  13 );
    addZombieRankPerks( "Evil",                         1150,   1.7, 0.45,  13 );
    addZombieRankPerks( "Malefic",                      1175,   1.7, 0.5,   13 );
    addZombieRankPerks( "Devastating",                  1175,   1.7, 0.5,   13 );
    addZombieRankPerks( "Desecrator",                   1200,   1.8, 0.5,   14 );
    addZombieRankPerks( "Smasher",                      1200,   1.8, 0.5,   14 );
    addZombieRankPerks( "Wrecker",                      1225,   1.8, 0.5,   14 );
    addZombieRankPerks( "Extinguisher",                 1225,   1.9, 0.5,   14 );
    addZombieRankPerks( "Decimator",                    1250,   1.9, 0.5,   15 );
    addZombieRankPerks( "Obliterator",                  1250,   2.0, 0.5,   15 );
    addZombieRankPerks( "Depriver",                     1275,   2.0, 0.5,   15 );
    addZombieRankPerks( "Plunderer",                    1275,   2.0, 0.5,   15 );
    addZombieRankPerks( "Marauder",                     1300,   2.0, 0.5,   15 );
    addZombieRankPerks( "Tormentor",                    1300,   2.5, 0.5,   15 );
    addZombieRankPerks( "1337",                         1350,   2.5, 0.5,   15 );
    addZombieRankPerks( "Godly",                        1350,   2.5, 0.5,   15 );
    addZombieRankPerks( "Monster",                      1400,   2.5, 0.5,   15 );
    addZombieRankPerks( "Harbinger of your Salvation",  1500,   3,   0.5,   15 );
    addZombieRankPerks( "FUCKING BRUCE LEE",            10000,  3,   0.5,   15 );
}

addHunterRank( rankName, startXP, endXP, perkFunction )
{
    [[ level.precache ]]( rankName );
    [[ level.precache ]]( toLocalizedString( rankName ) );
    
    id = level.hunterRanks.size;
    level.hunterRanks[ id ] = spawnstruct();
    level.hunterRanks[ id ].id = id;
    level.hunterRanks[ id ].rankName = rankName;
    level.hunterRanks[ id ].rankString = toLocalizedString( rankName );
    level.hunterRanks[ id ].startXP = startXP;
    level.hunterRanks[ id ].endXP = endXP;
    
    if ( isDefined( perkFunction ) )
        level.hunterRanks[ id ].perkFunction = perkFunction;
}

addZombieRank( rankName, startXP, endXP, perkFunction )
{
    [[ level.precache ]]( rankName );
    [[ level.precache ]]( toLocalizedString( rankName ) );
    
    id = level.zombieRanks.size;
    level.zombieRanks[ id ] = spawnstruct();
    level.zombieRanks[ id ].id = id;
    level.zombieRanks[ id ].rankName = rankName;
    level.zombieRanks[ id ].rankString = toLocalizedString( rankName );
    level.zombieRanks[ id ].startXP = startXP;
    level.zombieRanks[ id ].endXP = endXP;
    
    if ( isDefined( perkFunction ) )
        level.hunterRanks[ id ].perkFunction = perkFunction;
}

// addHunterRankPerks( rankName, health, stickynades, healthpacks, bodyarmor, exploarmor, immunitylevel, ammobonus )
addHunterRankPerks( rankName, health, stickynades, healthpacks, bodyarmor, exploarmor, speedmod, damagemod, ammobonus )
{
    perks = spawnstruct();
    perks.health = health;
    perks.stickynades = stickynades;
    perks.healthpacks = healthpacks;
    perks.bodyarmor = bodyarmor;
    perks.exploarmor = exploarmor;

    perks.maxarmor = 0;
    if ( health < 1000 )
        perks.maxarmor = 1000 - health;

    //perks.immunitylevel = immunitylevel;
    perks.immunitylevel = 0;
    perks.speedmod = speedmod;
    perks.damagemod = damagemod;
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
        self.maxarmor = thesePerks.maxarmor;
            
        // some classes have more health than others
        if ( self.maxhealth > newhealth ) {
            prevrank = getRankById( "hunter", self.rank - 1 );

            if ( isDefined( prevrank ) && isDefined( prevrank.rankPerks ) ) {
                diff = self.maxhealth - prevrank.rankPerks.health;
                self.maxhealth = newhealth + diff;
            } else {
                self.maxhealth = newhealth;
            }
        } else {
            self.maxhealth = newhealth;
        }
        
        if ( !level.gamestarted || level.lasthunter )
            self.health = self.maxhealth;

        if ( self.bodyarmor > self.maxarmor )
            self.bodyarmor = self.maxarmor;
        if ( self.exploarmor > self.maxarmor )
            self.exploarmor = self.maxarmor;
            
        //self thread setHeadIcon();
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
        
        // some classes have more health than others
        if ( self.maxhealth > newhealth ) {
            prevrank = getRankByID( "zombie", self.zomrank - 1 );

            if ( isDefined( prevrank ) && isDefined( prevrank.rankPerks ) ) {
                diff = self.maxhealth - prevrank.rankPerks.health;
                self.maxhealth = newhealth + diff;
            } else {
                self.maxhealth = newhealth;
            }
        } else {
            self.maxhealth = newhealth;
        }

        if ( !level.gamestarted )
            self.health = self.maxhealth;
        
        if ( level.firstzombie )
            self setWeaponSlotAmmo( "grenade", self.zomnadeammo + 10 );
        else
            self setWeaponSlotAmmo( "grenade", self.zomnadeammo );
    }
}


/*  Zombie Ranks:
    0   - 0 K : Innocent
    1   - 5 K : Harmless
    2   - 10 K : Menacing
    3   - 15 K : Noxious
    4   - 20 K : Malignant
    5   - 25 K : Damaging
    6   - 30 K : Sinister
    7   - 40 K : Toxic
    8   - 50 K : Crippling
    9   - 60 K : Corroding
    10  - 75 K : Ominous
    11  - 100 K : Calamitous
    12  - 125 K : Ranksacker
    13  - 150 K : Bomber
    14  - 175 K : Cancer
    15  - 200 K : Demolisher
    16  - 250 K : Vandal
    17  - 300 K : Eradicator
    18  - 350 K : Savage
    19  - 400 K : Exterminator
    20  - 450 K : Slaughterer
    21  - 500 K : Radiator
    22  - 600 K : Butcher
    23  - 750 K : Guerilla
    24  - 1000 K : Annihilator
    25  - 1250 K : Liquidator
    26  - 1500 K : Slayer
    27  - 1750 K : Hunter
    28  - 2000 K : Cannibal
    29  - 2250 K : Ruthless
    30  - 2500 K : Fuckin' Lethal
    31  - 2750 K : Unrelenting
    32  - 3000 K : Reaper
    33  - 3250 K : Evil
    34  - 3500 K : Malefic
    35  - 3750 K : Devastating
    36  - 4000 K : Desecrator
    37  - 4250 K : Smasher
    38  - 4500 K : Wrecker
    39  - 5000 K : Extinguisher
    40  - 5500 K : Decimator
    41  - 6000 K : Obliterator
    42  - 7000 K : Depriver
    43  - 8000 K : Plunderer
    44  - 9000 K : Marauder
    45  - 10000 K : Tormentor
    46  - 25000 K : 1337
    47  - 50000 K : Godly
    48  - 75000 K : Monster
    49  - 100000 K : FUCKING BRUCE LEE
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

checkRank()
{
    currentrank = undefined;
    newrank = undefined;

    if ( self.pers[ "team" ] == "axis" )
    {
        if ( self.xp < 0 )
            self.xp = 0;

        currentrank = self.rank;
        rank = getRankByXP( "hunter", self.xp );
        newrank = rank.id;
    }

    if ( self.pers[ "team" ] == "allies" )
    {
        if ( self.zomxp < 0 )
            self.zomxp = 0;
        
        currentrank = self.zomrank;
        rank = getRankByXP( "zombie", self.zomxp );
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
        rank = getRankByID( "hunter", newrank );
        
        ranktext = rank.rankString;
        hudtext = rank.rankName;

        if ( isDefined( self.hud[ "rank" ] ) ) {
            self.hud[ "rank" ] setText( ranktext );
        }
    }
    else if ( self.pers[ "team" ] == "allies" )
    {
        self.zomrank = newrank;
        rank = getRankByID( "zombie", newrank );
        
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
        
        //self iPrintLn( "^2You can change your weapon." );
        
        self thread giveHunterRankPerks();
        
        self.points += level.pointvalues[ "RANKUP" ];
    }
    
    if ( self.pers[ "team" ] == "allies" )
        self thread giveZomRankPerks();
}
