package vault.utils.database
{
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.events.EventDispatcher;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;

	public class Database extends EventDispatcher
	{
		public var dbFile:File;
		public var sqlConnection:SQLConnection;
		
		public function Database( _dbFile:File = null, _sqlConnection:SQLConnection = null )
		{
			dbFile = _dbFile;
			sqlConnection = _sqlConnection;
		}
		
		/******************************************************/
		
		public function openSync():void
		{
			try
			{
				if( !sqlConnection.connected ) sqlConnection.open( dbFile );					
				dispatchEvent( new SQLEvent( SQLEvent.OPEN ) );
			}
			catch( error:Error )
			{
				dispatchEvent( new SQLErrorEvent( SQLErrorEvent.ERROR ) );
			}
		}
		
		public function openAsync():void
		{
			if( sqlConnection.connected )
			{
				dispatchEvent( new SQLEvent( SQLEvent.OPEN ) );
				return;
			}
			
			sqlConnection.addEventListener( SQLEvent.OPEN, dispatchEvent );
			sqlConnection.addEventListener( SQLErrorEvent.ERROR, dispatchEvent );
			sqlConnection.openAsync( dbFile );
		}
		
		/******************************************************/
		
		public function querySync( sqlString:String ):SQLResult
		{
			var sqlStmt:SQLStatement = new SQLStatement();
			sqlStmt.sqlConnection = sqlConnection;
			sqlStmt.text = sqlString;
			try
			{
				sqlStmt.execute();
				dispatchEvent( new SQLEvent( SQLEvent.RESULT ) );
			}
			catch( error:Error )
			{
				dispatchEvent( new SQLErrorEvent( SQLErrorEvent.ERROR ) );
			}
			
			return sqlStmt.getResult();
		}
		
		public function queryAsync( sqlString:String ):SQLStatement
		{
			//For query result - listen for SQLEvent.RESULT, then sqlStmt.getResult();
			var sqlStmt:SQLStatement = new SQLStatement();
			sqlStmt.sqlConnection = sqlConnection;
			sqlStmt.text = sqlString;
			
			sqlStmt.addEventListener( SQLEvent.RESULT, dispatchEvent );
			sqlStmt.addEventListener( SQLErrorEvent.ERROR, dispatchEvent );
			
			sqlStmt.execute();
			
			return sqlStmt;
		}
		
		/******************************************************/
		
		public function drop():void
		{
			if( dbFile && dbFile.exists ) dbFile.deleteFile();
		}
		
		public function dispose( autoDrop:Boolean = false ):void
		{
			if( autoDrop ) drop();
			
			sqlConnection.close();
			sqlConnection = null;
			dbFile = null;
		}
		
		/******************************************************/
	}
}