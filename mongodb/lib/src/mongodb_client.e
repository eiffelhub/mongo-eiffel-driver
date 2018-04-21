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
		end

create
	make, make_own_from_pointer, make_from_uri

feature {NONE}-- Initialization

	make (a_uri: STRING_8)
			-- Creates a new MongoClient using the URI string `a_uri' provided.
		do
			memory_make
			mongoc_init
			new_mongoc_cient (a_uri)
		end

	make_from_uri (a_uri: MONGODB_URI)
		do
			memory_make
			mongoc_init
			make_own_from_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_new_from_uri (a_uri.item))
			check success: item /= default_pointer end
		end

	make_own_from_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.own_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := False
		end

	new_mongoc_cient (a_uri: STRING_8)
			-- new mongodb client instance using the uri `a_uri'.
		local
			c_string: C_STRING
		do
			create c_string.make (a_uri)
			make_own_from_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_new (c_string.item))
			check success: item /= default_pointer end
		end

feature {NONE} -- Init

	mongoc_init
			-- Required to initialize libmongoc's internals.
		do
			{MONGODB_EXTERNALS}.c_mongoc_init
		end

feature -- Error

	has_error: BOOLEAN
			-- Indicates that there was an error during the last operation
		do
			Result := attached error
		end

	error_string: STRING
			-- Output a related error message.
		require
			was_error: has_error
		do
			if attached {BSON_ERROR} error as l_error then
				Result := "[Code:" + l_error.code.out + "]" + " [Domain:"+ l_error.domain.out + "]" + " [Message:" + l_error.message + "]"
			else
				Result := "Unknown Error"
			end
		end

feature -- Access

	uri: MONGODB_URI
			-- Fetches the mongoc_uri_t used to create the client.
		do
			create Result.make_own_from_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_get_uri (item))
		end

	collection (a_db: STRING_8; a_colleciton: STRING): MONGODB_COLLECTION
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
			create Result.make_own_from_pointer (l_ptr)
		end

	database (a_dbname: STRING_8): MONGODB_DATABASE
				-- Get a new database MONGODB_DATABASE for the database named `a_dbname'.
		note
			EIS: "name=API get_database", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_database.html", "protocol=uri"
		local
			c_name: C_STRING
			l_ptr: POINTER
		do
			create c_name.make (a_dbname)
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_database (item, c_name.item)
			create Result.make_own_from_pointer (l_ptr)
		end

	database_names (a_opts: detachable BSON): LIST [STRING]
			-- This function queries the MongoDB server for a list of known databases
			-- a_opts: A bson document containing additional options.
		note
			EIS: "name=mongoc_client_get_database_names_with_opts ", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_database_names_with_opts.html", "protocol=uri"
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
			create l_error.default_create
			create l_res.default_create
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_database_names_with_opts (item, l_opts, l_error.item)
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_get_database_names_count (item, l_opts, l_error.item)
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

	default_database: detachable MONGODB_DATABASE
			-- Get the database named in the MongoDB connection URI, or VOID if the URI specifies none.
			-- Useful when you want to choose which database to use based only on the URI in a configuration file.
		note
			EIS: "name=mongoc_client_get_default_database", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_default_database.html", "protocol=uri"
		local
			l_ptr: POINTER
		do
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_default_database (item)
			if l_ptr /= default_pointer then
				create Result.make_own_from_pointer (l_ptr)
			end
		end

	find_databases_with_opts (a_opts: detachable BSON): MONGODB_CURSOR
				-- Fetches a cursor containing documents, each corresponding to a database on this MongoDB server.
		note
			EIS: "name=mongoc_client_find_databases_with_opts", "src=http://mongoc.org/libmongoc/current/mongoc_client_find_databases_with_opts.html", "protocol=uri"
		local
			l_opts: POINTER
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			create Result.make_own_from_pointer({MONGODB_EXTERNALS}.c_mongoc_client_find_databases_with_opts (item, l_opts))
		end


	read_concern: MONGODB_READ_CONCERN
				-- Retrieve the default read concern configured for the client instance.
				-- This Result should not be modified.
		note
			EIS: "name=mongoc_client_get_read_concern", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_read_concern.html", "protocol=uri"
		do
			create Result.make_own_from_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_get_read_concern (item))
		end

	read_preferences: MONGODB_READ_PREFERENCE
				-- Retrieves the default read preferences configured for the client instance.
				-- This result should not be modified
		note
			EIS: "name=mongoc_client_get_read_prefs", "src=http://mongoc.org/libmongoc/current/mongoc_client_get_read_prefs.html", "protocol=uri"
		do
			create Result.make_own_from_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_get_read_prefs (item))
		end

	server_descriptions: LIST [MONGODB_SERVER_DESCRIPTION]
			-- Return an array of server descriptions or empty until the clients connects.
		local
			l_size: INTEGER_64
			l_mgr: MANAGED_POINTER
			l_ptr: POINTER
			i: INTEGER
		do
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_get_server_descriptions (item, $l_size)
			create l_mgr.make_from_pointer (l_ptr, (l_size.as_integer_32)* c_sizeof (l_ptr))
			create {ARRAYED_LIST [MONGODB_SERVER_DESCRIPTION]} Result.make (l_size.as_integer_32)
			from
				i := 0
			until
				i = l_mgr.count
			loop
				Result.force (create {MONGODB_SERVER_DESCRIPTION}.make_own_from_pointer (l_mgr.read_pointer (i)))
				i := i + c_sizeof (l_ptr)
			end
		end

feature -- Status

	server_status (a_read_prefs: detachable MONGODB_READ_PREFERENCE): BSON
			-- query the current server status, return a bson document.
		local
			l_res: BOOLEAN
			l_reply: BSON
			l_error: BSON_ERROR
			l_prefs: POINTER
		do
			if attached a_read_prefs then
				l_prefs := a_read_prefs.item
			end
			create l_reply.make
			create l_error.default_create
			l_res :={MONGODB_EXTERNALS}.c_mongoc_client_get_server_status (item, l_prefs, l_reply.item, l_error.item)
			Result := l_reply
			if l_res then
				error := l_error
			else
				error := Void
			end
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

	set_read_concern (a_read_concern: MONGODB_READ_CONCERN)
			-- The default read concern is MONGOC_READ_CONCERN_LEVEL_LOCAL. This is the correct read concern for the great majority of applications.
			-- It is a programming error to call this function on a client from a mongoc_client_pool_t. For pooled clients, set the read concern with the MongoDB URI instead.
		note
			EIS: "name=mongoc_client_set_read_concern", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_read_concern.html", "protocol=uri"
		do
			{MONGODB_EXTERNALS}.c_mongoc_client_set_read_concern (item, a_read_concern.item)
		end


	set_read_preference (a_read_pref: MONGODB_READ_PREFERENCE)
			-- Sets the default read preferences to use with future operations
			-- The global default is to read from the replica set primary.
		note
			EIS: "name=mongoc_client_set_read_prefs ", "src=http://mongoc.org/libmongoc/current/mongoc_client_set_read_prefs.html", "protocol=uri"
		do
			{MONGODB_EXTERNALS}.c_mongoc_client_set_read_prefs (item, a_read_pref.item)
		end

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
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_command_simple (item, c_db.item, a_command.item, l_read_prefs, a_reply.item, l_error)
			if l_res then
				create error.make_own_from_pointer (l_error)
			else
				error := Void
			end
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

feature -- Session

	start_session (a_opts: detachable MONGODB_SESSION_OPT): MONGODB_CLIENT_SESSION
		local
			l_opts: POINTER
			l_error: BSON
			l_ptr: POINTER
		do
			if attached a_opts then
				l_opts := a_opts.item
			end
			create l_error.make
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_start_session (item, l_opts, l_error.item )
				-- TODO check if there was an error. check l_error.
			create Result.make_own_from_pointer (l_ptr)
		end

feature {NONE} -- Measurement

	error: detachable BSON_ERROR
			-- last error.

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

	c_sizeof (ptr: POINTER): INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return sizeof ($ptr)"
		end

end
