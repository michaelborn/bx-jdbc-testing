<cfscript>
    request.testDSN = "mssql";
    // setup:
    //     queryExecute(
    //         "CREATE DATABASE myDB;
    //         CREATE TABLE foo (
    //             id VARCHAR(35),
    //             createdAt DATETIME
    //         );",
    //         {},
    //         { datasource= request.testDSN, debug : true }
    //     )
    writeDump(
        queryExecute(
            "SELECT GETDATE() AS CurrentDateTime",
            {},
            { datasource= request.testDSN, debug : true }
        )
    );
    writeDump(
        queryExecute(
            "SELECT GETDATE() AS CurrentDateTime",
            {},
            { datasource= request.testDSN, debug : true, timezone = "Europe/Amsterdam" }
        )
    );
    writeDump(
        queryExecute(
            "INSERT INTO myDB.dbo.foo (id, createdAt) VALUES ( :id, :createdAt )",
            {
                id: { value : createUUID(), cfsqltype : "cf_sql_varchar" },
                createdAt : { value : now(), cfsqltype : "cf_sql_timestamp" }
            },
            { datasource= request.testDSN, debug : true, timezone = "Europe/Amsterdam" }
        )
    );
</cfscript>