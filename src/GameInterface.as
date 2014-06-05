package
{
	import characters.Player;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class GameInterface extends Sprite
	{
		private var bullet1:Image;
		private var bullet2:Image;
		private var bullet3:Image;
		private var player:Player;
		private var scoreText:TextField;
		private var gearRight:Image;
		private var gearLeft:Image;
		
		public var bulletsFired:int;
		
		public function GameInterface(player:Player)
		{
			super();
			this.player = player;
			this.addEventListener(Event.ADDED_TO_STAGE, createInterface);
			this.addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function createInterface(event:Event):void
		{
			gearLeft = new Image(Media.getTexture("Gear"));
			gearLeft.pivotX = gearLeft.width/2;
			gearLeft.pivotY = gearLeft.height/2;
			gearLeft.scaleX = 0.5;
			gearLeft.scaleY = 0.5;
			gearLeft.x = 20;
			gearLeft.y = stage.stageHeight+5;
			this.addChild(gearLeft);
			
			gearRight = new Image(Media.getTexture("Gear"));
			gearRight.pivotX = gearRight.width/2;
			gearRight.pivotY = gearRight.height/2;
			gearRight.scaleX = 0.5;
			gearRight.scaleY = 0.5;
			gearRight.x = stage.stageWidth-20;
			gearRight.y = stage.stageHeight+5;
			this.addChild(gearRight);
			
			bullet1 = new Image(Media.getTexture(("Bullet")));
			bullet1.scaleX = 0.1;
			bullet1.scaleY = 0.1;
			bullet1.x = 7;
			bullet1.y = stage.stageHeight-8-bullet1.height;
			this.addChild(bullet1);
			
			bullet2 = new Image(Media.getTexture(("Bullet")));
			bullet2.scaleX = 0.1;
			bullet2.scaleY = 0.1;
			bullet2.x = bullet1.x+bullet2.width+4;
			bullet2.y = stage.stageHeight-8-bullet2.height;
			this.addChild(bullet2);
			
			bullet3 = new Image(Media.getTexture(("Bullet")));
			bullet3.scaleX = 0.1;
			bullet3.scaleY = 0.1;
			bullet3.x = bullet2.x+bullet2.width+4;
			bullet3.y = stage.stageHeight-8-bullet3.height;
			this.addChild(bullet3);
			
			scoreText = new TextField(100, 20, player.score.toString(), "Square", 14, 0xffffff);
			this.addChild(scoreText);
			scoreText.hAlign = "right";
			scoreText.x = stage.stageWidth-scoreText.width-7;
			scoreText.y = stage.stageHeight-scoreText.height-7;
		} 
		
		public function bulletFired():void
		{
			if (player.shotsFired == 3) bullet1.visible = false;
			
			if (player.shotsFired == 2) bullet2.visible = false;
			
			if (player.shotsFired == 1) bullet3.visible = false;			
		}
		
		public function bulletRestore():void
		{
			bullet1.visible = true;
			bullet2.visible = true;
			bullet3.visible = true;
		}
		
		private function update(event:Event):void
		{
			scoreText.text = player.score.toString();
			gearRight.rotation = player.playerObject.y/5;
			gearLeft.rotation = -player.playerObject.y/5;
		}
	}
}