note
	description: "Example: show how to update a document."
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit

	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			update_document
		end

	update_document
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
			l_collection := l_client.collection ("mydb", "mycoll")
				-- First we create a document
			create l_oid.make (Void)
			create l_doc.make
			l_doc.bson_append_oid ("_id", l_oid)
			l_doc.bson_append_utf8 ("key", "Hello Eiffel")
			create l_error.default_create
			l_collection.insert_one (l_doc, Void, Void, l_error)

				-- Update the document we just create
			create l_query.make
			l_query.bson_append_oid ("_id", l_oid)
			create l_subdoc.make
			l_subdoc.bson_append_utf8 ("key", "Hello MongoDB from Eiffel")
			l_subdoc.bson_append_boolean ("updated", True)
			create l_update.make
			l_update.bson_append_document ("$set", l_subdoc)
			create l_error.default_create
			l_collection.update_one (l_query, l_update, Void, Void, l_error)
		end

end
