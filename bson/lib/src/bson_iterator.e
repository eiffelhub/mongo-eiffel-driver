note
	description: "[
	Objec representing the 	bson_iter_t is a structure.
	It is used to iterate through the elements of a bson_t. It is meant to be used on the stack and can be discarded at any time as it contains no external allocation. 
	The contents of the structure should be considered private and may change between releases, however the structure size will not change.

	The bson_t MUST be valid for the lifetime of the iter and it is an error to modify the bson_t while using the iter.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_iter_t", "src=http://mongoc.org/libbson/current/bson_iter_t.html", "protocol=uri"

class
	BSON_ITERATOR

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

create default_create, make_by_pointer

feature {NONE} -- Creation

	default_create
			-- Initialize an empty iterator structure,
		local
			res: INTEGER_32
		do
			make
		end

	make_by_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.share_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := True
		end

feature -- Operations

	bson_iter_init (a_bson: BSON)
		local
			l_res: BOOLEAN
		do
			l_res := c_bson_iter_init (item, a_bson.item)
		end

	bson_iter_next: BOOLEAN
		local
			l_res: BOOLEAN
		do
			Result := c_bson_iter_next (item)
		end

	bson_iter_key: STRING_32
		local
			l_string: C_STRING
		do
			create l_string.make_by_pointer (c_bson_iter_key (item))
			create Result.make_from_string (l_string.string)
		end

feature {NONE} -- C externals

	c_bson_iter_init (a_iter: POINTER; a_bson: POINTER): BOOLEAN
		external "C inline use <bson.h>"
		alias
			"return bson_iter_init ((bson_iter_t *)$a_iter, (const bson_t *)$a_bson);"
		end

	c_bson_iter_next (a_iter: POINTER): BOOLEAN
		external "C inline use <bson.h>"
		alias
			"return bson_iter_next ((bson_iter_t *)$a_iter);	"
		end

	c_bson_iter_key (a_iter: POINTER): POINTER
		external "C inline use <bson.h>"
		alias
			"return bson_iter_key ((const bson_iter_t *)$a_iter);"
		end

feature {ANY}

	managed_pointer: MANAGED_POINTER
			-- <Precursor>

feature {NONE} -- Implementation

	structure_size: INTEGER
			-- Size to allocate (in bytes)
		do
			Result := struct_size
		end

	struct_size: INTEGER
		external
			"C inline use <bson.h>"
		alias
			"sizeof(bson_iter_t)"
		end

end
