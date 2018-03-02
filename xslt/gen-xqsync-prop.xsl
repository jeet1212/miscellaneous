<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
   <xsl:output encoding="UTF-8" method="text"/>
   <xsl:param name="fpath" select="'../ofiles/'"/>
    
   <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template  match="envs">
<xsl:for-each select="env">
<xsl:variable name="fname"><xsl:text>xqsync-</xsl:text> <xsl:value-of select="from/db"/>-marklogic-2-marklogic-env</xsl:variable>
<xsl:result-document method="text" encoding="UTF-8" href="{lower-case(concat($fpath, $fname, '.txt'))}">
<xsl:text><![CDATA[############################### FROM ############################################]]>
</xsl:text>
    <!--  FORM:  INPUT_CONNECTION_STRING=xcc://<<USER>>:<<PWD>>@<<HOST>>:<<XDBCPORT>>/<<DB>>-->
<xsl:text>INPUT_CONNECTION_STRING=xcc://</xsl:text><xsl:value-of select="from/user"/><xsl:text>:</xsl:text><xsl:value-of select="from/pwd"/><xsl:text>@</xsl:text>
    <xsl:value-of select="from/host"/><xsl:text>:</xsl:text><xsl:value-of select="from/xport"/><xsl:text>/</xsl:text><xsl:value-of select="from/db"/>
<xsl:text>
############################### TO ############################################
</xsl:text>
    <!--  TO:  OUTPUT_CONNECTION_STRING=xcc://<<USER>>:<<PWD>>@<<HOST>>:<<XDBCPORT>>/<<DB>>-->
<xsl:text>OUTPUT_CONNECTION_STRING=xcc://</xsl:text><xsl:value-of select="to/user"/><xsl:text>:</xsl:text><xsl:value-of select="to/pwd"/><xsl:text>@</xsl:text>
<xsl:value-of select="to/host"/><xsl:text>:</xsl:text><xsl:value-of select="to/xport"/><xsl:text>/</xsl:text><xsl:value-of select="to/db"/>
<![CDATA[#################################################################################
#### WHAT TO COPY #######
# QUERY generating the URIs to copy
# This query returns the URIs of anything that has changed since the last day
# This one uses timestamp, which is very slow
# This one uses the prop:last-modified property, which we index, and so is very fast.
INPUT_QUERY=xquery version "1.0-ml"; declare variable $date-x-days-ago  := fn:current-dateTime() - xs:dayTimeDuration("P1D"); for $d in cts:search(/, cts:and-query( ( cts:not-query(cts:directory-query('/events/', 'infinity')), cts:properties-query(cts:element-range-query(xs:QName("prop:last-modified"), ">", $date-x-days-ago )) ) ) ) let $uri := xdmp:node-uri($d) order by $uri return $uri
# These COPY_ settings are the defaults, but I am being explicit
COPY_COLLECTIONS=true
COPY_PROPERTIES=false
COPY_QUALITY=true
# There are no permissions to copy
# COPY_PERMISSIONS=true
###### HOW TO COPY ############
INPUT_BATCH_SIZE=8
FATAL_ERRORS=true
INPUT_QUERY_CACHABLE=false
INPUT_RESULT_BUFFER_SIZE=0
QUEUE_SIZE=1000
INPUT_INDENTED=false
THREADS=8
PRINT_CURRENT_RATE=true
THROTTLE_EVENTS_PER_SECOND=50
############
## Logging
LOG_LEVEL=FINE
LOG_HANDLER=FILE
]]><xsl:text>LOG_FILEHANDLER_PATH=/opt/logs/</xsl:text><xsl:value-of select="lower-case($fname)"/>.log
<xsl:text>LOG_FILEHANDLER_APPEND=false</xsl:text>
</xsl:result-document>  
</xsl:for-each>
          
</xsl:template>
    
    <xsl:template match="*"/>
    
</xsl:stylesheet>
