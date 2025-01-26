package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;


class TitleState extends BaseState {
    var titleText:FlxText;
    var pressText:FlxText;

    override public function create() {
        super.create();
		titleText = new FlxText(10, 50, FlxG.width - 20, "In Your Head").setFormat("assets/fonts/CaveatBrush.ttf", 96, CENTER);
        pressText = new FlxText(10, 10, FlxG.width - 20, "Press Z to Start").setFormat("assets/fonts/CaveatBrush.ttf", 64, CENTER);
        pressText.y = FlxG.height - pressText.height - 50;
        titleText.camera = pressText.camera = uiCamera;
        add(titleText);
        add(pressText);
    }

    public var starting:Bool = false;
    override public function update(elapsed:Float) {
        super.update(elapsed);
        if (FlxG.keys.justPressed.Z && !starting) {
            starting = true;
            FlxTween.tween(uiCamera, {alpha: 0}, 1, {onComplete: (_) -> FlxG.switchState(GameState.new)});
        }
    }
}