<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%

int user_id=Integer.parseInt(request.getParameter("uer_id"));
int task_id=Integer.parseInt(request.getParameter("task_id"));



%>

<div class="ibox-content full-height-scroll modal-height" id="modal_feedback">
	<div class="row">
		<div class="product-box p-xl b-r-lg border-left-right border-top-bottom">
			<div class="m-t-sm m-l-sm">
				<strong class="m-l-sm"></strong>
			</div>
		</div>
	</div>
</div>