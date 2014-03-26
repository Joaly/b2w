package
{
	/* 8===D~ */
<<<<<<< HEAD
	//hololo 
=======
	//hololo
	//wulululwuwu
>>>>>>> 255dcb40ddf996eeede932c765dcd96f388815e0
	
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
