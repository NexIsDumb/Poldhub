package;

import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.text.FlxText;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxG;

class JenpactCutScene extends MusicBeatState
{
    private var camHUD:FlxCamera;
    var camFollow:FlxObject;

    override function create()
    {
        var comic:FlxSprite = new FlxSprite().loadGraphic(Paths.image('jenshin/ita'));
        var shut:Bool = comic.scale.x > comic.scale.y;
        comic.setGraphicSize(1280, 720);
		comic.updateHitbox();
		var finalScale = (shut ? Math.max : Math.min)(comic.scale.x, comic.scale.y);
		comic.scale.set(finalScale, finalScale);
        add(comic);

        camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);
        FlxG.camera.follow(camFollow);

        camHUD = new FlxCamera();
        FlxG.cameras.add(camHUD, false);
        camHUD.bgColor.alpha = 0;

        var tipTextArray:Array<String> =
        "Com Movimento (Opz) - Muovi Cam
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

            if (controls.UI_UP)
                camFollow.y -= addToCam;
            else if (controls.UI_DOWN)
                camFollow.y += addToCam;

            if (controls.UI_LEFT)
                camFollow.x -= addToCam;
            else if (controls.UI_RIGHT)
                camFollow.x += addToCam;
        }

        if (controls.ACCEPT) {
            if (PlayState.SONG.player1 == null) {
                LoadingState.loadAndSwitchState(new CharSelectorState());
                FreeplayState.skinSelected = true;
            } else {
                LoadingState.loadAndSwitchState(new PlayState());
                FlxG.sound.music.volume = 0;
            }
        }
    }
}