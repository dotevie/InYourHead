package;

import flixel.text.FlxText;

class DoneState extends BaseState {
    public override function create() {
        super.create();
        var txt:FlxText = new FlxText(0,0,0,"We ran out of time!").setFormat("assets/fonts/CaveatBrush.ttf", 96);
        txt.camera = uiCamera;
        txt.screenCenter();
        add(txt);
    }
}