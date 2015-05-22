
<%@page import="java.sql.* "%>

<%
	Class.forName("com.mysql.jdbc.Driver");
%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Flight Details</title>
<style type="text/css">
</style>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>

<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/js/bootstrap.min.js"></script>

<script type="text/javascript">
	$(document).ready(function() {
		$("#airportlist").html("");

		$("#textDepAirportCode, #textArrivalAirportCode").keyup(function() {
			$("#airportlist").html("");
			var text = $(this).val();
			text = "airportcode=" + text;
			$.ajax({
				type : "GET",
				url : "GetAirportCodes",
				dataType : 'json',
				data : text,
				contentType : 'application/json',
				mimeType : 'application/json',

				success : function(data, textStatus, jqXHR) {
					$("#airportlist").html("");
					if (data.data.length > 0) {
						var records = data.data;

						for ( var x in records) {
							var rec = records[x];

							$("#airportlist").append("<option value='" + rec.airport_code +"'></option>");
						}
					}
				},

				error : function(jqXHR, textStatus, errorThrown) {
					console.log("Something really bad happened " + textStatus);
				}

			});
		});

	});
</script>



</head>
<body>
	<%@ include file="Header.jsp"%>
	<div class="container">
		<%!public class Flight {
		String url = "jdbc:mysql://localhost:3306/airline";
		String username = "root";
		String password = "12345";
		boolean data_available_flag = false;
		Connection conn = null;
		PreparedStatement selectFlights = null;
		PreparedStatement selectFlights_2 = null;
		PreparedStatement selectFlights_3 = null;

		int maxstops;
		String dep, arr;
		ResultSet[] res = new ResultSet[3];

		public Flight(String d, String a, String m) {
			try {

				maxstops = Integer.parseInt(m);
				conn = DriverManager.getConnection(url, username, password);
				dep = d;
				arr = a;
				String query_1stop = "select flight_number,departure_time,arrival_time,travel_date,airline,weekdays,TIMEDIFF(arrival_time,departure_time) AS total_journey from flight_instance natural join flight"
						+ " where departure_airport_code='"
						+ d
						+ "' AND arrival_airport_code='"
						+ a
						+ "' order by departure_time";
				selectFlights = conn.prepareStatement(query_1stop);

				if (maxstops > 1) {
					String query_2stop = "select f1.flight_number as f1_number,f1.departure_time AS f1_departure,f1.arrival_time AS f1_arrival,TIMEDIFF(f1.arrival_time,f1.departure_time) AS f1_time,f1.arrival_airport_code As via,"
							+ " f2.departure_time as f2_departure,f2.arrival_time as f2_arrival, TIMEDIFF(f2.arrival_time,f2.departure_time) AS f2_time,"
							+ " f2.flight_number as f2_number,f1.weekdays AS f1_weekdays,f2.weekdays AS f2_weekdays,"
							+ " TIMEDIFF(f2.arrival_time,f1.departure_time) AS total_journey"
							+ " from (select * from flight_instance natural join flight) f1, (select * from flight_instance natural join flight) f2"
							+ " where f1.departure_airport_code='"
							+ d
							+ "' AND f2.arrival_airport_code='"
							+ a
							+ "'"
							+ " AND f1.arrival_airport_code=f2.departure_airport_code"
							+ " AND TIMEDIFF(f2.departure_time,f1.arrival_time)>'00:59:59'";
					System.out.println(query_2stop);
					selectFlights_2 = conn.prepareStatement(query_2stop);
				}
				if (maxstops > 2) {

					String query_3stop = "select f1.flight_number as f1_number,f1.departure_time AS f1_dep,f1.arrival_time AS f1_arrival,TIMEDIFF(f1.arrival_time,f1.departure_time) AS f1_time,"
							+ " f1.arrival_airport_code As via_1,"
							+ " f2.departure_time as f2_dep,f2.arrival_time as f2_arrival, TIMEDIFF(f2.arrival_time,f2.departure_time) AS f2_time,"
							+ " f2.flight_number as f2_number,"
							+ " f2.arrival_airport_code As via_2,"
							+ " f3.flight_number as f3_number,f3.departure_time AS f3_dep,f3.arrival_time AS f3_arrival,TIMEDIFF(f3.arrival_time,f3.departure_time) AS f3_time,"
							+ " TIMEDIFF(f3.arrival_time,f1.departure_time) AS total_journey,"
							+ " f1.weekdays as f1_days, f2.weekdays as f2_days, f3.weekdays as f3_days"
							+ " from (select * from flight_instance natural join flight) f1, (select * from flight_instance natural join flight) f2,(select * from flight_instance natural join flight) f3"
							+ " where f1.departure_airport_code='"
							+ d
							+ "' AND f3.arrival_airport_code='"
							+ a
							+ "'"
							+ " AND f1.arrival_airport_code=f2.departure_airport_code"
							+ " AND f2.arrival_airport_code=f3.departure_airport_code"
							+ " AND TIMEDIFF(f2.departure_time,f1.arrival_time)>'00:59:59'"
							+ " AND TIMEDIFF(f3.departure_time,f2.arrival_time)>'00:59:59'"
							+ " AND NOT f1.arrival_airport_code='"
							+ a
							+ "'"
							+ " AND NOT f2.arrival_airport_code='"
							+ a
							+"'"
							+ " AND NOT f2.departure_airport_code='"
							+ d
							+ "'"
							+ " AND NOT f3.departure_airport_code='" + d + "'";

					System.out.println(query_3stop);
					selectFlights_3 = conn.prepareStatement(query_3stop);
				}

			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		public ResultSet[] getFlights() {
			try {
				res[0] = selectFlights.executeQuery();
				if (maxstops > 1) {
					res[1] = selectFlights_2.executeQuery();
				}
				if (maxstops > 2) {
					res[2] = selectFlights_3.executeQuery();
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
			return res;
		}

		public String getWeekdays(String s) {
			String weekdays = s;
			StringBuilder days = new StringBuilder("");

			if (weekdays.contains("Mon"))
				days.append(" Monday");
			if (weekdays.contains("Tue"))
				days.append(" Tuesday");
			if (weekdays.contains("Wed"))
				days.append(" Wednesday");
			if (weekdays.contains("Thu"))
				days.append(" Thursday");
			if (weekdays.contains("Fri"))
				days.append(" Friday");
			if (weekdays.contains("Sat"))
				days.append(" Saturday");
			if (weekdays.contains("Sun"))
				days.append(" Sunday");
			if (days.length() == 57)
				days.replace(0, 57, "All Days");

			return days.toString();
		}

	}%>
		<h4>Flight Details</h4>
		<br>
		<form class="form-inline" method="get" action="FlightDetails.jsp">
			<div class="form-group">
				<label for="textDepAirportCode">Departure Airport Code: </label> <input
					type="text" class="form-control" id="textDepAirportCode"
					name="textDepAirportCode" placeholder="Departure Airport Code"
					required maxlength="3" list="airportlist" minlength="3"
					pattern="[A-z][A-z][A-z]"
					oninvalid="setCustomValidity('Min/Max Length: 3 characters. Please enter only characters e.g DFW')"
					oninput="setCustomValidity('')"> <label
					for="textArrivalAirportCode">&nbsp &nbsp Arrival Airport
					Code: </label> <input type="text" class="form-control"
					id="textArrivalAirportCode" name="textArrivalAirportCode"
					placeholder="Arrival Airport Code" required maxlength="3"
					list="airportlist" minlength="3" pattern="[A-z][A-z][A-z]"
					oninvalid="setCustomValidity('Min/Max Length: 3 characters. Please enter only characters e.g DFW')"
					oninput="setCustomValidity('')"> &nbsp&nbsp<label>Maximum
					Stops:</label> <label class=".radio-inline"> <input type="radio"
					name="maxstops" id="maxstops1" value="1" checked> nonstop
				</label> <label class=".radio-inline"> <input type="radio"
					name="maxstops" id="maxstops2" value="2"> 1
				</label> <label class=".radio-inline"> <input type="radio"
					name="maxstops" id="maxstops3" value="3"> 2
				</label> &nbsp&nbsp

			</div>
			<button type="submit" class="btn btn-primary" id="searchflights"
				data-toggle="tooltip" data-placement="bottom"
				title="Tooltip on bottom">Search Details</button>
		</form>

		<datalist id="airportlist" name="flightlist"> </datalist>
		<br>

		<%
			if (request.getParameter("textDepAirportCode") == null)
				return;
			Flight f = new Flight(request.getParameter("textDepAirportCode"),
					request.getParameter("textArrivalAirportCode"),
					request.getParameter("maxstops"));

			ResultSet res[] = f.getFlights();
			ResultSet r = res[0];
			if (r.first() == false) {
		%>
		<%
			} else {
				r.beforeFirst();
				f.data_available_flag = true;
		%>

		<div class="alert alert-info animated fadeIn" role="alert">
			Details of <u><i>direct</i></u> flights from <strong><%=request.getParameter("textDepAirportCode")%></strong>
			to <strong><%=request.getParameter("textArrivalAirportCode")%></strong>
			are as below
		</div>
		<%
			while (r.next()) {
					String s = r.getString("weekdays");
					String days = f.getWeekdays(s);
		%>
		<div class="flightdetails animated bounceInRight">
			<div class="flight_icon"></div>
			<div class="flightdata">
				<div class="time">
					Departure<br> <span style="font-size: 20px; color: #0066FF;"><td><%=r.getString("departure_time")%></span>
				</div>
				<div class="data">
					<span style="font-size: 14px; color: #8B8B8B;">Flight
						Number: <%=r.getString("flight_number")%>
						&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Airline: <%=r.getString("airline")%>
						&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp Total Journey: <%=r.getString("total_journey")%>
						<br> <span style="font-size: 18px; color: #FF6600;"><%=f.dep.toUpperCase()%>
							---> <%=f.arr.toUpperCase()%> </span> <br> <span
						style="font-size: 14px; color: #009933;"><%=days%></span>
				</div>
				<div class="time">
					Arrival<br> <span style="font-size: 20px; color: #0066FF;"><%=r.getString("arrival_time")%></span>
				</div>
			</div>
		</div>
		<%
			}
			}
			if (f.maxstops > 1) {
				ResultSet rs = res[1];
				if (rs.first() == false) {
		%>
		<%
			} else {
					rs.beforeFirst();
					f.data_available_flag = true;
		%>
		<br>
		<div class="alert alert-info animated fadeIn" role="alert">
			Details of flights from <strong><%=request.getParameter("textDepAirportCode")%></strong>
			to <strong><%=request.getParameter("textArrivalAirportCode")%></strong>
			via <u><i>one stop</i></u> are as below
		</div>
		<%
			while (rs.next()) {
						String days1 = rs.getString("f1_weekdays");
						String days2 = rs.getString("f2_weekdays");
						StringBuilder days = new StringBuilder("");

						if (days1.contains("Mon") && days2.contains("Mon"))
							days.append(" Monday");

						if (days1.contains("Tue") && days2.contains("Tue"))
							days.append(" Tuesday");

						if (days1.contains("Wed") && days2.contains("Wed"))
							days.append(" Wednesday");

						if (days1.contains("Thu") && days2.contains("Thu"))
							days.append(" Thursday");

						if (days1.contains("Fri") && days2.contains("Fri"))
							days.append(" Friday");

						if (days1.contains("Sat") && days2.contains("Sat"))
							days.append(" Saturday");

						if (days1.contains("Sun") && days2.contains("Sun"))
							days.append(" Sunday");

						if (days.length() == 57)
							days = new StringBuilder("All Days");
		%>

		<div class="flightdetails animated bounceInRight exht">
			<div class="flight_icon"></div>
			<div class="flightdata exht">
				<div class="time exht">
					Departure<br> <span style="font-size: 20px; color: #0066FF;"><%=rs.getString("f1_departure")%></span>
				</div>
				<div class="data exht">
					<span style="font-size: 14px; color: #8B8B8B;">Flight
						Number: <%=rs.getString("f1_number")%>&nbsp&nbsp <span
						style="font-size: 18px; color: #FF6600;"><%=f.dep.toUpperCase()%>
							---> <%=rs.getString("via")%> </span> <span
						style="font-size: 14px; color: #8B8B8B;">&nbsp&nbsp arrives
							at <%=rs.getString("f1_arrival")%> <i>(<%=rs.getString("f1_time").substring(0, 2)
								+ "h "
								+ rs.getString("f1_time").substring(3, 5) + "m"%>)
						</i>
					</span> <br> <span style="font-size: 14px; color: #8B8B8B;">Flight
							Number: <%=rs.getString("f2_number")%>&nbsp&nbsp
					</span> <span style="font-size: 14px; color: #8B8B8B;"> <span
							style="font-size: 18px; color: #FF6600;"><%=rs.getString("via")%>
								---> <%=f.arr.toUpperCase()%></span>&nbsp&nbsp Departs at <%=rs.getString("f2_departure")%>
							<i>(<%=rs.getString("f2_time").substring(0, 2)
								+ "h "
								+ rs.getString("f2_time").substring(3, 5) + "m"%>)
						</i></span> <br>Total Journey: <%=rs.getString("total_journey").substring(0, 2)
								+ " hrs "
								+ rs.getString("total_journey").substring(3, 5)
								+ " mins"%> <br> <span
						style="font-size: 14px; color: #009933;"><%=days.toString()%></span>
				</div>
				<div class="time exht">
					Arrival<br> <span style="font-size: 20px; color: #0066FF;"><%=rs.getString("f2_arrival")%></span>
				</div>
			</div>
		</div>

		<%
			}

				}
			}

			if (f.maxstops > 2) {
				ResultSet rs = res[2];
				if (rs.first() == false) {
		%>
		<%
			} else {
					rs.beforeFirst();
					f.data_available_flag = true;
		%>

		<div class="alert alert-info animated fadeIn" role="alert">
			Details of flights from <strong><%=request.getParameter("textDepAirportCode")%></strong>
			to <strong><%=request.getParameter("textArrivalAirportCode")%></strong>
			via <i><u>two stops</u></i> are as below
		</div>
		<%
			while (rs.next()) {

						String days1 = rs.getString("f1_days");
						String days2 = rs.getString("f2_days");
						StringBuilder days = new StringBuilder("");

						if (days1.contains("Mon") && days2.contains("Mon"))
							days.append(" Monday");

						if (days1.contains("Tue") && days2.contains("Tue"))
							days.append(" Tuesday");

						if (days1.contains("Wed") && days2.contains("Wed"))
							days.append(" Wednesday");

						if (days1.contains("Thu") && days2.contains("Thu"))
							days.append(" Thursday");

						if (days1.contains("Fri") && days2.contains("Fri"))
							days.append(" Friday");

						if (days1.contains("Sat") && days2.contains("Sat"))
							days.append(" Saturday");

						if (days1.contains("Sun") && days2.contains("Sun"))
							days.append(" Sunday");
		%>

		<div class="flightdetails animated bounceInRight exht3">
			<div class="flight_icon"></div>
			<div class="flightdata">
				<div class="time exht3">
					Departure<br> <span style="font-size: 20px; color: #0066FF;"><%=rs.getString("f1_dep")%></span>
				</div>
				<div class="data exht3">
					<span style="font-size: 14px; color: #8B8B8B;">Flight
						Number: <%=rs.getString("f1_number")%>&nbsp&nbsp <span
						style="font-size: 18px; color: #FF6600;"><%=f.dep.toUpperCase()%>
							---> <%=rs.getString("via_1").toUpperCase()%> </span> <span
						style="font-size: 14px; color: #8B8B8B;">&nbsp&nbsp arrives
							at <%=rs.getString("f1_arrival")%> <i>(<%=rs.getString("f1_time").substring(0, 2)
								+ "h "
								+ rs.getString("f1_time").substring(3, 5) + "m"%>)
						</i>
					</span> <br> <span style="font-size: 14px; color: #8B8B8B;">Flight
							Number: <%=rs.getString("f2_number")%>&nbsp&nbsp
					</span> <span style="font-size: 14px; color: #8B8B8B;"> <span
							style="font-size: 18px; color: #FF6600;"><%=rs.getString("via_1")%>
								---> <%=rs.getString("via_2")%></span>&nbsp&nbsp departs at <%=rs.getString("f2_dep")%>
							<i>(<%=rs.getString("f2_time").substring(0, 2)
								+ "h "
								+ rs.getString("f2_time").substring(3, 5) + "m"%>)
						</i></span> <br> <span style="font-size: 14px; color: #8B8B8B;">Flight
							Number: <%=rs.getString("f3_number")%>&nbsp&nbsp <span
							style="font-size: 18px; color: #FF6600;"><%=rs.getString("via_2")%>
								---> <%=f.arr.toUpperCase()%> </span> <span
							style="font-size: 14px; color: #8B8B8B;">&nbsp&nbsp
								departs at <%=rs.getString("f3_dep")%> <i>(<%=rs.getString("f3_time").substring(0, 2)
								+ "h "
								+ rs.getString("f3_time").substring(3, 5) + "m"%>)
							</i>
						</span> <br> Total Journey: <%=rs.getString("total_journey").substring(0, 2)
								+ " hrs "
								+ rs.getString("total_journey").substring(3, 5)
								+ " mins"%> <br> <span
							style="font-size: 14px; color: #009933;"><%=days.toString()%></span>
				</div>
				<div class="time exht3">
					Arrival<br> <span style="font-size: 20px; color: #0066FF;"><%=rs.getString("f3_arrival")%></span>
				</div>
			</div>
		</div>

		<%
			}

				}
			}

			if (!f.data_available_flag) {
		%>
		<div class="alert alert-warning animated pulse" role="alert">
			Details of flights from <strong><%=request.getParameter("textDepAirportCode")%></strong>
			to <strong><%=request.getParameter("textArrivalAirportCode")%></strong>
			are not available.
		</div>
		<%
			}
		%>


	</div>
</body>
</html>


