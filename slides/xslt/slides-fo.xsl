<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:p="http://www.corbas.co.uk/ns/presentations" xmlns:fo="http://www.w3.org/1999/XSL/Format"
	xmlns:h="http://www.w3.org/1999/xhtml"
	xpath-default-namespace="http://www.corbas.co.uk/ns/presentations"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" exclude-result-prefixes="p xsi"
	version="2.0">

	<xsl:import href="../../xslt/verbatim-fo.xsl"/>
	<xsl:import href="process-includes.xsl"/>
	<xsl:param name="indent-elements" select="true()"/>
	<xsl:param name="suppress-ns-declarations-default" select="true()"/>

	<xsl:output name="file-as-text" method="text" encoding="utf-8"/>
	<xsl:output name="file-as-xml" method="xml" indent="yes" encoding="UTF-8"/>

	<xsl:attribute-set name="slide-attributes" >
		<xsl:attribute name="font-family">Arial</xsl:attribute>
		<xsl:attribute name="font-size">16pt</xsl:attribute>
		<xsl:attribute name="font-weight">normal</xsl:attribute>
		<xsl:attribute name="page-break-after">always</xsl:attribute>
	</xsl:attribute-set>

	<xsl:attribute-set name="page-header-attributes">
		<xsl:attribute name="color">#b7032c</xsl:attribute>
		<xsl:attribute name="border-bottom-style">solid</xsl:attribute>
		<xsl:attribute name="border-bottom-width">2pt</xsl:attribute>
		<xsl:attribute name="font-size">24pt</xsl:attribute>
		<xsl:attribute name="padding-bottom">8pt</xsl:attribute>
		<xsl:attribute name="margin-bottom">8pt</xsl:attribute>
	</xsl:attribute-set>


	<xsl:attribute-set name="h3-attributes">
		<xsl:attribute name="font-size">16pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">#b7032c</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="h4-attributes">
		<xsl:attribute name="font-size">16pt</xsl:attribute>
		<xsl:attribute name="font-weight">bold</xsl:attribute>
		<xsl:attribute name="color">#707070</xsl:attribute>
	</xsl:attribute-set>
	
	<xsl:attribute-set name="preformatted-text">
		<xsl:attribute name="color">#333333</xsl:attribute>
		<xsl:attribute name="font-family">monospace</xsl:attribute>
	</xsl:attribute-set>

	<xsl:template match="/">
		
		<fo:root>

			<fo:layout-master-set>
				<fo:simple-page-master master-name="A4" margin="1.5cm" page-height="210mm"
					page-width="297mm">
					<fo:region-body margin-bottom="5mm" margin-top="5mm"/>
					<fo:region-before extent="3cm"/>
					<fo:region-after extent="1.5cm"/>
				</fo:simple-page-master>
			</fo:layout-master-set>

			<fo:page-sequence master-reference="A4">
				<xsl:call-template name="page-header"/>
				<xsl:call-template name="page-footer"/>
				<xsl:apply-templates />
			</fo:page-sequence>
		</fo:root>

	</xsl:template>

	<xsl:template name="page-header"> </xsl:template>

	<xsl:template name="page-footer">
		<fo:static-content flow-name="xsl-region-after">
			<fo:block>
				<fo:external-graphic
					src="url(images/logo.jpg)"
					vertical-align="middle"/>
			</fo:block>
		</fo:static-content>
	</xsl:template>

	<xsl:template match="presentation">
		<fo:flow flow-name="xsl-region-body">
			<xsl:apply-templates/>
		</fo:flow>
	</xsl:template>


	<xsl:template match="presentation/presentation">
		<xsl:apply-templates/>
	</xsl:template>


	<documentation xmlns="http://www.corbas.co.uk/ns/documentation">
		<p xmlns="http://www.w3.org/1999/xhtml">Slides just contain elements which may or may not be
			processed. Apply templates to the lot.</p>
	</documentation>

	<xsl:template match="slide[@type = 'html' or not(@type)]">
		<fo:block xsl:use-attribute-sets="slide-attributes" id="{(@xml:id, @id, generate-id())[1]}">
			<xsl:apply-templates select="node()"/>
		</fo:block>
	</xsl:template>


	

	<documentation xmlns="http://www.corbas.co.uk/ns/documentation">
		<h:p>Slides of type markdown should have had their content converted to html by this point
			so we just copy them to the output</h:p>
	</documentation>




	<documentation xmlns="http://www.corbas.co.uk/ns/documentation">
		<h:p>Slides of type text are just wrapped in an article and treated as preformmatted
			text.</h:p>
	</documentation>

	<xsl:template match="text">
		<fo:block xsl:use-attribute-sets="preformatted-text"><xsl:value-of select="."/></fo:block>
	</xsl:template>

	<documentation xmlns="http://www.corbas.co.uk/ns/documentation">
		<h:p>Slides of type code with a subtype of xml or xhtml are passed through the verbatim
			processor.</h:p>
	</documentation>

	<xsl:template match="code[@type = ('xml', 'xhtml') or not(@type)][parent::slide]">
		<xsl:variable name="title" select="*[1][self::p:title]"/>
		<fo:block xsl:use-attribute-sets="verbatim-default">
			<xsl:apply-templates select="$title"/>
			<xsl:apply-templates select="node() except $title" mode="code-block"/>
			<xsl:apply-templates select="@file-as"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="code[@type = ('xml', 'xhtml') or not(@type)][not(parent::slide)]">
		<xsl:variable name="title" select="*[1][self::p:title]"/>
	
			<fo:block xsl:use-attribute-sets="verbatim-default">
				<xsl:apply-templates select="$title"/>
				<xsl:apply-templates select="node() except $title" mode="code-block"/>
				<xsl:apply-templates select="@file-as"/>
			</fo:block>
		
	</xsl:template>

	<xsl:template match="*" mode="code-block">
		<fo:block xsl:use-attribute-sets="verbatim-default">
			<xsl:apply-templates select="." mode="verbatim">
				<xsl:with-param name="suppress-ns-declarations"
					select="if (ancestor::p:code[@show-ns-declarations]) then false() else true()"/>
			</xsl:apply-templates>
		</fo:block>
	</xsl:template>


	<xsl:template match="@file-as">
		<fo:block class="file-as">
			
			<fo:external-graphic
				src="url({.})"
				vertical-align="middle"/>
			
		</fo:block>
	</xsl:template>


	<documentation xmlns="http://www.corbas.co.uk/ns/documentation">
		<h:p>Other code is just passed through as predefined text</h:p>
	</documentation>
	<xsl:template match="code[not(parent::slide)]">
		<xsl:variable name="title" select="*[1][self::p:title]"/>
		
		
			<fo:block>
				<xsl:apply-templates select="$title"/>
				<fo:block xsl:use-attribute-sets="preformatted-text"><xsl:copy-of select="node() except $title"/></fo:block>
			</fo:block>

	</xsl:template>


	<xsl:template match="code[parent::slide]">
		<xsl:variable name="title" select="*[1][self::p:title]"/>
		<fo:block>
			<xsl:apply-templates select="$title"/>
			<fo:block xsl:use-attribute-sets="preformatted-text"><xsl:apply-templates select="node() except $title" mode="code"/></fo:block>
		</fo:block>
	</xsl:template>

	<xsl:template match="code/node()" mode="code">
		<xsl:value-of select="normalize-space(.)"/>
	</xsl:template>


	<!-- ignore notes elements in normal output -->
	<xsl:template match="notes"/>


	<!-- blockquotes generate a narrower box with slightly smaller text -->
	<xsl:template match="h:blockquote">
		<fo:block font-size="90%" margin-left="1em" margin-right="1em">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	
	<!-- definition lists -->
	<xsl:template match="h:dl">
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="h:dt">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>		
	</xsl:template>
	
	<xsl:template match="h:dd">
		<fo:block margin-left="1em" margin-bottom="0.5em">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<!-- simple html -->
	<xsl:template match="h:p">
		<fo:block padding-bottom="0.5em">
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="h:ol|h:ul">
		<fo:list-block>
			<xsl:apply-templates/>
		</fo:list-block>
	</xsl:template>

	<xsl:template match="h:ol/h:li">
		<fo:list-item margin-top="0.5em">
			<fo:list-item-label end-indent="label-end()">
				<fo:block>
					<xsl:value-of select="position()"/>
				</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates/>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template match="h:ul/h:li">
		<fo:list-item margin-top="0.5em">
			<fo:list-item-label end-indent="label-end()">
				<fo:block>&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates/>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>

	<xsl:template match="h:ul/h:li[not(h:p)]" priority="1">
		<fo:list-item margin-top="0.5em">
			<fo:list-item-label end-indent="label-end()">
				<fo:block>&#x2022;</fo:block>
			</fo:list-item-label>
			<fo:list-item-body start-indent="body-start()">
				<fo:block><xsl:apply-templates/></fo:block>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	

	<xsl:template match="h:li/h:p">
		<fo:block>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>

	<xsl:template match="h:h1">
		<fo:block margin-top="8cm" text-align="center">
			<fo:block font-size="48pt">
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="h:h2|code[not(parent::p:slide)]/title">
		<fo:block height="2cm" vertical-align="top">
			<fo:block xsl:use-attribute-sets="page-header-attributes">
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>
	
	<xsl:template match="h:h3">
		<fo:block height="2cm" vertical-align="top">
			<fo:block xsl:use-attribute-sets="h3-attributes">
				<xsl:apply-templates/>
			</fo:block>
		</fo:block>
	</xsl:template>
	
	
	<xsl:template match="h:h4">
			<fo:block xsl:use-attribute-sets="h4-attributes">
				<xsl:apply-templates/>
			</fo:block>
	</xsl:template>
	
	<xsl:template match="h:div">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="h:em">
		<fo:inline font-style="italic"><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="h:strong">
		<fo:inline font-weight="bold"><xsl:apply-templates/></fo:inline>
	</xsl:template>

	<xsl:template match="h:img">
		<fo:external-graphic src="{@src}"/>
	</xsl:template>
	
	<xsl:template match="h:code">
		<fo:inline font-family="Courier New, Courier, mono"><xsl:apply-templates/></fo:inline>
	</xsl:template>
	
	<xsl:template match="h:table[h:caption][h:tbody]">
		<fo:table-and-caption>
			<xsl:apply-templates select="h:caption"/>
			<xsl:apply-templates select="* except h:caption"/>
		</fo:table-and-caption>
	</xsl:template>
	
	<xsl:template match="h:table[h:caption][not(h:tbody)]">
		<fo:table-and-caption>
			<xsl:apply-templates select="caption"/>
			<fo:table>
				<fo:table-body>
					<xsl:apply-templates/>
				</fo:table-body>
			</fo:table>
		</fo:table-and-caption>
	</xsl:template>
	
	<xsl:template match="h:table[h:tbody]">
		<fo:table>
			<xsl:apply-templates select="* except h:caption"/>
		</fo:table>
	</xsl:template>

	<xsl:template match="h:table[not(h:tbody)]">
			<fo:table>
				<fo:table-body>
					<xsl:apply-templates/>
				</fo:table-body>
			</fo:table>
	</xsl:template>

	<xsl:template match="h:tbody">
		<fo:table-body>
			<xsl:apply-templates/>
		</fo:table-body>
	</xsl:template>

	<xsl:template match="h:thead">
		<fo:table-header>
			<xsl:apply-templates/>
		</fo:table-header>
	</xsl:template>

	<xsl:template match="h:tr">
		<fo:table-row>
			<xsl:apply-templates/>
		</fo:table-row>
	</xsl:template>

	<xsl:template match="h:td">
		<fo:table-cell>
			<xsl:apply-templates/>
		</fo:table-cell>
	</xsl:template>
	
	<xsl:template match="h:td[not(h:p)]">
		<fo:table-cell>
			<fo:block><xsl:apply-templates/></fo:block>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="h:th">
		<fo:table-cell font-weight="bold">
			<xsl:apply-templates/>
		</fo:table-cell>
	</xsl:template>

	<xsl:template match="h:th[not(h:p)]">
		<fo:table-cell font-weight="bold">
			<fo:block><xsl:apply-templates/></fo:block>
		</fo:table-cell>
	</xsl:template>
	
	
	<xsl:template match="h:a">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="h:br">
		<fo:block/>
	</xsl:template>

	<!-- div and slid titles generate a heading slide -->
	<xsl:template match="div/title|presentation/title">
		<fo:block xsl:use-attribute-sets="slide-attributes" id="{(@xml:id, @id, generate-id())[1]}">
			<fo:block margin-top="8cm" text-align="center">
				<fo:block font-size="48pt">
					<xsl:apply-templates/>
				</fo:block>
			</fo:block>
		</fo:block>
	</xsl:template>
	
	<!-- Ignore divs -->
	<xsl:template match="div">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- ignore *ANYTHING* with suppress set to true -->
	<xsl:template match="*[@suppress = ('always', 'print')]" priority="100" mode="#all"/>


	<!-- just for development -->
	<xsl:template match="*" priority="-1">
		<xsl:message terminate="yes">Unhandled element - <xsl:value-of select="local-name()"
			/></xsl:message>
	</xsl:template>



	



</xsl:stylesheet>
