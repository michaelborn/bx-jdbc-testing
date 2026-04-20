component{
	this.name = "JDBC Tests";

	rootPath                 = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings[ "/root" ] = rootPath;
	this.mappings[ "/cborm" ] = rootPath & "modules/cborm/";

	// this.ormEnabled  = true;
	// this.ormSettings = {
	// 	cfclocation : [
	// 		rootPath & "models"
	// 	],
	// 	dialect              : "org.hibernate.dialect.MySQL5InnoDBDialect",   // MySQL Dialect
	// 	dbcreate             : "none",
	// 	secondarycacheenabled: false,
	// 	cacheprovider        : "ehCache",
	// 	logSQL               : false,
	// 	flushAtRequestEknd   : false,
	// 	autoManageSession    : false,
	// 	eventHandling        : true,
	// 	eventHandler         : "cborm.models.BXEventHandler",
	// 	skipCFCWithError     : true,
	// 	datasource           : "mysql"
	// };

	public boolean function onRequestStart( String targetPage ){
		// ormReload();
		// writeDump( var = ORMGetSessionFactory(), label = "in onRequestStart" );
		// abort;
		return true;
	}
}