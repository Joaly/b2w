package
{
	import flash.display.Bitmap;
	import flash.utils.Dictionary;
	
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class Media extends Sprite
	{
		[Embed(source= "../media/graphics/welcome_screen.png")]
		public static const WelcomeScreen:Class;
		
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
		
		[Embed(source = "../media/graphics/Mariposa.png")]
		public static const MariposaEnemigo:Class;
		
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
		
		private static var _textures:Dictionary = new Dictionary();
		private static var _xmlFiles:Dictionary = new Dictionary();
		
		public function Media()
		{
			super();
		}
		
		public static function getTexture(name:String):Texture
		{
			if (_textures[name] == undefined)
			{
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
	}
}