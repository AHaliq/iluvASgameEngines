package com.iluvas.utilities 
{
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author iluvAS
	 */
	public final class ILUOOP 
	{
		
		/**
		 * If class A inherits or is class B this function will return true
		 * @param	a
		 * @param	b
		 * @return
		 */
		public static function checkIfExtendsOrIs(a:Class, b:Class):Boolean
		{
			var desc:XML = XML(describeType(a));            
			var name:String = getQualifiedClassName(b);
			return Boolean(desc.factory.extendsClass.@type.contains(name) || desc.factory.implementsInterface.@type.contains(name));
		}
		
	}

}