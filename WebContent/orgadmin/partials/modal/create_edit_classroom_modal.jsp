<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/inc/head.jsp"></jsp:include>

<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	int colegeID = (int)request.getSession().getAttribute("orgId");

	
	int class_id = 0;
	if (request.getParameter("class_id") != null) {
		class_id = Integer.parseInt(request.getParameter("class_id"));
	}

	String type = "Create";
	if (request.getParameter("type") != null) {
		type = request.getParameter("type");
	}

	UIUtils utils = new UIUtils();
	String className = "";
	String classIP = "";
	String organization_id = "";
	String max_students = "";
	
	String tv_projector="";
	String internet_speed="";
	String lab_or_class="";
	
	boolean internet_availability=false;
	boolean compute_stick=false;
	boolean extension_box=false;
	boolean router=false;
	boolean keyboard=false;
	boolean mouse=false;

	if (!type.equalsIgnoreCase("Create")) {
		String sql = "SELECT * from classroom_details where id="+ class_id;
		DBUTILS dbutils = new DBUTILS();
		List<HashMap<String, Object>> data = dbutils.executeQuery(sql);

		for (HashMap<String, Object> item : data) {
			className = (String) item.get("classroom_identifier");
			classIP = (String) item.get("ip_address");
			organization_id = (int) item.get("organization_id") + "";
			max_students = (int) item.get("max_students") + "";
			tv_projector=item.get("tv_projector")!=null?item.get("tv_projector")+"":"";
			internet_speed=item.get("internet_speed")!=null?item.get("internet_speed")+"":"";
			lab_or_class=item.get("type_of_class")!=null?item.get("type_of_class")+"":"";

			internet_availability=item.get("internet_availability")!=null? (boolean)item.get("internet_availability"):false;
			compute_stick=item.get("compute_stick")!=null? (boolean)item.get("compute_stick"):false;
			extension_box=item.get("extension_box")!=null? (boolean)item.get("extension_box"):false;
			router=item.get("router")!=null? (boolean)item.get("router"):false;
			keyboard=item.get("keyboard")!=null? (boolean)item.get("keyboard"):false;
			mouse=item.get("mouse")!=null? (boolean)item.get("mouse"):false;

		}
	}
%>

<body class="top-navigation" id='super_admin_classroom'>
	<div id="wrapper">
		<div id="page-wrapper" class="gray-bg">
			<jsp:include page="/inc/navbar.jsp"></jsp:include>
                <% 
			String[] brd = {"Dashboard"};
			%>
				<%=UIUtils.getPageHeader("Classroom(s)", brd) %>

				<div class='row card-box scheduler_margin-box'>
					<div id='redirect_url' data-url='<%=baseURL%>orgadmin/classrroms.jsp' style='display: none;'></div>
					
					<form class="form-horizontal" action="../create_or_update_classroom" id="edit_class_model_form" method="post">
						<input type="hidden" value="<%=class_id%>" name="class_id" />
						<div class="form-group">

							<div class="col-lg-6">
								<label class="control-label">Class Room Name *</label> <input type="text" placeholder="Class Room Name" name="class_name" class="form-control" value="<%=className%>">
							</div>


							<div class="col-lg-6">
								<label class="control-label">IP Address *</label> <input type="text" placeholder="Eg. 192.168.0.0" name="class_ip" class="form-control" value='<%=classIP%>'>
							</div>


							<div class="col-lg-6">
								<label class="control-label">Max Students *</label> <input type="number" placeholder="0-10000" name="class_students" min='0' class="form-control" value='<%=max_students%>'>
							</div>


							<%
								if (type.equalsIgnoreCase("Create")) {
							%>
							<input type="hidden" value="<%=colegeID%>" name="org_id" />
							<%
								} else {
							%>
							<input type="hidden" value="<%=organization_id%>" name="org_id" />
							<%
								}
							%>


						</div>

						<div class='form-group'>
							<div class='col-md-4'>
								<label>Tv/Projector Availability</label> <select class='select-2' name='tv_projector'>
									<option value="NONE" <%=tv_projector.equalsIgnoreCase("NONE") || tv_projector.equalsIgnoreCase("")?"selected":"" %>>None</option>
									<option value="TV" <%=tv_projector.equalsIgnoreCase("TV")?"selected":"" %>>Tv</option>
									<option value="PROJECTOR" <%=tv_projector.equalsIgnoreCase("PROJECTOR")?"selected":"" %>>projector</option>
								</select>
							</div>

							<div class="col-lg-2">
								<label class="control-label">Internet Availability</label> <select class='select-2' name='internet_availability'>
									<option value="NO" <%=internet_availability?"":"selected"%>>NO</option>
									<option value="YES" <%=internet_availability?"selected":""%>>Yes</option>
								</select>
							</div>


							<div class="col-lg-6">
								<label class="control-label">Internet Speed</label> <br /> <input type="number" placeholder="in MBPS" name="internet_speed" min='0' class="form-control" value='<%=internet_speed%>'>
							</div>


						</div>
						<div class='form-group'>
							<div class='col-md-3'>
								<label> Type of Class</label> <select class='select-2' name='lab_or_class'>
									<option value="CLASS" <%=lab_or_class.equalsIgnoreCase("CLASS")||lab_or_class.equalsIgnoreCase("")?"selected":"" %>>Class</option>
									<option value="LAB" <%=lab_or_class.equalsIgnoreCase("LAB")?"selected":"" %>>Lab</option>
								</select>

							</div>
							<div class='col-md-3'>
								<label> compute stick</label> <select class='select-2' name='compute_stick'>
									<option value="NO" <%=compute_stick?"":"selected"%>>NO</option>
									<option value="YES" <%=compute_stick?"selected":""%>>Yes</option>
								</select>
							</div>

							<div class='col-md-3'>
								<label> Extension Box</label> <select class='select-2' name='extension_box'>
									<option value="NO" <%=extension_box?"":"selected"%>>NO</option>
									<option value="YES" <%=extension_box?"selected":""%>>Yes</option>
								</select>
							</div>
							<div class='col-md-3'>
								<label>Router</label> <select class='select-2' name='router'>
									<option value="NO" <%=router?"":"selected"%>>NO</option>
									<option value="YES" <%=router?"selected":""%>>Yes</option>
								</select>
							</div>
						</div>
						<div class='form-group'>
							<div class='col-md-3'>
								<label>Keyboard</label> <select class='select-2' name='keyboard'>
									<option value="NO" <%=keyboard?"":"selected"%>>NO</option>
									<option value="YES" <%=keyboard?"selected":""%>>Yes</option>
								</select>
							</div>
							<div class='col-md-3'>
								<label>Mouse</label> <select class='select-2' name='mouse'>
									<option value="NO" <%=mouse?"":"selected"%>>NO</option>
									<option value="YES" <%=mouse?"selected":""%>>Yes</option>
								</select>
							</div>

						</div>

						<div class="modal-footer" style="padding-bottom: 0px">
							<div class="form-group">
								<button type="button" id="class_modal_submit" class="btn btn-primary btn-danger"><%=(type.equalsIgnoreCase("Create") ? "Create Class Room" : "Update Class Room")%></button>
							</div>
						</div>
					</form>
				</div>
		</div>
	</div>
	<!-- Mainly scripts -->
	<jsp:include page="/inc/foot.jsp"></jsp:include>
</body>
