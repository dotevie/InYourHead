package ui;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxCamera;
import backend.CustomTypedText;
import flixel.text.FlxText;
import flixel.group.FlxGroup;

using flixel.util.FlxSpriteUtil;

typedef TaggedText = String; // just to be clear which of them gets tags read from it
typedef Filename = String;

/**
    MetaTexts are *almost* always read in order
    the notable exception is with choices where you have to load another MetaTextContainer in
    i know this wan't the smartest way to do it but the loophole i have to do for choices is easier than doing looping
**/
typedef MetaText = {
    name:String,
    text:TaggedText,
    isChoice:Bool,
    ?choice:Array<Choice>
};

typedef Choice = {
    text:TaggedText,
    correct:Bool,
    nextTree:Filename // e.g. "NextTree.json"
};

typedef MetaTextContainer = {
    cacheFiles:Array<Filename>,
    texts:Array<MetaText>
};

@:access(backend.CustomTypedText)
class GameUI extends FlxGroup {
    var nameField:FlxText;
    var gameText:CustomTypedText;
    var metaContainer:MetaTextContainer;
    var currentMeta:MetaText;
    var nextTriangle:FlxSprite;

    public function new(?cam:FlxCamera) {
        super();
        camera = cam ?? BaseState.current.uiCamera;
		gameText = new CustomTypedText(FlxG.width * 0.2, FlxG.height - 142, Std.int(FlxG.width * 0.6), "", 32, false);
        gameText.setFormat("assets/fonts/OpenSans.ttf", 32, FlxColor.WHITE, LEFT);
        gameText.delay = 0.04;
        gameText.useDefaultSound = true;
        gameText.tagCallback = onTag;
        gameText.completeCallback = onTextComplete;
        gameText._finalText = "My name is Jin, and you're about to see me in for the biggest surprise of my life.";
        add(gameText);
        nextTriangle = new FlxSprite(FlxG.width * .8 + 32, FlxG.height - 52).makeGraphic(16, 16, 0).drawTriangle(0,0,16);
        nextTriangle.angle = 90;
        nextTriangle.alpha = 0;
        add(nextTriangle);
        metaContainer = {
            cacheFiles: [],
            texts: [
                {
                    name:"Jin",
                    text:"My name is Jin, and you're about to see me in for the biggest surprise of my life.",
                    isChoice:false
                },
                {
                    name:"Jin",
                    text:"We're in for a <shake:ui:0.05:0.15><sound:Explosion>rough time.",
                    isChoice:false
                },
            ]
        };
        for (i in members) {
            if (i is FlxSprite) {
                cast (i, FlxSprite).scrollFactor.set();  
            }
        }
    }

    public var inText:Bool = false;
    public function playNext() {
        inText = true;
        //gameText.erase(0, true);
        if (metaContainer.texts.length < 1) {
            inText = false;
            gameText._finalText = " ";
            gameText.start(0, true);
            nextTriangle.stopFlickering();
            nextTriangle.alpha = 0.000001;
            return;
        }
        nextTriangle.flicker(0, 0.25);
        currentMeta = metaContainer.texts.shift();
        gameText._finalText = currentMeta.text;
        gameText.start(0.04, true);
    }

    /**
        called when CustomTypedText reads a tag "e.g. <flash:1>"
        name and subsequent arguments separated by colons, converted to other types as needed
        @param signature unprocessed tag string without carats (e.g. "shake:ui:0.15:0.25")
        NOTE: skipping text WILL skip these, so don't put *any* important game logic in them
    **/
    public function onTag(signature:String) {
        var parameters:Array<String> = signature.split(":");
        var name = parameters.shift();
        switch (name) {
            case "color":
                gameText.color = Std.parseInt(parameters[0]);
            case "shake":
                (parameters[0] == "ui" ? BaseState.current.uiCamera : FlxG.camera).shake(Std.parseFloat(parameters[1]), Std.parseFloat(parameters[2]));
            case "flash":
                camera.flash(parameters.length > 1 ? Std.parseInt(parameters[1]) : FlxColor.WHITE, Std.parseFloat(parameters[0]));
            case "sound":
                FlxG.sound.play("assets/sounds/" + parameters[0] + ".wav");
        }
    }

    public var canProgress:Bool = false;
    public function onTextComplete() {
        trace("completed");
        if (!currentMeta.isChoice && inText) {
            canProgress = true;
            nextTriangle.alpha = 1;
        }
    }

    public override function update(elapsed:Float) {
        super.update(elapsed);
        if (canProgress && inText && FlxG.keys.justPressed.Z) {
            canProgress = false;
            nextTriangle.alpha = 0;
            FlxG.sound.play("assets/sounds/Next.wav", 0.15);
            playNext();  
        } 
    }
}