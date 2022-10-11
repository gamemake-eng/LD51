package;

import flixel.FlxState;
import flixel.FlxG;

class PlayState extends FlxState
{
	var test = "kool";
	override public function create()
	{
		super.create();

		
	}

	override public function update(elapsed:Float)
	{
		trace('$test');
		
		add(new flixel.ui.FlxButton(0,0,"Help my pain", play).screenCenter());
		super.update(elapsed);
	}

	function play() {
		FlxG.switchState(new LevelState("lv1"));
	}
}
