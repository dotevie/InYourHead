package;

import flixel.text.FlxText;
import flixel.FlxState;

class PlayState extends FlxState
{
	override public function create()
	{
		super.create();
		add({
			var x = new FlxText(0,0,0,"Hello, World!").setFormat(null, 16);
			x.screenCenter();
			x;
		});
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
