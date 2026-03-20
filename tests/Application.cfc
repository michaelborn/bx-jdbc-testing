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
	// debugging boxlang /testbox file inclusion error madness
	// writeDump( this.mappings );
	// writeDump( expandPath( "/testbox" ) );
	// writeDump( fileRead( expandPath( "/testbox/system/runners/HTMLRunner.cfm" ) ) );
	//abort;

	// public boolean function onRequestStart( String targetPage ){
	// 	return true;
	// }

}
