note
	description: "[
		Object Representing a MongoDB Database Abstraction
		mongoc_database_t provides access to a MongoDB database. This handle is useful for actions a particular database object. It is not a container for mongoc_collection_t structures.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Mongo Database ", "src=http://mongoc.org/libmongoc/current/mongoc_database_t.html", "protocol=uri"
class
	MONGODB_DATABASE


inherit

	MONGODB_WRAPPER_BASE

create
	make_by_pointer

feature -- Removal

	dispose
		do
			if shared then
				c_mongoc_database_destroy (item)
			end
		end

feature -- Access

	collection_names (a_opts: detachable BSON): LIST [STRING]
			-- This function queries current database and  return a list of strings containing the names of all of the collections in database.
			-- a_opts: A bson document containing additional options.
		note
			EIS: "name=mongoc_database_get_collection_names_with_opts  ", "src=http://mongoc.org/libmongoc/current/mongoc_database_get_collection_names_with_opts.html", "protocol=uri"
		local
			l_error: BSON_ERROR
			l_ptr: POINTER
			i: INTEGER
			l_mgr: MANAGED_POINTER
			l_opts: POINTER
			l_res: INTEGER
			l_cstring: C_STRING
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			create l_res.default_create
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_database_get_collection_names_with_opts (item, l_opts, l_error.item)
			l_res := {MONGODB_EXTERNALS}.c_mongoc_database_get_collection_names_count (item, l_opts, l_error.item)
			create l_mgr.make_from_pointer (l_ptr, l_res* c_sizeof (l_ptr))
			create {ARRAYED_LIST [STRING]} Result.make (l_res)
			from
				i := 0
			until
				i = l_mgr.count
			loop
				create l_cstring.make_by_pointer (l_mgr.read_pointer (i))
				Result.force (l_cstring.string)
				i := i + c_sizeof (l_ptr)
			end
		end

	collection (a_name: READABLE_STRING_GENERAL): MONGODB_COLLECTION
			-- If the collection `a_name' does not exist create a new one.
		note
			EIS: "name=", "src=http://mongoc.org/libmongoc/current/mongoc_database_get_collection.html", "protocol=uri"
		local
			l_name: C_STRING
		do
			create l_name.make (a_name)
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_database_get_collection (item, l_name.item))
		end

	name: READABLE_STRING_8
			-- name of the database.
		note
			EIS: "name=mongoc_database_get_name", "src=http://mongoc.org/libmongoc/current/mongoc_database_get_name.html", "protocol=uri"
		local
			c_string: C_STRING
		do
			create c_string.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_database_get_name (item))
			Result := c_string.string
		end

feature -- Drop

	drop_with_opts (a_opts: detachable BSON)
			-- Drop a current a database on the MongoDB server.
		note
			EIS: "name=mongoc_database_drop_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_database_drop_with_opts.html", "protocol=uri"
		local
			l_error: BSON_ERROR
			l_opts: POINTER
			l_res: BOOLEAN
		do
			create l_error.make
			if attached a_opts then
				l_opts := a_opts.item
			end
			l_res := {MONGODB_EXTERNALS}.c_mongoc_database_drop_with_opts (item, l_opts, l_error.item)
		end

feature -- Status Report

	has_collection (a_name: READABLE_STRING_GENERAL): BOOLEAN
			-- Does collection `a_name' exist in the current database?
		note
			EIS: "name=mongoc_database_has_collection", "src=http://mongoc.org/libmongoc/current/mongoc_database_has_collection.html", "protocol=uri"
		local
			l_error: BSON_ERROR
			l_name: C_STRING
		do
			create l_error.make
			create l_name.make (a_name)
			Result := {MONGODB_EXTERNALS}.c_mongoc_database_has_collection (item, l_name.item, l_error.item)
		end

feature -- Collection

	create_collection (a_name: STRING_32; a_opts: detachable BSON): MONGODB_COLLECTION
			-- Creates a MONGODB_COLLECTION from the current database.
		local
			l_opts: POINTER
			l_error: BSON_ERROR
			l_name: C_STRING
		do
			create l_name.make (a_name)
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			create Result.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_database_create_collection (item, l_name.item, l_opts, l_error.item))
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
			"return sizeof(mongoc_database_t *);"
		end

	c_sizeof (ptr: POINTER): INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return sizeof ($ptr)"
		end

	c_mongoc_database_destroy (a_database: POINTER)
		external
			"C inline use <mongoc.h>"
		alias
			"mongoc_database_destroy ((mongoc_database_t *)$a_database);	"
		end

end
