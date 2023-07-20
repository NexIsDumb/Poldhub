package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class VisualsUISubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Visuals e UI';
		rpcTitle = "Menu' delle Impostazioni delle Visuals e UI"; //for Discord Rich Presence

		var option:Option = new Option('SPLASHHH',
			"Se non spuntato, colpire le note \"Sick!\" non mostrerà lo splash sulle note.",
			'noteSplashes',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('HUD Nascosto',
			'Se spuntato, nasconde la maggior parte\ndegli elementi dell\'HUD.',
			'hideHud',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Time Bar:',
			"Che cosa dovrebbe mostrare la Time Bar?",
			'timeBarType',
			'string',
			'Tempo Rimanente',
			['Tempo Rimanente', 'Tempo Trascorso', 'Nome canzone', 'Disabilitato']);
		addOption(option);

		var option:Option = new Option('Luci Lampeggianti',
			"Non spuntare questo se sei sensibile alle luci lampeggianti!",
			'flashing',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Zoom Camera',
			"Se non spuntato, la camera non zoomma ad ogni beat hit.",
			'camZooms',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Zoom della Scritta Punteggio',
			"Se non spuntato, disabilita lo zoom dello\nScore Text ogni volta che colpisci una nota.",
			'scoreZoom',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Visibilita\' Barra della Vita',
			'Quanto visibili dovrebbero essere la health bar e le icons.',
			'healthBarAlpha',
			'percent',
			1);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		#if !mobile
		var option:Option = new Option('Counter degli FPS',
			'Se non spuntato, nasconde il Counter degli FPS.',
			'showFPS',
			'bool',
			false);  // Modificato da Nex
		addOption(option);
		option.onChange = onChangeFPSCounter;
		#end

		var option:Option = new Option('Canzone di Pausa:',
			"Che canzone preferisci per il Menu' di Pausa?",
			'pauseMusic',
			'string',
			'Tea Time',
			['Nessuna', 'Breakfast', 'Tea Time']);
		addOption(option);
		option.onChange = onChangePauseMusic;

		#if CHECK_FOR_UPDATES  // Non serve tradurlo dato che non verrà utilizzato  - Nex
		var option:Option = new Option('Check for Updates',
			'On Release builds, turn this on to check for updates when you start the game.',
			'checkForUpdates',
			'bool',
			true);
		addOption(option);
		#end

		var option:Option = new Option('Combo Stacking',
			"Se non spuntato, Valutazioni e Combo non stackeranno, salvandole sulla Memoria di Sistema e rendendole più semplici da leggere",
			'comboStacking',
			'bool',
			true);
		addOption(option);

		super();
	}

	var changedMusic:Bool = false;
	function onChangePauseMusic()
	{
		if(ClientPrefs.pauseMusic == 'Nessuna')
			FlxG.sound.music.volume = 0;
		else
			FlxG.sound.playMusic(Paths.music(Paths.formatToSongPath(ClientPrefs.pauseMusic)));

		changedMusic = true;
	}

	override function destroy()
	{
		if(changedMusic) FlxG.sound.playMusic(Paths.music('starRelax'));
		super.destroy();
	}

	#if !mobile
	function onChangeFPSCounter()
	{
		if(Main.fpsVar != null)
			Main.fpsVar.visible = ClientPrefs.showFPS;
	}
	#end
}
