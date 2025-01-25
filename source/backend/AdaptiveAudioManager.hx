package backend;

import flixel.FlxG;
import flixel.sound.FlxSound;

class AdaptiveAudioManager {
    public static var sounds:Array<FlxSound> = [];

    // Main.hx, after FlxGame initialized?
    public static function configure(tracks:Array<String>) {
        for (i in tracks) {
            var sound = FlxG.sound.load(i, 0, true, FlxG.sound.defaultMusicGroup);
            sound.persist = true;
            sounds.push(sound);
        }
    }

    public static var playing:Bool = false;
    private static var _firstPlayed:Bool = false;

    public static function play() {
        if (_firstPlayed) return;
        _firstPlayed = true;
        playing = true;
        sounds[0].volume = 1;
        for (i in sounds) i.play();
        sync();
    }

    public static function pause() {
        if (!playing) return;
        playing = false;
        for (i in sounds) i.pause();
    }

    public static function resume() {
        if (playing) return;
        playing = true;
        for (i in sounds) i.resume();
    }

    public static function fadeIn(track:Int) {
        if (track == 0) return;
        sounds[track].fadeIn();
    }

    // run every second maybe??
    // certainly doesn't have to be every frame but i am NOT doing a conductor
    public static function sync() {
        for (i in 1...sounds.length) sounds[i].time = sounds[0].time;
    }
}