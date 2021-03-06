package characters
{
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.b2Body;
	
	import com.reyco1.physinjector.PhysInjector;
	import com.reyco1.physinjector.contact.ContactManager;
	import com.reyco1.physinjector.data.PhysicsObject;
	import com.reyco1.physinjector.data.PhysicsProperties;
	import com.reyco1.physinjector.manager.Utils;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import objects.Wall;
	
	import projectiles.PlayerShot;
	
	import screens.Stage1;
	
	import starling.core.Starling;
	import starling.core.starling_internal;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.extensions.ColorArgb;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	import starling.utils.deg2rad;

	public class Player extends Sprite
	{
		private const forceLimit:Number = 120;
		public var playerImage:Image;
		private var playerX:Number;
		private var playerY:Number;
		public var playerObject:PhysicsObject;
		private var playerPhysics:PhysInjector;
		private var touchPos:Point;
		public var position:Point;
		private var wallLeft:Wall;
		private var wallRight:Wall;
		public var onJump:Boolean;
		private var timer:Timer;
		public var shotsFired:Number;
		private var coolDown:Boolean;
		private var jumpForce:b2Vec2;
		private var touchBegin:Touch;
		private var touchEnd:Touch;
		private var slideAllowed:Boolean;
		public var slideSpeed:Number;
		private var slideDistance:Number;
		private var particleConfig:XML;
		private var particle:Texture;
		private var particleSystem:PDParticleSystem;
		private var particleTimer:Timer;
		private var attacking:Boolean;
		private var firstWallContact:Boolean;
		public var sliding:Boolean;
		public var offsetY:Number;
		private var playerInterface:GameInterface;
		private var restored:Boolean;
		public var score:Number;
		private var jumpTimer:Timer;
		private var target:Point;

		public var isDead:Boolean;

		private var playerArt:MovieClip;
		private var weaponArt:MovieClip;
		
		public function Player(physics:PhysInjector, x:Number, y:Number, wallL:Wall, wallR:Wall)
		{
			playerPhysics = physics;
			playerX = x;
			playerY = y;
			wallLeft = wallL;
			wallRight = wallR;

			this.addEventListener(Event.ADDED_TO_STAGE, createPlayer);
		}

		private function createPlayer(event:Event):void
		{
			// Creamos el sprite.
			playerImage = new Image(Media.getTexture("Character"));
			playerImage.pivotX = playerImage.width/2;
			playerImage.pivotY = playerImage.height/2;
			playerImage.scaleX = 0.3;
			playerImage.scaleY = 0.3;
			this.addChild(playerImage);

			playerObject = playerPhysics.injectPhysics(playerImage, PhysInjector.SQUARE, new PhysicsProperties({isDynamic:true, friction:0.5, restitution:0}));
			playerObject.x = playerX;
			playerObject.y = playerY;
			playerObject.physicsProperties.isSensor = true;
			playerObject.name = "player";
			playerObject.physicsProperties.contactGroup = "player";
			
			playerImage.visible = false;

			position = new Point(playerImage.x, playerImage.y);
			onJump = new Boolean(true);
			isDead = new Boolean(false);
			coolDown = new Boolean(false);
			shotsFired = new Number(0);
			timer = new Timer(100, 0);
			particleTimer = new Timer(10, 0);
			jumpTimer = new Timer(100, 0);
			jumpForce = new b2Vec2(0,0);
			attacking = false;
			target = new Point;

			playerObject.body.ApplyForce(new b2Vec2(forceLimit/2, -forceLimit), playerObject.body.GetWorldCenter());
			
			ContactManager.onContactBegin("player", "wall", wallContact, true);
			ContactManager.onContactBegin("player", "contactWeak", enemyContact, true);
			ContactManager.onContactBegin("player", "contactWeakB", enemyContact, true);			
			ContactManager.onContactBegin("player", "shotWeak", enemyContact, true);
			ContactManager.onContactBegin("player", "enemyShot", enemyContact, true);
			//offsetY = 0;
			
			score = new Number;
			playerInterface = new GameInterface(this);
			this.addChild(playerInterface);

			stage.addEventListener(TouchEvent.TOUCH, playerTouch);
			this.addEventListener(Event.ENTER_FRAME, update);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, createPlayer);
			createPlayerArt();
			createWeaponArt();
		}
		
		private function createPlayerArt():void
		{
			playerArt = new MovieClip(Media.getCharAtlas().getTextures("DJumpL__"), 20);	
			playerArt.scaleX = 0.5;
			playerArt.scaleY = 0.5;
			playerArt.pivotX = (playerArt.width / 2) + 20;
			playerArt.pivotY = playerArt.height / 2;
			Starling.juggler.add(playerArt);
			playerArt.loop = false;
			this.addChild(playerArt);
		}
		
		private function createWeaponArt():void
		{
			weaponArt = new MovieClip(Media.getCharAtlas().getTextures("DShotR__"), 20);
			weaponArt.scaleX = 0;
			weaponArt.scaleY = 0;
			weaponArt.pivotX = weaponArt.width / 2;
			weaponArt.pivotY = weaponArt.height / 2;
			Starling.juggler.add(weaponArt);
		}
		
		private function changeAnimation(status:String):void
		{
			switch (status) 
			{
				case "stand":
					if (playerObject.x >= 318.1) 
					{
						this.removeChild(playerArt);
						playerArt = new MovieClip(Media.getCharAtlas().getTextures("DStandR__"), 20);
						playerArt.scaleX = 0.5;
						playerArt.scaleY = 0.5;
						playerArt.pivotX = (playerArt.width / 2) + 20;
						playerArt.pivotY = playerArt.height / 2;
						Starling.juggler.add(playerArt);
						this.addChild(playerArt);
					}
					
					if (playerObject.x <= 65.9) 
					{
						this.removeChild(playerArt);
						playerArt = new MovieClip(Media.getCharAtlas().getTextures("DStandL__"), 20);
						playerArt.scaleX = 0.5;
						playerArt.scaleY = 0.5;
						playerArt.pivotX = (playerArt.width / 2)+20;
						playerArt.pivotY = playerArt.height / 2;
						Starling.juggler.add(playerArt);
						this.addChild(playerArt);
					}
					break;
					
				case "jump":
					if (onJump && playerObject.x > stage.stageWidth /2) 
					{
						this.removeChild(playerArt);
						playerArt = new MovieClip(Media.getCharAtlas().getTextures("DJumpR__"), 35);
						playerArt.scaleX = 0.5;
						playerArt.scaleY = 0.5;
						playerArt.pivotX = (playerArt.width / 2) + 20;
						playerArt.pivotY = playerArt.height / 2;
						Starling.juggler.add(playerArt);
						playerArt.loop = false;
						this.addChild(playerArt);
					}
					
					if (onJump  && playerObject.x < stage.stageWidth /2) 
					{
						this.removeChild(playerArt);
						playerArt = new MovieClip(Media.getCharAtlas().getTextures("DJumpL__"), 35);
						playerArt.scaleX = 0.5;
						playerArt.scaleY = 0.5;
						playerArt.pivotX = (playerArt.width / 2)+20;
						playerArt.pivotY = playerArt.height / 2;
						Starling.juggler.add(playerArt);
						playerArt.loop = false;
						this.addChild(playerArt);
					}
					break;
					
				case "slide":
					if (sliding && playerObject.x == 318.1) 
					{
						this.removeChild(playerArt);
						playerArt = new MovieClip(Media.getCharAtlas().getTextures("DSlideR__"), 40);
						playerArt.scaleX = 0.5;
						playerArt.scaleY = 0.5;
						playerArt.pivotX = (playerArt.width / 2) + 20;
						playerArt.pivotY = (playerArt.height / 2);
						Starling.juggler.add(playerArt);
						this.addChild(playerArt);
					}
					
					if (sliding && playerObject.x == 65.9) 
					{
						this.removeChild(playerArt);
						playerArt = new MovieClip(Media.getCharAtlas().getTextures("DSlideL__"), 40);
						playerArt.scaleX = 0.5;
						playerArt.scaleY = 0.5;
						playerArt.pivotX = (playerArt.width / 2) + 20;
						playerArt.pivotY = (playerArt.height / 2);
						Starling.juggler.add(playerArt);
						this.addChild(playerArt);
					}
					break;
					
				case "shoot":
					if (playerObject.x > stage.stageWidth/2) 
					{
						this.removeChild(weaponArt);
						weaponArt = new MovieClip(Media.getCharAtlas().getTextures("DShotR__"), 20);
						weaponArt.pivotX = weaponArt.width;
						weaponArt.pivotY = weaponArt.height;
						weaponArt.scaleX = 0.5;
						weaponArt.scaleY = 0.5;
						weaponArt.x = playerObject.x;
						weaponArt.y = playerObject.y+30;
						weaponArt.rotation = Math.atan((playerObject.y-target.y)/(playerObject.x-target.x));
						if (weaponArt.rotation < 0) weaponArt.x += target.x / 25;
						Starling.juggler.add(weaponArt);
						weaponArt.loop = false;
						this.addChild(weaponArt);
						
						this.removeChild(playerArt);
						playerArt = new MovieClip(Media.getCharAtlas().getTextures("DWhileSR__"), 20);
						playerArt.scaleX = 0.5;
						playerArt.scaleY = 0.5;
						playerArt.pivotX = (playerArt.width / 2) + 5;
						playerArt.pivotY = playerArt.height / 2;
						Starling.juggler.add(playerArt);
						this.addChild(playerArt);
					}
					
					if (playerObject.x < stage.stageWidth/2) 
					{
						this.removeChild(playerArt);
						playerArt = new MovieClip(Media.getCharAtlas().getTextures("DWhileSL__"), 20);
						playerArt.scaleX = 0.5;
						playerArt.scaleY = 0.5;
						playerArt.pivotX = (playerArt.width / 2) + 20;
						playerArt.pivotY = playerArt.height / 2;
						Starling.juggler.add(playerArt);
						this.addChild(playerArt);
						
						this.removeChild(weaponArt);
						weaponArt = new MovieClip(Media.getCharAtlas().getTextures("DShotL__"), 20);
						weaponArt.pivotX = 0;
						weaponArt.pivotY = weaponArt.height;
						weaponArt.scaleX = 0.5;
						weaponArt.scaleY = 0.5;
						weaponArt.x = playerObject.x;
						weaponArt.y = playerObject.y+30;
						weaponArt.rotation = Math.atan((playerObject.y-target.y)/(playerObject.x-target.x));
						if (weaponArt.rotation < 0) weaponArt.x += target.x / 25;
						Starling.juggler.add(weaponArt);
						weaponArt.loop = false;
						this.addChild(weaponArt);
					}
					break;
					
				case "attack":
					if (attacking && playerObject.x > stage.stageWidth /2) 
					{
						this.removeChild(playerArt);
						playerArt = new MovieClip(Media.getCharAtlas().getTextures("DAttackR__"), 50);
						playerArt.scaleX = 0.5;
						playerArt.scaleY = 0.5;
						playerArt.pivotX = (playerArt.width / 2) + 20;
						playerArt.pivotY = playerArt.height / 2;
						Starling.juggler.add(playerArt);
						playerArt.loop = false;
						this.addChild(playerArt);
					}
					
					if (attacking && playerObject.x < stage.stageWidth /2) 
					{
						this.removeChild(playerArt);
						playerArt = new MovieClip(Media.getCharAtlas().getTextures("DAttackL__"), 50);
						playerArt.scaleX = 0.5;
						playerArt.scaleY = 0.5;
						playerArt.pivotX = (playerArt.width / 2) + 20;
						playerArt.pivotY = playerArt.height / 2;
						Starling.juggler.add(playerArt);
						playerArt.loop = false;
						this.addChild(playerArt);
					}
					break;				
				default:
			}
		}

		private function playerTouch(event:TouchEvent):void
		{
			if (event.getTouch(stage, TouchPhase.BEGAN))
			{
				// Si tocamos cerca del jugador almacenamos las coordenadas.
				if ((event.getTouch(stage, TouchPhase.BEGAN).globalX >= playerObject.x-playerImage.width && !onJump)
					&& (event.getTouch(stage, TouchPhase.BEGAN).globalX <= playerObject.x+playerImage.width)
					&& (event.getTouch(stage, TouchPhase.BEGAN).globalY >= playerObject.y-playerImage.height)
					&& (event.getTouch(stage, TouchPhase.BEGAN).globalY <= playerObject.y+playerImage.height))
				{
					touchBegin = event.getTouch(stage, TouchPhase.BEGAN);
					jumpForce.x = new Number(touchBegin.globalX);
					jumpForce.y = new Number(touchBegin.globalY);
					trace(jumpForce.y);
					trace(playerObject.y);
				}

				// En caso contario, realizamos un disparo.
				else if (!onJump) 
				{
					if ((playerObject.x < stage.stageWidth/2 && event.getTouch(stage, TouchPhase.BEGAN).globalX > playerObject.x+30) 
						|| (playerObject.x > stage.stageWidth/2 && event.getTouch(stage, TouchPhase.BEGAN).globalX < playerObject.x-30))
					{
						shoot(event.getTouch(stage, TouchPhase.BEGAN));
						touchBegin = null;
					}
				}
				else attack();
			}

			if (event.getTouch(stage, TouchPhase.ENDED)) 
			{
				// Si hemos tocado cerca del jugador, al finalizar el toque realizamos un salto.
				if (jumpForce.x == event.getTouch(stage, TouchPhase.ENDED).globalX
					&& jumpForce.y == event.getTouch(stage, TouchPhase.ENDED).globalY) touchBegin = null;
				if (touchBegin && event.getTouch(stage, TouchPhase.ENDED).globalY < playerObject.y-playerImage.height
					&& ((playerObject.x < stage.stageWidth/2
					&& event.getTouch(stage, TouchPhase.ENDED).globalX > Stage1.OFFSET)
					|| (playerObject.x > stage.stageWidth/2
					&& event.getTouch(stage, TouchPhase.ENDED).globalX < stage.stageWidth-Stage1.OFFSET)))
				{
					touchEnd = event.getTouch(stage, TouchPhase.ENDED);
					jumpForce.x = (touchEnd.globalX - jumpForce.x) * 1.5;
					jumpForce.y = (touchEnd.globalY - jumpForce.y) * 1.5;
					touchBegin = null;
					touchEnd = null;
					jump(jumpForce);
				}

				else if (event.getTouch(stage, TouchPhase.ENDED).globalY > playerObject.y+playerImage.height && touchBegin)
				{
					if (slideAllowed)
					{
						touchBegin = null;
						slideSpeed = 5;
						slideDistance = 0;
						slideAllowed = false;
						sliding = true;
						this.addEventListener(Event.ENTER_FRAME, slideDown);
						changeAnimation("slide");
					}
				}
			}
		}

		private function update(event:Event):void
		{
			position.x = playerObject.x;
			position.y = playerObject.y;
			
			playerArt.x = playerObject.x;
			playerArt.y = playerObject.y;
			
			if (playerObject.name == "respawn") playerDeath();
			if (playerObject.y > stage.stageHeight+playerImage.height*2) playerObject.name = "respawn";
			
			if (!coolDown)
			{
				if (timer.currentCount >= 5 && !restored) 
				{
					playerInterface.bulletRestore();
					restored = true;
				}
			}
			else if (timer.currentCount >= 20) 
			{
				playerInterface.bulletRestore();
			}
			
			if (onJump && jumpTimer.currentCount > 10) Stage1.cameraOn = false;
			
			if (this.contains(weaponArt) && weaponArt.currentFrame == 12)
			{
				this.removeChild(weaponArt);
				changeAnimation("stand");
			}
		}

		private function wallContact(player:PhysicsObject, wall:PhysicsObject, contact:b2Contact):void
		{
			if (!firstWallContact)
			{
				firstWallContact = true;
				Stage1.cameraOn = true;
			}
			
			else offsetY -= 10;
			playerObject.physicsProperties.isDynamic = false;
			onJump = false;
			slideAllowed = true;
			playerImage.blendMode = BlendMode.NORMAL;
			attacking = false;

			if (wall.name == "Left") playerObject.x = Stage1.OFFSET+playerImage.width/2;
			else playerObject.x = stage.stageWidth-Stage1.OFFSET-playerImage.width/2;
			
			jumpTimer.reset();
			changeAnimation("stand");
		}

		private function enemyContact(player:PhysicsObject, enemy:PhysicsObject, contact:b2Contact):void
		{
			if (attacking && enemy.physicsProperties.contactGroup.substr(0,11) == "contactWeak") enemy.physicsProperties.name = "slashed";
			else
			{
				player.name = "respawn";
				if (enemy.physicsProperties.contactGroup == "enemyShot") enemy.physicsProperties.name = "bounced";
			}
		}

		private function jump(force:b2Vec2):void
		{
			playerObject.physicsProperties.isDynamic = true;
			onJump = true;
			
			if (force.y < -forceLimit) force.y = -forceLimit;
			if (force.y > 0) 
			{
				force.y = 0;
				force.x = 0;
			}
			if (force.x < -forceLimit) force.x = -forceLimit;
			if (force.x > forceLimit) force.x = forceLimit;
			playerObject.body.ApplyForce(force, playerObject.body.GetWorldCenter()); // Aplicamos la fuerza al jugador para que salte.
			
			jumpTimer.start();
			changeAnimation("jump");
		}

		private function shoot(touchPos:Touch):void
		{
			if (!coolDown)
			{
				var shot:PlayerShot = new PlayerShot(playerPhysics, playerObject.x, playerObject.y, 15, new Point(touchPos.globalX, touchPos.globalY), false);
				this.addChild(shot);
				restored = false;
				target.x = touchPos.globalX;
				target.y = touchPos.globalY;					
				changeAnimation("shoot");

				if (timer.currentCount < 5) 
				{
					shotsFired++;
				}
				else //if (timer.currentCount >= 30) 
				{
					shotsFired = 1;
				}
				timer.reset();
				timer.start();
				
				if (shotsFired >= 3)
				{
					coolDown = true;
					timer.reset();
					timer.start();
				}
				playerInterface.bulletFired();
			}			

			if (coolDown && timer.currentCount >= 20)
			{
				timer.reset();
				timer.stop();
				coolDown = false;
				shotsFired = 0;
				shoot(touchPos);
			}
		}

		private function slideDown():void
		{
			if (slideDistance < 100)
			{
				//playerObject.y += slideSpeed;
				slideDistance += slideSpeed;
				//playerImage.y += slideSpeed;
				slideSpeed += 1;
			}

			else 
			{
				sliding = false;
				this.removeEventListener(Event.ENTER_FRAME, slideDown);
				changeAnimation("stand");
			}
		}

		private function playerDeath():void			
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
			stage.removeEventListener(TouchEvent.TOUCH, playerTouch);
			onJump = false;
			
			isDead = true;
			
			playerObject.name = "player";
			playerImage.visible = false;
			playerObject.physicsProperties.active = false;
			particleConfig = new XML(Media.getXML("ParticleConfig"));
			particle = Media.getTexture("Particle");
			particleSystem = new PDParticleSystem(particleConfig, particle);
			this.addChild(particleSystem);
			particleSystem.x = playerObject.x;
			particleSystem.y = playerObject.y;
			Starling.juggler.add(particleSystem);
			particleSystem.startSize *= 2;
			particleSystem.emitAngleVariance = 10;
			particleSystem.startColor = new ColorArgb(0,0.5,2.5,2);
			particleSystem.endColor = new ColorArgb(0,0,2.5,2);
			particleSystem.lifespan *= 0.6;
			particleSystem.start();		
			this.addEventListener(Event.ENTER_FRAME, particleFade);
			particleTimer.reset();
			particleTimer.start();
			
			this.removeChild(playerArt);
			this.removeChild(weaponArt);
		}

		private function particleFade(event:Event):void
		{
			if (particleTimer.currentCount >= 10) particleSystem.stop(false);			
			if (particleTimer.currentCount >= 50)
			{
				this.addEventListener(Event.ENTER_FRAME, update);
				particleSystem.dispose();
				this.removeEventListener(Event.ENTER_FRAME, particleFade);
				
				
			}
		}
		
		private function attack():void
		{
			playerImage.blendMode = BlendMode.SCREEN;
			attacking = true;
			changeAnimation("attack");
		}
	}
}