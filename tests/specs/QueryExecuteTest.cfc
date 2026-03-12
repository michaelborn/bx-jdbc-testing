component extends="BaseTest" {

	variables.testDSN = "mysql";
	function beforeAll(){
		super.beforeAll();
	}

	function run(){

		describe( "queryExecute basic functionality", function(){
			afterEach( resetTestDB );

			it( "can execute a simple SELECT query", function(){
				var result = queryExecute(
					"SELECT 1 AS test",
					[],
					{ datasource: variables.testDSN }
				);

				expect( result.recordCount ).toBe( 1 );
			});

			it( "can insert with named parameters", function(){
				var result = queryExecute(
					"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
					{ id : { value : 77, cfsqltype : "cf_sql_integer" }, name : "Michael Born", role : "Developer" },
					{ datasource: variables.testDSN }
				);

				var verification = queryExecute(
					"SELECT * FROM developers WHERE id = 77",
					[],
					{ datasource: variables.testDSN }
				);

				expect( verification.recordCount ).toBe( 1 );
			});

			it( "can insert with positional parameters", function(){
				var result = queryExecute(
					"INSERT INTO developers ( id, name, role ) VALUES ( ?, ?, ? )",
					[ { value : 77, cfsqltype : "integer" }, "Jon Clausen", "Engineer" ],
					{ datasource: variables.testDSN }
				);

				var verification = queryExecute(
					"SELECT * FROM developers WHERE id = 77",
					[],
					{ datasource: variables.testDSN }
				);

				expect( verification.recordCount ).toBe( 1 );
			});

			it( "can insert multiple rows with array parameters", function(){
				var result = queryExecute(
					"INSERT INTO developers ( id, name, role ) VALUES ( ?, ?, ? ), ( ?, ?, ? )",
					[ { value : 77, cfsqltype : "integer" }, "Jon Clausen", "Engineer", { value : 81, cfsqltype : "cf_SQL_integer" }, "Eric Peterson", "Engineer" ],
					{ datasource: variables.testDSN }
				);

				var verification = queryExecute(
					"SELECT * FROM developers WHERE id IN (77, 81)",
					[],
					{ datasource: variables.testDSN }
				);

				expect( verification.recordCount ).toBe( 2 );
			});

			describe( "null handling", function(){

				it( "can insert null values with nulls=true", function(){
					queryExecute(
						"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
						{ id : { value : 99, cfsqltype : "cf_sql_integer" }, name : "Michael Whomever", role : { nulls: true } },
						{ datasource: variables.testDSN }
					);

					var data = queryExecute(
						"SELECT * FROM developers WHERE id = 99",
						[],
						{ datasource: variables.testDSN }
					);

					expect( data.recordCount ).toBe( 1 );
				});

				it( "can coerce null to empty string", function(){
					queryExecute(
						"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
						{ id : { value : 99, cfsqltype : "cf_sql_integer" }, name : "Michael Whomever", role : { nulls: true } },
						{ datasource: variables.testDSN }
					);

					var data = queryExecute(
						"SELECT * FROM developers WHERE id = 99",
						[],
						{ datasource: variables.testDSN }
					);

					// Test null coercion to empty string
					expect( isNull( data.role ) OR data.role == "" ).toBeTrue();
				});

			});

			describe( "parameter type specifications", function(){

				it( "supports cfsqltype attribute with compat module", function(){
					var result = queryExecute(
						"INSERT INTO developers ( id, name, role ) VALUES ( ?, ?, ? )",
						[ { value : 88, cfsqltype : "integer" }, "Jon Clausen", "Engineer" ],
						{ datasource: variables.testDSN }
					);

					var verification = queryExecute(
						"SELECT * FROM developers WHERE id = 88",
						[],
						{ datasource: variables.testDSN }
					);

					expect( verification.recordCount ).toBe( 1 );
				});

				it( "supports cf_SQL_ prefixed types", function(){
					var result = queryExecute(
						"INSERT INTO developers ( id, name, role ) VALUES ( ?, ?, ? )",
						[ { value : 77, cfsqltype : "cf_SQL_integer" }, "Jon Clausen", "Engineer" ],
						{ datasource: variables.testDSN }
					);

					var verification = queryExecute(
						"SELECT * FROM developers WHERE id = 77",
						[],
						{ datasource: variables.testDSN }
					);

					expect( verification.recordCount ).toBe( 1 );
				});

				it( "supports sqltype attribute", function(){
					var result = queryExecute(
						"INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
						{ id : { value : 99, sqltype : "integer" }, name : "Michael Born", role : "Developer" },
						{ datasource: variables.testDSN }
					);

					var verification = queryExecute(
						"SELECT * FROM developers WHERE id = 99",
						[],
						{ datasource: variables.testDSN }
					);

					debug( verification );

					expect( verification.recordCount ).toBe( 1 );
				});

			});

			describe( "connection tests", function(){

				it( "can query database process list", function(){
					var result = queryExecute(
						"SELECT * FROM information_schema.PROCESSLIST",
						[],
						{ datasource: variables.testDSN }
					);

					expect( result.recordCount ).toBeGT( 0 );
					expect( isQuery( result ) ).toBeTrue();
				});

			});

		});

	}

}