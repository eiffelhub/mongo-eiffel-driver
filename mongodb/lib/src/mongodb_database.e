note
	description: "[
		Object Representing a MongoDB Database Abstraction
		mongoc_database_t provides access to a MongoDB database. This handle is useful for actions a particular database object. It is not a container for mongoc_collection_t structures.	
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Mongo Database ", "src=http://mongoc.org/libmongoc/current/mongoc_database_t.html", "protocol=uri"
class
	MONGODB_DATABASE


inherit

	MEMORY_STRUCTURE
		rename
			make as memory_make
		redefine
			make_by_pointer
		end

create
	make_by_pointer

feature {NONE} -- Initialization

	make_by_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.share_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := True
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
			"return sizeof(mongoc_database_t *);"
		end

end
