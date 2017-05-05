<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%
String collegeId = request.getParameter("college_id");
String entityType = request.getParameter("entityType");
String entityId = request.getParameter("entity_id");
%>    
<div class="panel-body custom-body-style-3">
	<div class="col-lg-6" style="padding: 0px;
    margin-top: -15px;
    margin-left: -15px;">
						<jsp:include page="map_content_available_content.jsp">
							<jsp:param value='<%=entityType%>' name="entity_type" />
							<jsp:param value='<%=entityId%>' name="entity_id" />
							<jsp:param value='<%=collegeId%>' name="college_id" />
						</jsp:include>
					</div>

					<div class="col-lg-6" style="padding: 0px;
    margin-top: -15px;
    margin-left: 4px;">
						<jsp:include page="map_content_associated_role_content.jsp">
						<jsp:param value='<%=entityType%>' name="entity_type" />
							<jsp:param value='<%=entityId%>' name="entity_id" />
							<jsp:param value='<%=collegeId%>' name="college_id" />
						</jsp:include>
					</div>

				</div>