package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;

class DoneState extends BaseState {
    public override function create() {
        super.create();
        var txt:FlxText = new FlxText(0,0,0,"We ran out of time!").setFormat("assets/fonts/CaveatBrush.ttf", 96);
        txt.camera = uiCamera;
        txt.screenCenter();
        add(txt);
		var bigSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xff000000);
		bigSprite.camera = uiCamera;
		bigSprite.alpha = 1;
		add(bigSprite);
		FlxTween.tween(bigSprite, {alpha: 0}, 1);
    }
}