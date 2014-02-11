package vault.utils
{
	import flash.utils.describeType;

	/** 
	 * <code>removeClassPrefix</code> is a function that removes the prefix from a <code>Class</code> name.<br /><br />
	 * E.g. <code>"flash:display::Sprite"</code> becomes <code>"Sprite"</code>
	 * @param classObject
	 * @return
	 */		
	public function removeClassPrefix( classObject:Class ):String
	{
		var classNameFullPath:String = describeType( classObject ).@name.toString();
		return classNameFullPath.substr( classNameFullPath.lastIndexOf( ":" ) + 1 );
	}
}