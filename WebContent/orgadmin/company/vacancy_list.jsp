<%@page import="in.orgadmin.utils.UserInterfaceUtils"%>
<%@page import="com.istarindia.apps.dao.*"%>
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<!DOCTYPE html>
<html>

<head>
<% 
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length()) + request.getContextPath() + "/";
%>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="shortcut icon" href="<%=baseURL%>assets/images/talentify_logo_fav_48x48.png" />

	
    <title>Talentify Recruitor | Dashboard</title>

    <link href="<%=baseURL%>css/bootstrap.min.css" rel="stylesheet">
    <link href="<%=baseURL%>font-awesome/css/font-awesome.css" rel="stylesheet">

    <link href="<%=baseURL%>css/animate.css" rel="stylesheet">
    <link href="<%=baseURL%>css/style.css" rel="stylesheet">
    <link href="<%=baseURL%>css/plugins/summernote/summernote.css" rel="stylesheet">
    <link href="<%=baseURL%>css/plugins/summernote/summernote-bs3.css" rel="stylesheet">

</head>

<body class="fixed-navigation">
    <div id="wrapper">
    	<jsp:include page="../includes/sidebar.jsp"></jsp:include>
        <div id="page-wrapper" class="gray-bg ">
	        
	        <div class="row border-bottom">
				<jsp:include page="../includes/header.jsp"></jsp:include>
	        </div>
            
            <div class="wrapper wrapper-content">
                <div class="row">
					<div class="col-lg-12">
				        <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h2>List of Vacancy</h2>
                            
                        </div>
                        <div class="ibox-content">

                            <table class="table table-hover">
                                <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Title</th>
                                    <th>Company</th>
                                    <th>Description</th>
                                    <th>Location</th>                                                                   
                                </tr>
                                </thead>
                                <tbody>
                               <% 
                               VacancyDAO dao = new VacancyDAO();
                               List<Vacancy>  list = dao.findAll();
                               for(Vacancy vacancy:   list) { %>
                               
                                <tr>
                                    <td><%=vacancy.getId() %></td>
                                   <td><%=vacancy.getProfileTitle() %></td>
                                   <td><%=vacancy.getCompany().getName() %></td>
                                   <td><%=vacancy.getDescription() %></td>
                                   <td><%=vacancy.getLocation()%></td>
                                </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>
                    </div>
				    </div>
                </div>
            </div>
            
        </div>
    </div>

    <!-- Mainly scripts -->
    <script src="<%=baseURL%>js/jquery-2.1.1.js"></script>
    <script src="<%=baseURL%>js/bootstrap.min.js"></script>
    <script src="<%=baseURL%>js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="<%=baseURL%>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

    <!-- Peity -->
    <script src="<%=baseURL%>js/plugins/peity/jquery.peity.min.js"></script>
    <script src="<%=baseURL%>js/demo/peity-demo.js"></script>

    <!-- Custom and plugin javascript -->
        	<script src="<%=baseURL%>js/highcharts-custom.js"></script>
    <script src="<%=baseURL%>js/inspinia.js"></script>
    <script src="<%=baseURL%>js/plugins/pace/pace.min.js"></script>

    <!-- jQuery UI -->
    <script src="<%=baseURL%>js/plugins/jquery-ui/jquery-ui.min.js"></script>

    <!-- Jvectormap -->
    <script src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-2.0.2.min.js"></script>
    <script src="<%=baseURL%>js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>

    <!-- Sparkline -->
    <script src="<%=baseURL%>js/plugins/sparkline/jquery.sparkline.min.js"></script>
    <script src="<%=baseURL%>js/plugins/summernote/summernote.min.js"></script>

    <!-- Sparkline demo data  -->
    <script src="<%=baseURL%>js/demo/sparkline-demo.js"></script>


    <script>
        $(document).ready(function() {

        });
    </script>
</body>
</html>
