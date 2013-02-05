<?xml 
    version="1.0" 
    encoding="utf-8"
    ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2"
    xmlns:cword="http://www.corbas.co.uk/ns/word"
    xmlns="http://docbook.org/ns/docbook"     
    xmlns:db="http://docbook.org/ns/docbook"     
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xpath-default-namespace="http://docbook.org/ns/docbook"
     exclude-result-prefixes="db xd cword xlink dcterms">
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>Convert the compound XML document to a Penguin variant XML file and
            insert the xml-model PI to ensure that we get Penguin XML that can be validated
            out of the end.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:output  indent="yes"/>
    
    <xsl:include href="../../xslt/identity.xsl"/>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Insert the xml-model PI at the root.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Take the only DocBook namespaced element that's a child
            of cword:word-doc and output only that.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="cword:word-doc">
        <xsl:apply-templates select="db:*"/>
    </xsl:template>


	<!-- strip out the conversion helper attributes -->
	<xsl:template match="@cword:*"/>

</xsl:stylesheet>
