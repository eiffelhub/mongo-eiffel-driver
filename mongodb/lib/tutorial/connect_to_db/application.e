note
	description: "Example: Connect to a MongoDB Database"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_client: MONGODB_CLIENT
			l_database: MONGODB_DATABASE
		do
				-- Initialize and create a new mongobd client instance.
			create l_client.make ("mongodb://127.0.0.1:27017")
			print ("Connected to the database successfully%N")

				-- Accessing a database
			l_database := l_client.database ("newDB")

				-- Exists collection "newCollection"?
			if l_database.has_collection ("newCollection") then
				print ("Collection newCollection exists%N")
			else
				print ("Collection newCollection does not exists%N")
			end
		end

end
