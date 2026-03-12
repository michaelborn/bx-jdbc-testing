component extends="BaseTest" {

	variables.testDSN = "mssql";
	function beforeAll(){}

	function run(){

		describe( "basic transactions", function(){
			afterEach( resetTestDB );

			it( "can commit a transaction", function(){
				transaction{
					queryExecute(
						"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
						{ id : { value : 77, sqltype : "integer" }, name : "Michael Born", role : "Developer" },
						{ datasource: variables.testDSN }
					);
				}

				var result = queryExecute(
					"SELECT * FROM developers WHERE id = 77",
					[],
					{ datasource: variables.testDSN }
				);

				debug( result );

				expect( result.recordCount ).toBe( 1 );
			});

			it( "can roll back a transaction", function(){
				transaction{
					queryExecute(
						"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
						{ id : { value : 77, sqltype : "integer" }, name : "Michael Born", role : "Developer" },
						{ datasource: variables.testDSN }
					);
					transactionRollback();
				}

				var result = queryExecute(
					"SELECT * FROM developers WHERE id = 77",
					[],
					{ datasource: variables.testDSN }
				);

				expect( result.recordCount ).toBe( 0, "should be 0 records inserted after rollback" );
			});

			describe( "nested transactions", function(){

				it( "can handle rollback as the first statement in a transaction", function(){
					// Lucee doesn't throw an error when rollback is the first statement
					// This should not throw
					expect( function(){
						transaction{
							transactionRollback();
						}
					}).notToThrow();
				});

				it( "nested transaction rollback should not roll back parent", function(){
					// In Lucee, nested transactions aren't supported
					// Inner transaction rollback affects the parent transaction
					transaction{
						queryExecute(
							"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
							{ id : { value : 77, sqltype : "integer" }, name : "Michael Born", role : "Developer" },
							{ datasource: variables.testDSN }
						);

						transaction{
							transactionRollback();
						}
					}

					var result = queryExecute(
						"SELECT * FROM developers WHERE id = 77",
						[],
						{ datasource: variables.testDSN }
					);

					// In Lucee, this will be 0 (full rollback)
					// In Adobe/BoxLang, this might be different
					expect( result.recordCount ).toBeTypeOf( "numeric" ).toBe( 1, "inserted row should persist despite child transaction rollback." );
				});

				it( "can handle isolation level changes in nested transactions", function(){
					expect( function(){
						transaction isolation = "repeatable_read" {
							queryExecute(
								"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
								{ id : { value : 77, sqltype : "integer" }, name : "Michael Born", role : "Developer" },
								{ datasource: variables.testDSN }
							);

							transaction isolation = "read_committed" {
								queryExecute(
									"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
									{ id : { value : 88, sqltype : "integer" }, name : "Willie Nelson", role : "Quality Assurance" },
									{ datasource: variables.testDSN }
								);
							}
						}
					}).notToThrow();

					var result = queryExecute(
						"SELECT * FROM developers",
						[],
						{ datasource: variables.testDSN }
					);

					expect( result.recordCount ).toBeGT( 0 );
				});

			});

		});

	}

}
