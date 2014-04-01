package enemies 
{
	import characters.Player;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	public class DisparoEnemigo extends Sprite 
	{
		
		//Imagen disparo.
		private var disparo:Image;
		
		//Posicion de inicio del disparo.
		private var inicioX:Number;
		private var inicioY:Number;
		
		private var enemigo:Enemigo;
		
		private var player:Player;
		
		public function DisparoEnemigo(inicioX:Number, inicioY:Number, enemigo:Enemigo, player:Player)
		{
			super();
		
			this.inicioX = inicioX;
			this.inicioY = inicioY;
			this.enemigo = enemigo;
			this.player = player;

			this.addEventListener(Event.ADDED_TO_STAGE, crearDisparo);
		}
		
		private function crearDisparo(event:Event):void
		{
			
			this.removeEventListener(Event.ADDED_TO_STAGE, crearDisparo);
			
			disparo = new Image(Media.getTexture("Bala1")); //El disparo tendrá la imagen de la Bala.
			
			
			disparo.x = inicioX; //Ponemos las coordenadas de inicio de la bala.
			disparo.y = inicioY;
			
			disparo.scaleX = 0.05;
			disparo.scaleY = 0.05;
			
			this.addChild(disparo);
			
			this.addEventListener(Event.ENTER_FRAME, ataqueEnemigo);
			
		}
		
		private function ataqueEnemigo():void //Función dedicada a realizar el ataque del enemigo.
		{

			if(disparo.x < player.x) disparo.x += 1;
			if(disparo.x > player.x) disparo.x -= 1;
			if (disparo.y < player.y) disparo.y += 1;
			if (disparo.y > player.y) disparo.y -= 1;
				
			trace(disparo.x, player.x);
			
			if (player.bounds.intersects(enemigo.bounds) || disparo.bounds.intersects(player.bounds)) this.removeEventListener(Event.ENTER_FRAME, ataqueEnemigo);
		}
	}

}