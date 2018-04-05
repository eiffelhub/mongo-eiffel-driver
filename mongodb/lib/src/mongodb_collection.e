note
	description: "[
		Object representing a mongoc_collection_t structure.
		It provides access to a MongoDB collection. This handle is useful for actions for most CRUD operations, I.e. insert, update, delete, find, etc.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_collection_t", "src=http://mongoc.org/libmongoc/current/mongoc_collection_t.html", "protocol=uri"

class
	MONGODB_COLLECTION

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
		end

	make_own_from_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.own_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := False
		end

feature -- Access

	find_with_opts (a_filter: BSON; a_opts: detachable BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCE): MONGODB_CURSOR
			-- 'a_filter': A bson_t containing the query to execute.
			-- 'a_opts:' An optional bson_t query options, including sort order and which fields to return
			-- 'a_read_prefs': An optional reading preferences.
			-- Return a mongo cursor.
		note
			EIS: "name=mongoc_collection_find_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_collection_find_with_opts.html", "protocol=uri"
		local
			l_pointer: POINTER
			l_opts: POINTER
			l_read_prefs: POINTER
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end
			l_pointer := {MONGODB_EXTERNALS}.c_mongoc_collection_find_with_opts (item, a_filter.item, l_opts, l_read_prefs)
			create Result.make_own_from_pointer (l_pointer)
		end

	count (a_flags: INTEGER; a_query: BSON; a_skip: INTEGER_64; a_limit: INTEGER_64; a_read_prefs: detachable MONGODB_READ_PREFERENCE; a_error: detachable BSON_ERROR): INTEGER_64
			-- This feature shall execute a count query `a_query' on the current collection.
			-- 'a_flags': A mongoc_query_flags_t.
			-- 'a_query': A bson_t containing the query.
			-- 'a_skip': A int64_t, zero to ignore.
			-- 'a_limit': A int64_t, zero to ignore.
			-- 'a_read_prefs': An optional mongoc_read_prefs_t.
			-- 'a_error': An optional location for a bson_error_t.
		note
			EIS: "name=mongoc_collection_count", "src=http://mongoc.org/libmongoc/current/mongoc_collection_count.html", "protocol=uri"
		require
			is_valid_falg: (create {MONGODB_QUERY_FLAG}).is_valid_flag (a_flags)
		local
			l_read_prefs: POINTER
			l_error: POINTER
		do
			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end
			if attached a_error then
				l_error := a_error.item
			end
			Result := {MONGODB_EXTERNALS}.c_mongoc_collection_count (item, a_flags, a_query.item, a_skip, a_limit, l_read_prefs, l_error)
			if Result = -1 then
				last_execution := False
			else
				last_execution := True
			end
		end

feature -- Command

	insert_one (a_document: BSON; a_opts: detachable BSON; a_reply: detachable BSON; a_error: detachable BSON_ERROR)
			-- This feature shall insert document `a_document' into collection.
			-- a_document: A BSON document
			-- a_opts: An optional BSON containing additional options.
			-- a_reply: Optional. An uninitialized bson_t populated with the insert result.
			-- a_error: An optional location for a BSON_ERROR.
		note
			EIS: "name=mongoc_collection_insert_one", "src=http://mongoc.org/libmongoc/current/mongoc_collection_insert_one.html", "protocol=uri"
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: POINTER
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end
			if attached a_error then
				l_error := a_error.item
			end
			last_execution := {MONGODB_EXTERNALS}.c_mongoc_collection_insert_one (item, a_document.item, l_opts, l_reply, l_error)
		end

	update_one (a_selector: BSON; a_update: BSON; a_opts: detachable BSON; a_reply: detachable BSON; a_error: detachable BSON_ERROR)
			-- a_selector: A bson_t containing the query to match the document for updating.
			-- a_update: A bson_t containing the update to perform.
			-- a_opts: An optional bson_t containing additional options
			-- a_reply: Optional. An uninitialized bson_t populated with the update result.
			-- a_error: An optional location for a bson_error_t.
			-- This feature updates at most one document in collection that matches selector `a_selector'.
		note
			EIS: "name=mongoc_collection_update_one","src=http://mongoc.org/libmongoc/current/mongoc_collection_update_one.html", "protocol=uri"
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: POINTER
			l_res: BOOLEAN
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end
			if attached a_error then
				l_error := a_error.item
			end
			last_execution := {MONGODB_EXTERNALS}.c_mongoc_collection_update_one (item, a_selector.item, a_update.item, l_opts, l_reply, l_error)
		end

	delete_one (a_selector: BSON; a_opts: detachable BSON; a_reply: detachable BSON; a_error: detachable BSON_ERROR )
			-- a_selector: A bson_t containing the query to match documents.
			-- a_opts: An optional bson_t containing additional options.
			-- a_reply: Optional. An uninitialized bson_t populated with the delete result, or NULL.
			-- a_error: An optional location for a bson_error_t or NULL.
			-- This feature removes at most one document in the given collection that matches selector `a_selector'.		
		note
			EIS: "name=mongoc_collection_delete_one","src=http://mongoc.org/libmongoc/current/mongoc_collection_delete_one.html","protocol=uri"
		local
			l_opts: POINTER
			l_reply: POINTER
			l_error: POINTER
			l_res: BOOLEAN
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_reply then
				l_reply := a_reply.item
			end
			if attached a_error then
				l_error := a_error.item
			end
			last_execution := {MONGODB_EXTERNALS}.c_mongoc_collection_delete_one (item, a_selector.item, l_opts, l_reply, l_error)
		end

feature -- Status Report

	has_error: BOOLEAN
			-- Indicates that there was an error during the last operation
		do
			Result := last_execution
		end

feature {NONE} -- Implementation

	last_execution: BOOLEAN
			-- True if successful or false in other case, check the BSON_ERROR for details. 		

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
			"return sizeof(mongoc_collection_t *);"
		end


end
