# JDBC Tests

## Getting Started

1. download the webserver jar OR setup a symbolic link to your boxlang source code's compiled webserver jar
2. Run `java -jar boxlang-webserver-1.0.0-all.jar` in the repo root.

## JDBC Tests:

It appears the `driver` is required when it probably shouldn't be, for backwards compat:

```js
queryExecute( "SELECT 1", {}, { datasource : {  "connectionString" : "jdbc:derby:memory:myDB;create=true" } } );
```

fails with 

```sh
BoxLang> queryExecute( "SELECT 1", {}, { datasource : {  "connectionString" : "jdbc:derby:memory:myDB;create=true" } } );
java.lang.IllegalArgumentException: Datasource properties must contain 'type' or a 'driver' to use
at ortus.boxlang.runtime.jdbc.ConnectionManager.getOnTheFlyDataSource(ConnectionManager.java:365)
at ortus.boxlang.runtime.jdbc.QueryOptions.determineDataSource(QueryOptions.java:228)
at ortus.boxlang.runtime.jdbc.QueryOptions.<init>(QueryOptions.java:129)
at ortus.boxlang.runtime.bifs.global.jdbc.QueryExecute._invoke(QueryExecute.java:81)
```

Next, running a `SELECT 1` query throws an `EOF` exception:

```sh
BoxLang> queryExecute( "SELECT 1", [], { datasource: { "driver" : "derby", "connectionString": "jdbc:derby:memory:myDB;create=true" } } );
ortus.boxlang.runtime.types.exceptions.DatabaseException: Syntax error: Encountered "<EOF>" at line 1, column 8.
at ortus.boxlang.runtime.jdbc.PendingQuery.execute(PendingQuery.java:220)
at ortus.boxlang.runtime.bifs.global.jdbc.QueryExecute._invoke(QueryExecute.java:89)
at ortus.boxlang.runtime.bifs.BIF.invoke(BIF.java:87)
at ortus.boxlang.runtime.bifs.BIFDescriptor.invoke(BIFDescriptor.java:187)
at ortus.boxlang.runtime.context.BaseBoxContext.invokeFunction(BaseBoxContext.java:392)
at boxgenerated.scripts.Statement_629edb3be792af4ea3ff00a0d450be24._invoke(Statement_629edb3be792af4ea3ff00a0d450be24.java:77)
at ortus.boxlang.runtime.runnables.BoxScript.invoke(BoxScript.java:77)
at ortus.boxlang.runtime.BoxRuntime.executeSource(BoxRuntime.java:1145)
at ortus.boxlang.runtime.BoxRuntime.executeSource(BoxRuntime.java:1107)
at ortus.boxlang.runtime.BoxRunner.main(BoxRunner.java:125)
Caused by: java.sql.SQLSyntaxErrorException: Syntax error: Encountered "<EOF>" at line 1, column 8.
at bx-derby//org.apache.derby.impl.jdbc.SQLExceptionFactory.getSQLException(SQLExceptionFactory.java:103)
at bx-derby//org.apache.derby.impl.jdbc.Util.generateCsSQLException(Util.java:230)
at bx-derby//org.apache.derby.impl.jdbc.TransactionResourceImpl.wrapInSQLException(TransactionResourceImpl.java:431)
at bx-derby//org.apache.derby.impl.jdbc.TransactionResourceImpl.handleException(TransactionResourceImpl.java:360)
at bx-derby//org.apache.derby.impl.jdbc.EmbedConnection.handleException(EmbedConnection.java:2400)
at bx-derby//org.apache.derby.impl.jdbc.ConnectionChild.handleException(ConnectionChild.java:86)
at bx-derby//org.apache.derby.impl.jdbc.EmbedStatement.execute(EmbedStatement.java:697)
at bx-derby//org.apache.derby.impl.jdbc.EmbedStatement.execute(EmbedStatement.java:736)
at com.zaxxer.hikari.pool.ProxyStatement.execute(ProxyStatement.java:102)
at com.zaxxer.hikari.pool.HikariProxyStatement.execute(HikariProxyStatement.java)
at ortus.boxlang.runtime.jdbc.PendingQuery.executeStatement(PendingQuery.java:243)
at ortus.boxlang.runtime.jdbc.PendingQuery.execute(PendingQuery.java:204)
... 9 more
Caused by: ERROR 42X01: Syntax error: Encountered "<EOF>" at line 1, column 8.
at bx-derby//org.apache.derby.shared.common.error.StandardException.newException(StandardException.java:299)
at bx-derby//org.apache.derby.shared.common.error.StandardException.newException(StandardException.java:294)
at bx-derby//org.apache.derby.impl.sql.compile.ParserImpl.parseStatementOrSearchCondition(ParserImpl.java:175)
at bx-derby//org.apache.derby.impl.sql.compile.ParserImpl.parseStatement(ParserImpl.java:130)
at bx-derby//org.apache.derby.impl.sql.GenericStatement.prepMinion(GenericStatement.java:359)
at bx-derby//org.apache.derby.impl.sql.GenericStatement.prepare(GenericStatement.java:99)
at bx-derby//org.apache.derby.impl.sql.conn.GenericLanguageConnectionContext.prepareInternalStatement(GenericLanguageConnectionContext.java:1114)
at bx-derby//org.apache.derby.impl.jdbc.EmbedStatement.execute(EmbedStatement.java:689)
... 14 more
```

queryExecute( "CREATE TABLE developers ( id INTEGER, name VARCHAR(155), role VARCHAR(155) )", [], { datasource: { "driver" : "derby", "connectionString": "jdbc:derby:memory:myDB;create=true" } } );

queryExecute( "SELECT * FROM developers", [], { datasource: { "driver" : "derby", "connectionString": "jdbc:derby:memory:myDB;create=true" } } );

Testing with datasource definitions:

```js
"myMysql": {
	"driver": "mysql",
	"properties": {
		"host": "${env.MYSQL_HOST:localhost}",
		"port": "${env.MYSQL_PORT:3306}",
		"database": "${env.MYSQL_DATABASE:myDB}",
		"username": "${env.MYSQL_USERNAME:root}",
		"password": "${env.MYSQL_PASSWORD}"
	}
},
```