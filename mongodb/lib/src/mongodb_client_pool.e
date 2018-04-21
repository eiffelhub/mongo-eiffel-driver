note
	description: "Object representing a connection pool for multi-threaded programs"
	date: "$Date$"
	revision: "$Revision$"

class
	MONGODB_CLIENT_POOL

inherit

	MEMORY_STRUCTURE
		rename
			make as memory_make
		end

create
	 make_own_from_pointer, make_from_uri

feature {NONE} -- Initialization

	make_own_from_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.own_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := False
		end

	make_from_uri (a_uri: MONGODB_URI)
			-- create a new pool using the uri `a_uri'.
		local
			l_ptr: POINTER
		do
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_pool_new (a_uri.item)
			make_own_from_pointer (l_ptr)
		end

feature -- Access

	has_pop: BOOLEAN
			-- was pop or try_pop called?	


	pop: MONGODB_CLIENT
			-- Retrieve a MONGODB_CLIENT from the client pool, possibly blocking until one is available.
		note
			EIS: "name=mongoc_client_pool_pop", "src=http://mongoc.org/libmongoc/current/mongoc_client_pool_pop.html", "protocol=uri"
		do
			has_pop := True
			create Result.make_own_from_pointer ({MONGODB_EXTERNALS}.c_mongoc_client_pool_pop (item))
		end

	try_pop: detachable MONGODB_CLIENT
			-- Retrieve a MONGODB_CLIENT from the client pool similar to pop, ecxcept it will return VOID instead of blocking for a client to become available.
		note
			EIS: "name=mongoc_client_pool_try_pop", "src=http://mongoc.org/libmongoc/current/mongoc_client_pool_try_pop.html", "protocol=uri"
		local
			l_ptr: POINTER
		do
			has_pop := True
			l_ptr := {MONGODB_EXTERNALS}.c_mongoc_client_pool_try_pop (item)
			if l_ptr /= default_pointer  then
				create Result.make_own_from_pointer (l_ptr)
			end
		end

	push (a_client: MONGODB_CLIENT)
			-- Return a MONGODB_CLIENT `a_client' to the client pool.
		do
			{MONGODB_EXTERNALS}.C_MONGOC_CLIENT_POOL_PUSH (item, a_client.item)
		end

feature -- Settings

	set_appname (a_name: READABLE_STRING_GENERAL)
			-- Set the application name `a_name' for this client.
			-- WARNING: MONGODB_CLIENT.set_appname can't be called on a client retrieved from a client pool.
			-- This function can only be called once on a pool, and must be called before the first call to `pop' or `try_pop'.
		note
			EIS: "name=mongoc_client_pool_set_appname","src=http://mongoc.org/libmongoc/current/mongoc_client_pool_set_appname.html", "protocol=uri"
		require
			is_valid_length: a_name.count <= {MONGODB_EXTERNALS}.MONGOC_HANDSHAKE_APPNAME_MAX
			not_pop: not has_pop
		local
			c_name: C_STRING
			l_res: BOOLEAN
		once
			create c_name.make (a_name)
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_pool_set_appname (item, c_name.item)
		end


	set_error_api (a_version: INTEGER)
			-- Configure how the C Driver reports errors
			-- a_version: version of the error API, either MONGOC_ERROR_API_VERSION_LEGACY or MONGOC_ERROR_API_VERSION_2.
			-- This function can only be called once on a pool, and must be called before the first call to `pop' or `try_pop'.
		note
			EIS: "name=mongoc_client_pool_set_error_api", "src=http://mongoc.org/libmongoc/current/mongoc_client_pool_set_error_api.html", "protocol=uri"
		require
			valid_version: a_version = {MONGODB_EXTERNALS}.mongoc_error_api_version_2 or else a_version = {MONGODB_EXTERNALS}.mongoc_error_api_version_legacy
			not_pop: not has_pop
		local
			l_res: BOOLEAN
		once
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_pool_set_error_api (item, a_version)
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
			"return sizeof(mongoc_client_pool_t *);"
		end



end
