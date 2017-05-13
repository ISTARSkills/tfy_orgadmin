<%@page import="in.orgadmin.admin.services.OrgAdminSkillService"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	int colegeID = Integer.parseInt(request.getParameter("colegeID"));
	String type = request.getParameter("type");
	int offset=0;
	if(request.getParameter("offset")!=null){
	 offset=Integer.parseInt(request.getParameter("offset"));
	}	
	String searchKey="";
	if(request.getParameter("searchkey")!=null){
		searchKey=request.getParameter("searchkey").toString().replaceAll("%20", "");
	}	
	String limit = "10";
	if(request.getParameterMap().containsKey("limit"))
	{
		limit = request.getParameter("limit");
	}
	List<HashMap<String, Object>> list = new OrgAdminSkillService().getAllContentUserList(colegeID, type,offset,searchKey, limit);
	int totalEntities =0;
	if(list.size()>0)
	{
		totalEntities = (int)list.get(0).get("total_user");
	}
%>
					<div class="text-center">
						<div id="user_page-selection" class="page-selection" data-org='<%=colegeID%>' data-url="partials/map_inner_tab_content.jsp" data-type='User' data-size='<%=totalEntities%>'>
							<input type='text' id="content-user-search"  placeholder=" Search Users..." class="form-control b-r-lg no-opaddings pull-right m-r-xl m-t-sm content-user-search-holder content-user-search" data-org='<%=colegeID%>' data-url="partials/map_inner_tab_content.jsp" data-type='User' data-size='<%=list.size()%>'/>
						</div>
					</div>
<div class="panel-body no-borders content-map-ajax-request actual_content_body">					 
<div class="tabs-container">
	<div class="tabs-left ">
		<ul class="nav nav-tabs gray-bg tab-width-custom " style="padding: 5px;">
			<%
				int i = 0;
				for (HashMap<String, Object> item : list) {
			%>

			<li class="<%=i == 0 ? "active" : ""%> no-padding bg-muted"><a	data-target="#admin_content_inner_tab_<%=i+type%>" 
			data-toggle="tabajax_admin_child" href="partials/available_mapped_content.jsp" data-entity_type="<%=type%>" data-entity_id="<%=item.get("id") %>" data-college_id="<%=colegeID %>"
				aria-expanded="false"><%=item.get("email")%> <span class="label" id="role_skill_count_<%=type+item.get("id")%>"><%=item.get("count")%></span>
			</a></li>
			<%
				i++;
				}
			%>
		</ul>
		<div class="tab-content">
			<%
				i = 0;
				for (HashMap<String, Object> item : list) {
			%>

			<div id="admin_content_inner_tab_<%=i+type%>"
				class="tab-pane <%=i == 0 ? "active" : ""%>">
				
			</div>
			<%
				i++;
				}
			%>
		</div>
	</div>
</div>
</div>