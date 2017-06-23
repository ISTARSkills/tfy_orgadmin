package tfy.admin.trainer;

import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import org.apache.commons.lang.StringUtils;

import com.istarindia.android.pojo.ComplexObject;
import com.istarindia.android.pojo.DailyTaskPOJO;
import com.istarindia.android.pojo.RestClient;
import com.istarindia.android.pojo.TaskSummaryPOJO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.TrainerEmpanelmentStageTypes;
import com.viksitpro.core.utilities.TrainerEmpanelmentStatusTypes;

import in.orgadmin.utils.report.CustomReportUtils;

public class TaskCardFactoryRecruitment {
	public StringBuffer showTrainerProfileCard(int trainerId) {
		IstarUser user = new IstarUserDAO().findById(trainerId);
		StringBuffer sb = new StringBuffer();
		DBUTILS util = new  DBUTILS();
		CustomReportUtils repUtil = new CustomReportUtils();
		sb.append("<div class='widget-head-color-box navy-bg p-lg text-center'>                      ");
		sb.append("<div class='m-b-md'>                                                              ");
		sb.append("<h2 class='font-bold no-margins'>                                                 ");
		sb.append(user.getUserProfile().getFirstName());
		sb.append("</h2>                                                                             ");
		sb.append("<small>"+user.getEmail()+"</small>                                               ");
		sb.append("</div>                                                                            ");
		sb.append("<img src='"+user.getUserProfile().getProfileImage()+"' class='img-circle circle-border m-b-md' alt='profile'>      ");
		sb.append("<div>                                                                             ");
		sb.append("<span>"+user.getMobile()+"</span>                                                           ");
		sb.append("                                                                                  ");
		sb.append("</div>                                                                            ");
		sb.append("</div>");
		sb.append("<div class='product-box ' style='    margin-bottom: 20px;'>			"
				+ "	<div class='ibox' style='height: 100%;margin-bottom: 0px !important; '> "
				+ "<div class='ibox-content ' style='height: 100%; min-height:500px'> ");			
		//sb.append("<small>You have "+cp.getEventsToday().size() +" events and "+cp.getNotificationsValid()+" notifications.</small>                                 ");
		sb.append("<ul class='list-group clear-list m-t'>  ");
		String[] class1={"primary","information","success","warning","danger"};
		
		
		sb.append("<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
		sb.append("<div class='row'>"
				+ "<div class='col-md-1  no-padding'></div>"
				+ "<div class='col-md-3 no-padding'><b>Gender</b></div>"
				+ "<div class='col-md-8	 no-padding'>"+user.getUserProfile().getGender()+"</div></div>");
		sb.append("</li>");
		sb.append("<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
		sb.append("<div class='row'>"
				+ "<div class='col-md-1  no-padding'></div>"
				+ "<div class='col-md-3 no-padding'><b>UG Degree</b></div>"
				+ "<div class='col-md-8	 no-padding'>"+user.getProfessionalProfile().getUnderGraduateDegreeName()+"</div></div>");
		sb.append("</li>");
		sb.append("<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
		sb.append("<div class='row'>"
				+ "<div class='col-md-1  no-padding'></div>"
				+ "<div class='col-md-3 no-padding'><b>PG Degree</b></div>"
				+ "<div class='col-md-8	 no-padding'>"+user.getProfessionalProfile().getPgDegreeName()+"</div></div>");
		sb.append("</li>");
		sb.append("<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
		sb.append("<div class='row'>"
				+ "<div class='col-md-1  no-padding'></div>"
				+ "<div class='col-md-3 no-padding'><b>Experience</b></div>"
				+ "<div class='col-md-8	 no-padding'>"+user.getProfessionalProfile().getExpereinceInYears()+" years "+user.getProfessionalProfile().getExperienceInMonths()+" months</div></div>");
		sb.append("</li>");
		String interestedCourses = "";
		String getAlreadySelectedInterestedCourse ="select string_agg(distinct course_name,', ') as courses from trainer_intrested_course, course where trainer_intrested_course.course_id = course.id and trainer_id = "+user.getId();
		List<HashMap<String, Object>> selectedIntrested = util.executeQuery(getAlreadySelectedInterestedCourse);
		for(HashMap<String, Object> row : selectedIntrested)
		{
			interestedCourses = row.get("courses").toString();
		}
		
		sb.append("<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
		sb.append("<div class='row'>"
				+ "<div class='col-md-1  no-padding'></div>"
				+ "<div class='col-md-3 no-padding'><b>Interested  Courses</b></div>"
				+ "<div class='col-md-7	 no-padding'>"+interestedCourses+"</div></div>");
		sb.append("</li>");
		
		sb.append("<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
		sb.append("<div class='row'>"
				+ "<div class='col-md-1  no-padding'></div>"
				+ "<div class='col-md-8 no-padding'><h3>Available Days and Time Slots</h3></div>"
				+ "<div class='col-md-3	 no-padding'></div></div>");
		sb.append("</li>");
		
		
		String sql = repUtil.getReport(44).getSql().replace(":trainer_id", user.getId()+"");
		List<HashMap<String, Object>> timeSlots = util.executeQuery(sql);
		for(HashMap<String, Object> row: timeSlots)
		{
			sb.append("<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
			sb.append("<div class='row'>"
					+ "<div class='col-md-1  no-padding'></div>"
					+ "<div class='col-md-3 no-padding'><b>"+row.get("day")+"</b></div>"
					+ "<div class='col-md-8	 no-padding'>"+row.get("time_slots").toString().replaceAll("- 9am, 9am -","-").replaceAll("- 10am, 10am -","-").replaceAll("- 11am, 11am -","-").replaceAll("- 12pm, 12pm -","-").replaceAll("- 1pm, 1pm -","-").replaceAll("- 2pm, 2pm -","-").replaceAll("- 3pm, 3pm -","-").replaceAll("- 4pm, 4pm -","-").replaceAll("- 5pm, 5pm -","-").replaceAll(", $", "")+"</div></div>");
			sb.append("</li>");
		}
		
		sb.append("</ul>                                                                                    ");
		sb.append("</div> </div> </div>                                                                                   ");

		return sb;
		}
	
	
	public StringBuffer showSummaryCard(int trainerID) {
		SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy hh:mm a");
		DBUTILS util = new  DBUTILS();
		String empanelmentData ="SELECT course. ID, course.course_name FROM trainer_intrested_course, course WHERE trainer_intrested_course.trainer_id = "+trainerID+" AND course. ID = trainer_intrested_course.course_id ";
		List<HashMap<String, Object>> data = util.executeQuery(empanelmentData);
		StringBuffer sb = new StringBuffer();
		sb.append("<div class='product-box' style='height: 100%' >                                        ");
		sb.append(" <div class='ibox' style='height: 100%;margin-bottom: -10px;>                                            ");
		sb.append(" <div class='ibox-content h-370 no-padding' style='height: 100%;'>                  ");
		sb.append(" <div class='task-complete-header bg-primary'>                 ");
		sb.append(" <h6 class='p-xxs font-normal bg-muted m-l-xs m-t-none'>TODAY'S ");
		sb.append(" Placement Summary</h6>                                                 ");
		sb.append(" <h3 class='p-xxs m-l-xs'>"+data.size()+" courses applied.</h3>               ");
		sb.append(" </div>                                                        ");
		sb.append(" <div class='product-desc no-padding' style='margin-top: -10px;'>                         ");
		sb.append("                                                               ");
		sb.append("                                                               ");
		sb.append(" <div class='ibox-content no-padding content-border'           ");
		sb.append(" id='ibox-content'>                                            ");
		sb.append("<div id='vertical-timeline' class='vertical-container dark-timeline left-orientation'style=' margin-bottom: 10px !important;'>");
		//iterate
		
		for(HashMap<String, Object> row: data ){
			
			String getstatus ="select stage, empanelment_status, TP.first_name as trainer_name, IP.first_name as interviewer_name, created_at  from (select created_at, stage, empanelment_status, course_id, trainer_id from trainer_empanelment_status where course_id = "+row.get("id")+" and trainer_id ="+trainerID+" order by id desc limit 1 )T1 left join interview_rating on (interview_rating.trainer_id =T1.trainer_id and T1.course_id =interview_rating.course_id) left join user_profile TP on (interview_rating.trainer_id = TP.user_id) left join user_profile IP on (interview_rating.interviewer_id = IP.user_id) limit 1";
			List<HashMap<String, Object>> statusData = util.executeQuery(getstatus);
			String taskIcon = "fa fa-desktop";
			String bgStyle = " style='    background-color: #eb384f;' ";
			String status =statusData.get(0).get("empanelment_status").toString();
			String stage = statusData.get(0).get("stage").toString();
			String interviewerName ="";
			Timestamp date = (Timestamp)statusData.get(0).get("created_at");
			if(statusData.get(0).get("interviewer_name")!=null)
			{
				interviewerName = "by "+statusData.get(0).get("interviewer_name").toString();
			}
			String score ="";
			if(stage.equalsIgnoreCase(TrainerEmpanelmentStageTypes.ASSESSMENT_DONE))
			{
				String getScore ="select cast (sum(score) as integer) as user_score, (select cast (count(assessment_question.id) as integer) as total from assessment_question where assessmentid in (select DISTINCT assessment_id from course_assessment_mapping where course_id ="+row.get("id")+"))   from report where user_id = "+trainerID+" and assessment_id in (select DISTINCT assessment_id from course_assessment_mapping where course_id ="+row.get("id")+")";
				List<HashMap<String, Object>> scoreL3 = util.executeQuery(getScore);
				if(scoreL3.size()>0 && scoreL3.get(0).get("user_score")!=null)
				{
					score = "with the score " +  scoreL3.get(0).get("user_score").toString()+"/"+scoreL3.get(0).get("total").toString();
				}
			}
			else 	if(stage.equalsIgnoreCase(TrainerEmpanelmentStageTypes.SME_INTERVIEW) || stage.equalsIgnoreCase(TrainerEmpanelmentStageTypes.DEMO) ||stage.equalsIgnoreCase(TrainerEmpanelmentStageTypes.FITMENT_INTERVIEW))
			{
				String getScore ="SELECT  CAST (AVG(rating) AS INTEGER) AS rating FROM interview_rating WHERE trainer_id = "+trainerID+" AND course_id = "+row.get("id")+" and stage_type = '"+stage+"'";
				List<HashMap<String, Object>> scoreL3Plus = util.executeQuery(getScore);
				if(scoreL3Plus.size()>0)
				{
					score = "with the score " + scoreL3Plus.get(0).get("rating").toString()+"/5";
				}			
			}
			
			
			String title="The Candidate was <strong>"+StringUtils.capitalize(status)+"</strong>  in stage "+stage+" for the position of "
					+ "Trainer - <strong>"+StringUtils.capitalize(row.get("course_name").toString())+" "+score +" "+ interviewerName+"</strong>  on "+format.format(date)+" </p";
		
			if(status.equalsIgnoreCase(TrainerEmpanelmentStatusTypes.SELECTED)){
				taskIcon = "fa fa-check";
				bgStyle = " style='    background-color: #18a689  !important;     color: white !important;' ";
			}else if(status.equalsIgnoreCase(TrainerEmpanelmentStatusTypes.REJECTED)){
				taskIcon = "fa fa-times";
				bgStyle = " style='    background-color: #ec4758 !important;     color: white !important;' ";
			}
			else {
				taskIcon = "fa fa-hourglass-end";
				bgStyle = " style='    background-color: #f8ac59 !important;     color: white !important;' ";
			}
			
			 sb.append("<div class='vertical-timeline-block no-padding' style='margin: 1em 0 !important;'>   ");
			 sb.append("<div class='vertical-timeline-icon' "+bgStyle+" >       ");
			 sb.append("<i class='"+taskIcon+"'></i>                    ");
			 sb.append("</div>                                             ");
			 sb.append("                                                   ");
			 sb.append("<div class='vertical-timeline-content p-xxs'>      ");
			 sb.append("<p>"+title+" </p>       ");
			 sb.append("                                                   ");
			 sb.append("                                                   ");
			 
			 sb.append("</div>                                             ");
			 sb.append("</div>                                             ");
			 
		}
		sb.append(" </div>");
		
		sb.append("                                                               ");
		sb.append("                                                               ");
		sb.append(" <div class='m-l-lg'>                                          ");
		
		
		sb.append(" </div>                                                        ");
		sb.append(" </div>                                                        ");
		sb.append("                                                               ");
		sb.append(" </div>                                                        ");
		sb.append(" </div>                                                        ");
		sb.append("                                                               ");
		sb.append(" </div>                                                        ");
		sb.append(" </div>                                                        ");	
		
		return sb;
		}
	
	public StringBuffer showCourseCard(int trainerID, int courseID){
		Course course  = new CourseDAO().findById(courseID); 
		SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy hh:mm a");
		
		
		DBUTILS util = new DBUTILS();
		StringBuffer sb = new StringBuffer();
		sb.append("<div class='col-lg-4'>				");
		sb.append("<div class='card1' style='max-height:400px;'>                                                                          ");
		sb.append("<div class='front' >                                                                      ");
		sb.append("<div class='ibox-content product-box' id='ibox-content' style='max-height:400px;min-height:400px; overflow-y: auto;'>                                             ");
		sb.append("<div id='vertical-timeline' class='vertical-container dark-timeline '>                   ");
		
		ArrayList<String>stages = new ArrayList<>();
		stages.add("L1");
		stages.add("L2");
		stages.add("L3");
		stages.add("L4");
		stages.add("L5");
		stages.add("L6");
		
		ArrayList<String>stageNames = new ArrayList<>();
		stageNames.add("Telephonic Interview");
		stageNames.add("Trainer SignUp");
		stageNames.add("Trainer Assessment");
		stageNames.add("SME Interview");
		stageNames.add("Demo");
		stageNames.add("Fitment Interview");
		HashMap<Integer, Boolean> stagesCleared = new HashMap<>();
		stagesCleared.put(0, true);
		stagesCleared.put(1, true);
		stagesCleared.put(2, false);
		stagesCleared.put(3, false);
		stagesCleared.put(4, false);
		stagesCleared.put(5, false);
		String details ="";
		for(int i=0; i< stages.size(); i++)
		{
			String taskIcon = "fa fa-desktop";
			String bgStyle = " style='    background-color: #eb384f;' ";
			String title ="";
			//String stage="";
			String interviewerComments ="";
			String interviewerName ="";
			if(stages.get(i).equalsIgnoreCase(TrainerEmpanelmentStageTypes.TELEPHONIC_INTERVIEW))
			{
				title ="Candidate successfully cleared stage L1.";
				taskIcon = "fa fa-check";
				bgStyle = " style='    background-color: #18a689  !important;     color: white !important;' ";
			}
			else if (stages.get(i).equalsIgnoreCase(TrainerEmpanelmentStageTypes.SIGNED_UP))
			{
				String sql  ="select * from trainer_empanelment_status where trainer_id = "+trainerID+" and course_id = "+course.getId()+" and stage = 'L2'";
				List<HashMap<String, Object>> statusData = util.executeQuery(sql);
				if(statusData.size()>0)
				{
					Timestamp date = (Timestamp)statusData.get(0).get("created_at");
					title ="Candidate successfully cleared stage L2 on "+format.format(date)+"";
					taskIcon = "fa fa-check";
					bgStyle = " style='    background-color: #18a689  !important;     color: white !important;' ";
				}
				
			}
			else
			{
				
				if(stagesCleared.get(i-1))
				{
					//if previous stage is cleared then show current
					String sql  ="select * from trainer_empanelment_status where trainer_id = "+trainerID+" and course_id = "+course.getId()+" and stage = '"+stages.get(i)+"'";					
					List<HashMap<String, Object>> statusData = util.executeQuery(sql);					
					Timestamp date = (Timestamp)statusData.get(0).get("created_at");
					String status = statusData.get(0).get("empanelment_status").toString();
					String score ="";
					if(status.equalsIgnoreCase(TrainerEmpanelmentStatusTypes.SELECTED)){
						taskIcon = "fa fa-check";
						bgStyle = " style='    background-color: #18a689  !important;     color: white !important;' ";
					}else if(status.equalsIgnoreCase(TrainerEmpanelmentStatusTypes.REJECTED)){
						taskIcon = "fa fa-times";
						bgStyle = " style='    background-color: #ec4758 !important;     color: white !important;' ";
					}
					else {
						taskIcon = "fa fa-hourglass-end";
						bgStyle = " style='    background-color: #f8ac59 !important;     color: white !important;' ";
					}
					
					if(stages.get(i).equalsIgnoreCase(TrainerEmpanelmentStageTypes.ASSESSMENT_DONE))
					{
						String getScore ="SELECT assessment.id , assessmenttitle, CAST (SUM(score) AS INTEGER) AS user_score, ( SELECT CAST ( COUNT (assessment_question. ID) AS INTEGER ) AS total FROM assessment_question WHERE assessmentid IN ( SELECT DISTINCT assessment_id FROM course_assessment_mapping WHERE course_id = "+courseID+" ) ) FROM report, assessment WHERE assessment.id = report.assessment_id  and user_id = "+trainerID+" AND assessment_id IN ( SELECT DISTINCT assessment_id FROM course_assessment_mapping WHERE course_id = "+courseID+" ) group by assessment.id , assessmenttitle";
						List<HashMap<String, Object>> scoreL3 = util.executeQuery(getScore);
						int userScore = 0;
						int totalScore = 0;
						if(scoreL3.size()>0 )
						{
							for(HashMap<String, Object> row: scoreL3)
							{
								if(row.get("user_score")!=null)
								{
									userScore =  userScore+ ((int)row.get("user_score"));
									totalScore =userScore+ ((int)row.get("total"));
									details +="<a href='/assessment_report?user_id="+trainerID+"&assessment_id="+row.get("id")+"' class='btn btn-sm btn-success'> "+row.get("assessmenttitle")+" </a>&nbsp;&nbsp;";
								} 
							}
							//&& scoreL3.get(0).get("user_score")!=null
							score = "with the score " +  userScore+"/"+totalScore;
							
						}
					}
					else if(stages.get(i).equalsIgnoreCase(TrainerEmpanelmentStageTypes.SME_INTERVIEW) || stages.get(i).equalsIgnoreCase(TrainerEmpanelmentStageTypes.DEMO) ||stages.get(i).equalsIgnoreCase(TrainerEmpanelmentStageTypes.FITMENT_INTERVIEW))
					{
						String getScore ="SELECT  CAST (AVG(rating) AS INTEGER) AS rating FROM interview_rating WHERE trainer_id = "+trainerID+" AND course_id = "+courseID+" and stage_type = '"+stages.get(i)+"'";
						List<HashMap<String, Object>> scoreL3Plus = util.executeQuery(getScore);
						if(scoreL3Plus.size()>0)
						{
							score = "with the score " + scoreL3Plus.get(0).get("rating").toString()+"/5";
						}
						String getComments ="select trainer_comments.comments, user_profile.first_name from trainer_comments, user_profile where trainer_comments.interviewer_id = user_profile.user_id and trainer_comments.course_id = "+courseID+" and trainer_comments.stage = '"+stages.get(i)+"' and trainer_comments.trainer_id = "+trainerID;
						List<HashMap<String, Object>> commentsData = util.executeQuery(getComments);
						if(commentsData.size()>0)
						{
							if(commentsData.get(0).get("comments")!=null)
							{
								interviewerComments = commentsData.get(0).get("comments").toString();
								interviewerName = "by "+commentsData.get(0).get("first_name").toString();
							}							
						}
						
						//details="<a href='/interview_details?user_id="+trainerID+"&course_id="+courseID+"&stage="+stages.get(i)+"' class='btn btn-sm btn-success'> Details </a>";
					}
					
					if(statusData.size()>0)
					{
						 title="The Candidate was <strong>"+StringUtils.capitalize(statusData.get(0).get("empanelment_status").toString())+"</strong>  in stage "+stages.get(i)+" for the position of "
								+ "Trainer - <strong>"+StringUtils.capitalize(course.getCourseName())+" "+score +" "+ interviewerName+"</strong>  on "+format.format(date)+" </p";
						 if(statusData.get(0).get("empanelment_status").toString().equalsIgnoreCase(TrainerEmpanelmentStatusTypes.SELECTED))
						 {
							 stagesCleared.put(i, true);
						 }
					}
					else
					{
						title ="Candidates "+stages.get(i)+" interview is pending.";
					}
				}
				else
				{
					//show this candidate in rejected.
					title ="This candidate was rejected.";
					taskIcon = "fa fa-times";
					bgStyle = " style='    background-color: #ec4758 !important;     color: white !important;' ";
				}	
				 
			}
			sb.append("<div class='vertical-timeline-block no-padding' style='margin: 1em 0 !important;'>   ");
				 sb.append("<div class='vertical-timeline-icon' "+bgStyle+" >       ");
				 sb.append("<i class='"+taskIcon+"'></i>                    ");
				 sb.append("</div>                                             ");
				 sb.append("                                                   ");
				 sb.append("<div class='vertical-timeline-content p-xxs'>      ");
				 System.err.println("iiii"+i);
				 sb.append("<h3>"+stageNames.get(i)+" ("+stages.get(i)+")</h3>");
				 sb.append("<p>"+title+" </p>       ");
				 if(!interviewerComments.equalsIgnoreCase(""))
				 { 
				 sb.append("<p><strong>Comments&nbsp;&nbsp;</strong>"+interviewerComments+" </p>       ");
				 	
				 }
				 if(!details.equalsIgnoreCase(""))
				 	{ 
				 		sb.append(details);
				 	}
				 sb.append("                                                   ");
				 sb.append("                                                   ");			 
				 sb.append("</div>                                             ");
				 sb.append("</div>                                             ");
			
		}
		
		
		sb.append("</div>                                                                                   ");
		sb.append("</div>                                                                                   ");
		sb.append("</div>                                                                                   ");
		sb.append("<div class='back' >                                                                       ");
		sb.append("<div class='ibox-content' id='ibox-content' style='max-height:400px;min-height:400px;'>                                             ");
		sb.append("Back content                                                                             ");
		sb.append("                                                                                         ");
		sb.append("<div class='rateYo'></div>                                                                  ");
		sb.append("<textarea rows='4' cols='50'>At w3schools.com you will learn how to make a website. We o ");
		sb.append("</textarea>                                                                              ");
		sb.append("</div>                                                                                   ");
		sb.append("</div>                                                                                   ");
		sb.append("</div>                                                                                   ");
		sb.append("</div>                                                                                   ");
		return sb;
	}
	
}
