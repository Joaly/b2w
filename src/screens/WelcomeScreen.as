package screens
{
	import flash.utils.Timer;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	
	public class WelcomeScreen extends Sprite
	{
		private var welcomeImage:Image;
		private var titleAnimation:MovieClip;
		private var playButton:Button;
		private var storyButton:Button;
		private var controlsButton:Button;
		private var aboutButton:Button;
		private var gameStage:Stage1;
		private var buttonTimer:Timer;
		private var story:TextField;
		private var back:Button;
		private var bg:Image;
		
		public function WelcomeScreen()
		{
			super();
			this.addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void
		{
			drawScreen();
		}
		
		private function drawScreen():void
		{
			welcomeImage = new Image(Media.getTexture("WelcomeScreen"));
			welcomeImage.width /= 2; //REDIMENSION
			welcomeImage.height /= 2; //REDIMENSION
			this.addChild(welcomeImage);
			
			titleAnimation = new MovieClip(Media.getAtlas().getTextures("GameIntro_"),12);
			titleAnimation.scaleX = 0.5;
			titleAnimation.scaleY = 0.5;
			titleAnimation.loop = false;
			titleAnimation.y = 70;
			Starling.juggler.add(titleAnimation);
			this.addChild(titleAnimation);
			
			buttonTimer = new Timer(10,0);
			buttonTimer.start();
			
			this.addEventListener(Event.ENTER_FRAME, buttonsDelay);
		}
		
		private function buttonsDelay(event:Event):void
		{
			if (buttonTimer.currentCount == 200)
			{
				createButtons();
			}
			
			if (buttonTimer.currentCount > 210)
			{
				playButton.alpha += 0.01;
				storyButton.alpha += 0.01;
				controlsButton.alpha += 0.01;
				aboutButton.alpha += 0.01;
				
				if (playButton.alpha == 1)
				{
					buttonTimer.stop();
					playButton.touchable = true;
					storyButton.touchable = true;
					controlsButton.touchable = true;
					aboutButton.touchable = true;
					this.removeEventListener(Event.ENTER_FRAME, buttonsDelay);
				}
			}
		}
		
		private function createButtons():void
		{
			playButton = new Button(Media.getTexture("Play"));
			playButton.scaleX = 0.3;
			playButton.scaleY = 0.3;
			playButton.x = stage.stageWidth/2 - playButton.width/2;
			playButton.y = 260;
			playButton.alpha = 0;
			playButton.touchable = false;
			this.addChild(playButton);
			
			storyButton = new Button(Media.getTexture("Story"));
			storyButton.scaleX = 0.3;
			storyButton.scaleY = 0.3;
			storyButton.x = stage.stageWidth/2 - storyButton.width/2;
			storyButton.y = 300;
			storyButton.alpha = 0;
			storyButton.touchable = false;
			this.addChild(storyButton);
			
			
			controlsButton = new Button(Media.getTexture("Controls"));
			controlsButton.scaleX = 0.3;
			controlsButton.scaleY = 0.3;
			controlsButton.x = stage.stageWidth/2 - controlsButton.width/2;
			controlsButton.y = 340;
			controlsButton.alpha = 0;
			controlsButton.touchable = false;
			this.addChild(controlsButton);
			
			aboutButton = new Button(Media.getTexture("About"));
			aboutButton.scaleX = 0.3;
			aboutButton.scaleY = 0.3;
			aboutButton.x = stage.stageWidth/2 - aboutButton.width/2;
			aboutButton.y = 380;
			aboutButton.alpha = 0;
			aboutButton.touchable = false;
			this.addChild(aboutButton);
			
			playButton.addEventListener(Event.TRIGGERED, playClick);
			storyButton.addEventListener(Event.TRIGGERED, storyClick);
		}
		
		private function playClick(event:Event):void
		{
			gameStage = new Stage1();
			stage.addChild(gameStage);
		}
		
		private function storyClick(event:Event):void
		{
			bg = new Image(Media.getTexture("WelcomeScreen"));
			bg.scaleX = 0.5;
			bg.scaleY = 0.5;
			this.addChild(bg);
			
			story = new TextField(stage.stageWidth-40, stage.stageHeight-40, "hola", "Verdana", 16, 0xffffff);
			this.addChild(story);
			story.pivotX = story.width/2;
			story.x = stage.stageWidth/2;
			story.y = stage.stageHeight;
			story.text = "Dwayne Varnados was a soldier who was part of a special program of training " +
				"which purpose was to create a generation of super-agents for the FBI: the project MORPHEUS. " +
				"After months of hard physical and mental training, which included inhuman exercises " +
				"and consumption of special drugs to potentiate human attributes, " +
				"Dwayne became a highly qualified super-soldier." +
				"Once Dwayne promoted, the FBI asked him to carry out a top secret mission: " +
				"to assassinate the USA president. Dwayne immediately rejected, and decided to leave the company " +
				"and to move to a little village among mountains, looking for peace and tranquility. "+
				"A few weeks later, Dwayne noticed by an article on the newspaper that the USA president was murdered, " +
				"and the government blamed him. Decided, Dwayne started his own battle against the world with only one purpose: " +
				"to clean his name and discover the truth.";
			
			back = new Button(Media.getTexture("Menu"));
			back.scaleX = 0.4;
			back.scaleY = 0.4;
			back.alpha = 0.5;
			back.x = stage.stageWidth - back.width - 10;
			back.y = stage.stageHeight - back.height - 10;
			back.addEventListener(Event.TRIGGERED, backClick);
			this.addChild(back);
			
			this.addEventListener(Event.ENTER_FRAME, scroll);
		}
		
		private function scroll(event:Event):void
		{
			story.y -= 0.35;
			if (story.y < -story.height-20) story.y = stage.stageHeight;
		}
		
		private function backClick(event:Event):void
		{
			bg.removeFromParent(true);
			back.removeFromParent(true);
			story.removeFromParent(true);
			this.removeEventListener(Event.ENTER_FRAME, scroll);
			
		}
	}
}