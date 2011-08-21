package
{
  import org.flixel.*;
  public class PlayState extends FlxState
  {
    [Embed(source = '../assets/graphics/tiles.png')] private var Tiles:Class;
    [Embed(source = '../assets/music/LD21.mp3')] private var Music:Class;

    public function PlayState()
    {
    }

    override public function create():void
    {
      FlxG.playMusic( Music );// play music

      var game:Game = new Game( 1, Tiles );
      FlxG.switchState( game );
    }

    override public function destroy( ):void {
      //FlxG.music.stop( );
    }
  }

}