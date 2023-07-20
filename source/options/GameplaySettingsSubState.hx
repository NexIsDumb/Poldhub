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

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'Impostazioni del Gameplay';
		rpcTitle = "Menu' delle Impostazioni del Gameplay"; //for Discord Rich Presence

		var option:Option = new Option('Modalita\' Controller',
			'Spunta questo se vuoi giocare\ncon un controller invece di usare la\ntua tastiera.',
			'controllerMode',
			'bool',
			false);
		addOption(option);

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'Se spuntato, le note andranno giù invece che sopra, abbastanza semplice.', //Description
			'downScroll', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'Se spuntato, le tue note vengono centrate.',
			'middleScroll',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Note Avversarie',
			'Se non spuntato, le note dell\'avversario vengono nascoste.',
			'opponentStrums',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Visibilita\' Background Note',
			'Quanto visibile dovrebbe essere il background delle note.\nEssendo scuro, può essere usato per una maggiore visibilità\ndelle note.',
			'scrollUnderlay',
			'percent',
			0);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"Se spuntato, non riceverai misses premendo comandi\nquando non ci stanno note da colpire.",
			'ghostTapping',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Disattiva il Pulsante Reset',
			"Se spuntato, premere Reset non fara' niente.",
			'noReset',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Volume della Hitsound',
			'Le note burla fanno \"Tick!\" quando le colpisci.',
			'hitsoundVolume',
			'percent',
			0);
		addOption(option);
		option.scrollSpeed = 1.6;
		option.minValue = 0.0;
		option.maxValue = 1;
		option.changeValue = 0.1;
		option.decimals = 1;
		option.onChange = onChangeHitsoundVolume;

		var option:Option = new Option('Valutazione Offset',
			'Cambia con quanto ritardo/anticipo devi colpire per un "Sick!"\nPiù alto il valore è, più tardi devi colpire.',
			'ratingOffset',
			'int',
			0);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option('Finestra di colpi "Sick!"',
			'Cambia la quantità di tempo che hai\nper colpire un "Sick!" in millisecondi.',
			'sickWindow',
			'int',
			45);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option('Finestra di colpi "Good"',
			'Cambia la quantità di tempo che hai\nper colpire un "Good!" in millisecondi.',
			'goodWindow',
			'int',
			90);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option('Finestra di colpi "Bad"',
			'Cambia la quantità di tempo che hai\nper colpire un "Bad!" in millisecondi.',
			'badWindow',
			'int',
			135);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option('Frame Sicuri',
			'Cambia quanti frame extra hai per\ncolpire una nota prima che faccia miss.',
			'safeFrames',
			'float',
			10);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super();
	}

	function onChangeHitsoundVolume()
	{
		FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
	}
}