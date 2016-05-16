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

//
// spawnGoalStruct()
// spawns a new goal struct
//
spawnGoalStruct() {
    goal = spawnstruct();

    goal.location = ( 0, 0, 0 );
    goal.entity = undefined;
    goal.type = level.kBOT_GT_GENERIC;
    goal.priority = level.kBOT_GP_NORM;

    return goal;
}

setDefaultGoals() {
    self.goals = [];
}

//
// addGoal()
// adds a goal to the bot's list
//
addGoal( type, location_or_entity, priority ) {
    if ( !isDefined( type ) || !isDefined( location_or_entity ) )
        return;

    struct_goal = spawnGoalStruct();

    if ( typeof( location_or_entity ) == "vector" )
        struct_goal.location = location_or_entity;
    else
        struct_goal.entity = location_or_entity;

    if ( isDefined( priority ) )
        struct_goal.priority = priority;

    self.goals[ self.goals.size ] = struct_goal;
}

//
// removeGoal()
// will remove a goal <location_or_entity> with optional
// filter by <priority>
//
removeGoal( location_or_entity, priority ) {
    if ( !isDefined( location_or_entity ) )
        return;

    for ( i = 0; i < self.goals.size; i++ ) {
        goal = self.goals[ i ];

        if ( !isDefined( goal ) )
            continue;

        // if priority is not defined, continue
        // if it is defined, make sure it's equivalent to the one we want to delete
        if ( !isDefined( priority ) || ( isDefined( priority ) && priority == goal.priority ) ) {
            // check for location or entity
            // and then remove if found
            if ( ( typeof( location_or_entity ) == "vector" && goal.location == location_or_entity ) || 
                 ( typeof( location_or_entity ) != "vector" && goal.entity == location_or_entity ) ) {
                self.goals[ i ] = undefined;
                continue;
            }
        }
    }
}

//
// removeAllGoals()
// reset to a blank slate
//
removeAllGoals() {
    for ( i = 0; i < self.goals.size; i++ ) {
        self.goals[ i ] = undefined;
    }
}

//
// getNextGoal()
// sets the bot's next goal, if none, will 
// go for the defaults
//
getNextGoal() {
    if ( self.goals.size == 0 )
        setDefaultGoals();

    // only sort if we've added some goals since last time
    if ( self.goals_needsort )
        sortGoals();

    nextgoal = undefined;
    lasttype = level.kBOT_GT_GENERIC;
    lastpriority = level.kBOT_GP_NONE;
    for ( i = 0; i < self.goals.size; i++ ) {
        goal = self.goals[ i ];

        if ( !isDefined( goal ) )
            continue;

        // find the highest ranking goal
        // players are alway most important
        // player goals with a high priority setting are sought first
        if ( goal.type >= lasttype && goal.priority > lastpriority ) {
            nextgoal = goal;
            lasttype = goal.type;
            lastpriority = goal.priority;
        }
    }

    // couldn't find a goal
    if ( !isDefined( nextgoal ) )
        return;

    self.currentgoal = nextgoal;
    self.currentgoalentity = nextgoal.entity;
}

//
// sortGoals()
// sorts goals by priority, highest first
//
sortGoals() {
    /*
    priority_highest = [];      priority_high = [];
    priority_norm = [];         priority_low = [];
    priority_lowest = [];

    // sort goals
    for ( i = 0; i < self.goals.size; i++ ) {
        goal = self.goals[ i ];

        if ( !isDefined( goal ) )
            continue;

        // delete this goal
        if ( goal.priority == level.kBOT_GP_NONE )
            continue;

        switch ( goal.priority ) {
            case level.kBOT_GP_LOWEST:      priority_lowest [ priority_lowest.size  ] = goal; break;
            case level.kBOT_GP_LOW:         priority_low    [ priority_low.size     ] = goal; break;
            case level.kBOT_GP_NORM:        priority_norm   [ priority_norm.size    ] = goal; break;
            case level.kBOT_GP_HIGH:        priority_high   [ priority_high.size    ] = goal; break;
            case level.kBOT_GP_HIGHEST:     priority_highest[ priority_highest.size ] = goal; break;
            default: 
                continue;
                break;
        }
    }

    goals = [];

    for ( i = 0; i < priority_highest.size; i++ )   goals[ goals.size ] = priority_highest[ i ];
    for ( i = 0; i < priority_high.size; i++ )      goals[ goals.size ] = priority_high[ i ];
    for ( i = 0; i < priority_norm.size; i++ )      goals[ goals.size ] = priority_norm[ i ];
    for ( i = 0; i < priority_low.size; i++ )       goals[ goals.size ] = priority_low[ i ];
    for ( i = 0; i < priority_lowest.size; i++ )    goals[ goals.size ] = priority_lowest[ i ];

    self.goals = goals;*/
}