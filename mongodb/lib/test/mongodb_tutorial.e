note
	description: "[
		The example below establishes a connection to a standalone server on localhost, registers the client application as 'connect-example', and performs a simple command.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=MongoDB Tutorial", "src=http://mongoc.org/libmongoc/current/tutorial.html", "protocol=uri"

class
	MONGODB_TUTORIAL


feature -- Tutorial

	tutorial_api
		local
			l_client: MONGODB_CLIENT
			l_database: MONGODB_DATABASE
			l_collection: MONGODB_COLLECTION
			l_command: BSON
			l_reply: BSON
			l_error: BSON_ERROR
			l_insert: BSON
		do
				-- Initialize and create a new mongobd client instance.
			create l_client.make ("mongodb://localhost:27017")

		     	-- Register the application name so we can track it in the profile logs
		     	-- on the server. This can also be done from the URI (see other examples).
		    l_client.set_appname ("connect_example")

		    	-- Get a handle on the database "db_name" and collection "coll_name"
			l_database := l_client.get_database ("db_name")
			l_collection := l_client.get_collection ("db_name", "coll_name")

				-- Do work. This example pings the database, prints the result as JSON and
				-- performs an insert

			create l_command.make
			l_command.bson_append_integer_32 ("ping", 1)
			create l_reply.make_empty
			create l_error
			l_client.command_simple ("db_name", l_command, Void, l_reply, l_error)

			print ("%NOperation: l_client.command_simple " + l_error.message)

			print ("%N bson output: " +l_reply.bson_as_json)

			create l_insert.make
			l_insert.bson_append_utf8 ("hello", "world")
			create l_error

			l_collection.insert_one (l_insert, Void, Void, l_error)

			print ("%NOperation l_collection.insert_one" + l_error.message)


		end

	tutorial_externals
			-- test how to make a connection.
		local
			l_uri: C_STRING
			l_client: POINTER
				-- mongoc_client_t *
			l_appname: C_STRING
			l_res: BOOLEAN
			l_database: POINTER
				-- mongoc_database_t *
			l_collection: POINTER
				-- mongoc_collection_t *
			l_dbname: C_STRING
			l_coll_name: C_STRING
			l_command: BSON
			l_retval: BOOLEAN
			l_admin: C_STRING
			l_reply: BSON
			l_error: BSON_ERROR
			l_insert: BSON
			l_opts: BSON
		do
				-- Initialize libmongodb.
			{MONGODB_EXTERNALS}.c_mongoc_init

				-- Create a new client instance.
			create l_uri.make ("mongodb://localhost:27017")
			l_client := {MONGODB_EXTERNALS}.c_mongoc_client_new (l_uri.item)

				--
				--	Register the application name so we can track it in the profile logs
				--	on the server. This can also be done from the URI (see other examples).
			create l_appname.make ("connect-example")
			l_res := {MONGODB_EXTERNALS}.c_mongoc_client_set_appname (l_client, l_appname.item)

				-- Get a handle on the database "db_name" and collection "coll_name"
			create l_dbname.make ("db_name")
			l_database := {MONGODB_EXTERNALS}.c_mongoc_client_get_database (l_client, l_dbname.item);
			create l_coll_name.make ("coll_name")
			l_collection := {MONGODB_EXTERNALS}.c_mongoc_client_get_collection (l_client, l_dbname.item, l_coll_name.item)
			check l_collection /= default_pointer end

				-- Do work. This example pings the database, prints the result as JSON and
				-- performs an insert
			create l_command.make
			l_command.bson_append_integer_32 ("ping", 1)

			create l_reply.make_empty
			create l_admin.make ("admin")
			create l_error
			l_retval := {MONGODB_EXTERNALS}.c_mongoc_client_command_simple (l_client, l_admin.item, l_command.item, default_pointer, l_reply.item, l_error.item)

			if not l_retval then
				print ("%N Failure: " + l_error.message)
			else
				print ("%N bson output: " +l_reply.bson_as_json)
			end


			create l_insert.make
			l_insert.bson_append_utf8 ("hello", "world")
			create l_error
			create l_opts.make
			l_retval := {MONGODB_EXTERNALS}.c_mongoc_collection_insert_one (l_collection, l_insert.item, l_opts.item, default_pointer, l_error.item)

			if not l_retval then
				print ("%N Failure: " + l_error.message)
			end
		end


feature -- Crud

	insert_document
		note
			EIS: "name=Insert a Document", "src=http://mongoc.org/libmongoc/current/tutorial.html#basic-crud-operations", "protocol=uri"
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_doc: BSON
			l_oid: BSON_OID
			l_error: BSON_ERROR
		do
			create l_client.make ("mongodb://localhost:27017/?appname=insert-example")
			l_collection := l_client.get_collection ("mydb", "mycoll")
			create l_doc.make
			create l_oid.make (Void)
			l_doc.bson_append_oid ("_id", l_oid)
			l_doc.bson_append_utf8 ("hello", "eiffel")

			create l_error
			l_collection.insert_one (l_doc, Void, Void, l_error)
			print ("Last Operation l_collection.insert_one: " + l_error.message)
		end

	find_documents
		note
			EIS: "name=Find a Document", "src=http://mongoc.org/libmongoc/current/tutorial.html#finding-a-document", "protocol=uri"
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_query: BSON
			l_cursor: MONGODB_CURSOR
			l_after: BOOLEAN
		do
			create l_client.make ("mongodb://localhost:27017/?appname=find-example")
			l_collection := l_client.get_collection ("mydb", "mycoll")
			create l_query.make
			l_cursor := l_collection.find_with_opts (l_query, Void, Void)

			from
			until
				l_after
			loop
				if attached l_cursor.next as l_bson then
					print (l_bson.bson_as_canonical_extended_json)
					print ("%N")
				else
					l_after := True
				end

			end
		end


	find_specific_document
		note
			EIS: "name=Find a Document", "src=http://mongoc.org/libmongoc/current/tutorial.html#finding-a-document", "protocol=uri"
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_query: BSON
			l_cursor: MONGODB_CURSOR
			l_after: BOOLEAN
		do
			create l_client.make ("mongodb://localhost:27017/?appname=find-example")
			l_collection := l_client.get_collection ("mydb", "mycoll")
			create l_query.make
			l_query.bson_append_utf8 ("hello", "eiffel")
			l_cursor := l_collection.find_with_opts (l_query, Void, Void)

			from
			until
				l_after
			loop
				if attached l_cursor.next as l_bson then
					print (l_bson.bson_as_canonical_extended_json)
					print ("%N")
				else
					l_after := True
				end

			end
		end

	update_document
		note
			EIS: "name=Updating a Document", "src=http://mongoc.org/libmongoc/current/tutorial.html#updating-a-document", "protocol=uri"
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_doc: BSON
			l_update: BSON
			l_query: BSON
			l_oid: BSON_OID
			l_error: BSON_ERROR
			l_subdoc: BSON
		do
			create l_client.make ("mongodb://localhost:27017/?appname=update-example")
			l_collection := l_client.get_collection ("mydb", "mycoll")
			create l_oid.make (Void)
			create l_doc.make
			l_doc.bson_append_oid ("_id", l_oid)
			l_doc.bson_append_utf8 ("key", "old_value")

			create l_error.default_create
			l_collection.insert_one (l_doc,Void, Void, l_error)

			create l_query.make
			l_query.bson_append_oid ("_id", l_oid)

			create l_subdoc.make
			l_subdoc.bson_append_utf8 ("key", "new_value")
			l_subdoc.bson_append_boolean ("updated", True)
			create l_update.make
			l_update.bson_append_document ("$set", l_subdoc)

			create l_error.default_create

			l_collection.update_one (l_query, l_update, Void, Void, l_error)

			print ("Last Operation : l_collection.update_one: " + l_error.message)
		end


	delete_document
		note
			EIS: "name=Deleting a Document", "src=http://mongoc.org/libmongoc/current/tutorial.html#deleting-a-document", "protocol=uri"
		local
			l_client: MONGODB_CLIENT
			l_collection: MONGODB_COLLECTION
			l_doc: BSON
			l_oid: BSON_OID
			l_error: BSON_ERROR
		do
			create l_client.make ("mongodb://localhost:27017/?appname=delete-example")
			l_collection := l_client.get_collection ("test", "test")
			create l_oid.make (Void)
			create l_doc.make
			l_doc.bson_append_oid ("_id", l_oid)
			l_doc.bson_append_utf8 ("hello", "world")

			create l_error
			l_collection.insert_one (l_doc, Void, Void, l_error)
			print ("Last Operation : l_collection.insert_one: " + l_error.message)


			create l_doc.make
			l_doc.bson_append_oid ("_id", l_oid)
			create l_error
			l_collection.delete_one (l_doc, Void, Void, l_error)
			print ("Last Operation : l_collection.delete_one: " + l_error.message)

		end


	count_documents
		note
			EIS: "name=Counting documents", "src=http://mongoc.org/libmongoc/current/tutorial.html#counting-documents", "protocol=uri"
		local
			l_client: MONGODB_CLIENT
			l_doc: BSON
			l_collection: MONGODB_COLLECTION
			l_error: BSON_ERROR
			l_count: INTEGER_64
		do
			create l_client.make ("mongodb://localhost:27017/?appname=delete-example")
			l_collection := l_client.get_collection ("mydb", "mycoll")
			create l_doc.make
			l_doc.bson_append_utf8 ("hello", "world")

			create l_error
			l_count := l_collection.count ((create {MONGODB_QUERY_FLAG}).mongoc_query_none, l_doc, 0, 0, Void, l_error)
			if l_count < 0 then
				print ("Error message: " + l_error.message)
			else
				print ("Number of documents:" + l_count.out)
			end
		end

end
