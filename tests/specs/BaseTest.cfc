component extends="testbox.system.BaseSpec" {

    variables.testDSN = "mysql";

	function beforeAll(){
		setupDatabase();
	}

	function setupDatabase(){
		IF( variables.testDSN EQ "mssql" ){
			try {
				queryExecute(
					"CREATE DATABASE myDB",
					{},
					{ datasource: variables.testDSN }
				);
			} catch ( any e ) {
				// Database may already exist
			}
		}
		queryExecute(
			"DROP TABLE IF EXISTS developers",
			[],
			{ datasource: variables.testDSN }
		);
		queryExecute(
			"DROP TABLE IF EXISTS foo",
			[],
			{ datasource: variables.testDSN }
		);
		queryExecute(
			"CREATE TABLE developers ( id INTEGER, name VARCHAR(155), role VARCHAR(155) )",
			[],
			{ datasource: variables.testDSN }
		);

		try {
			queryExecute(
				"CREATE TABLE foo ( id VARCHAR(35), createdAt DATETIME )",
				{},
				{ datasource: variables.testDSN }
			);
		} catch ( any e ){
			// Table may already exist
		}

		// Seed with test data
		seedData();
	}

	function resetTestDB( currentSpec, data ){
		// Reset database state after each test
		queryExecute(
			"TRUNCATE TABLE developers",
			[],
			{ datasource: variables.testDSN }
		);
		seedData();
	}
	function seedData(){
		queryExecute(
			"INSERT INTO developers ( id, name, role ) VALUES ( 1, 'John Doe', 'Developer' )",
			[],
			{ datasource: variables.testDSN }
		);
		queryExecute(
			"INSERT INTO developers ( id, name, role ) VALUES ( 2, 'Jane Smith', 'Designer' )",
			[],
			{ datasource: variables.testDSN }
		);
	}
}