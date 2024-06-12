#!/usr/bin/env bash

BOXLANG_REPO_HOME=~/repos/boxlang
BOXLANG_MODULE_INSTALL_DIR=~/.boxlang/modules

rm -rf bin lib

if [ ! -d "bin" ]; then
    # Setup the miniserver binaries
    cp $BOXLANG_REPO_HOME/boxlang-miniserver/build/distributions/boxlang-miniserver-1.0.0.zip .
    unzip boxlang-miniserver-1.0.0.zip
fi

# Copy/install any custom module builds to your .boxlang/modules directory
unzip -u -o $BOXLANG_REPO_HOME/modules/bx-compat/build/distributions/bx-compat-1.0.0.zip -d $BOXLANG_MODULE_INSTALL_DIR/bx-compat
unzip -u -o $BOXLANG_REPO_HOME/modules/bx-mssql/build/distributions/bx-mssql-1.0.0.zip -d $BOXLANG_MODULE_INSTALL_DIR/bx-mssql

./bin/boxlang-miniserver