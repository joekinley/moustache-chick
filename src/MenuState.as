package
{
  import org.flixel.*;
  import mochi.as3.*;
  import flash.ui.Mouse;
	public class MenuState extends FlxState
	{
		private var startButton:FlxButton;
    private var creditButton:FlxButton;
    private var highscoreButton:FlxButton;
    
		public function MenuState():void
		{
      super( );
		}
		override public function create():void
		{
      var back:FlxSprite = new FlxSprite( 0, 0, Globals.MenuBackground );
      add( back );

			FlxG.mouse.show();
			startButton = new FlxButton(120, 155, "Start Game", startGame);
			add(startButton);
      highscoreButton = new FlxButton( 120, 175, "Highscore", highscore );
      add( highscoreButton );
      creditButton = new FlxButton( 120, 195, "Credits", credits);
      add( creditButton );

      var text:FlxText = new FlxText( 90, 210, 200, 'Cursor keys for movement' );
      add( text );
      var text2:FlxText = new FlxText( 90, 220, 200, '[A] or [UP] for jump' );
      add( text2 );
		}
    
    override public function update( ):void {
      //if ( FlxG.keys.any( ) ) {
      //  this.startGame( );
      //}
      
      super.update( );
    }
    
		private function startGame():void
		{
			FlxG.mouse.hide();
			FlxG.switchState(new PlayState);
		}
    
    private function credits( ):void {
      FlxG.mouse.hide( );
      FlxG.switchState( new CreditState );
    }
    
    private function highscore( ):void {
      Mouse.show( );
      var o:Object = { n: [3, 12, 14, 11, 14, 10, 9, 4, 1, 13, 2, 12, 6, 3, 13, 14], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
      var boardID:String = o.f(0,"");
      MochiScores.showLeaderboard( { boardID: boardID } );
      MochiScores.onClose( function( ):void { Mouse.hide( ); FlxG.mouse.show( ); } );
    }
	}

}