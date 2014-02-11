package vault.utils
{
	public function nearestAngle( currentAngle:Number, nearestAngle:Number ):Number
	{
		var a:Number = currentAngle;
		var b:Number = a / nearestAngle;
		var c:Number = Math.floor( b );
		
		var x:Number = a - ( c * nearestAngle );
		var y:Number = ( ( c + 1 ) * nearestAngle ) - a;
		var z:Number = Math.min( x, y );
		
		if( z == x ) a -= x;
		else a += y;
		
		return a;
	}
}