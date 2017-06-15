
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="in.talentify.core.utils.UIUtils"%>
<%

	int college_id = (int) request.getSession().getAttribute("orgId");
	DBUTILS util = new DBUTILS();
	
%>
<jsp:include page="/common_jsps/batch_programs_cards.jsp">
<jsp:param value='<%=college_id%>' name='college_id'/>
</jsp:include>