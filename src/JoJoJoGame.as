package
{
	/* 8===D~ */
	import flash.display.Sprite;
	
	import starling.core.Starling;
	
	[SWF(width="384", height="512", frameRate="60", backgroundColor="#619462")]
	public class JoJoJoGame extends Sprite
	{
		private var myStarling:Starling;
		
		public function JoJoJoGame()
		{
			myStarling = new Starling(Game, stage);
			myStarling.antiAliasing = 1;
			myStarling.start();
		}
	}
}
