
<%@page import="java.util.Calendar"%>
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
<title>Seat Availability</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="myscript.js"></script>
</head>
<body>
	<%@ include file="Header.jsp"%>
	<div class="container">
	
		<%!public class Availability {
		String url = "jdbc:mysql://localhost:3306/airline";
		String username = "root";
		String password = "12345";
		Connection conn = null;
		PreparedStatement selectFlights = null;
		ResultSet res = null;

		public Availability(String flight_number, String date) {
			try {

				conn = DriverManager.getConnection(url, username, password);
				String query = "select f.flight_number, f.travel_date, f.departure_time, f.arrival_time,total_number_of_seats-count(s.flight_number) AS Available_Seats"
						+ " from flight_instance f LEFT OUTER JOIN seat_reservations s ON f.flight_number=s.flight_number, airplane a"
						+ " where f.airplane_id=a.airplane_id"
						+ " AND f.travel_date='"
						+ date
						+ "'"
						+ " AND f.flight_number='"
						+ flight_number
						+ "'"
						+ " group by f.flight_number";
				
						System.out.println(query);
				selectFlights = conn.prepareStatement(query);
				System.out.println("Connection Succeded");

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		public ResultSet getFlights() {
			try {
				res = selectFlights.executeQuery();
			} catch (Exception e) {
				e.printStackTrace();
			}
			return res;
		}
	}%>
		<h4>Seat Availability</h4>
		<br>

		<form class="form-inline" method="get" action="Availability.jsp">
			<div class="form-group">
				<label for="textFlightNumber">Flight Number: </label> <input
					type="text" class="form-control" id="textFlightNumber"
					name="textFlightNumber" list="flightlist"
					placeholder="Enter Flight Number" required maxlength="4"
					minlength="3" pattern="[0-9]*"
					oninvalid="setCustomValidity('Enter flight number in proper format e.g 1500')"
					oninput="setCustomValidity('')"> &nbsp &nbsp <label
					for="textDate">Travel Date: </label> <input type="date"
					class="form-control" id="textDate" name="textDate"
					placeholder="Enter Travel Date" required>
			</div>
			<button type="submit" class="btn btn-primary" id="searchflightnumber">Search
				Availability Details</button>
		</form>
		<datalist id="flightlist" name="flightlist"></datalist>
		<br>
		<%
			if (request.getParameter("textFlightNumber") == null)
				return;
			Availability a = new Availability(
					request.getParameter("textFlightNumber"),
					request.getParameter("textDate"));

			ResultSet r = a.getFlights();
			if (r.first() == false) {
		%>
		<div class="alert alert-warning" role="alert">
			Details of seat availability for flight number <strong><%=request.getParameter("textFlightNumber")%>
			</strong> for date <strong><%=request.getParameter("textDate")%> </strong> are
			not available.
		</div>
		<%
			return;
			} else {
				r.beforeFirst();
			}
		%>
		<div class="alert alert-info" role="alert">
			Details of seat availability for flight number <strong><%=request.getParameter("textFlightNumber")%></strong>
			are as below
		</div>

		<table class="table table-hover table-bordered">
			<tr>
				<th>Flight Number</th>
				<th>Travel Date</th>
				<th>Departure Time</th>
				<th>Arrival Time</th>
				<th>Available Seats</th>
			</tr>
			<%
				while (r.next()) {
			%>
			<tr>
				<td><%=r.getString("flight_number")%></td>
				<td><%=r.getString("travel_date")%></td>
				<td><%=r.getString("departure_time")%></td>
				<td><%=r.getString("arrival_time")%></td>
				<td><%=r.getString("available_seats")%></td>
			</tr>
			<%
				}
			%>
		</table>
	</div>
	<%@ include file="Footer.jsp"%>
</body>
</html>


