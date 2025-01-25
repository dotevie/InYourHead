package;

import backend.AdaptiveAudioManager;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import backend.CustomTypedText;

class TitleState extends BaseState
{
	public var titleText:FlxText;
	override public function create()
	{
		AdaptiveAudioManager.configure([
			"assets/music/Track1.ogg",
			"assets/music/Track2.ogg",
			"assets/music/Track3.ogg",
			"assets/music/Track4.ogg",
			"assets/music/Track5.ogg"			
		]);
		super.create();
		// var ctt = new CustomTypedText(10, 10, 0, "What's the deal with airline food? It's <shake>completely terrible!", 32, false);
		// ctt.camera = uiCamera;
		// ctt.skipKeys = [Z];
		// ctt.font = "assets/fonts/OpenSans.ttf";
		// ctt.delay = 0.04;
		// ctt.useDefaultSound = true;
		// ctt.tagCallback = onTag;
		// add(ctt);
		// ctt.start();
		var gameui = new ui.GameUI();
		add(gameui);
		gameui.playNext();
		AdaptiveAudioManager.play();
	}

    function onTag(n) {
        FlxG.camera.flash(FlxColor.WHITE, 0.25);
    }

	var thing = 0;
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.justPressed.SPACE && thing < 4) {
			AdaptiveAudioManager.fadeIn(++thing);
		}
	}
}
