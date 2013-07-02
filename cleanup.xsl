<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://docbook.org/ns/docbook"
    xmlns:db="http://docbook.org/ns/docbook"
    version="1.0">
    
    <xsl:output encoding="UTF-8"/>

    <xsl:param name="BASE"/>
    <xsl:param name="default.table.width" select="'80%'"/>

    <xsl:template match="db:article">
        <xsl:apply-templates select="db:section"/>
    </xsl:template>

    <xsl:template match="db:section[parent::db:article]">
        <chapter 
            version="5.0"
            xmlns:xi="http://www.w3.org/2001/XInclude"
            xmlns:xlink="http://www.w3.org/1999/xlink" >
            <xsl:attribute name="xml:id"><xsl:value-of select="$BASE"/></xsl:attribute> 
	    <xsl:processing-instruction name="dbhtml">stop-chunking</xsl:processing-instruction>
            <xsl:apply-templates select="node() | @*"/>
        </chapter> 
    </xsl:template>

    <xsl:template match="db:imagedata">
      <imagedata>
	<xsl:copy-of select="@*"/>
	<xsl:attribute name="fileref">
	  <xsl:call-template name="remove-encoded-spaces">
	    <xsl:with-param name="content" select="@fileref"/>
	  </xsl:call-template>
	</xsl:attribute>
      </imagedata>
    </xsl:template>

    <xsl:template name="remove-encoded-spaces">
      <xsl:param name="content" select="."/>
      <xsl:choose>
	<xsl:when test="contains($content,'%20')">
	  <xsl:call-template name="remove-encoded-spaces">
	    <xsl:with-param name="content" select="concat(substring-before($content,'%20'), ' ',substring-after($content,'%20'))"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:otherwise><xsl:value-of select="$content"/></xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template match="db:section">
        <section>
            <xsl:attribute name="xml:id"><xsl:value-of select="concat($BASE, '-', generate-id())"/></xsl:attribute>
            <xsl:apply-templates select="node() | @*"/>
        </section>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>

<!-- Convert cals tables to html -->
<!-- adapted from: http://www.biglist.com/lists/xsl-list/archives/200202/msg00666.html -->

<xsl:template match="db:informaltable">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:tgroup">
  <informaltable rules="all">
    <xsl:if test="../@pgwide=1">
      <xsl:attribute name="width">100%</xsl:attribute>
    </xsl:if>

    <xsl:if test="@align">
      <xsl:attribute name="align">
        <xsl:value-of select="@align"/>
      </xsl:attribute>
    </xsl:if>

    <!-- <xsl:choose> -->
    <!--   <xsl:when test="../@frame='TOPBOT'"> -->
    <!--     <xsl:attribute name="style">border-top:thin solid black;border-bottom:thin solid black</xsl:attribute> -->
    <!--   </xsl:when> -->
    <!--   <xsl:otherwise> -->
    <!--     <xsl:attribute name="border">0</xsl:attribute> -->
    <!--   </xsl:otherwise> -->
    <!-- </xsl:choose> -->

    <xsl:variable name="colgroup">
      <colgroup>
        <xsl:call-template name="generate.colgroup">
          <xsl:with-param name="cols" select="@cols"/>
        </xsl:call-template>
      </colgroup>
    </xsl:variable>

    <xsl:variable name="table.width">
      <xsl:choose>
        <xsl:when test="$default.table.width = ''">
          <xsl:text>100%</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$default.table.width"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:attribute name="width">
       <xsl:value-of select="$table.width"/>
    </xsl:attribute>


    <xsl:copy-of select="$colgroup"/>

    <xsl:apply-templates/>

   </informaltable>
</xsl:template>

<xsl:template match="db:colspec"></xsl:template>

<xsl:template match="db:spanspec"></xsl:template>

<xsl:template match="db:thead|db:tfoot">
  <xsl:element name="{name(.)}">
    <xsl:if test="@align">
      <xsl:attribute name="align">
        <xsl:value-of select="@align"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@char">
      <xsl:attribute name="char">
        <xsl:value-of select="@char"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@charoff">
      <xsl:attribute name="charoff">
        <xsl:value-of select="@charoff"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@valign">
      <xsl:attribute name="valign">
        <xsl:value-of select="@valign"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:tbody">
  <tbody>
    <xsl:if test="@align">
      <xsl:attribute name="align">
        <xsl:value-of select="@align"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@char">
      <xsl:attribute name="char">
        <xsl:value-of select="@char"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@charoff">
      <xsl:attribute name="charoff">
        <xsl:value-of select="@charoff"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@valign">
      <xsl:attribute name="valign">
        <xsl:value-of select="@valign"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:apply-templates/>
  </tbody>
</xsl:template>

<xsl:template match="db:row">
  <tr>
    <xsl:if test="@align">
      <xsl:attribute name="align">
        <xsl:value-of select="@align"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@char">
      <xsl:attribute name="char">
        <xsl:value-of select="@char"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@charoff">
      <xsl:attribute name="charoff">
        <xsl:value-of select="@charoff"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@valign">
      <xsl:attribute name="valign">
        <xsl:value-of select="@valign"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates/>
  </tr>
</xsl:template>

<xsl:template match="db:thead/db:row/db:entry">
  <xsl:call-template name="process.cell">
    <xsl:with-param name="cellgi">th</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:tbody/db:row/db:entry">
  <xsl:call-template name="process.cell">
    <xsl:with-param name="cellgi">td</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:tfoot/db:row/db:entry">
  <xsl:call-template name="process.cell">
    <xsl:with-param name="cellgi">th</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="process.cell">
  <xsl:param name="cellgi">td</xsl:param>


  <xsl:variable name="empty.cell" select="count(node()) = 0"/>

  <xsl:variable name="entry.colnum">
    <xsl:call-template name="entry.colnum"/>
  </xsl:variable>

  <xsl:if test="$entry.colnum != ''">
    <xsl:variable name="prev.entry" select="preceding-sibling::*[1]"/>
    <xsl:variable name="prev.ending.colnum">
      <xsl:choose>
        <xsl:when test="$prev.entry">
          <xsl:call-template name="entry.ending.colnum">
            <xsl:with-param name="entry" select="$prev.entry"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:call-template name="add-empty-entries">
      <xsl:with-param name="number">
        <xsl:choose>
          <xsl:when test="$prev.ending.colnum = ''">0</xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$entry.colnum - $prev.ending.colnum - 1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>

  <xsl:element name="{$cellgi}" namespace="http://docbook.org/ns/docbook">

  <xsl:if test="@spanname">
  	<xsl:variable name="namest" select="ancestor::db:tgroup/spanspec[@spanname=./@spanname]/@namest"/>
	<xsl:variable name="nameend" select="ancestor::db:tgroup/spanspec[@spanname=./@spanname]/@nameend"/>
	<xsl:variable name="colst" select="ancestor::db:*[db:colspec/@colname=$namest]/db:colspec[@colname=$namest]/@colnum"/>
	<xsl:variable name="colend" select="ancestor::db:*[db:colspec/@colname=$nameend]/db:colspec[@colname=$nameend]/@colnum"/>
	<xsl:attribute name="colspan"><xsl:value-of select="number($colend) - number($colst) + 1"/></xsl:attribute>
  </xsl:if>

    <xsl:if test="@morerows">
      <xsl:attribute name="rowspan">
        <xsl:value-of select="@morerows+1"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@namest">
      <xsl:attribute name="colspan">
        <xsl:call-template name="calculate.colspan"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@align">
      <xsl:attribute name="align">
        <xsl:value-of select="@align"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@char">
      <xsl:attribute name="char">
        <xsl:value-of select="@char"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@charoff">
      <xsl:attribute name="charoff">
        <xsl:value-of select="@charoff"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@valign">
      <xsl:attribute name="valign">
        <xsl:value-of select="@valign"/>
      </xsl:attribute>
    </xsl:if>

	<xsl:if test="@rowsep='1'">
		<xsl:attribute name="style">border-bottom:thin solid black</xsl:attribute>
	</xsl:if>

    <xsl:if test="not(preceding-sibling::*)
                  and ancestor::db:row/@id">
      <a name="{ancestor::db:row/@id}"/>
    </xsl:if>

    <xsl:if test="@id">
      <a name="{@id}"/>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="$empty.cell">
        <xsl:text>&#160;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:element>
</xsl:template>

<xsl:template name="add-empty-entries">
  <xsl:param name="number" select="'0'"/>
  <xsl:choose>
    <xsl:when test="$number &lt;= 0"></xsl:when>
    <xsl:otherwise>
      <td>&#160;</td>
      <xsl:call-template name="add-empty-entries">
        <xsl:with-param name="number" select="$number - 1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="entry.colnum">
  <xsl:param name="entry" select="."/>

  <xsl:choose>
    <xsl:when test="$entry/@colname">
      <xsl:variable name="colname" select="$entry/@colname"/>
      <xsl:variable name="colspec"

select="$entry/ancestor::db:tgroup/db:colspec[@colname=$colname]"/>
      <xsl:call-template name="colspec.colnum">
        <xsl:with-param name="colspec" select="$colspec"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$entry/@namest">
      <xsl:variable name="namest" select="$entry/@namest"/>
      <xsl:variable name="colspec" select="$entry/ancestor::db:tgroup/db:colspec[@colname=$namest]"/>
      <xsl:call-template name="colspec.colnum">
        <xsl:with-param name="colspec" select="$colspec"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="count($entry/preceding-sibling::*) = 0">1</xsl:when>
    <xsl:otherwise>
      <xsl:variable name="pcol">
        <xsl:call-template name="entry.ending.colnum">
          <xsl:with-param name="entry"
select="$entry/preceding-sibling::*[1]"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$pcol + 1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="entry.ending.colnum">
  <xsl:param name="entry" select="."/>

  <xsl:choose>
    <xsl:when test="$entry/@colname">
      <xsl:variable name="colname" select="$entry/@colname"/>
      <xsl:variable name="colspec"
select="$entry/ancestor::db:tgroup/db:colspec[@colname=$colname]"/>
      <xsl:call-template name="colspec.colnum">
        <xsl:with-param name="colspec" select="$colspec"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$entry/@nameend">
      <xsl:variable name="nameend" select="$entry/@nameend"/>
      <xsl:variable name="colspec"
select="$entry/ancestor::db:tgroup/db:colspec[@colname=$nameend]"/>
      <xsl:call-template name="colspec.colnum">
        <xsl:with-param name="colspec" select="$colspec"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="count($entry/preceding-sibling::*) = 0">1</xsl:when>
    <xsl:otherwise>
      <xsl:variable name="pcol">
        <xsl:call-template name="entry.ending.colnum">
          <xsl:with-param name="entry"
select="$entry/preceding-sibling::*[1]"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$pcol + 1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template name="colspec.colnum">
  <xsl:param name="colspec" select="."/>
  <xsl:choose>
    <xsl:when test="$colspec/@colnum">
      <xsl:value-of select="$colspec/@colnum"/>
    </xsl:when>
    <xsl:when test="$colspec/preceding-sibling::db:colspec">
      <xsl:variable name="prec.colspec.colnum">
        <xsl:call-template name="colspec.colnum">
          <xsl:with-param name="colspec"
                          select="$colspec/preceding-sibling::db:colspec[1]"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:value-of select="$prec.colspec.colnum + 1"/>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="generate.colgroup">
  <xsl:param name="cols" select="1"/>
  <xsl:param name="count" select="1"/>
  <xsl:choose>
    <xsl:when test="$count>$cols"></xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="generate.col">
        <xsl:with-param name="countcol" select="$count"/>
      </xsl:call-template>
      <xsl:call-template name="generate.colgroup">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="generate.col">
  <xsl:param name="countcol">1</xsl:param>
  <xsl:param name="colspecs" select="./db:colspec"/>
  <xsl:param name="count">1</xsl:param>
  <xsl:param name="colnum">1</xsl:param>

  <xsl:choose>
    <xsl:when test="$count>count($colspecs)">
      <col/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="colspec" select="$colspecs[$count=position()]"/>
      <xsl:variable name="colspec.colnum">
        <xsl:choose>
          <xsl:when test="$colspec/@colnum">
            <xsl:value-of select="$colspec/@colnum"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$colnum"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$colspec.colnum=$countcol">
          <col>
            <xsl:if test="$colspec/@align">
              <xsl:attribute name="align">
                <xsl:value-of select="$colspec/@align"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="$colspec/@char">
              <xsl:attribute name="char">
                <xsl:value-of select="$colspec/@char"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="$colspec/@charoff">
              <xsl:attribute name="charoff">
                <xsl:value-of select="$colspec/@charoff"/>
              </xsl:attribute>
            </xsl:if>
          </col>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="generate.col">
            <xsl:with-param name="countcol" select="$countcol"/>
            <xsl:with-param name="colspecs" select="$colspecs"/>
            <xsl:with-param name="count" select="$count+1"/>
            <xsl:with-param name="colnum">
              <xsl:choose>
                <xsl:when test="$colspec/@colnum">
                  <xsl:value-of select="$colspec/@colnum + 1"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$colnum + 1"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
           </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template name="colspec.colwidth">
  <!-- when this macro is called, the current context must be an entry -->
  <xsl:param name="colname"></xsl:param>
  <!-- .. = row, ../.. = thead|db:tbody, ../../.. = tgroup -->
  <xsl:param name="colspecs" select="../../../../db:tgroup/db:colspec"/>
  <xsl:param name="count">1</xsl:param>
  <xsl:choose>
    <xsl:when test="$count>count($colspecs)"></xsl:when>
    <xsl:otherwise>
      <xsl:variable name="colspec" select="$colspecs[$count=position()]"/>
      <xsl:choose>
        <xsl:when test="$colspec/@colname=$colname">
          <xsl:value-of select="$colspec/@colwidth"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="colspec.colwidth">
            <xsl:with-param name="colname" select="$colname"/>
            <xsl:with-param name="colspecs" select="$colspecs"/>
            <xsl:with-param name="count" select="$count+1"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="calculate.colspan">
  <xsl:param name="entry" select="."/>
  <xsl:variable name="namest" select="$entry/@namest"/>
  <xsl:variable name="nameend" select="$entry/@nameend"/>

  <xsl:variable name="scol">
    <xsl:call-template name="colspec.colnum">
      <xsl:with-param name="colspec"
select="$entry/ancestor::db:tgroup/db:colspec[@colname=$namest]"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="ecol">
    <xsl:call-template name="colspec.colnum">
      <xsl:with-param name="colspec" select="$entry/ancestor::db:tgroup/db:colspec[@colname=$nameend]"/>
    </xsl:call-template>
  </xsl:variable>
  <xsl:value-of select="$ecol - $scol + 1"/>
</xsl:template>
    
</xsl:stylesheet>
