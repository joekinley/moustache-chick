package
{
  /**
   * ...
   * @author Rafael Wenzel
   */
  import org.flixel.FlxTilemap;
  import org.flixel.FlxState;
  import org.flixel.FlxGroup;
  import org.flixel.FlxPoint;
  import org.flixel.FlxG;
  import org.flixel.FlxRect;

  public class Game extends FlxState
  {
    private var Tiles:Class;

    private var level:FlxTilemap;
    private var layerWorld:FlxGroup;
    private var lava:FlxTilemap;
    private var layerObjects:FlxGroup;

    private var game:Game;
    private var player:Player;
    private var gameLevel:int;

    private var lavaLevel:int; // height level of lava
    private var lavaTimer:Number;
    private var lavaNewTimer:Number;
    private var lavaAnimationTimer:Number;

    public function Game( number:int, tileset:Class )
    {
      this.gameLevel = number;
      this.Tiles = tileset;
      this.player = new Player( tileset );
    }

    override public function create( ):void {

      // initialize layers
      layerWorld = new FlxGroup;
      layerObjects = new FlxGroup;

      // generate level
      level = new FlxTilemap;
      level.loadMap( this.getLevel( this.gameLevel ), this.Tiles, Globals.TILE_WIDTH, Globals.TILE_HEIGHT, 0, 1, 1, 21 );
      layerWorld.add( level );

      // initialize lava system
      this.lavaTimer = 0;
      this.lavaNewTimer = 0;
      this.lavaAnimationTimer = 0;
      this.lavaLevel = this.level.heightInTiles;

      // initialize player
      var startPoint:FlxPoint = level.getTileCoords( Globals.TILES_PLAYER_START, false )[ 0 ];
      player.x = startPoint.x;
      player.y = startPoint.y;

      // initialize lava
      this.initializeLava( );

      this.add( layerWorld );
      this.add( layerObjects );
      this.add( player );

      // set camera
      FlxG.camera.follow( player );
      FlxG.camera.setBounds( 0, 0, level.width, level.height );
      FlxG.worldBounds = new FlxRect( 0, 0, level.width, level.height );
    }

    override public function update( ):void {

      this.debug( );

      this.lavaTimer += FlxG.elapsed;
      this.lavaNewTimer += FlxG.elapsed;
      this.lavaAnimationTimer += FlxG.elapsed;

      if( this.lavaNewTimer > Globals.GAME_LAVA_SPEED ) {
        this.updateLava( );
        this.lavaNewTimer = 0;
      }

      // collide player with level
      FlxG.collide( this.level, this.player );
      // collide player with lava
      FlxG.collide( this.lava, this.player, this.lavaCollision );


      // check for win condition
      if ( this.level.getTile( this.player.x/Globals.TILE_WIDTH, this.player.y/Globals.TILE_HEIGHT ) == Globals.TILES_EXIT ) {
        var newLevel:Game = new Game( this.gameLevel + 1, Tiles );
        FlxG.switchState( newLevel );
      }

      super.update( );
    }

    // basic level returner
    public function getLevel( number:int ):String {

      switch( number ) {
        case 0: return FlxTilemap.arrayToCSV( Levels.level0( ), 10 );
        case 1: return FlxTilemap.arrayToCSV( Levels.level1( ), 20 );
        case 2: return FlxTilemap.arrayToCSV( Levels.level2( ), 25 );
        case 3: return FlxTilemap.arrayToCSV( Levels.generateLevel( 30, 30 ), 30 );
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
      this.layerObjects.add( this.lava );
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
      // if bottom tile is a floor tile; advance either left or right (chance); with a little chance of advancing to both sides
      for ( i = level.widthInTiles*level.heightInTiles; i > 0; i-- ) {

        // set bottom indicator
        thisTileLevel = this.level.getTileByIndex( i ); thisTileLava = this.lava.getTileByIndex( i );
        top = i - level.widthInTiles; topTileLava = this.lava.getTileByIndex( top ); topTileLevel = this.level.getTileByIndex( top );
        bottom = i + level.widthInTiles; bottomTileLava = this.lava.getTileByIndex( bottom ); bottomTileLevel = this.level.getTileByIndex( bottom );
        left = ( i % level.widthInTiles == 0 )? -1 : i - 1; leftTileLava = this.lava.getTileByIndex( left ); leftTileLevel = this.level.getTileByIndex( left );
        right = ( (i + 1) % level.widthInTiles == 0 )? -1: i + 1; rightTileLava = this.lava.getTileByIndex( right ); rightTileLevel = this.level.getTileByIndex( right );

        // advance lava
        if ( this.isLava( thisTileLava ) ) { // only advance lava

          if ( this.isFloor( thisTileLevel ) && this.isLava( thisTileLava, 4 ) ) { // do not move hardened lava
            continue;
          } else if ( this.isFloor( bottomTileLevel ) ) { // if i is a floor, advance left or right
            if ( this.isLava( thisTileLava, 2 ) && !this.isFloor( leftTileLevel ) ) { // advance left flowing lava
              this.lava.setTileByIndex( left, thisTileLava );
              this.lava.setTileByIndex( i, 0 );
              i--; // advance further, otherwise this tile gets computed twice
            } else if ( this.isLava( thisTileLava, 3 ) && !this.isFloor( rightTileLevel ) ) { // advance right flowing lava
              this.lava.setTileByIndex( right, thisTileLava );
              this.lava.setTileByIndex( i, 0 );
            } else { // decide which way to flow
              rand = Math.random( ) * 100;
              if ( left != -1 && rand % 2 == 0 && !this.isFloor( leftTileLevel ) && !this.isLava( leftTileLava ) ) { // just flow left
                this.lava.setTileByIndex( i, Globals.randomNumber( 30, 27 ) );
                i--; // advance counter by one, otherwise we will move the left tile again here
              } else if( right != -1 && !this.isFloor( rightTileLevel ) && !this.isLava( rightTileLava ) ) { // just flow right
                this.lava.setTileByIndex( i, Globals.randomNumber( 33, 30 ) );
              }
            }
          } else if( !this.isLava( bottomTileLava ) ) {
            // if below is free, fall down
            this.lava.setTileByIndex( bottom, thisTileLava );
            this.lava.setTileByIndex( i, 0 );
          }
        }
      }

      // create new lava
      if ( this.lavaTimer > Globals.GAME_LAVA_NEW ) {
        for ( i = 0; i < level.widthInTiles * level.heightInTiles; i++ ) {
          if ( Math.random( ) * 100 < Globals.GAME_LAVA_SPREAD_POSSIBILITY && this.level.getTileByIndex( i ) == Globals.TILES_LAVA_SOURCE ) {
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
          rand = Globals.randomNumber( 15, 12 );
          this.lava.setTileByIndex( i, rand );
          thisTileLava = rand;
        }
        // harden lava if surrounded by lava or floor
        if ( this.isLava( thisTileLava ) && !this.isFloor( thisTileLevel )
        && ( this.isLava( leftTileLava ) || this.isFloor( leftTileLevel ) )
        && ( this.isLava( rightTileLava ) || this.isFloor( rightTileLevel ) )
        && ( this.isLava( bottomTileLava ) || this.isFloor( bottomTileLevel ) ) ) {

          this.lava.setTileByIndex( i, 24 );

          if ( this.isLava( topTileLava ) && thisTileLevel == 0 ) {
            this.level.setTileByIndex( i, Globals.TILES_WALL );
            this.lava.setTileByIndex( i, 0 );
          }
        }

        // lava on the bottom shall harden on the edges
        if ( this.isLava( thisTileLava ) && this.lavaLevel - 1 <=  (i + 1) / level.widthInTiles ) {

          if ( ( this.isLava( thisTileLava, 2 ) && this.isFloor( leftTileLevel ) )
          || ( this.isLava( thisTileLava, 3 ) && this.isFloor( rightTileLevel ) ) ) {
            this.level.setTileByIndex( i, Globals.TILES_WALL );
            this.lava.setTileByIndex( i, 24 );
          }
        }

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

      // if a complete row is full of lava tiles or
      var raiseLevel:Boolean = true;
      for ( i = level.widthInTiles * this.lavaLevel - level.widthInTiles; i < level.widthInTiles * this.lavaLevel; i++ ) {
        // if this tile is still accessible, don't raise level
        if ( !this.isLava( this.lava.getTileByIndex( i ) ) && !this.isFloor( this.level.getTileByIndex( i ) ) ) {
          raiseLevel = false;
          break;
        }
      }
      if ( raiseLevel ) this.lavaLevel--;
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
      if ( mode == 2 && ( tile == 22 ) ) return true;
      return false;
    }

    public function lavaCollision( object1:Object, object2:Object ):void {

      //trace( 'player hits LAVA' );
      //trace( object1, object2 );
      this.player.flicker( 3 );
    }

    // used for debug stuff
    public function debug( ):void {

      if ( FlxG.keys.justPressed( 'P' ) ) this.lavaTimer = 1000;
      if ( FlxG.keys.justPressed( 'O' ) ) this.lavaNewTimer = 1000;
    }
  }
}