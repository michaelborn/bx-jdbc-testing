/**
 * Copyright Since 2005 Ortus Solutions, Corp
 * www.ortussolutions.com
 * *************************************************************************************
 */
component {

	this.name              = "bx-jdbc-testing TestBox Suite";
	this.sessionManagement = true;

	// Mappings
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings[ "/testbox" ] = expandPath( "../testbox" );

	public boolean function onRequestStart( String targetPage ){
		return true;
	}

}
