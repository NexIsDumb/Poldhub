package;

import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;

using StringTools;

class JenpactCutScene extends MusicBeatState
{
    private var lol:FlxTween;
    private var pulsantone:FlxSprite;
    private var camFollow:FlxObject;

    override function create()
    {
        var comic:FlxSprite = new FlxSprite().loadGraphic(Paths.image('jenshin/ita'));
        var shut:Bool = comic.scale.x > comic.scale.y;
        comic.setGraphicSize(1280, 720);
		comic.updateHitbox();
		var finalScale = (shut ? Math.max : Math.min)(comic.scale.x, comic.scale.y);
		comic.scale.set(finalScale, finalScale);
        comic.screenCenter();
        add(comic);

        camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);
        FlxG.camera.follow(camFollow);

        var camHUD:FlxCamera = new FlxCamera();
        FlxG.cameras.add(camHUD, false);
        camHUD.bgColor.alpha = 0;

        var camOther:FlxCamera = new FlxCamera();
        FlxG.cameras.add(camOther, false);
        camOther.bgColor.alpha = 0;
        CustomFadeTransition.nextCamera = camOther;

        var shit:String = '';
        var fuck:Array<Array<String>> = [[], []];
        for (i => comm in ['ui_left', 'ui_down', 'ui_up', 'ui_right']) {
            var keys:Array<Dynamic> = ClientPrefs.keyBinds.get(comm);
            fuck[0][i] = InputFormatter.getKeyName(keys[0]);
            fuck[1][i] = InputFormatter.getKeyName(keys[1]);
        }
        for(key in fuck[0]) shit += key + " ";
        shit+= "/ ";
        for(key in fuck[1]) shit += key + " ";

        var leReset:Array<Dynamic> = ClientPrefs.keyBinds.get('reset');
        var leAccept:Array<Dynamic> = ClientPrefs.keyBinds.get('accept');
        var tipTextArray:Array<String> =
        '$shit- Muoviti
        \nShift - Movimento piu\' veloce
        \nE / Q - Camera Zoom Avanti/Indietro
		\n${InputFormatter.getKeyName(leReset[0])} / ${InputFormatter.getKeyName(leReset[1])} - Reset Camera Zoom
		\n${InputFormatter.getKeyName(leAccept[0])} / ${InputFormatter.getKeyName(leAccept[1])} per continuare'.split('\n');

		for (i in 0...tipTextArray.length-1)
		{
			var tipText:FlxText = new FlxText(FlxG.width - 1020, FlxG.height - 15 - 16 * (tipTextArray.length - i), 1000, tipTextArray[i], 12);
			tipText.cameras = [camHUD];
			tipText.setFormat(null, 12, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE_FAST, FlxColor.BLACK);
			tipText.scrollFactor.set();
			tipText.borderSize = 1;
			add(tipText);
		}

        pulsantone = new FlxSprite(FlxG.width - 280, FlxG.height - 270 - 16 * tipTextArray.length);
        pulsantone.scale.set(0.6, 0.6);
        pulsantone.frames = Paths.getSparrowAtlas('jenshin/pulsantone');
        pulsantone.animation.addByPrefix('idle', 'Non Premuto Invio', 24);
	    pulsantone.animation.addByPrefix('click', 'Premuto Invio', 24, false);
        pulsantone.cameras = [camHUD];
        pulsantone.animation.play('idle');
        add(pulsantone);

        FlxG.sound.playMusic(Paths.music('bgmjen'), 0);
        FlxG.sound.music.pitch = 0;
        FlxG.sound.music.volume = 1;
	    lol = FlxTween.tween(FlxG.sound.music, {pitch: 1}, 2);

        super.create();
        CustomFadeTransition.nextCamera = camOther;
    }

    private var selectedSmth:Bool = false;
    override function update(elapsed:Float)
    {
        if (!selectedSmth)
        {
            if (FlxG.keys.justPressed.R) {
                FlxG.camera.zoom = 1;
            }

            if (FlxG.keys.pressed.E && FlxG.camera.zoom < 3) {
                FlxG.camera.zoom += elapsed * FlxG.camera.zoom;
                if(FlxG.camera.zoom > 3) FlxG.camera.zoom = 3;
            }
            if (FlxG.keys.pressed.Q && FlxG.camera.zoom > 0.1) {
                FlxG.camera.zoom -= elapsed * FlxG.camera.zoom;
                if(FlxG.camera.zoom < 0.1) FlxG.camera.zoom = 0.1;
            }

            if (controls.UI_UP || controls.UI_DOWN || controls.UI_LEFT || controls.UI_RIGHT)
            {
                var addToCam:Float = 500 * elapsed;
                if (FlxG.keys.pressed.SHIFT)
                    addToCam *= 4;

                if (controls.UI_UP && camFollow.y > -360)
                    camFollow.y -= addToCam;
                if (controls.UI_DOWN && camFollow.y < 1080)
                    camFollow.y += addToCam;
                if (controls.UI_LEFT && camFollow.x > -640)
                    camFollow.x -= addToCam;
                if (controls.UI_RIGHT && camFollow.x < 1920)
                    camFollow.x += addToCam;
            }

            if (controls.ACCEPT) {
                FlxG.sound.play(Paths.sound('confirmMenu'));
                pulsantone.animation.play('click');
                selectedSmth = true;

                new FlxTimer().start(0.4, function(tmr:FlxTimer) {
                    if (!lol.finished) lol.cancelChain();
                    if (PlayState.SONG.player1 == null) {
                        LoadingState.loadAndSwitchState(new CharSelectorState());
                        FreeplayState.skinSelected = true;
                        FlxTween.tween(FlxG.sound.music, {pitch: 0}, 0.6);
                    } else {
                        LoadingState.loadAndSwitchState(new PlayState());
                        FlxG.sound.music.volume = 0;
                    }
                });
            }
            else if (controls.BACK) {  // Resetto anche le variabili del Playstate per sicurezza  - Nex
                selectedSmth = true;
                if (!lol.finished) lol.cancelChain();
                FlxG.sound.play(Paths.sound('cancelMenu'));
                PlayState.deathCounter = 0;
                PlayState.seenCutscene = false;
                WeekData.loadTheFirstEnabledMod();
                MusicBeatState.switchState(new FreeplayState());
                FlxG.sound.playMusic(Paths.music('freakyMenu'));
                PlayState.changedDifficulty = false;
                PlayState.chartingMode = false;
            }
        }

        super.update(elapsed);
    }
}