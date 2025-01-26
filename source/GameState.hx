package;

import asepriteatlas.AsepriteAtlasFrames;
import flixel.FlxSprite;
import lime.utils.Assets;
import ui.GameUI;
import backend.AdaptiveAudioManager;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import backend.CustomTypedText;

class GameState extends BaseState
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
		AdaptiveAudioManager.play();
		add(new Character(20, 20));
	}

	function doFadeOut() {
		gameui.fadeOut(AdaptiveAudioManager.play);
	}

	function complete(name:String) {
		gameui.fadeOut(() -> _complete(name));
	}
	
	private function _complete(name:String) {

	}

	var curTrack:Int = 0;
	function playNextTrack() {
		if (curTrack < 4) AdaptiveAudioManager.fadeIn(++curTrack);
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
