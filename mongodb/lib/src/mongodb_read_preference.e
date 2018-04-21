note
	description: "[
		Object representing a read preference abstraction
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_read_prefs_t", "src=http://mongoc.org/libmongoc/current/mongoc_read_prefs_t.html", "protocol=uri"

class
	MONGODB_READ_PREFERENCE

inherit

	MEMORY_STRUCTURE
		rename
			make as memory_make
		end

create
	 make_own_from_pointer

feature {NONE} -- Initialization

	make (a_read_mode: MONGODB_READ_MODE_ENUM)
		do
			memory_make
			read_prefs_new (a_read_mode)
		end

	make_own_from_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.own_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := False
		end

	read_prefs_new (a_read_mode:MONGODB_READ_MODE_ENUM)
			-- Creates a new mongoc_read_prefs_t using the mode specified.
		note
			EIS: "name=mongoc_read_prefs_new", "src=http://mongoc.org/libmongoc/current/mongoc_read_prefs_new.html", "protocol=uri"
		local
			l_ptr: POINTER
		do
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_read_prefs_new (a_read_mode.value)
			make_own_from_pointer (l_ptr)
		end

feature -- Access

	mode: MONGODB_READ_MODE_ENUM
			-- Fetches the MONGODB_READ_MODE_ENUM for the read preference.
		note
			EIS: "name=mongoc_read_prefs_get_mode", "src=http://mongoc.org/libmongoc/current/mongoc_read_prefs_get_mode.html", "protocol=uri"
		local
			l_value: INTEGER
		do
			create Result.make
			l_value := {MONGODB_EXTERNALS}.c_mongoc_read_prefs_get_mode (item)
			Result.set_value (l_value)
		end

	tags: BSON
			-- Fetches any read preference tags that have been registered.
		note
			EIS: "name=mongoc_read_prefs_get_tags", "src=http://mongoc.org/libmongoc/current/mongoc_read_prefs_get_tags.html", "protocol=uri"
		local
			l_ptr: POINTER
		do
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_read_prefs_get_tags (item)
			create Result.make_own_from_pointer (l_ptr)
		end

feature -- Change Element

	set_mode (a_mode: MONGODB_READ_MODE_ENUM)
			-- Sets the read preference mode with `a_mode'.
		note
			EIS: "name=mongoc_read_prefs_set_mode", "src=http://mongoc.org/libmongoc/current/mongoc_read_prefs_set_mode.html", "protocol=uri"
		do
			{MONGODB_EXTERNALS}.c_mongoc_read_prefs_set_mode (item, a_mode.value)
		end

	set_tags (a_tags: BSON)
			-- Sets the tags to be used for the read preference with `a_tags'.
		note
			EIS: "name=mongoc_read_prefs_set_tags", "src=http://mongoc.org/libmongoc/current/mongoc_read_prefs_set_tags.html", "protocol=uri"
		do
			{MONGODB_EXTERNALS}.c_mongoc_read_prefs_set_tags (item, a_tags.item)
		end

	set_max_staleness_seconds (a_seconds: INTEGER_64)
			-- Sets the maxStalenessSeconds to be used for the read preference.
			-- Clients estimate the staleness of each secondary, and select for reads only those secondaries whose estimated staleness is less than or equal to maxStalenessSeconds.
		require
			valid_max_staleness_seconds: a_seconds <= {MONGODB_EXTERNALS}.MONGOC_NO_MAX_STALENESS
		do
			{MONGODB_EXTERNALS}.c_mongoc_read_prefs_set_max_staleness_seconds (item, a_seconds)
		end

feature -- Status Report

	is_valid: BOOLEAN
			-- Performs a consistency check of read_prefs to ensure it makes sense and can be satisfied.
		note
			EIS: "name=mongoc_read_prefs_is_valid", "src=http://mongoc.org/libmongoc/current/mongoc_read_prefs_is_valid.html", "protocol=uri"
		do
			Result := {MONGODB_EXTERNALS}.c_mongoc_read_prefs_is_valid (item)
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
