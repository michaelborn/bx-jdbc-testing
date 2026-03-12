component extends="BaseTest" {

	variables.testDSN = "mysql";
	function beforeAll(){
		super.beforeAll();
	}

	function run(){

		describe( "Query results tests", () => {
			afterEach( resetTestDB );

			describe( "duplicate column handling", function(){

				it( "handles duplicate column names in query results", function(){
					var result = queryExecute(
						"SELECT CURRENT_DATE AS name, name, id, role FROM developers",
						{},
						{ datasource: variables.testDSN }
					);

					expect( result.recordCount ).toBeGT( 0 );
					expect( isQuery( result ) ).toBeTrue();
					// The query should contain columns, even if there are duplicate names
					expect( listLen( result.columnList ) ).toBeGT( 0 );
				});

			});

			describe( "delete query results", function(){

				it( "returns recordCount for DELETE queries", function(){
					var result = queryExecute(
						"DELETE FROM developers WHERE id = :id",
						{ id: 1 },
						{ datasource: variables.testDSN }
					);

					expect( result.recordCount ).toBe( 1 );
				});

				it( "returns 0 recordCount when no rows deleted", function(){
					var result = queryExecute(
						"DELETE FROM developers WHERE id = :id",
						{ id: 999 },
						{ datasource: variables.testDSN }
					);

					expect( result.recordCount ).toBe( 0 );
				});

				it( "returns a query object from DELETE", function(){
					var result = queryExecute(
						"DELETE FROM developers WHERE id = :id",
						{ id: 1 },
						{ datasource: variables.testDSN }
					);

					expect( isQuery( result ) ).toBeTrue();
				});

			});

			describe( "multi-statement result sets", function(){

				it( "handles MSSQL multi-statement queries", function(){
					variables.testDSN = "mssql";

					// Skip if MSSQL not configured
					try {
						var result = queryExecute(
							"SELECT * FROM developers",
							{},
							{ datasource: variables.testDSN }
						);
					} catch ( any e ) {
						skip( "MSSQL not configured" );
					}

					var result = queryExecute(
						"SELECT * FROM developers;
						INSERT INTO developers (id) VALUES (111);
						SELECT * FROM developers;
						INSERT INTO developers (id) VALUES (222);
						SELECT * FROM developers",
						{},
						{ datasource: variables.testDSN }
					);

					expect( isQuery( result ) ).toBeTrue();
					expect( result.recordCount ).toBeGT( 0 );
				});

			});
		});

	}

}
