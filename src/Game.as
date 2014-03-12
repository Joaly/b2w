package
{
	import screens.Stage1;
	import screens.WelcomeScreen;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class Game extends Sprite
	{
		private var _welcome:WelcomeScreen;
		private var _stage01:Stage1;
		
		public function Game()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			_welcome = new WelcomeScreen;
			this.addChild(_welcome);
			
			_stage01 = new Stage1;
			this.addChild(_stage01);
		}
	}
}