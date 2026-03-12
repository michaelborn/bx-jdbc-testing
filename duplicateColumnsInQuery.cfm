<cfscript>
    result = queryExecute( "SELECT CURRENT_DATE AS name, name, id, role FROM developers", {}, { "datasource": request.testDSN } );
    writeDump(result);
</cfscript>