# Data Dictionary #

This is the XSL being used to generate the GIS Data Dictionary pages from ArcSDE metadata.

The SDE metadata is stored as an XML field (in SQL Server anyway) called Documentation in the GDB_Items table, so it’s easy to get using the feature class name:

```sql  
SELECT Documentation  
FROM  GDB_ITEMS  
WHERE PhysicalName = 'blah'  
'''  

Here’s what we are using right now for fields:
	
| Field | Source in XML (from <metadata>) |  
| ----- | ------------------------------- |  
| image | Binary/Thumbnail/Data |  
| gis file name | dataIdInfo/idCitation/resTitle |  
| description | dataIdInfo/idAbs (rich text) |  
| purpose | dataIdInfo/idPurp |  
| last modified | Esri/ModDate |  
| attributes | eainfo/detailed/attr (multiples) |  
|  *attribute features | attr/attrlabl,attrtype,attwidth,atprecis,attrdef |  
|  *attribute values | attr/attrdomv/edom/edomv,edomvd |  
| coordinate system | Esri/DataProperties/coordRef/projcsn |  
