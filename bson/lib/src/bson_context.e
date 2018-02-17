note
	description: "Object representing BSON OID Generation Context."
	date: "$Date$"
	revision: "$Revision$"

class
	BSON_CONTEXT
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
			"sizeof(bson_context_t *)"
		end
end

