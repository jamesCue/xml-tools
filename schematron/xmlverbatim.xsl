<?xml version="1.0" encoding="UTF-8"?>

<!--
    XML to HTML Verbatim Formatter with Syntax Highlighting
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

	<xsl:variable name="tab" select="'&#x9;'"/>
	<xsl:variable name="tab-out" select="'&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;&#xA0;'"/>
	<xsl:variable name="nbsp" select="'&#xA0;'"/>
	<xsl:variable name="nl" select="'&#xA;'"/>

	<xsl:template match="/">
		<xsl:apply-templates select="." mode="xmlverb">
			<xsl:with-param name="force-ns" select="true()"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- root -->
	<xsl:template match="/" mode="xmlverb">

		<xsl:param name="force-ns" select="false()"/>

		<xsl:text>&#xA;</xsl:text>
		<xsl:comment>
         <xsl:text> converted by xmlverbatim.xsl 1.1, (c) O. Becker </xsl:text>
      </xsl:comment>
		<xsl:text>&#xA;</xsl:text>
		<div class="xmlverb-default">
			<xsl:apply-templates mode="xmlverb">
				<xsl:with-param name="force-ns" select="$force-ns"/>
				<xsl:with-param name="indent-elements" select="$indent-elements"/>
			</xsl:apply-templates>
		</div>
		<xsl:text>&#xA;</xsl:text>
	</xsl:template>

	<!-- wrapper -->
	<xsl:template match="verb:wrapper">
		<xsl:apply-templates mode="xmlverb">
			<xsl:with-param name="indent-elements" select="$indent-elements"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="verb:wrapper" mode="xmlverb">
		<xsl:apply-templates mode="xmlverb">
			<xsl:with-param name="indent-elements" select="$indent-elements"/>
		</xsl:apply-templates>
	</xsl:template>


	<!-- element nodes -->


	<xsl:template match="*" mode="verbatim" as="xs:string">
		<xsl:param name="force-ns" select="false()"/>
		<xsl:variable name="indent-elements" select="false()" as="xs:boolean"/>
		<xsl:param name="indent" select="''"/>
		<xsl:param name="indent-increment" select="'&#xA0;&#xA0;&#xA0;'"/>

	</xsl:template>


	<xsl:template match="*" mode="xmlverb">
		<xsl:param name="force-ns" select="false()"/>
		<xsl:param name="indent-elements" select="false()"/>
		<xsl:param name="indent" select="''"/>
		<xsl:param name="indent-increment" select="'&#xA0;&#xA0;&#xA0;'"/>
		<xsl:param name="depth" select="3"/>
		<xsl:variable name="prefix" select="cfn:namespace-prefix(.)"/>

		<xsl:if test="$indent-elements">
			<br/>
			<xsl:value-of select="$indent"/>
		</xsl:if>

		<xsl:text>&lt;</xsl:text>
		<xsl:apply-templates select="." mode="ns-prefix"/>
		<xsl:apply-templates select="." mode="element-name"/>
		<xsl:apply-templates select="." mode="ns-declarations"/>	
		
		<xsl:variable name="pns" select="../namespace::*"/>
		<xsl:if test="$pns[name()=''] and not(namespace::*[name()=''])">
			<span class="xmlverb-ns-name">
				<xsl:text> xmlns</xsl:text>
			</span>
			<xsl:text>=&quot;&quot;</xsl:text>
		</xsl:if>
		<xsl:for-each select="namespace::*">
			<xsl:if test="not($pns[name()=name(current()) and 
                  .=current()])">
				<xsl:call-template name="xmlverb-ns"/>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="@*">
			<xsl:call-template name="xmlverb-attrs"/>
		</xsl:for-each>
		<xsl:choose>
			<xsl:when test="node()">
				<xsl:text>&gt;</xsl:text>
				<xsl:choose>

					<xsl:when test="count(descendant::*) gt 10"> … </xsl:when>

					<xsl:when test="$depth gt 0">
						<xsl:apply-templates mode="xmlverb">
							<xsl:with-param name="indent-elements" select="$indent-elements"/>
							<xsl:with-param name="indent"
								select="concat($indent, $indent-increment)"/>
							<xsl:with-param name="indent-increment" select="$indent-increment"/>
							<xsl:with-param name="depth" select="$depth - 1"/>
						</xsl:apply-templates>

					</xsl:when>


					<xsl:otherwise> … </xsl:otherwise>

				</xsl:choose>

				<xsl:if test="* and $indent-elements">
					<br/>
					<xsl:value-of select="$indent"/>
				</xsl:if>
				<xsl:text>&lt;/</xsl:text>
				<xsl:if test="$ns-prefix != ''">
					<span class="xmlverb-element-nsprefix">
						<xsl:value-of select="$ns-prefix"/>
					</span>
					<xsl:text>:</xsl:text>
				</xsl:if>
				<span class="xmlverb-element-name">
					<xsl:value-of select="local-name()"/>
				</span>
				<xsl:text>&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text> /&gt;</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="not(parent::*)">
			<br/>
			<xsl:text>&#xA;</xsl:text>
		</xsl:if>

	</xsl:template>


	<xsl:template match="*[not(cfn:namespace-prefix(.) = '')]" mode="ns-prefix">
		<xsl:variable name="ns" select="cfn:namespace-prefix(.)"/>
		<span class="xmlverb-element-nsprefix"><xsl:value-of select="cfn:namespace-prefix(.)"/></span><xsl:text>:</xsl:text>		
	</xsl:template>
	
	<xsl:template match="*" mode="ns-prefix"/>
	
	<xsl:template match="*" mode="element-name">
		<span class="xmlverb-element-name">
			<xsl:apply-templates select="@xml:id|@id" mode="id-copy"/>
			<xsl:value-of select="local-name()"/>
		</span>		
	</xsl:template>
	
	<xsl:template match="@*" mode="id-copy">
		<xsl:attribute name="xml:id" select="."/>
	</xsl:template>

	<!-- attribute nodes -->
	<xsl:template name="xmlverb-attrs">
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

	<!-- namespace nodes -->
	<xsl:template name="xmlverb-ns">
		<xsl:if test="name()!='xml'">
			<span class="xmlverb-ns-name">
				<xsl:text> xmlns</xsl:text>
				<xsl:if test="name()!=''">
					<xsl:text>:</xsl:text>
				</xsl:if>
				<xsl:value-of select="name()"/>
			</span>
			<xsl:text>=&quot;</xsl:text>
			<span class="xmlverb-ns-uri">
				<xsl:value-of select="."/>
			</span>
			<xsl:text>&quot;</xsl:text>
		</xsl:if>
	</xsl:template>

	<!-- text nodes 
      NG - modified to replace large blocks of text with ellipsis 
      Large is defined as 'more than 50 words' -->
	<xsl:template match="text()" mode="xmlverb">

		<span class="xmlverb-text">
			<xsl:call-template name="preformatted-output">
				<xsl:with-param name="text" select="cfn:html-replace-entities(cfn:limit-text(.))"/>
			</xsl:call-template>
		</span>

	</xsl:template>

	<xsl:template match="text()[contains(., $nl)]">
		<span class="xmlverb-text">
			<xsl:value-of select="cfn:html-replace-entities(cfn:limit-text(.))"/>
		</span>
	</xsl:template>

	<!-- comments -->
	<xsl:template match="comment()" mode="xmlverb">
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
	<xsl:template match="processing-instruction()" mode="xmlverb">
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



	<!-- replace in $value substring $from with $to -->
	<xsl:template name="replace-substring">
		<xsl:param name="value"/>
		<xsl:param name="from"/>
		<xsl:param name="to"/>
		<xsl:choose>
			<xsl:when test="contains($value,$from)">
				<xsl:value-of select="substring-before($value,$from)"/>
				<xsl:value-of select="$to"/>
				<xsl:call-template name="replace-substring">
					<xsl:with-param name="value" select="substring-after($value,$from)"/>
					<xsl:with-param name="from" select="$from"/>
					<xsl:with-param name="to" select="$to"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

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
		<xsl:variable name="prefix"
			select="for $ns in in-scope-prefixes($node) return if (namespace-uri-for-prefix($ns, $node) = $uri) then ($ns) else ()"/>
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
		<xsl:variable name="parent-namespaces" select="in-scope-prefixes($node/parent::*)"/>
		<xsl:value-of
			select="for $n in $our-namespaces 
			return if (exists(index-of($parent-namespaces, $n))) then $n else ()"
		/>
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
