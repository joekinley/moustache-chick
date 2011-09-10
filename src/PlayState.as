package
{
  import org.flixel.*;
  public class PlayState extends FlxState
  {
    [Embed(source = '../assets/graphics/tiles_2.png')] private var Tiles:Class;
    [Embed(source = '../assets/music/LD21.mp3')] private var Music:Class;

    public function PlayState()
    {
    }

    override public function create():void
    {
      FlxG.playMusic( Music );// play music
      Globals.health = Globals.PLAYER_START_HEALTH;
      Globals.score = 0;

      var game:Game = new Game( 40, Tiles );
      FlxG.switchState( game );
    }

    override public function destroy( ):void {
      //FlxG.music.stop( );
    }
  }

}