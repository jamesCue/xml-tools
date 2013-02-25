<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:cword="http://www.corbas.co.uk/ns/word"
                xpath-default-namespace="http://docbook.org/ns/docbook"
                version="2.0">
   <xsl:output method="xml" encoding="UTF-8"/>
   <xsl:template match="@*|node()" mode="#all">
      <xsl:copy>
         <xsl:apply-templates select="@*|node()" mode="#current"/>
      </xsl:copy>
   </xsl:template>

	  <xsl:template match="para[@role = '01FMTPTitle']">
      <title xmlns="http://docbook.org/ns/docbook"
             cword:hint="doc-title"
             cword:level="0">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </title>
   </xsl:template>
	  <xsl:template match="para[@role = '01FMTPSubtitle']">
      <subtitle xmlns="http://docbook.org/ns/docbook" cword:hint="doc-title">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </subtitle>
   </xsl:template>

	  <xsl:template match="para[@role = '01FMHead']">
      <title xmlns="http://docbook.org/ns/docbook"
             cword:hint="prelims-title"
             cword:level="2">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </title>
   </xsl:template>
	  <xsl:template match="para[@role = '01FMTPAuthor']">
      <author xmlns="http://docbook.org/ns/docbook" cword:hint="doc-author">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <personname>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </personname>
      </author>
   </xsl:template>
	  <xsl:template match="para[@role = '01FMDediBody']">
      <dedication xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <para>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </para>
      </dedication>
   </xsl:template>

	  <xsl:template match="para[@role = '01FMAboutAuthorTitle']">
      <title xmlns="http://docbook.org/ns/docbook"
             cword:hint="prelims-title"
             cword:level="2">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </title>
   </xsl:template>
	  <xsl:template match="para[@role = '01FMbythesameauthorHead']">
      <title xmlns="http://docbook.org/ns/docbook"
             cword:hint="prelims-title"
             cword:level="2">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </title>
   </xsl:template>
	  <xsl:template match="para[@role = '01FMAcknowledgementsHead']">
      <title xmlns="http://docbook.org/ns/docbook"
             cword:hint="prelims-title"
             cword:level="2">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </title>
   </xsl:template>

	  <xsl:template match="para[@role = '01FMDediBody']">
      <dedication xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <para>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </para>
      </dedication>
   </xsl:template>



	  <xsl:template match="para[@role = '02PartTitle']">
      <title xmlns="http://docbook.org/ns/docbook"
             cword:hint="part-title"
             cword:level="1">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </title>
   </xsl:template>
	  <xsl:template match="para[@role = '02PartNumber']">
      <title xmlns="http://docbook.org/ns/docbook"
             cword:hint="part-number"
             cword:level="1">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </title>
   </xsl:template>
	  <xsl:template match="para[@role = '02PartTitleSubtitle']">
      <subtitle xmlns="http://docbook.org/ns/docbook" cword:hint="part-title">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </subtitle>
   </xsl:template>

	  <xsl:template match="para[@role = '03ChapterNumberandTitle']">
      <title xmlns="http://docbook.org/ns/docbook"
             cword:hint="chapter-title"
             cword:level="2">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </title>
   </xsl:template>
	  <xsl:template match="para[@role = '03ChapterNumber']">
      <title xmlns="http://docbook.org/ns/docbook"
             cword:hint="chapter-number"
             cword:level="2">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </title>
   </xsl:template>
	  <xsl:template match="para[@role = '03ChapterTitle']">
      <title xmlns="http://docbook.org/ns/docbook"
             cword:hint="chapter-title"
             cword:level="2">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </title>
   </xsl:template>
	  <xsl:template match="para[@role = '03ChapterTitleSubtitle']">
      <subtitle xmlns="http://docbook.org/ns/docbook" cword:hint="chapter-title">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </subtitle>
   </xsl:template>

	  <xsl:template match="para[@role = '05HeadA']">
      <title xmlns="http://docbook.org/ns/docbook"
             cword:hint="A-Head"
             cword:level="3">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </title>
   </xsl:template>
	  <xsl:template match="para[@role = '05HeadB']">
      <title xmlns="http://docbook.org/ns/docbook"
             cword:hint="B-Head"
             cword:level="4">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </title>
   </xsl:template>
	  <xsl:template match="para[@role = '05HeadC']">
      <title xmlns="http://docbook.org/ns/docbook"
             cword:hint="C-Head"
             cword:level="5">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </title>
   </xsl:template>

	  <xsl:template match="para[@role = '01FMEpigraph']">
      <epigraph xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <para>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </para>
      </epigraph>
   </xsl:template>
	  <xsl:template match="para[@role = '01FMEpigraphFL']">
      <epigraph xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <para>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </para>
      </epigraph>
   </xsl:template>
	  <xsl:template match="para[@role = '01EpigraphVerse']">
      <epigraph xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <para>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </para>
      </epigraph>
   </xsl:template>
	  <xsl:template match="para[@role = '02PartEpigraphVerse']">
      <epigraph xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <para>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </para>
      </epigraph>
   </xsl:template>
	  <xsl:template match="para[@role = '03ChapterEpigraph']">
      <epigraph xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <para>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </para>
      </epigraph>
   </xsl:template>
	  <xsl:template match="para[@role = '03ChapterEpigraphVerse']">
      <epigraph xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <attribution>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </attribution>
      </epigraph>
   </xsl:template>

	  <xsl:template match="para[@role = '01FMEpigraphSource']">
      <epigraph xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <attribution>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </attribution>
      </epigraph>
   </xsl:template>
	  <xsl:template match="para[@role = '02PartEpigraphSource']">
      <epigraph xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <attribution>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </attribution>
      </epigraph>
   </xsl:template>
	  <xsl:template match="para[@role = '03ChapterEpigraphSource']">
      <epigraph xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <attribution>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </attribution>
      </epigraph>
   </xsl:template>

	  <xsl:template match="para[@role = '12Caption']">
      <caption xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <para>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </para>
      </caption>
   </xsl:template>

	  <xsl:template match="para[@role = '06ProseExtract']">
      <blockquote xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <para>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </para>
      </blockquote>
   </xsl:template>
	  <xsl:template match="para[@role = '06ProseExtractFirst']">
      <blockquote xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <para>
            <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
            <xsl:apply-templates select="node()"/>
         </para>
      </blockquote>
   </xsl:template>

	  <xsl:template match="para[@role = 'normal']">
      <para xmlns="http://docbook.org/ns/docbook">
         <xsl:apply-templates select="@*[local-name() = 'id']"/>
         <xsl:apply-templates select="@*[not(local-name() = 'id')]"/>
         <xsl:apply-templates select="node()"/>
      </para>
   </xsl:template>

	  <xsl:template match="para[starts-with(@role,'01FMContent')]"/>

</xsl:stylesheet>
