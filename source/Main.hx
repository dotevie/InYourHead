package;

import flixel.FlxGame;
import openfl.display.Sprite;
import backend.AdaptiveAudioManager;

class Main extends Sprite
{
	public static var STAGE_WIDTH:Int = 640;
	public static var STAGE_HEIGHT:Int = 360;
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, TitleState, 60, 60, true));
	}
}
