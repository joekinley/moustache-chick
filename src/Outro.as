package  
{
  import org.flixel.FlxPoint;
  import org.flixel.FlxSprite;
  import org.flixel.FlxState;
  import org.flixel.FlxG;
  import org.flixel.FlxText;
  import mochi.as3.MochiScores;
  import flash.ui.Mouse;
  
	/**
   * ...
   * @author ...
   */
  public class Outro extends FlxState
  {
    [Embed(source = '../assets/graphics/intro.png')] private var Image:Class;
    private var currentScreen:FlxSprite;
    private var animationTimer:Number;
    private var text:FlxText;
    private var current:int;
    
    public function Outro() 
    {
      
    }
    
    override public function create( ):void {
      
      if ( Globals.score > 0 ) {
        Mouse.show( );
        var o:Object = { n: [3, 12, 14, 11, 14, 10, 9, 4, 1, 13, 2, 12, 6, 3, 13, 14], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
        var boardID:String = o.f(0,"");
        MochiScores.showLeaderboard({boardID: boardID, score: Globals.score});
      }
      
      animationTimer = 0;
      current = 0;
      
      text = new FlxText( 30, 200, 290, '' );
      add ( text );
      
      currentScreen = new FlxSprite
      currentScreen.loadGraphic( Image, false, false, 60, 40 );
      currentScreen.x = 120;
      currentScreen.y = 100;
      
      currentScreen.addAnimation( '1', [16] );
      currentScreen.addAnimation( '2', [17] );
      currentScreen.addAnimation( '3', [18] );
      currentScreen.addAnimation( '4', [19] );
      currentScreen.addAnimation( '5', [20] );
      currentScreen.addAnimation( '6', [21] );
      currentScreen.addAnimation( '7', [22] );
      currentScreen.addAnimation( '8', [23] );
      currentScreen.addAnimation( '9', [24] );
      currentScreen.scale = new FlxPoint( 3, 3 );
      
      add( currentScreen );
      
      nextScreen( );
    }
    
    override public function update( ):void {
      animationTimer += FlxG.elapsed;
      
      if ( animationTimer > 10 ) {
        nextScreen( );
        animationTimer = 0;
      }
      
      // quit properly
      if ( current > 9 ) {
        quitOutro( );
      }
    }
    
    public function quitOutro( ):void {
      
      FlxG.mouse.hide();
			FlxG.switchState(new CreditState);
    }
    
    public function nextScreen( ):void {
      current++;
      
      this.currentScreen.play( current.toString( ) );
      showText( );
    }
    
    public function showText( ):void {
      
      var output:String;
      
      switch( this.current ) {
        case 1: output = "Nooooooooooo"; break;
        case 2: output = "Yay my ladyshaver. I did it!"; break;
        case 3: output = "... and finally Moustache chick could prepare herself for the date she looked forward to for so long."; break;
        case 4: output = "Okay better be cautious."; break;
        case 5: output = "Nearly done."; break;
        case 6: output = "Aaah. That feels so much better now."; break;
        case 7: output = "Do I look nice in this dress?"; break;
        case 8: output = "*kiss* Perfect girl for a perfect date."; break;
        case 9: output = "... we wish our chick the very best for her date."; break;
        default: output = ""; break;
      }
      
      this.text.text = output;
    }
    
  }

}