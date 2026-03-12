<cfscript>
    // what happens when you have a rollback as the very first statement in a transaction???
    transaction{
        transactionRollback();
    }
    // what about nested transactions?
    transaction{
        variables.structparams = queryExecute(
            "INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
            { id : { value : 77, sqltype : "integer" }, name : "Michael Born", role : "Developer" },
            { "datasource": request.testDSN }
        );
        transaction{
            transactionRollback();
        }
    }

    // what about changing the isolation in a nested transaction?
    transaction isolation="repeatable_read"{
        variables.structparams = queryExecute(
            "INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
            { id : { value : 77, sqltype : "integer" }, name : "Michael Born", role : "Developer" },
            { "datasource": request.testDSN }
        );
        transaction isolation="read_committed"{
            variables.structparams = queryExecute(
                "INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
                { id : { value : 88, sqltype : "integer" }, name : "Willie Nelson", role : "Quality Assurance" },
                { "datasource": request.testDSN }
            );
        }
    }
    
    writeDump(
        queryExecute(
            "SELECT * FROM developers",
            [],
            { datasource: request.testDSN }
        )
    );
</cfscript>

## Nested Transaction Behavior:

In Lucee, nested transactions are not supported. When you nest a transaction within another transaction, the inner transaction is ignored and statements execute on the parent transaction.

For example:

```
transaction{
    variables.structparams = queryExecute(
        "INSERT INTO developers ( id, name, role ) VALUES ( :id, :name, :role )",
        { id : { value : 77, sqltype : "integer" }, name : "Michael Born", role : "Developer" },
        { "datasource": request.testDSN }
    );
    transaction{
        transactionRollback();
    }
}
```

In Lucee, the `transactionRollback()` in the child transaction block will roll back the entire (parent) transaction. This is not correct behavior.

## Rollback Behavior:

Lucee doesn't care if you have a `transactionRollback()` as the very first statement in a transaction. i.e. this will NOT throw an error:

```
transaction{
    transactionRollback();
}
```