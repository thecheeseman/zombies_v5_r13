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

playerHandler() {
    level endon("intermission");
   
    for(;;)
    {
        self waittill("menuresponse", menu, response);
        
        if(response == "open" || response == "close")
            continue;

        if(menu == game["menu_team"])
        {
            switch(response)
            {
            case "allies":
            case "axis":
            case "autoassign":
                if ( !level.gamestarted )
                    response = "axis";
                else
                    response = "allies";
                
                if(response == self.pers["team"] && self.sessionstate == "playing")
                    break;

                if(response != self.pers["team"] && self.sessionstate == "playing")
                    self suicide();

                self notify("end_respawn");

                self.pers["team"] = response;
                self.pers["weapon"] = undefined;
                self.pers["savedmodel"] = undefined;

                self setClientCvar("scr_showweapontab", "1");

                if(self.pers["team"] == "allies")
                {
                    self setClientCvar("g_scriptMainMenu", game["menu_weapon_allies"]);
                    self openMenu(game["menu_weapon_allies"]);
                }
                else
                {
                    self setClientCvar("g_scriptMainMenu", game["menu_weapon_axis"]);
                    self openMenu(game["menu_weapon_axis"]);
                }
                break;

            case "spectator":
                if(self.pers["team"] != "spectator")
                {
                    if ( level.firstzombie && self.pers[ "team" ] == "allies" ) {
                        self iPrintLnBold( "Please kill someone before going spectate." );
                        continue;
                    }
                    
                    self.pers["team"] = "spectator";
                    self.pers["weapon"] = undefined;
                    self.pers["savedmodel"] = undefined;
                    
                    self.sessionteam = "spectator";
                    self setClientCvar("g_scriptMainMenu", game["menu_team"]);
                    self setClientCvar("scr_showweapontab", "0");
                    [[ level.callbackSpawnSpectator ]]();
                }
                break;

            case "weapon":
                if(self.pers["team"] == "allies")
                    self openMenu(game["menu_weapon_allies"]);
                else if(self.pers["team"] == "axis")
                    self openMenu(game["menu_weapon_axis"]);
                break;
                
            case "viewmap":
                self openMenu(game["menu_viewmap"]);
                break;

            case "callvote":
                self openMenu(game["menu_callvote"]);
                break;
            }
        }       
        else if(menu == game["menu_weapon_allies"] || menu == game["menu_weapon_axis"])
        {
            if(response == "team")
            {
                self openMenu(game["menu_team"]);
                continue;
            }
            else if(response == "viewmap")
            {
                self openMenu(game["menu_viewmap"]);
                continue;
            }
            else if(response == "callvote")
            {
                self openMenu(game["menu_callvote"]);
                continue;
            }
            
            if(!isdefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
                continue;

            weapon = self zombies\_teams::restrict_anyteam(response);

            if(weapon == "restricted")
            {
                self openMenu(menu);
                continue;
            }
            
            if(isdefined(self.pers["weapon"]) && self.pers["weapon"] == weapon)
                continue;
            
            if(!isdefined(self.pers["weapon"]))
            {
                self.pers["weapon"] = weapon;
                [[ level.callbackSpawnPlayer ]]();
            }
            else
            {
                if ( self.pers[ "team" ] == "allies" && isAlive( self ) )
                    self suicide();

                if ( self.pers[ "team" ] == "axis" ) {
                    if ( !level.gamestarted ) {
                        if ( isAlive( self ) )
                            self suicide();
                    } else {
                        self iPrintLn( "^1You cannot change your weapon at this time." );
                        continue;
                    }
                }
                
                oldweap = self.pers[ "weapon" ];
                self.pers["weapon"] = weapon;

                weaponname = zombies\_teams::getWeaponName(self.pers["weapon"]);
            }
        }
        else if(menu == game["menu_viewmap"])
        {
            switch(response)
            {
            case "team":
                self openMenu(game["menu_team"]);
                break;
                
            case "weapon":
                if(self.pers["team"] == "allies")
                    self openMenu(game["menu_weapon_allies"]);
                else if(self.pers["team"] == "axis")
                    self openMenu(game["menu_weapon_axis"]);
                break;

            case "callvote":
                self openMenu(game["menu_callvote"]);
                break;
            }
        }
        else if(menu == game["menu_callvote"])
        {
            if ( response == "team" )
            {
                self openMenu(game["menu_team"]);
                continue;
            }   
            else if ( response == "weapon" )
            {
                if(self.pers["team"] == "allies")
                    self openMenu(game["menu_weapon_allies"]);
                else if(self.pers["team"] == "axis")
                    self openMenu(game["menu_weapon_axis"]);
                continue;
            }
            else if ( response == "viewmap" )
            {
                self openMenu(game["menu_viewmap"]);
                continue;
            }
            
            self zombies\buymenu::buymenu( response );
        }
        else if(menu == game["menu_quickcommands"])
            zombies\_teams::quickcommands(response);
        else if(menu == game["menu_quickstatements"])
            zombies\_teams::quickstatements(response);
        else if(menu == game["menu_quickresponses"])
            zombies\_teams::quickresponses(response);
    }
}