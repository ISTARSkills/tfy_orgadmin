/**
 * 
 */
package in.orgadmin.utils.report;

/**
 * @author vaibhav
 *
 */
public class ReportColumnHandlerFactory {

	private static ReportColumnHandlerFactory instance = null;

	protected ReportColumnHandlerFactory() {
		// Exists only to defeat instantiation.
	}

	public static ReportColumnHandlerFactory getInstance() {
		if (instance == null) {
			instance = new ReportColumnHandlerFactory();
		}
		return instance;
	}

	public ColumnHandler getHandler(String columnHandler) {
		switch (columnHandler) {
		case "PROFILE_IMAGE":
			return (new ProfileImageHandler());
		case "STAR_RATING":
			return (new RatingHandler());
		case "USER_HANDLER":
			return (new UserHandler());
		case "BG_ROLE_HANDLER":
			return (new BGRoleHandler());
		case "CHECKBOX_HANDLER":
			return (new RadiButtonHandler());
		/*case "TRAINER_PROFILE_HANDLER":
			return (new TRAINER_PROFILE_HANDLER());*/
		case "TRAINER_ASSESSMENT_LIST_HANDLER":
			return (new TRAINER_ASSESSMENT_LIST_HANDLER());
		case "CLASSROOM_HANDLER":
			return (new CLASSROOM_HANDLER());
		/*case "BATCH_ATTENDANCE_HANDLER":
			return (new BatchAttedanceHandler());
		case "VIEW_ASSESSMENT_DETAILS_HANDLER":
			return (new ViewAssessmentDetailsHandler());
		case "VIEW_ASSESSMENT_REPORT_DETAILS_HANDLER":
			return (new ViewAssessmentReportDetailsHandler());
		case "BATCH_COLUMN_HANDLER":
			return (new BatchColumnHandler());
		case "BOOLEAN_COLUMN_HANDLER":
			return (new BooleanColumnHandler());
		case "DATE":
			return (new DateHandler());
		case "DURATION_HANDLER":
			return (new DurationHandler());
		case "NULL_HANDLER":
			return (new NullColumnHandler());
		case "VIEW_TRAINER":
			return (new VIEW_TRAINERHandler());	
		case "VIEW_STUDENT":
			return (new VIEW_STUDENTHandler());	
		case "EDIT_BATCHGROUP_HANDLER":
			return (new EditBatchgroupHandler());
		case "EDIT_TRAINER_HANDLER":
			return (new EditTrainerHandler());
		case "UPDATE_ATTENDANCE_HANDLER":
			return (new UpdateAttendanceHandler());	
		case "TRAINER_LOGS_HANDLER":
			return (new TrainerLogsHandler());	
		case "VIEW_ATTENDANCE_DETAILS_HANDLER":
			return (new Attendance_Detail_Handler());*/
		default:
			break;
		}
		return null;

	}

}
