note
	description: "[
			Object representing a mongoc_uri_t structure.
			It provides an abstraction on top of the MongoDB connection URI format. 
			It provides standardized parsing as well as convenience methods for extracting useful information such as replica hosts or authorization information.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_uri_t", "src=http://mongoc.org/libmongoc/current/mongoc_uri_t.html", "protocol=uri"

class
	MONGODB_URI

inherit

	MEMORY_STRUCTURE
		rename
			make as memory_make
		end

create
	make, make_own_from_pointer

feature {NONE}-- Initialization

	make (a_uri: STRING_8)
			-- Creates a new MongoClient using the URI string `a_uri' provided.
		do
			memory_make
			uri_new (a_uri)
		end

	make_own_from_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.own_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := False
		end

	uri_new (a_uri: STRING_8)
		local
			c_string: C_STRING
		do
			create c_string.make (a_uri)
			make_own_from_pointer ({MONGODB_EXTERNALS}.c_mongoc_uri_new (c_string.item))
			check success: item /= default_pointer end
		end


feature -- Access

	uri_string: STRING_8
			-- String representation of current URI.
		note
			EIS: "name=mongoc_uri_get_string", "src=http://mongoc.org/libmongoc/current/mongoc_uri_get_string.html", "protocol=uri"
		local
			c_string: C_STRING
		do
			create c_string.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_uri_get_string (item))
			Result := c_string.string
		end

feature -- Operations

	uri_copy: MONGODB_URI
			-- Copies the entire contents of the current URI.
		note
			EIS: "name=mongo_uri_copy", "src=http://mongoc.org/libmongoc/current/mongoc_uri_copy.html", "protocol=uri"
		do
			create Result.make_own_from_pointer ({MONGODB_EXTERNALS}.c_mongoc_uri_copy (item))
		end

feature {NONE} -- Measurement

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

	struct_size: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return sizeof(mongoc_uri_t *);"
		end

end
