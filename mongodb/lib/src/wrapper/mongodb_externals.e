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
		external
			"C inline use <mongoc.h>"
		alias
			"mongoc_init();"
		end

feature -- Read Concern Levels		

	MONGOC_READ_CONCERN_LEVEL_LOCAL: STRING = "local"
			-- #define MONGOC_READ_CONCERN_LEVEL_LOCAL "local".

	MONGOC_READ_CONCERN_LEVEL_MAJORITY: STRING = "majority"
			-- #define MONGOC_READ_CONCERN_LEVEL_MAJORITY "majority".

	MONGOC_READ_CONCERN_LEVEL_LINEARIZABLE: STRING = "linearizable"
			-- #define MONGOC_READ_CONCERN_LEVEL_LINEARIZABLE "linearizable"

feature -- Error

	MONGOC_ERROR_API_VERSION_LEGACY: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_ERROR_API_VERSION_LEGACY"
		end

	MONGOC_ERROR_API_VERSION_2: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_ERROR_API_VERSION_2"
		end

	MONGOC_HANDSHAKE_APPNAME_MAX: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_HANDSHAKE_APPNAME_MAX"
		end

feature -- Read Preference Modes

	MONGOC_READ_PRIMARY: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_READ_PRIMARY"
		end

	MONGOC_READ_SECONDARY: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_READ_SECONDARY"
		end

	MONGOC_READ_PRIMARY_PREFERRED: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_READ_PRIMARY_PREFERRED"
		end

	MONGOC_READ_SECONDARY_PREFERRED: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_READ_SECONDARY_PREFERRED"
		end

	MONGOC_READ_NEAREST: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_READ_NEAREST"
		end

	MONGOC_NO_MAX_STALENESS: INTEGER_64
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_NO_MAX_STALENESS"
		end


Feature -- Mongo Query Flags

	MONGOC_QUERY_NONE: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_NONE"
		end

	MONGOC_QUERY_TAILABLE_CURSOR: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_TAILABLE_CURSOR"
		end

	MONGOC_QUERY_SLAVE_OK: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_SLAVE_OK"
		end

	MONGOC_QUERY_OPLOG_REPLAY: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_OPLOG_REPLAY"
		end

	MONGOC_QUERY_NO_CURSOR_TIMEOUT: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_NO_CURSOR_TIMEOUT"
		end

	MONGOC_QUERY_AWAIT_DATA: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_AWAIT_DATA"
		end

	MONGOC_QUERY_EXHAUST: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_EXHAUST"
		end

	MONGOC_QUERY_PARTIAL: INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"return MONGOC_QUERY_PARTIAL"
		end

feature -- Client

	c_mongoc_client_new (a_uri: POINTER): POINTER
			-- Create a new client instance with uri `a_uri'.
		external
			"C inline use <mongoc.h>"
		alias
			"return mongoc_client_new ((const char *)$a_uri);"
		end

	c_mongoc_client_new_from_uri (a_uri: POINTER): POINTER
			-- Create a new client instance with uri `a_uri'.
		external
			"C inline use <mongoc.h>"
		alias
			"return mongoc_client_new_from_uri ((const mongoc_uri_t *)$a_uri);"
		end

	c_mongoc_client_set_appname (a_client: POINTER; a_appname: POINTER): BOOLEAN
			-- Sets the application name for this client.
		external
			"C inline use <mongoc.h>"
		alias
			"return (EIF_BOOLEAN) mongoc_client_set_appname ((mongoc_client_t *)$a_client, (const char *)$a_appname);"
		end

	c_mongoc_client_get_database (a_client: POINTER; a_name: POINTER): POINTER
			-- Get a newly allocated mongoc_database_t for the database named name.
		external
			"C inline use <mongoc.h>"
		alias
			"return mongoc_client_get_database ((mongoc_client_t *)$a_client, (const char *)$a_name);"
		end

	c_mongoc_client_get_default_database (a_client: POINTER): POINTER
			-- Get the database named in the MongoDB connection URI, or NULL if the URI specifies none.
			-- Useful when you want to choose which database to use based only on the URI in a configuration file.
		external
			"C inline use <mongoc.h>"
		alias
			"return mongoc_client_get_default_database ((mongoc_client_t*)$a_client);"
		end

	c_mongoc_client_get_collection (a_client: POINTER; a_db: POINTER; a_collection: POINTER): POINTER
			-- Get a newly allocated mongoc_collection_t for the collection named collection in the database named db.
		external
			"C inline use <mongoc.h>"
		alias
			"[
								return mongoc_client_get_collection ((mongoc_client_t *)$a_client,
				                              (const char *)$a_db,
				                              (const char *)$a_collection);
			]"
		end

	c_mongoc_client_command_simple (a_client: POINTER; a_dbname: POINTER; a_command: POINTER; a_read_prefs: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
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
		external
			"C inline use <mongoc.h>"
		alias
			"return mongoc_client_set_error_api ((mongoc_client_t *)$a_client, (int32_t)$a_version);"
		end

	c_mongoc_client_command_with_opts (a_client: POINTER; a_db_name: POINTER; a_command: POINTER; a_read_prefs: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
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

	c_mongoc_client_get_database_names_with_opts (a_client: POINTER; a_opts: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
					   char **strv;
					   strv = mongoc_client_get_database_names_with_opts ($a_client, $a_opts, $a_error);
				 	   return strv;
			]"
		end

	c_mongoc_client_get_database_names_count (a_client: POINTER; a_opts: POINTER; a_error: POINTER): INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				char **strv;
				strv = mongoc_client_get_database_names_with_opts ($a_client, $a_opts, $a_error);
				int i;
				for (i = 0; strv[i]; i++);
				return i;
			]"
		end

	c_mongoc_client_get_uri (a_client: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_client_get_uri ((const mongoc_client_t *)$a_client);
			]"
		end

	c_mongoc_client_get_server_status (a_client: POINTER; a_read_prefs: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
		alias
			"[
								return (EIF_BOOLEAN) mongoc_client_get_server_status ((mongoc_client_t *)$a_client,
				                                 (mongoc_read_prefs_t *)$a_read_prefs,
				                                 (bson_t *)$a_reply,
				                                 (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_client_find_databases_with_opts (a_client: POINTER; a_opts: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
								return mongoc_client_find_databases_with_opts ((mongoc_client_t *)$a_client, (const bson_t *)$a_opts);

			]"
		end

	c_mongoc_client_get_read_concern (a_client: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
								return mongoc_client_get_read_concern ((const mongoc_client_t *)$a_client);

			]"
		end


	c_mongoc_client_get_read_prefs (a_client: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
								return mongoc_client_get_read_prefs ((const mongoc_client_t *)$a_client);

			]"
		end


	c_mongoc_client_set_read_concern (a_client: POINTER; a_read_concern: POINTER)
		external
			"C inline use <mongoc.h>"
		alias
			"[
								mongoc_client_set_read_concern ((mongoc_client_t *)$a_client, (const mongoc_read_concern_t *)$a_read_concern);

			]"
		end


	c_mongoc_client_set_read_prefs (a_client: POINTER; a_read_prefs:POINTER)
		external
			"C inline use <mongoc.h>"
		alias
			"[
								mongoc_client_set_read_prefs ((mongoc_client_t *)$a_client, (const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_client_get_server_descriptions (a_client: POINTER; a_size: TYPED_POINTER [INTEGER_64]): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
						size_t i, n;
						mongoc_server_description_t ** res;
						res = mongoc_client_get_server_descriptions ((const mongoc_client_t *)$a_client, &n);
						$a_size = n;
						return res;
			]"
		end

	c_mongoc_client_start_session (a_client: POINTER; a_opts: POINTER; a_error:POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
						return mongoc_client_start_session ((mongoc_client_t *)$a_client, (mongoc_session_opt_t *)$a_opts, (bson_error_t *)$a_error);

			]"
		end

feature -- Mongo Collection

	c_mongoc_collection_insert_one (a_collection: POINTER; a_document: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
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
		external
			"C inline use <mongoc.h>"
		alias
			"[
								return mongoc_collection_find_with_opts ((mongoc_collection_t *)$a_collection,
				                                  (const bson_t *)$a_filter,
				                                  (const bson_t *)$a_opts,
				                                  (const mongoc_read_prefs_t *)$a_read_prefs)
			]"
		end

	c_mongoc_collection_update_one (a_collection: POINTER; a_selector: POINTER; a_update: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
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

	c_mongoc_collection_delete_one (a_collection: POINTER; a_selector: POINTER; a_opts: POINTER; a_reply: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
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
		external
			"C inline use <mongoc.h>"
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

	c_mongoc_collection_drop_with_opts (a_collection: POINTER; a_opts: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
		alias
			"[
								return (EIF_BOOLEAN)  mongoc_collection_drop_with_opts ((mongoc_collection_t *)$a_collection,
				                                  (bson_t *)$a_opts,
				                                  (bson_error_t *)$a_error);
			]"
		end

feature -- Mongo Database

	c_mongoc_database_create_collection (a_database: POINTER; a_name: POINTER; a_opts: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
								return mongoc_database_create_collection ((mongoc_database_t *)$a_database,
				                                   (const char *)$a_name,
				                                   (const bson_t *)$a_opts,
				                                   (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_database_get_collection_names_with_opts (a_database: POINTER; a_opts: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
					   char **strv;
					   strv = mongoc_database_get_collection_names_with_opts  ($a_database, $a_opts, $a_error);
				 	   return strv;
			]"
		end

	c_mongoc_database_get_collection_names_count (a_database: POINTER; a_opts: POINTER; a_error: POINTER): INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				char **strv;
				strv = mongoc_database_get_collection_names_with_opts ($a_database, $a_opts, $a_error);
				int i;
				for (i = 0; strv[i]; i++);
				return i;
			]"
		end

	c_mongoc_database_has_collection (a_database: POINTER; a_name: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
		alias
			"[
							return (EIF_BOOLEAN) mongoc_database_has_collection ((mongoc_database_t *)$a_database,
				                                (const char *)$a_name,
				                                (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_database_drop_with_opts (a_database: POINTER; a_opts: POINTER; a_error: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
		alias
			"[
							return (EIF_BOOLEAN) mongoc_database_drop_with_opts ((mongoc_database_t *)$a_database,
				                                (const bson_t *)$a_opts,
				                                (bson_error_t *)$a_error);
			]"
		end

	c_mongoc_database_get_collection (a_database: POINTER; a_name: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_database_get_collection ((mongoc_database_t *)$a_database, (const char *)$a_name);
			]"
		end

	c_mongoc_database_get_name (a_database: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_database_get_name ((mongoc_database_t *)$a_database);	;
			]"
		end

feature -- Mongo Client Pool

	c_mongoc_client_pool_new (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_client_pool_new ((const mongoc_uri_t *)$a_uri);
			]"
		end

	c_mongoc_client_pool_pop (a_pool: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_client_pool_pop ((mongoc_client_pool_t *)$a_pool);
			]"
		end

	c_mongoc_client_pool_push (a_pool: POINTER; a_client: POINTER)
		external
			"C inline use <mongoc.h>"
		alias
			"[
				mongoc_client_pool_push ((mongoc_client_pool_t *)$a_pool, (mongoc_client_t *)$a_client);
			]"
		end

	c_mongoc_client_pool_try_pop (a_pool: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_client_pool_try_pop ((mongoc_client_pool_t *)$a_pool);
			]"
		end

	c_mongoc_client_pool_set_appname (a_pool: POINTER; a_name: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_client_pool_set_appname ((mongoc_client_pool_t *)$a_pool, (const char *)$a_name);
			]"
		end

	c_mongoc_client_pool_set_error_api (a_pool: POINTER; a_version: INTEGER): BOOLEAN
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_client_pool_set_error_api ((mongoc_client_pool_t *)$a_pool, (int32_t)$a_version);
			]"
		end

feature -- Cursor

	c_mongo_cursor_next (a_cursor: POINTER; a_bson: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_cursor_next ((mongoc_cursor_t *)$a_cursor, (const bson_t **)$a_bson);
			]"
		end

feature -- URI

	c_mongoc_uri_new (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_uri_new ((const char *)$a_uri);
			]"
		end

	c_mongoc_uri_copy (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_uri_copy ((const mongoc_uri_t *)$a_uri);
			]"
		end

	c_mongoc_uri_get_string (a_uri: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_uri_get_string ((const mongoc_uri_t *)$a_uri);
			]"
		end

feature -- Mongo Read Preference

	c_mongoc_read_prefs_new (a_read_mode: INTEGER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_new ((mongoc_read_mode_t)$a_read_mode);
			]"
		end

	c_mongoc_read_prefs_is_valid (a_read_prefs: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_read_prefs_is_valid ((const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_read_prefs_get_mode (a_read_prefs: POINTER): INTEGER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_get_mode ((const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_read_prefs_get_tags (a_read_prefs: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_get_tags ((const mongoc_read_prefs_t *)$a_read_prefs);
			]"
		end

	c_mongoc_read_prefs_set_mode (a_read_prefs: POINTER; a_mode: INTEGER)
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_set_mode ((mongoc_read_prefs_t *)$a_read_prefs,
                            (mongoc_read_mode_t)$a_mode);
			]"
		end

	c_mongoc_read_prefs_set_tags (a_read_prefs: POINTER; a_tags: POINTER)
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_set_tags ((mongoc_read_prefs_t *)$a_read_prefs,
                            (const bson_t *)$a_tags);
			]"
		end

	c_mongoc_read_prefs_set_max_staleness_seconds (a_read_prefs: POINTER; a_seconds: INTEGER_64)
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_read_prefs_set_max_staleness_seconds ((mongoc_read_prefs_t *)$a_read_prefs,
                                             (int64_t)$a_seconds);
			]"
		end

feature -- Mongo Read Concern

	c_mongoc_read_concern_new: POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_read_concern_new();
			]"
		end

	c_mongoc_read_concern_get_level (a_read_concern: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return (const char *) mongoc_read_concern_get_level ((const mongoc_read_concern_t *)$a_read_concern);
			]"
		end

	c_mongoc_read_concern_is_default (a_read_concern: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_read_concern_is_default ((mongoc_read_concern_t *)$a_read_concern);
			]"
		end

	c_mongoc_read_concern_set_level (a_read_concern: POINTER; a_level: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return (EIF_BOOLEAN) mongoc_read_concern_set_level ((mongoc_read_concern_t *)$a_read_concern,
	                              (const char *)$a_level);
			]"
		end


feature -- Mongo Server Description

	c_mongoc_server_description_id (a_description: POINTER): INTEGER_32
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return (EIF_INTEGER_32) mongoc_server_description_id ((const mongoc_server_description_t *)$a_description);
			]"
		end

	c_mongoc_server_description_ismaster (a_description: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_server_description_ismaster ((const mongoc_server_description_t *)$a_description);
			]"
		end

	c_mongoc_server_description_new_copy (a_description: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_server_description_new_copy ((const mongoc_server_description_t *)$a_description);
			]"
		end

	c_mongoc_server_description_round_trip_time (a_description: POINTER): INTEGER_64
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return (EIF_INTEGER_64) mongoc_server_description_round_trip_time ((const mongoc_server_description_t *)$a_description);
			]"
		end

	c_mongoc_server_description_type (a_description: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_server_description_type ((const mongoc_server_description_t *)$a_description);

			]"
		end

	c_mongoc_server_description_host (a_description: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_server_description_host ((const mongoc_server_description_t *)$a_description);

			]"
		end

feature -- MongoDB Session Options

	c_mongoc_session_opts_new: POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_session_opts_new();
			]"
		end


	c_mongoc_session_opts_get_causal_consistency (a_opts: POINTER): BOOLEAN
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return mongoc_session_opts_get_causal_consistency($a_opts);
			]"
		end

	c_mongoc_session_opts_set_causal_consistency (a_opts: POINTER; a_causal_consistency: BOOLEAN)
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return 	mongoc_session_opts_set_causal_consistency ((mongoc_session_opt_t *)$a_opts, (bool)$a_causal_consistency);	
			]"
		end

	c_mongoc_session_opts_clone (a_opts: POINTER): POINTER
		external
			"C inline use <mongoc.h>"
		alias
			"[
				return 	mongoc_session_opts_clone ((const mongoc_session_opt_t *)$a_opts);
			]"
		end

end
