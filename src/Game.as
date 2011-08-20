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

    private var game:Game;
    private var player:Player;
    private var gameLevel:int;

    public function Game( number:int, tileset:Class, globalPlayer:Player )
    {
      this.gameLevel = number;
      this.Tiles = tileset;
      this.player = globalPlayer;
    }

    override public function create( ):void {
      // initialize layers
      layerWorld = new FlxGroup;

      level = new FlxTilemap;
      level.loadMap( this.getLevel( this.gameLevel ), Tiles, Globals.TILE_WIDTH, Globals.TILE_HEIGHT, 0, 1, 1, 21 );
      layerWorld.add( level );

      // initialize player
      var startPoint:FlxPoint = level.getTileCoords( Globals.TILES_PLAYER_START, false )[ 0 ];
      player.x = startPoint.x;
      player.y = startPoint.y;

      this.add( layerWorld );
      this.add( player );

      // set camera
      FlxG.camera.follow( player );
      FlxG.camera.setBounds( 0, 0, level.width, level.height );
      FlxG.worldBounds = new FlxRect( 0, 0, level.width, level.height );
    }

    override public function update( ):void {

      FlxG.collide( this.level, this.player );
      super.update( );
    }

    // basic level returner
    public function getLevel( number:int ):String {

      switch( number ) {
        case 1: return FlxTilemap.arrayToCSV( Levels.level1( ), 20 );
      }

      return "";
    }

    // initializes the player object correctly

  }

}