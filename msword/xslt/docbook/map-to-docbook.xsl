<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cword="http://www.corbas.co.uk/ns/word"
    xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
    xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
    xmlns:rp="http://schemas.openxmlformats.org/package/2006/relationships"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
    xmlns="http://docbook.org/ns/docbook"
    xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xs w cp r rp dc a">


	<!--
		
		This program and accompanying files are copyright 2008, 2009, 20011, 2012, 2013 Corbas Consulting Ltd.
		
		This program is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version.
		
		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.
		
		You should have received a copy of the GNU General Public License
		along with this program.  If not, see http://www.gnu.org/licenses/.
		
		If your organisation or company are a customer or client of Corbas Consulting Ltd you may
		be able to use and/or distribute this software under a different license. If you are
		not aware of any such agreement and wish to agree other license terms you must
		contact Corbas Consulting Ltd by email at corbas@corbas.co.uk. 
		
	-->
	
	<xsl:import href="../../xslt/identity.xsl"/>
	<xsl:import href="map-tables-to-docbook.xsl"/>

    <xsl:output encoding="UTF-8" indent="yes"/>

	<!-- override to change the assumed dir for images -->
    <xsl:param name="image-uri-base" select="'images'"/>
    
	<!-- set to 'yes' to output the core properties from word into DocBook -->
	<xsl:param name="transcribe.core.properties" select="'yes'"/>

    <xsl:strip-space elements="*"/>
    <xsl:preserve-space elements="w:t"/>

    <xd:doc xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jan 28, 2010</xd:p>
            <xd:p><xd:b>Author:</xd:b> nicg</xd:p>
            <xd:p>Default templates for major word components such as document and paragraph.</xd:p>
            <xd:p>
                <xd:b>Update 2010-03-19</xd:b>
            </xd:p>
            <xd:p>Added support for images contained within w:drawing elements. Currently, only
                handles images referenced via the <xd:b>blip</xd:b> element. We render these as
                DocBook imageobject elements within a section (the next stage processing may move
                this).</xd:p>
        </xd:desc>
    </xd:doc>
    
    

    <!-- word body can be skipped -->
    <xsl:template match="w:body">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- Section, para and run properties must be dropped -->
    <xsl:template match="w:sectPr|w:p/w:pPr|w:r/w:rPr"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Matches the document, processing titles and all para, table and graphical
                content.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="w:document">

    	<book version="5.0" xmlns="http://docbook.org/ns/docbook" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:m="http://www.w3.org/1998/Math/MathML">
            <info>
            	<!-- not worth phrasing the following with predicates -->
                <xsl:if test="$transcribe.core.properties = 'yes'">
                	<xsl:apply-templates select="//cp:coreProperties/*"/>
                </xsl:if>
            </info>
            <xsl:apply-templates/>
        </book>
    </xsl:template>


    <xd:doc>
        <xd:desc>
            <xd:p>Matches paragraphs. Ignores empty paragraphs and fetches any style data to copy
                into the role attribute of the element.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="w:p[not(normalize-space(.) = '')]">
        <xsl:apply-templates select="." mode="basic"/>
    </xsl:template>

    <xsl:template match="w:p[normalize-space(.) = '']" priority="2"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Default processing for paragraphs. Created with a mode so it can be called from
                other paragraph handling templates.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="w:p" mode="basic">
        <para>
            <xsl:call-template name="cword:getStyleAsRole">
                <xsl:with-param name="properties" select="w:pPr"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </para>
    </xsl:template>


    <xd:doc>
        <xd:desc>
            <xd:p>Matches paras with a single run that contains an images - block images.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="w:p[count(w:r) = 1]/w:r[descendant::w:drawing]" priority="3">
        <xsl:apply-templates select="descendant::w:drawing" mode="block"/>
    </xsl:template>


    <xd:doc>
        <xd:desc>Process paragraphs which represent list items. Right now we just convert them to
            listitem elements and store information in the role about the sort of list and indent
            level.</xd:desc>
    </xd:doc>
    <xsl:template match="w:p[w:pPr/w:numPr[w:numId and w:ilvl]]" priority="1">
        <listitem cword:list-level="{w:pPr/w:numPr/w:ilvl/@w:val}"
            cword:list-mark="{w:pPr/w:numPr/w:numId/@w:val}">
            <xsl:apply-templates select="." mode="basic"/>
        </listitem>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Template to ignore paragraphs with no runs and just section or page breaks</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="w:p[not(w:tbl|w:r|w:hlink) and w:pPr/w:sectPr]"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Ignore paragraphs that contain just a single run and that run just contains a
                break. </xd:p>
        </xd:desc>
    </xd:doc>
    
   
    <xsl:template match="w:p[count(w:r) = 1][w:r/w:br][not(w:r/w:t)]"/>
    
    
    <xd:doc>
        <xd:desc>
            <xd:p>Ignore paragraphs containing just a singe run which contains only a tab.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="w:p[count(w:r) = 1][w:r/w:tab][not(w:r/w:t)]"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Default processing for runs - execute and supply mode base. This is intended to
                allow additional modes as required.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="w:r">
        <xsl:apply-templates select="." mode="base"/>
    </xsl:template>
    
     

    <xd:doc>
        <xd:desc>
            <xd:p>Primary processing for runs of text. If the run has any styling we generated a
                phrase element so that we can capture the character style name.</xd:p>
        </xd:desc>
    </xd:doc>

	<xsl:template match="w:r[w:rPr/w:rStyle|w:rPr/w:b|w:rPr/w:i|w:rPr/w:vertAlign]" mode="base">
		<xsl:variable name="style" select="if (cword:getStyle(w:rPr)) then concat(cword:getStyle(w:rPr), ' ') else ''"/>
		<xsl:variable name="bold" select="if (cword:isBold(.)) then 'bold ' else ''"/>
		<xsl:variable name="italic" select="if (cword:isItalic(.)) then 'italic ' else ''"/>
		
		<xsl:variable name="role" select="normalize-space(concat($style, $bold, $italic))"/>
		
		<xsl:choose>
			<xsl:when test="cword:isSuperscript(.)">
				<xsl:choose>
					<xsl:when test="$role">
						<phrase role="{$role}"><superscript><xsl:apply-templates/></superscript></phrase>
					</xsl:when>
					<xsl:otherwise>
						<superscript><xsl:apply-templates/></superscript>
					</xsl:otherwise>						
				</xsl:choose>
			</xsl:when>
			<xsl:when test="cword:isSubscript(.)">
				<xsl:choose>
					<xsl:when test="$role">
						<phrase role="{$role}"><subscript><xsl:apply-templates/></subscript></phrase>
					</xsl:when>
					<xsl:otherwise>
						<subscript><xsl:apply-templates/></subscript>
					</xsl:otherwise>						
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<phrase role="{$role}"><xsl:apply-templates/></phrase>
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	
	<xsl:template match="w:r" mode="base">
		<xsl:apply-templates/>
	</xsl:template>

    
    <xd:doc>
        <xd:desc>
            <xd:p>Override for hyperlink runs. We already did something sensible with them.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="w:r[w:rPr/w:rStyle[@w:val='Hyperlink']][not(w:t)]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="w:r[w:rPr/w:rStyle[@w:val='CommentReference']][not(w:t)]">
        <xsl:apply-templates/>
    </xsl:template>
	
	
	<xd:doc>
		<xd:desc>
			<xd:p>Process a run of text that contains an image as an inline (block images handled earlier)</xd:p>
		</xd:desc>
	</xd:doc>
	
	<xsl:template match="w:r[descendant::w:drawing]">
		<xsl:apply-templates select="descendant::w:drawing"/>
	</xsl:template>
	

    <xd:doc>
        <xd:desc>
            <xd:p>Process runs of text with foot note references into docbook footnotes.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <!-- don't output the run in which an endnote occurs, skip to the note -->
    <xsl:template match="w:r[w:endnoteReference]"  priority="1">
        <xsl:apply-templates select="w:endnoteReference"/>
    </xsl:template>
    
    <!-- don't output the run in which an footnote occurs, skip to the note -->
    <xsl:template match="w:r[w:footnoteReference]" priority="1">
        <xsl:apply-templates select="w:footnoteReference"/>
    </xsl:template>

    <!-- replace endnote reference with referenced note -->
    <xsl:template match="w:endnoteReference">
        <xsl:apply-templates select="//w:endnotes/w:endnote[@w:id = current()/@w:id]"/>
    </xsl:template>
    
    <!-- replace footnote reference with referenced note -->
    <xsl:template match="w:footnoteReference">
        <xsl:apply-templates select="//w:footnotes/w:footnote[@w:id = current()/@w:id]"/>
    </xsl:template>

    <!-- process any endnotes which aren't separators -->
    <xsl:template match="w:endnote[descendant::w:r[not(w:continuationSeparator)]]" priority="1">
        <footnote role="endnote" xml:id="{generate-id()}">
            <xsl:apply-templates/>
        </footnote>
    </xsl:template>
    
    <!-- process any footnotes which aren't separators -->
    <xsl:template match="w:footnote[descendant::w:r[not(w:continuationSeparator)]]" priority="1">
        <footnote xml:id="{generate-id()}">
            <xsl:apply-templates/>
        </footnote>
    </xsl:template>

    <!-- suppress empty notes -->
    <xsl:template match="w:endnote[normalize-space(.) = '']"/>
    <xsl:template match="w:footnote[normalize-space(.) = '']"/>
    
    <!-- suppress the footnote or endnote ref *inside* the note -->
    <xsl:template match="w:footnote/descendant::w:r[w:footnoteRef]"/>
    <xsl:template match="w:endnote/descendant::w:r[w:endnoteRef]"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Process text elements by outputting them as long as they aren't empty text.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="w:t">
        <xsl:apply-templates/>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Handle <xd:b>w:drawing</xd:b> elements. We only handle those with a:blip children.
            	Convert them to a DocBook imageobject
                element. The fileRef attribute is filled with the relation ID. Later processing can
                replace that with the actual URL from document.rels.xml</xd:p>
    
        </xd:desc>
    </xd:doc>
	
	<xsl:template match="w:drawing">
		<xsl:message terminate="yes">Encountered a w:drawing with no descendant a:blip</xsl:message>
	</xsl:template>
	
	<xsl:template match="w:drawing[descendant::a:blip]">
		<xsl:apply-templates select="descendant::a:blip"/>
	</xsl:template>
	
    <xsl:template match="a:blip" mode="block">
        <mediaobject xml:id="{generate-id()}">
            <imageobject>
                <xsl:apply-templates select="@r:link|@r:embed"/>
            </imageobject>
        </mediaobject>
    </xsl:template>
	
	<xsl:template match="a:blip">
		<inlinemediaobject xml:id="{generate-id()}">
			<imageobject>
				<xsl:apply-templates select="@r:link|@r:embed"/>
			</imageobject>
		</inlinemediaobject>
	</xsl:template>

    <xsl:template match="a:blip/@r:embed|a:blip/@r:link">
        <!-- generate a docbook imdagedata element based on this. -->
        <xsl:variable name="id" select="."/>
    	
    	<xsl:variable name="relindex" select="if (ancestor::w:footnote) then 2 else if (ancestor::w:endnote) then 3 else 1"/>
    	<xsl:variable name="rels" select="//rp:Relationships[$relindex]"/>

        <imagedata>
            <xsl:variable name="doc-image-uri" select="$rels/rp:Relationship[@Id = $id]/@Target"/>
            <xsl:analyze-string select="$doc-image-uri" regex=".+/([^/]+)$/">
                <xsl:matching-substring>
                    <xsl:attribute name="fileref"
                        select="concat($image-uri-base, '/', regex-group(1))"/>
                </xsl:matching-substring>
                <xsl:non-matching-substring>
                    <xsl:attribute name="fileref" select="$doc-image-uri"/>
                </xsl:non-matching-substring>
            </xsl:analyze-string>
        </imagedata>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Handle comment references by processing the referenced comment
            and including it as an XML comment in the same location.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="w:r[descendant::w:commentReference]" priority="1">
        <xsl:apply-templates select="descendant::w:commentReference"/>
    </xsl:template>
    
    <xsl:template match="w:commentReference">
        <xsl:variable name="comment-id" select='@w:id'/>
        <xsl:apply-templates select="//w:comments/w:comment[@w:id = $comment-id]"/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Convert a word comment to an XML comment. Output the name
            of the user who made the comment too.</xd:p>
        </xd:desc>
    </xd:doc>
    
    <xsl:template match="w:comment">
        <remark>
            <xsl:apply-templates select="@w:author"/>: <xsl:apply-templates/>
        </remark>
    </xsl:template>
    
    <xsl:template match="@w:author">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="w:comment/*" priority="1">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xd:doc>
        <xd:desc>
            <xd:p>Converts the style given in an elements properties to a role attribute containing
                the style's value.</xd:p>
            <xd:p>Currently handles run and paragraph styles.</xd:p>
            <xd:p>Suppresses some known irrelevant styles.</xd:p>
        </xd:desc>
        <xd:param name="properties">
            <xd:p>The properties parameter must be provided and must contain the properties element
                of the document being processed</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template name="cword:getStyleAsRole">
        <xsl:param name="properties"/>
    	<xsl:attribute name="role" select="cword:getStyle($properties)"/>
    </xsl:template>
	
	<xsl:function name="cword:getStyle" as="xs:string">

		<xsl:param name="properties"/>
		<xsl:variable name="style" select="($properties/w:rStyle/@w:val, $properties/w:pStyle/@w:val)[1]"/>
		<xsl:value-of select="if ($style = ('attributes', 'CommentReference', 'FootnoteText', 'EndnoteText')) then '' else $style"/>
		
	</xsl:function>
	

	<xsl:function name="cword:isBold" as="xs:boolean">
		
		<xsl:param name="run"/>
		<xsl:value-of select="if ($run/w:rPr/w:b) then true() else false()"/>
		
	</xsl:function>

	<xsl:function name="cword:isItalic" as="xs:boolean">
		
		<xsl:param name="run"/>
		<xsl:value-of select="if ($run/w:rPr/w:i) then true() else false()"/>
		
	</xsl:function>
	
	<xsl:function name="cword:isSuperscript" as="xs:boolean">
		
		<xsl:param name="run"/>
		<xsl:value-of select="if ($run/w:rPr/w:vertAlign[@w:val = 'superscript']) then true() else false()"/>
		
	</xsl:function>
	
	<xsl:function name="cword:isSubscript" as="xs:boolean">
		
		<xsl:param name="run"/>
		<xsl:value-of select="if ($run/w:rPr/w:vertAlign[@w:val = 'subscript']) then true() else false()"/>
		
	</xsl:function>
	
	
	
    <xd:doc>
        <xd:desc>
            <xd:p>Skip core properties</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="cp:coreProperties"/>

    <xd:doc>
        <xd:desc>
            <xd:p>Copy children of core properties unless specified.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="cp:coreProperties/*">
        <bibliomisc role="{name()}">
            <xsl:apply-templates/>
        </bibliomisc>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Returns the document title from properties.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="cp:coreProperties/dc:title" priority="1">
        <title>
            <xsl:apply-templates/>
        </title>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Convert dcterms:created and modified into date metadata</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="cp:coreProperties/dcterms:created|cp:coreProperties/dcterms:modified"
        priority="1">
        <date role="{name()}">
            <xsl:apply-templates/>
        </date>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Convert the word revision number</xd:p>
        </xd:desc>
    </xd:doc>


    <xd:doc>
        <xd:desc>
            <xd:p>Handle word bookmarks by converting them to either anchors (when empty) or phrases
                (when not)</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="w:bookmarkStart[following-sibling::node()[1][self::w:bookmarkEnd]]">
        <anchor xml:id="{@w:name}"/>
    </xsl:template>

    <xsl:template match="w:bookmarkStart[not(following-sibling::node()[1][self::w:bookmarkEnd])]">
        <xsl:variable name="end-marker" select="(following-sibling::*[self::bookmarkEnd])[1]"/>
        <phrase xml:id="{@w:name}">
            <xsl:apply-templates select="following-sibling::*[ . &lt;&lt; $end-marker]"/>
        </phrase>
    </xsl:template>

    <xsl:template match="w:bookmarkEnd"/>


    <!-- Handle hyperlinks -->
<!--    <xsl:template match="w:r[descendant::w:rStyle[@w:val='Hyperlink']]">
        <xsl:apply-templates select="descendant::w:hyperlink"/>
    </xsl:template>-->
    
    <xsl:template match="w:hyperlink[@w:anchor]">
        <link linkend="{@w:anchor}"><xsl:apply-templates/></link>
    </xsl:template>
    
    <xsl:template match="w:hyperlink[@r:id]">
    	<xsl:variable name="relindex" select="if (ancestor::w:footnote) then 2 else if (ancestor::w:endnote) then 3 else 1"/>
    	<xsl:variable name="rels" select="//rp:Relationships[$relindex]"/>
        <xsl:variable name="id" select="@r:id"/>
        <link xlink:href="{$rels/rp:Relationship[@Id = $id]/@Target}"><xsl:apply-templates/></link>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>Suppress the following:</xd:p>
        </xd:desc>
    </xd:doc>

    <xsl:template match="w:br"/>
    <xsl:template match="w:lastRenderedPageBreak"/>
	
	<xsl:template match="w:instrText"/>
	<xsl:template match="w:fldChar"/>

    <xsl:template match="w:annotationRef"/>
	<xsl:template match="w:proofErr"/>
	<xsl:template match="w:softHyphen">
		<xsl:comment>SOFT HYPHEN</xsl:comment>
	</xsl:template>
	
	<!-- crappy  handling for objects right now -->
	<xsl:template match="w:object">
		<phrase>OBJECT INSERTION</phrase>
	</xsl:template>

	<!-- convert a tab to a space -->
	<xsl:template match="w:tab">
		<xsl:text>&#32;</xsl:text>
	</xsl:template>
	
	<!-- insert an emphasis with a role of break for crs and breaks  -->
	<xsl:template match="w:cr|w:br[not(@w:type)]">
		<phrase role="break"/>
	</xsl:template>
	
	
	
	
    
</xsl:stylesheet>
