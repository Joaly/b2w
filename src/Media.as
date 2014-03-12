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
		
		private static var _textures:Dictionary = new Dictionary();
		
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
	}
}