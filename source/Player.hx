package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class Player extends FlxSprite {
	var jt:Float;
	var j:Bool;
	public function new(x:Float,y:Float)
	{
	    	super(x,y);
	    	makeGraphic(16,16, FlxColor.WHITE);
	    	maxVelocity.x=80;
	    	maxVelocity.y=200;
	    	acceleration.y=200;
	    	drag.x=80*4;

	    	jt=0;
	    	j=false;
	}

	override public function update(elapsed:Float)
	{
		var jb = FlxG.keys.anyPressed([UP,W,SPACE]);
		acceleration.x=0;
		if(FlxG.keys.anyPressed([LEFT,A]))
			acceleration.x = -80*4;
		if(FlxG.keys.anyPressed([RIGHT,D]))
			acceleration.x = 80*4;
		
		if(j && !jb)
			j=false;

		if (isTouching(DOWN) && !j)
			jt=0;

		if (jt >= 0 && jb) {
			j=true;
			jt+=elapsed;
		}
		else
			jt=-1;

		if (jt>0 && jt<0.25) {
			velocity.y=-210/2;
		}

		if (FlxG.keys.anyJustPressed([UP,W,SPACE]) && isTouching(DOWN)) {
			FlxG.sound.play("assets/sounds/jump.wav");
		}

		super.update(elapsed);
	}
}