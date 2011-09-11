package  
{
  import org.flixel.FlxButton;
  import org.flixel.FlxState;
  import org.flixel.FlxG;
	/**
   * ...
   * @author ...
   */
  public class LevelSelect extends FlxState
  {
    private var buttons:Array;
    
    public function LevelSelect() 
    {
      buttons = new Array( 45 );
    }
    
    override public function create( ):void {
      
      var posX:int = 0;
      var posY:int = 10;
      
      for ( var i:int = 1; i <= Globals.progress; i++ ) {
        
        posX += 10;
        if ( posX >= 310 ) {
          posX = 10;
          posY += 10;
        }
        buttons[ i - 1 ] = new FlxButton( posX, posY, i.toString( ), gotoLevel );
        buttons[ i -1 ].width = 8;
        
        add( buttons[ i - 1 ] );
      }
    }
    
    public function gotoLevel( ):void {
      var game:Game = new Game( Globals.progress, Globals.Tiles );
      FlxG.switchState( game );
    }
    
    override public function update( ):void {
      
    }
    
  }

}