<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	version="2.0">
	
	<xsl:import href="../../../xslt/verbatim.xsl"/>

	<xsl:param name="indent-elements" select="true()"/>
	
	<xsl:template match="/">
		<html>
			<head>
				<title>Verbatim Test</title>
				<style type="text/css">
					.xmlverb-default          { color: #333333; background-color: #ffffff;
					font-family: monospace }
					.xmlverb-element-name     { color: #990000 }
					.xmlverb-element-nsprefix { color: #666600 }
					.xmlverb-attr-name        { color: #660000 }
					.xmlverb-attr-content     { color: #000099; font-weight: bold }
					.xmlverb-ns-name          { color: #666600 }
					.xmlverb-ns-uri           { color: #330099 }
					.xmlverb-text             { color: #000000; font-weight: bold }
					.xmlverb-comment          { color: #006600; font-style: italic }
					.xmlverb-pi-name          { color: #006600; font-style: italic }
					.xmlverb-pi-content       { color: #006666; font-style: italic }
					
					body
					{
					font-family: Helvetica, Arial, sans-serif;
					font-size:  medium;
					}
					
					
					
					div.error
					{
					border-top-style: solid;
					border-top-width: 1px;
					border-top-color: black;
					margin-top: 2em;
					padding-top: 1em;
					}
					
					div.element
					{
					padding: 2em;
					border: 1px dotted silver;
					}
					
					div.assert, div.report
					{
					margin-top: 4em;
					padding: 2em;
					border: 1px solid silver;
					}
					
					table
					{
					margin-bottom: 1.5em;
					}
					
					th
					{
					text-align: left;
					}
					
					div.warning h3
					{
					color: #fff000;
					}
					
					div.error h3
					{
					color: red;
					}
					
					
					
				</style>
				
			</head>
			<body><pre>
				<xsl:apply-templates select="." mode="verbatim"/></pre>
			</body>
		</html>
	</xsl:template>
	
</xsl:stylesheet>