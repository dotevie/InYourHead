package;

import flixel.FlxSprite;

class Character extends FlxSprite {
    public function new(x:Int, y:Int) {
        super(x, y);
        loadGraphic("assets/images/walkBase.png", true, 35, 76);
        animation.add("idle", [1], 12);
        animation.add("walk", [0, 1, 2], 12);
        updateHitbox();
        animation.play("idle");
    }
}