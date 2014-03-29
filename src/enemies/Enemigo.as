package enemies 
{
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	
	import flash.geom.Rectangle;
	
	import  characters.Player;
	
	public class Enemigo extends Sprite 
	{
		
		private var enemigo:Image; //Creando la variable para el enemigo.
		private var disparo:Image;
		
		private var inicioX:Number; //Creando las variables donde se iniciará la posición del enemigo.
		private var inicioY:Number;
		
		private var velocidad:Number = 3; //Variable usada para establecer la velocidad del enemigo

		
		public function Enemigo(inicioX:Number, inicioY:Number) 
		{
			super();
			
			this.inicioX = inicioX; //Cuando vayamos a crear el enemigo, deberemos poner las coordenadas donde empezará y se guardáran en las variables anteriormente explicadas.
			this.inicioY = inicioY;
			
			this.addEventListener(Event.ADDED_TO_STAGE, crearEnemigo); //Lo enlazamos con el escenario para que el enemigo se pueda crear.
			
		}
		
		private function crearEnemigo(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, crearEnemigo);
			
			enemigo = new Image(Media.getTexture("Enemigo1")); //El enemigo tendrá la imagen de Huesitos.
			
			enemigo.scaleX = 0.15;
			enemigo.scaleY = 0.15;
			
			enemigo.x = inicioX; //Le ponemos las coordenadas de inicio deseadas al enemigo.
			enemigo.y = inicioY;
			
			this.addChild(enemigo); //Se vuelve visible en enemigo.
			
			this.addEventListener(Event.ENTER_FRAME, movimientoEnemigo); //Vamos a realizar una serie de condiciones para el enemigo.
		}
		
		private function movimientoEnemigo(event:Event):void //Con esta función buscamos que se mueva el enemigo.
		{
			enemigo.x += velocidad;
			
			if (enemigo.x >= 265) velocidad = -2; //Si llega al lateral derecho se cambiará el sentido de la dirección.
			else if (enemigo.x <= 65) velocidad = 2;

		}
		
	}

}