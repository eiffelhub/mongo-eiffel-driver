note
	description: "Summary description for {MONGODB_EXTERNALS}."
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=Mongodb API", "src=http://mongoc.org/libmongoc/current/api.html", "protocol=uri"
class
	MONGODB_EXTERNALS


feature -- Init

	c_mongoc_init
			-- Required to initialize libmongoc's internals
		external "C inline use <mongoc.h>"
		alias
			"mongoc_init();"
		end


feature -- Error

	MONGOC_ERROR_API_VERSION_LEGACY: INTEGER
		external "C inline use <mongoc.h>"
		alias
			"return MONGOC_ERROR_API_VERSION_LEGACY"
		end

	MONGOC_ERROR_API_VERSION_2: INTEGER
		external "C inline use <mongoc.h>"
		alias
			"return MONGOC_ERROR_API_VERSION_2"
		end

	MONGOC_HANDSHAKE_APPNAME_MAX: INTEGER
		external "C inline use <mongoc.h>"
		alias
			"return MONGOC_HANDSHAKE_APPNAME_MAX"
		end

feature -- Mongo Query Flags

 	MONGOC_QUERY_NONE: INTEGER
	 	external "C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_NONE"
		end

   MONGOC_QUERY_TAILABLE_CURSOR: INTEGER
   	 	external "C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_TAILABLE_CURSOR"
		end

   MONGOC_QUERY_SLAVE_OK: INTEGER
    	external "C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_SLAVE_OK"
		end

   MONGOC_QUERY_OPLOG_REPLAY: INTEGER
    	external "C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_OPLOG_REPLAY"
		end

   MONGOC_QUERY_NO_CURSOR_TIMEOUT: INTEGER
    	external "C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_NO_CURSOR_TIMEOUT"
		end

   MONGOC_QUERY_AWAIT_DATA: INTEGER
    	external "C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_AWAIT_DATA"
		end

   MONGOC_QUERY_EXHAUST: INTEGER
       	external "C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_EXHAUST"
		end

   MONGOC_QUERY_PARTIAL: INTEGER
       	external "C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_PARTIAL"
		end

feature -- Client

	c_mongoc_client_new (a_uri: POINTER): POINTER
			-- Create a new client instance with uri `a_uri'.
		external "C inline use <mongoc.h>"
		alias
			"return mongoc_client_new ((const char *)$a_uri);"
		end

	c_mongoc_client_set_appname	(a_client: POINTER; a_appname: POINTER): BOOLEAN
			-- Sets the application name for this client.
		external "C inline use <mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_client_set_appname ((mongoc_client_t *)$a_client, (const char *)$a_appname);"
		end

	c_mongoc_client_get_database(a_client: POINTER; a_name: POINTER): POINTER
			-- Get a newly allocated mongoc_database_t for the database named name.
		external "C inline use <mongoc.h>"
		alias
			"return mongoc_client_get_database ((mongoc_client_t *)$a_client, (const char *)$a_name);"
		end

	c_mongoc_client_get_default_database(a_client: POINTER): POINTER
			-- Get the database named in the MongoDB connection URI, or NULL if the URI specifies none.
			-- Useful when you want to choose which database to use based only on the URI in a configuration file.
		external "C inline use <mongoc.h>"
		alias
			"return mongoc_client_get_default_database ((mongoc_client_t*)$a_client);"
		end

	c_mongoc_client_get_collection(a_client: POINTER; a_db: POINTER; a_collection: POINTER): POINTER
			-- Get a newly allocated mongoc_collection_t for the collection named collection in the database named db.
		external "C inline use <mongoc.h>"
		alias
			"[
				return mongoc_client_get_collection ((mongoc_client_t *)$a_client,
                              (const char *)$a_db,
                              (const char *)$a_collection);

			]"
		end

	c_mongoc_client_command_simple (a_client: POINTER; a_dbname: POINTER; a_command: POINTER; a_read_prefs: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external "C inline use <mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_client_command_simple ((mongoc_client_t *)$a_client,
                              (const char *)$a_dbname,
                              (const bson_t *)$a_command,
                              (const mongoc_read_prefs_t *)$a_read_prefs,
                              (bson_t *)$a_reply,
                              (bson_error_t *)$a_error);
			]"
		end


	c_mongoc_client_set_error_api (a_client: POINTER; a_version: INTEGER): BOOLEAN
		external "C inline use <mongoc.h>"
		alias
			"return mongoc_client_set_error_api ((mongoc_client_t *)$a_client, (int32_t)$a_version);"
		end

	c_mongoc_client_command_with_opts (a_client: POINTER; a_db_name: POINTER; a_command: POINTER; a_read_prefs: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external "C inline use <mongoc.h>"
		alias
		"[
			return (EIF_BOOLEAN)	mongoc_client_command_with_opts (
							   (mongoc_client_t *)$a_client,
							   (const char *)$a_db_name,
							   (const bson_t *)$a_command,
							   (const mongoc_read_prefs_t *)$a_read_prefs,
							   (const bson_t *)$a_opts,
							   (bson_t *)$a_reply,
							   (bson_error_t *)$a_error);

		]"
		end

feature -- Mongo Collection

	c_mongoc_collection_insert_one (a_collection: POINTER; a_document: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external "C inline use <mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_collection_insert_one ((mongoc_collection_t *)$a_collection,
                              (const bson_t *)$a_document,
                              (const bson_t *)$a_opts,
                              (bson_t *)$a_reply,
                              (bson_error_t *)$a_error);

			]"
		end

	c_mongoc_collection_find_with_opts (a_collection: POINTER; a_filter: POINTER; a_opts: POINTER; a_read_prefs: POINTER): POINTER
		external "C inline use <mongoc.h>"
		alias
			"[
				return mongoc_collection_find_with_opts ((mongoc_collection_t *)$a_collection,
                                  (const bson_t *)$a_filter,
                                  (const bson_t *)$a_opts,
                                  (const mongoc_read_prefs_t *)$a_read_prefs)
  			]"
        end

	c_mongoc_collection_update_one (a_collection: POINTER; a_selector: POINTER; a_update: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external "C inline use <mongoc.h>"
		alias
			"[
			 return (EIF_BOOLEAN) mongoc_collection_update_one ((mongoc_collection_t *)$a_collection,
			                              (const bson_t *)$a_selector,
			                              (const bson_t *)$a_update,
			                              (const bson_t *)$a_opts,
			                              (bson_t *)$a_reply,
			                              (bson_error_t *)$a_error);
			                              ]"
		end

	c_mongoc_collection_delete_one (a_collection: POINTER; a_selector: POINTER; a_opts: POINTER; a_reply:POINTER; a_error: POINTER): BOOLEAN
		external "C inline use <mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN)  mongoc_collection_delete_one ((mongoc_collection_t *)$a_collection,
                              (const bson_t *)$a_selector,
                              (const bson_t *)$a_opts,
                              (bson_t *)$a_reply,
                              (bson_error_t *)$a_error);
              ]"
		end

	c_mongoc_collection_count (a_collection: POINTER; a_flags: INTEGER; a_query: POINTER; a_skip: INTEGER_64; a_limit: INTEGER_64; a_read_prefs: POINTER; a_error: POINTER): INTEGER_64
		external "C inline use <mongoc.h>"
		alias
			"[
				return (EIF_INTEGER_64)
				mongoc_collection_count ((mongoc_collection_t *)$a_collection,
			                         (mongoc_query_flags_t)$a_flags,
			                         (const bson_t *)$a_query,
			                         (int64_t)$a_skip,
			                         (int64_t)$a_limit,
			                         (const mongoc_read_prefs_t *)$a_read_prefs,
			                         (bson_error_t *)$a_error);			
			]"
		end

feature -- Cursor

	c_mongo_cursor_next (a_cursor: POINTER; a_bson: POINTER): BOOLEAN
		external "C inline use <mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_cursor_next ((mongoc_cursor_t *)$a_cursor, (const bson_t **)$a_bson);
			]"
		end
end
