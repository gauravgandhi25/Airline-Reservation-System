$(document).ready(function() {
			$("#customerlist").html("");
			$("#textCustomerName").keyup(function()
					{
				
				var text=$("#textCustomerName").val();
						
						text = "customername="
							+ text;
														
						$
						.ajax({
							type : "GET",
							url : "GetCustomerNames",
							dataType : 'json',
							data : text,
							contentType : 'application/json',
							mimeType : 'application/json',
	
							success : function(data, textStatus, jqXHR) 
							{
								$("#customerlist").html("");
								if (data.data.length > 0) {
									var records = data.data;
									
									for ( var x in records) {
										var rec = records[x];
													//+ rec.flight_number
									$("#customerlist").append("<option value='" + 
                					rec.customer_name + "'></option>");
										
								//display error message
								
									}
									
								}
							},
						
							error : function(jqXHR, textStatus,errorThrown) {
							console.log("Something really bad happened "+ textStatus);
							
							}
						
						
							});
				});
		});

