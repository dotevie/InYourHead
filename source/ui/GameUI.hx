package ui;

import backend.CustomTypedText;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.Assets;

using StringTools;
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
    ?isChoice:Bool,
    ?thought:String,
    ?choices:Array<Choice>,
    ?callback:String
};

typedef Choice = {
    text:String,
    correct:Bool,
    ?wrongAnswer:TaggedText,
    ?nextContainer:Filename // e.g. "NextTree" for assets/data/NextTree.json
};

typedef MetaTextContainer = {
    cacheFiles:Array<Filename>,
    texts:Array<MetaText>
};

@:access(backend.CustomTypedText)
class GameUI extends FlxTypedSpriteGroup<FlxSprite> {
    var nameField:FlxText;
    var gameText:CustomTypedText;
    var metaContainer:MetaTextContainer;
    var currentMeta:MetaText;
    var nextTriangle:FlxSprite;
    var textbox:FlxSprite;
    var nameSprite:FlxSprite;
    var alphaTween:FlxTween;
    var choices:Array<FlxText> = [null, null, null];
	var lerps:Array<Float> = [-FlxG.width / 2, -FlxG.width / 2, -FlxG.width / 2];

	var thoughtBubble:FlxSprite;
	var thoughtText:FlxText;

	public function setBubblePosition(x:Float, y:Float, flip:Bool)
	{
		thoughtBubble.x = x * 2;
		thoughtBubble.y = y * 2;
		thoughtText.x = thoughtBubble.x + (thoughtBubble.width / 2) - (thoughtText.width / 2) + 10;
		thoughtText.y = thoughtBubble.y + (thoughtBubble.height / 2) - (thoughtText.height / 2) - 10;
		thoughtBubble.flipX = flip;
	}

	public function AHHHHHH()
	{
		thoughtBubble.x = FlxG.width - thoughtBubble.width - 128;
		thoughtBubble.y = FlxG.height - thoughtBubble.width - 128;
		thoughtBubble.flipX = true;
	}

    public function new(?cam:FlxCamera) {
        super();
        camera = cam ?? BaseState.current.uiCamera;
        alpha = 0;
		choices[1] = new FlxText(FlxG.width, 0, FlxG.width / 2).setFormat("assets/fonts/CaveatBrush.ttf", 28, 0xffeeeeee, LEFT);
        choices[1].screenCenter(Y);
		choices[0] = new FlxText(FlxG.width, 0, FlxG.width / 2).setFormat("assets/fonts/CaveatBrush.ttf", 28, 0xffeeeeee, LEFT);
        choices[0].y = choices[1].y - choices[0].height - 16;
		choices[2] = new FlxText(FlxG.width, 0, FlxG.width / 2).setFormat("assets/fonts/CaveatBrush.ttf", 28, 0xffeeeeee, LEFT);
        choices[2].y = choices[1].y + choices[0].height +  16;
		for (i in choices)
		{
			i.setBorderStyle(OUTLINE, 0xff000000, 2);
		}
        add(choices[0]);
        add(choices[1]);
        add(choices[2]);
        textbox = new FlxSprite().loadGraphic("assets/images/textBox.png");
        textbox.screenCenter(X);
		textbox.y = 16;
        add(textbox);
        nameSprite = new FlxSprite(96).loadGraphic("assets/images/nameTag.png");
        nameSprite.scale *= 0.5;
        nameSprite.updateHitbox();
        nameSprite.y = textbox.y - nameSprite.height + 48;
        add(nameSprite);
        nameField = new FlxText(nameSprite.x, 0, nameSprite.width).setFormat("assets/fonts/CaveatBrush.ttf", 48, 0xff333333, CENTER);
        nameField.y = nameSprite.y + (nameSprite.height / 2) - (nameField.height / 2);
        add(nameField);
		gameText = new CustomTypedText(FlxG.width * 0.1, FlxG.height * 0.75, Std.int(FlxG.width * 0.8), "", 32, false);
        gameText.setFormat("assets/fonts/CaveatBrush.ttf", 48, 0xff1f1f1f, LEFT);
        gameText.fieldHeight = 140;
        gameText.y = textbox.y + (textbox.height / 2) - (gameText.fieldHeight / 2) + 10;
        gameText.delay = 0.035;
        gameText.useDefaultSound = true;
        gameText.tagCallback = onTag;
        gameText.completeCallback = onTextComplete;
        gameText._finalText = "My name is Jin, and you're about to see me in for the biggest surprise of my life.";
        add(gameText);
        nextTriangle = new FlxSprite(FlxG.width * .8 + 32, FlxG.height - 52).makeGraphic(16, 16, 0).drawTriangle(0,0,16, 0xff333333);
        nextTriangle.y = textbox.y + textbox.height - 64;
        nextTriangle.angle = 90;
        nextTriangle.alpha = 0;
        add(nextTriangle);
        for (i in members) {
            if (i is FlxSprite) {
                cast (i, FlxSprite).scrollFactor.set();  
            }
        }
		thoughtBubble = new FlxSprite().loadGraphic("assets/images/thoughtBubble.png", true, 295, 235);
		thoughtBubble.animation.add("loop", [0, 1, 2], 6, true);
		thoughtBubble.animation.play("loop");
		thoughtBubble.x = FlxG.width - thoughtBubble.width - 128;
		thoughtBubble.y = FlxG.height - thoughtBubble.width - 128;
		thoughtBubble.visible = false;
		thoughtBubble.flipX = true;
		add(thoughtBubble);
		thoughtText = new FlxText(thoughtBubble.x).setFormat("assets/fonts/CaveatBrush.ttf", 24, 0xff1f1f1f);
		thoughtText.fieldWidth = thoughtBubble.width - 40;
		thoughtText.fieldHeight = thoughtBubble.height / 2;
		thoughtText.x = thoughtBubble.x + (thoughtBubble.width / 2) - (thoughtText.width / 2);
		thoughtText.y = thoughtBubble.y + (thoughtBubble.height / 2) - (thoughtText.height / 2);
		thoughtText.visible = false;
		add(thoughtText);
    }

    public function fadeIn(?callback:Void->Void) {
        FlxTween.cancelTweensOf(this);
        alpha = 0;
        FlxTween.tween(this, {alpha: 1}, 1, {onComplete: (_) -> {
            nextTriangle.alpha = 0;
				thoughtBubble.visible = true;
				thoughtBubble.alpha = 0;
				thoughtText.visible = true;
				thoughtText.alpha = 0;
            if (callback != null) callback();
        }});
    }

    public function fadeOut(?callback:Void->Void) {
		thoughtBubble.visible = thoughtText.visible = false;
        FlxTween.cancelTweensOf(this);
        alpha = 1;
        nextTriangle.alpha = 0;
        FlxTween.tween(this, {alpha: 0}, 1, {onComplete: (_) -> if (callback != null) callback()});
    }

    public var inText:Bool = false;
    public function playNext() {
		if (thoughtBubble.alpha > 0)
		{
			FlxTween.completeTweensOf(thoughtBubble);
			FlxTween.tween(thoughtBubble, {alpha: 0}, 1);
		}
        inText = true;
        nextTriangle.stopFlickering();
        //gameText.erase(0, true);
        if (metaContainer.texts.length < 1) {
            inText = false;
            gameText._finalText = " ";
            gameText.start(0, true);
            nextTriangle.stopFlickering();
            nextTriangle.alpha = 0.000001;
            if (currentMeta.callback != null) {
                var params = currentMeta.callback.split(":");
                var name = params.shift();
                Reflect.callMethod(BaseState.current, Reflect.field(BaseState.current, name), params);
            }
            return;
        }
        nextTriangle.flicker(0, 0.25);
        currentMeta = metaContainer.texts.shift();
        nameField.text = currentMeta.name;
        gameText._finalText = currentMeta.text;
        gameText.color = 0xff333333; 
        gameText.start(0.035, true);
    }

    public function playCurrent() {
        nameField.text = currentMeta.name;
        gameText._finalText = currentMeta.text;
        gameText.color = 0xff333333; 
        gameText.start(0.035, true);
    }

    var strung:Bool = false;
    public function playString(s:String) {
        inText = true;
        strung = true;
        gameText._finalText = s;
        if (s.startsWith("<color:0xff3333ff>(That")) nameField.text = "Jin";
        gameText.color = 0xff333333;
        gameText.start(0.035, true);
    }

    public var cache:Map<String, MetaTextContainer> = [];
    public var loadedContainer:String;
    public function loadMetaContainer(name:String) {
        loadedContainer = name;
        metaContainer = cache.get(name) ?? cast {cache.set(name,Json.parse(Assets.getText('assets/data/$name.json'))); cache.get(name);};
        for (i in metaContainer.cacheFiles) {
            if (!cache.exists(i)) {
                cache.set(i, cast Json.parse(Assets.getText('assets/data/$i.json')));
            }
        }
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
    public var choosing:Bool = false;
    private var currentChoice:Int = 0;
    public function onTextComplete() {
        trace("completed");
		if (currentMeta.thought != null)
		{
			thoughtText.text = currentMeta.thought;
			FlxTween.tween(thoughtBubble, {alpha: 1}, 1);
		}
        if (!currentMeta.isChoice && inText) {
            canProgress = true;
            nextTriangle.alpha = 1;
        } else if (inText && currentMeta.isChoice) {
            if (strung) {
                canProgress = true;
                nextTriangle.alpha = 1;
            } else {
                currentChoice = 0;
                choosing = true;
                for (i in 0...3) {
                    choices[i].text = currentMeta.choices[i].text;
					lerps[i] = 16;
                }
            }
        }
    }

    public override function update(elapsed:Float) {
		thoughtText.alpha = thoughtBubble.alpha;
        super.update(elapsed);
        for (i in 0...3) {
            choices[i].x = FlxMath.lerp(lerps[i], choices[i].x, 1 - (elapsed * 9));
        }
        if (canProgress && inText && FlxG.keys.justPressed.Z) {
            canProgress = false;
            nextTriangle.alpha = 0;
            FlxG.sound.play("assets/sounds/Next.wav", 0.15);
            if (strung) {
                if (gameText.text.startsWith("(That")) {
                    strung = false;
                    playCurrent();
                }
                else playString("<color:0xff3333ff>(That doesn't seem right...)");
            } else playNext();  
        } 
        if (choosing) {
			for (i in 0...3)
				lerps[i] = 16;
			lerps[currentChoice] = 48;
            if (FlxG.keys.anyJustPressed([UP, LEFT]))
                currentChoice--;
            else if (FlxG.keys.anyJustPressed([DOWN, RIGHT]))
                currentChoice++;
            if (currentChoice < 0) currentChoice += 3;
            currentChoice %= 3;
            if (FlxG.keys.justPressed.Z) {
                choosing = false;
				for (i in 0...3)
					lerps[i] = -FlxG.width / 2;
                if (currentMeta.choices[currentChoice].correct) {
                    loadMetaContainer(currentMeta.choices[currentChoice].nextContainer);
                    strung = choosing = false; // double triple check
                    playNext();
                } else {
                    playString(currentMeta.choices[currentChoice].wrongAnswer);
                }
            }
        }
    }
}