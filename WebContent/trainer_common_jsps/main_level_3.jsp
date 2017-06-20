<%@page import="com.viksitpro.core.dao.entities.CourseDAO"%>
<%@page import="com.viksitpro.core.dao.entities.Course"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.viksitpro.core.utilities.DBUTILS"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUserDAO"%>
<%@page import="com.viksitpro.core.dao.entities.IstarUser"%>
<%
	String url = request.getRequestURL().toString();
	String baseURL = url.substring(0, url.length() - request.getRequestURI().length())
			+ request.getContextPath() + "/";
%>
<%
int trainer_id = Integer.parseInt(request.getParameter("trainer_id"));
IstarUser trainer  = new IstarUserDAO().findById(trainer_id);
boolean isSelected = false;
boolean interviewStatus = false;
DBUTILS util = new DBUTILS();

IstarUser masterTrainer = (IstarUser)request.getSession().getAttribute("user");
int masterTrainerId = masterTrainer.getId();
%>
<div class="panel-body">
	<h3>
		<strong>Trainer Email: </strong>
		<%=trainer.getEmail()%></h3>
	<div class="row" style="margin-left: 0px;">
		
	
	<div class="form-group">

		<label>Comments</label>

		<textarea class="form-control" id="comment" required placeholder="Write comment..."></textarea>
	</div>
	<div class="form-group">
	<%
	String getAlreadyMappedCourses ="select DISTINCT course_id from  trainer_skill_distrubution_stats where trainer_skill_distrubution_stats.trainer_id = "+trainer_id;
	ArrayList<Integer>alreadyMappedIds = new ArrayList();
	List<HashMap<String,Object>> mappedCourses = util.executeQuery(getAlreadyMappedCourses);
	for(HashMap<String,Object> row: mappedCourses)
	{
		int course_id = (int)row.get("course_id");
		alreadyMappedIds.add(course_id);
	}
	
	
	%>
	<label>Trainer Skill</label>
		<div>
			<input type="hidden" id="courseIDS" value=""> <select data-placeholder="Choose a Course..." required class="course_list chosen-select" multiple style="width: 350px;" tabindex="4">
			<%
			List<Course> courses = (List<Course>) new CourseDAO().findAll();
			for(Course c: courses)
			{
				String selected="";
				if(alreadyMappedIds.contains(c.getId()))
				{
					selected ="selected";
				}
				%>
				<option value="<%=c.getId()%>" <%=selected %>><%=c.getCourseName() %></option>
				<% 	
			}
			%>
			</select>
		</div>

	</div>
	<div class="form-group">
		<label > Select Trainer <input type="checkbox" <%=isSelected!=false?"checked":"" %> value="<%=isSelected!=false?"true":"false" %>" id="is_checked_trainer"></label>	
		<label style=" color: red;     margin-left: 37px;" class="" > Mark L3 interview As Completed <input type="checkbox" <%=interviewStatus!=false?"checked":"" %> value="<%=interviewStatus!=false?"true":"false" %>" id="is_checked_interview_status" required></label>		
		
	</div>
	<div class="form-group">
	<button class="btn btn-sm btn-primary m-t-n-xs"
									id="submit_comment" type="button" style="float:left">
									<strong>Submit</strong>
								</button>
	</div>	
	</div>
	<br>
	<div class="row" style="    margin-top: 20px;">
	<div class="col-lg-12">
                    <div class="tabs-container">
                        <ul class="nav nav-tabs">
                            <li class="active"><a data-toggle="tab" href="#tab-1"> This is tab</a></li>
                            <li class=""><a data-toggle="tab" href="#tab-2">This is second tab</a></li>
                        </ul>
                        <div class="tab-content">
                            <div id="tab-1" class="tab-pane active">
                                <div class="panel-body">
                                    <strong>Lorem ipsum dolor sit amet, consectetuer adipiscing</strong>

                                    <p>A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of
                                        existence in this spot, which was created for the bliss of souls like mine.</p>

                                    <p>I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at
                                        the present moment; and yet I feel that I never was a greater artist than now. When.</p>
                                </div>
                            </div>
                            <div id="tab-2" class="tab-pane">
                                <div class="panel-body">
                                    <strong>Donec quam felis</strong>

                                    <p>Thousand unknown plants are noticed by me: when I hear the buzz of the little world among the stalks, and grow familiar with the countless indescribable forms of the insects
                                        and flies, then I feel the presence of the Almighty, who formed us in his own image, and the breath </p>

                                    <p>I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy, my dear friend, so absorbed in the exquisite
                                        sense of mere tranquil existence, that I neglect my talents. I should be incapable of drawing a single stroke at the present moment; and yet.</p>
                                </div>
                            </div>
                        </div>


                    </div>
                </div>
	
	</div>
</div>
<script type="text/javascript">

$(document).ready(function(){
	 $('.chosen-select').chosen({width: "100%"});
	 
	 $( ".course_list" ).change(function() {
		// this.val();
		console.log("-->"+$(this).val());
		  $('#courseIDS').val($(this).val());
		});
	
	 $('#is_checked_trainer').change(function(){ 
		 
		 if($('#is_checked_trainer').prop('checked')) {
			 $('#is_checked_trainer').val('true');
			} else {
				$('#is_checked_trainer').val('false');
			} 
	 });
	 
	 $('#is_checked_interview_status').change(function(){ 
		 
		 if($('#is_checked_interview_status').prop('checked')) {
			 $('#is_checked_interview_status').val('true');
			} else {
				$('#is_checked_interview_status').val('false');
			} 
	 });
	
    
    $( "#submit_comment" ).click(function() {
		 console.log("");
		 
		 var comment = $('#comment').val();
		// var courseid =$("option:selected").map(function(){ return this.value }).get().join(", ");
		 var courseid = $('#courseIDS').val();
		 var is_tariner_selected = $('#is_checked_trainer').val();
		 var interview_status = $('#is_checked_interview_status').val();
		 
		if(interview_status == 'true'){
			
			 var jsp="<%=baseURL%>master_trainer_comments";
		    	$.post(jsp, 
						{comment:comment,courseid:courseid,is_tariner_selected:is_tariner_selected,mastertrainer_id:<%=masterTrainerId%>,trainer_id:<%=trainer_id%>,interview_status:interview_status}, 
						function(data) {
							
							alert('Submit')
				});
			 
		
    }else{
    	alert('please check interview is over or not')
    }
		
		});

});





</script>