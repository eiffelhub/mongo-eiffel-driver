note
	description: "Object Representing a MongoDB server description."
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=mongoc_server_description_t", "src=http://mongoc.org/libmongoc/current/mongoc_server_description_t.html", "protocol=uri"

class
	MONGODB_SERVER_DESCRIPTION

inherit

	MEMORY_STRUCTURE
		rename
			make as memory_make
		end

create
	 make_own_from_pointer

feature {NONE}-- Initialization

	make_own_from_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.own_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := False
		end


feature -- Factory

	new_copy: MONGODB_SERVER_DESCRIPTION
			-- A copy of the original server description.
		note
			EIS: "name=_mongoc_server_description_new_copy", "src=http://mongoc.org/libmongoc/current/mongoc_server_description_new_copy.html", "protocol=uri"
		do
			create Result.make_own_from_pointer ({MONGODB_EXTERNALS}.c_mongoc_server_description_new_copy (item))
		end

feature -- Access

	description_id: INTEGER_32
			-- Server's id.
		note
			EIS: "name=mongoc_server_description_id", "src=http://mongoc.org/libmongoc/current/mongoc_server_description_id.html", "protocol=uri"
		do
			Result := {MONGODB_EXTERNALS}.c_mongoc_server_description_id (item)
		end


	is_master: BSON
			-- A reference to a BSON document, owned by the server description. The document is empty if the driver is not connected to the server.
		note
			EIS: "name=mongoc_server_description_ismaster", "src= http://mongoc.org/libmongoc/current/mongoc_server_description_ismaster.html", "protocol=uri"
		do
			create Result.make_own_from_pointer ({MONGODB_EXTERNALS}.c_mongoc_server_description_ismaster (item))
		end

	round_trip_time: INTEGER_64
			-- Server's round trip time in milliseconds. This is the client's measurement of the duration of `ismaster` command.
		do
			Result := {MONGODB_EXTERNALS}.c_mongoc_server_description_round_trip_time (item)
		end

	description_type: STRING
			-- Return a servier type
		note
			EIS: "name=mongoc_server_description_type", "src=http://mongoc.org/libmongoc/current/mongoc_server_description_type.html", "protocol=uri"
		local
			l_cstring: C_STRING
		do
			create l_cstring.make_by_pointer ({MONGODB_EXTERNALS}.c_mongoc_server_description_type (item))
			Result := l_cstring.string
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
			"return sizeof(mongoc_server_description_t *);"
		end

end
