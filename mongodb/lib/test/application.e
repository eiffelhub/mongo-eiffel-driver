note
	description: "test application root class"
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
----			test_connection
----			example_client
			tutorial
		end

	tutorial
		local
			l_tutorial: MONGODB_TUTORIAL
		do
			create l_tutorial
			l_tutorial.tutorial_api
			l_tutorial.insert_document
			l_tutorial.find_documents
			l_tutorial.find_specific_document
			l_tutorial.update_document
			l_tutorial.count_documents
		end

	example_client
		local
			ec: EXAMPLE_CLIENT
		do
			create ec.make
		end



end
