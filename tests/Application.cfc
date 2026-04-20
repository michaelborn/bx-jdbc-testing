/**
 * Copyright Since 2005 Ortus Solutions, Corp
 * www.ortussolutions.com
 * *************************************************************************************
 */
component {

	this.name              = "JDBC Test suite for Boxlang,ACF and Lucee";
	this.sessionManagement = true;

	// Mappings
	variables.rootPath = getDirectoryFromPath( getCurrentTemplatePath() ) & "../";
	this.mappings[ "/tests" ] = variables.rootPath & "tests/";
	this.mappings[ "/testbox" ] = this.mappings[ "/tests" ] & "testbox";
	this.mappings[ "/models" ] = variables.rootPath & "models";

	public boolean function onRequestStart( String targetPage ){
		return true;
	}

}
