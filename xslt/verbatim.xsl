<?xml version="1.0" encoding="UTF-8"?>

<!--
    XML to HTML Verbatim Formatter with Syntax Highlighting
    
    Version 2.0
   	Contributors: Nic Gibson
   	Copyright 2013 Corbas Consulting Ltd
	Contact: corbas@corbas.co.uk

   	Full rewrite of Oliver Becker's original code to modularise for reuseability 
   	and rewrite to XSLT 2.0. Code for handling the root element removed as the
   	purpose of the rewrite is to handle code snippets. Modularisation and extensive
   	uses of modes used to ensure that special purpose usages can be achieved
	through use of xsl:import.
   	
    
    Version 1.1
    Contributors: Doug Dicks, added auto-indent (parameter indent-elements)
                  for pretty-print

    Copyright 2002 Oliver Becker
    ob@obqo.de
 
    Licensed under the Apache License, Version 2.0 (the "License"); 
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
    Unless required by applicable law or agreed to in writing, software distributed
    under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
    CONDITIONS OF ANY KIND, either express or implied. See the License for the
    specific language governing permissions and limitations under the License.

    Alternatively, this software may be used under the terms of the 
    GNU Lesser General Public License (LGPL).
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:verb="http://informatik.hu-berlin.de/xmlverbatim"
	xmlns:cfn="http://www.corbas.co.uk/ns/xsl/functions" xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="verb xs cfn">

	<xsl:output method="html" omit-xml-declaration="yes" indent="no"/>

	<xsl:param name="indent-elements" select="false()"/>
	<xsl:param name="max-depth" select="10000"/>
	<xsl:param name="limit-text" select="true()"/>

	<xsl:variable name="tab" select="'&#x9;'"/>
	<xsl:variable name="tab-out" select="'&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;'"/>
	<xsl:variable name="nbsp" select="'&#xA0;'"/>
	<xsl:variable name="nl" select="'&#xA;'"/>

	<!-- element nodes -->
	<xsl:template match="*" mode="verbatim" >
		
		<xsl:param name="indent-elements" select="false()" />
		<xsl:param name="indent" select="''"/>
		<xsl:param name="indent-increment" select="'&#xA0;&#xA0;&#xA0;'"/>
		<xsl:param name="depth" select="$max-depth"/>
		
		<xsl:apply-templates select="." mode="verbatim-start"  >
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="indent-elements" select="$indent-elements"/>			
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="verbatim-content">
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="indent-elements" select="$indent-elements"/>			
			<xsl:with-param name="depth" select="$depth"/>
			<xsl:with-param name="indent-increment" select="$indent-increment"/>
		</xsl:apply-templates>
		
		<xsl:apply-templates select="." mode="verbatim-end">
			<xsl:with-param name="indent" select="$indent"/>
			<xsl:with-param name="indent-elements" select="$indent-elements"/>						
		</xsl:apply-templates>

		<xsl:if test="not(parent::*)">
			<br/>
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>

	</xsl:template>


	<xsl:template match="*" mode="verbatim-start">
		<xsl:param name="indent" select="''" />
		<xsl:param name="indent-elements" select="true()"/>
		
		<xsl:if test="$indent-elements">
			<br/>
			<xsl:value-of select="$indent"/>
		</xsl:if>
		
		<xsl:text>&lt;</xsl:text>
		<xsl:apply-templates select="." mode="verbatim-ns-prefix"/>
		<xsl:apply-templates select="." mode="verbatim-element-name"/>
		<xsl:apply-templates select="." mode="verbatim-ns-declarations"/>
		<xsl:apply-templates select="@*" mode="verbatim-attributes"/>
		
		<xsl:if test="node()">
			<xsl:text>&gt;</xsl:text>
		</xsl:if>
		
	</xsl:template>
	
	
	<xsl:template match="*[not(node())]" mode="verbatim-end">
		<xsl:text> /&gt;</xsl:text>
	</xsl:template>
	
	<xsl:template match="*[node()]" mode="verbatim-end">
		
		<xsl:param name="indent" select="''"/>
		<xsl:param name="indent-elements" select="true()"/>
		
		<xsl:if test="* and $indent-elements">
			<br/>
			<xsl:value-of select="$indent"/>
		</xsl:if>
		
		<xsl:text>&lt;/</xsl:text>
		<xsl:apply-templates select="." mode="verbatim-ns-prefix"/>
		<xsl:apply-templates select="." mode="verbatim-element-name"/>
		<xsl:text>&gt;</xsl:text>
		
	</xsl:template>

	<xsl:template match="*[not(cfn:namespace-prefix(.) = '')]" mode="verbatim-ns-prefix">
		<xsl:variable name="ns" select="cfn:namespace-prefix(.)"/>
		<span class="xmlverb-element-nsprefix"><xsl:value-of select="cfn:namespace-prefix(.)"/></span><xsl:text>:</xsl:text>		
	</xsl:template>
	
	<xsl:template match="*" mode="verbatim-ns-prefix"/>
	
	<xsl:template match="*" mode="verbatim-element-name">
		<span class="xmlverb-element-name">
			<xsl:apply-templates select="@xml:id|@id" mode="verbatim-id-copy"/>
			<xsl:value-of select="local-name()"/>
		</span>		
	</xsl:template>
	
	<xsl:template match="*" mode="verbatim-ns-declarations">
		<xsl:variable name="node" select="."/>
		<xsl:variable name="in-scope" select="cfn:newly-declared-namespaces(.)" as="xs:string*"/>
		<xsl:message>Declaring <xsl:value-of select="count($in-scope)"/> new namespaces</xsl:message>
		<xsl:for-each select="$in-scope">
			<xsl:message>Declaring: <xsl:value-of select="if (. = '') then '#DEFAULT' else ."/></xsl:message>
			<span class="xmlverb-ns-name">
				<xsl:value-of select="concat(' xmlns', if (. = '') then '' else ':', '=&quot;', namespace-uri-for-prefix(., $node), '&quot;')"/>
			</span>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template match="*[node()]" mode="verbatim-content">
		
		<xsl:param name="depth"/>
		<xsl:param name="indent"/>
		<xsl:param name="indent-increment"/>
		<xsl:param name="indent-elements"/>
		
		<xsl:choose>
			
			<xsl:when test="$depth gt 0">
				<xsl:apply-templates mode="verbatim">
					<xsl:with-param name="indent-elements" select="$indent-elements"/>
					<xsl:with-param name="indent"
						select="concat($indent, $indent-increment)"/>
					<xsl:with-param name="indent-increment" select="$indent-increment"/>
					<xsl:with-param name="depth" select="$depth - 1"/>
				</xsl:apply-templates>
				
			</xsl:when>
			
			
			<xsl:otherwise><xsl:text> … </xsl:text></xsl:otherwise>
			
		</xsl:choose>
		
		
	</xsl:template>
	
	<xsl:template match="*[not(node())]" mode="verbatim-content"/>
	
	<xsl:template match="@*" mode="verbatim-attributes">
		<xsl:text> </xsl:text>
		<span class="xmlverb-attr-name">
			<xsl:value-of select="name()"/>
		</span>
		<xsl:text>=&quot;</xsl:text>
		<span class="xmlverb-attr-content">
			<xsl:value-of select="cfn:html-replace-entities(normalize-space(.), true())"/>
		</span>
		<xsl:text>&quot;</xsl:text>
	</xsl:template>
	
	<xsl:template match="@*" mode="verbatim-id-copy">
		<xsl:attribute name="xml:id" select="."/>
	</xsl:template>

	<xsl:template match="text()" mode="verbatim">

		<span class="xmlverb-text">
			<xsl:call-template name="preformatted-output">
				<xsl:with-param name="text" select="if ($limit-text = true()) 
					then cfn:html-replace-entities(cfn:limit-text(.))
					else cfn:html-replace-entities(.)"/>
			</xsl:call-template>
		</span>

	</xsl:template>

	<xsl:template match="text()[contains(., $nl)]" mode="verbatim">
		<span class="xmlverb-text">
			<xsl:value-of select="cfn:html-replace-entities(cfn:limit-text(.))"/>
		</span>
	</xsl:template>

	<!-- comments -->
	<xsl:template match="comment()" mode="verbatim">
		<xsl:text>&lt;!--</xsl:text>
		<span class="xmlverb-comment">
			<xsl:call-template name="preformatted-output">
				<xsl:with-param name="text" select="."/>
			</xsl:call-template>
		</span>
		<xsl:text>--&gt;</xsl:text>
		<xsl:if test="not(parent::*)">
			<br/>
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- processing instructions -->
	<xsl:template match="processing-instruction()" mode="verbatim">
		<xsl:text>&lt;?</xsl:text>
		<span class="xmlverb-pi-name">
			<xsl:value-of select="name()"/>
		</span>
		<xsl:if test=".!=''">
			<xsl:text> </xsl:text>
			<span class="xmlverb-pi-content">
				<xsl:value-of select="."/>
			</span>
		</xsl:if>
		<xsl:text>?&gt;</xsl:text>
		<xsl:if test="not(parent::*)">
			<br/>
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>
	</xsl:template>


	<!-- =========================================================== -->
	<!--                    Procedures / Functions                   -->
	<!-- =========================================================== -->





	<!-- preformatted output: space as &nbsp;, tab as 8 &nbsp;
                             nl as <br> -->
	<xsl:template name="preformatted-output">
		<xsl:param name="text"/>
		<xsl:call-template name="output-nl">
			<xsl:with-param name="text" select="replace(replace($text, $tab, $tab-out), ' ', $nbsp)"
			/>
		</xsl:call-template>
	</xsl:template>

	<!-- output nl as <br> -->
	<xsl:template name="output-nl">
		<xsl:param name="text"/>
		<xsl:variable name="tokens" select="tokenize($text, '&#xA;')"/>
		<xsl:choose>
			<xsl:when test="count($tokens) = 1">
				<xsl:value-of select="$tokens"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="$tokens">
					<br/>
					<xsl:value-of select="."/>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!-- restrict text where we have more than 50 words to first five,
   ellipsis and last five -->
	<xsl:function name="cfn:limit-text">
		<xsl:param name="text"/>
		<xsl:variable name="words" select="tokenize($text, '\s+')" as="xs:string*"/>
		<xsl:variable name="nwords" select="count($words)" as="xs:integer"/>
		<xsl:value-of
			select="if ($nwords lt 50) 
   			then $words else 
   			string-join((
   				for $n in 1 to 5 return $words[$n], 
   				' … ', 
   				for $n in $nwords - 5 to $nwords return $words[$n]), 
   				' ')"
		/>
	</xsl:function>

	<xsl:function name="cfn:html-replace-entities">
		<xsl:param name="value"/>
		<xsl:param name="with-attrs"/>
		<xsl:variable name="tmp"
			select="
			replace(replace(replace($value, '&amp;', '&amp;amp;'),'&lt;', '&amp;lt;'),'&gt;', '&amp;gt;')"/>
		<xsl:value-of
			select="if ($with-attrs) then replace(replace($tmp, '&quot;', '&amp;quot;'), '&#xA;', '&amp;#xA;') else $tmp"
		/>
	</xsl:function>

	<xsl:function name="cfn:html-replace-entities">
		<xsl:param name="value"/>
		<xsl:value-of select="cfn:html-replace-entities($value, false())"/>
	</xsl:function>

	<doc:documentation xmlns:doc="http://www.corbas.co.uk/ns/documentation"
		xmlns="http://www.w3.org/1999">
		<p>Return the namespace prefix for a node if known.</p>
	</doc:documentation>
	<xsl:function name="cfn:namespace-prefix" as="xs:string">

		<xsl:param name="node" as="element()"/>
		<xsl:variable name="uri" select="namespace-uri($node)"/>
		<xsl:variable name="prefixes" select="in-scope-prefixes($node)"/>
		<xsl:variable name="prefix"
			select="for $ns in $prefixes return if (namespace-uri-for-prefix($ns, $node) = $uri) then ($ns) else ()"/>
		<xsl:value-of select="$prefix"/>

	</xsl:function>

	<doc:documentation xmlns:doc="http://www.corbas.co.uk/ns/documentation"
		xmlns="http://www.w3.org/1999/xhtml">
		<p>Return a sequence of namespace prefixes which were not declared on the parent
			element.</p>
	</doc:documentation>
	<xsl:function name="cfn:newly-declared-namespaces" as="xs:string*">
		<xsl:param name="node" as="element()"/>
		
		<xsl:variable name="our-namespaces" select="in-scope-prefixes($node)"/>
		<xsl:message>Our Namespaces = (<xsl:value-of select="string-join(for $x in $our-namespaces return if ($x = '') then '#DEFAULT' else $x, ' | ')"/>)</xsl:message>
		<xsl:variable name="ignore-namespaces" select="('xml')"/>
		<xsl:variable name="parent-namespaces" select="if ($node/parent::*) then in-scope-prefixes($node/parent::*) else ()"/>
		<xsl:message>Parent Namespaces = (<xsl:value-of select="string-join(for $x in $parent-namespaces return if ($x = '') then '#DEFAULT' else $x, ' | ')"/>)</xsl:message>
		<xsl:variable name="new-namespaces" select="distinct-values($our-namespaces[not(. = $parent-namespaces)][not(. = $ignore-namespaces)])"/>
		<xsl:message>New Namespaces = (<xsl:value-of select="string-join(for $x in $new-namespaces return if ($x = '') then '#DEFAULT' else $x, ' | ')"/>)</xsl:message>
		<xsl:message>Number of new namespaces is: <xsl:value-of select="count($new-namespaces)"/></xsl:message>
		<xsl:value-of select="$new-namespaces"/>
	</xsl:function>

	<doc:documentation xmlns:doc="http://www.corbas.co.uk/ns/documentation"
		xmlns="http://www.w3.org/1999">
		<p>Return true() if a node is in the default namespace. Checks by ensuring that the element
			is in a namespace and then checking if the namespace prefix is blank.</p>
	</doc:documentation>
	<xsl:function name="cfn:in-default-ns" as="xs:boolean">
		<xsl:param name="node" as="element()"/>
		<xsl:variable name="prefix" select="cfn:namespace-prefix($node)"/>
		<xsl:value-of select="if (namespace-uri($node) and $prefix = '') then true() else false()"/>
	</xsl:function>

</xsl:stylesheet>
