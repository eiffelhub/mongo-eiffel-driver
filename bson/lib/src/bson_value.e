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

	BSON_WRAPPER_BASE

create
	make, make_by_pointer

feature {NONE} -- Initialization

	make
		do
			memory_make
		end

feature -- Access

	value_type: INTEGER
		do
			Result := c_value_type (item)
		end


feature -- Removal

	dispose
		do
			if shared then
				c_bson_value_destroy (item)
			end
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

	c_bson_value_destroy (a_value: POINTER)
		external
			"C inline use <bson.h>"
		alias
			"bson_value_destroy ((bson_value_t *)$a_value);"
		end
end
