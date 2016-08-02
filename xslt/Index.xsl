<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    
    <!-- 
        ~ Created On: Jul 4, 2016
        ~ Created By: Indy
        ~ This script is to show books information in the HTML format
    -->
    
    
    <!-- output type -->
    <xsl:output method="xhtml" omit-xml-declaration="yes"/>
    
    <!-- Suppressed un-used spaces -->
    <xsl:strip-space elements="*"/>
    
    <!-- Document node processing -->
    <xsl:template match="/">
        <!-- ******************************** APPLY TEMPLATE ************************* -->
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Root element catalog processing -->
    
    <!-- ******************************** TEMPLATE MATCH ************************* -->
    <xsl:template match="catalog">
        <html>
            <head>
                <title><xsl:value-of select="$book-details"/></title>
                <style type="text/css">
                    body {font-family:arial, sans-serif; font-size: 12px; margin: 15px; line-height:1.3em;}
                    h1, h2 {margin-bottom:25px;;color:green}
                    h3 {margin:1px;;color:#0879C0}
                    div#tbooks{padding-left:10px;}
                    div.tbook{float:left;width:100%;}
                    div.bookInfoCaption {float:left;width:10%;font-weight:bold}
                    div.bookInfoText {float:left;width:90%;}
                    .indexTerm {padding-left:10px; padding-bottom:10px;}
                    ul {margin:0px}
                </style>
            </head>
            <body>
                <!-- ToC -->
                <h2><xsl:value-of select="$book-index"/></h2>
                <div class="indexTerm">
                   <ol style="type:circle">
                    <xsl:apply-templates select="book/title" mode="ToC"/> 
                   </ol>    
                </div>
                <hr/>
                <h2>
                    <xsl:value-of select="$book-details"/>
                </h2>
                <div id="tbooks">
                   <xsl:call-template name="output-book"/>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <!-- ****************************** MODAL Template ********************* -->
    <xsl:template match="title" mode="ToC">
        <li>
            <a href="{concat('#',../@id)}" style="text-decoration:none"><xsl:value-of select="."/></a>
        </li>
    </xsl:template>
    
    <!-- Display book details in the ascending order of the tilte name -->
    <!-- ****************************** EXAMPLE of NAMED TEMPLATE ****************************** -->
    <xsl:template name="output-book">
        <xsl:for-each select="book">
            <xsl:sort select="title" data-type="text"/>
          
            <div class="tbook" id="{@id}">
                <xsl:choose>
                    <xsl:when test="position() = last()">
                        <xsl:attribute name="style">
                            <xsl:text>display:table;padding-bottom:10px;padding-left:10px;</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="style">
                            <xsl:text>display:table;padding-bottom:25px;padding-left:10px;</xsl:text>
                        </xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="output-bname"/>
                <xsl:apply-templates/>
            </div>
        </xsl:for-each>
    </xsl:template>
    
    
    <!--  Show book title in the first place. As per XML it will come on second so created named template to show it on first place -->
    <xsl:template name="output-bname">
        <h3 style="margin-left:-10px;margin-bottom:5px;">
           <xsl:value-of select="title"/>
        </h3>
    </xsl:template>
    
    <!-- Book Author handling -->
    <xsl:template match="author">
        <div class="bookInfoCaption">
            <xsl:value-of select="$book-author"/>
        </div>
        <div class="bookInfoText">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Book category handling -->
    <xsl:template match="genre">
        <div class="bookInfoCaption">
            <xsl:value-of select="$book-category"/>
        </div>
        <div class="bookInfoText">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Book price handling -->
    <xsl:template match="price">
        <div class="bookInfoCaption">
            <xsl:value-of select="$book-price"/>
        </div>
        <div class="bookInfoText">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Book publish date handling -->
    <xsl:template match="publish_date">
        <div class="bookInfoCaption">
            <xsl:value-of select="$book-publish-date"/>
        </div>
        <div class="bookInfoText">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- Book description handling -->
    <xsl:template match="description">
        <div class="bookInfoCaption">
            <xsl:value-of select="$book-description"/>
        </div>
        <div class="bookInfoText">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <!-- suppress formatting of book/title element as we have shown this already in the first place -->
    <xsl:template match="title[parent::book]"/>
    
    <!-- ****************************Static Text*************************************** -->
    
    <!-- We can make another common XSLT file like gentext.xsl for all the used text and can import in the main xsl file -->
    
    <xsl:param name="book-details">
        <xsl:text>Book's Detail</xsl:text>
    </xsl:param>
    
    <xsl:param name="book-index">
        <xsl:text>Index</xsl:text>
    </xsl:param>
    
    <xsl:param name="book-author">
        <xsl:text>Author:</xsl:text>
    </xsl:param>
    
    <xsl:param name="book-category">
        <xsl:text>Category:</xsl:text>
    </xsl:param>
    
    <xsl:param name="book-price">
        <xsl:text>Price:</xsl:text>
    </xsl:param>
    
    <xsl:param name="book-publish-date">
        <xsl:text>Publish Date:</xsl:text>
    </xsl:param>
    
    <xsl:param name="book-description">
        <xsl:text>Description:</xsl:text>
    </xsl:param>
</xsl:stylesheet>
