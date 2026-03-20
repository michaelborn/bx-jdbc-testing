/**
 * Copyright Since 2005 Ortus Solutions, Corp
 * www.ortussolutions.com
 * *************************************************************************************
 */
component {

	this.name              = "JDBC Test suite for Boxlang,ACF and Lucee";
	this.sessionManagement = true;

	// Mappings
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings[ "/testbox" ] = this.mappings[ "/tests" ] & "testbox";

	public boolean function onRequestStart( String targetPage ){
		return true;
	}

}
