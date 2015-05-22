
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
<title>Fare Details</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="myscript.js"></script>

</head>
<body>
	<%@ include file="Header.jsp"%>
	<div class="container">
		<%!public class FareDetails {
		String url = "jdbc:mysql://localhost:3306/airline";
		String username = "root";
		String password = "12345";

		Connection conn = null;
		PreparedStatement selectFlights = null;
		ResultSet res = null;

		public FareDetails(String flight_number) {
			try {

				conn = DriverManager.getConnection(url, username, password);
				String query = "select * from fare where flight_number='"
						+ flight_number + "'";
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
		<h4>Fare Details</h4><br>
		<form class="form-inline" method="get" action="FareDetails.jsp">
			<div class="form-group">
				<label for="textFlightNumber">Flight Number: </label> <input
					type="text" class="form-control" id="textFlightNumber"
					name="textFlightNumber" list="flightlist"
					placeholder="Enter Flight Number" required maxlength="4"
					minlength="2" pattern="[0-9]*"
					oninvalid="setCustomValidity('Enter flight number in proper format e.g 7530')"
					oninput="setCustomValidity('')">
			</div>
			<button type="submit" class="btn btn-primary" id="searchflightnumber">Search
				Fare Details</button>
		</form>
		<datalist id="flightlist" name="flightlist"> </datalist>
		<br>
		<%
			if (request.getParameter("textFlightNumber") == null)
				return;
			FareDetails f = new FareDetails(
					request.getParameter("textFlightNumber"));

			ResultSet r = f.getFlights();
			if (r.first() == false) {
		%>
		<div class="alert alert-warning animated pulse" role="alert">
			Details of fare for flight number <strong><%=request.getParameter("textFlightNumber")%>
			</strong> are not available.
		</div>
		<%
			return;
			} else {
				r.beforeFirst();
			}
		%>
		<div class="alert alert-info animated fadeIn" role="alert">
			Details of fare for flight number <strong><%=request.getParameter("textFlightNumber")%></strong>
			are as below
		</div>
		<table class="table table-hover table-bordered animated fadeIn">
			<tr>
				<th>Flight Number</th>
				<th>Amount</th>
				<th>Fare Code</th>
				<th>Restrictions</th>
			</tr>
			<%
				while (r.next()) {
			%>
			<tr>
				<td><%=r.getString("flight_number")%></td>
				<td>$ <%=r.getString("amount")%></td>
				<td><%=r.getString("fare_code")%></td>
				<td><%=r.getString("restrictions")%></td>
			</tr>
			<%
				}
			%>
		</table>
	</div>
</body>
</html>


