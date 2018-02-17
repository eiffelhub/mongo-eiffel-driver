note
	description: "[
		Object representing the bson_json_reader_t structure.
		It is used for reading a sequence of JSON documents and transforming them to bson_t documents.
		This can often be useful if you want to perform bulk operations that are defined in a file containing JSON documents.
		Tip: bson_json_reader_t works upon JSON documents formatted in MongoDB extended JSON format.
	]"
	date: "$Date$"
	revision: "$Revision$"
	EIS: "name=bson_json_reader_t", "src=http://mongoc.org/libbson/current/bson_json_reader_t.html", "protocol=uri"

class
	BSON_JSON_READER

inherit

	MEMORY_STRUCTURE
		rename
			make as memory_make
		redefine
			make_by_pointer
		end

create
	make

feature {NONE} -- Initialization

	make (a_filename: PATH)
		do
			create error
			make_by_pointer (bson_json_reader_new_from_file (a_filename, error))
		end

	make_by_pointer (a_ptr: POINTER)
			-- Initialize current with `a_ptr'.
		do
			create managed_pointer.share_from_pointer (a_ptr, structure_size)
			internal_item := a_ptr
			shared := True
		end

	bson_json_reader_new_from_file (a_file_name: PATH; a_error: BSON_ERROR): POINTER
		local
			l_filename: C_STRING
		do
			create l_filename.make (a_file_name.absolute_path.name)
			Result := c_bson_json_reader_new_from_file (l_filename.item, a_error.item)
		end

feature -- Operations

	bson_json_reader_read (a_bson: BSON)
		local
			l_res: INTEGER
		do
			from
				l_res := c_bson_json_reader_read (item, a_bson.item, error.item)
			until
				l_res = 0 or l_res= -1
			loop
				l_res := c_bson_json_reader_read (item, a_bson.item, error.item)
			end

		end

feature -- Error

	error: BSON_ERROR

feature -- Measurement

	structure_size: INTEGER
		external
			"C inline use <bson.h>"
		alias
			"return sizeof(bson_t);"
		end

feature {NONE} -- c EXTERNALS


	c_bson_json_reader_new_from_file (a_filename: POINTER; a_error: POINTER): POINTER
		external
			"C inline use <bson.h>"
		alias
			"return bson_json_reader_new_from_file ((const char *)$a_filename, (bson_error_t *)$a_error);"
		end

	c_bson_json_reader_read (a_reader: POINTER; a_bson: POINTER; a_error: POINTER): INTEGER
		external
			"C inline use <bson.h>"
		alias
			"return bson_json_reader_read ((bson_json_reader_t *)$a_reader, (bson_t *)$a_bson, (bson_error_t *)$a_error); "
		end


end
