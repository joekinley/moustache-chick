package  
{
  import org.flixel.FlxState;
  import org.flixel.FlxG;
  import org.flixel.FlxText;
	/**
   * ...
   * @author ...
   */
  public class CreditState extends FlxState
  {
    
    public function CreditState() 
    {
      
    }
    
    override public function create( ):void {
      var credits_1:FlxText = new FlxText( 50, 50, 200, 'EVERYTHING CREATED BY' );
      add( credits_1 );
      var credits_2:FlxText = new FlxText( 50, 60, 200, 'Rafael Wenzel' );
      credits_2.alignment = 'right';
      add( credits_2 );
      /*
      var credits_3:FlxText = new FlxText( 50, 80, 200, 'PROGRAMMED BY' );
      add( credits_3 );
      var credits_4:FlxText = new FlxText( 50, 90, 200, 'Rafael Wenzel' );
      credits_4.alignment = 'right';
      add( credits_4 );
      
      var credits_5:FlxText = new FlxText( 50, 110, 200, 'GRAPHICS BY' );
      add( credits_5 );
      var credits_6:FlxText = new FlxText( 50, 120, 200, 'Rafael Wenzel' );
      credits_6.alignment = 'right';
      add( credits_6 );
      
      var credits_7:FlxText = new FlxText( 50, 140, 200, 'AUDIO BY' );
      add( credits_7 );
      var credits_8:FlxText = new FlxText( 50, 150, 200, 'Rafael Wenzel' );
      credits_8.alignment = 'right';
      add( credits_8 );
      */
      var credits_9:FlxText = new FlxText( 50, 80, 200, 'SPECIAL THANKS TO' );
      add( credits_9 );
      var credits_10:FlxText = new FlxText( 50, 90, 200, 'Levin Beicht' );
      credits_10.alignment = 'right';
      add( credits_10 );
    }
    
    override public function update( ):void {
      
      if ( FlxG.keys.any( ) ) {
        FlxG.switchState( new MenuState ); 
      }
      
      super.update( );
    }
    
  }

}