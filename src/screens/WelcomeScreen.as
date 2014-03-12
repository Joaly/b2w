package screens
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class WelcomeScreen extends Sprite
	{
		private var _welcomeImage:Image;
		
		public function WelcomeScreen()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			drawScreen();
		}
		
		private function drawScreen():void
		{
			_welcomeImage = new Image(Media.getTexture("WelcomeScreen"));
			_welcomeImage.width /= 2; //REDIMENSION
			_welcomeImage.height /= 2; //REDIMENSION
			this.addChild(_welcomeImage);
		}
	}
}