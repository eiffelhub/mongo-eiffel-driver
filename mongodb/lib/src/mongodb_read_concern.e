note
	description: "[
		Object Representing a Read Concern abstraction
	The MONGODB_READ_CONCERN allows clients to choose a level of isolation for their reads. The default, MONGOC_READ_CONCERN_LEVEL_LOCAL, is right for the great majority of applications.
	You can specify a read concern on connection objects, database objects, or collection objects.

	Read Concern is only sent to MongoDB when it has explicitly been set by set_level to anything other than NULL.
	
	MONGOC_READ_CONCERN_LEVEL_LOCAL	Level local, the default.	3.2
	MONGOC_READ_CONCERN_LEVEL_MAJORITY	Level majority.	3.2
	MONGOC_READ_CONCERN_LEVEL_LINEARIZABLE	Level linearizable.	3.4
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_read_concern_t", "src=http://mongoc.org/libmongoc/current/mongoc_read_concern_t.html", "protocol=uri"

class
	MONGODB_READ_CONCERN

inherit

	MEMORY_STRUCTURE
		rename
			make as memory_make
		end

create
	make, make_own_from_pointer

feature {NONE} -- Initialization

	make
		do
			memory_make
			read_concern_new
		end

	make_own_from_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.own_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := False
		end

	read_concern_new
		note
			EIS: "name=mongoc_read_concern_new", "src=http://mongoc.org/libmongoc/current/mongoc_read_concern_new.html", "protocol=uri"
		local
			l_ptr: POINTER
		do
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_read_concern_new
			make_own_from_pointer (l_ptr)
		end

feature -- Status Report

	is_default: BOOLEAN
			-- Returns true if read_concern has not been modified from the default.
		note
			EIS: "name=mongoc_read_concern_is_default", "src=http://mongoc.org/libmongoc/current/mongoc_read_concern_is_default.html", "protocol=uri"
		do
			Result := {MONGODB_EXTERNALS}.c_mongoc_read_concern_is_default (item)
		end

feature -- Access

	level: detachable READABLE_STRING_8
			-- Returns the currently set read concern, if none Void.
		note
			EIS: "name=mongoc_read_concern_get_level", "src=http://mongoc.org/libmongoc/current/mongoc_read_concern_get_level.html", "protocol=uri"
		local
			c_string: C_STRING
			l_ptr: POINTER
		do
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_read_concern_get_level (item)
			if l_ptr /= default_pointer then
				create c_string.make_by_pointer (l_ptr)
				create {STRING_8} Result.make_from_string (c_string.string)
			end
		end

feature -- Change Element

	set_level (a_level: READABLE_STRING_GENERAL)
			-- Sets the read concern level with `a_level'
			-- Todo add precondition to verify that set level is a valid level.
		note
			EIS: "name=mongoc_read_concern_set_level", "src=http://mongoc.org/libmongoc/current/mongoc_read_concern_set_level.html", "protocol=uri"
		local
			l_string: C_STRING
			l_res: BOOLEAN
		do
			create l_string.make (a_level)
			l_res := {MONGODB_EXTERNALS}.c_mongoc_read_concern_set_level (item, l_string.item)
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
			"return sizeof(mongoc_read_prefs_t *);"
		end


end
