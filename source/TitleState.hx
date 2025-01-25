package;

import lime.utils.Assets;
import flxgif.FlxGifSprite;
import ui.GameUI;
import backend.AdaptiveAudioManager;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import backend.CustomTypedText;

class TitleState extends BaseState
{
	public var titleText:FlxText;
	public var gameui:GameUI;
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
		gameui = new GameUI();
		add(gameui);
		gameui.loadMetaContainer("KevinIntro");
		gameui.fadeIn(gameui.playNext);
		//AdaptiveAudioManager.play();
	}

	function doFadeOut() {
		gameui.fadeOut(AdaptiveAudioManager.play);
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
