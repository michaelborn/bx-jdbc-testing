component extends="BaseTest" {

	variables.testDSN = "mysql";

	function beforeAll(){}

	function run(){

		describe( "cachedAfter attribute", function(){
			afterEach( resetTestDB );

			it( "can cache query results using cachedAfter attribute", function(){
				var queryMeta = {};
				var result = queryExecute(
					"SELECT 1, CURRENT_TIMESTAMP AS CurrentDateTime FROM SYSIBM.SYSDUMMY1",
					{},
					{ datasource = variables.testDSN, cachedAfter = "2024-06-01", result = "queryMeta" }
				);

				expect( queryMeta.cached ).toBeTrue();
				expect( result.recordCount ).toBe( 1 );
			});

			it( "can retrieve results from cache on subsequent calls", function(){
				var queryMeta = {};
				var firstResult = queryExecute(
					"SELECT 1, CURRENT_TIMESTAMP AS CurrentDateTime FROM SYSIBM.SYSDUMMY1",
					{},
					{ datasource = variables.testDSN, cachedAfter = "2024-06-01", result = "queryMeta" }
				);
				var firstCached = queryMeta.cached;

				sleep( 1000 );

				var secondResult = queryExecute(
					"SELECT 1, CURRENT_TIMESTAMP AS CurrentDateTime FROM SYSIBM.SYSDUMMY1",
					{},
					{ datasource = variables.testDSN, cachedAfter = "2024-06-01", result = "queryMeta" }
				);
				var secondCached = queryMeta.cached;

				expect( firstCached ).toBeTrue();
				expect( secondCached ).toBeTrue();
			});

			it( "honors cacheTimeout with cachedAfter", function(){
				var queryMeta = {};
				queryExecute(
					"SELECT 1, CURRENT_TIMESTAMP AS CurrentDateTime FROM SYSIBM.SYSDUMMY1",
					{},
					{ datasource = variables.testDSN, cachedAfter = "2024-06-01", result = "queryMeta" }
				);

				expect( queryMeta.cacheTimeout ).toBeTypeOf( "date" );
			});

		});

	}

}
