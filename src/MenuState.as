package
{
  import org.flixel.*;
	public class MenuState extends FlxState
	{
		private var startButton:FlxButton;
		public function MenuState():void
		{
      super( );
		}
		override public function create():void
		{
      var back:FlxSprite = new FlxSprite( 0, 0, Globals.MenuBackground );
      add( back );

			FlxG.mouse.show();
			startButton = new FlxButton(120, 90, "Start Game", startGame);
			add(startButton);

      var text:FlxText = new FlxText( 90, 120, 200, 'Cursor keys for movement' );
      add( text );
      var text2:FlxText = new FlxText( 90, 150, 190, '[a] for whip, after Level "The End" for breaking floors' );
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
	}

}