component{
	this.name = "Foo";

	// this.datasources["derby"] = {
	// 	"driver": "derby",
	// 	"properties": {
	// 		"connectionString": "jdbc:derby:memory:testDB;create=true"
	// 	}
	// };

	// this.datasources["mysql"] = {
	// 	"class":"com.mysql.cj.jdbc.Driver",
	// 	"connectionLimit":"100",
	// 	"connectionTimeout":"1000",
	// 	"custom":"useUnicode=true&characterEncoding=UTF8&serverTimezone=UTC&useLegacyDatetimeCode=true&autoReconnect=true&useSSL=false&allowPublicKeyRetrieval=true",
	// 	"database":"${DB_DATABASE:cms}",
	// 	"dbdriver":"${DB_DRIVER:MySQL}",
	// 	"dsn":"jdbc:mysql://{host}:{port}/{database}",
	// 	"host":"${DB_HOST:127.0.0.1}",
	// 	"password":"${DB_PASSWORD:superS3cret}",
	// 	"port":"${DB_PORT:3306}",
	// 	"username":"${DB_USER:root}",
	// 	"storage":"false"
	// };
	// this.datasources["mariadb"] = {
	// 	"driver": "mariadb",
	// 	"host": "${env.MARIADB_HOST:localhost}",
	// 	"port": "${env.MARIADB_PORT:3309}",
	// 	"database": "${env.MARIADB_DATABASE:myDB}",
	// 	"username": "${env.MARIADB_USERNAME:root}",
	// 	"password": "123456Password"
	// };
	// this.datasources["postgres"] = {
	// 	"driver": "postgresql",
	// 	"host": "${env.POSTGRES_HOST:localhost}",
	// 	"port": "${env.POSTGRES_PORT:5432}",
	// 	"database": "${env.POSTGRES_DATABASE:myDB}",
	// 	"username": "${env.POSTGRES_USERNAME:postgres}",
	// 	"password": "123456Password"
	// };
	// this.datasources["postgres"] = {
	// 	"driver": "postgresql",
	// 	"host": "${env.POSTGRES_HOST:localhost}",
	// 	"port": "${env.POSTGRES_PORT:5432}",
	// 	"database": "${env.POSTGRES_DATABASE:myDB}",
	// 	"username": "${env.POSTGRES_USERNAME:postgres}",
	// 	"password": "123456Password"
	// };
	// this.datasources["mssql"] = {
	// 	"driver": "mssql",
	// 	"host": "${env.MSSQL_HOST:localhost}",
	// 	"port": "${env.MSSQL_PORT:1433}",
	// 	"database": "${env.MSSQL_DATABASE:master}",
	// 	"username": "${env.MSSQL_USERNAME:sa}",
	// 	"password": "123456Password"
	// };
	// this.datasources["urlonly"] = {
	// 	"url" : "jdbc:mysql://${env.MYSQL_HOST:localhost}:${env.MYSQL_PORT:3306}/${env.MYSQL_DATABASE:myDB}",
	// 	"username": "${env.MYSQL_USERNAME:root}",
	// 	"password": "123456Password"
	// };

	function onRequestStart(){
		// request.testDSN = "myDerby";
		// request.testDSN = "myMysql";
		// request.testDSN = "derby";
		request.testDSN = "mysql";
		// request.testDSN = "mariadb";
		// request.testDSN = "postgres";
		// request.testDSN = "mssql";
		// request.testDSN = "urlonly";

		variables.drop = queryExecute(
			"DROP TABLE developers",
			[],
			{ datasource: request.testDSN }
		);
		// writeDump( var = variables.drop, label = "drop" );
		variables.creation = queryExecute(
			"CREATE TABLE developers ( id INTEGER, name VARCHAR(155), role VARCHAR(155) )",
			[],
			{ datasource: request.testDSN }
		);
		// writeDump( var = variables.creation, label = "creation" );

		variables.structparams = queryExecute(
			"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
			{ id : { value : 77, cfsqltype : "cf_sql_integer" }, name : "Michael Born", role : "Developer" },
			{ "datasource": request.testDSN }
		);
		// writeDump( var = variables.structparams, label = "structparams" );
		variables.arrayparams = queryExecute(
			"INSERT INTO developers ( id, name, role ) VALUES ( ?, ?, ? ),( ?, ?, ? )",
			[ { value : 78, sqltype : "integer" }, "Jon Clausen", "Engineer", { value : 81, sqltype : "cf_SQL_integer" }, "Eric Peterson", "Engineer"],
			{ "datasource": request.testDSN }
		);
		// writeDump( var = variables.arrayparams, label = "arrayparams" );

		variables.selection = queryExecute(
			"SELECT * FROM developers",
			[],
			{ datasource: request.testDSN }
		);

		// writeDump( var = variables.selection, label = "selection" );

		// MSSQL only:
		/*
		result = queryExecute( "
			insert into developers (id, name) OUTPUT INSERTED.*
			VALUES (1, 'Luis'), (2, 'Brad'), (3, 'Jon')
		",{},{ datasource: request.testDSN } );
		writeDump( result );
		*/
	}

}