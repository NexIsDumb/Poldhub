package;

import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;

class JenpactCutScene extends MusicBeatState
{
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

        var tipTextArray:Array<String> =
        "Comandi Movimento - Muoviti
        \nShift - Movimento piu' veloce
        \nE/Q - Camera Zoom Avanti/Indietro
		\nR - Reset Camera Zoom
		\nAccetta per continuare".split('\n');

		for (i in 0...tipTextArray.length-1)
		{
			var tipText:FlxText = new FlxText(FlxG.width - 320, FlxG.height - 15 - 16 * (tipTextArray.length - i), 300, tipTextArray[i], 12);
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

        super.create();
        CustomFadeTransition.nextCamera = camOther;
    }

    override function update(elapsed:Float)
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
            else if (controls.UI_DOWN && camFollow.y < 720)
                camFollow.y += addToCam;

            if (controls.UI_LEFT && camFollow.x > -640)
                camFollow.x -= addToCam;
            else if (controls.UI_RIGHT && camFollow.x < 1280)
                camFollow.x += addToCam;
        }

        if (controls.ACCEPT) {
            FlxG.sound.play(Paths.sound('confirmMenu'));
            pulsantone.animation.play('click');
            new FlxTimer().start(0.4, function(tmr:FlxTimer) if (PlayState.SONG.player1 == null) {
                LoadingState.loadAndSwitchState(new CharSelectorState());
                FreeplayState.skinSelected = true;
            } else {
                LoadingState.loadAndSwitchState(new PlayState());
                FlxG.sound.music.volume = 0;
            });
        }
        else if (controls.BACK) {  // Resetto anche le variabili del Playstate per sicurezza  - Nex
            FlxG.sound.play(Paths.sound('cancelMenu'));
            PlayState.deathCounter = 0;
            PlayState.seenCutscene = false;
            WeekData.loadTheFirstEnabledMod();
            MusicBeatState.switchState(new FreeplayState());
            FlxG.sound.playMusic(Paths.music('freakyMenu'));
            PlayState.changedDifficulty = false;
            PlayState.chartingMode = false;
        }

        super.update(elapsed);
    }
}