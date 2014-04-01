package enemies 
{
	import characters.Player;
	
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	public class Enemigo extends Sprite 
	{
		
		// Imagen enemigo.
		private var enemigo:Image;
		
		// Posición inicial.
		private var inicioX:Number;
		private var inicioY:Number;
		
		// Velocidad enemigo.
		private var velocidad:Number;
		
		private var player:Player;
		

		
		public function Enemigo(inicioX:Number, inicioY:Number, player:Player) 
		{
			super();
			
			this.inicioX = inicioX;
			this.inicioY = inicioY;
			this.player = player;
			
			this.addEventListener(Event.ADDED_TO_STAGE, crearEnemigo); // Inicialización del enemigo.
			
		}
		
		private function crearEnemigo(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, crearEnemigo);
			
			enemigo = new Image(Media.getTexture("Enemigo1")); // El enemigo tendrá la imagen de Huesitos.
			
			enemigo.scaleX = 0.15;
			enemigo.scaleY = 0.15;
			
			enemigo.x = inicioX;
			enemigo.y = inicioY;
			
			this.addChild(enemigo);
			
			velocidad = new Number(3);
			
			this.addEventListener(Event.ENTER_FRAME, movimientoEnemigo); // Bucle enemigo.
		}
		
		private function movimientoEnemigo(event:Event):void // Movemos el enemigo.
		{
			enemigo.x += velocidad;
			
			if (enemigo.x >= 265) velocidad *= -1; //Si llega al lateral derecho se cambiará el sentido del movimiento.
			else if (enemigo.x <= 65) velocidad *= -1;
			
			if (player.bounds.intersects(enemigo.bounds)) this.removeEventListener(Event.ENTER_FRAME, movimientoEnemigo);
			
		}
		
	}

}