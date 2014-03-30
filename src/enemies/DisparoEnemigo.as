package enemies 
{
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
		
		
		public function DisparoEnemigo(inicioX:Number, inicioY:Number) 
		{
			super();
			
			this.inicioX = inicioX; //Guardamos la posición de inicio del disparo.
			this.inicioY = inicioY;

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
			
		}
	}

}