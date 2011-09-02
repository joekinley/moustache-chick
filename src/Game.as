package
{
  /**
   * ...
   * @author Rafael Wenzel
   */
  import org.flixel.FlxTileblock;
  import org.flixel.FlxTilemap;
  import org.flixel.FlxState;
  import org.flixel.FlxGroup;
  import org.flixel.FlxPoint;
  import org.flixel.FlxParticle;
  import org.flixel.FlxObject;
  import org.flixel.FlxG;
  import org.flixel.FlxRect;
  import org.flixel.FlxText;
  import org.flixel.FlxSprite;
  import org.flixel.system.FlxTile;

  public class Game extends FlxState
  {
    private var Tiles:Class;

    private var level:FlxTilemap;
    private var layerWorld:FlxGroup;
    private var lava:FlxTilemap;
    private var layerObjects:FlxGroup;
    private var layerBackground:FlxGroup;

    private var game:Game;
    private var player:Player;
    private var gameLevel:int;

    private var lavaTimer:Number;
    private var lavaNewTimer:Number;
    private var lavaAnimationTimer:Number;
    private var spikeAnimationTimer:Array;
    private var shakeTimer:Number;
    private var dieTimer:Number;

    private var collectibleAnimationTimer:Number;

    private var score:FlxText;
    private var health:FlxText;
    private var isWhipping:Boolean
    private var whipTimer:Number;
    private var gameScore:int;

    public function Game( number:int, tileset:Class )
    {
      this.gameLevel = number;
      this.Tiles = tileset;
      this.player = new Player( tileset );
    }

    override public function create( ):void {

      Globals.health = Globals.PLAYER_START_HEALTH;
      this.gameScore = 0;
      
      // initialize layers
      layerWorld = new FlxGroup;
      layerObjects = new FlxGroup;
      layerBackground = new FlxGroup;

      // initialize background group; tile it 5x10
      for ( var i:int = 0; i < 6; i++ ) {
        for ( var j:int = 0; j < 10; j++ ) {
          var oneTile:FlxSprite = new FlxSprite( j * 160, i * 160, Globals.Background );
          this.layerBackground.add( oneTile );
        }
      }

      // generate level
      level = new FlxTilemap;
      level.loadMap( this.getLevel( this.gameLevel ), this.Tiles, Globals.TILE_WIDTH, Globals.TILE_HEIGHT, 0, 1, 1, 21 );
      layerWorld.add( level );
      this.level.setTileProperties( 21, FlxObject.ANY, this.checkWhip ); // for whip action
      this.level.setTileProperties( Globals.TILES_SPIKES, FlxObject.NONE, this.spikeCollision, null, 4 ); // spikes
      this.level.setTileProperties( 47, FlxObject.NONE, this.ladderCollision, Player, 2 );
      this.level.setTileProperties( 49, FlxObject.LEFT | FlxObject.RIGHT | FlxObject.CEILING, this.ladderCollision );

      // initialize lava system
      this.lavaTimer = 0;
      this.lavaNewTimer = 0;
      this.lavaAnimationTimer = 0;
      this.collectibleAnimationTimer = 0;
      this.shakeTimer = 0;
      this.dieTimer = 0;

      // initialize player
      var startPoint:FlxPoint = level.getTileCoords( Globals.TILES_PLAYER_START, false )[ 0 ];
      player.x = startPoint.x;
      player.y = startPoint.y;

      // initialize lava
      this.initializeLava( );

      // initialize collectibles
      this.initializeCollectibles( );

      // initialize spike system
      this.initializeSpikes( );
      
      this.add( layerBackground );
      this.add( layerWorld );
      this.add( layerObjects );
      this.add( player );
      this.add( player.whipSprite );

      // set camera
      FlxG.camera.follow( player );
      FlxG.camera.setBounds( 0, 0, level.width, level.height );
      FlxG.worldBounds = new FlxRect( 0, 0, level.width, level.height );

      // initialize hud
      score = new FlxText( 10, 10, 50, 'Score: ' + Globals.score );
      score.scrollFactor.x = 0;
      score.scrollFactor.y = 0;
      add( score );

      health = new FlxText( FlxG.camera.width - 60, 10, 100, 'Health: ' + Globals.health );
      health.scrollFactor.x = 0;
      health.scrollFactor.y = 0;
      add( health );
    }

    override public function update( ):void {

      this.debug( );

      this.lavaTimer += FlxG.elapsed;
      this.lavaNewTimer += FlxG.elapsed;
      this.lavaAnimationTimer += FlxG.elapsed;
      this.collectibleAnimationTimer += FlxG.elapsed;
      this.whipTimer += FlxG.elapsed;
      this.shakeTimer += FlxG.elapsed;

      // lava updating mechanism
      if( this.lavaNewTimer > Globals.GAME_LAVA_SPEED ) {
        this.updateLava( );
        this.lavaNewTimer = 0;
      }

      // collectible animation
      if ( this.collectibleAnimationTimer > Globals.GAME_COLLECTIBLE_ANIMATION_SPEED ) {
        this.updateCollectibles( );
        this.collectibleAnimationTimer = 0;
      }
      
      // update spikes
      this.updateSpikes( );
      
      if ( this.shakeTimer > Globals.GAME_SHAKE_MAX_TIMER || Math.random( ) * 10000 < Globals.GAME_SHAKE_CHANCE ) {
        FlxG.shake( 0.02 );
        this.shakeTimer = 0;
      }

      // collide player with level
      FlxG.collide( this.level, this.player );
      // collide player with lava
      FlxG.collide( this.lava, this.player, this.lavaCollision );

      // check for win condition
      if ( this.level.getTile( this.player.x/Globals.TILE_WIDTH, this.player.y/Globals.TILE_HEIGHT ) == Globals.TILES_EXIT ) {
        Globals.deathCounter = 0;
        var newLevel:Game = new Game( this.gameLevel + 1, Tiles );
        FlxG.switchState( newLevel );
      }

      // player whipping
      if ( Globals.hasWhip && FlxG.keys.justPressed( 'A' ) ) {
        FlxG.play( Globals.SoundCrush, 0.5 )
        this.isWhipping = true;
        this.whipTimer = 0;
        this.player.setWhipping( true );
      }
      if ( FlxG.keys.justReleased( 'A' ) || this.whipTimer > Globals.PLAYER_WHIP_DURATION ) {
        this.isWhipping = false;
        this.player.setWhipping( false );
      }

      // HUD
      this.score.text = 'Score: ' + Globals.score;
      this.health.text = 'Health: ' + Globals.health;

      // loose condition
      if ( Globals.health <= 0 || !this.player.onScreen( ) ) {
        
        this.dieTimer += FlxG.elapsed;
        this.player.die( );
        
        if( this.dieTimer > Globals.GAME_DIE_TIME && this.player.dead && this.player.finished ) {
          Globals.score -= this.gameScore;
          Globals.score -= Globals.GAME_LOST_LIFE_LOSE_SCORE;
          Globals.health = Globals.PLAYER_START_HEALTH;
          Globals.deathCounter++;
          var thisLevel:Game = new Game( this.gameLevel, Tiles );
          FlxG.switchState( thisLevel );
        }
      }

      // no negative score
      if ( Globals.score <= 0 ) Globals.score = 0;
      super.update( );
    }

    // basic level returner
    public function getLevel( number:int ):String {

      switch( number ) {
        case -1: return FlxTilemap.arrayToCSV( Levels.level01( ), 8 ); break;
        // easy levels
        case 0: return FlxTilemap.arrayToCSV( Levels.level0( ), 10 ); break;
        case 1: return FlxTilemap.arrayToCSV( Levels.level1( ), 20 ); break;
        case 2: return FlxTilemap.arrayToCSV( Levels.level2( ), 15 ); break;
        case 3: return FlxTilemap.arrayToCSV( Levels.level3( ), 20 ); break;
        case 4: return FlxTilemap.arrayToCSV( Levels.level4( ), 30 ); break;
        case 5: return FlxTilemap.arrayToCSV( Levels.level5( ), 10 ); break;
        case 6: return FlxTilemap.arrayToCSV( Levels.level6( ), 16 ); break;
        case 7: return FlxTilemap.arrayToCSV( Levels.level7( ), 19 ); break;
        case 8: return FlxTilemap.arrayToCSV( Levels.level8( ), 65 ); break;
        case 9: return FlxTilemap.arrayToCSV( Levels.level9( ), 6 ); break;
        case 10: return FlxTilemap.arrayToCSV( Levels.level10( ), 25 ); break;
        case 11: return FlxTilemap.arrayToCSV( Levels.level11( ), 30 ); break;
        case 12: return FlxTilemap.arrayToCSV( Levels.level12( ), 50 ); break;
        case 13: return FlxTilemap.arrayToCSV( Levels.level13( ), 5 ); break;
        case 14: return FlxTilemap.arrayToCSV( Levels.level14( ), 60 ); break;
        // medium levels
        case 15: return FlxTilemap.arrayToCSV( Levels.level15( ), 20 ); break;
        case 16: return FlxTilemap.arrayToCSV( Levels.level16( ), 10 ); break;
        case 17: return FlxTilemap.arrayToCSV( Levels.level17( ), 30 ); break;
        case 18: return FlxTilemap.arrayToCSV( Levels.level18( ), 20 ); break;
        case 19: return FlxTilemap.arrayToCSV( Levels.level19( ), 80 ); break;
        case 20: return FlxTilemap.arrayToCSV( Levels.level20( ), 30 ); break;
        case 21: return FlxTilemap.arrayToCSV( Levels.level21( ), 20 ); break;
        
        case 31: return FlxTilemap.arrayToCSV( Levels.level31( ), 25 ); break;
        case 32: return FlxTilemap.arrayToCSV( Levels.level32( ), 25 ); break;
        case 33: return FlxTilemap.arrayToCSV( Levels.level33( ), 6 ); break;
        case 34: return FlxTilemap.arrayToCSV( Levels.level34( ), 50 ); break;
        case 35: return FlxTilemap.arrayToCSV( Levels.level35( ), 30 ); break;
        case 36: return FlxTilemap.arrayToCSV( Levels.level36( ), 50 ); break;
        case 46: return FlxTilemap.arrayToCSV( Levels.level46( ), 27 ); break;

        default:
          Globals.hasWhip = true;
          //return FlxTilemap.arrayToCSV( Levels.generateLevel( 30, 30 ), 30 );
          return FlxTilemap.arrayToCSV( Levels.level0( ), 10 ); break;
          break;
      }

      return "";
    }

    public function initializeLava( ):void {

      var lavaData:Array = new Array( level.widthInTiles * level.heightInTiles );
      for ( var i:int = 0; i < level.widthInTiles * level.heightInTiles; i++ ) {
        lavaData[ i ] = 0;
      }
      this.lava = new FlxTilemap;
      this.lava.loadMap( FlxTilemap.arrayToCSV( lavaData, level.widthInTiles ), this.Tiles, Globals.TILE_WIDTH, Globals.TILE_HEIGHT, 0, 1, 1, 1 );

      //set special callbacks for certain tiles
      this.lava.setTileProperties( 12, FlxObject.NONE, this.lavaCollision, null, 3 ); // lava
      this.lava.setTileProperties( 24, FlxObject.NONE, this.lavaCollision, null, 9 ); // lava
      this.lava.setTileProperties( 19, FlxObject.NONE, this.coinCollision, null, 2 ); // coins
      this.lava.setTileProperties( 33, FlxObject.NONE, this.heartCollision, null, 3 ); // hearts

      this.layerObjects.add( this.lava );
    }

    public function initializeCollectibles( ):void {

      var startIndex:int, heartsPlaced:int = 0, itteration:int = 0, i:int;
      
      for ( i = 0; i < level.widthInTiles * level.heightInTiles; i++ ) {
        if ( this.level.getTileByIndex( i ) == Globals.TILES_COLLECTIBLE_INDICATOR ) {
          this.lava.setTileByIndex( i, 19 );
          this.level.setTileByIndex( i, 0 );
        } else if ( this.level.getTileByIndex( i ) == Globals.TILES_HEART_INDICATOR ) {
          this.lava.setTileByIndex( i, 33 );
          this.level.setTileByIndex( i, 0 );
        }
        if ( this.level.getTileByIndex( i ) == Globals.TILES_PLAYER_START ) startIndex = i;
      }
      
      // start placing as many hearts as Globals.deathCounter
      // start left, then go in circles around the player
      var leftmost:int, rightmost:int, topmost:int;
      while ( heartsPlaced < Globals.deathCounter ) {
        itteration++; leftmost = startIndex; rightmost = startIndex; topmost = startIndex;
        
        while( leftmost % this.lava.widthInTiles != 0 && leftmost > startIndex - itteration ) leftmost--;
        while( rightmost + 1 % this.lava.widthInTiles != 0 && rightmost < startIndex + itteration ) rightmost++;
        while( topmost > this.lava.widthInTiles && topmost > startIndex - itteration * this.lava.widthInTiles ) topmost -= this.lava.widthInTiles;

        // set the hearts
        if ( leftmost != startIndex && heartsPlaced < Globals.deathCounter && this.lava.getTileByIndex( leftmost ) == 0 && !this.isFloor( this.level.getTileByIndex( leftmost ) ) ) {
          this.lava.setTileByIndex( leftmost, 33 );
          heartsPlaced++;
        }
        if ( rightmost != startIndex && heartsPlaced < Globals.deathCounter && this.lava.getTileByIndex( rightmost ) == 0 && !this.isFloor( this.level.getTileByIndex( rightmost ) ) ) {
           this.lava.setTileByIndex( rightmost, 33 );
           heartsPlaced++;
        }
        for ( i = topmost - ( startIndex - leftmost ); i < topmost + ( rightmost - startIndex ); i++ ) {
          if ( i != startIndex && heartsPlaced < Globals.deathCounter && this.lava.getTileByIndex( i ) == 0 && !this.isFloor( this.level.getTileByIndex( i ) ) ) {
            this.lava.setTileByIndex( i, 33 );
            heartsPlaced++;
          }
        }
      }
    }
    
    public function initializeSpikes( ):void {
      
      this.spikeAnimationTimer = new Array( this.level.widthInTiles * this.level.heightInTiles );
      for ( var i:int = 0; i < this.level.widthInTiles * this.level.heightInTiles; i++ ) {
        this.spikeAnimationTimer[ i ] = -1;
      }
    }

    // updates advancing lava doom
    public function updateLava( ):void {

      var top:int, left:int, right:int, bottom:int;
      var topTileLava:int, leftTileLava:int, rightTileLava:int, bottomTileLava:int;
      var topTileLevel:int, leftTileLevel:int, rightTileLevel:int, bottomTileLevel:int;
      var thisTileLevel:int, thisTileLava:int;
      var i:int, rand:int;

      var doAnimate:Boolean = false;
      if ( this.lavaAnimationTimer > Globals.GAME_LAVA_ANIMATION_SPEED ) doAnimate = true;
      
      // advance in movement
      // all lava does one step down if downtile is no floor; thus crushes items and all
      // if bottom tile is a floor tile; advance either left or right
      for ( i = level.widthInTiles*level.heightInTiles; i > 0; i-- ) {

        // set bottom indicator
        thisTileLevel = this.level.getTileByIndex( i ); thisTileLava = this.lava.getTileByIndex( i );
        top = i - level.widthInTiles; topTileLava = this.lava.getTileByIndex( top ); topTileLevel = this.level.getTileByIndex( top );
        bottom = i + level.widthInTiles; bottomTileLava = this.lava.getTileByIndex( bottom ); bottomTileLevel = this.level.getTileByIndex( bottom );
        left = ( i % level.widthInTiles == 0 )? -1 : i - 1; leftTileLava = this.lava.getTileByIndex( left ); leftTileLevel = this.level.getTileByIndex( left );
        right = ( (i + 1) % level.widthInTiles == 0 )? -1: i + 1; rightTileLava = this.lava.getTileByIndex( right ); rightTileLevel = this.level.getTileByIndex( right );

        // advance lava
        if ( this.isLava( thisTileLava ) ) { // only advance lava

          if ( this.isLava( thisTileLava, 4 ) && this.isFloor( thisTileLevel ) ) { // do not move hardened lava
            continue;
          } else if ( this.isFloor( bottomTileLevel ) ) { // if i is a floor, advance left or right
            if ( left != -1 && this.isLava( thisTileLava, 2 ) && !this.isFloor( leftTileLevel ) ) { // advance left flowing lava
              this.lava.setTileByIndex( left, thisTileLava ); leftTileLava = thisTileLava;
              this.lava.setTileByIndex( i, 0 ); thisTileLava = 0;
              if( left != -1 ) i--; // advance further, otherwise this tile gets computed twice; only if not leftmost
            } else if ( right != -1 && this.isLava( thisTileLava, 3 ) && !this.isFloor( rightTileLevel ) ) { // advance right flowing lava
              this.lava.setTileByIndex( right, thisTileLava ); rightTileLava = thisTileLava;
              this.lava.setTileByIndex( i, 0 ); thisTileLava = 0;
            } else { // decide which way to flow
             
              if ( left != -1 && !this.isFloor( leftTileLevel ) ) { // just flow left
                this.lava.setTileByIndex( i, 27 ); thisTileLava = 27;
                if( left != -1 ) i--; // advance counter by one, otherwise we will move the left tile again here
              } else if( right != -1 && !this.isFloor( rightTileLevel ) ) { // just flow right
                this.lava.setTileByIndex( i, 30 ); thisTileLava = 30;
              } else if ( this.isFloor( leftTileLevel ) || this.isFloor( rightTileLevel ) ) { // error case, apparently this lava tile is trapped, so just make it hardened
                this.lava.setTileByIndex( i, 24 ); thisTileLava = 24;
                this.level.setTileByIndex( i, 21 ); thisTileLevel = 21;
			        }
            }
          } else if( !this.isLava( bottomTileLava ) ) {
            // if below is free, fall down
            this.lava.setTileByIndex( bottom, thisTileLava ); bottomTileLava = thisTileLava;
            this.lava.setTileByIndex( i, 0 ); thisTileLava = 0;
          }
        }
      }

      // create new lava
      if ( this.lavaTimer > Globals.GAME_LAVA_NEW ) {
        for ( i = 0; i < level.widthInTiles * level.heightInTiles; i++ ) {
          if ( this.level.getTileByIndex( i ) == Globals.TILES_LAVA_SOURCE ) {
            this.lava.setTileByIndex( i + level.widthInTiles, 12 );
          }                                
        }
        this.lavaTimer = 0;
      }

      // correct animations
      // when there is lava to the left, right and bottom of a lava, make it whole lava
      for ( i = level.widthInTiles*level.heightInTiles-level.widthInTiles; i > level.widthInTiles; i-- ) {

        // set bottom indicator
        thisTileLevel = this.level.getTileByIndex( i ); thisTileLava = this.lava.getTileByIndex( i );
        top = i - level.widthInTiles; topTileLava = this.lava.getTileByIndex( top ); topTileLevel = this.level.getTileByIndex( top );
        bottom = i + level.widthInTiles; bottomTileLava = this.lava.getTileByIndex( bottom ); bottomTileLevel = this.level.getTileByIndex( bottom );
        left = ( i % level.widthInTiles == 0 )? -1 : i - 1; leftTileLava = this.lava.getTileByIndex( left ); leftTileLevel = this.level.getTileByIndex( left );
        right = ( (i + 1) % level.widthInTiles == 0 )? -1: i + 1; rightTileLava = this.lava.getTileByIndex( right ); rightTileLevel = this.level.getTileByIndex( right );

        // make lava falling again
        if ( !this.isLava( thisTileLava, 1 ) && this.isLava( thisTileLava ) && !this.isFloor( bottomTileLevel ) ) {
          this.lava.setTileByIndex( i, 12 ); thisTileLava = 12;
        } 
        
        // check hardened lava for correct behaviour
        // if leftmost lava and !canFall, harden it
        if ( this.isLava( thisTileLava ) && this.isFloor( bottomTileLevel )
          && ( ( this.isLava( thisTileLava, 2 ) && this.isFloor( leftTileLevel ) && !this.couldFall( i ) )
            || ( this.isLava( thisTileLava, 3 ) && this.isFloor( rightTileLevel ) && !this.couldFall( i ) ) ) ) {
              
            this.lava.setTileByIndex( i, 24 ); thisTileLava = 24;
            this.level.setTileByIndex( i, 21 ); thisTileLevel = 21;
        }
        
        // harden lava if surrounded by lava or floor
        if ( this.isLava( thisTileLava ) 
        && !this.isFloor( thisTileLevel )
        && this.isFloor( leftTileLevel )
        && this.isFloor( rightTileLevel )
        && this.isFloor( bottomTileLevel ) ) {

          this.lava.setTileByIndex( i, 24 ); thisTileLava = 24;
		      this.level.setTileByIndex( i, 21 ); thisTileLevel = 21;
        }

        // handle animation
        if ( doAnimate ) {
          // falling lava
          if ( thisTileLava == 12 || thisTileLava == 13 ) this.lava.setTileByIndex( i, thisTileLava + 1 );
          if ( thisTileLava == 14 ) this.lava.setTileByIndex( i, 12 );

          // left advancing lava
          if ( thisTileLava == 27 || thisTileLava == 28 ) this.lava.setTileByIndex( i, thisTileLava + 1 );
          if ( thisTileLava == 29 ) this.lava.setTileByIndex( i, 27 );

          // right advancing lava
          if ( thisTileLava == 30 || thisTileLava == 31 ) this.lava.setTileByIndex( i, thisTileLava + 1 );
          if ( thisTileLava == 32 ) this.lava.setTileByIndex( i, 30 );

          // still lava
          if ( thisTileLava == 24 || thisTileLava == 25 ) this.lava.setTileByIndex( i, thisTileLava + 1 );
          if ( thisTileLava == 26 ) this.lava.setTileByIndex( i, 24 );

          this.lavaAnimationTimer = 0;
        }
      }
    }

    public function updateCollectibles( ):void {

      var currentTile:int;
      for ( var i:int = 0; i < this.lava.widthInTiles * this.lava.heightInTiles; i++ ) {
        currentTile = this.lava.getTileByIndex( i );
        // moustache combs
        if ( currentTile == 19 ) {
          this.lava.setTileByIndex( i, 20 );
        } else if ( currentTile == 20 ) {
          this.lava.setTileByIndex( i, 19 );
        }

        // hearts
        else if ( currentTile == 33 || currentTile == 34 ) {
          this.lava.setTileByIndex( i, currentTile+1 );
        } else if ( currentTile == 35 ) {
          this.lava.setTileByIndex( i, 33 );
        }
      }
    }
    
    // spike update method
    public function updateSpikes( ):void {
      
      // update animation timer
      for ( var i:int = 0; i < this.spikeAnimationTimer.length; i++ ) {
        if ( this.spikeAnimationTimer[ i ] >= 0 ) {
          this.spikeAnimationTimer[ i ] += FlxG.elapsed;
          
          // second animation phase
          if ( this.spikeAnimationTimer[ i ] > Globals.GAME_SPIKE_ANIMATION_SPEED ) this.level.setTileByIndex( i, 42 );
          
          // third animation phase
          if ( this.spikeAnimationTimer[ i ] > 2 * Globals.GAME_SPIKE_ANIMATION_SPEED ) this.level.setTileByIndex( i, 43 );
          
          // remove spike after duration
          if ( this.spikeAnimationTimer[ i ] > Globals.GAME_SPIKE_DURATION ) {
            this.level.setTileByIndex( i, 40 );
            
            this.spikeAnimationTimer[ i ] = -1;
          }
        }
        
        
      }
      
      // spike removal after timeout
    }

    // helper functions
    // mode = 0 -> all lava
    // mode = 1 -> only falling lava
    // mode = 2 -> only left flowing lava
    // mode = 3 -> only right flowing lava
    // mode = 4 -> only bottom lava
    public function isLava( tile:int, mode:int = 0 ):Boolean {

      if ( mode == 0 && ( tile == 12 || tile == 13 || tile == 14 || tile == 24 || tile == 25 || tile == 26 || tile == 27 || tile == 28 || tile == 29 || tile == 30 || tile == 31 || tile == 32 ) ) return true;
      if ( mode == 1 && ( tile == 12 || tile == 13 || tile == 14 ) ) return true;
      if ( mode == 2 && ( tile == 27 || tile == 28 || tile == 29 ) ) return true;
      if ( mode == 3 && ( tile == 30 || tile == 31 || tile == 32 ) ) return true;
      if ( mode == 4 && ( tile == 24 || tile == 25 || tile == 26 ) ) return true;
      return false;
    }

    // mode = 0 -> all floor tiles
    // mode = 1 -> only middle floor
    // mode = 2 -> only wall floor tiles
    public function isFloor( tile:int, mode:int = 0 ):Boolean {

      if ( mode == 0 && ( tile == 21 || tile == 22 ) ) return true;
      if ( mode == 1 && ( tile == 21 ) ) return true;
      if ( mode == 2 && ( tile == 22 || tile == 23 ) ) return true;
      return false;
    }
    
    // recursive function to check wether a lava could go deeper
    public function couldFall( i:int, direction:String = 'both' ):Boolean {

      // determine left, right, bottom
      var thisTileLava:int;
      var bottom:int, bottomTileLava:int, bottomTileLevel:int;
      var left:int, leftTileLava:int, leftTileLevel:int;
      var right:int, rightTileLava:int, rightTileLevel:int;
      
      thisTileLava = this.lava.getTileByIndex( i );
      bottom = i + level.widthInTiles; bottomTileLava = this.lava.getTileByIndex( bottom ); bottomTileLevel = this.level.getTileByIndex( bottom );
      left = ( i % level.widthInTiles == 0 )? -1 : i - 1; leftTileLava = this.lava.getTileByIndex( left ); leftTileLevel = this.level.getTileByIndex( left );
      right = ( (i + 1) % level.widthInTiles == 0 )? -1: i + 1; rightTileLava = this.lava.getTileByIndex( right ); rightTileLevel = this.level.getTileByIndex( right );
      
      // if bottom is free, return true
      if ( !this.isFloor( bottomTileLevel ) ) return true;
      
      // if left is free, return couldFall( left );
      if ( ( direction == 'left' || direction == 'both' ) && left != -1 && !this.isFloor( leftTileLevel ) && !this.isLava( leftTileLava, 4 ) ) return this.couldFall( left, 'left' );
      
      // if right is free, return couldFall( right );
      if ( ( direction == 'right' || direction == 'both' ) && right != -1 && !this.isFloor( rightTileLevel ) && !this.isLava( rightTileLava, 4 ) ) return this.couldFall( right, 'right' );
      
      // error case; shall never happen
      return false;
    }

    public function lavaCollision( tile:FlxTile, obj:FlxObject ):void {

      // hurt collision with lava
      if( !this.player.dead && !this.player.flickering && Math.abs( ( tile.mapIndex % this.lava.widthInTiles ) * Globals.TILE_WIDTH - obj.x ) < 10 ) { // tilemap collision hack on right side of player
        FlxG.play( Globals.SoundHurt, 0.5 )
        if( Globals.health > 0 ) this.player.flicker( 3 );
        
        // collision with spikes makes the player dead immediately
        Globals.health--; // lava just takes health
        Globals.score -= Globals.GAME_HIT_LAVA_LOSE_SCORE;
      }
    }

    public function coinCollision( tile:FlxTile, obj:FlxObject ):void {

      FlxG.play( Globals.SoundCoin, 0.5 );
      this.lava.setTileByIndex( tile.mapIndex, 0 );
      Globals.score++;
      this.gameScore++;
    }

    public function heartCollision( tile:FlxTile, obj:FlxObject ):void {

      FlxG.play( Globals.SoundCoin, 0.5 );
      this.lava.setTileByIndex( tile.mapIndex, 0 );
      Globals.health++;
    }
    
    public function spikeCollision( tile:FlxTile, obj:FlxObject ):void {
      
      // add new spike timer
      if( tile.index == 40 ) { 
        
        this.level.setTileByIndex( tile.mapIndex, 41 );
        this.spikeAnimationTimer[ tile.mapIndex ] = 0;
      }
//trace( ( tile.mapIndex / this.lava.widthInTiles ) * Globals.TILE_HEIGHT, obj.y );      
      // hurt handling
      // hurt collision with spikes
      if ( !this.player.dead 
       && ( Math.abs( ( tile.mapIndex % this.lava.widthInTiles ) * Globals.TILE_WIDTH - obj.x ) < 10 )
       /*&& ( Math.abs( ( tile.mapIndex / this.lava.heightInTiles ) * Globals.TILE_HEIGHT - obj.y ) < 12 ) */ ) { // tilemap collision hack on right side of player
        FlxG.play( Globals.SoundHurt, 0.5 )
        if( Globals.health > 0 ) this.player.flicker( 3 );
        
        // collision with spikes makes the player dead immediately
        Globals.health = 0; 
      }
    }
    
    public function ladderCollision( tile:FlxTile, plr:Player ):void {
      if( Math.abs( ( tile.mapIndex % this.lava.widthInTiles ) * Globals.TILE_WIDTH - plr.x ) < 10 ) {
        plr.isTouchingLadder( true );
      }
    }

    public function checkWhip( tile:FlxTile, obj:FlxObject ):void {

      if ( this.isWhipping ) {
        if ( this.isFloor( tile.index ) ) {
          if ( ( this.player.isTouching( FlxObject.CEILING ) )
          || ( this.player.isTouching( FlxObject.LEFT ) && this.player.facingDir == 'left' )
          || ( this.player.isTouching( FlxObject.RIGHT ) && this.player.facingDir == 'right' ) ) {
            this.level.setTileByIndex( tile.mapIndex, 0 );
          }
        }
      }
    }

    // used for debug stuff
    public function debug( ):void {

      if ( FlxG.keys.justPressed( 'P' ) ) Globals.health++;
      if ( FlxG.keys.justPressed( 'O' ) ) {
        Globals.deathCounter = 0;
        var newLevel:Game = new Game( this.gameLevel + 1, Tiles );
        FlxG.switchState( newLevel );
      }
    }
  }
}