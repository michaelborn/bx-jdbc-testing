component extends="BaseTest" {

	variables.testDSN = "mssql";
	function beforeAll(){}

	function run(){

		describe( "timezone handling", function(){
			afterEach( resetTestDB );

			it( "can execute query without timezone parameter", function(){
				var result = queryExecute(
					"SELECT GETDATE() AS CurrentDateTime",
					{},
					{ datasource: variables.testDSN, debug: true }
				);

				expect( isQuery( result ) ).toBeTrue();
				expect( result.recordCount ).toBe( 1 );
				expect( isDate( result.CurrentDateTime ) ).toBeTrue();
			});

			it( "can execute query with timezone parameter", function(){
				var result = queryExecute(
					"SELECT GETDATE() AS CurrentDateTime",
					{},
					{ datasource: variables.testDSN, debug: true, timezone = "Europe/Amsterdam" }
				);

				expect( isQuery( result ) ).toBeTrue();
				expect( result.recordCount ).toBe( 1 );
				expect( isDate( result.CurrentDateTime ) ).toBeTrue();
			});

			it( "can insert with timezone parameter and timestamp", function(){
				var uuid = createUUID();
				var result = queryExecute(
					"INSERT INTO myDB.dbo.foo (id, createdAt) VALUES ( :id, :createdAt )",
					{
						id: { value: uuid, cfsqltype: "cf_sql_varchar" },
						createdAt: { value: now(), cfsqltype: "cf_sql_timestamp" }
					},
					{ datasource: variables.testDSN, debug: true, timezone = "Europe/Amsterdam" }
				);

				// Verify the insert worked
				var verification = queryExecute(
					"SELECT * FROM myDB.dbo.foo WHERE id = :id",
					{ id: uuid },
					{ datasource: variables.testDSN }
				);

				expect( verification.recordCount ).toBe( 1 );
				expect( isDate( verification.createdAt ) ).toBeTrue();
			});

		});

	}

}
