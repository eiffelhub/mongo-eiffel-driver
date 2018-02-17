note
	description: "[
		Object Representing MongoDB mongoc_client_t 
		It is an opaque type that provides access to a MongoDB server, replica set, or sharded cluster. 
		It maintains management of underlying sockets and routing to individual nodes based on mongoc_read_prefs_t or mongoc_write_concern_t.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name= Mongoc Client", "src=http://mongoc.org/libmongoc/current/mongoc_client_t.html", "protocol=uri"

class
	MONGODB_CLIENT

inherit

	MEMORY_STRUCTURE
		rename
			make as memory_make
		redefine
			make_by_pointer
		end

create
	make

feature {NONE}-- Initialization

	make (a_uri: STRING_8)
			-- Creates a new MongoClient using the URI string `a_uri' provided.
		do
			memory_make
			mongoc_init
			create uri_string.make_from_string (a_uri)
			new_mongoc_cient (a_uri)
		ensure
			uri_string_set: uri_string.same_string (a_uri)
		end

	make_by_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.share_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := True
		end

	new_mongoc_cient (a_uri: STRING_8)
			-- new mongodb client instance using the uri `a_uri'.
		local
			c_string: C_STRING
		do
			create c_string.make (a_uri)
			make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_new (c_string.item))
			check success: item /= default_pointer end
		end

feature {NONE} -- Init

	mongoc_init
			-- Required to initialize libmongoc's internals.
		do
			{MONGODB_EXTERNALS}.c_mongoc_init
		end

feature -- Access

	uri_string: STRING_8
			-- A string containing the MongoDB connection URI.		

	get_collection (a_db: STRING_8; a_colleciton: STRING): MONGODB_COLLECTION
			-- a_db: The name of the database containing the collection.
			-- a_collection: The name of the collection.
		local
			c_db: C_STRING
			c_collection: C_STRING
			l_ptr:  POINTER
		do
			create c_db.make (a_db)
			create c_collection.make (a_colleciton)
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_collection (item, c_db.item, c_collection.item)
			create Result.make_by_pointer (l_ptr)
		end

	get_database (a_dbname: STRING_8): MONGODB_DATABASE
				-- Get a new database MONGODB_DATABASE for the database named `a_dbname'.
		note
			EIS: "name=API get_database", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_database.html", "protocol=uri"
		local
			c_name: C_STRING
			l_ptr: POINTER
		do
			create c_name.make (a_dbname)
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_database (item, c_name.item)
			create Result.make_by_pointer (l_ptr)
		end

feature -- Error

	set_error_api (a_version: INTEGER)
			-- Configure how the C Driver reports errors
			-- a_version: version of the error API, either MONGOC_ERROR_API_VERSION_LEGACY or MONGOC_ERROR_API_VERSION_2.
		note
			EIS: "name=mongoc_client_set_error_api", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_error_api.html", "protocol=uri"
		require
			valid_version: a_version = {MONGODB_EXTERNALS}.mongoc_error_api_version_2 or else a_version = {MONGODB_EXTERNALS}.mongoc_error_api_version_legacy
		local
			l_res: BOOLEAN
		do
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_set_error_api (item, a_version)
		end

feature -- Change Element

	set_appname (a_name: STRING_32)
			-- Sets the application name 'a_name' for this client.
			-- This string, along with other internal driver details, is sent to the server as part of the initial connection handshake ('isMaster').
			--'a_name': The application name, of length at most {MONGODB_EXTERNALS}.MONGOC_HANDSHAKE_APPNAME_MAX
		note
			EIS: "name=mongoc_client_set_appname", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_appname.html", "protocol=uri"
		require
			is_valid_length: a_name.count <= {MONGODB_EXTERNALS}.MONGOC_HANDSHAKE_APPNAME_MAX
		local
			c_name: C_STRING
			l_res: BOOLEAN
		do
			create c_name.make (a_name)
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_set_appname (item, c_name.item)
		end

feature -- Command

	command_simple (a_db:STRING_8; a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCE; a_reply: BSON; a_error: detachable BSON_ERROR)
			-- This is a simplified interface to mongoc_client_command(). It returns the first document from the result cursor into reply. The client’s read preference, read concern, and write concern are not applied to the command.
			-- 'a_db': The name of the database to run the command on.
			-- 'a_command': A bson_t containing the command specification.
			-- 'a_read_prefs': An optional mongoc_read_prefs_t. Otherwise, the command uses mode MONGOC_READ_PRIMARY.
			-- 'reply': A location for the resulting document.
			--	a_error: An optional location for a bson_error_t or NULL
		note
			EIS: "name=mongoc_client_command_simple", "src=http://mongoc.org/libmongoc/current/mongoc_client_command_simple.html", "protocol=uri"
		local
			c_db: C_STRING
			l_res: BOOLEAN
			l_error: POINTER
			l_read_prefs:  POINTER
		do
			create c_db.make (a_db)

			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end

			if attached a_error then
				l_error := a_error.item
			end
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_command_simple (item, c_db.item, a_command.item, l_read_prefs, a_reply.item, l_error )
		end

	command_with_opts (a_db_name: STRING_8; a_command: BSON; a_read_prefs: detachable MONGODB_READ_PREFERENCE; a_opts:detachable BSON;  a_reply: BSON; a_error: detachable BSON_ERROR)
			-- Execute a command on the server, interpreting opts according to the MongoDB server version.
			-- 'a_db_name': The name of the database to run the command on.
			-- 'a_command': A bson_t containing the command specification.
			-- 'a_read_prefs': An optional mongoc_read_prefs_t.
			-- 'a_opts': A bson_t containing additional options.
			-- 'a_reply': A location for the resulting document.
			-- 'a_error': An optional location for a bson_error_t or NULL.	
		note
			EIS: "name=mongoc_client_command_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_command_with_opts.html", "protocol=uri"
		local
			c_db: C_STRING
			l_read_prefs: POINTER
			l_opts: POINTER
			l_error: POINTER
			l_res: BOOLEAN
		do
			create c_db.make (a_db_name)
			if attached a_read_prefs then
				l_read_prefs := a_read_prefs.item
			end
			if attached a_opts then
				l_opts := a_opts.item
			end
			if attached a_error then
				l_error := a_error.item
			end
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_command_with_opts (item, c_db.item, a_command.item, l_read_prefs, l_opts, a_reply.item, l_error)
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
			"return sizeof(mongoc_client_t *);"
		end

end
