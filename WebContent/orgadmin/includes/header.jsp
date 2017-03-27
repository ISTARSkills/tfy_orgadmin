<%@page import="in.orgadmin.utils.OrgadminUtil"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<% String url = request.getRequestURL().toString();
String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
+ request.getContextPath() + "/";

IstarUser user= (IstarUser)request.getSession().getAttribute("user");

if (request.getSession().getAttribute("user") != null) {
	String imageURL = "img/user_images/recruiter.png";
}
String imageURL = user.getImageUrl();
if (imageURL == null) {
	imageURL = "/img/user_images/recruiter.png";
}

/* if(request.getSession().getAttribute("user")!=null) {
//	String url1 = "/content/"+ ((IstarUser)session.getAttribute("user")).getUserType().toLowerCase()+"/dashboard.jsp";
	//response.sendRedirect(url1);
}	 */

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<nav class="navbar navbar-static-top" role="navigation"
	style="background: white; height: 45px; padding-top:10px; padding-bottom:5px;">
	
		<div class="navbar-header" style="height: 40px !important;">
            <a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="#" style="min-height:20px !important; margin: 0px !important; margin-top: 5px; padding-top:5px; padding-bottom:5px;"><i class="fa fa-bars"></i> </a>
            <form role="search" class="navbar-form-custom" action="search_results.html">
                <div class="form-group">
                    <input type="text" placeholder="Search for something..." class="form-control" name="top-search" id="top-search" style="height:40px;font-size: 11px;">
                </div>
            </form>
        </div>
        
	<ul class="nav navbar-top-links navbar-right" style="margin-top: -12px;">
	

	              <%
              OrgadminUtil util = new OrgadminUtil();
              out.println(util.getOrgInHeader(user, baseURL));
              %>
		<li class="m-r-sm text-muted"><span
			style="font-size: 15px; font-weight: bold; color: black;">Welcome
				to Talentify Admin</span>
		</li>
		<li>
		<div class="dropdown profile-element">
				<a data-toggle="dropdown" class="dropdown-toggle" href="#"> <img
					style="width: 30px;padding-bottom:10px;" alt="<%=user.getName()%>" class="img-circle"
					src="<%=baseURL %><%=imageURL%>" />
				</a>
				<ul class="dropdown-menu animated fadeInRight m-t-xs">
					<li><a href="<%=baseURL %>auth/logout">Logout</a></li>
				</ul>
			</div>
		</li>		
	</ul>


        </nav>