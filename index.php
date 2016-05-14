<!DOCTYPE html>
<html>

  <head>
    <meta charset='utf-8'>
    <meta http-equiv="X-UA-Compatible" content="chrome=1">
    <meta name="description" content="Zombies : Version 5, Revision 13">

    <link rel="stylesheet" type="text/css" media="screen" href="stylesheets/stylesheet.css">

    <title>Zombies</title>
  </head>

  <body>

    <!-- HEADER -->
    <div id="header_wrap" class="outer">
        <header class="inner">
          <a id="forkme_banner" href="https://github.com/thecheeseman/zombies_v5_r13">View on GitHub</a>

          <h1 id="project_title">Zombies</h1>
          <h2 id="project_tagline">Version 5, Revision 13</h2>

            <section id="downloads">
              <a class="zip_download_link" href="https://github.com/thecheeseman/zombies_v5_r13/zipball/master">Download this project as a .zip file</a>
              <a class="tar_download_link" href="https://github.com/thecheeseman/zombies_v5_r13/tarball/master">Download this project as a tar.gz file</a>
            </section>
        </header>
    </div>

    <!-- MAIN CONTENT -->
    <div id="main_content_wrap" class="outer">
      <section id="main_content" class="inner">
        <h1>
<a id="zombies" class="anchor" href="#zombies" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Zombies</h1>

<p>Zombies is a modification for Call of Duty 1.1. It is my take on the classic Zombies gamemodes as seen in many, many other games, but built to work within the limitations and confines of the original Call of Duty. It is meant to act as a (mostly) server-side only modification, requiring no downloads. This version was originally built/"completed" in May of 2011, but I have since resurrected it due to renewed interest by several other parties. I have slowly begun reworking and fixing various bugs, removing old and bad coding habits, and importing new features along the way. </p>

<h3>
<a id="dumas" class="anchor" href="#dumas" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Dumas Screenshot Challenge</h3>

<p>Click <a href="https://form.jotform.com/61338058171151">here</a> to submit your entry into the contest!</p>

<h3>
<a id="bug-report" class="anchor" href="#bug-report" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Bug Report/Feature Request</h3>

<p>Click <a href="http://goo.gl/forms/yXOYSL3tup">here</a> to submit a bug report or feature request!</p>

<h3>
<a id="buy-menu-and-map-packs" class="anchor" href="#buy-menu-and-map-packs" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Buy Menu and Map Packs</h3>

<p><a href="https://github.com/thecheeseman/zombies_v5_upd/raw/master/buymenu/zombies_addon_points.pk3">Buy Menu</a></p>

<p><a href="https://github.com/thecheeseman/zombies_v5_upd/raw/master/mappacks/zombiesmappack.pk3">Map Pack #1</a></p>
<p><a href="https://github.com/thecheeseman/zombies_v5_upd/raw/master/mappacks/zombiesSUMMERmappack.pk3">Map Pack #2</a></p>

<h3>
<a id="requirements" class="anchor" href="#requirements" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Requirements</h3>

<ul>
<li>Call of Duty version 1.1</li>
<li>CoDExtended (at least version v20)</li>
<li>Any flavour of Linux you like</li>
</ul>

<h3>
<a id="some-notes" class="anchor" href="#some-notes" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Some notes</h3>

<p>You can probably try and get this working without CoDExtended -- I'm only really using it for file I/O and a few of its functions. I left the original stats saving method (with cvars) in <code>_stats_legacy.gsc</code>, so if you really want to work without CoDExtended there are instructions in <code>_stats.gsc</code> for getting that working. Otherwise good luck in trying to convert it. I was originally trying to make it work for both, but that's really too much work and I can't be bothered. Sorry.</p>

<p>Feel free to contact me on Steam at <a href="http://steamcommunity.com/id/thecheeseman999/">thecheeseman999</a> if you have any questions, comments, suggestions, or hate mail.</p>

<h1>
<a id="changelog" class="anchor" href="#changelog" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Changelog</h1>

<h4>
<a id="legend" class="anchor" href="#legend" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Legend:</h4>

<pre><code>+   new feature
-   removal
*   change
#   fix
</code></pre>

<h4>
<a id="revision-1313" class="anchor" href="#revision-1313" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Revision 13.1.3 (wip)</h4>

<h4>
<a id="100416---110416" class="anchor" href="#100416---110416" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>14/04/16 - 18/04/16</h4>

<pre><code>+ Added !spectate command for quick spectating of players
+ Jumper Zombies now take 75% less fall damage than other Zombies
- Hitmarker no longer shows when your sentry shoots a Zombie
# Fixed a bug where Last Hunter would lose their armor 
# Fixed a bug where combatSentryKills would add up incorrectly over time
+ Added !restart and !map commands
+ Added updated version of Indy's chat commands
* Rocket attack no longer throws you if you shoot beneath yourself
* Rocket attack now gives +500 armor/explosion armor
# Fixed a problem where Rocket Attack could drop someone into another player
+ Added buy menu and some other commands to Indy's chat commands
# Fixed a bug/glitch where people could place barrels on ladders and block Zombies
- Fire now only affects Hunters (Zombies can't catch each other on fire)
+ Added Indy's updated chat commands
+ Added a measure to prevent first zombie from spectating (and forcing someone else to be zombie)
+ Added new permission system
* Revised some code to remove too many unnecessary threads
</code></pre>

<h4>
<a id="revision-1312" class="anchor" href="#revision-1312" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Revision 13.1.2</h4>

<h4>
<a id="100416---110416" class="anchor" href="#100416---110416" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>10/04/16 - 13/04/16</h4>

<pre><code>* Upped points / xp received for being last hunter
+ Added back zom_antispec
+ Added the rest of my admin commands from Cato's Jump Mod
- Completely removed the index.dat LUT for stats, instead relying on fexists() now
# Fixed a bug where Rank health was completely screwed up
# Fixed a bug where Sniper invisibility could last for a long period of time
* Increased cooldown time for Sniper invisiblity
* Updated Fade and Majdrew's skin ID's
# Fixed a bug where first zombie wouldn't receive 2000 health
+ Add stats for times played as Last Hunter and Last Hunter kills
+ Add stats: kills for engineers, medics, supports, snipers, recons, and sentries (and their combat cousins)
+ Medics are now immue to poison and fire (up to 200 dmg)
* Combat Snipers can now double tap F to go invisible
* Regular Snipers now have a maximum invisibility time (55 seconds)
+ Add some more Killstreak notification text 
* Buffed the Recon
+ Split Support, Medic, and Engineer into two subclasses (combat versions and regular)
+ Split Sniper into two sub-classes: Combat Sniper and Hidden Sniper
# Fixed a problem where Engineers could get stuck inside their Sentries
</code></pre>

<h4>
<a id="revision-1311" class="anchor" href="#revision-1311" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Revision 13.1.1</h4>

<h4>
<a id="090416" class="anchor" href="#090416" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>09/04/16</h4>

<pre><code># Fixed a bug allowing other classes to become invisible 
# Fixed a bug causing the Sentry Health HUD elem to extend across the screen
# Fixed a bug with class stacking
# Fixed Sentry shot's hit being counted for Player's shot's hit
# Fixed a bug with Sentry kills not tallying correctly
</code></pre>

<h4>
<a id="revision-131" class="anchor" href="#revision-131" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Revision 13.1</h4>

<h4>
<a id="040416---080416" class="anchor" href="#040416---080416" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>04/04/16 - 08/04/16</h4>

<pre><code>* Increased Last Hunter's HP by +150
* Adjusted hitboxes for placing Turrets
* Increased hitboxes for barricades
# Fixed a bug where snipers didn't get double damage for being invisible
# Fixed a bug where sentries could be placed in the air and/or fall down inside of objects
* Lowered Sentry damage from 15 to 7
# Invisible snipers actually can be hit now
+ Targeted Zombies get hit with 2X damage
+ Engineers with the M1Garand can now select a preferred target for their sentry
+ Redid weapon damage according to CP's spec
# Fixed various bugs relating to new additions
+ Added destructible barricades
+ Now when you buy Flashbangs, they will completely replace your regular grenades :)
+ Sniper now does 2X damage when invisible
+ Added Sniper class with special ability: invisibility (active after not moving for 3 seconds)
- Removed "immunity" progress bar as it's basically useless and wasting 2/31 HUD elements
+ Sentries are now movable
+ Sentries have 500 health now instead of 100
* Changed Sentry code around, now Engineer needs to bash to repair - Zombies also do full melee damage to turrets
+ Added new stats: sentryKills
+ Added Engineer class
* Finally updated killstreaks to use CoDExtended's getPlayerAngles() for more accurate locations
# Fixed a potential crash with the Carpet Bomb / Airstrike killstreaks
- Disabled the ability to change classes on the fly - if its before game starts, you'll just commit suicide and change (makes my life so much easier)
* Some slight cosmetic changes with Support / Medic so you don't see the ammobox / medicbag spawning :)
# Fixed a bug where you could have a Medic helmet and not be a Medic
# Fixed a bug that would caues the Recon to double-jump while getting ammo from an ammobox
+ Added a +25 HP bonus if Medic bashes players while healing them
+ Added new stats: timePlayed, joins, hpHealed, ammoHealed
# Fixed a crash that occured when two players joined, the timer started, and left
# Fixed a crash that occured when game tried to force everyone into a gamecam with no last killer
* Changed move speeds of Zombie classes to make them a bit faster
+ Medic now gains XP per 25 health restored
+ Added gained XP message
* Updated Ammoboxes so they don't give you grenades if you're Medic, Support, or Engineer
# Fixed bug where you could be a Medic with Recon abilities
* Upped the Sten's melee time so you can now do 6 bashes per second as opposed to 3
# Fixed Recon's double jump from applying as last hunter
# Fixed Medic's health regen from applying to other classes / last hunter
+ Added classes from v6 : Recon, Support, Medic
- Removed the ability to change weapons during the game
+ Added Indy's chat commands
</code></pre>

<h4>
<a id="revision-1307" class="anchor" href="#revision-1307" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Revision 13.07</h4>

<h4>
<a id="030416" class="anchor" href="#030416" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>03/04/16</h4>

<pre><code>* Increase Last Hunter's health by +250
* Increased M1Carbine's max ammo
# Fixed a bug where if someone had a special skin, it would be overridden by the default last hunter skin
* Lasthunter now has updated moveSpeedScale
# Forgot to remove some debug prints, so those are gone now
* Upped dynamic timelimit from 12 -&gt; 16 max players to encourage more hunter wins
+ Added Indy's chat commands system
# Fixed a bug with getBest() function
# Fixed a crash caused by Zombies changing weapons
+ Flattened all moveSpeedScales in weapon files in favour of using CoDExtended's moveSpeedScale
+ Rewrote and reimplemented old skin system from v5r12 - custom skins for unique player IDs are now in place
+ Redid the CoD skin system for a more varied collection of hunters and zombies
# Fixed direct grenade hit 25% chance not working
</code></pre>

<h4>
<a id="revision-1306" class="anchor" href="#revision-1306" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Revision 13.06</h4>

<h4>
<a id="020416" class="anchor" href="#020416" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>02/04/16</h4>

<pre><code>+ Added a shellshock grenade for fast zombies
+ Added a pushback grenade for jumpers
* Direct grenade hits now have a 25% chance (instead of 100%) of applying poison, fire, shellshock, or pushback
# Fixed a bug that allowed hunters to boost timealive XP
* Changed pre-game time from 45 seconds to 60 seconds and added a cvar option
* Finally added the 10% armor to the random selection on the buy menu
* Raised fire FX time so it's not so obnoxious
</code></pre>

<h4>
<a id="revision-1305" class="anchor" href="#revision-1305" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Revision 13.05</h4>

<h4>
<a id="010416" class="anchor" href="#010416" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>01/04/16</h4>

<pre><code># Fixed some undefined bugs 
# Fixed the dynamic timelimit not being so dynamic
+ Players now can replenish their healthpacks one at a time at an ammobox
+ Changed dynamic timelimit from a max of 8 players to 12
+ Fog now dynamically adjusts to the timelimit (gets closer faster with less people)
* Updated Powcamp's fog to be 1600 instead of 1200
* Changed the RNG with the Random option in the Buy Menu to be more balanced
</code></pre>

<h4>
<a id="revision-1304" class="anchor" href="#revision-1304" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Revision 13.04</h4>

<h4>
<a id="310316" class="anchor" href="#310316" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>31/03/16</h4>

<pre><code># Fixed quite a few bugs and other problems
* Completely revised stat saving system to use CoDExtended's file I/O (legacy is still available)    
</code></pre>

<h4>
<a id="revision-1303" class="anchor" href="#revision-1303" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Revision 13.03</h4>

<h4>
<a id="300316" class="anchor" href="#300316" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>30/03/16</h4>

<pre><code># Fixed at least 13 different bugs / hidden problems 
- Removed "HUD Stats" from the top right hand corner... no one ever used them :(
+ Dynamic timelimit - &lt;8 players will lower the length of a match to a minimum of 40% of the maximum timelimit
# Fixed a bug where the new fog would override the endgame fog settings
</code></pre>

<h4>
<a id="revision-1302" class="anchor" href="#revision-1302" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Revision 13.02</h4>

<h4>
<a id="290316" class="anchor" href="#290316" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>29/03/16</h4>

<pre><code>+ Added some more shark scanner depths and exploit fixes for custom maps
+ Added exploit fixes from v6 to prevent jumping out of Harbor
+ Added a cvar to control server message display interval
# Fixed a bug where server messages / welcome messages never displayed
* Rewrote getBestXXX() functions to be just a single getBest( what ) or getMost( what ) function
# Finally fixed the bug where players who joined after the game start would have extremely close fog
- Removed functionality allowing dynamic updating of cvars due to "too many script variables" error
</code></pre>

<h4>
<a id="revision-1301" class="anchor" href="#revision-1301" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>Revision 13.01</h4>

<h4>
<a id="280316" class="anchor" href="#280316" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>28/03/16</h4>

<pre><code># Fixed a crash that could cause an "exceeded maximum number of script variables" error
* Rewrote the bloodsplatter() function I took from AWE (82 lines -&gt; 50 lines)
* Went through and cleaned up code / removed commented sections of code, etc. (3368 lines -&gt; 3099 lines)
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
</code></pre>

<h3>
<a id="gnu-license" class="anchor" href="#gnu-license" aria-hidden="true"><span aria-hidden="true" class="octicon octicon-link"></span></a>GNU License</h3>

<pre><code>    Zombies, Version 5, Revision 13
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
    along with this program.  If not, see &lt;http://www.gnu.org/licenses/&gt;.
</code></pre>
      </section>
    </div>

    <!-- FOOTER  -->
    <div id="footer_wrap" class="outer">
      <footer class="inner">
        <p class="copyright">Zombies maintained by <a href="https://github.com/thecheeseman">thecheeseman</a></p>
        <p>Published with <a href="https://pages.github.com">GitHub Pages</a></p>
      </footer>
    </div>

    

  </body>
</html>
