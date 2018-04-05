note
	description: "[
			Object Representing the bson_context_t structure.
			This context is for generation of BSON Object IDs. 
			This context allows for specialized overriding of how ObjectIDs are generated based on the applications requirements. 
			For example, disabling of PID caching can be configured if the application cannot detect when a call to fork() has occurred.
		]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Bson Context", "src=http://mongoc.org/libbson/current/bson_context_t.html", "protocol=uri"

class
	BSON_CONTEXT
inherit

	MEMORY_STRUCTURE
		rename
			make as memory_make
		end

create
	make, make_own_from_pointer, make_default

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

	make_default
			-- Create the default, thread-safe, bson_context_t for the process.
		local
			l_pointer: POINTER
		do
			l_pointer := c_bson_context_get_default
			make_own_from_pointer (l_pointer)
		end


feature {NONE} -- Implementation

	c_bson_context_get_default: POINTER
		external
			"C inline use <bson.h>"
		alias
			"return bson_context_get_default();"
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
			"sizeof(bson_context_t *)"
		end
end

