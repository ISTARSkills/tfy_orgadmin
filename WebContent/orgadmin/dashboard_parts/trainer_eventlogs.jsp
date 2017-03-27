<%@page import="java.util.*"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
	
%>
<%		if (request.getParameterMap().containsKey("event_id") && !(request.getParameter("event_id").equalsIgnoreCase("NONE")) ) {
	
	int slide_id = 6060;
	String urlIfram = null;
	String event_id = request.getParameter("event_id");
	System.out.println("--------------------------------------"+event_id);
			String sql = "SELECT slide_id,url FROM event_session_log WHERE event_id = '"+event_id+"' ORDER BY 	ID DESC LIMIT 1";
			System.out.println("-------------------sql-------------------"+sql);

			DBUTILS db = new DBUTILS();
	  List<HashMap<String, Object>> data = db.executeQuery(sql);
		 
		if(data.size() != 0 ){
			for (HashMap<String, Object> row2 : data) {
				
				slide_id = (int) row2.get("slide_id");
				urlIfram = (String) row2.get("url");
			
			}
			
		}
		System.out.println("-----------url-----------------"+urlIfram);
		System.out.println("-----------slide_id-----------------"+slide_id);
	
	
 %>
<div class="col-lg-12" id="online" style="margin-bottom: 10px;">
	<div class="tabs-container">
		<ul class="nav nav-tabs" id="track_session">
			<li value="student" class="active"><a data-toggle="tab"
				href="#tab-7">Slide</a></li>
			<li value="program" class=""><a data-toggle="tab" href="#tab-8">Video</a></li>
		</ul>
		<div class="tab-content">
			<div id="tab-7" class="tab-pane active">
				<div class="panel-body" style="height: 50em;">
					<div class="ibox-content">
						<div id="slide_out">

							<div class='tab-pane fade in active' id='desktop'>


								<iframe id="d-preview desktop-preview-frame" class="col-lg-12"
									style="height: 46em;" src="<%=urlIfram%>"> </iframe>

							</div>

						</div>
					</div>
				</div>
			</div>
			<div id="tab-8" class="tab-pane">
				<div class="panel-body">
					<div class="ibox-content">
						<div id="video_out"></div>
					</div>

				</div>
			</div>
		</div>
	</div>
</div>
<% } else{ %>

<div class="col-lg-12" id="online" style="margin-bottom: 10px;">
	<div class="tabs-container">
		<ul class="nav nav-tabs" id="track_session">
			<li value="student" class="active"><a data-toggle="tab"
				href="#tab-7">Slide</a></li>
			<li value="program" class=""><a data-toggle="tab" href="#tab-8">Video</a></li>
		</ul>
		<div class="tab-content">
			<div id="tab-7" class="tab-pane active">
				<div class="panel-body">
					<div class="ibox-content">
						<div id="slide_out">
							<div class="well">
								<h1 class="text-center">NO DATA</h1>

							</div>
						</div>
					</div>
				</div>
			</div>
			<div id="tab-8" class="tab-pane">
				<div class="panel-body">
					<div class="ibox-content">
						<div id="video_out"></div>
					</div>
					<div class="well">
						<h1 class="text-center">NO DATA</h1>

					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<%} %>