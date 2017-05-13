<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";

	int class_id = 0;
	if (request.getParameter("class_id") != null) {
		class_id = Integer.parseInt(request.getParameter("class_id"));
	}

	String type = "Create";
	if (request.getParameter("type") != null) {
		type = request.getParameter("type");
	}
	
	UIUtils utils=new UIUtils();
	String className="";
	String classIP="";
	String organization_id="";
	String max_students="";
	
	if(!type.equalsIgnoreCase("Create")){
		String sql="SELECT classroom_identifier,ip_address,organization_id,max_students from classroom_details where id="+class_id;
		DBUTILS dbutils=new DBUTILS();
		List<HashMap<String, Object>> data = dbutils.executeQuery(sql);
		
		for (HashMap<String, Object> item : data) {
			className=(String)item.get("classroom_identifier");
			classIP=(String)item.get("ip_address");
			organization_id=(int)item.get("organization_id")+"";
			max_students=(int)item.get("max_students")+"";
		}	
	}
%>


<div id="edit_class_room_model" class="modal inmodal"
	role="dialog" aria-hidden="true">
	<div class='modal-dialog'>
		<div class='modal-content animated flipInY'>

			<div class="panel panel-primary custom-theme-panel-primary" style="margin-bottom: 0px;">
                                        <div class="panel-heading custom-theme-panal-color">
				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
				</button>
				<h4 class="modal-title text-center"><%=type%> Class Room
				</h4>
			</div>
			<div class="modal-body" style="padding-bottom: 0px">

				<form class="form-horizontal"
					action="../create_or_update_classroom"
					id="edit_class_model_form" method="post">
					<input type="hidden" value="<%=class_id%>" name="class_id" />
					<div class="form-group">

						<div class="col-lg-6">
							<label class="control-label">Class Room Name *</label> <input type="text" placeholder="Class Room Name"
								name="class_name" class="form-control"
								value="<%=className%>">
						</div>
						

						<div class="col-lg-6">
							<label class="control-label">IP Address *</label> <input type="text"
								placeholder="Eg. 192.168.0.0" name="class_ip"
								class="form-control"
								value='<%=classIP%>'>
						</div>
						
						
						<div class="col-lg-6">
							<label class="control-label">Max Students *</label> <input type="number"
								placeholder="0-10000" name="class_students"
								class="form-control"
								value='<%=max_students%>'>
						</div>
						

				<%if(type.equalsIgnoreCase("Create")){ %>
						<div class="col-lg-6">
							<label class="control-label">Organization *</label> <select
								class="form-control" name="org_id"
								data-validation="required">
								<%=utils.getOrganization()%>
							</select>
						</div>
						<%}else{ %>
						<input type="hidden" value="<%=organization_id%>" name="org_id" />
						<%} %>
					</div>
<div class="modal-footer" style="padding-bottom: 0px">
					<div class="form-group">
						<button type="button" id="class_modal_submit"
							class="btn btn-primary btn-danger"><%=(type.equalsIgnoreCase("Create")?"Create Class Room":"Update Class Room")%></button>
					</div></div>
				</form>
			</div>
		</div></div>
	</div>
</div>