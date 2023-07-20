// CODDATO INTERAMENTE DA NEX
package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxMath;
import flixel.group.FlxGroup.FlxTypedGroup;

using StringTools;

class CharSelectorState extends MusicBeatState
{
    private static var curSelected:Int = 0;
    private var chars:FlxTypedGroup<Character>;
    private var skins:Array<Array<String>> = [  // Metti i nomi ed artisti delle skin giocabili qua  - Nex
        ['poldo-bf', 'Astro Galaxy'],
        ['poldo-bf-chitarra', 'JackLePatate'],
        ['144', 'Astro Galaxy - Gabrifulup13'],
        ['bf', 'Phantom Arcade'],
        ['bf-christmas', 'Phantom Arcade']
        //'bf-pixel'
    ];

    private var lol:FlxTween;
    private var camFollowPos:FlxObject;
    private var charName:Alphabet;
    private var arrow1:FlxSprite;
    private var arrow2:FlxSprite;

    private var bg:FlxSprite;
    private var intendedColor:Int;
	private var colorTween:FlxTween;
    override function create()
	{
        Paths.clearStoredMemory();  // Dato che il character selector pesa un botto sulla ram  - Nex

        bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        bg.updateHitbox();
        bg.screenCenter();
        bg.scrollFactor.set();
        add(bg);

        chars = new FlxTypedGroup<Character>();
        add(chars);

        for (i in 0...skins.length) {
            var character:Character = new Character(600 * i, -200, skins[i][0], true);
            character.debugMode = true;
            character.forceDance = true;
            character.x += character.positionArray[0];
		    character.y += character.positionArray[1];
            chars.add(character);
            character.ID = i;
        }

        if(curSelected >= skins.length) curSelected = 0;  // Per sicurezza  - Nex
        bg.color = FlxColor.fromRGB(
            chars.members[curSelected].healthColorArray[0],
            chars.members[curSelected].healthColorArray[1],
            chars.members[curSelected].healthColorArray[2]
        );
		intendedColor = bg.color;

        arrow1 = new FlxSprite();
		arrow1.frames = Paths.getSparrowAtlas('Freccia');
		arrow1.animation.addByPrefix('idle', 'FrecciaFerma', 24);
		arrow1.animation.addByPrefix('click', 'FrecciaClick', 24, false);
        arrow1.animation.finishCallback = function(an:String) if(an == 'click') {
            arrow1.offset.set(0, 0);
            arrow1.animation.play('idle');
        }
		arrow1.animation.play('idle');
		add(arrow1);

        arrow2 = arrow1.clone();
        arrow2.animation.finishCallback = function(an:String) if(an == 'click') {
            arrow2.offset.set(0, 0);
            arrow2.animation.play('idle');
        }
        arrow2.flipX = true;
		add(arrow2);

        arrow2.setPosition(chars.members[curSelected].getGraphicMidpoint().x + FlxG.width, chars.members[curSelected].getGraphicMidpoint().y);
        arrow1.setPosition(chars.members[curSelected].getGraphicMidpoint().x - FlxG.width, chars.members[curSelected].getGraphicMidpoint().y);
        arrow1.updateHitbox();
        arrow2.updateHitbox();

        var cinemaBar:FlxSprite = new FlxSprite(-50, -(FlxG.height / 2.9)).makeGraphic(FlxG.width + 100, Std.int(FlxG.height / 2), FlxColor.TRANSPARENT, false, 'transparent-lmfao');
        cinemaBar.pixels.fillRect(new flash.geom.Rectangle(1, 1, cinemaBar.width - 2, cinemaBar.height - 2), FlxColor.BLACK);
        cinemaBar.angle = -10;
        cinemaBar.scrollFactor.set();
        add(cinemaBar);

        var secondBar:FlxSprite = cinemaBar.clone();
        secondBar.y = FlxG.height + (cinemaBar.y / 2.05) - 26;
        secondBar.angle = -10;
        secondBar.scrollFactor.set();
        add(secondBar);

        charName = new Alphabet(0, 0, '', true);
        charName.scaleX = 0.6;
        charName.scaleY = 0.6;
        charName.alignment = RIGHT;
        charName.setPosition(FlxG.width - 10, FlxG.height - 126);
        charName.scrollFactor.set();
        add(charName);

        var titleText:Alphabet = new Alphabet(10, 10, 'Selezione Personaggio', true);
		titleText.scaleX = 0.8;
		titleText.scaleY = 0.8;
        titleText.scrollFactor.set();
		add(titleText);

        var text:FlxText = new FlxText(0, FlxG.height - 22, FlxG.width, 'Selezionato il personaggio comincerà la canzone / Tornando indietro andrai nel Freeplay.', 16);
		text.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		add(text);

        camFollowPos = new FlxObject(chars.members[curSelected].getGraphicMidpoint().x, -250, 1, 1);
        add(camFollowPos);
        FlxG.camera.follow(camFollowPos, null, 1);

        FlxG.sound.playMusic(Paths.music('charsel'), 0);
        FlxG.sound.music.pitch = 0;
        FlxG.sound.music.volume = 1;
	    lol = FlxTween.tween(FlxG.sound.music, {pitch: 1}, 2);
        Conductor.songPosition = 0;
        Conductor.changeBPM(128);

        changeItem();
        Paths.clearUnusedMemory();  // Anche qua per la ram  - Nex
        super.create();
    }

    function changeItem(huh:Int = 0)
	{
        if (huh != 0) {
            var arrow:FlxSprite = huh < 0 ? arrow1 : arrow2;
            arrow.animation.play('click', true);
            arrow.offset.set(huh < 0 ? 35 : 0, 23);
        }

		curSelected += huh;
		if (curSelected >= chars.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = chars.length - 1;

        var daText:String = skins[curSelected][0].replace('-', ' ');  // Creo questa variabile per evitare di aggiornare in continuazione l'alphabet, laggerebbe di più  - Nex
        switch(daText) {  // Casi in cui forzo il nome  - Nex
            case 'bf':
                daText = 'Boyfriend';
            case 'bf christmas':
                daText = 'Winter BF';
        }
        charName.text = daText + '\n' + skins[curSelected][1];

        var newColor:Int = FlxColor.fromRGB(
            chars.members[curSelected].healthColorArray[0],
            chars.members[curSelected].healthColorArray[1],
            chars.members[curSelected].healthColorArray[2]
        );
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}
    }

    private var selectedSomethin:Bool = false;
    private var holdTime:Float = 0;
    override function update(elapsed:Float)
    {
		Conductor.songPosition = FlxG.sound.music.time;

		if (!selectedSomethin)
		{
            var shiftMult:Int = 1;
			if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

			if (FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
			    changeItem(shiftMult * FlxG.mouse.wheel);
                holdTime = 0;
			}

			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			    changeItem(-shiftMult);
                holdTime = 0;
			}
			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
			    changeItem(shiftMult);
                holdTime = 0;
			}

            if(controls.UI_LEFT || controls.UI_RIGHT)
			{
                var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeItem((checkNewHold - checkLastHold) * (controls.UI_LEFT ? -shiftMult : shiftMult));
                    FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				}
            }

            if (controls.ACCEPT) {
                if (colorTween != null) colorTween.cancel();
                if (!lol.finished) lol.cancelChain();
                selectedSomethin = true;
                FlxG.sound.music.volume = 0;
                FlxG.sound.play(Paths.sound('confirmMenu'));
                if (ClientPrefs.flashing) FlxG.camera.flash();
                if (chars.members[curSelected].animOffsets.exists('hey'))
                {
                    chars.members[curSelected].playAnim('hey', true);
                    chars.members[curSelected].animation.finishCallback = function(an:String) {
                        if(an.startsWith('hey')) {
                            LoadingState.loadAndSwitchState(new PlayState());
                            FlxTween.tween(arrow1, {alpha: 0, x: arrow1.x - FlxG.width}, 0.4, {ease: FlxEase.quadIn});
                            FlxTween.tween(arrow2, {alpha: 0, x: arrow2.x + FlxG.width}, 0.4, {ease: FlxEase.quadIn});
                        }
                    };
                } else {
                    new FlxTimer().start(1, function(tmr:FlxTimer) {
                        LoadingState.loadAndSwitchState(new PlayState());
                        FlxTween.tween(arrow1, {alpha: 0, x: arrow1.x - FlxG.width}, 0.4, {ease: FlxEase.quadIn});
                        FlxTween.tween(arrow2, {alpha: 0, x: arrow2.x + FlxG.width}, 0.4, {ease: FlxEase.quadIn});
                    });
                }
                
                PlayState.SONG.player1 = chars.members[curSelected].curCharacter;
            }
            else if (controls.BACK) {  // Resetto anche le variabili del Playstate per sicurezza  - Nex
                if (colorTween != null) colorTween.cancel();
                if (!lol.finished) lol.cancelChain();
                selectedSomethin = true;
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

        chars.forEach(function(spr:Character)
		{
            var scale:Float = 0.6;
            if (spr.ID != curSelected) {
                if(spr.alpha != 0.4) spr.alpha = FlxMath.lerp(0.4, spr.alpha, CoolUtil.boundTo(1 - (elapsed * 40), 0.4, 1));
            } else {
                if(spr.alpha != 1) spr.alpha = FlxMath.lerp(1, spr.alpha, CoolUtil.boundTo(1 - (elapsed * 40), 0.4, 1));
                scale = 0.8;
            }
            var mult:Float = FlxMath.lerp(scale, spr.scale.x, CoolUtil.boundTo(1 - (elapsed * 20), 0, 1));
            spr.scale.set(mult, mult);
            //spr.centerOffsets();
        });

        var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, chars.members[curSelected].getGraphicMidpoint().x, lerpVal), FlxMath.lerp(camFollowPos.y, 350, lerpVal));

        var arrMult:Float = FlxMath.lerp(0.5, arrow2.scale.x, CoolUtil.boundTo(1 - (elapsed * 0.3), 0, 1));
		arrow2.scale.set(arrMult, arrMult);
		arrow2.x = FlxMath.lerp(arrow2.x, chars.members[curSelected].getMidpoint().x + (chars.members[curSelected].frameWidth / 1.9), lerpVal);
        arrow2.y = FlxMath.lerp(arrow2.y, chars.members[curSelected].getMidpoint().y - arrow2.height / 2, lerpVal);

        arrMult = FlxMath.lerp(0.5, arrow1.scale.x, CoolUtil.boundTo(1 - (elapsed * 0.3), 0, 1));
		arrow1.scale.set(arrMult, arrMult);
		arrow1.x = FlxMath.lerp(arrow1.x, chars.members[curSelected].getMidpoint().x - (chars.members[curSelected].frameWidth / 1.9), lerpVal);
        arrow1.y = FlxMath.lerp(arrow1.y, chars.members[curSelected].getMidpoint().y - arrow1.height / 2, lerpVal);

        super.update(elapsed);
    }

    override function beatHit()
	{
		super.beatHit();
        arrow2.scale.set(1, 1);
        arrow1.scale.set(1, 1);
        chars.forEach(function(character:Character) {
            if (curBeat % character.danceEveryNumBeats == 0 && !(character.ID == curSelected && character.animation.curAnim.name == 'hey')) character.dance();
        });
    }

    override function destroy() {  // Non so se effettivamente può aiutare con la ram ma lo faccio comunque  - Nex
        var i:Int = chars.length - 1;
		while (i >= 0) {
			var daChar:Character = chars.members[i];
			daChar.kill();
			chars.remove(daChar, true);
			daChar.destroy();
			--i;
		}

        if (FlxG.sound.music.pitch != 1) FlxG.sound.music.pitch = 1;  // Per qualsiasi caso possibile  - Nex
        super.destroy();
    }
}