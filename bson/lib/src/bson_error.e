note
	description: "[
		Object representing the bson_error_t structure.
		It is used as an out-parameter to pass error information to the caller. It should be stack-allocated and does not requiring freeing.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_error_t", "src=http://mongoc.org/libbson/current/bson_error_t.html", "protocol=uri"
class
	BSON_ERROR

inherit
	MEMORY_STRUCTURE
		export
			{ANY} managed_pointer
		undefine
			default_create
		end

create default_create, make_own_from_pointer

feature {NONE} -- Creation

	default_create
			-- Initialize an empty Error structure,
		do
			make
		end

	make_own_from_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.own_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := False
		end

feature -- Access

	domain: INTEGER_32
		do
			Result := c_domain (item)
		end

	code: INTEGER_32
		do
			Result := c_code (item)
		end

	message: STRING_32
		local
			l_string: C_STRING

		do
			create l_string.make_by_pointer (c_message (item))
			Result := l_string.string
		end

feature {NONE} -- Implementation


	c_domain ( a_pointer: POINTER): INTEGER_32
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson.h>"
		alias
			"return ((bson_error_t *) $a_pointer)->domain;"
		end

	c_code ( a_pointer: POINTER): INTEGER_32
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson.h>"
		alias
			"return ((bson_error_t *) $a_pointer)->code;"
		end

	c_message ( a_pointer: POINTER): POINTER
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson.h>"
		alias
			"return ((bson_error_t *) $a_pointer)->message;"
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
			"sizeof(bson_error_t)"
		end


end

