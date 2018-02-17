note
	description: "[
		Object representing the bson_decimal128_t structure.
		It represents the IEEE-754 Decimal128 data type.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_decimal128_t", "src=http://mongoc.org/libbson/current/bson_decimal128_t.html", "protocol=uri"
class
	BSON_DECIMAL_128

inherit
	MEMORY_STRUCTURE
		export
			{ANY} managed_pointer
		undefine
			default_create
		redefine
			make_by_pointer,
			managed_pointer
		end

create
	default_create, with_string

feature {NONE} -- Creation

	default_create
			-- Initialize an empty decimal structure,
		local
			res: INTEGER_32
		do
			make
		end

	with_string (a_string: STRING)
		require
			a_string /= Void
		local
			res: BOOLEAN
			c_str: C_STRING
		do
			create c_str.make (a_string)
			make
			res := c_bson_decimal128_from_string (c_str.item, item)
		end

	make_by_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.share_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := True
		end

feature -- Access

	high: INTEGER_64
		do
			Result := c_high (item)
		end

	low: INTEGER_64
		do
			Result := c_low (item)
		end

	to_string: STRING_32
		local
			l_string: C_STRING
		do
			create l_string.make_empty (128)
			c_bson_decimal128_to_string (item, l_string.item)
			Result := l_string.string
		end

feature -- Change Element

	set_high (a_val: INTEGER_64)
		do
			c_set_high (item, a_val)
		end

	set_low (a_val: INTEGER_64)
		do
			c_set_low (item, a_val)
		end

feature {ANY}

	managed_pointer: MANAGED_POINTER
			-- <Precursor>

feature {NONE} -- Implementation

	c_high( a_pointer: POINTER): INTEGER_64
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson.h>"
		alias
			"return ((bson_decimal128_t *) $a_pointer)->high;"
		end

	c_low( a_pointer: POINTER): INTEGER_64
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson.h>"
		alias
			"return ((bson_decimal128_t *) $a_pointer)->low;"
		end

	c_set_high( a_pointer: POINTER; a_val: INTEGER_64 )
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson.h>"
		alias
			"((bson_decimal128_t *) $a_pointer)->high = $a_val;"
		end

	c_set_low( a_pointer: POINTER; a_val: INTEGER_64)
		require p_not_null: a_pointer /= default_pointer
		external "C inline use <bson.h>"
		alias
			"((bson_decimal128_t *) $a_pointer)->low = $a_val;"
		end

	c_bson_decimal128_to_string (a_dec: POINTER; a_str: POINTER)
		external
			"C inline use <bson.h>"
		alias
			"[
				bson_decimal128_to_string ((const bson_decimal128_t *)$a_dec, (char *)$a_str);
				printf("%s\n", $a_str);
			]"
		end

	c_bson_decimal128_from_string (a_string: POINTER; a_dec: POINTER): BOOLEAN
		external
			"C inline use <bson.h>"
		alias
			"return bson_decimal128_from_string ((const char *)$a_string, (bson_decimal128_t *)$a_dec);"
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
