note
	description: "[
		Object representing a read preference abstraction
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_read_prefs_t", "src=http://mongoc.org/libmongoc/current/mongoc_read_prefs_t.html", "protocol=uri"

class
	MONGODB_READ_PREFERENCE

inherit

	MEMORY_STRUCTURE
		rename
			make as memory_make
		end

create
	make, make_own_from_pointer

feature {NONE} -- Initialization

	make
		do
			memory_make
		end

	make_own_from_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.own_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := False
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
			"return sizeof(mongoc_read_prefs_t *);"
		end

end
