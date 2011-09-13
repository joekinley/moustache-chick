package  
{
  import org.flixel.FlxButton;
  import org.flixel.FlxState;
  import org.flixel.FlxG;
  import org.flixel.FlxText;
  import org.flixel.FlxTilemap;
  import org.flixel.system.FlxTile;
  import org.flixel.FlxObject;
	/**
   * ...
   * @author ...
   */
  public class LevelSelect extends FlxState
  {
    [Embed(source = '../assets/graphics/levels_2.png')] private var Levels:Class;
    private var levelTiles:FlxTilemap;
    
    public function LevelSelect() 
    {
    }
    
    override public function create( ):void {
      FlxG.mouse.show( );
      levelTiles = new FlxTilemap( );
      levelTiles.loadMap( FlxTilemap.arrayToCSV( this.getLevelMap( ), 10 ), this.Levels, Globals.TILE_WIDTH*2, Globals.TILE_HEIGHT*2, 0, 1, 1 );
      //levelTiles.setTileProperties( 1, FlxObject.ANY, gotoLevel, null, 45 );
      this.add( levelTiles );
      
      // draw level numbers
      var posX:int = 0; var posY:int = 0;
      for ( var i:int = 1; i <= Globals.progress; i++ ) {
        
        var levNum:FlxText = new FlxText( posX, posY + 10, Globals.TILE_WIDTH * 2, i.toString( ) );
        levNum.alignment = 'center';
        add( levNum );
        
        posX += Globals.TILE_WIDTH * 2;
        if ( posX >= 10 * (Globals.TILE_WIDTH * 2) ) {
          posY += Globals.TILE_HEIGHT * 2;
          posX = 0;
        }
      }
    }
    
    public function gotoLevel( myLevel:int ):void {
      var game:Game = new Game( myLevel, Globals.Tiles );
      FlxG.switchState( game );
      FlxG.mouse.hide( );
    }
    
    override public function update( ):void {
      var clicked:int;
      
      if ( FlxG.mouse.justPressed( ) ) {
        clicked = this.levelTiles.getTile( (int)(FlxG.mouse.x / (Globals.TILE_WIDTH*2)), (int)(FlxG.mouse.y / (Globals.TILE_HEIGHT*2)) );
        
        if ( clicked > 0 ) gotoLevel( clicked );
      }
    }
    
    public function getLevelMap( ):Array {
      var map:Array = new Array( );
      
      for ( var i:int = 0; i < 50; i++ ) {
        if ( i < Globals.progress ) map[ i ] = i + 1;
        else map[ i ] = 0;
      }
      
      return map;
    }
    
  }

}