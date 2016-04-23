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
    level.utility = ::utility_call;
    level.utilityFunctions = [];

                        // function name    function ptr            paramslist #    types                   required            can be undefined?

    addUtilityFunction( "showpos",          ::showPos                                                                                           );

    addUtilityFunction( "_randomInt",       ::_randomInt,           addParams( 1,   "integer",              "true",             "false"         ) );
    addUtilityFunction( "_randomIntRange",  ::_randomIntRange,      addParams( 2,   "integer,integer",      "true,true",        "false,false"   ) );
    addUtilityFunction( "arrayShuffle",     ::arrayShuffle,         addParams( 1,   "array",                "true",             "false"         ) );
    addUtilityFunction( "atoi",             ::atoi,                 addParams( 1,   "string",               "true",             "false"         ) );
    addUtilityFunction( "contains",         ::contains,             addParams( 2,   "string,string",        "true,true",        "false,false"   ) );
    addUtilityFunction( "cleanString",      ::cleanString,          addParams( 2,   "string,boolean",       "false,false",      "true,true"     ) );
    addUtilityFunction( "charToDigit",      ::charToDigit,          addParams( 1,   "string",               "true",             "false"         ) );
    addUtilityFunction( "distance2D",       ::distance2D,           addParams( 2,   "vector,vector",        "true,true",        "false,false"   ) );
    addUtilityFunction( "endsWith",         ::endsWith,             addParams( 2,   "string,string",        "false,false",      "true,true"     ) );
    addUtilityFunction( "explode",          ::explode,              addParams( 2,   "string,string",        "true,true",        "false,false"   ) );
    addUtilityFunction( "getNumberedName",  ::getNumberedName,      addParams( 2,   "string,boolean",       "false,false",      "false,false"   ) );
    addUtilityFunction( "getPlayerByID",    ::getPlayerByID,        addParams( 1,   "integer",              "true",             "true"          ) );
    addUtilityFunction( "getPlayersOnTeam", ::getPlayersOnTeam,     addParams( 1,   "string",               "true",             "false"         ) );
    addUtilityFunction( "getStance",        ::getStance,            addParams( 1,   "boolean",              "false",            "true"          ) );
    addUtilityFunction( "isChar",           ::isChar,               addParams( 1,   "string",               "true",             "false"         ) );
    addUtilityFunction( "isDigit",          ::isDigit,              addParams( 1,   "string",               "true",             "false"         ) );
    addUtilityFunction( "isSymbol",         ::isSymbol,             addParams( 1,   "string",               "true",             "false"         ) );
    addUtilityFunction( "startsWith",       ::startsWith,           addParams( 2,   "string,string",        "false,false",      "true,true"     ) );
    addUtilityFunction( "strip",            ::strip,                addParams( 1,   "string",               "false",            "true"          ) );
    addUtilityFunction( "strreplacer",      ::strreplacer,          addParams( 2,   "string,string",        "true,true",        "false,false"   ) );
}

addParams( paramCount, paramTypes, required, canBeUndefined ) {
    params = spawnstruct();

    if ( !isDefined( paramCount ) ) {
        params.count = 0;
        params.types = [];
        params.required = [];
        params.undefineds = [];
        return params;
    }
    params.count = paramCount;

    // quick check for type correctness
    paramTypesArr = explode( paramTypes, "," );
    for ( i = 0; i < paramTypesArr.size; i++ ) {
        type = paramTypesArr[ i ];

        switch ( type ) {
            case "integer":
            case "float":
            case "boolean":
            case "string":
            case "localized-string":
            case "vector":
            case "array":
            case "object":
                continue;
            default:
                [[ level.logwrite ]]( "maps\\mp\\gametypes\\_utility.gsc::addParams() -- invalid type : " + type );
                return undefined;
        }
    }
    params.types = paramTypesArr;

    // quick check for required correctness
    requiredArr = explode( required, "," );
    booleanArr = [];
    for ( i = 0; i < requiredArr.size; i++ ) {
        boolean = requiredArr[ i ];

        switch ( boolean ) {
            case "true":
                booleanArr[ booleanArr.size ] = true;
                continue;
            case "false":
                booleanArr[ booleanArr.size ] = false;
                continue;
            default:
                [[ level.logwrite ]]( "maps\\mp\\gametypes\\_utility.gsc::addParams() -- requiredArr - value not boolean : " + boolean );
                return undefined;
        }
    }
    params.required = booleanArr;

    // quick check for undefinedz
    undefinedArr = explode( canBeUndefined, "," );
    undefinedListArr = [];
    for ( i = 0; i < undefinedArr.size; i++ ) {
        boolean = undefinedArr[ i ];

        switch ( boolean ) {
            case "true":
                undefinedListArr[ undefinedListArr.size ] = true;
                continue;
            case "false":
                undefinedListArr[ undefinedListArr.size ] = false;
                continue;
            default:
                [[ level.logwrite ]]( "maps\\mp\\gametypes\\_utility.gsc::addParams() -- undefineds - value not boolean : " + boolean );
                return undefined;
        }
    }
    params.undefineds = undefinedListArr;

    if ( paramTypesArr.size != requiredArr.size ) {
        [[ level.logwrite ]]( "maps\\mp\\gametypes\\_utility.gsc::addParams() -- differing array sizes : " + paramTypesArr.size + " vs " + requiredArr.size );
        return undefined;
    }

    return params;
}

addUtilityFunction( funcName, func, params ) {
    if ( isDefined( getFunction( funcName ) ) )
        return;

    if ( !isDefined( func ) )
        return;

    if ( !isDefined( params ) ) {
        params = spawnstruct();
        params.count = 0;
        params.types = [];
        params.required = [];
        params.undefineds = [];
    }

    function = spawnstruct();
    function.name = funcName;
    function.func = func;
    function.params = params;

    level.utilityFunctions[ level.utilityFunctions.size ] = function;
    [[ level.logwrite ]]( "maps\\mp\\gametypes\\_utility.gsc::addUtilityFunction() -- added function " + funcName + " with " + params.count + " total parameters " );
}

getFunction( name ) {
    if ( !isDefined( name ) )
        return undefined;

    for ( i = 0; i < level.utilityFunctions.size; i++ ) {
        func = level.utilityFunctions[ i ];

        if ( func.name == name )
            return func;
    }

    return undefined;
}

utility_call( name, p0, p1, p2, p3, p4, p5, p6, p7, p8, p9 ) {
    function = getFunction( name );
    if ( !isDefined( function ) ) {
        [[ level.logwrite ]]( "maps\\mp\\gametypes\\_utility.gsc::utility_call() -- tried to call undefined function : " + name );
        return;
    }

    // it's easier to split all the arguments above to an array here
    // than to do it at every single point [[ level.utility ]] is called
    args = [];
    args[ 0 ] = p0; args[ 1 ] = p1; args[ 2 ] = p2; args[ 3 ] = p3;
    args[ 4 ] = p4; args[ 5 ] = p5; args[ 6 ] = p6; args[ 7 ] = p7;
    args[ 8 ] = p8; args[ 9 ] = p9;

    return utility_runner( function, args );
}

utility_runner( function, args ) {
    if ( !isDefined( function ) || !isDefined( args ) )
        return;

    if ( args.size < function.params.count ) {
        [[ level.logwrite ]]( "maps\\mp\\gametypes\\_utility.gsc::utility_runner() -- probably should increase args count higher than : " + function.params.count ) ;
        return undefined;
    }

    totalargs = 0;
    for ( i = 0; i < function.params.count; i++ ) {
        type = function.params.types[ i ];
        required = function.params.required[ i ];
        canBeUndefined = function.params.undefineds[ i ];

        // if a param is left blank, by default it's undefined
        // sometimes though, functions _can_ be passed undefined parameters
        // so we need to check and make sure 
        if ( !isDefined( args[ i ] ) ) {
            // if this parameter isn't required, we'll just stop sending args at this point
            // no reason to send more than necessary
            if ( !required ) {
                break;
            }

            // if we're allowed to have this parameter undefined, that's cool
            if ( canBeUndefined ) {
                totalargs++;
                continue;
            } else {
                [[ level.logwrite ]]( "maps\\mp\\gametypes\\_utility.gsc::utility_runner() -- function " + function.name + " arg " + i + " should not be undefined and is" );
                return undefined;
            }
        }

        // now we'll check if the type matches
        actualtype = typeof( args[ i ] );
        if ( actualtype != type ) {
            okay = false;

            // check to see if we're expecting a boolean
            // but passed something other than integers or floats
            if ( type == "boolean" && ( actualtype != "integer" && actualtype != "float" ) ) {
                [[ level.logwrite ]]( "maps\\mp\\gametypes\\_utility.gsc::utility_runner() -- function " + function.name + " arg " + i + " expects boolean, but received " + actualtype );
                return undefined;
            } else if ( type == "boolean" && ( actualtype == "integer" || actualtype == "float" ) ) {
                okay = true;
            }

            // arrays show up as objects
            if ( type == "array" && actualtype != "object" ) {
                [[ level.logwrite ]]( "maps\\mp\\gametypes\\_utility.gsc::utility_runner() -- function " + function.name + " arg " + i + " expects array, but received " + actualtype );
                return undefined;
            } else if ( type == "array" && actualtype == "object" ) {
                okay = true;
            }

            // try to cast to int
            if ( type == "integer" && actualtype == "string" ) {
                tmp = atoi( args[ i ] );
                if ( isDefined( tmp ) ) {
                    args[ i ] = tmp;
                    okay = true;

                    [[ level.logwrite ]]( "maps\\mp\\gametypes\\_utility.gsc::utility_runner() -- function " + function.name + " arg " + i + " expects integer, but received string : cast succeeded" );
                }
            }

            // try to cast to float
            if ( type == "float" && actualtype == "string" ) {
                tmp = atof( args[ i ] );
                if ( isDefined( tmp ) ) {
                    args[ i ] = tmp;
                    okay = true;

                    [[ level.logwrite ]]( "maps\\mp\\gametypes\\_utility.gsc::utility_runner() -- function " + function.name + " arg " + i + " expects float, but received string : cast succeeded" );
                }
            }

            if ( !okay ) {
                [[ level.logwrite ]]( "maps\\mp\\gametypes\\_utility.gsc::utility_runner() -- function " + function.name + " arg " + i + " expects " + type + ", but received " + actualtype );
                return undefined;
            }
        }

        totalargs++;
    }

    a = [];
    for ( i = 0; i < totalargs; i++ )
        a[ i ] = args[ i ];

    // passed all our preliminary checks
    // let's call the function
    switch ( totalargs ) {
        case 0:     return [[ function.func ]]();
        case 1:     return [[ function.func ]]( a[ 0 ] );
        case 2:     return [[ function.func ]]( a[ 0 ], a[ 1 ] );
        case 3:     return [[ function.func ]]( a[ 0 ], a[ 1 ], a[ 2 ] );
        case 4:     return [[ function.func ]]( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ] );
        case 5:     return [[ function.func ]]( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ], a[ 4 ] );
        case 6:     return [[ function.func ]]( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ], a[ 4 ], a[ 5 ] );
        case 7:     return [[ function.func ]]( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ], a[ 4 ], a[ 5 ], a[ 6 ] );
        case 8:     return [[ function.func ]]( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ], a[ 4 ], a[ 5 ], a[ 6 ], a[ 7 ] );
        case 9:     return [[ function.func ]]( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ], a[ 4 ], a[ 5 ], a[ 6 ], a[ 7 ], a[ 8 ] );
        case 10:    return [[ function.func ]]( a[ 0 ], a[ 1 ], a[ 2 ], a[ 3 ], a[ 4 ], a[ 5 ], a[ 6 ], a[ 7 ], a[ 8 ], a[ 9 ] );
    }
}

// ------------------------------------------------------------------------- //
// utility functions 
// ------------------------------------------------------------------------- //

_randomInt( max ) {
    arr = [];

    for ( i = 0; i < 100; i++ )
        arr[ arr.size ] = randomInt( max );

    arr = arrayShuffle( arr );
    return arr[ randomInt( arr.size ) ];
}

_randomIntRange( min, max ) {
    arr = [];

    for ( i = 0; i < 1024; i++ ) {
        tmp = randomInt( max );
        if ( tmp < min )
            continue;

        arr[ arr.size ] = tmp;
    }

    arr = arrayShuffle( arr );
    return arr[ randomInt( arr.size ) ];
}

/*
_randomInt( iMax )
{
    oArray = [];
    
    for ( i = 0; i < 100; i++ ) 
        oArray[ i ] = randomInt( iMax );
    
    for ( k = 0; k < 50; k++ )
    {
        for ( i = 0; i < oArray.size; i++ )
        {
            j = randomInt( oArray.size );
            oElem = oArray[ i ];
            oArray[ i ] = oArray[ j ];
            oArray[ j ] = oElem;
        }
    }
    
    return oArray[ randomInt( oArray.size ) ];
}

_randomIntRange( min, max ) {
    temparr = [];
    for ( i = 0; i < 1024; i++ )
        temparr[ i ] = randomInt( max );
        
    goods = [];
    for ( i = 0; i < temparr.size; i++ ) {
        if ( temparr[ i ] < min )
            continue;
        goods[ goods.size ] = temparr[ i ];
    }
    
    thisint = goods[ randomInt( goods.size ) ];
    return thisint;
}
*/

arrayShuffle(arr)
{
    for(i = 0; i < arr.size; i++) {
        // Store the current array element in a variable
        _tmp = arr[i];

        // Generate a random number
        rN = randomInt(arr.size);

        // Replace the current with the random
        arr[i] = arr[rN];
        // Replace the random with the current
        arr[rN] = _tmp;
    }
    return arr;
}

atoi( sString ) {
    sString = strreplacer( sString, "numeric" );
    if ( sString == "" )
        return undefined;
    return (int)sString;
}

atof( sString ) {
    sString = strreplacer( sString, "numeric" );
    if ( sString == "" )
        return undefined;
    return (float)sString;
}

charToDigit( ch )
{
    switch ( ch )
    {
        case "a":   return 100; break;  case "b":   return 101; break;
        case "c":   return 102; break;  case "d":   return 103; break;
        case "e":   return 104; break;  case "f":   return 105; break;
        case "g":   return 106; break;  case "h":   return 107; break;
        case "i":   return 108; break;  case "j":   return 109; break;
        case "k":   return 110; break;  case "l":   return 111; break;
        case "m":   return 112; break;  case "n":   return 113; break;
        case "o":   return 114; break;  case "p":   return 115; break;
        case "q":   return 116; break;  case "r":   return 117; break;
        case "s":   return 118; break;  case "t":   return 119; break;
        case "u":   return 120; break;  case "v":   return 121; break;
        case "w":   return 122; break;  case "x":   return 123; break;
        case "y":   return 124; break;  case "z":   return 125; break;
        case "0":   return 126; break;  case "1":   return 127; break;
        case "2":   return 128; break;  case "3":   return 129; break;
        case "4":   return 130; break;  case "5":   return 131; break;
        case "6":   return 132; break;  case "7":   return 133; break;
        case "8":   return 134; break;  case "9":   return 135; break;
        case "-":   return 136; break;  case ">":   return 137; break;
        case "<":   return 138; break;  case "(":   return 139; break;  
        case ")":   return 140; break;  case "!":   return 141; break;  
        case "@":   return 142; break;  case "#":   return 143; break;  
        case "$":   return 144; break;  case "%":   return 145; break;  
        case "&":   return 146; break;  case "*":   return 147; break;  
        case "[":   return 148; break;  case "]":   return 149; break;  
        case "{":   return 150; break;  case "}":   return 151; break;  
        case ":":   return 152; break;  case ".":   return 153; break;  
        case "?":   return 154; break;  case "^":   return 155; break;
        case "A":   return 156; break;  case "B":   return 156; break;
        case "C":   return 157; break;  case "D":   return 158; break;
        case "E":   return 159; break;  case "F":   return 160; break;
        case "G":   return 161; break;  case "H":   return 162; break;
        case "I":   return 163; break;  case "J":   return 164; break;
        case "K":   return 165; break;  case "L":   return 166; break;
        case "M":   return 167; break;  case "N":   return 168; break;
        case "O":   return 169; break;  case "P":   return 170; break;
        case "Q":   return 171; break;  case "R":   return 172; break;
        case "S":   return 173; break;  case "T":   return 174; break;
        case "U":   return 175; break;  case "V":   return 176; break;
        case "W":   return 177; break;  case "X":   return 178; break;
        case "Y":   return 179; break;  case "Z":   return 180; break;
        case "/":   return 181; break;  case "+":   return 182; break;
        case "~":   return 182; break;  case "`":   return 183; break;
        default:    return 0;
    }
}

cleanString( str, ignorespaces )
{
    if ( !isDefined( str ) || str == "" )
        return "";
        
    newstr = "";
    
    for ( i = 0; i < str.size; i++ )
    {
        ch = str[ i ];
        
        if ( isDefined( ignorespaces ) && ignorespaces && ch == " " )
            continue;
            
        if ( !isDigit( ch ) && !isChar( ch ) && !isSymbol( ch ) && ch != " " )
            continue;
            
        newstr += ch;
    }

    return newstr;
}

contains( sString, sOtherString ) {
    if ( sOtherString.size > sString.size )
        return false;
    
    // loop through the string to check
    for ( i = 0; i < sString.size; i++ ) {
        x = 0;
        tmp = "";
        
        // string to check against
        for ( j = 0; j < sOtherString.size; j++ ) {
            cur = sOtherString[ j ];
            
            if ( ( i + j ) >= sString.size )
                break;
                
            //printconsole( "cur = " + sOtherString[j] + " j: " + j +"\n");
                
            next = sString[ i + j ];
            
            if ( cur == next ) {
                tmp += cur;
                x++;
                continue;
            }
            
            break;
        }
        
        // looped through entire string, found it
        if ( x == sOtherString.size && tmp == sOtherString )
            return true;
    }
    
    return false;
}

distance2D( origin1, origin2 ) {
    return distance( ( origin1[ 0 ], origin1[ 1 ], 0 ), ( origin2[ 0 ], origin2[ 1 ], 0 ) );
}

endsWith( string, end ) {
    if ( !isDefined( string ) || !isDefined( end ) )
        return false;

    if ( string == "" || end == "" )
        return false;

    if ( end.size > string.size )
        return false;

    for ( i = 0; i < end.size; i++ ) {
        if ( string[ string.size - 1 - i ] != end[ end.size - 1 - i ] )
            return false;
    }

    return true;
}

explode( s, delimiter, num )
{
    temparr = [];
    
    if ( !isDefined ( s ) || s == "" )
        return temparr;
        
    if ( !isDefined( num ) )
        num = 1024;
        
    j = 0;
    temparr[ j ] = "";  

    for ( i = 0; i < s.size; i++ )
    {
        if ( s[ i ] == delimiter && j < num )
        {
            j++;
            temparr[ j ] = "";
        }
        else
            temparr[ j ] += s[i];
    }
    return temparr;
}

getNumberedName( str, ignorespaces )
{
    if ( !isDefined( str ) || str == "" )
        return "";
        
    int = 0;
    colors = 0;
    symbols = 0;
    
    for ( i = 0; i < str.size; i++ )
    {
        ch = str[ i ];
        
        if ( isDefined( ignorespaces ) && ignorespaces && ch == " " )
            continue;
            
        if ( !isDigit( ch ) && !isChar( ch ) && !isSymbol( ch ) )
            continue;
            
        if ( ch == "^" )
            colors++;
            
        if ( isSymbol( ch ) && ch != "^" )
            symbols++;
            
        int += charToDigit( ch );
    }
    
    if ( str.size % 2 == 0 )
        int += str.size;
    else
        int -= str.size;
        
    int += ( colors * 10 );
    int += ( symbols * 30 );
    
    return int;
}

getMapWeather()
{
    sMapName = toLower( getCvar( "mapname" ) );
    
    switch ( sMapName )
    {
        case "mp_harbor":
        case "mp_pavlov":
        case "mp_hurtgen":
        case "mp_rocket":
        case "mp_railyard":
        case "mp_stalingrad":
            return "winter"; break;
    }
    
    return "normal";
}

getPlayerByID( iID )
{
    eGuy = undefined;
    ePlayers = getEntArray( "player", "classname" );
    for ( i = 0; i < ePlayers.size; i++ )
    {
        if ( !isPlayer( ePlayers[ i ] ) )
            continue;

        if ( ePlayers[ i ] getEntityNumber() == iID )
        {
            eGuy = ePlayers[ i ];
            break;
        }
    }
            
    return eGuy;
}

getPlayersOnTeam( team )
{
    players = getEntArray( "player", "classname" );

    if ( team == "hunters" ) team = "axis";
    if ( team == "zombies" ) team = "allies";
    
    guys = [];
    for ( i = 0; i < players.size; i++ )
    {
        if ( players[ i ].pers[ "team" ] == team || team == "any" )
            guys[ guys.size ] = players[ i ];
    }
    
    return guys;
}

getStance( returnValue )
{
    if ( !self isOnGround() && !isDefined( returnValue ) )
        return "in air";
 
    org = spawn( "script_model", self.origin );
    org linkto( self, "tag_helmet", ( 0, 0, 0 ), ( 0, 0, 0 ) );
    wait 0.03;  // this is required, or else the model will not move to tag_helmet by the time it's removed
 
    z = org.origin[ 2 ] - self.origin[ 2 ];
 
    org delete();
    
    if ( isDefined( returnValue ) && returnValue )
        return z;
 
    if ( z < 20 )   return "prone";
    if ( z < 50 )   return "crouch";
    if ( z < 70 )   return "stand";
}

isChar( cChar )
{
    bIsChar = false;
    
    switch ( toLower( cChar ) )
    {
        case "a":   case "b":   case "c":
        case "d":   case "e":   case "f":
        case "g":   case "h":   case "i":
        case "j":   case "k":   case "l":
        case "m":   case "n":   case "o":
        case "p":   case "q":   case "r":
        case "s":   case "t":   case "u":
        case "v":   case "w":   case "x":
        case "y":   case "z":
            bIsChar = true;
            break;
        default:
            break;
    }
    
    return bIsChar;
}

isDigit( cDigit )
{
    bIsDigit = false;
    switch ( cDigit )
    {
        case "0":   case "1":   case "2":
        case "3":   case "4":   case "5":
        case "6":   case "7":   case "8":
        case "9":
            bIsDigit = true;
            break;
        default:
            break;
    }
    
    return bIsDigit;
}

isSymbol( cChar )
{
    bIsSymbol = false;
    switch ( cChar )
    {
        case "-":   case ">":   case "<":
        case "(":   case ")":   case "!":
        case "@":   case "#":   case "$":
        case "%":   case "&":   case "*":
        case "[":   case "]":   case "{":
        case "}":   case ":":   case ".":
        case "?":   case "^":   case "+":
        case "/":   case "~":   case "`":
        case ";":
            bIsSymbol = true;
            break;
        default:
            break;
    }
    
    return bIsSymbol;
}

showPos()
{
    while ( isAlive( self ) )
    {
        if ( self meleebuttonpressed() )
        {
            self iprintln( "^5(^7" + self.origin[ 0 ] + ", " + self.origin[ 1 ] + ", " + self.origin[ 2 ] + "^5)^7 " + self.angles[ 1 ] );
            wait 1;
        }
        
        wait 0.05;
    }
}

startsWith( string, start ) {
    if ( !isDefined( string ) || !isDefined( start ) )
        return false;

    if ( string == "" || start == "" )
        return false;

    if ( start.size > string.size )
        return false;

    for ( i = 0; i < start.size; i++ ) {
        if ( string[ i ] != start[ i ] )
            return false;
    }

    return true;
}

strip(s) {
    if(!isDefined(s) || s == "")
        return "";

    resettimeout();

    s2 = "";
    s3 = "";

    i = 0;
    while(i < s.size && s[i] == " ")
        i++;

    if(i == s.size)
        return "";
    
    for(; i < s.size; i++) {
        s2 += s[i];
    }

    i = s2.size-1;
    while(s2[i] == " " && i > 0)
        i--;

    for(j = 0; j <= i; j++) {
        s3 += s2[j];
    }
        
    return s3;
}

strreplacer( sString, sType ) {
    out = "";
    in = "";
    switch ( sType ) {
        case "alphanumeric":
            out = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890-=+_/*!@#$%^&*(){}[];'.~` ";
            in = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890-=+_/*!@#$%^&*(){}[];'.~` ";
            bIgnoreExtraChars = true;
            break;
        case "lower":
            out = "abcdefghijklmnopqrstuvwxyz";
            in = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            bIgnoreExtraChars = false;
            break;
        case "upper":
            in = "abcdefghijklmnopqrstuvwxyz";
            out = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            bIgnoreExtraChars = false;
            break;
        case "onlynumbers":
            in = "0123456789";
            out = "0123456789";
            bIgnoreExtraChars = true;
            break;
        case "numeric":
            in = "0123456789.-";
            out = "0123456789.-";
            bIgnoreExtraChars = true;
            break;
        case "vector":
            in = "0123456789.-,()";
            out = "0123456789.-,()";
            bIgnoreExtraChars = true;
            break;
        default:
            return sString;
            break;
    }
        
    sOut = "";
    for ( i = 0; i < sString.size; i++ ) {
        bFound = false;
        cChar = sString[ i ];
        for ( j = 0; j < in.size; j++ ) {
            if ( in[ j ] == cChar ) {
                sOut += out[ j ];
                bFound = true;
                break;
            }
        }
        
        if ( !bFound && !bIgnoreExtraChars )
            sOut += cChar;
    }
    
    return sOut;
}
