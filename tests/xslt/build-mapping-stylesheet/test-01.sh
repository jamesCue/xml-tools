#!/bin/sh

saxon ../../../msword/xslt/build-mapping-stylesheet.xsl test-01-map.xml test-01.xsl
saxon test-01.xsl test-01.xml result-01.xml
