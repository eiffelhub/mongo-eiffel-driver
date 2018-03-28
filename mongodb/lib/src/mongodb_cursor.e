note
	description: "[
		Object representing a Client-side cursor abstraction.
		
		mongoc_cursor_t provides access to a MongoDB query cursor. It wraps up the wire protocol negotiation required to initiate a query and retrieve an unknown number of documents.

		Cursors are lazy, meaning that no network traffic occurs until the first call to mongoc_cursor_next().

		At that point we can:

		Determine which host we’ve connected to with mongoc_cursor_get_host().
		Retrieve more records with repeated calls to mongoc_cursor_next().
		Clone a query to repeat execution at a later point with mongoc_cursor_clone().
		Test for errors with mongoc_cursor_error().
		Thread Safety
		mongoc_cursor_t is NOT thread safe. It may only be used from the thread it was created from.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	MONGODB_CURSOR

inherit

	MEMORY_STRUCTURE
		rename
			make as memory_make
		redefine
			make_by_pointer
		end

create
	make_by_pointer

feature {NONE} -- Initialization

	make_by_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.share_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := True
		end

feature

	next: detachable BSON
			-- 'a_bson': A location for a bson_t.
			--| This function returns true if a valid bson document was read from the cursor. Otherwise, false if there was an error or the cursor was exhausted.
			--| Errors can be determined with the mongoc_cursor_error() function.		
		note
			EIS: "name=mongoc_cursor_next", "src=http://mongoc.org/libmongoc/current/mongoc_cursor_next.html", "protocol=uri"
		local
			l_pointer: POINTER
		do

			if {MONGODB_EXTERNALS}.c_mongo_cursor_next (item, $l_pointer) then
				create Result.make_by_pointer (l_pointer)
			else
					-- cursor exhausted or error
			end
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
			"return sizeof(mongoc_cursor_t *);"
		end

end

