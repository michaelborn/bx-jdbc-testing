<cfscript>
result = queryExecute( "DELETE FROM developers WHERE id = :id", {id: 77}, { datasource: request.testDSN });

writeDump(result.recordCount);
writeDump(result);
writeDump(serializeJSON( result ));
writeDump(result.$bx.meta);
variables.selection = queryExecute(
    "SELECT * FROM developers",
    [],
    { datasource: request.testDSN }
);

writeDump( var = variables.selection, label = "selection" );
</cfscript>