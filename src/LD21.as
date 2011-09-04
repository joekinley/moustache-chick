package
{

  import flash.events.Event;
  import org.flixel.FlxGame;
  import mochi.as3.MochiServices;
  //import mochi.as3.MochiAd;

  //[Frame(factoryClass = "Preloader")]
  
	public dynamic class LD21 extends FlxGame
	{
		public function LD21():void
		{
			super(320, 240, MenuState, 2);
      addEventListener(Event.ADDED_TO_STAGE, init);
		}
    
    private function init( e:Event ):void {
      //MochiServices.connect( "a37cee9a5ae400e2", this.parent );
    }
	}

}