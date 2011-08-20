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
      var player:Player = new Player( Tiles );
      var game:Game = new Game( 1, Tiles, player );
      FlxG.switchState( game );
    }
  }

}