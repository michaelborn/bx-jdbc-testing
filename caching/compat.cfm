<cfscript>
request.testDSN = "derby";
runQuery = function(){
    var result = queryExecute(
        // mssql:
        // "SELECT 1, GETDATE() AS CurrentDateTime",
        // Derby:
        "SELECT 1, CURRENT_TIMESTAMP AS CurrentDateTime FROM SYSIBM.SYSDUMMY1",
        {},
        { datasource= request.testDSN, cachedAfter: "2024-06-01", result = "variables.queryMeta" }
    );
    return result;
};

runQuery();
writeDump( variables.queryMeta.cached );
writeDump( variables.queryMeta.cacheTimeout );
sleep( 1000 );
runQuery();
writeDump( variables.queryMeta.cached );
writeDump( variables.queryMeta.cacheTimeout );
</cfscript>