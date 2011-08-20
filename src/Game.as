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

    private var lavaTimer:Number;
    private var lavaNewTimer:Number;

    public function Game( number:int, tileset:Class )
    {
      this.gameLevel = number;
      this.Tiles = tileset;
      this.player = new Player( tileset );
    }

    override public function create( ):void {

      this.lavaTimer = 0;
      this.lavaNewTimer = 0;

      // initialize layers
      layerWorld = new FlxGroup;
      layerObjects = new FlxGroup;

      level = new FlxTilemap;
      level.loadMap( this.getLevel( this.gameLevel ), this.Tiles, Globals.TILE_WIDTH, Globals.TILE_HEIGHT, 0, 1, 1, 21 );
      layerWorld.add( level );

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

      this.lavaTimer += FlxG.elapsed;
      this.lavaNewTimer += FlxG.elapsed;

      if( this.lavaNewTimer > Globals.GAME_LAVA_SPEED ) {
        this.updateLava( );
        this.lavaNewTimer = 0;
      }

      // collide player with level
      FlxG.collide( this.level, this.player );

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

      var top:int, left:int, right:int, bottom:int, i:int, rand:int, lavaData:Array;

      lavaData = this.lava.getData( );

      // advance in movement
      // all lava does one step down if downtile is no floor; thus crushes items and all
      // if bottom tile is a floor tile; advance either left or right (chance); with a little chance of advancing to both sides
      for ( i = level.widthInTiles*level.heightInTiles-level.widthInTiles; i > 0; i-- ) {

        // set bottom indicator
        top = i - level.widthInTiles;
        bottom = i + level.widthInTiles;
        left = ( i % level.widthInTiles == 0 )? -1 : top - 1;
        right = ( (i + 1) % level.widthInTiles == 0 )? -1: top + 1;

        // advance lava
        if ( this.lava.getTileByIndex( top ) == 12 && this.level.getTileByIndex( i ) != 21 && this.level.getTileByIndex( i ) != 22 ) {
          this.lava.setTileByIndex( i, this.lava.getTileByIndex( top ) );
          this.lava.setTileByIndex( top, 0 );
        } else if ( this.lava.getTileByIndex( top ) == 12 && this.level.getTileByIndex( i ) == 21 || this.level.getTileByIndex( i ) == 22 ) { // spread left or right

          rand = Math.random( ) * 100;
          if ( rand <= Globals.GAME_LAVA_SPREAD_POSSIBILITY ) { // spread to both sides

          } else if ( rand % 2 == 0 && left != -1 && this.lava.getTileByIndex( left ) != 12 && this.level.getTileByIndex( left ) != 21 && this.level.getTileByIndex( left ) != 22 ) { // just spread left
            this.lava.setTileByIndex( left, this.lava.getTileByIndex( top ) );
            this.lava.setTileByIndex( top, 0 );
          } else if( right != -1 && this.lava.getTileByIndex( right ) != 12 && this.level.getTileByIndex( right ) != 21 && this.level.getTileByIndex( right ) != 22 ) { // just spread right
            this.lava.setTileByIndex( right, this.lava.getTileByIndex( top ) );
            this.lava.setTileByIndex( top, 0 );
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

      }

      // correct animations
    }

  }

}