package
{	
	import flash.display.Sprite;
	
	import net.hires.debug.Stats;
	
	import starling.core.Starling;
	
	[SWF(width="384", height="512", frameRate="60", backgroundColor="#000000")]
	public class JoJoJoGame extends Sprite
	{
		private var stats:Stats;
		private var myStarling:Starling;
		
		public function JoJoJoGame()
		{
			stats = new Stats();
			//this.addChild(stats);
			
			myStarling = new Starling(Game, stage);
			myStarling.antiAliasing = 1;
			myStarling.start();
		}
	}
}
