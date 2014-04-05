package projectiles
{
	import characters.Player;
	import starling.animation.Tween;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;	
	import starling.utils.deg2rad;
	import starling.core.Starling;
	
	public class Bullet extends Sprite
	{
		//Imagen disparo.
		private var bulletImage:Image;
		
		//Posición de inició del disparo.
		private var bulletStartX:Number;
		private var bulletStartY:Number;
		
		//Velocidad del disparo.
		private var bulletSpeed:Number;
		
		//Variable jugador.
		private var playerObjective:Player;
		
		//Posición donde el disparo debe ir.
		private var positionX:Number;
		private var positionY:Number;
		
		private var tween:Tween;
		
		public function Bullet(player:Player, startX:Number, startY:Number)
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
			bulletImage.scaleX = 0.04;
			bulletImage.scaleY = 0.04;	
			
			positionX = new Number(playerObjective.position.x);
			positionY = new Number(playerObjective.position.y);
			
			bulletSpeed = new Number(20); // Inicializamos la velocidad.
			
			tween = new Tween(bulletImage,bulletSpeed);
			
			Starling.juggler.add(tween);
			
			this.addChild(bulletImage);
			
			this.addEventListener(Event.ENTER_FRAME, movement);	// Determinamos el movimiento de la bala.
		}
		
		private function movement():void
		{
			
			tween.moveTo(positionX, positionY); //La bala irá hasta la posición donde el jugador estaba cuando el enemigo ataca.
			
			if (bulletImage.bounds.intersects(playerObjective.bounds)) // Si la bala toca al objetivo, ambos desaparecen.
			{
				playerObjective.isDead = true;
				this.removeFromParent();
				playerObjective.visible = false;
			}
			
			if (Math.round(tween.currentTime) == 2) //Si la bala falla (pasará como 2-3 segundos) entonces es eliminada.
			{
				this.removeFromParent();
			}
		}
	}
}