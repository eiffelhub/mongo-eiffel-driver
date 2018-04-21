note
	description: "Summary description for {MONGODB_CLIENT_SESSION}."
	date: "$Date$"
	revision: "$Revision$"

class
	MONGODB_CLIENT_SESSION


inherit

	MEMORY_STRUCTURE
		rename
			make as memory_make
		end

create
	make_own_from_pointer

feature {NONE} -- Initialization

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
			"return sizeof(mongoc_client_session_t *);"
		end

end
