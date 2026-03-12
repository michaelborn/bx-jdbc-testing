# JDBC Testing Repository

## Purpose

This repository contains tests for comparing JDBC functionality across three CFML engines:
- **Adobe ColdFusion** (2021+)
- **Lucee Server** (5.x)
- **BoxLang**

The tests identify behavioral differences and ensure compatibility across engines.

## Docker Setup

Spin up test databases with docker-compose:
```bash
docker-compose up --build -d
```

Services:
- **MariaDB** (port 3360)
- **MySQL 5** (port 3630)
- **PostgreSQL 11** (port 5432)
- **MSSQL 2019** (port 1433)

Environment variables in `.env` control connection details for each database.

## Running Tests

### CommandBox Server Setup

Each engine has its own `server-*.json` config:
- `server-boxlang.json` - BoxLang with bx-derby, bx-mysql, bx-mssql, bx-oracle, bx-postgres modules
- `server-adobe2021.json` - Adobe ColdFusion 2021 with derby, sqlserver, administrator extensions
- `server-lucee5.json` - Lucee 5

Start a server:
```bash
# For BoxLang
./bin/boxlang-miniserver

# Or via CommandBox
server start server-boxlang.json
```

## Test Categories

### 1. Regular JDBC Tests
- Basic query execution with `queryExecute()`
- Named and positional parameters (`:param` and `?`)
- SQL type specification (`cfsqltype`/`sqltype` attributes)
- Array parameters for batch inserts

Files: `index.bxs`, `connTest.bxs`, `Application.cfc`

### 2. Transaction Tests
- Transaction management with `transaction` block
- Rollback behavior
- Nested transaction support

Files: `transactions.bxs`, `nestedTransactions.cfm`

### 3. JDBC Caching Tests
- Query caching with `cacheTimeout`
- Cache timeout verification
- Cache key management

Files: `caching/modern.bxs`, `caching/compat.cfm`

### 4. ORM Tests
- (To be added)

### 5. Edge Cases
- NULL handling (`nullTest.bxs`)
- Duplicate columns in query results (`duplicateColumnsInQuery.cfm`)
- Delete query behavior (`deleteQuery.cfm`)
- Multi-statement result sets for MSSQL (`mssqlMultiStatementResultSet.cfm`)
- Timezone handling (`timezone.cfm`)

### 6. Debugging Utilities
- `jdbcDebugging.bxm` - Lists configured datasources
- `debug.bxs` - General debugging helpers

## TestBox Integration

Tests will be organized into TestBox specs (BDD/Unit). Run tests via:
```bash
# From testbox directory
testbox run
```

Or via the web runner at `/testbox/runner.cfm` when server is running.
