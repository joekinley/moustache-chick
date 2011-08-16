package
{
	import flash.display.Sprite;
	import flash.events.Event;
	[Frame(factoryClass = "Preloader")]

	public class Main extends Sprite
	{
		public function Main():void
		{
			if (stage)
			{
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var game:LD21 = new LD21;
			addChild(game);
		}
	}
}