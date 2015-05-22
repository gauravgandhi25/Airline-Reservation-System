$(document).ready(function() {
			$("#flightlist").html("");
			$("#textFlightNumber").keyup(function()
					{
				$("#flightlist").html("");
				var text=$("#textFlightNumber").val();
						
						text = "flightnumber="
							+ text;
														
						$
						.ajax({
							type : "GET",
							url : "GetFlightNumbers",
							dataType : 'json',
							data : text,
							contentType : 'application/json',
							mimeType : 'application/json',
	
							success : function(data, textStatus, jqXHR) 
							{
								$("#flightlist").html("");
								if (data.data.length > 0) {
									var records = data.data;
									
									for ( var x in records) {
										var rec = records[x];
													//+ rec.flight_number
									$("#flightlist").append("<option value='" + 
                					rec.flight_number + "'></option>");
		
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

