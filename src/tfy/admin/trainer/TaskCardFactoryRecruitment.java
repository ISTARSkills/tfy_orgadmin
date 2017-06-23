package tfy.admin.trainer;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import com.istarindia.android.pojo.ComplexObject;
import com.istarindia.android.pojo.DailyTaskPOJO;
import com.istarindia.android.pojo.RestClient;
import com.istarindia.android.pojo.TaskSummaryPOJO;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.TrainerEmpanelmentStageTypes;

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
				+ "	<div class='ibox' style='height: 100%;margin-bottom: 25px !important; '> "
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
		
		DBUTILS util = new  DBUTILS();
		String empanelmentData ="select course.id , course_name, stage, empanelment_status from (WITH summary AS ( SELECT p.trainer_id,p.course_id, p.stage,p.empanelment_status ,    ROW_NUMBER() OVER(PARTITION BY  p.trainer_id,p.course_id  ORDER BY p.id DESC) AS rk   FROM trainer_empanelment_status p where 			 p.trainer_id = "+trainerID+" ) SELECT s.*   FROM summary s  WHERE s.rk = 1 )T1 left join course on (course.id = T1.course_id)";
		List<HashMap<String, Object>> data = util.executeQuery(empanelmentData);
		StringBuffer sb = new StringBuffer();
		sb.append("<div class='product-box' style='height: 100%;' >                                        ");
		sb.append(" <div class='ibox' style='height: 100%;'>                                            ");
		sb.append(" <div class='ibox-content h-370' style='height: 100%;'>                  ");
		sb.append(" <div class='task-complete-header bg-primary'>                 ");
		sb.append(" <h6 class='p-xxs font-normal bg-muted m-l-xs m-t-none'>TODAY'S ");
		sb.append(" ACTIVITY</h6>                                                 ");
		sb.append(" <h3 class='p-xxs m-l-xs'>"+data.size()+" courses applied.</h3>               ");
		sb.append(" </div>                                                        ");
		sb.append(" <div class='product-desc no-padding'>                         ");
		sb.append("                                                               ");
		sb.append("                                                               ");
		sb.append(" <div class='ibox-content no-padding content-border'           ");
		sb.append(" id='ibox-content'>                                            ");
		sb.append("<div id='vertical-timeline' class='vertical-container dark-timeline left-orientation'style=' margin-bottom: 10px !important;'>");
		//iterate
		
		for(HashMap<String, Object> row: data ){
			String taskIcon = "fa fa-desktop";
			String status =row.get("empanelment_status").toString();
			if(row.get("stage").toString().equalsIgnoreCase(TrainerEmpanelmentStageTypes.SIGNED_UP)){
				taskIcon = "fa fa-houzz";
			}else if(row.get("stage").toString().equalsIgnoreCase(TrainerEmpanelmentStageTypes.ASSESSMENT_DONE)){
				taskIcon = "fa fa-houzz";
			}
			else if(row.get("stage").toString().equalsIgnoreCase(TrainerEmpanelmentStageTypes.SME_INTERVIEW)){
				taskIcon = "fa fa-houzz";
			}
			else if(row.get("stage").toString().equalsIgnoreCase(TrainerEmpanelmentStageTypes.DEMO)){
				taskIcon = "fa fa-houzz";
			}
			else if(row.get("stage").toString().equalsIgnoreCase(TrainerEmpanelmentStageTypes.FITMENT_INTERVIEW)){
				taskIcon = "fa fa-houzz";
			}
			
			 sb.append("<div class='vertical-timeline-block no-padding' style='margin: 1em 0 !important;'>   ");
			 sb.append("<div class='vertical-timeline-icon navy-bg'>       ");
			 sb.append("<i class='fa fa-briefcase'></i>                    ");
			 sb.append("</div>                                             ");
			 sb.append("                                                   ");
			 sb.append("<div class='vertical-timeline-content p-xxs'>      ");
			 sb.append("<p>"+row.get("course_name")+"</p>       ");
			 sb.append("                                                   ");
			 sb.append("                                                   ");
			 sb.append("<span class='vertical-date'> <small>"+row.get("stage")+"</small>");
			 sb.append("</span>                                            ");
			 
			 sb.append("<span class='vertical-date pull-right'> <small>"+row.get("empanelment_status")+"</small>");
			 sb.append("</span>                                            ");
			 
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
		StringBuffer sb = new StringBuffer();
		sb.append("<div class='col-lg-4'>				");
		sb.append("<div class='card1' style='max-height:400px;'>                                                                          ");
		sb.append("<div class='front' >                                                                      ");
		sb.append("<div class='ibox-content product-box' id='ibox-content' style='max-height:400px;min-height:400px; overflow-y: auto;'>                                             ");
		sb.append("<div id='vertical-timeline' class='vertical-container dark-timeline '>                   ");
		sb.append("<div class='vertical-timeline-block'>                                                    ");
		sb.append("<div class='vertical-timeline-icon blue-bg'>                                             ");
		sb.append("<i class='fa fa-file-text'></i>                                                          ");
		sb.append("</div>                                                                                   ");
		sb.append("<div class='vertical-timeline-content'>                                                  ");
		sb.append("<h2>Send documents to Mike</h2>                                                          ");
		sb.append("<span class='vertical-date'>                                                             ");
		sb.append("Today <br>                                                                               ");
		sb.append("<small>Dec 24</small>                                                                    ");
		sb.append("</span>                                                                                  ");
		sb.append("</div>                                                                                   ");
		sb.append("</div>                                                                                   ");
		sb.append("<div class='vertical-timeline-block'>                                                    ");
		sb.append("<div class='vertical-timeline-icon blue-bg'>                                             ");
		sb.append("<i class='fa fa-file-text'></i>                                                          ");
		sb.append("</div>                                                                                   ");
		sb.append("<div class='vertical-timeline-content'>                                                  ");
		sb.append("<h2>Send documents to Mike</h2>                                                          ");
		sb.append("<span class='vertical-date'>                                                             ");
		sb.append("Today <br>                                                                               ");
		sb.append("<small>Dec 24</small>                                                                    ");
		sb.append("</span>                                                                                  ");
		sb.append("</div>                                                                                   ");
		sb.append("</div>                                                                                   ");
		sb.append("<div class='vertical-timeline-block'>                                                    ");
		sb.append("<div class='vertical-timeline-icon blue-bg'>                                             ");
		sb.append("<i class='fa fa-file-text'></i>                                                          ");
		sb.append("</div>                                                                                   ");
		sb.append("<div class='vertical-timeline-content'>                                                  ");
		sb.append("<h2>Send documents to Mike</h2>                                                          ");
		sb.append("<span class='vertical-date'>                                                             ");
		sb.append("Today <br>                                                                               ");
		sb.append("<small>Dec 24</small>                                                                    ");
		sb.append("</span>                                                                                  ");
		sb.append("</div>                                                                                   ");
		sb.append("</div>                                                                                   ");
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
