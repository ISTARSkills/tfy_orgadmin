package tfy.webapp.ui;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import com.istarindia.android.pojo.ComplexObject;
import com.istarindia.android.pojo.ConcreteItemPOJO;
import com.istarindia.android.pojo.CoursePOJO;
import com.istarindia.android.pojo.DailyTaskPOJO;
import com.istarindia.android.pojo.ModulePOJO;
import com.istarindia.android.pojo.TaskSummaryPOJO;
import com.viksitpro.core.dao.entities.Task;
import com.viksitpro.core.dao.entities.TaskDAO;
import com.viksitpro.core.utilities.AppProperies;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.TaskItemCategory;

import tfy.admin.trainer.TaskCardFactoryRecruitment;

public class TaskCardFactory {

	public StringBuffer showSummaryCard(ComplexObject cp) {
		if(cp.getTasks().size()==0) {
			return new StringBuffer();
		} else {
		
		StringBuffer sb = new StringBuffer();
		Integer taskRemaining = cp.getTasks().size() - cp.getTaskForTodayCompleted().size();
		sb.append("<div class='col-md-3 product-box' style='height: 100%;     width: 22.6%; margin-left: 2.25%;    margin-right: 1.2%;' >                                        ");
		sb.append(" <div class='ibox' style='height: 100%;'>                                            ");
		sb.append(" <div class='ibox-content product-box h-370' style='height: 100%;'>                  ");
		sb.append(" <div class='task-complete-header bg-primary'>                 ");
		sb.append(" <h6 class='p-xxs font-normal bg-muted m-l-xs m-t-none'>TODAY'S ");
		sb.append(" ACTIVITY</h6>                                                 ");
		sb.append(" <h3 class='p-xxs m-l-xs'>"+cp.getTaskForTodayCompleted().size()+" Tasks Completed</h3>               ");
		sb.append(" </div>                                                        ");
		sb.append(" <div class='product-desc no-padding'>                         ");
		sb.append("                                                               ");
		sb.append("                                                               ");
		sb.append(" <div class='ibox-content no-padding content-border'           ");
		sb.append(" id='ibox-content'>                                            ");
		sb.append("<div id='vertical-timeline' class='vertical-container dark-timeline left-orientation'style=' margin-bottom: 10px !important;'>");
		//iterate
		String taskIcon = "fa fa-desktop";
		for(TaskSummaryPOJO taskSummaryPOJO :cp.getTaskCompleted() ){
			if(taskSummaryPOJO.getItemType().equalsIgnoreCase("ASSESSMENT")){
				taskIcon = "fa fa-houzz";
			}
			DateFormat dateFormat = new SimpleDateFormat("hh:mm a");
			String dateString = dateFormat.format(taskSummaryPOJO.getDate());
			 sb.append("<div class='vertical-timeline-block no-padding' style='margin: 1em 0 !important;'>   ");
			 sb.append("<div class='vertical-timeline-icon navy-bg'>       ");
			 sb.append("<i class='fa fa-briefcase'></i>                    ");
			 sb.append("</div>                                             ");
			 sb.append("                                                   ");
			 sb.append("<div class='vertical-timeline-content p-xxs'>      ");
			 sb.append("<p>"+taskSummaryPOJO.getTitle()+"</p>       ");
			 sb.append("                                                   ");
			 sb.append("                                                   ");
			 sb.append("<span class='vertical-date'> <small>"+dateString+"</small>");
			 sb.append("</span>                                            ");
			 if(taskSummaryPOJO.getItemType().equalsIgnoreCase("ASSESSMENT")) {
			 sb.append("<span class='vertical-date pull-right'> <small><a href='/student/assessment_report.jsp?assessment_id="+taskSummaryPOJO.getItemId()+"&user_id="+cp.getId()+"'>View Report</a></small>");
			 sb.append("</span>                                            ");
			 }
			 sb.append("</div>                                             ");
			 sb.append("</div>                                             ");
			 
		}
		sb.append(" </div>");
		
		sb.append("                                                               ");
		sb.append("                                                               ");
		sb.append(" <div class='m-l-lg' style='position: absolute;    bottom: -30px;'>                                          ");
		sb.append(" <i class='fa fa-circle-thin m-r-md'></i>"+taskRemaining+" tasks remaining    ");
		sb.append(" for the day                                                   ");
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
	}

	public StringBuffer showcard(TaskSummaryPOJO task) {
		switch (task.getItemType()) {
		case TaskItemCategory.ASSESSMENT:
			return showAssessmentCard(task);
		case TaskItemCategory.CLASSROOM_ASSESSMENT:
			return showAssessmentCard(task);
		case TaskItemCategory.CLASSROOM_SESSION:
			return showCLASSROOM_SESSIONCard(task);
		case TaskItemCategory.LESSON_PRESENTATION:
				return showLessonPresenationCard(task);
		case TaskItemCategory.CLASSROOM_SESSION_STUDENT:
			return showCLASSROOM_SESSIONStudentCard(task);
		case TaskItemCategory.ZOOM_INTERVIEW_INTERVIEWEE:
			return showZoomInterviewForIntervieweeCard(task);	
		case TaskItemCategory.ZOOM_INTERVIEW_INTERVIEWER:
			return showZoomInterviewForInterviewerCard(task);
		case TaskItemCategory.WEBINAR_TRAINER:
			return showTrainerWebinarCard(task);
		case TaskItemCategory.WEBINAR_STUDENT:
			return showStudentWebinarCard(task);
		case TaskItemCategory.REMOTE_CLASS_TRAINER:
			return showTrainerRemoteClassCard(task);
		case TaskItemCategory.REMOTE_CLASS_STUDENT:
			return showStudentRemoteClassCard(task);		
		default:
			break;
		}
		return new StringBuffer().append("ff");

	}

	private StringBuffer showStudentRemoteClassCard(TaskSummaryPOJO task) {

		StringBuffer sb = new StringBuffer();
		if (task.getHeader() == null) {
			task.setHeader("");
		}
		
			sb.append("<div class='col-md-3 '>													");
			sb.append("<div class='ibox'>														");
			sb.append("<div class='ibox-content product-box h-370'>                             ");
			sb.append("<h6 class='p-xxs font-normal bg-muted m-l-xs'>"+task.getHeader()+"</h6>          ");
			sb.append("<h3 class='p-xxs m-l-xs'>"+task.getTitle()+"</h3>                                ");
			sb.append("<div class='product-imitation'                                           ");
			sb.append("style='padding: 0px !important; background: transparent;'>               ");
			sb.append("<img alt='' class='session-square-img'                                   ");
			sb.append("src='"+task.getImageURL()+"'>                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='product-desc'>                                               ");
			sb.append("<div class='row text-center font-normal bg-muted small p-xxs'>           ");
			sb.append("<div class='col-xs-4 col-md-4'>Time</div>                                ");
			sb.append("<div class='col-xs-4 col-md-4'>Batch</div>                               ");
			sb.append("<div class='col-xs-4 col-md-4'>Location</div>                            ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='row text-center p-xxs' style='font-size:20px;color: #eb384f;'>                                      ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-clock-o'></i>                                            ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-group'></i>                                              ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-home'></i>                                               ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='row text-center font-bold medium p-xxs' style='font-size: 10px;'>                     ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getTime()+"</div>     	            ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getGroupName()+"</div>             ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>ROOM #"+task.getClassRoomId()+"</div>     ");
			sb.append("</div>                                                                   ");
			sb.append("                                                                         ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='m-t text-center button-top'>                                 ");
			sb.append("                                                                         ");
			sb.append("<a class='banner btn btn-rounded' href='/start_remote_class?task_id="+task.getId()+"'>JOIN CLASS</a>           ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
		
		return sb;
	}

	private StringBuffer showTrainerRemoteClassCard(TaskSummaryPOJO task) {

		StringBuffer sb = new StringBuffer();
		if (task.getHeader() == null) {
			task.setHeader("");
		}
		
			
			sb.append("<div class='col-md-3 '>													");
			sb.append("<div class='ibox'>														");
			sb.append("<div class='ibox-content product-box h-370'>                             ");
			sb.append("<h6 class='p-xxs font-normal bg-muted m-l-xs'>"+task.getHeader()+"</h6>          ");
			sb.append("<h3 class='p-xxs m-l-xs'>"+task.getTitle()+"</h3>                                ");
			sb.append("<div class='product-imitation'                                           ");
			sb.append("style='padding: 0px !important; background: transparent;'>               ");
			sb.append("<img alt='' class='session-square-img'                                   ");
			sb.append("src='"+task.getImageURL()+"'>                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='product-desc'>                                               ");
			sb.append("<div class='row text-center font-normal bg-muted small p-xxs'>           ");
			sb.append("<div class='col-xs-4 col-md-4'>Time</div>                                ");
			sb.append("<div class='col-xs-4 col-md-4'>Batch</div>                               ");
			sb.append("<div class='col-xs-4 col-md-4'>Location</div>                            ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='row text-center p-xxs' style='font-size:20px;color: #eb384f;'>                                      ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-clock-o'></i>                                            ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-group'></i>                                              ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-home'></i>                                               ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='row text-center font-bold medium p-xxs' style='font-size: 10px;'>                     ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getTime()+"</div>     	            ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getGroupName()+"</div>             ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>ROOM #"+task.getClassRoomId()+"</div>     ");
			sb.append("</div>                                                                   ");
			sb.append("                                                                         ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='m-t text-center button-top'>                                 ");
			sb.append("                                                                         ");
			sb.append("<a class='banner btn btn-rounded' href='/start_remote_class?task_id="+task.getId()+"'>START CLASS</a>           ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			
		
		
		
		return sb;
	}

	private StringBuffer showStudentWebinarCard(TaskSummaryPOJO task) {
		StringBuffer sb = new StringBuffer();
		if (task.getHeader() == null) {
			task.setHeader("");
		}
		if(task.getTaskContent()!=null && task.getTaskContent().size()>0)
		{	
				
			String startUrl = task.getTaskContent().get("join_url");
			sb.append("<div class='col-md-3 '>													");
			sb.append("<div class='ibox'>														");
			sb.append("<div class='ibox-content product-box h-370'>                             ");
			sb.append("<h6 class='p-xxs font-normal bg-muted m-l-xs'>"+task.getHeader()+"</h6>          ");
			sb.append("<h3 class='p-xxs m-l-xs'>"+task.getTitle()+"</h3>                                ");
			sb.append("<div class='product-imitation'                                           ");
			sb.append("style='padding: 0px !important; background: transparent;'>               ");
			sb.append("<img alt='' class='session-square-img'                                   ");
			sb.append("src='"+task.getImageURL()+"'>                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='product-desc'>                                               ");
			sb.append("<div class='row text-center font-normal bg-muted small p-xxs'>           ");
			sb.append("<div class='col-xs-4 col-md-4'>Time</div>                                ");
			sb.append("<div class='col-xs-4 col-md-4'>Batch</div>                               ");
			sb.append("<div class='col-xs-4 col-md-4'>Location</div>                            ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='row text-center p-xxs' style='font-size:20px;color: #eb384f;'>                                      ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-clock-o'></i>                                            ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-group'></i>                                              ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-home'></i>                                               ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='row text-center font-bold medium p-xxs' style='font-size: 10px;'>                     ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getTime()+"</div>     	            ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getGroupName()+"</div>             ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>ROOM #"+task.getClassRoomId()+"</div>     ");
			sb.append("</div>                                                                   ");
			sb.append("                                                                         ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='m-t text-center button-top'>                                 ");
			sb.append("                                                                         ");
			sb.append("<a class='banner btn btn-rounded' href='/start_webinar?task_id="+task.getId()+"'>JOIN WEBINAR</a>           ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
		}
		return sb;
	}

	private StringBuffer showTrainerWebinarCard(TaskSummaryPOJO task) {
		StringBuffer sb = new StringBuffer();
		if (task.getHeader() == null) {
			task.setHeader("");
		}
		if(task.getTaskContent()!=null && task.getTaskContent().size()>0)
		{	
			
			String startUrl = task.getTaskContent().get("start_url");
			
			
			sb.append("<div class='col-md-3 '>													");
			sb.append("<div class='ibox'>														");
			sb.append("<div class='ibox-content product-box h-370'>                             ");
			sb.append("<h6 class='p-xxs font-normal bg-muted m-l-xs'>"+task.getHeader()+"</h6>          ");
			sb.append("<h3 class='p-xxs m-l-xs'>"+task.getTitle()+"</h3>                                ");
			sb.append("<div class='product-imitation'                                           ");
			sb.append("style='padding: 0px !important; background: transparent;'>               ");
			sb.append("<img alt='' class='session-square-img'                                   ");
			sb.append("src='"+task.getImageURL()+"'>                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='product-desc'>                                               ");
			sb.append("<div class='row text-center font-normal bg-muted small p-xxs'>           ");
			sb.append("<div class='col-xs-4 col-md-4'>Time</div>                                ");
			sb.append("<div class='col-xs-4 col-md-4'>Batch</div>                               ");
			sb.append("<div class='col-xs-4 col-md-4'>Location</div>                            ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='row text-center p-xxs' style='font-size:20px;color: #eb384f;'>                                      ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-clock-o'></i>                                            ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-group'></i>                                              ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-home'></i>                                               ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='row text-center font-bold medium p-xxs' style='font-size: 10px;'>                     ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getTime()+"</div>     	            ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getGroupName()+"</div>             ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>ROOM #"+task.getClassRoomId()+"</div>     ");
			sb.append("</div>                                                                   ");
			sb.append("                                                                         ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='m-t text-center button-top'>                                 ");
			sb.append("                                                                         ");
			sb.append("<a class='banner btn btn-rounded' href='/start_webinar?task_id="+task.getId()+"'>START WEBINAR</a>           ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			
		}
		
		
		return sb;
	}

	private StringBuffer showZoomInterviewForInterviewerCard(TaskSummaryPOJO task) {
		StringBuffer sb = new StringBuffer();
		if (task.getHeader() == null) {
			task.setHeader("");
		}
		if(task.getTaskContent()!=null && task.getTaskContent().size()>0)
			{	
				
				int interviewerId = Integer.parseInt(task.getTaskContent().get("interviewer_id"));
				int intervieweeId = Integer.parseInt(task.getTaskContent().get("interviewee_id"));
				int courseId = Integer.parseInt(task.getTaskContent().get("course_id"));
				
				sb.append(new TaskCardFactoryRecruitment().showCourseCard(intervieweeId, courseId, interviewerId,true));
				
			}
		
		return sb;
	}
	
	private StringBuffer showZoomInterviewForIntervieweeCard(TaskSummaryPOJO task) {
		StringBuffer sb = new StringBuffer();
		if (task.getHeader() == null) {
			task.setHeader("");
		}
		if(task.getTaskContent()!=null && task.getTaskContent().size()>0)
		{	
			String interviewerName =task.getTaskContent().get("interviewer_name");
			String intervieweeName =task.getTaskContent().get("interviewee_name");
			
			String joinUrl =task.getTaskContent().get("join_url");
			sb.append("<div class='col-md-3 '>													");
			sb.append("<div class='ibox'>														");
			sb.append("<div class='ibox-content product-box h-370'>                             ");
			sb.append("<h6 class='p-xxs font-normal bg-muted m-l-xs'>"+task.getHeader()+"</h6>          ");
			sb.append("<h3 class='p-xxs m-l-xs'>"+task.getTitle()+"</h3>                                ");
			sb.append("<div class='product-imitation'                                           ");
			sb.append("style='padding: 0px !important; background: transparent;'>               ");
			sb.append("<img alt='' class='session-square-img'                                   ");
			sb.append("src='"+task.getImageURL()+"'>                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='product-desc'>                                               ");
			sb.append("<div class='row text-center font-normal bg-muted small p-xxs'>           ");
			sb.append("<div class='col-xs-4 col-md-4'>Time</div>                                ");
			sb.append("<div class='col-xs-4 col-md-4'>Interviewer</div>                               ");
			sb.append("<div class='col-xs-4 col-md-4'>Duration</div>                            ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='row text-center p-xxs' style='font-size:20px;color: #eb384f;'>                                      ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-clock-o'></i>                                            ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-group'></i>                                              ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='col-xs-4 col-md-4'>                                          ");
			sb.append("<i class='fa fa-home'></i>                                               ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='row text-center font-bold medium p-xxs' style='font-size: 10px;'>                     ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getTime()+"</div>     	            ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+interviewerName+"</div>             ");
			sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getDurationMinutes()+" mins</div>     ");
			sb.append("</div>                                                                   ");
			sb.append("                                                                         ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("<div class='m-t text-center button-top'>                                 ");
			sb.append("                                                                         ");
			sb.append("<a class='banner btn btn-rounded' target='_blank' href='"+joinUrl+"?uname="+intervieweeName+"'>JOIN INTERVIEW</a>           ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
			sb.append("</div>                                                                   ");
		}
		return sb;
	}

	private StringBuffer showCLASSROOM_SESSIONStudentCard(TaskSummaryPOJO task) {
		StringBuffer sb = new StringBuffer();
		if (task.getHeader() == null) {
			task.setHeader("");
		}
		sb.append("<div class='col-md-3 '>													");
		sb.append("<div class='ibox'>														");
		sb.append("<div class='ibox-content product-box h-370'>                             ");
		sb.append("<h6 class='p-xxs font-normal bg-muted m-l-xs'>"+task.getHeader()+"</h6>          ");
		sb.append("<h3 class='p-xxs m-l-xs'>"+task.getTitle()+"</h3>                                ");
		sb.append("<div class='product-imitation'                                           ");
		sb.append("style='padding: 0px !important; background: transparent;'>               ");
		sb.append("<img alt='' class='session-square-img'                                   ");
		sb.append("src='"+task.getImageURL()+"'>                   ");
		sb.append("</div>                                                                   ");
		sb.append("<div class='product-desc'>                                               ");
		sb.append("<div class='row text-center font-normal bg-muted small p-xxs'>           ");
		sb.append("<div class='col-xs-4 col-md-4'>Time</div>                                ");
		sb.append("<div class='col-xs-4 col-md-4'>Batch</div>                               ");
		sb.append("<div class='col-xs-4 col-md-4'>Location</div>                            ");
		sb.append("</div>                                                                   ");
		sb.append("<div class='row text-center p-xxs' style='font-size:20px;color: #eb384f;'>                                      ");
		sb.append("<div class='col-xs-4 col-md-4'>                                          ");
		sb.append("<i class='fa fa-clock-o'></i>                                            ");
		sb.append("</div>                                                                   ");
		sb.append("<div class='col-xs-4 col-md-4'>                                          ");
		sb.append("<i class='fa fa-group'></i>                                              ");
		sb.append("</div>                                                                   ");
		sb.append("<div class='col-xs-4 col-md-4'>                                          ");
		sb.append("<i class='fa fa-home'></i>                                               ");
		sb.append("</div>                                                                   ");
		sb.append("</div>                                                                   ");
		sb.append("<div class='row text-center font-bold medium p-xxs' style='font-size: 10px;'>                     ");
		sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getTime()+"</div>     	            ");
		sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getGroupName()+"</div>             ");
		sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>ROOM #"+task.getClassRoomId()+"</div>     ");
		sb.append("</div>                                                                   ");
		sb.append("                                                                         ");
		sb.append("</div>                                                                   ");
		sb.append("</div>                                                                   ");
		sb.append("<div class='m-t text-center button-top'>                                 ");
		sb.append("                                                                         ");
		sb.append("<a class='banner btn btn-rounded' href='/student/sync_class.jsp?task_id="+task.getId()+"'>JOIN CLASS</a>           ");
		sb.append("</div>                                                                   ");
		sb.append("</div>                                                                   ");
		sb.append("</div>                                                                   ");
		return sb;
	}

	private StringBuffer showLessonPresenationCard(TaskSummaryPOJO task) {
		StringBuffer sb = new StringBuffer();
		if (task.getHeader() == null) {
			task.setHeader("");
		}
		
		sb.append("<div class='col-md-3 '>												");
		sb.append("<div class='ibox'>                                                   ");
		sb.append("<div class='ibox-content product-box h-370'>                         ");
		sb.append("<h6 class='p-xxs font-normal bg-muted m-l-xs'>"+task.getHeader()+"</h6>          ");
		sb.append("<h3 class='p-xxs m-l-xs'>"+task.getTitle()+"</h3>                                ");
		sb.append("<div class='product-imitation' style='padding: 0px !important;'>     ");
		sb.append("<img alt=''                                                          ");
		sb.append("src='"+task.getImageURL()+"'                ");
		sb.append("style='width: 100%;'>                                                ");
		sb.append("</div>                                                               ");
		sb.append("<div class='product-desc'>                                           ");
		sb.append("                                                                     ");
		sb.append("                                                                     ");
		sb.append("<div class='medium m-t-xs'>"+task.getDescription()+"</div>                             ");
		sb.append("                                                                     ");
		sb.append("</div>                                                               ");
		sb.append("</div>                                                               ");
		sb.append("<div class='m-t text-center button-top'>                             ");
		sb.append("                                                                     ");
		sb.append("<a target='_blank' class='banner btn btn-rounded' href='/student/presentation.jsp?lesson_id="+task.getItemId()+"&task_id="+task.getId()+"'>START                 ");
		sb.append("PRESENTATION</a>                                                     ");
		sb.append("</div>                                                               ");
		sb.append("</div>                                                               ");
		sb.append("</div>                                                               ");
		return sb;
	}

	private StringBuffer showCLASSROOM_SESSIONCard(TaskSummaryPOJO task) {
		StringBuffer sb = new StringBuffer();
		if (task.getHeader() == null) {
			task.setHeader("");
		}
		sb.append("<div class='col-md-3 '>													");
		sb.append("<div class='ibox'>														");
		sb.append("<div class='ibox-content product-box h-370'>                             ");
		sb.append("<h6 class='p-xxs font-normal bg-muted m-l-xs'>"+task.getHeader()+"</h6>          ");
		sb.append("<h3 class='p-xxs m-l-xs'>"+task.getTitle()+"</h3>                                ");
		sb.append("<div class='product-imitation'                                           ");
		sb.append("style='padding: 0px !important; background: transparent;'>               ");
		sb.append("<img alt='' class='session-square-img'                                   ");
		sb.append("src='"+task.getImageURL()+"'>                   ");
		sb.append("</div>                                                                   ");
		sb.append("<div class='product-desc'>                                               ");
		sb.append("<div class='row text-center font-normal bg-muted small p-xxs'>           ");
		sb.append("<div class='col-xs-4 col-md-4'>Time</div>                                ");
		sb.append("<div class='col-xs-4 col-md-4'>Batch</div>                               ");
		sb.append("<div class='col-xs-4 col-md-4'>Location</div>                            ");
		sb.append("</div>                                                                   ");
		sb.append("<div class='row text-center p-xxs' style='font-size:20px;color: #eb384f;'>                                      ");
		sb.append("<div class='col-xs-4 col-md-4'>                                          ");
		sb.append("<i class='fa fa-clock-o'></i>                                            ");
		sb.append("</div>                                                                   ");
		sb.append("<div class='col-xs-4 col-md-4'>                                          ");
		sb.append("<i class='fa fa-group'></i>                                              ");
		sb.append("</div>                                                                   ");
		sb.append("<div class='col-xs-4 col-md-4'>                                          ");
		sb.append("<i class='fa fa-home'></i>                                               ");
		sb.append("</div>                                                                   ");
		sb.append("</div>                                                                   ");
		sb.append("<div class='row text-center font-bold medium p-xxs' style='font-size: 10px;'>                     ");
		sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getTime()+"</div>     	            ");
		sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getGroupName()+"</div>             ");
		sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>ROOM #"+task.getClassRoomId()+"</div>     ");
		sb.append("</div>                                                                   ");
		sb.append("                                                                         ");
		sb.append("</div>                                                                   ");
		sb.append("</div>                                                                   ");
		sb.append("<div class='m-t text-center button-top'>                                 ");
		sb.append("                                                                         ");
		sb.append("<a class='banner btn btn-rounded' href='#'>START CLASS</a>           ");
		sb.append("</div>                                                                   ");
		sb.append("</div>                                                                   ");
		sb.append("</div>                                                                   ");
		return sb;
	}

	private StringBuffer showAssessmentCard(TaskSummaryPOJO task) {
		// TODO Auto-generated method stub
		Task taskObject = new TaskDAO().findById(task.getId());

		String url = "/student/user_assessment.jsp?task_id="+task.getId()+"&assessment_id="+task.getItemId()+"&user_id="+taskObject.getIstarUserByActor().getId();
		StringBuffer sb = new StringBuffer();
		if (task.getHeader() == null) {
			task.setHeader("");
		}

		if(task.getImageURL() == null){
			task.setImageURL("http://cdn.talentify.in:9999//course_images/assessment.png");
		}
		sb.append("<div class='col-md-3 '>                                            ");
		sb.append("<div class='ibox'>                                                 ");
		sb.append("<div style='' class='ibox-content product-box h-370'>              ");
		sb.append("<h6 class='p-xxs font-normal bg-muted m-l-xs'>"+task.getItemType()+"</h6>          ");
		sb.append("<h3 class='p-xxs m-l-xs'>"+task.getTitle()+"</h3>      ");
		sb.append("<div class='product-imitation'                                     ");
		sb.append("style='padding: 0px !important; background: transparent;'>         ");
		sb.append("<img alt='' style='width: 75%;'                                   ");
		sb.append("src='"+task.getImageURL()+"'>       ");
		sb.append("</div>                                                             ");
		sb.append("<div class='product-desc'>                                         ");
		sb.append("<div class='row text-center font-bold medium' '>                     ");
		sb.append("<div class='col-xs-4 col-md-4' '>"+task.getNumberOfQuestions()+"</div>                             ");
		sb.append("<div class='col-xs-4 col-md-4'>"+task.getItemPoints()+"</div>                             ");
		sb.append("<div class='col-xs-4 col-md-4' >"+task.getDuration()+"</div>                            ");
		sb.append("</div>                                                             ");
		sb.append("<div class='row text-center font-normal bg-muted small' >           ");
		sb.append("<div class='col-xs-4 col-md-4'>Questions</div>                     ");
		sb.append("<div class='col-xs-4 col-md-4'>Experience</div>                    ");
		sb.append("<div class='col-xs-4 col-md-4' >Time Limit</div>                    ");
		sb.append("</div>                                                             ");
		sb.append("</div>                                                             ");
		sb.append("</div>                                                             ");
		sb.append("<div class='m-t text-center button-top'>                           ");
		sb.append("<a class='banner btn btn-rounded' href='"+url+"' target='_blank'>START ASSESSMENT</a>           ");
		sb.append("</div>                                                             ");
		sb.append("</div>                                                             ");
		sb.append("</div>                                                             ");
		return sb;
	}

	
	public StringBuffer showSummaryEvents(ComplexObject cp) {
		StringBuffer sb = new StringBuffer();
		sb.append("<div class='col-md-3 product-box ' style='overflow-y: auto;    max-height: 360px !important;    margin-left: 16px;    width: 22.6%; '>			"
				+ "	<div class='ibox' style='height: 100%;margin-bottom:0px !important'> "
				+ "<div class='ibox-content ' style='height: 100%; min-height:345px;margin-bottom:0px !important'> " +AppProperies.generatePopOver("task_summary_card"));			
		sb.append("<h3>Welcome "+cp.getStudentProfile().getFirstName()+"</h3>                                                                  ");
		sb.append("<small>You have "+cp.getEventsToday().size() +" events and "+cp.getNotificationsValid()+" notifications.</small>                                 ");
		sb.append("<ul class='list-group clear-list m-t'>  ");
		String[] class1={"primary","information","success","warning","danger"};
		
		int i=1;
		for (DailyTaskPOJO event : cp.getEventsToday()) {
			DateFormat dateFormat = new SimpleDateFormat("hh:mm a");
			String dateString = dateFormat.format(event.getStartDate());
			int rnd = (new Random()).nextInt(4);
		sb.append("<li class='list-group-item' style='margin-left: -16px;     margin-right: -13px;'	>                                                   ");
		sb.append("<div class='row'><div class='col-md-1  no-padding' style='    margin-top: 0px;'><span class='label label-"+class1[rnd]+"'>"+(i++)+"</span></div>"
				+ "<div class='col-md-1  no-padding'></div><div class='col-md-7 no-padding' style='font-size: 12px;'>"+event.getName()+"</div>"
				+ "<div class='col-md-3	 no-padding'>"+dateString+"</div></div>");
		sb.append("</li>                                                                                    ");
		}                                                                              
		sb.append("</ul>                                                                                    ");
		sb.append("</div> </div> </div>                                                                                   ");

		return sb;
	}
}

