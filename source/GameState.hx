package;

import backend.AdaptiveAudioManager;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import ui.GameUI;

class GameState extends BaseState
{
	public var titleText:FlxText;
	public var gameui:GameUI;
	public var bg:FlxSprite;
	public var player:Character;
	public var elijah:Character;
	public var kevin:Character;
	public var aboveText:FlxText;
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
		bg = new FlxSprite().loadGraphic("assets/images/background.png");
		add(bg);
		gameui = new GameUI();
		add(gameui);
		gameui.loadMetaContainer("KevinIntro");
		gameui.fadeIn(gameui.playNext);
		AdaptiveAudioManager.play();
		player = new Character(64, "jin");
		player.y = Main.STAGE_HEIGHT - player.height - 16;
		player.flipX = true;
		add(kevin =
			{
				var c = new Character();
				c.x = player.x + c.width + 64;
				c.y = player.y;
				c;
			});
		elijah = new Character();
		elijah.x = Main.STAGE_WIDTH - elijah.width - 64;
		elijah.y = player.y;
		add(elijah);
		aboveText = new FlxText(elijah.x, elijah.y - 48, "Z").setFormat("assets/fonts/CaveatBrush.ttf", 24, 0xffffffff, CENTER, OUTLINE, 0xff000000);
		aboveText.fieldWidth = elijah.width;
		add(aboveText);
		aboveText.alpha = 0;
		gameui.setBubblePosition(kevin.x + kevin.width + 16, kevin.y - kevin.height, false);
		add(player);
		
	}

	function doFadeOut() {
		gameui.fadeOut(AdaptiveAudioManager.play);
	}

	function complete(name:String) {
		gameui.fadeOut(() -> _complete(name));
	}
	
	private function _complete(name:String) {
		playNextTrack();
		playNextTrack();
		canMove = true;
		if (name == "elijah")
		{
			canMove = false;
			var bigSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xff000000);
			bigSprite.camera = uiCamera;
			bigSprite.alpha = 0;
			add(bigSprite);
			FlxTween.tween(bigSprite, {alpha: 1}, 1, {startDelay: 0.5, onComplete: (_) -> FlxG.switchState(DoneState.new)});
		}
		else if (name == "kevin")
		{
			remove(gameui);
			gameui.destroy();
			gameui = new GameUI();
			add(gameui);
		}
	}

	var curTrack:Int = 0;
	function playNextTrack() {
		if (curTrack < 4) AdaptiveAudioManager.fadeIn(++curTrack);
	}

    function onTag(n) {
        FlxG.camera.flash(FlxColor.WHITE, 0.25);
    }

	var thing = 0;
	public var canMove:Bool = false;
	public var canInteract = true;
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		if (canMove)
		{
			if (FlxG.keys.pressed.RIGHT)
			{
				player.velocity.x = 72;
				player.flipX = true;
				player.animation.play("walk");
			}
			else if (FlxG.keys.pressed.LEFT)
			{
				player.velocity.x = -72;
				player.flipX = false;
				player.animation.play("walk");
			}
			else
			{
				player.velocity.x = 0;
				player.animation.play("idle");
			}
		}

		if (canMove && player.x > Main.STAGE_WIDTH * 0.75)
		{
			canInteract = true;
			aboveText.alpha = 1;
			aboveText.flicker();
			if (FlxG.keys.justPressed.Z)
			{
				canMove = false;
				gameui.loadMetaContainer("ElijahIntro");
				gameui.fadeIn(gameui.playNext);
			}
		}
		else
		{
			canInteract = false;
			aboveText.alpha = 0;
			aboveText.flicker();
		}
		if (FlxG.keys.justPressed.SPACE && thing < 4) {
			AdaptiveAudioManager.fadeIn(++thing);
		}
	}
}
