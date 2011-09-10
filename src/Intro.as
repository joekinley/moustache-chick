package  
{
  import org.flixel.FlxPoint;
  import org.flixel.FlxSprite;
  import org.flixel.FlxState;
  import org.flixel.FlxG;
  import org.flixel.FlxText;
	
  /**
   * ...
   * @author ...
   */
  public class Intro extends FlxState
  {
    [Embed(source = '../assets/graphics/intro.png')] private var Image:Class;
    private var currentScreen:FlxSprite;
    private var animationTimer:Number;
    private var text:FlxText;
    private var current:int;
    
    public function Intro() 
    {
      
    }
    
    override public function create( ):void {
      
      animationTimer = 0;
      current = 0;
      
      text = new FlxText( 30, 200, 290, '' );
      add ( text );
      
      // keys text
      var keysText:FlxText = new FlxText( 5, 5, 200, '[ESCAPE] to skip' );
      keysText.scale = new FlxPoint( 1, 1 );
      add( keysText );
      var keysText2:FlxText = new FlxText( 5, 15, 200, '[X] for next panel' );
      keysText2.scale = new FlxPoint( 1, 1 );
      add( keysText2 );
      
      currentScreen = new FlxSprite
      currentScreen.loadGraphic( Image, false, false, 60, 40 );
      currentScreen.x = 120;
      currentScreen.y = 100;
      
      currentScreen.addAnimation( '1', [0] );
      currentScreen.addAnimation( '2', [1] );
      currentScreen.addAnimation( '3', [2] );
      currentScreen.addAnimation( '4', [3] );
      currentScreen.addAnimation( '5', [4] );
      currentScreen.addAnimation( '6', [5] );
      currentScreen.addAnimation( '7', [6] );
      currentScreen.addAnimation( '8', [7] );
      currentScreen.addAnimation( '9', [8] );
      currentScreen.addAnimation( '10', [9] );
      currentScreen.addAnimation( '11', [10] );
      currentScreen.addAnimation( '12', [11] );
      currentScreen.addAnimation( '13', [12] );
      currentScreen.addAnimation( '14', [13] );
      currentScreen.addAnimation( '15', [14] );
      currentScreen.addAnimation( '16', [15] );
      currentScreen.scale = new FlxPoint( 3, 3 );
      
      add( currentScreen );
      
      nextScreen( );
    }
    
    override public function update( ):void {
      animationTimer += FlxG.elapsed;
      
      // skip possibility
      if ( FlxG.keys.justPressed( 'ESCAPE' ) ) {
        quitIntro( );
      }
      
      if ( animationTimer > 5 || FlxG.keys.justPressed( 'X' ) ) {
        nextScreen( );
        animationTimer = 0;
      }
      
      // quit properly
      if ( current > 16 ) {
        quitIntro( );
      }
    }
    
    public function quitIntro( ):void {
      
      FlxG.mouse.hide();
			FlxG.switchState(new MenuState);
    }
    
    public function nextScreen( ):void {
      current++;
      
      this.currentScreen.play( current.toString( ) );
      showText( );
    }
    
    public function showText( ):void {
      
      var output:String;
      
      switch( this.current ) {
        case 1: output = "Okay, so we'll meet tonight at 8. Great, see you then."; break;
        case 2: output = "Finally a date after all these years."; break;
        case 3: output = "Do I have a nice dress? And what about my hair?"; break;
        case 4: output = "I could wear the black shoes with the black dress. That'll do."; break;
        case 5: output = "Let's see what I can do with my hair and make-up."; break;
        case 6: output = "G-A-S-P"; break;
        case 7: output = "OMG, I need to shave really bad."; break;
        case 8: output = "Better hurry with that so it can heal on time."; break;
        case 9: output = "Now where is my lady shaver?"; break;
        case 10: output = "HAHA, YOU ARE LOOKING FOR THIS?"; break;
        case 11: output = "Give - me - my - ladyshaver - right - now!"; break;
        case 12: output = "NO! NEVER!"; break;
        case 13: output = "Come here and give it to me!"; break;
        case 14: output = "NO, CATCH ME IF YOU CAN"; break;
        case 15: output = "YOU WILL NEVER GET TO ME"; break;
        case 16: output = "... and so begins the adventure of ..."; break;
        default: output = ""; break;
      }
      
      this.text.text = output;
    }
    
  }

}