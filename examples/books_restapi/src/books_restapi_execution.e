note
	description: "[
				application execution
			]"
	date: "$Date: 2016-10-21 10:45:18 -0700 (Fri, 21 Oct 2016) $"
	revision: "$Revision: 99331 $"

class
	BOOKS_RESTAPI_EXECUTION

inherit

	WSF_ROUTED_EXECUTION
		redefine
			initialize
		end

	WSF_URI_HELPER_FOR_ROUTED_EXECUTION

	WSF_URI_TEMPLATE_HELPER_FOR_ROUTED_EXECUTION

	WSF_RESOURCE_HANDLER_HELPER
	
create
	make

feature {NONE} -- Initialization

	initialize
			-- Initialize current service.
		do
			Precursor
			initialize_router
		end

 	setup_router
 			--  Setup `router'
 		local
 			fhdl: WSF_FILE_SYSTEM_HANDLER
 		do
 				 -- uri/uri templates.
 			map_uri_agent ("/", agent handle_home_page, router.methods_GET)
 			map_uri_agent ("/books", agent handle_collection, router.methods_get_post)
 			map_uri_template_agent ("/books/{id}", agent handle_item, router.methods_get_put_delete)

 			create fhdl.make_hidden ("www")
 			fhdl.set_directory_index (<<"index.html">>)
 			router.handle ("/", fhdl, router.methods_GET)
 		end

 feature  -- Handle HTML pages

 	handle_home_page (req: WSF_REQUEST; res: WSF_RESPONSE)
 		do
 			handle_not_implemented ("Home page not implemented", req, res)
 		end

	handle_collection (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_books_mgr: BOOKS_MANAGER
		do
			if attached req.http_host as l_host then
				if req.is_get_request_method then
					create l_books_mgr.make (mongodb_client)
					compute_response_get_json (req, res, l_books_mgr.find_documents )
				elseif req.is_post_request_method  then
					if attached {BOOK} extract_data_from_json (req) as l_book then
							-- TODO handle errors.
						create l_books_mgr.make (mongodb_client)
						l_books_mgr.insert_document (l_book)
						if l_books_mgr.has_error then
							handle_internal_server_error ("{%"error%":%"Database Server Error:[" + l_books_mgr.error_message +"] %"}", req, res)
						else
							compute_response_post_json (req, res, l_book.to_json_string)
						end
					else
						handle_bad_request_response ("{%"error%":%"Error with form data: JSON form with the following pattern:%N { %"name%":%"...%", %"description%":%"...%",  %"image%":%"...%" }%"", req, res)
					end
				else
					handle_method_not_allowed_response ("{%"error%":%"The mehtod [" + req.request_method + "] is not allowed%"}" , req, res)
				end
 			else
 				handle_internal_server_error ("{%"error%":%"Internal Server Error: host not found%"}", req, res)
 			end
		end

	handle_item (req: WSF_REQUEST; res: WSF_RESPONSE)
		local
			l_books_mgr: BOOKS_MANAGER
		do
			if attached req.http_host as l_host then
					-- Get a document
				if req.is_get_request_method then
					if attached {WSF_STRING}  req.path_parameter ("id") as l_id then
						create l_books_mgr.make (mongodb_client)
						if attached l_books_mgr.find_doument_by_id (l_id.value) as l_result then
							compute_response_get_json (req, res, l_result)
						else
							handle_resource_not_found_response ("{%"error%":%"The document id [" + l_id.value +"] does not exist%"}", req, res)
						end
					end
					-- Delete a document
				elseif req.is_delete_request_method then
					if attached {WSF_STRING}  req.path_parameter ("id") as l_id then
						create l_books_mgr.make (mongodb_client)
						if  attached l_books_mgr.find_doument_by_id (l_id.value)  then
							l_books_mgr.delete_by_id (l_id.value)
							if l_books_mgr.has_error then
								handle_internal_server_error ("{%"error%":%"Database Server Error:[" + l_books_mgr.error_message +"] %"}", req, res)
							else
								compute_response_get_json (req, res, "{ %"result%":%"success%" }")
							end
						else
							handle_resource_not_found_response ("{ %"error%":%"The document id does not exist%", %"_id%": %"" + l_id.value +"%"}"  , req, res)
						end
					else
						handle_internal_server_error ("{%"error%":%"Internal Server Error: host not found%"}", req, res)
					end
				elseif req.is_put_request_method then
					if attached {WSF_STRING}  req.path_parameter ("id") as l_id then
						create l_books_mgr.make (mongodb_client)
						if attached l_books_mgr.find_doument_by_id (l_id.value) then
							if 	attached {BOOK} extract_data_from_json (req) as l_book then
								create l_books_mgr.make (mongodb_client)
								l_books_mgr.update_document (l_book)
								if l_books_mgr.has_error then
									handle_internal_server_error ("{%"error%":%"Database Server Error:[" + l_books_mgr.error_message +"] %"}", req, res)
								else
									compute_response_put_json (req, res, l_book.to_json_string)
								end
							else
								handle_bad_request_response ("{%"error%":%"Error with form data: JSON form with the following pattern:%N { %"_id%":%"..%", %"name%":%"...%", %"description%":%"...%",  %"image%":%"...%" }%"}", req, res)
							end
						else
							handle_resource_not_found_response ("{ %"error%":%"The document id does not exist%", %"_id%": %"" + l_id.value +"%"}"  , req, res)
						end
					else
					end
				end
			else
 				handle_internal_server_error ("{%"error%":%"Internal Server Error: host not found%"}", req, res)
 			end
		end

 feature -- Compute Response

 	compute_response_get (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
 		local
 			h: HTTP_HEADER
 			l_msg: STRING
 			hdate: HTTP_DATE
 		do
 			create h.make
 			create l_msg.make_from_string (output)
 			h.put_content_type_text_html
			h.put_content_length (l_msg.count)
 			if attached req.request_time as time then
 				create hdate.make_from_date_time (time)
 				h.add_header ("Date:" + hdate.rfc1123_string)
 			end
 			res.set_status_code ({HTTP_STATUS_CODE}.ok)
 			res.put_header_text (h.string)
 			res.put_string (l_msg)
 		end

 	compute_response_get_json (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
 		local
 			h: HTTP_HEADER
 			l_msg: STRING
 			hdate: HTTP_DATE
 		do
 			create h.make
 			create l_msg.make_from_string (output)
 			h.put_content_type_application_json
			h.put_content_length (l_msg.count)
 			if attached req.request_time as time then
 				create hdate.make_from_date_time (time)
 				h.add_header ("Date:" + hdate.rfc1123_string)
 			end
 			res.set_status_code ({HTTP_STATUS_CODE}.ok)
 			res.put_header_text (h.string)
 			res.put_string (l_msg)
 		end

 	 compute_response_post_json (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
 		local
 			h: HTTP_HEADER
 			l_msg: STRING
 			hdate: HTTP_DATE
 		do
 			create h.make
 			create l_msg.make_from_string (output)
 			h.put_content_type_application_json
			h.put_content_length (l_msg.count)
 			if attached req.request_time as time then
 				create hdate.make_from_date_time (time)
 				h.add_header ("Date:" + hdate.rfc1123_string)
 			end
 			res.set_status_code ({HTTP_STATUS_CODE}.created)
 			res.put_header_text (h.string)
 			res.put_string (l_msg)
 		end

 	 compute_response_put_json (req: WSF_REQUEST; res: WSF_RESPONSE; output: STRING)
 		local
 			h: HTTP_HEADER
 			l_msg: STRING
 			hdate: HTTP_DATE
 		do
 			create h.make
 			create l_msg.make_from_string (output)
 			h.put_content_type_application_json
			h.put_content_length (l_msg.count)
 			if attached req.request_time as time then
 				create hdate.make_from_date_time (time)
 				h.add_header ("Date:" + hdate.rfc1123_string)
 			end
 			res.set_status_code ({HTTP_STATUS_CODE}.ok)
 			res.put_header_text (h.string)
 			res.put_string (l_msg)
 		end

feature -- MongoDB

	mongodb_client: MONGODB_CLIENT
		do
				-- Initialize and create a new mongobd client instance.
			create Result.make ("mongodb://127.0.0.1:27017")

		     	-- Register the application name so we can track it in the profile logs
		     	-- on the server. This can also be done from the URI (see other examples).
		    Result.set_appname (app_name)
		end

	app_name: STRING = "books_restapi"

feature -- JSON

	extract_data_from_json (req: WSF_REQUEST): detachable BOOK
			-- Extract request form JSON data and build a object
			-- password view.
		local
			l_parser: JSON_PARSER
			l_name: STRING_32
			l_description: STRING_32
			l_image: STRING_32
		do
			create l_parser.make_with_string (retrieve_data (req))
			l_parser.parse_content
			if attached {JSON_OBJECT} l_parser.parsed_json_object as jv and then l_parser.is_parsed
			then
				if
					attached {JSON_STRING} jv.item ("name") as js_name and then
					attached {JSON_STRING} jv.item ("description") as js_description and then
					attached {JSON_STRING} jv.item ("image") as js_image
				then
		 			l_image := js_image.item
		 			l_name := js_name.item
		 			l_description := js_description.item
		 			if attached {JSON_STRING} jv.item ("_id") as l_id then
		 				create Result.make_with_id (l_id.item, l_name, l_description, l_image)
		 			else
						create Result.make (l_name, l_description, l_image)
					end
				end
			end
		end

end
