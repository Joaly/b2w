package projectiles
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	
	import flash.geom.Point;
	
	import screens.Stage1;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	
	public class PlayerShot extends Sprite
	{
		private var shotImage:Image;
		private var shotObject:PhysicsObject;
		private var shotPhysics:PhysInjector;
		private var startX:Number;
		private var startY:Number;
		private var speed:Number;
		private var direction:b2Vec2;
		private var target:Point;
		
		
		public function PlayerShot(physics:PhysInjector, x:Number, y:Number, shotSpeed:Number, target:Point)
		{
			shotPhysics = physics;
			startX = x;
			startY = y;
			speed = shotSpeed;
			this.target = new Point(target.x, target.y); // Posición donde irá el disparo.
			
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, createShot);
		}
		
		private function createShot(event:Event):void
		{
			// Creamos la imagen del disparo.
			shotImage = new Image(Media.getTexture("PlayerShot"));
			shotImage.pivotX = shotImage.width/2;
			shotImage.pivotY = shotImage.height/2;
			this.addChild(shotImage);
			
			// Creamos el objeto del disparo.
			shotObject = shotPhysics.injectPhysics(shotImage, PhysInjector.CIRCLE, new PhysicsProperties({isDynamic:true, friction:0.5, restitution:0}));
			shotObject.physicsProperties.isSensor = true;
			shotObject.name = "shot" + new String(Math.round(target.x*target.y*Math.random()));
			shotObject.x = startX;
			shotObject.y = startY;
			
			// Calculamos la velocidad del disparo.
			var speedModule:Number = new Number(Math.sqrt(Math.pow(target.x-startX,2)+Math.pow(target.y-startY,2)));
			direction = new b2Vec2((target.x - startX) / speedModule * speed, (target.y - startY) / speedModule * speed);
			
			Stage1.shots.push(shotObject);
			
			this.addEventListener(Event.ENTER_FRAME, movement);
		}
		
		private function movement(event:Event):void
		{
			
			shotObject.body.SetLinearVelocity(direction); // Aplicamos la velocidad al objeto.
			
			if (shotObject.x < 0 || shotObject.x > stage.stageWidth || shotObject.y < 0 || shotObject.y > stage.stageHeight || shotObject.physicsProperties.name == "bounced") // Eliminamos el disparo cuando salga de pantalla.
			{
				this.removeEventListener(Event.ENTER_FRAME, movement);
				shotObject.physicsProperties.isDynamic = false;
				shotObject.body.GetWorld().DestroyBody(shotObject.body);
				shotObject.dispose();
				this.removeChild(shotImage);
			}
			
			//ContactManager.onContactBegin(shotObject.name, "shotWeak", shotContact); // Si colisiona con un enemigo débil a los disparos lo eliminamos.
			for (var i:int; i < Stage1.enemies.length; i++)
			{
				ContactManager.onContactBegin(shotObject.name, Stage1.enemies[i].name, shotContact);
			}
			
		}
		
		
		private function shotContact(shot:PhysicsObject, enemy:PhysicsObject, contact:b2Contact):void
		{
			enemy.physicsProperties.name = "dead"; // Como no podemos acceder a todas las propiedades del enemigo, cambiamos su nombre y lo eliminamos desde dentro.
			this.removeEventListener(Event.ENTER_FRAME, movement);
			shot.physicsProperties.isDynamic = false;
			shot.body.GetWorld().DestroyBody(shot.body);
			shot.dispose();
			this.removeChild(shotImage);
		}
	}
}