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

cleanScreen()
{
    for( i = 0; i < 5; i++ )
    {
        iPrintlnBold( " " );
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

fastMo( length )
{
    if ( length <= 1 )
        return;
    newlength = length - 1;
    
    for ( i = 1.0; i < 1.5; i += 0.05 )
    {
        setCvar( "timescale", i );
        setAllClientCvars( "timescale", i );
        wait 0.05;
    }
    
    setCvar( "timescale", 1.5 );
    setAllClientCvars( "timescale", 1.5 );
    
    wait ( newlength );
    
    for ( i = 0; i > 1.0; i -= 0.05 )
    {
        setCvar( "timescale", i );
        setAllClientCvars( "timescale", i );
        wait 0.05;
    }
    
    setCvar( "timescale", 1.0 );
    setAllClientCvars( "timescale", 1.0 );
}

FOVScale( value ) {
    self setClientCvar( "cg_fov", value );
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

isWinterMap( map ) {
    if ( !isDefined( map ) ) {
        return false;
    }

    switch ( map ) {
        case "mp_harbor":
        case "mp_hurtgen":
        case "mp_pavlov":
        case "mp_railyard":
        case "mp_rocket":
        case "mp_stalingrad":
            return true;
            break;
        default:
            return false;
            break;
    }
}

mapChar( str, conv )
{
    if ( !isdefined( str ) || ( str == "" ) )
        return ( "" );

    from = "";
    to = "";
    switch ( conv )
    {
      case "U-L":   case "U-l": case "u-L": case "u-l":
        from = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        to   = "abcdefghijklmnopqrstuvwxyz";
        break;
      case "L-U":   case "L-u": case "l-U": case "l-u":
        from = "abcdefghijklmnopqrstuvwxyz";
        to   = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        break;
      default:
        return ( str );
    }

    s = "";
    for ( i = 0; i < str.size; i++ )
    {
        ch = str[ i ];

        for ( j = 0; j < from.size; j++ ) {
            resettimeout();
            if ( ch == from[ j ] )
            {
                ch = to[ j ];
                break;
            }
        }

        s += ch;
    }

    return ( s );
}

monotone( str )
{
    if ( !isdefined( str ) || ( str == "" ) )
        return ( "" );

    _s = "";

    _colorCheck = false;
    for ( i = 0; i < str.size; i++ )
    {
        ch = str[ i ];
        if ( _colorCheck )
        {
            _colorCheck = false;

            switch ( ch )
            {
              case "0":
              case "1":
              case "2":
              case "3":
              case "4":
              case "5":
              case "6":
              case "7":
                break;
              default:
                _s += ( "^" + ch );
                break;
            }
        }
        else
        if ( ch == "^" )
            _colorCheck = true;
        else
            _s += ch;
    }

    return ( _s );
}

playSoundInSpace( sAlias, vOrigin, iTime )
{
    oOrg = spawn( "script_model", vOrigin );
    wait 0.05;
    oOrg playSound( sAlias );
    
    wait ( iTime );
    
    oOrg delete();
}

scriptedRadiusDamage( origin, range, maxdamage, mindamage, attacker, ignore )
{
    players = getEntArray( "player", "classname" );
    inrange = [];
    
    for ( i = 0; i < players.size; i++ )
    {
        if ( distance( origin, players[ i ].origin ) < range )
        {
            if ( isDefined( ignore ) && players[ i ] == ignore )
                continue;
                
            if ( players[ i ].sessionstate != "playing" )
                continue;
                
            inrange[ inrange.size ] = players[ i ];
        }
    }

    for ( i = 0; i < inrange.size; i++ )
    {
        damage = 0;
        
        dist = distance( origin, inrange[ i ].origin );
        
        dmult = ( range - dist ) / range;
        if ( dmult >= 1 ) dmult = 0.99;
        if ( dmult <= 0 ) dmult = 0.01;
            
        damage = maxdamage * dmult;

        trace = bullettrace( origin, inrange[ i ].origin + ( 0, 0, 16 ), false, undefined );
        trace2 = bullettrace( origin, inrange[ i ].origin + ( 0, 0, 40 ), false, undefined );
        trace3 = bullettrace( origin, inrange[ i ].origin + ( 0, 0, 60 ), false, undefined );
        if ( trace[ "fraction" ] != 1 && trace2[ "fraction" ] != 1 && trace3[ "fraction" ] != 1 )
            continue;
            
        hitloc = "torso_upper";
        if ( trace3[ "fraction" ] != 1 && trace2[ "fraction" ] == 1 )
            hitloc = "torso_lower";
        if ( trace3[ "fraction" ] != 1 && trace2[ "fraction" ] != 1 && trace[ "fraction" ] == 1 )
        {
            s = "left";
            if ( _randomInt( 100 ) > 50 )
                s = "right";
                
            hitloc = s + "_leg_upper";
        }
            
        inrange[ i ] thread [[ level.callbackPlayerDamage ]]( attacker, attacker, damage, 0, "MOD_GRENADE_SPLASH", "defaultweapon_mp", origin, vectornormalize( inrange[ i ].origin - origin ), hitloc );
    }
}

// "myString" to "My String"
seperateVarName( var, num ) {
    temp = "";     
    if ( !isDefined( num ) )
        num = 1024;
        
    for ( i = 0; i < var.size; i++ ) {
        if ( var[ i ] == toupper( var[ i ] ) && num > 0) {
            num--;
            temp += " " + var[ i ];
        }
        else
            temp += var[ i ];
    }
    return ucfirst( temp );
}

setAllClientCvars( cvar, value )
{
    players = getEntArray( "player", "classname" );
    for ( i = 0; i < players.size; i++ )
        players[ i ] setClientCvar( cvar, value );
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

slowMo( length )
{
    if ( length <= 1 )
        return;
    newlength = length - 1;
    
    for ( i = 1.0; i > 0.5; i -= 0.05 )
    {
        setCvar( "timescale", i );
        setAllClientCvars( "timescale", i );
        wait 0.05;
    }
    
    setCvar( "timescale", 0.5 );
    setAllClientCvars( "timescale", 0.5 );
    
    wait ( newlength );
    
    for ( i = 0.5; i < 1.0; i += 0.05 )
    {
        setCvar( "timescale", i );
        setAllClientCvars( "timescale", i );
        wait 0.05;
    }
    
    setCvar( "timescale", 1.0 );
    setAllClientCvars( "timescale", 1.0 );
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

vectorScale( vec, scale ) {
    vec = ( vec[ 0 ] * scale, vec[ 1 ] * scale, vec[ 2 ] * scale );
    return vec;
}

waittillframeend() {
    if ( !isDefined( level.frametime ) ) {
        level.frametime = (float)( (float)1 / (float)getCvarFloat( "sv_fps" ) );
    }

    wait ( level.frametime );
}
