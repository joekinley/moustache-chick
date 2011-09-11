package
{
  import org.flixel.*;
  public class PlayState extends FlxState
  {
    [Embed(source = '../assets/music/LD21.mp3')] private var Music:Class;
    
    private var save:FlxSave;

    public function PlayState()
    {
    }

    override public function create():void
    {
      save = new FlxSave( );
      save.bind( Globals.GAME_SAVE_NAME );
      
      if ( save.data.progress != null ) Globals.progress = save.data.progress;
      
      FlxG.playMusic( Music );// play music
      Globals.health = Globals.PLAYER_START_HEALTH;
      Globals.score = 0;

      var game:Game = new Game( Globals.progress, Globals.Tiles );
      FlxG.switchState( game );
      // FlxG.switchState( new LevelSelect );
    }

    override public function destroy( ):void {
      //FlxG.music.stop( );
    }
  }

}