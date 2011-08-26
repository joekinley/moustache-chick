package
{

  import org.flixel.FlxGame;
  [Frame(factoryClass = "Preloader")]
  
	public class LD21 extends FlxGame
	{
		public function LD21():void
		{
			super(320, 240, MenuState, 2);
		}
	}

}