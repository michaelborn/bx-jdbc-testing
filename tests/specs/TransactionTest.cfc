component extends="BaseTest" {

	variables.testDSN = "mssql";
	function beforeAll(){
		super.beforeAll();
	}

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

			/**
			 * Adobe: Throws 'Parameter validation error for transactionSetSavepoint function.' What's more, it's a compile-time error, so you can't even catch it with try/catch or expect().toThrow() in tests. For these reasons, this test is commented out.
			 * Lucee: Does not throw.
			 * BoxLang: Does not throw.
			 
			it( "can set an anonymous savepoint", function(){
				expect( function(){
					transaction{
						queryExecute(
							"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
							{ id : { value : 77, sqltype : "integer" }, name : "Michael Born", role : "Developer" },
							{ datasource: variables.testDSN }
						);
						transactionSetSavepoint();
					}
				}).notToThrow();

				var result = queryExecute(
					"SELECT * FROM developers WHERE id = 77",
					[],
					{ datasource: variables.testDSN }
				);

				expect( result.recordCount ).toBe( 1, "should be 1 records inserted" );
			});
			*/

			/**
			 * Adobe: no throw.
			 * Lucee: no throw.
			 * BoxLang: no throw.
			 */
			it( "can handle commit as the first statement in a transaction", function(){
				expect( function(){
					transaction{
						transactionCommit();
					}
				}).notToThrow();
			});

			/**
			 * Adobe: no throw.
			 * Lucee: no throw.
			 * BoxLang: no throw.
			 */
			it( "can handle rollback as the first statement in a transaction", function(){
				expect( function(){
					transaction{
						transactionRollback();
					}
				}).notToThrow();
			});

			/**
			 * Adobe: Throws.
			 * 		- Message [Savepoint cannot be set at this point in transaction.]
			 * 		- Detail [Savepoints cannot be set if there was no query to execute since the transaction start or since the last transaction commit or complete rollback
			 * Lucee: no throw.
			 * BoxLang: no throw.
			 */
			xit( "can handle transactionSetSavepoint as the first statement in a transaction", function(){
				expect( function(){
					transaction{
						transactionSetSavepoint( "foo" );
					}
				}).notToThrow();
			});

			// Dumb Lucee-only bug in Lucee 5.4.8.2
			it( "can do transactions inside a closure", () => {
				expect( function(){
					transaction{
						queryExecute(
							"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
							{ id : { value : 77, sqltype : "integer" }, name : "Michael Born", role : "Developer" },
							{ datasource: variables.testDSN }
						);
					}
				}).notToThrow();
			})
			it( "won't roll back past a savepoint", () => {
				transaction{
					queryExecute(
						"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
						{ id : { value : 77, sqltype : "integer" }, name : "Michael Born", role : "Developer" },
						{ datasource: variables.testDSN }
					);
					transactionSetSavepoint( "foo" );

					queryExecute(
						"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
						{ id : { value : 88, sqltype : "integer" }, name : "Willie Nelson", role : "Quality Assurance" },
						{ datasource: variables.testDSN }
					);

					transactionRollback( "foo" );
				}

				var result = queryExecute(
					"SELECT * FROM developers WHERE id IN ( 77, 88 )",
					[],
					{ datasource: variables.testDSN }
				);

				expect( result.recordCount ).toBe( 1, "should be 1 record after rolling back to savepoint." );
				expect( result.name[1] ).toBe( "Michael Born", "record that should persist after rollback is the one inserted before the savepoint." );
			})

			describe( "nested transactions", function(){

				/**
				 * Adobe:
				 * 	rolls back the outer transaction, EVEN THOUGH NESTED TRANSACTIONS ARE SUPPOSED TO BE SUPPORTED. This is a known issue/quirk in Adobe ColdFusion's implementation of nested transactions. When you call transactionRollback() within a nested transaction, it rolls back the entire transaction, including the outer transaction, instead of just rolling back to the savepoint or affecting only the inner transaction.
				 * 
				 * Lucee: rolls back the outer transaction, because nested transactions are not supported. (The nested transaction block is essentially ignored, so the transactionRollback() call rolls back the entire transaction.)
				 * 
				 * BoxLang: Does not throw.
				*/
				it( "nested transaction rollback should not roll back parent", function(){
					transaction{
						queryExecute(
							"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
							{ id : { value : 77, sqltype : "integer" }, name : "Michael Born", role : "Developer" },
							{ datasource: variables.testDSN }
						);

						transaction{
							queryExecute( "INSERT INTO developers ( id, name, role ) VALUES ( 33, 'Jon Clausen', 'Developer' )", {}, { datasource: variables.testDSN } );
							transactionRollback();
						}
					}

					var result = queryExecute(
						"SELECT * FROM developers WHERE id = 77",
						[],
						{ datasource: variables.testDSN }
					);

					// In Lucee and Adobe, this will be 0 (full rollback)
					// In BoxLang, this is different
					expect( result.recordCount ).toBeTypeOf( "numeric" ).toBe( 1, "inserted row should persist despite child transaction rollback." );
				});

				/**
				 * Adobe: Throws.
				 * 	 - message [Nested cftransaction tag should specify same isolation level as the parent.] 
				 *   - detail [A child cftransaction tag cannot use an isolation level different from the parent cftransaction tag. Parent isolation level is repeatable_read and child isolation level is read_committed]
				 * 
				 * Lucee: Does not throw. Lucee ignores isolation level in nested transactions and does not enforce matching isolation levels.
				 * 
				 * BoxLang: Does not throw.
				*/
				it( "throws when isolation level changes in a nested transaction", function(){
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
					}).toThrow();
				});

			});

		});

	}

}
