<cfscript>
request.testDSN = "mssql";
writeDump(
    queryExecute(
        "SELECT * FROM developers",
        {},
        { datasource= request.testDSN, debug : true }
    )
);
writeDump(
    queryExecute(
        "SELECT * FROM developers;
        INSERT INTO developers (id) VALUES (111);
        SELECT * FROM developers;
        INSERT INTO developers (id) VALUES (222);
        SELECT * FROM developers;
        ",
        {},
        { datasource= request.testDSN }
    )
);

// queryExecute(
//     "CREATE TABLE MyTable (
//         ID int IDENTITY(1,1) PRIMARY KEY,
//         Username nvarchar(255) NOT NULL,
//     )",
//     {},
//     { datasource= request.testDSN }
// )

// writeDump(
//     queryExecute(
//         "DECLARE @Inserted_ID_Table TABLE (ID int NOT NULL);
//         INSERT INTO MyTable ( Username )
//         OUTPUT INSERTED.ID INTO @Inserted_ID_Table
//         VALUES (
//             :username
//         );
//         SELECT ID FROM @Inserted_ID_Table",
//         { username : "foo_#createUUID()#" },
//         { datasource= request.testDSN }
//     )
// );
</cfscript>