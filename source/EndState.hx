package;

import flixel.FlxState;
import flixel.FlxG;

class EndState extends FlxState
{
	var test = "kool";
	override public function create()
	{
		super.create();

		
	}

	override public function update(elapsed:Float)
	{
		add(new flixel.text.FlxText(0,0,"END", 60).screenCenter());
	}
}
