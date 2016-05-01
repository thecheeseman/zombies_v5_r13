/*
    The MIT License (MIT)

    Copyright (c) 2016 Indy

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    More information can be acquired at https://opensource.org/licenses/MIT
*/

commands() {

    // Add custom commands here
    
    // Permisions:
    // 0 = Guest 1 = VIP 2 = Moderator 3 = Admin 4 = God 

    // Arguments: <cmd> , <call> , <permissions> , <info> , <id-requirement[1]>, <ignore-self [1] | codam-command [-1]> 
    // Guest Commands //
    thread [[ level.chatCallback ]] ( "!buy"           ,   ::buymenu                                , 0 ,  "Buy an item: !buy [item]"                          , 0      );
    thread [[ level.chatCallback ]] ( "!random"        ,   ::buymenu_rnd                            , 0 ,  "Buy a random item: !random"                        , 0      );
    thread [[ level.chatCallback ]] ( "!healthpack"    ,   ::buymenu_hp                             , 0 ,  "Buy a health pack: !healthpack"                    , 0      );
    thread [[ level.chatCallback ]] ( "!stats"         ,   ::zom_stats                              , 0 ,  "Get your current stats: !stats"                    , 0      );
    
    // VIP Commands //
    
    // Mod Commands //
    thread [[ level.chatCallback ]] ( "!spectate"      ,   ::spectate_player                        , 2 ,  "Spectate player: !spectate [player]"               , 1 , 1  );
    
    // Admin Commands //
    thread [[ level.chatCallback ]] ( "!id"            ,   ::getid                                  , 3 ,  "Get GUID: !id [player]"                            , 1      );
    thread [[ level.chatCallback ]] ( "!moveguid"      ,   zombies\admin::move_guid                 , 3 ,  "Change player's guid: !moveguid [player]"          , 1      ); 
    
    thread [[ level.chatCallback ]] ( "!giveks"        ,   zombies\admin::giveks                    , 3 ,  "Give a killstreak: !giveks [player] [killstreak]"  , 1      );
    thread [[ level.chatCallback ]] ( "!givearmor" ,       zombies\admin::givearmor                 , 3 ,  "Give armor: !givearmor [player] [amount]"          , 1      );

    thread [[ level.chatCallback ]] ( "!givexp"        ,   zombies\admin::giveXp                    , 3 ,  "Give XP: !givexp [player] [amount]"                , 1      );
    thread [[ level.chatCallback ]] ( "!givekills"     ,   zombies\admin::giveKills                 , 3 ,  "Give Kills: !givekills [player] [amount]"          , 1      );
    thread [[ level.chatCallback ]] ( "!givepoints"    ,   zombies\admin::givePoints                , 3 ,  "Give Points: !givepoints [player] [amount]"        , 1      );
    thread [[ level.chatCallback ]] ( "!updatexp"      ,   zombies\admin::updatexp                  , 3 ,  "Update XP stats: !updatexp [player]"               , 1      );
    thread [[ level.chatCallback ]] ( "!updatekills"   ,   zombies\admin::updatekills               , 3 ,  "Update Kills stats: !updatekills [player]"         , 1      );
    thread [[ level.chatCallback ]] ( "!forcespec"     ,   zombies\admin::forcespec                 , 3 ,  "Move player to spec: !forcespec [player]"          , 1      );
    
    // God Commands //

}

aliases() {
    // Aliases // 
    commands::addAlias( "!givexp"       , "!gxp"     );
    commands::addAlias( "!givepoints"   , "!gpt"     );
    commands::addAlias( "!givekills"    , "!gki"     );
    commands::addAlias( "!giveks"       , "!gks"     );
    commands::addAlias( "!givearmor"    , "!garm"    );
    commands::addAlias( "!updatexp"     , "!uxp"     );
    commands::addAlias( "!updatekills"  , "!uki"     );
    commands::addAlias( "!buy"          , "!b"       );
    commands::addAlias( "!random"       , "!rnd"     );
    commands::addAlias( "!healthpack"   , "!hp"      );
}

zom_stats ( tok ) {
    player = self;
    
    // looking for another player's stats?
    if ( tok != "" ) {
        // get player
        id = self callback::getByAnyMeans( tok );
        if ( !isDefined( id ) ) {
            return;
        }
        player = utilities::getPlayerById( id );
    }
    
    if ( !isDefined( player.stats ) || player.stats[ "playerName" ] == "" ) {
        self playerMsg( "Could not retrieve stats for " + player.name );
        return;
    }

    // show stats
    player playerMsg( "^3Stats ^7for " + player.name + " ^7( ^3" + player.stats[ "guid" ] + " ^7) ^3:"  );
    player playerMsg( "^6Hunter: ^7" + self.rank +  " ^6|^7 " + self.xp + " XP ^6|^7 " + self.points + " Points ^6|^7 " + self.stats[ "sentryKills" ] + " Sentry Kills" );
    player playerMsg( "^1Zombie: ^7" + self.zomrank +  " ^1|^7 " + self.zomxp + " XP ^1|^7 " );
    player playerMsg( "^5Totals: ^7" + self.stats[ "totalKills" ] + " Kills ^5|^7 " + self.stats[ "totalDeaths" ] + " Deaths ^5|^7 " + self.stats[ "totalDamage" ] + " Damage ^5|^7 " +
                           self.stats[ "totalAssists" ] + " Assists " );
    player playerMsg( "^5Totals: ^7" + self.stats[ "totalBashes" ] + " Bashes ^5|^7 " + self.stats[ "totalHeadshots" ] + " Headshots ^5|^7 " + self.stats[ "totalShotsFired" ] + " Shots Fired ^5|^7 " +
                           self.stats[ "totalShotsHit" ] + " Shots Hit");
}

buymenu( tok ) {
    if ( tok == "" ) {
        self playerMsg( "Buy Menu -- Available items" );
        self playerMsg( "armor (100, 250, 500), explosionarmor (100, 250, 500 or just 'explo'), damage (10 or 25)" );
        self playerMsg( "healthpack (hp), proxy, crate, barrel, panzerfaust, flashbangs, rocket, mortar, artillery" );
        self playerMsg( "gatlin, airstrike, carpetbomb, nuke, or random" );
        return;
    }

    item = tok;
    switch ( item ) {
        case "armor":
        case "armor100":            item = "buy_armor_10"; break;
        case "armor250":            item = "buy_armor_25"; break;
        case "armor500":            item = "buy_armor_50"; break;
        case "explo":
        case "explo100":
        case "explosionarmor":  
        case "explosionarmor100":   item = "buy_explo_10"; break;
        case "explo250":
        case "explosionarmor250":   item = "buy_explo_25"; break;
        case "explo500":
        case "explosionarmor500":   item = "buy_explo_50"; break;
        case "dmg":
        case "dmg10":
        case "damage":
        case "damage10":            item = "buy_damage_10"; break;
        case "dmg25":
        case "damage25":            item = "buy_damage_25"; break;
        case "hp":
        case "health":
        case "healthpack":          item = "buy_healthpack"; break;
        case "proxy":               item = "buy_proxy"; break;
        case "crate":               item = "buy_crate"; break;
        case "barrel":              item = "buy_barrel"; break;
        case "panzer":
        case "panzerfaust":         item = "buy_panzer"; break;
        case "flashbangs":          item = "buy_flashnades"; break;
        case "random":
        case "rocket":
        case "mortar":
        case "artillery":
        case "gatlin":
        case "airstrike":
        case "carpetbomb":
        case "nuke":                break;
        default:                    self playerMsg( "Buy Menu -- unknown item: " + item ); return; break;
    }

    self zombies\buymenu::buymenu( item );
}

buymenu_rnd( tok ) {
    self zombies\buymenu::buymenu( "random" );
}

buymenu_hp( tok ) {
    self zombies\buymenu::buymenu( "buy_healthpack" );
}

spectate_player( tok ) {
    player = utilities::getPlayerById( tok );
    if ( isDefined ( player ) && player.sessionstate == "playing" && player != self ) {
        self.specplayer = player getEntityNumber();
        wait 0.05;
        self [[ level.callbackSpawnSpectator ]]();
    }
}

getid( tok ) {
    player = utilities::getPlayerById( tok );
    if ( isDefined( player ) ) {
        guid = utilities::getNumberedName( player.name );
        self playerMsg( player.name + "^7's ID is " + guid );
    }
}

playerMsg( msg ) {
    self commands::playerMsg( msg );
}
