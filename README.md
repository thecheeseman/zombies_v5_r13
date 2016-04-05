# Zombies 

Zombies is a modification for Call of Duty 1.1. It is my take on the classic Zombies gamemodes as seen in many, many other games, but built to work within the limitations and confines of the original Call of Duty. It is meant to act as a (mostly) server-side only modification, requiring no downloads. This version was originally built/"completed" in May of 2011, but I have since resurrected it due to renewed interest by several other parties. I have slowly begun reworking and fixing various bugs, removing old and bad coding habits, and importing new features along the way. 

### Requirements

- Call of Duty version 1.1
- CoDExtended (at least version v20)
- Any flavour of Linux you like

### Some notes

You can probably try and get this working without CoDExtended -- I'm only really using it for file I/O and a few of its functions. I left the original stats saving method (with cvars) in `_stats_legacy.gsc`, so if you really want to work without CoDExtended there are instructions in `_stats.gsc` for getting that working. Otherwise good luck in trying to convert it. I was originally trying to make it work for both, but that's really too much work and I can't be bothered. Sorry.

Feel free to contact me on Steam at [thecheeseman999](http://steamcommunity.com/id/thecheeseman999/) if you have any questions, comments, suggestions, or hate mail.

# To-do

- [ ] Add classes: recon, support, medic, sniper, engineer
    - [X] Recon: double jump
    - [X] Support: mobile ammobox
    - [X] Medic: mobile medic bag
    - [ ] Sniper: something interesting
    - [ ] Engineer: turrets
- [ ] Breakable barricades and turrets
- [ ] Some new buy menu features?
- [ ] ????
- [ ] Profit

# Changelog

#### Legend:
    
    +   new feature
    -   removal
    *   change
    #   fix

#### Revision 13.08
    
    + Added classes from v6 : Recon, Support, Medic
    - Removed the ability to change weapons during the game
    + Added Indy's chat commands

#### Revision 13.07
#### 03/04/16

    * Increase Last Hunter's health by +250
    * Increased M1Carbine's max ammo
    # Fixed a bug where if someone had a special skin, it would be overridden by the default last hunter skin
    * Lasthunter now has updated moveSpeedScale
    # Forgot to remove some debug prints, so those are gone now
    * Upped dynamic timelimit from 12 -> 16 max players to encourage more hunter wins
    + Added Indy's chat commands system
    # Fixed a bug with getBest() function
    # Fixed a crash caused by Zombies changing weapons
    + Flattened all moveSpeedScales in weapon files in favour of using CoDExtended's moveSpeedScale
    + Rewrote and reimplemented old skin system from v5r12 - custom skins for unique player IDs are now in place
    + Redid the CoD skin system for a more varied collection of hunters and zombies
    # Fixed direct grenade hit 25% chance not working

#### Revision 13.06
#### 02/04/16

    + Added a shellshock grenade for fast zombies
    + Added a pushback grenade for jumpers
    * Direct grenade hits now have a 25% chance (instead of 100%) of applying poison, fire, shellshock, or pushback
    # Fixed a bug that allowed hunters to boost timealive XP
    * Changed pre-game time from 45 seconds to 60 seconds and added a cvar option
    * Finally added the 10% armor to the random selection on the buy menu
    * Raised fire FX time so it's not so obnoxious

#### Revision 13.05
#### 01/04/16

    # Fixed some undefined bugs 
    # Fixed the dynamic timelimit not being so dynamic
    + Players now can replenish their healthpacks one at a time at an ammobox
    + Changed dynamic timelimit from a max of 8 players to 12
    + Fog now dynamically adjusts to the timelimit (gets closer faster with less people)
    * Updated Powcamp's fog to be 1600 instead of 1200
    * Changed the RNG with the Random option in the Buy Menu to be more balanced

#### Revision 13.04
#### 31/03/16

    # Fixed quite a few bugs and other problems
    * Completely revised stat saving system to use CoDExtended's file I/O (legacy is still available)    

#### Revision 13.03
#### 30/03/16
    # Fixed at least 13 different bugs / hidden problems 
    - Removed "HUD Stats" from the top right hand corner... no one ever used them :(
    + Dynamic timelimit - <8 players will lower the length of a match to a minimum of 40% of the maximum timelimit
    # Fixed a bug where the new fog would override the endgame fog settings

#### Revision 13.02
#### 29/03/16

    + Added some more shark scanner depths and exploit fixes for custom maps
    + Added exploit fixes from v6 to prevent jumping out of Harbor
    + Added a cvar to control server message display interval
    # Fixed a bug where server messages / welcome messages never displayed
    * Rewrote getBestXXX() functions to be just a single getBest( what ) or getMost( what ) function
    # Finally fixed the bug where players who joined after the game start would have extremely close fog
    - Removed functionality allowing dynamic updating of cvars due to "too many script variables" error

#### Revision 13.01
#### 28/03/16

    # Fixed a crash that could cause an "exceeded maximum number of script variables" error
    * Rewrote the bloodsplatter() function I took from AWE (82 lines -> 50 lines)
    * Went through and cleaned up code / removed commented sections of code, etc. (3368 lines -> 3099 lines)
    + Added "Most Assists" screen at the end of the game along with the other "best of"s
    + Added zom_stat_count to allow an increase in stat cvars without modifying code
    + Stats now use a recursive method instead of bruteforce (stats[x] instead of stats1, stats2, etc)
    * Completely rewrote the saving/loading stats code
    # Fixed a bug where you would not receive points on ranking up
    * Changed the reticule size on damage from 64 to 48
    # Fixed a bug where sv_maprotationcurrent would be set, but mapvote was looking for sv_maprotation
    + Added functionality to allow custom cvars to update dynamically during gameplay
    + Added zom_jumper_falldamage to allow Jumpers to have fall damage (like v6)
    + Added zom_jumper_damage as a height control
    - Removed Mega Jump as it's useless now
    + Added v6's Jumper Zombie mechanics (jump + super jump)
    # Fixed the faulty "server is hung up" message when Nuke is called
    # Hopefully fixed double fire/double poison glitch
    + Added a zombies_debug.cfg for testing purposes
    + Added a zombies.cfg with default values to match _config.gsc
    + Added skins.gsc to the stock pk3 (this was originally there to allow custom skins for GUID's, but I don't have the script anymore so it's just blank for now)
    * Updated scroller in top left to reflect new update

### GNU License

```
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
```
