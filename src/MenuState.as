package
{
  import org.flixel.*;
	public class MenuState extends FlxState
	{
		private var startButton:FlxButton;
    private var creditButton:FlxButton;
    
		public function MenuState():void
		{
      super( );
		}
		override public function create():void
		{
      var back:FlxSprite = new FlxSprite( 0, 0, Globals.MenuBackground );
      add( back );

			FlxG.mouse.show();
			startButton = new FlxButton(120, 165, "Start Game", startGame);
			add(startButton);
      creditButton = new FlxButton( 120, 190, "Credits", credits);
      add( creditButton );

      var text:FlxText = new FlxText( 90, 210, 200, 'Cursor keys for movement' );
      add( text );
      var text2:FlxText = new FlxText( 90, 220, 200, '[A] or [UP] for jump' );
      add( text2 );
		}
    
    override public function update( ):void {
      if ( FlxG.keys.any( ) ) {
        this.startGame( );
      }
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
	}

}