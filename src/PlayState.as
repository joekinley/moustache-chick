package
{
  import org.flixel.*;
  public class PlayState extends FlxState
  {
    [Embed(source = '../assets/graphics/tiles.png')] private var Tiles:Class;

    public function PlayState()
    {
    }

    override public function create():void
    {
      var game:Game = new Game( 0, Tiles );
      FlxG.switchState( game );
    }
  }

}