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

	BSON_WRAPPER_BASE
		rename
			make as memory_make
		end

create
	make, make_by_pointer

feature {NONE} -- Initialization

	make
			-- Create the default, thread-safe, bson_context_t for the process.
		local
			l_pointer: POINTER
		do
			l_pointer := c_bson_context_get_default
			make_by_pointer (l_pointer)
		end

feature -- Removal

	dispose
			-- <Precursor>
		do
			if shared then
				c_bson_context_destroy (item)
			else
				-- Memory managed by Eiffel.
			end
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

	c_bson_context_destroy (a_context: POINTER)
		external
			"C inline use <bson.h>"
		alias
			"bson_context_destroy ((bson_context_t *)$a_context);	"
		end

end

