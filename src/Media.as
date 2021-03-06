package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	public class Media extends Sprite
	{
		[Embed(source= "../media/graphics/titleScreen.png")]
		public static const WelcomeScreen:Class;
		
		[Embed(source= "../media/graphics/titleSpriteSheet.png")]
		public static const TitleSpriteSheet:Class;
		
		[Embed(source= "../media/graphics/titleConfig.xml", mimeType="application/octet-stream")]
		public static const TitleConfig:Class;
		
		[Embed(source= "../media/graphics/stage_01_bg.png")]
		public static const Stage1Bg:Class;
		
		[Embed(source="../media/graphics/character.png")]
		public static const Character:Class;
		
		[Embed(source="../media/graphics/floor.png")]
		public static const Floor:Class;
		
		[Embed(source="../media/graphics/wallTile.png")]
		public static const WallTile:Class;
		
		[Embed(source = "../media/graphics/Huesitos.png")]
		public static const Enemigo1:Class;
		
		[Embed(source = "../media/graphics/Bala.png")]
		public static const Bala1:Class;
		
		[Embed(source = "../media/graphics/shot.png")]
		public static const PlayerShot:Class;
		
		[Embed(source = "../media/graphics/Medusa.png")]
		public static const MedusaEnemigo:Class;
		
		[Embed(source = "../media/graphics/Medusa2.png")]
		public static const Medusa2Enemigo:Class;
		
		[Embed(source = "../media/graphics/Mariposa.png")]
		public static const MariposaEnemigo:Class;
		
		[Embed(source = "../media/graphics/Mariposa2.png")]
		public static const Mariposa2Enemigo:Class;
		
		[Embed(source="../media/graphics/particle.pex", mimeType="application/octet-stream")]
		private static const ParticleConfig:Class;

		[Embed(source = "../media/graphics/texture.png")]
		private static const Particle:Class;
		
		[Embed(source = "../media/graphics/particleBullet.pex", mimeType = "application/octet-stream")]
		private static const ParticleConfigBullet:Class;
		
		[Embed(source = "../media/graphics/textureBullet.png")]
		private static const ParticleBullet:Class;
		
		[Embed(source = "../media/graphics/ObstaculoBarreraEncendido.png")]
		private static const BarreraEncendido:Class;
		
		[Embed(source = "../media/graphics/ObstaculoBarreraApagado.png")]
		private static const BarreraApagado:Class;
		
		[Embed(source = "../media/graphics/RayoObstaculo.png")]
		private static const BarreraRayo:Class;
		
		[Embed(source = "../media/graphics/BarrierTexture.png")]
		private static const ParticleBarrier:Class;
		
		[Embed(source = "../media/graphics/BarrierTexture.pex", mimeType = "application/octet-stream")]
		private static const ParticleConfigBarrier:Class;
		
		[Embed(source = "../media/graphics/Mina.png")]
		private static const Mine:Class;
		
		[Embed(source = "../media/graphics/MinaExterior.png")]
		private static const MineBox:Class;
		
		[Embed(source = "../media/graphics/Robot.png")]
		private static const WhiteRobot:Class;
		
		[Embed(source = "../media/graphics/RobotBox.png")]
		private static const WhiteRobotBox:Class;
		
		[Embed(source = "../media/graphics/RobotProteccion.png")]
		private static const WhiteRobotCover:Class;
		
		[Embed(source = "../media/graphics/RobotNegro.png")]
		private static const BlackRobot:Class;
		
		[Embed(source = "../media/graphics/RobotNegroProteccion.png")]
		private static const BlackRobotCover:Class;
		
		[Embed(source = "../media/graphics/Tuerca.png")]
		private static const Nut:Class;
		
		[Embed(source = "../media/graphics/TuercaEnganche.png")]
		private static const CoverNut:Class;
		
		[Embed(source = "../media/graphics/TuercaAgarre.png")]
		private static const AgarreNut:Class;
		
		[Embed(source = "../media/graphics/particleTuerca.pex", mimeType = "application/octet-stream")]
		private static const ParticleConfigNut:Class;
		
		[Embed(source = "../media/graphics/textureTuerca.png")]
		private static const ParticleNut:Class;
		
		[Embed(source = "../media/graphics/BG.png")]
		private static const BG:Class;
		
		[Embed(source = "../media/graphics/Rect.png")]
		private static const Rect:Class;
		
		[Embed(source = "../media/graphics/SpriteSheetB2W.png")]
		private static const SheetPNG:Class;
		
		[Embed(source = "../media/graphics/SpriteSheetB2W.xml", mimeType="application/octet-stream")]
		private static const SheetXML:Class;	
		
		[Embed(source = "../media/graphics/obstaculosSpriteSheet.png")]
		private static const obsSheetPNG:Class;
		
		[Embed(source = "../media/graphics/obstaculosSpriteSheet.xml", mimeType="application/octet-stream")]
		private static const obsSheetXML:Class;
		
		//Interfaz.
		[Embed(source = "../media/graphics/interface/bullet.png")]
		private static const Bullet:Class;
		
		[Embed(source = "../media/graphics/interface/gear.png")]
		private static const Gear:Class;
		
		[Embed(source = "../media/graphics/interface/playButton.png")]
		private static const Play:Class;
		
		[Embed(source = "../media/graphics/interface/storyButton.png")]
		private static const Story:Class;
		
		[Embed(source = "../media/graphics/interface/controlsButton.png")]
		private static const Controls:Class;
		
		[Embed(source = "../media/graphics/interface/aboutButton.png")]
		private static const About:Class;
		
		[Embed(source = "../media/graphics/interface/retryButton.png")]
		private static const Retry:Class;
		
		[Embed(source = "../media/graphics/interface/menuButton.png")]
		private static const Menu:Class;
		
		[Embed(source = "../media/graphics/interface/backButton.png")]
		private static const Back:Class;
				
		[Embed(source = "../media/graphics/controls.png")]
		private static const ControlsInst:Class;
		
		[Embed(source = "../media/graphics/CityFront.png")]
		private static const CityFront:Class;
		
		[Embed(source = "../media/graphics/CityMed.png")]
		private static const CityMed:Class;
		
		[Embed(source = "../media/graphics/cityBack.png")]
		private static const CityBack:Class;
		
		[Embed(source = "../media/graphics/Mina1.png")]
		private static const Mina1:Class;
		
		//Fuentes.		
		[Embed(source = "../media/fonts/square.ttf", embedAsCFF="false", fontFamily="Square")]
		private static const Square:Class;
		
		[Embed(source = "../media/fonts/roboto.ttf", embedAsCFF="false", fontFamily="Roboto")]
		private static const Roboto:Class;
		
		
		private static var _textures:Dictionary = new Dictionary();
		private static var _xmlFiles:Dictionary = new Dictionary();
		private static var _titleAtlas:TextureAtlas;
		private static var _charAtlas:TextureAtlas;
		private static var _obsAtlas:TextureAtlas;
		
		public function Media()
		{
			super();
		}
		
		public static function getTexture(name:String):Texture
		{
			if (_textures[name] == undefined)
			{
				trace(name);
				var bitmap:Bitmap = new Media[name]();
				_textures[name] = Texture.fromBitmap(bitmap);
			}
			return _textures[name];
		}
		
		public static function getXML(name:String):XML
		{
			if (_textures[name] == undefined)
			{
				var xml:XML = XML(new Media[name]());
				_xmlFiles[name] = xml;
			}
			return _xmlFiles[name];
		}
		
		public static function getAtlas():TextureAtlas
		{	
			if (_titleAtlas == null) {
				
				var texture:Texture = getTexture("TitleSpriteSheet");
				var xml:XML= XML(new TitleConfig());
				_titleAtlas = new TextureAtlas(texture, xml);
			}
			return _titleAtlas;	
		}
		
		public static function getCharAtlas():TextureAtlas
		{	
			if (_charAtlas == null) {
				
				var texture:Texture = getTexture("SheetPNG");
				var xml:XML= XML(new SheetXML());
				_charAtlas = new TextureAtlas(texture, xml);
			}
			return _charAtlas;	
		}
		
		public static function getObsAtlas():TextureAtlas
		{	
			if (_obsAtlas == null) {
				
				var texture:Texture = getTexture("obsSheetPNG");
				var xml:XML= XML(new obsSheetXML());
				_obsAtlas = new TextureAtlas(texture, xml);
			}
			return _obsAtlas;	
		}
	}
}