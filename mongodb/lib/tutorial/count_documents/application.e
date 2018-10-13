note
	description: "Example: show how to count documents "
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
			count_documents
		end

	count_documents
		local
			l_client: MONGODB_CLIENT
			l_doc: BSON
			l_collection: MONGODB_COLLECTION
			l_error: BSON_ERROR
			l_count: INTEGER_64
		do
			create l_client.make ("mongodb://localhost:27017/?appname=count-example")
			l_collection := l_client.collection ("mydb", "mycoll")
			create l_doc.make
			l_doc.bson_append_utf8 ("hello", "eiffel")
			create l_error.make
			l_count := l_collection.count ((create {MONGODB_QUERY_FLAG}).mongoc_query_none, l_doc, 0, 0, Void, l_error)
			if l_count < 0 then
				print ("Error message: " + l_error.message)
			else
				print ("Number of documents:" + l_count.out)
			end
		end

end
