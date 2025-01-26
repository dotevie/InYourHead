package;

import flixel.FlxSprite;

class Character extends FlxSprite {
	public function new(?x:Int = 0, ?y:Int = 0, ?character:String = "walkBase")
	{
        super(x, y);
		loadGraphic('assets/images/$character.png', true, 35, 76);
		animation.add("idle", [1], 6);
		animation.add("walk", [0, 1, 2], 6);
        updateHitbox();
        animation.play("idle");
    }
}