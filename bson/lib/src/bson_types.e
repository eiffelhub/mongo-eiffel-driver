note
	description: "[
		Object representing the bson_type_t and bson_subtype_t enumerations. 
		It contains all of the types from the BSON Specification. It can be used to determine the type of a field at runtime.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_type_t", "src=http://mongoc.org/libbson/current/bson_type_t.html", "protocol=URI"
	EIS: "name=bson_subtype_t", "src=http://mongoc.org/libbson/current/bson_subtype_t.html", "protocol=URI"

class
	BSON_TYPES


feature -- BSON types

   BSON_TYPE_EOD : INTEGER = 0x00
   BSON_TYPE_DOUBLE : INTEGER = 0x01
   BSON_TYPE_UTF8 : INTEGER = 0x02
   BSON_TYPE_DOCUMENT : INTEGER = 0x03
   BSON_TYPE_ARRAY : INTEGER = 0x04
   BSON_TYPE_BINARY : INTEGER = 0x05
   BSON_TYPE_UNDEFINED : INTEGER = 0x06
   BSON_TYPE_OID : INTEGER = 0x07
   BSON_TYPE_BOOL : INTEGER = 0x08
   BSON_TYPE_DATE_TIME : INTEGER = 0x09
   BSON_TYPE_NULL : INTEGER = 0x0A
   BSON_TYPE_REGEX : INTEGER = 0x0B
   BSON_TYPE_DBPOINTER : INTEGER = 0x0C
   BSON_TYPE_CODE : INTEGER = 0x0D
   BSON_TYPE_SYMBOL : INTEGER = 0x0E
   BSON_TYPE_CODEWSCOPE : INTEGER = 0x0F
   BSON_TYPE_INT32 : INTEGER = 0x10
   BSON_TYPE_TIMESTAMP : INTEGER = 0x11
   BSON_TYPE_INT64 : INTEGER = 0x12
   BSON_TYPE_DECIMAL128 : INTEGER = 0x13
   BSON_TYPE_MAXKEY : INTEGER = 0x7F
   BSON_TYPE_MINKEY : INTEGER = 0xFF

feature -- Bson subtype

   BSON_SUBTYPE_BINARY: INTEGER = 0x00
   BSON_SUBTYPE_FUNCTION: INTEGER = 0x01
   BSON_SUBTYPE_BINARY_DEPRECATED: INTEGER = 0x02
   BSON_SUBTYPE_UUID_DEPRECATED: INTEGER = 0x03
   BSON_SUBTYPE_UUID: INTEGER = 0x04
   BSON_SUBTYPE_MD5: INTEGER = 0x05
   BSON_SUBTYPE_USER: INTEGER = 0x80


end
