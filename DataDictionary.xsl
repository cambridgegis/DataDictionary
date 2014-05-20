<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" omit-xml-declaration="yes" />
  <xsl:variable name="Upper" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
  <xsl:variable name="Lower" select="'abcdefghijklmnopqrstuvwxyz'" />
  <xsl:template match="metadata">
    <xsl:if test="count(Binary/Thumbnail/Data) > 0">
      <div class="right">
        <xsl:element name="img">
          <xsl:attribute name="src">data:image/jpeg;base64,<xsl:value-of select="Binary/Thumbnail/Data" /></xsl:attribute>
          <xsl:attribute name="width">350px</xsl:attribute>
        </xsl:element>
      </div>
    </xsl:if>

    <xsl:variable name="LayerName" select="dataIdInfo/idCitation/resTitle" />
    <xsl:if test="string-length($LayerName) > 0">
      <h2>GIS File Name</h2>
      <p>
        <xsl:value-of select="$LayerName" />
      </p>
    </xsl:if>

    <xsl:if test="count(dataIdInfo/idAbs) > 0">
      <h2>Description</h2>
      <xsl:variable name="BeforeText" select="substring-before(dataIdInfo/idAbs,'&lt;/DIV&gt;&lt;/DIV&gt;&lt;/DIV&gt;')" />
      <xsl:variable name="AfterText" select="substring-after($BeforeText, '&lt;DIV STYLE=&quot;text-align:Left;&quot;&gt;&lt;DIV&gt;&lt;DIV&gt;')" />
      <p>
        <xsl:if test="string-length($AfterText) > 0">
          <xsl:value-of select="$AfterText" disable-output-escaping="yes" />
        </xsl:if>
        <xsl:if test="string-length($AfterText) = 0">
            <xsl:value-of select="dataIdInfo/idAbs" disable-output-escaping="yes" />
        </xsl:if>
      </p>
    </xsl:if>

    <xsl:if test="count(dataIdInfo/idPurp) > 0">
      <h2>Purpose</h2>
      <p>
        <xsl:value-of select="dataIdInfo/idPurp" />
      </p>
    </xsl:if>
    
    <xsl:variable name="DownloadInstruct" select="translate(translate(dataIdInfo/resMaint/maintNote,$Lower,$Upper),' ','')" /> <!--check for download instructions, trim and uppercase them --> 
    <xsl:if test="string-length($LayerName) > 0 and substring($DownloadInstruct,1,10) != 'NODOWNLOAD'" >
      <h2>Download Layer Data</h2>
      <ul class="dictionary-downloads">
        <xsl:if test="substring($DownloadInstruct,1,5) != 'NOSHP'">
            <li>
              <xsl:element name="a">
                <xsl:attribute name="href">http://gis.cambridgema.gov/download/shp/<xsl:value-of select="$LayerName" />.shp.zip</xsl:attribute>
                <xsl:attribute name="class">document zip</xsl:attribute>
                <xsl:value-of select="$LayerName" /> ShapeFile</xsl:element>
            </li>
        </xsl:if>
        <xsl:if test="substring($DownloadInstruct,1,5) != 'NOGDB'">
            <li>
              <xsl:element name="a">
                <xsl:attribute name="href">http://gis.cambridgema.gov/download/gdb/<xsl:value-of select="$LayerName" />.gdb.zip</xsl:attribute>
                <xsl:attribute name="class">document zip</xsl:attribute>
                <xsl:value-of select="$LayerName" /> File GeoDatabase</xsl:element>
            </li>
        </xsl:if>
      </ul>
    </xsl:if>

    <xsl:if test="count(dataIdInfo/idCitation/date/reviseDate) >0">
      <h2>Last Modified</h2>
      <xsl:variable name="LastMod" select="dataIdInfo/idCitation/date/reviseDate/text()" />
      <p>
        <xsl:value-of select="concat(substring($LastMod,6,2),'-',substring($LastMod,9,2),'-',substring($LastMod,1,4))" />
      </p>
    </xsl:if>

    <xsl:variable name="attributes" select="eainfo/detailed/attr[translate(attrlabl,$Lower,$Upper)!='OBJECTID' and translate(attrlabl,$Lower,$Upper)!= 'OBJECTID_1' and translate(attrlabl,$Lower,$Upper)!= 'GLOBALID' and translate(attrlabl, $Lower, $Upper)!= 'SHAPE' and translate(attrlabl,$Lower,$Upper)!= 'SHAPE.AREA' and translate(attrlabl,$Lower,$Upper)!= 'SHAPE.LEN' and translate(attrlabl,$Lower,$Upper)!= 'EDITDATE']" /><!--return any nodes that pass the select statement, not the actual translations-->
    <xsl:if test="count($attributes) > 0">
      <h2>Attributes</h2>
      <table class="dictionary-attributes">
        <thead>
          <tr>
            <th class="name">Name</th>
            <th class="type">Type Details</th>
            <th class="description">Description</th>
          </tr>
        </thead>
        <xsl:apply-templates select="$attributes" />
      </table>
    </xsl:if>

    <xsl:if test="count(Esri/DataProperties/coordRef/projcsn) > 0">
      <h2>Coordinate System</h2>
      <p>
        <xsl:value-of select="translate(Esri/DataProperties/coordRef/projcsn, '_', ' ')" />
      </p>
    </xsl:if>
  </xsl:template>

  <!-- ATTRIBUTES -->
  <xsl:template match="eainfo/detailed/attr">
    <tr>
      <td>
        <xsl:value-of select="translate(attrlabl,$Lower,$Upper)" />
      </td>
      <td>
        type: <xsl:value-of select="attrtype" /><br />
        width: <xsl:value-of select="attwidth" /><br />
        precision: <xsl:value-of select="atprecis" />
      </td>
      <td>
        <xsl:value-of select="attrdef" />
        <!-- create the field values table; use class and id as hooks for jQuery later -->
        <xsl:if test="count(attrdomv/edom) > 0">
          <h4 class="values-title-box">
            <xsl:element name="a">
              <xsl:attribute name="id">values-title-<xsl:value-of select="attrlabl" /></xsl:attribute>
              <xsl:attribute name="class">values-title</xsl:attribute>
              <xsl:attribute name="href" />
              <xsl:text>Values</xsl:text>
            </xsl:element>
          </h4>
          <xsl:element name="table">
            <xsl:attribute name="id">values-table-<xsl:value-of select="attrlabl" /></xsl:attribute>
            <xsl:attribute name="class">values-table</xsl:attribute>
            <thead>
              <tr>
                <th>Value</th>
                <th>Description</th>
              </tr>
            </thead>
            <xsl:apply-templates select="attrdomv/edom" />
          </xsl:element>
        </xsl:if>
      </td>
    </tr>
  </xsl:template>

  <!-- FIELD VALUES -->
  <xsl:template match="attrdomv/edom">
    <tr>
      <td>
        <xsl:value-of select="edomv" />
      </td>
      <td>
        <xsl:value-of select="edomvd" />
      </td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>