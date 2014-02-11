package vault.dataObjects
{
	import flash.utils.Dictionary;

	public class LanguageDO
	{
		private var _id:String;
		private var _nodes:Dictionary = new Dictionary;
		
		public function LanguageDO( xml:XML )
		{
			_id = xml.@id;
			
			for each( var node:XML in xml.children() )
				 _nodes[ node.localName() ] = node.toString();			
		}
		
		public function getNode( name:String ):String
		{
			if( _nodes[ name ] ) return _nodes[ name ];
			else throw new Error( "A node with the name '" + name + "' does not exist" );
		}

		public function get id():String
		{
			return _id;
		}
	}
}