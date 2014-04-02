package enemies 
{
	import characters.Player;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;	
	import starling.utils.deg2rad;
	
	
	public class DisparoEnemigo extends Sprite 
	{
		
		//Imagen disparo.
		private var bulletImage:Image;
		private var bulletStartX:Number;
		private var bulletStartY:Number;
		private var bulletSpeed:Number;
		private var playerObjective:Player;
		
		public function DisparoEnemigo(player:Player, startX:Number, startY:Number)
		{
			playerObjective = player; // Objetivo de la bala.
			bulletStartX = startX; // Posición origen de la bala.
			bulletStartY = startY;

			this.addEventListener(Event.ADDED_TO_STAGE, createBullet); // Creamos la bala.
		}
		
		private function createBullet(event:Event):void
		{			
			this.removeEventListener(Event.ADDED_TO_STAGE, createBullet);
			
			bulletImage = new Image(Media.getTexture("Bala1"));			
			bulletImage.rotation = deg2rad(-90);
			bulletImage.x = bulletStartX; // Ponemos las coordenadas de inicio de la bala.
			bulletImage.y = bulletStartY;			
			bulletImage.scaleX = 0.05;
			bulletImage.scaleY = 0.05;			
			this.addChild(bulletImage);
			
			bulletSpeed = new Number(3); // Inicializamos la velocidad.
			
			this.addEventListener(Event.ENTER_FRAME, movement);	// Determinamos el movimiento de la bala.
		}
		
		private function movement():void
		{
			// La bala persigue al objetivo.
			if(bulletImage.x < playerObjective.position.x) bulletImage.x += bulletSpeed;
			if(bulletImage.x > playerObjective.position.x) bulletImage.x -= bulletSpeed;
			if (bulletImage.y < playerObjective.position.y) bulletImage.y += bulletSpeed;
			if (bulletImage.y > playerObjective.position.y) bulletImage.y -= bulletSpeed;

			if (bulletImage.bounds.intersects(playerObjective.bounds)) // Si la bala toca al objetivo, ambos desaparecen.
			{
				this.removeFromParent();
				playerObjective.visible = false;
			}
		}
	}

}