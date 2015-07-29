package com.fw5.utils.geom 
{
	import flash.display.Sprite;
	/**
	 * 2D Vecctor class. Performs all basic vector operations and has lazy instantization methods
	 * for getting magnitude and angle whilst x, y values are persistant.
	 * @author Haliq
	 */
	public class Vector2D
	{
		/* VARIABLES */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		private static const RAD2DEG:Number = 180 / Math.PI;
		private static const DEG2RAD:Number = Math.PI / 180;
		private static const PITIMES2:Number = Math.PI * 2;
		private static const PIDIV2:Number = Math.PI * 0.5;
		/* RADIAN CONSTANTS */
		//-----------------------------------------------------------------------------------------
		
		public var dx:Number = 0;
		public var dy:Number = 0;
		private var _x:Number;
		private var _y:Number
		private var _magnitude:Number;
		private var _angle:Number;
		/* STORED VALUES */
		//-----------------------------------------------------------------------------------------
		
		private var d_mag:Boolean = true;
		private var d_ang:Boolean = true;
		/* FLAG TO UPDATE STORED VALUES */
		//-----------------------------------------------------------------------------------------
		
		/* METHODS */
		//>->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->->
		
		/**
		 * Construct with default x, y values.
		 * @param	i	value for x
		 * @param	j	value for y
		 */
		public function Vector2D(i:Number = 0, j:Number = 0, di:Number = 0, dj:Number = 0) 
		{
			_x = i;
			_y = j;
			dx = di;
			dy = dj;
		}
		
		/* CONSTRUCTOR */
		//-----------------------------------------------------------------------------------------
		
		public static function get DOWN():Vector2D { return new Vector2D(0, 1); }
		public static function get RIGHT():Vector2D { return new Vector2D(1, 0); }
		public static function get UP():Vector2D { return new Vector2D(0, -1); }
		public static function get LEFT():Vector2D { return new Vector2D( -1, 0); }
		public static function get ONE():Vector2D { return new Vector2D(1, 1); }
		public static function get UNITX():Vector2D { return new Vector2D(1, 0); }
		public static function get UNITY():Vector2D { return new Vector2D(0, 1); }
		public static function get ZERO():Vector2D { return new Vector2D(0, 0); }
		
		/* STATIC CONSTANTS*/
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Returns a copy of this vector
		 * @return
		 */
		public function clone():Vector2D
		{
			return new Vector2D(x, y, dx, dy);
		}
		
		/**
		 * Replaces this vector's values with those of the parameter
		 * @param	v
		 */
		public function takeIn(v:Vector2D):void
		{
			x = v.x;
			y = v.y;
			dx = v.dx;
			dy = v.dy;
		}
		
		/* CORE */
		//-----------------------------------------------------------------------------------------
		
		public function get x():Number { return _x; }
		public function get y():Number { return _y; }
		public function set x(value:Number):void
		{
			_x = value;
			d_mag = d_ang = true;
		}
		public function set y(value:Number):void
		{
			_y = value;
			d_mag = d_ang = true;
		}
		
		/* X AND Y GET SET */
		//-----------------------------------------------------------------------------------------
		
		public function get magnitudeSquared():Number { return _x * _x + _y * _y; }
		public static function getMagnitudeSquared(v:Vector2D):Number { return v.x * v.x + v.y * v.y; }
		
		/**
		 * Returns distance / length from source
		 */
		public function get magnitude():Number
		{
			if (d_mag)
			{
				_magnitude = Math.sqrt(_x * _x + _y * _y);
				d_mag = false;
			}
			return _magnitude;
		}
		
		/**
		 * Assign distance / length from source; affecting x, y and angle
		 */
		public function set magnitude(value:Number):void
		{
			if (_x == 0 && _y == 0) _x = value;
			else
			{
				_x *= value / magnitude;
				_y *= value / _magnitude;
				
				_magnitude = value >= 0 ? value : -value;
				d_ang = true;
				d_mag = false;
			}
		}
		
		/**
		 * Returns resulting angle from coordinates in radians
		 */
		public function get angleRAD():Number
		{
			if (d_ang)
			{
				_angle = Math.atan2(_y, _x);
				d_ang = false;
			}
			return _angle;
		}
		
		/**
		 * Assigns angle based on source to current coordinates
		 * @param	value	in radians
		 */
		public function set angleRAD(value:Number):void
		{
			_angle = value;
			_x = Math.cos(_angle) * magnitude;
			_y = Math.sin(_angle) * _magnitude;
			while (_angle < 0) _angle += PITIMES2;
			while (_angle > PITIMES2) _angle -= PITIMES2;
			d_ang = false;
		}
		
		/**
		 * Returns resulting angle from coordinates in degrees
		 */
		public function get angle():Number
		{
			return angleRAD * RAD2DEG;
		}
		
		/**
		 * Assigns angle based on source to current cordinates
		 * @param	value	in degrees
		 */
		public function set angle(value:Number):void
		{
			angleRAD = value * DEG2RAD;
		}
		
		/* MAGNITUDE AND ANGLE GET SETS */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Flip vector in opposite direction
		 */
		public function negate():void
		{
			_x = -_x;
			_y = -_y;
		}
		
		/**
		 * Produce vector of opposite direction
		 * @return
		 */
		public static function getNegative(v:Vector2D):Vector2D
		{
			return new Vector2D( -v.x, -v.y);
		}
		
		/**
		 * Orthogonlizes the vector (-90 degree)
		 */
		public function orth():void
		{
			angle -= PIDIV2;
		}
		
		/**
		 * Returns a vector that is orthogonal of the parameter
		 * @param	v
		 * @return
		 */
		public static function getOrthogonal(v:Vector2D):Vector2D
		{
			var vec:Vector2D = v.clone();
			vec.orth();
			return vec;
		}
		
		/**
		 * Normals the vector (+90 degrees)
		 */
		public function norm():void
		{
			angle += PIDIV2;
		}
		
		/**
		 * Returns a vector that is normal to the parameter
		 * @param	v
		 * @return
		 */
		public static function getNormal(v:Vector2D):Vector2D
		{
			var vec:Vector2D = v.clone();
			vec.norm();
			return vec;
		}
		
		/**
		 * Scales magnitude to 1
		 */
		public function normalize():void
		{
			_x /= magnitude;
			_y /= _magnitude;
			_magnitude = 1;
			d_mag = false;
		}
		
		/**
		 * Returns scaled to 1 magnitude vector (unit vector)
		 */
		public static function getUnit(v:Vector2D):Vector2D
		{
			return new Vector2D(v.x / v.magnitude, v.y / v.magnitude);
		}
		
		/* VECTOR TYPES*/
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Adds x,y values to the vector
		 * @param	xVal
		 * @param	yVal
		 */
		public function add(xVal:Number, yVal:Number):void
		{
			x += xVal;
			_y += yVal;
		}
		
		/**
		 * Returns the sum of the two vector parameters
		 * @param	v1
		 * @param	v2
		 * @return
		 */
		public static function add(v1:Vector2D, v2:Vector2D):Vector2D
		{
			return new Vector2D(v1.x + v2.x, v1.y + v2.y);
		}
		
		/**
		 * Subtracts x,y value from the vector
		 * @param	xVal
		 * @param	yVal
		 */
		public function sub(xVal:Number, yVal:Number):void
		{
			x -= xVal;
			_y -= yVal;
		}
		
		/**
		 * Returns the vector of v1 subtracted by v2
		 * @param	v1
		 * @param	v2
		 * @return
		 */
		public static function sub(v1:Vector2D, v2:Vector2D):Vector2D
		{
			return new Vector2D(v1.x - v2.x, v1.y - v2.y);
		}
		
		/**
		 * Multiplies independent x,y values to the vector
		 * @param	xVal
		 * @param	yVal
		 */
		public function mul(xVal:Number, yVal:Number):void
		{
			x *= xVal;
			_y *= yVal;
		}
		
		/**
		 * Returns a vector that is the result of multiplying the two parameter vecctors
		 * @param	v1
		 * @param	v2
		 * @return
		 */
		public static function mul(v1:Vector2D, v2:Vector2D, supplyVec:Vector2D = null):Vector2D
		{
			var vec:Vector2D = supplyVec == null ? new Vector2D() : supplyVec;
			vec.x = v1.x * v2.x;
			vec.y = v1.y * v2.x;
			return vec;
		}
		
		/**
		 * Multiplies a scalar value to the vector
		 * @param	val
		 */
		public function mulScalar(val:Number):void
		{
			x *= val;
			_y *= val;
		}
		
		/**
		 * Returns a vector of a result of multiplying the scalar and vector
		 * @param	v
		 * @param	val
		 * @return
		 */
		public static function mulScalar(v:Vector2D, val:Number, supplyVec:Vector2D = null):Vector2D
		{
			var vec:Vector2D = supplyVec == null ? new Vector2D() : supplyVec;
			vec.x = v.x * val;
			vec.y = v.y * val;
			return vec;
		}
		
		/* ARITHMETIC */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Dot product multiplied by both magnitudes give cosine of the angles between the vectors
		 * @param	v2
		 * @return
		 */
		public static function angleCos(v1:Vector2D, v2:Vector2D):Number
		{
			return dot(v1, v2) / v2.magnitude / v1.magnitude;
		}
		
		/**
		 * Cross product multiplied by both magnitudes give sine of the angles between the vectors
		 * @param	v1
		 * @param	v2
		 * @return
		 */
		public static function angleSin(v1:Vector2D, v2:Vector2D):Number
		{
			return cross(v1, v2) / v2.magnitude / v1.magnitude;
		}
		
		/**
		 * Returns the angle between two vectors in degrees using angleCos
		 * @param	v1
		 * @param	v2
		 * @return
		 */
		public static function angleBetween(v1:Vector2D, v2:Vector2D, inDeg:Boolean = false):Number
		{
			return Math.acos(angleCos(v1, v2)) * (inDeg ? RAD2DEG : 1);
		}
		
		/* ANGLES */
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Returns the dot product (v1 mag * v2 mag * cos(angle between vecs))
		 * If one of the vec is unit vec, returns length of non unit projected onto unit
		 * @param	v1
		 * @param	v2
		 * @return
		 */
		public static function dot(v1:Vector2D, v2:Vector2D):Number
		{
			return v1.x * v2.x + v1.y * v2.y;
		}
		
		/**
		 * Returns the cross product (v1 mag * v2 mag * sin(angle between vecs))
		 * perpendicularity = 1
		 * @param	v2
		 * @return
		 */
		public static function cross(v1:Vector2D, v2:Vector2D):Number
		{
			return v1.x * v2.y - v1.y * v2.x;
		}
		
		/**
		 * Returns the projected vector of v1 onto v2
		 * @param	v1
		 * @param	v2
		 * @return
		 */
		public static function project(v1:Vector2D, v2:Vector2D, supplyVec:Vector2D = null):Vector2D
		{
			var v:Vector2D = supplyVec == null ? supplyVec : new Vector2D();
			v.x = v2.x;
			v.y = v2.y;
			v.mulScalar(dot(v1, v2) / getMagnitudeSquared(v2));
			return v;
		}
		
		/**
		 * Returns the rejected vector of v1 onto v2
		 * @param	v1
		 * @param	v2
		 * @return
		 */
		public static function reject(v1:Vector2D, v2:Vector2D, supplyVec:Vector2D = null):Vector2D
		{
			return sub(v1, project(v1, v2, supplyVec));
		}
		
		/**
		 * Returns the vector when v1 is reflected upon v2
		 * @param	v1
		 * @param	v2
		 * @return
		 */
		public static function reflect(v1:Vector2D, v2:Vector2D):Vector2D
		{
			return sub(mulScalar(project(v1, v2), 2), v1);
		}
		
		/* VEC TRANSMUTATION */
		//-----------------------------------------------------------------------------------------
		
		public static function lerp(v1:Vector2D, v2:Vector2D, t:Number):Vector2D
		{
			return add(mulScalar(v1, 1 - t), mulScalar(v2, t));
		}
		
		public static function slerp(v1:Vector2D, v2:Vector2D, t:Number):Vector2D
		{
			var ang:Number = angleBetween(v1, v2);
			if (Math.round(ang * RAD2DEG) == 0 || Math.round(ang * RAD2DEG) == 180) return lerp(v1, v2, t);
			// catch infinity / divide by 0 errors
			var sinAng:Number = Math.sin(ang);
			return add(mulScalar(v1, Math.sin((1 - t) * ang) / sinAng), mulScalar(v2, Math.sin(t * ang) / sinAng));
		}
		
		public static function nlerp(v1:Vector2D, v2:Vector2D, t:Number):Vector2D
		{
			return mulScalar(getUnit(add(mulScalar(v1, 1 - t), mulScalar(v2, t))), (v1.magnitude + v2.magnitude) * t);
		}
		
		/* INTERPOLATION */
		//-----------------------------------------------------------------------------------------
		
		public static function isEqual(v1:Vector2D, v2:Vector2D):Boolean
		{
			return (v1.x == v2.x && v1.y == v2.y);
		}
		
		public static function isNormal(v1:Vector2D, v2:Vector2D):Boolean
		{
			return dot(v1, v2) == 0;
		}
		
		/* BOOLEAN CHECKS*/
		//-----------------------------------------------------------------------------------------
		
		/**
		 * Returns a string describing the vector's cartesian and polar coordinates
		 * @return
		 */
		public function toString():String
		{
			return ("(x = " + _x + ", y = " + _y + " | r = " + magnitude + ", a" + angle + ")");
		}
		
		/**
		 * Using graphics.draw to display the vector graphically
		 * @param	source		Sprite instance to draw on
		 * @param	col			Color to draw in
		 * @param	grid		The size of the cartesian plane
		 * (<0 for no plane, 0 for follow magnitude size, > 0 for fixed size)
		 * @param	dAlpha		Line from origin to dX and dY's alpha value
		 * @param	rad			Radian for circle to show start of vector tail
		 * @param	lthc		Line thickness value
		 */
		public function draw(source:Sprite, col:uint = 0x000000, grid:Number = 0, dAlpha:Number = 0.15, rad:Number = 5, lthc:Number = 2):void
		{
			if (grid >= 0)
			{
				var gL:Number = grid > 0 ? grid : magnitude;
				source.graphics.lineStyle(lthc, 0x888888, dAlpha);
				source.graphics.moveTo(dx - gL, dy);
				source.graphics.lineTo(dx + gL, dy);
				source.graphics.moveTo(dx, dy - gL);
				source.graphics.lineTo(dx, dy + gL);
			}
			source.graphics.beginFill(col);
			source.graphics.drawCircle(dx, dy, rad);
			source.graphics.endFill();
			source.graphics.lineStyle(lthc, col, dAlpha);
			source.graphics.moveTo(0, 0);
			source.graphics.lineTo(dx, dy);
			source.graphics.lineStyle(lthc, col, 1);
			source.graphics.lineTo(x + dx, y + dy);
			
		}
		
		/* DEBUG */
		//-----------------------------------------------------------------------------------------
		
	}

}