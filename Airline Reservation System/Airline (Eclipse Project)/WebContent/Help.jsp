
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
<title>Help Page</title>

<script type="text/javascript">
	$(document).ready(function() {
		$(document).ready(function() {
		});
	});
</script>


</head>
<body>
	<%@ include file="Header.jsp"%>
	<div class="container">
		<div class="row">
			<div class="col-md-8">
				<h3>Search Flight Details</h3>
				<p>Click on "Flight Details" tab in the top navigation menu</p>
				<p>Enter "Departure Airport Code" e.g DFW</p>
				<p>Enter "Arrival Airport Code" e.g SFO</p>
				<p>Click search flight details to get Flight Numbers, Departure
					Time and Arrival Time</p>
			</div>
			<div class="col-md-8" id="tab2">
				<h3>Search Available Seats</h3>
				<p>Enter "Flight Number" and "Travel Date"</p>
				<p>Click Search Availability Details to get seat availability
					along with time details</p>
			</div>
			<div class="col-md-8" id="tab2">
				<h3>Search Fare Details</h3>
				<p>Enter "Flight Number"</p>
				<p>Click Search Flight Details to get amount, fare code,
					restrictions</p>
			</div>

			<div class="col-md-8" id="tab2">
				<h3>Search Passenger Details</h3>
				<ol>
					<li>
						<h4>Search by flight number</h4>
						<p>Enter flight number and get details of all customers flying through that flight</p>
					</li>
					<li>
					<h4>Search by customer namer</h4>
					<p>Enter customer name and get details of all the flight reservations by this customer</p>
					</li>
				</ol>
			</div>

		</div>
	</div>

</body>
</html>


