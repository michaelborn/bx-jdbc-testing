#!/usr/bin/env bash

BOXLANG_REPO_HOME=~/repos/boxlang
BOXLANG_MODULE_INSTALL_DIR=~/.boxlang/modules

MINISERVER_VERSION=1.0.0-snapshot

rm -rf bin lib

if [ ! -d "bin" ]; then
    # Setup the miniserver binaries
    cp $BOXLANG_REPO_HOME/boxlang-miniserver/build/distributions/boxlang-miniserver-$MINISERVER_VERSION.zip .
    unzip boxlang-miniserver-$MINISERVER_VERSION.zip
fi

# Copy/install any custom module builds to your .boxlang/modules directory
mkdir -p $BOXLANG_MODULE_INSTALL_DIR
unzip -u -o $BOXLANG_REPO_HOME/modules/bx-mysql/build/distributions/bx-mysql-1.0.0.zip -d $BOXLANG_MODULE_INSTALL_DIR/bx-mysql
unzip -u -o $BOXLANG_REPO_HOME/modules/bx-mssql/build/distributions/bx-mssql-1.0.0.zip -d $BOXLANG_MODULE_INSTALL_DIR/bx-mssql
unzip -u -o $BOXLANG_REPO_HOME/modules/bx-compat/build/distributions/bx-compat-1.1.0.zip -d $BOXLANG_MODULE_INSTALL_DIR/bx-compat

./bin/boxlang-miniserver --debug