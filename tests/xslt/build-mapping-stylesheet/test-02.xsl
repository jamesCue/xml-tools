<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cword="http://www.corbas.co.uk/ns/word"
                xmlns="http://www.w3.org/1999/xhtml"
                xpath-default-namespace="http://www.w3.org/1999/xhtml"
                version="2.0">
   <xsl:output method="xml" encoding="UTF-8"/>
   <xsl:template match="@*|node()" mode="#all">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()" mode="#current"/>
      </xsl:copy>
   </xsl:template>
	  <xsl:template match="*[@class = '01FMAboutAuthorTitle']">
      <h5>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB07SmallCapsMediumHead</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </h5>
   </xsl:template>
	  <xsl:template match="*[@class = '01FMBiographyFL']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB02BodyTextFullOut</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '01FMDediBody']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB02BodyTextFullOut</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '01FMEpigraph']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB17Epigraph</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '01FMEpigraphSource']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB18EpigraphSource</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '01FMTPAuthor ']">
      <h2>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB09SmallCapsLargeHead</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </h2>
   </xsl:template>
	  <xsl:template match="*[@class = '01FMTPSubtitle']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB11SmallItalicHeadSpaced</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '01FMTPTitle']">
      <h2>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB04MainHead</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </h2>
   </xsl:template>
	  <xsl:template match="*[@class = '01FMAcknowledgementsHead']">
      <h2>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB04MainHead</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </h2>
   </xsl:template>
	  <xsl:template match="*[@class = '01FMHead']">
      <h2>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB04MainHead</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </h2>
   </xsl:template>
	  <xsl:template match="*[@class = '03ChapterEpigraph']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB17Epigraph</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '03ChapterEpigraphSource']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB18EpigraphSource</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	
	  <xsl:template match="*[@class = '03ChapterNumberandTitle']">
      <h2>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB04MainHeadClosedTitle</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </h2>
   </xsl:template>
	  <xsl:template match="*[@class = '03ChapterTitle']">
      <h2>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB04MainHead</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </h2>
   </xsl:template>
	  <xsl:template match="*[@class = '04BodyText']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB03BodyTextIndented</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '04BodyTextFL']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB02BodyTextFullOut</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '05HeadA']">
      <h2>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB04MainHead2</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </h2>
   </xsl:template>
	  <xsl:template match="*[@class = '05HeadB']">
      <h4>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB10SmallHead</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </h4>
   </xsl:template>
	  <xsl:template match="*[@class = '05HeadC']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB11SmallItalicHead</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '06ProseExtractFirst']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB19ExtraFeatureFullOut</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '06Verse']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">poem</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '11RecipeIngredients']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB22ExtraFeatureFirst</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '11RecipeMethodSubhead']">
      <h4>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB10SmallHead</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </h4>
   </xsl:template>
	  <xsl:template match="*[@class = '11RecipeServes']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB14CopyrightText</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '12Caption']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB28InlineCaption</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '14FootnoteText']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB19ExtraFeatureFullOut</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '13EMBiblioFL']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB26SmallTextHangingIndent</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '15Italic']">
      <xsl:copy>
         <xsl:attribute name="class">EB12SmallItalic</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
      </xsl:copy>
   </xsl:template>
	  <xsl:template match="*[@class = '15Subscript']">
      <sub>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EBsub</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </sub>
   </xsl:template>
	  <xsl:template match="*[@class = 'bold']">
      <strong>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </strong>
   </xsl:template>
	  <xsl:template match="*[@class = 'italic']">
      <em>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </em>
   </xsl:template>
	  <xsl:template match="*[@class = 'normal']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB03BodyTextIndented</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '14FootnoteText']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB19ExtraFeatureFullOut</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '01FMbythesameauthorHead']">
      <h2>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB04MainHead</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </h2>
   </xsl:template>
	  <xsl:template match="*[@class = '01FMbythesameauthorlist']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB02BodyTextFullOut</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '02PartTitle']">
      <h2>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB04MainHead</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </h2>
   </xsl:template>
	  <xsl:template match="*[@class = '13EMHead']">
      <h5>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB13CopyrightHead</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </h5>
   </xsl:template>
	  <xsl:template match="*[@class = '13EMEndNotesFL']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">EB14CopyrightText</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '04SpaceBreak']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">specialsLastPara</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
	  <xsl:template match="*[@class = '01FMbythesameauthorname']">
      <p>
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:attribute name="class">OtherSpecialsAuthor</xsl:attribute>
         <xsl:apply-templates select="@*[not(local-name() = 'id')][not(@class)]"/>
         <xsl:apply-templates select="node()"/>
      </p>
   </xsl:template>
</xsl:stylesheet>
