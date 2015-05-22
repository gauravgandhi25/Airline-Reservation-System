<%@page import="java.sql.*"%>

<%
	Class.forName("com.mysql.jdbc.Driver");
%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Passenger Details</title>
</head>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="MyScript.js"></script>
<script src="customernames.js"></script>
<script type="text/javascript">
	$(document)
			.ready(
					function() {
						$("#searchCustomerName")
								.click(
										function() {

											var custName = $("input#textCustomerName").val();
											var dataString = "textCustomerName=" + custName;
											console.log(dataString);
											$
													.ajax({
														type : "GET",
														url : "CustomerFlightDetails",
														dataType : 'json',
														data : dataString,
														contentType : 'application/json',
														mimeType : 'application/json',

														//if received a response from the server
														success : function(data, textStatus, jqXHR) {
															var tabularData;
															if (data.data.length > 0) {
																tabularData = '<div class='+'"alert alert-info animated fadeIn"'+'role="'+'alert">'
																		+ 'Flight Details of customer <strong>'
																		+ custName + '</strong> are as below</div>'
																var records = data.data;
																tabularData += '<table class='+'"table table-hover table-bordered animated fadeIn">'
																		+ '<tr>'
																		+ '<th>Customer Name</th>'
																		+ '<th>Flight Number</th>'
																		+ '<th>Travel Date</th>'
																		+ '<th>Departure</th>'
																		+ '<th>Arrival</th>'
																		+ '<th>Departure Time</th>'
																		+ '<th>Seat Number</th>'
																		+ '<th>Customer Phone</th>' + '</tr>';
																for ( var x in records) {
																	var rec = records[x];
																	tabularData = tabularData + '<tr>' + '<td>'
																			+ rec.customer_name + '</td>' + '<td>'
																			+ rec.flight_number + '</td>' + '<td>'
																			+ rec.travel_date + '</td>' + '<td>'
																			+ rec.departure_airport_code + '</td>' + '<td>'
																			+ rec.arrival_airport_code + '</td>' + '<td>'
																			+ rec.departure_time + '</td>' + '<td>'
																			+ rec.seat_number + '</td>' + '<td>'
																			+ rec.customer_phone + '</td>' + '</tr>';
																}
																tabularData = tabularData + '</table>';
																$("#detailsTable").html(tabularData);
															}
															//display error message
															else {
																tabularData = '<div id='+'"details"'+' class="'+'alert alert-warning animated pulse"'+'role="'+'alert"'+'></div>';
																$("#detailsTable").html(tabularData);
																$("#details").html(
																		"Data is not available for the customer <strong>"
																				+ custName + "</strong>");
															}
														},

														//If there was no resonse from the server
														error : function(jqXHR, textStatus, errorThrown) {
															console.log("Something really bad happened " + textStatus);
															$("#details").html(jqXHR.responseText);
														},

														//capture the request before it was sent to server
														beforeSend : function(jqXHR, settings) {
															//adding some Dummy data to the request
															settings.data += "&dummyData=whatever";
															//disable the button until we get the response
															$('#myButton').attr("disabled", true);
														},

														//this is called after the response or error functions are finsihed
														//so that we can take some action
														complete : function(jqXHR, textStatus) {
															//enable the button 
															$('#myButton').attr("disabled", false);
														}
													});

										});
					});
</script>

<body>
	<%@ include file="Header.jsp"%>
	<%!public class Customers {
		String url = "jdbc:mysql://localhost:3306/airline";
		String username = "root";
		String password = "12345";

		Connection conn = null;
		PreparedStatement selectCustomers = null;
		ResultSet res = null;

		public Customers(String flight_number) {
			try {
				conn = DriverManager.getConnection(url, username, password);
				String query = "select * from seat_reservations where flight_number='"
						+ flight_number + "' order by seat_number";
				selectCustomers = conn.prepareStatement(query);
				System.out.println("Connection Succeded");

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		public ResultSet getCustomers() {
			try {
				res = selectCustomers.executeQuery();
			} catch (Exception e) {
				e.printStackTrace();
			}
			return res;
		}
	}%>

	<div class="container">
		<h4>Passenger Details</h4>
		<br>
		<ul class="nav nav-tabs" id=passengerTabs>
			<li role="presentation" class="active"><a data-toggle="tab"
				href="#searchbyflight">Search Passengers By Flight Number</a></li>
			<li role="presentation"><a data-toggle="tab"
				href="#searchbypassenger">Search Passengers By Name</a></li>
		</ul>
		<br>
		<div class="tab-content">
			<div class="container tab-pane active" id="searchbyflight">
				<form class="form-inline" method="get" action="PassengerDetails.jsp">
					<div class="form-group">
						<label for="textFlightNumber">Flight Number: </label> <input
							type="text" class="form-control" id="textFlightNumber"
							name="textFlightNumber" list="flightlist"
							placeholder="Enter Flight Number" required maxlength="4"
							minlength="3" pattern="[0-9]*"
							oninvalid="setCustomValidity('Enter flight number in proper format e.g 1500')"
							oninput="setCustomValidity('')">
					</div>
					<button type="submit" class="btn btn-primary"
						id="searchflightnumber">Search Customers</button>
				</form>
				<datalist id="flightlist" name="flightlist"></datalist>
				<br> <br>
				<%
					if (request.getParameter("textFlightNumber") != null) {

						Customers c = new Customers(
								request.getParameter("textFlightNumber"));
						ResultSet r = c.getCustomers();
						if (r.first() == false) {
				%>
				<div class="alert alert-warning animated pulse" role="alert">
					Passenger details for flight number <strong><%=request.getParameter("textFlightNumber")%>
					</strong> are not available.
				</div>
				<%
					} else {
							r.beforeFirst();
				%>
				<div class="alert alert-info animated fadeIn" role="alert">
					Passenger details for flight number <strong><%=request.getParameter("textFlightNumber")%></strong>
					are as below
				</div>
				<table class="table table-hover table-bordered animated fadeIn">
					<tr>
						<th>Travel Date</th>
						<th>Seat Number</th>
						<th>Customer Name</th>
						<th>Customer Phone</th>
					</tr>
					<%
						while (r.next()) {
					%>
					<tr>
						<td><%=r.getString("travel_date")%></td>
						<td><%=r.getString("seat_number")%></td>
						<td><%=r.getString("customer_name")%></td>
						<td><%=r.getString("customer_phone")%></td>
					</tr>
					<%
						}
					%>
				</table>
				<%
					}
					}
				%>
			</div>

			<div class="container tab-pane fade in" id="searchbypassenger">
				<form class="form-inline animated fadeIn" onsubmit="return false;">
					<div class="form-group">
						<label for="textCustomerName">Customer Name: </label> <input
							type="text" class="form-control" id="textCustomerName"
							name="textCustomerName" placeholder="Enter Customer Name"
							required maxlength="20" minlength="3" list="customerlist"
							oninvalid="setCustomValidity('Enter Customer Name')"
							oninput="setCustomValidity('')">
					</div>
					<button type="submit" class="btn btn-primary"
						id="searchCustomerName">Search Customers</button>
				</form>
				<datalist id="customerlist" name="flightlist"></datalist>
				<br>
				<div id="detailsTable"></div>
			</div>
		</div>
	</div>
</body>
</html>