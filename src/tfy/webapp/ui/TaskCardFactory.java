package tfy.webapp.ui;

import java.util.List;

import com.istarindia.android.pojo.TaskSummaryPOJO;
import com.viksitpro.core.utilities.TaskItemCategory;

public class TaskCardFactory {

	public StringBuffer showSummaryCard(List<TaskSummaryPOJO> filterTaskList ) {
		
		StringBuffer sb = new StringBuffer();
	
		sb.append("<div class='col-md-3 '>                                        ");
		sb.append(" <div class='ibox'>                                            ");
		sb.append(" <div class='ibox-content product-box h-370'>                  ");
		sb.append(" <div class='task-complete-header bg-primary'>                 ");
		sb.append(" <h6 class='p-xxs font-normal bg-muted m-l-xs m-t-none'>TODAY'S ");
		sb.append(" ACTIVITY</h6>                                                 ");
		sb.append(" <h3 class='p-xxs m-l-xs'>4 Tasks Completed</h3>               ");
		sb.append(" </div>                                                        ");
		sb.append(" <div class='product-desc no-padding'>                         ");
		sb.append("                                                               ");
		sb.append("                                                               ");
		sb.append(" <div class='ibox-content no-padding content-border'           ");
		sb.append(" id='ibox-content'>                                            ");
		sb.append("<div id='vertical-timeline' class='vertical-container dark-timeline left-orientation'>");
		//iterate
		for(TaskSummaryPOJO taskSummaryPOJO :filterTaskList ){
			 sb.append("<div class='vertical-timeline-block no-padding'>   ");
			 sb.append("<div class='vertical-timeline-icon navy-bg'>       ");
			 sb.append("<i class='fa fa-briefcase'></i>                    ");
			 sb.append("</div>                                             ");
			 sb.append("                                                   ");
			 sb.append("<div class='vertical-timeline-content p-xxs'>      ");
			 sb.append("<p>Introduction to Written Communication</p>       ");
			 sb.append("                                                   ");
			 sb.append("                                                   ");
			 sb.append("<span class='vertical-date'> <small>00:00 AM</small>");
			 sb.append("</span>                                            ");
			 sb.append("</div>                                             ");
			 sb.append("</div>                                             ");
			 
		}
		sb.append(" </div>");
		
		sb.append("                                                               ");
		sb.append("                                                               ");
		sb.append(" <div class='m-l-lg'>                                          ");
		sb.append(" <i class='fa fa-circle-thin m-r-md'></i>16 tasks remaining    ");
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
		
		default:
			break;
		}
		return new StringBuffer().append("ff");

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
		sb.append("<a target='_blank' class='btn btn-rounded' href='/student/presentation.jsp?lesson_id="+task.getItemId()+"'>START                 ");
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
		sb.append("<div class='row text-center font-bold medium p-xxs'>                     ");
		sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getTime()+"</div>     	            ");
		sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>"+task.getGroupName()+"</div>             ");
		sb.append("<div class='col-xs-4 col-md-4' style='padding-left:3px;padding-right:3px'>ROOM #"+task.getClassRoomId()+"</div>     ");
		sb.append("</div>                                                                   ");
		sb.append("                                                                         ");
		sb.append("</div>                                                                   ");
		sb.append("</div>                                                                   ");
		sb.append("<div class='m-t text-center button-top'>                                 ");
		sb.append("                                                                         ");
		sb.append("<a class='btn btn-rounded' href='#'>START CLASS</a>           ");
		sb.append("</div>                                                                   ");
		sb.append("</div>                                                                   ");
		sb.append("</div>                                                                   ");
		return sb;
	}

	private StringBuffer showAssessmentCard(TaskSummaryPOJO task) {
		// TODO Auto-generated method stub
		StringBuffer sb = new StringBuffer();
		if (task.getHeader() == null) {
			task.setHeader("");
		}

		if(task.getImageURL() == null){
			task.setImageURL("http://cdn.talentify.in//course_images/assessment.png");
		}
		sb.append(
				"<div class='col-md-3 '> 						<div class='ibox'> 							<div class='ibox-content product-box h-370'> 								<h6 class='p-xxs font-normal bg-muted m-l-xs'>"
						+ task.getHeader() + "</h6> 								<h3 class='p-xxs m-l-xs'>"
						+ task.getTitle()
						+ "</h3> 								<div class='product-imitation' 									style='padding: 0px !important; background: transparent;'> 									<img alt='' class='img-circle assessment-circle-img' 										src='"
						+ task.getImageURL()
						+ "'> 								</div> 								<div class='product-desc'>   									<div class='medium m-t-xs'>"
						+ "Many desktop publishing 										packages and web page editors now.Many desktop publishing 										packages and web page editors now."
						+ "</div> 									<br /> 									<div class='row text-center font-bold medium'> 										<div class='col-xs-4 col-md-4'>"
						+ task.getNumberOfQuestions()
						+ "</div> 										<div class='col-xs-4 col-md-4'>"
						+ task.getItemPoints()
						+ "</div> 										<div class='col-xs-4 col-md-4'>"
						+ task.getDuration()
						+ "</div> 									</div> 									<div class='row text-center font-normal bg-muted small'> 										<div class='col-xs-4 col-md-4'>Questions</div> 										<div class='col-xs-4 col-md-4'>Experience</div> 										<div class='col-xs-4 col-md-4'>Time Limit</div> 									</div>  								</div> 							</div> 							<div class='m-t text-center button-top'>  								<a class='btn btn-rounded' href='#'>START 									ASSESSMENT</a> 							</div> 						</div> 					</div>");
		return sb;
	}

}
