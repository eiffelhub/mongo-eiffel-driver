note
	description: "[
		Object representing the bson_value_t structure. It is a boxed type for encapsulating a runtime determined type.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_value_t", "src=http://mongoc.org/libbson/current/bson_value_t.html", "protocol=uri"
	
class
	BSON_VALUE

inherit

	MEMORY_STRUCTURE
		rename
			make as memory_make
		redefine
			make_by_pointer
		end

create
	make, make_by_pointer

feature {NONE} -- Initialization

	make
		do
			memory_make
		end

	make_by_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.share_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := True
		end

feature -- Access

	value_type: INTEGER
		do
			Result := c_value_type (item)
		end

feature {NONE} -- Implementation

	c_value_type ( a_pointer: POINTER): INTEGER
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson.h>"
		alias
			"return ((bson_value_t  *) $a_pointer)->value_type;"
		end

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

	struct_size: INTEGER
		external
			"C inline use <bson.h>"
		alias
			"sizeof(bson_decimal128_t)"
		end
end
