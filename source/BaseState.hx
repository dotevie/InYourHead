package;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxState;

class BaseState extends FlxState {
    public var uiCamera:FlxCamera;
    public static var current:BaseState;

    // 640x360 game, 1280x720 ui
    override public function create() {
        current = this;
        super.create();
        FlxG.camera.zoom = 2;
        FlxG.camera.scroll.subtract(Main.STAGE_WIDTH / 2, Main.STAGE_HEIGHT / 2);
        uiCamera = new FlxCamera();
        uiCamera.bgColor = 0;
        FlxG.cameras.add(uiCamera, false);
    }
}