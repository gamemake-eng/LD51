package;

import flixel.FlxState;
import flixel.FlxG;
import haxe.io.Path;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.text.FlxText;
import openfl.Assets;
import flixel.group.FlxGroup;
import djFlixel.gfx.StaticNoise;
import openfl.filters.BitmapFilter;
import openfl.filters.ShaderFilter;
import openfl.Lib;

class LevelState extends FlxState
{
	var level:FlxTilemap;
	var spikes:FlxTilemap;
	var level2:FlxTilemap;
	var spikes2:FlxTilemap;
	var end:flixel.FlxSprite;
	var player:Player;
	var mode:Int;
	var time:Int;
	var timer:flixel.util.FlxTimer;
	var timer2:flixel.util.FlxTimer;
	var timerText:FlxText;
	var levelName:String;
	var ln:String;
	var nl:String;

	public function new(levelN:String) {
		super();
		this.levelName = levelN;

	}

	override public function create()
	{
		super.create();

		ln = this.levelName;

		var map = new TiledMap('assets/data/$ln.tmx');
		var textLayer:TiledObjectLayer = cast(map.getLayer('text'));
		var textGroup = new FlxTypedGroup<FlxText>();
		for (t in textLayer.objects) {
			var text = new FlxText(t.x,t.y,t.properties.get('Text'),10);
        			text.setBorderStyle(OUTLINE, flixel.util.FlxColor.WHITE, 2);
        			text.addFormat(new FlxTextFormat(flixel.util.FlxColor.WHITE, false, false, flixel.util.FlxColor.BLACK));
        			textGroup.add(text);
		}

		add(textGroup);



		timer= new flixel.util.FlxTimer();
		timer.start(10.0,switchMode,0);
		timer2= new flixel.util.FlxTimer();
		timer2.start(1.0,countT,0);


		mode = 0;
		time = 1;
		var tiledLevel:TiledMap = new TiledMap('assets/data/$ln.tmx');
		

		level2 = new FlxTilemap();
        		var mapData:String = Assets.getText('assets/data/'+ln+'_platforms2.csv');
        		var mapTilePath:String = 'assets/images/tileset.png';
        		level2.loadMapFromCSV(mapData, mapTilePath, 16, 16);
        		level2.color = 0x000000;
        		add(level2);

        		spikes2 = new FlxTilemap();
        		var smapData:String = Assets.getText('assets/data/'+ln+'_spikes2.csv');
        		var smapTilePath:String = 'assets/images/tileset.png';
        		spikes2.loadMapFromCSV(smapData, smapTilePath, 16, 16);
        		spikes2.color = 0x000000;
        		add(spikes2);

		level = new FlxTilemap();
        		var mapData:String = Assets.getText('assets/data/'+ln+'_platforms.csv');
        		var mapTilePath:String = 'assets/images/tileset.png';
        		level.loadMapFromCSV(mapData, mapTilePath, 16, 16);
        		level.color = flixel.util.FlxColor.WHITE;
        		add(level);

        		spikes = new FlxTilemap();
        		var smapData:String = Assets.getText('assets/data/'+ln+'_spikes.csv');
        		var smapTilePath:String = 'assets/images/tileset.png';
        		spikes.loadMapFromCSV(smapData, smapTilePath, 16, 16);
        		spikes.color = flixel.util.FlxColor.WHITE;
        		add(spikes);

        		var endLayer:TiledObjectLayer = cast(map.getLayer('end'));
        		end = new flixel.FlxSprite();
        		end.makeGraphic(16, 16, flixel.util.FlxColor.YELLOW);
        		end.x=endLayer.objects[0].x;
        		end.y=endLayer.objects[0].y;
        		nl=endLayer.objects[0].properties.get('next');
        		add(end);


        		var map = new TiledMap('assets/data/$ln.tmx');
		var pLayer:TiledObjectLayer = cast(map.getLayer('player'));

        		player = new Player(pLayer.objects[0].x,pLayer.objects[0].x);
        		add(player);

        		timerText = new FlxText(320,0,'0',60);
        		timerText.setBorderStyle(OUTLINE, flixel.util.FlxColor.WHITE, 2);
        		timerText.addFormat(new FlxTextFormat(flixel.util.FlxColor.WHITE, false, false, flixel.util.FlxColor.BLACK));
        		timerText.screenCenter(flixel.util.FlxAxes.X);
        		add(timerText);

        		FlxG.camera.fade(flixel.util.FlxColor.BLACK, 1, true);

        		FlxG.game.setFilters([new ShaderFilter(new Scanline())]);
	}

	override public function update(elapsed:Float)
	{

		timerText.screenCenter(flixel.util.FlxAxes.X);

		if (mode==0) {
			FlxG.collide(level, player);
			FlxG.collide(player, spikes,playerDie);
			level.alpha=255;
			spikes.alpha=255;
			bgColor = flixel.util.FlxColor.BLACK;
			player.color=flixel.util.FlxColor.WHITE;
		}
		if (mode==1) {
			FlxG.collide(level2, player);
			FlxG.collide(spikes2, player,playerDie);
			level.alpha=0;
			spikes.alpha=0;
			bgColor = flixel.util.FlxColor.WHITE;
			player.color=flixel.util.FlxColor.BLACK;
		}

		FlxG.collide(end, player,nextLevel);

		timerText.text = Std.string(time);

		if (player.y>480) {
			FlxG.switchState(new LevelState(ln));
		}

		super.update(elapsed);
	}

	function switchMode(timer:flixel.util.FlxTimer) {
		if (mode==0) {
			FlxG.camera.flash(flixel.util.FlxColor.WHITE,1);
			mode=1;
			time=0;
		} else {
			FlxG.camera.flash(flixel.util.FlxColor.BLACK,1);
			mode=0;
			time=0;
		}
		FlxG.sound.play("assets/sounds/explosion.wav");
		timer.reset();
	}

	function countT(timer:flixel.util.FlxTimer) {
		if (time==10) {
			time=0;
		}
		time+=1;
		timer.reset();
	}

	function playerDie(s:flixel.FlxSprite, pl:flixel.FlxSprite) {
		FlxG.sound.play("assets/sounds/jump.wav");
		FlxG.switchState(new LevelState(ln));
	}

	function nextLevel(s:flixel.FlxSprite, pl:flixel.FlxSprite) {
		if (nl=="end") {
			FlxG.camera.fade(flixel.util.FlxColor.BLACK, 1, false, endFade);
		}else {
			FlxG.camera.fade(flixel.util.FlxColor.BLACK, 1, false, nextLevelFade);
		}
		
	}

	function nextLevelFade() {
		FlxG.switchState(new LevelState(nl));
	}
	function endFade() {
		FlxG.switchState(new EndState());
	}
}
