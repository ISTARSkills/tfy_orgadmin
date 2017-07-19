package tfy.admin.trainer;

import java.io.File;
import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;

import javax.persistence.criteria.CriteriaBuilder.In;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.jgroups.util.UUID;
import org.json.simple.JSONObject;
import org.json.simple.JSONArray;
import org.json.simple.parser.JSONParser;

import com.viksitpro.core.dao.entities.Assessment;
import com.viksitpro.core.dao.entities.AssessmentDAO;
import com.viksitpro.core.dao.entities.Course;
import com.viksitpro.core.dao.entities.CourseDAO;
import com.viksitpro.core.dao.entities.IstarNotification;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.utils.task.TaskServices;
import com.viksitpro.core.notification.IstarNotificationServices;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.IStarBaseServelet;
import com.viksitpro.core.utilities.NotificationType;
import com.viksitpro.core.utilities.TrainerEmpanelmentStageTypes;
import com.viksitpro.core.utilities.TrainerEmpanelmentStatusTypes;

@WebServlet("/user_signup")
public class UserSignUp extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	public UserSignUp() {
		super();

	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		IstarNotificationServices notificationService = new IstarNotificationServices();
		printParams(request);
		DBUTILS db = new DBUTILS();
		DateFormat dateformatto = new SimpleDateFormat("yyyy-MM-dd");
		DateFormat dateformatfrom = new SimpleDateFormat("dd/MM/yyyy");
		String firstName = "";
		String lastName = "";
		String email = "";
		String password = "";
		String mobile = "";
		String ugDegree = "";
		String pgDegree = "";
		String gender = "";
		String dob = "";
		String courseIds = "";
		String avaiableTime = "";
		String experinceYears = "";
		String experinceMonths = "";
		String teachingAddress = "";
		String addressLine1 = "";
		String addressLine2 = "";
		String cluster = "";
		String userType = "";
		String panNo = "";
		Long aadharno = 0l;
		float marks10 = 0f;
		int yop10 = 0;
		float marks12 = 0f;
		int yop12 = 0;
		String underGraduationSpecializationName = "";
		float underGradutionMarks = 0f;
		String postGraduationSpecializationName = "";
		float postGradutionMarks = 0f;
		String jobSector = "";
		String companyName = "";
		String position = "";
		int duration = 0;
		String description = "";
		String preferredLocation = "";
		boolean isStudyingFurtherAfterDegree = false;
		String areaOfInterest = "";
		String interestedInTypeOfCourse = "";
		Boolean below_poverty_line = false;
		String place_of_birth = "";
		String father_name = "";
		String caste_category = "";
		String religion = "";
		int pincode = 0;
		boolean hasUgDegree = false;
		boolean hasPgDegree = false;

		firstName = request.getParameter("f_name") != null ? request.getParameter("f_name") : "";
		lastName = request.getParameter("l_name") != null ? request.getParameter("l_name") : "";
		email = request.getParameter("email") != null ? request.getParameter("email") : "";
		password = request.getParameter("password") != null ? request.getParameter("password") : "";
		ugDegree = request.getParameter("ug_degree") != null ? request.getParameter("ug_degree") : null;
		pgDegree = request.getParameter("pg_degree") != null ? request.getParameter("pg_degree") : null;
		gender = request.getParameter("gender") != null ? request.getParameter("gender") : "";
		dob = request.getParameter("dob") != null ? request.getParameter("dob") : "";
		panNo = request.getParameter("pan") != null ? request.getParameter("pan") : "";
		courseIds = request.getParameter("session_id") != null ? request.getParameter("session_id") : "";
		mobile = request.getParameter("mobile") != null ? request.getParameter("mobile") : "0";
		avaiableTime = request.getParameter("avaiable_time") != null ? request.getParameter("avaiable_time") : "";
		teachingAddress = request.getParameter("teaching_address") != null ? request.getParameter("teaching_address")
				: "";
		cluster = request.getParameter("cluster") != null ? request.getParameter("cluster") : "";
		addressLine1 = request.getParameter("address_line1") != null ? request.getParameter("address_line1") : "";
		addressLine2 = request.getParameter("address_line2") != null ? request.getParameter("address_line2") : "";
		aadharno = request.getParameter("aadharno") != null ? Long.parseLong(request.getParameter("aadharno")) : 0l;
		marks10 = request.getParameter("marks10") != null ? Float.parseFloat(request.getParameter("marks10")) : 0f;
		marks12 = request.getParameter("marks12") != null ? Float.parseFloat(request.getParameter("marks12")) : 0f;
		yop10 = request.getParameter("yop10") != null ? Integer.parseInt(request.getParameter("yop10")) : 0;
		yop12 = request.getParameter("yop12") != null ? Integer.parseInt(request.getParameter("yop12")) : 0;
		underGraduationSpecializationName = request.getParameter("underGraduationSpecializationName") != null ? request.getParameter("underGraduationSpecializationName") : "";
		underGradutionMarks = request.getParameter("underGradutionMarks") != null ? Float.parseFloat(request.getParameter("underGradutionMarks")) : 0f;
		postGraduationSpecializationName = request.getParameter("postGraduationSpecializationName") != null ? request.getParameter("postGraduationSpecializationName") : "";
		postGradutionMarks = request.getParameter("postGradutionMarks") != null ? Float.parseFloat(request.getParameter("postGradutionMarks")) : 0f;
		jobSector = request.getParameter("jobSector") != null ? request.getParameter("jobSector") : "";
		companyName = request.getParameter("companyName") != null ? request.getParameter("companyName") : "";
		position = request.getParameter("position") != null ? request.getParameter("position") : "";
		duration = request.getParameter("duration") != null ? Integer.parseInt(request.getParameter("duration")) : 0;
		description = request.getParameter("description") != null ? request.getParameter("description") : "";
		preferredLocation = request.getParameter("preferredLocation") != null ? request.getParameter("preferredLocation") : "";
		isStudyingFurtherAfterDegree = request.getParameter("isStudyingFurtherAfterDegree") != null ? Boolean.getBoolean(request.getParameter("isStudyingFurtherAfterDegree")) : false;
		areaOfInterest = request.getParameter("areaOfInterest") != null ? request.getParameter("areaOfInterest") : "";
		interestedInTypeOfCourse = request.getParameter("interestedInTypeOfCourse") != null ? request.getParameter("interestedInTypeOfCourse") : "";
		below_poverty_line = request.getParameter("below_poverty_line") != null ? Boolean.parseBoolean(request.getParameter("below_poverty_line")) : false;
		place_of_birth = request.getParameter("place_of_birth") != null ? request.getParameter("place_of_birth") : "";
		father_name = request.getParameter("father_name") != null ? request.getParameter("father_name") : "";
		caste_category = request.getParameter("caste_category") != null ? request.getParameter("caste_category") : "";
		religion = request.getParameter("religion") != null ? request.getParameter("religion") : "";
		String student_id = "";
		pincode = request.getParameter("pincode") != null ? Integer.parseInt(request.getParameter("pincode")) : 0;
		experinceMonths = request.getParameter("experince_months") != null ? request.getParameter("experince_months")
				: "";
		experinceYears = request.getParameter("experince_years") != null ? request.getParameter("experince_years") : "";
		userType = request.getParameter("user_type");
		String presentor[] = email.split("@");
		String part1 = presentor[0];
		String part2 = presentor[1];
		String presentor_email = part1 + "_presenter@" + part2;
		JSONParser parser = new JSONParser();
		JSONObject obj;

		IstarUserDAO dao = new IstarUserDAO();
		if (dao.findByEmail(email).size() > 0 || dao.findByEmail(mobile).size() > 0) {
			if (userType.equalsIgnoreCase("STUDENT")) {
				response.sendRedirect("/student_signup.jsp?msg=The Email Address or Mobile Number is in use. ");

			} else {
				
				response.sendRedirect("/trainer_signup.jsp?msg=The Email Address or Mobile Number is in use. ");

			}
		} else {

			try {
				dob = dateformatto.format(dateformatfrom.parse(dob));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			if (ugDegree != null) {
				hasUgDegree = true;

			}
			if (pgDegree != null) {

				hasPgDegree = true;
			}

			if (!userType.equalsIgnoreCase("")) {
				TaskServices taskService = new TaskServices();
				String sql = "INSERT INTO address ( 	ID, 	addressline1, 	addressline2, 	pincode_id, 	address_geo_longitude, 	address_geo_latitude ) VALUES 	( 		(SELECT max(id)+1 FROM address), 		'"
						+ addressLine1 + "', 		'" + addressLine2 + "', 		 (select id from pincode where pin="
						+ pincode + " limit 1), 		 NULL, 		 NULL 	)RETURNING ID;";

				//System.err.println(sql);
				int address_id = db.executeUpdateReturn(sql);

				String insertIntoIstarUser = "INSERT INTO istar_user (id, email, password, created_at, mobile, auth_token, login_type, is_verified) VALUES ((select COALESCE(max(id),0)+1 from istar_user), '"
						+ email + "', '" + password + "', now(), " + mobile + ", NULL, NULL, 't') returning id;";
				//System.err.println(insertIntoIstarUser);
				int urseId = db.executeUpdateReturn(insertIntoIstarUser);
				student_id = urseId+"";
				if (userType.equalsIgnoreCase("TRAINER")) {
					String insertPresentorIntoIstarUser = "INSERT INTO istar_user (id, email, password, created_at, mobile, auth_token, login_type, is_verified) VALUES ((select COALESCE(max(id),0)+1 from istar_user), '"
							+ presentor_email + "', '" + password + "', now(), 9999999999, NULL, NULL, 't') returning id;";
					int presentorId = db.executeUpdateReturn(insertPresentorIntoIstarUser);
					
					String insertIntoUserRole = "INSERT INTO user_role (user_id, role_id, id, priority) VALUES (" + presentorId
							+ ", (select id from role where role_name='PRESENTOR'), ((select COALESCE(max(id),0)+1 from user_role)), 1);";
					db.executeUpdate(insertIntoUserRole);
				}

				String createUserProfile = "INSERT INTO user_profile (id,  first_name, last_name,  gender, user_id,address_id ,dob,aadhar_no,place_of_birth,father_name,caste_category,religion) VALUES ((select COALESCE(max(id),0)+1 from user_profile), '"
						+ firstName + "', '" + lastName + "', '" + gender + "'," + urseId + "," + address_id + " , '"
						+ dob + "', "+aadharno+",'"+place_of_birth+"','"+father_name+"','"+caste_category+"','"+religion+"');";
				//System.err.println(createUserProfile);
				db.executeUpdate(createUserProfile);

				String insertIntoUserRole = "INSERT INTO user_role (user_id, role_id, id, priority) VALUES (" + urseId
						+ ", (select id from role where role_name='" + userType
						+ "'), ((select COALESCE(max(id),0)+1 from user_role)), 1);";
				//System.err.println(insertIntoUserRole);
				db.executeUpdate(insertIntoUserRole);

				String insertIntoProfessionalProfile = "INSERT INTO professional_profile (id, user_id, has_under_graduation,has_post_graduation, under_graduate_degree_name, pg_degree_name, experience_in_years, experince_in_months, pan_no, yop_10, marks_10, yop_12, marks_12, under_graduation_specialization_name, under_gradution_marks, post_graduation_specialization_name, post_gradution_marks, is_studying_further_after_degree, job_sector, preferred_location, company_name, position, duration, description, interested_in_type_of_course, area_of_interest,below_poverty_line) VALUES ((select COALESCE(max(id),0)+1 from professional_profile), "
						+ urseId + ", '" + Boolean.toString(hasUgDegree).charAt(0) + "','"
						+ Boolean.toString(hasPgDegree).charAt(0) + "','" + ugDegree + "','" + pgDegree + "','"
						+ experinceYears + "','" + experinceMonths + "', '"+panNo+"', "+yop10+", "+marks10+", "+yop12+", "+marks12+","
						+ " '"+underGraduationSpecializationName+"' , "+underGradutionMarks+", '"+postGraduationSpecializationName+"',"
						+ " "+postGradutionMarks+", '"+Boolean.toString(isStudyingFurtherAfterDegree).charAt(0)+"', '"+jobSector+"', '"+preferredLocation+"',"
						+ " '"+companyName+"', '"+position+"', '"+duration+"', '"+description+"', '"+interestedInTypeOfCourse+"', '"+areaOfInterest+"', '"+Boolean.toString(below_poverty_line).charAt(0)+"'); ";
				//System.err.println(insertIntoProfessionalProfile);
				db.executeUpdate(insertIntoProfessionalProfile);

				if (userType.equalsIgnoreCase("TRAINER")) {

					

					String insertIntoUserOrg = "INSERT INTO user_org_mapping (user_id, organization_id, id) VALUES ("
							+ urseId + ", 2, ((select COALESCE(max(id),0)+1 from user_org_mapping)));";
					db.executeUpdate(insertIntoUserOrg);
					
					//trainer presentor mapping
					String insertTrainerPresentorMap = "INSERT INTO trainer_presentor (id, trainer_id, presentor_id) VALUES ((SELECT max(id)+1 from trainer_presentor) ,"
							+ " '"+urseId+"', (SELECT id from istar_user where email = '"+presentor_email+"'));";
					db.executeUpdate(insertTrainerPresentorMap);
					
					String groupNotificationCode = UUID.randomUUID().toString();
					if (!courseIds.equalsIgnoreCase("")) {
						String[] courses = courseIds.split(",");
						for (String course_id : courses) {
							String isAlreadyPresent = "SELECT  CAST (COUNT(*) AS INTEGER) as count FROM  trainer_intrested_course WHERE  trainer_id = "+urseId+" AND course_id =  "+course_id;
							List<HashMap<String, Object>> data = db.executeQuery(isAlreadyPresent);
							if((int)data.get(0).get("count") == 0){
							String insertIntoTrainerEmpanelmentStatus = "insert into trainer_empanelment_status (id, trainer_id, empanelment_status,created_at,stage, course_id) values((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "
									+ urseId + ", '" + TrainerEmpanelmentStatusTypes.SELECTED + "',now(), '"
									+ TrainerEmpanelmentStageTypes.SIGNED_UP + "',"+course_id+")";
							db.executeUpdate(insertIntoTrainerEmpanelmentStatus);
							
							String insertIntoTrainerEmpanelmentStatus2 = "insert into trainer_empanelment_status (id, trainer_id, empanelment_status,created_at,stage, course_id) values((select COALESCE(max(id),0)+1 from trainer_empanelment_status), "
									+ urseId + ", '" + TrainerEmpanelmentStatusTypes.SELECTED + "',now(), '"
									+ TrainerEmpanelmentStageTypes.TELEPHONIC_INTERVIEW + "', "+course_id+")";
							db.executeUpdate(insertIntoTrainerEmpanelmentStatus2);
							
							String insertInIntrestedTable = "insert into trainer_intrested_course (id, trainer_id, course_id) values((select COALESCE(max(id),0)+1 from trainer_intrested_course),"
									+ urseId + "," + course_id + ")";
							db.executeUpdate(insertInIntrestedTable);
							}

							Course course = new CourseDAO().findById(Integer.parseInt(course_id));
							String getAssessmentForCourse = "select distinct assessment_id from  course_assessment_mapping where course_id="
									+ course_id;
							List<HashMap<String, Object>> assessments = db.executeQuery(getAssessmentForCourse);
							for (HashMap<String, Object> assess : assessments) {
								int assessmentId = (int) assess.get("assessment_id");
								Assessment assessment = new AssessmentDAO().findById(assessmentId);
								String notificationTitle = "An assessment with title <b>"
										+ assessment.getAssessmenttitle() + "</b> of course <b>"
										+ course.getCourseName() + "</b> has been added to task list.";
								String notificationDescription = notificationTitle;
								String taskTitle = assessment.getAssessmenttitle();
								String taskDescription = notificationDescription;
								int taskId = taskService.createTodaysTask(taskTitle.trim().replace("'", ""),
										taskDescription.trim().replace("'", ""), 300 + "", urseId + "",
										assessmentId + "", "ASSESSMENT");
								IstarNotification istarNotification = notificationService.createIstarNotification(300,
										urseId, notificationTitle, notificationDescription, "UNREAD", null,
										NotificationType.ASSESSMENT, true, taskId, groupNotificationCode);
							}
						}

						String findDefaultAssessment = "select property_value from constant_properties where property_name ='default_assessment_for_trainer'";
						List<HashMap<String, Object>> defaultAssessment = db.executeQuery(findDefaultAssessment);
						if (defaultAssessment.size() > 0) {
							String defAssessments = defaultAssessment.get(0).get("property_value").toString();
							if (defAssessments != null) {
								for (String defAssess : defAssessments.split(",")) {
									int aid = Integer.parseInt(defAssess);
									Assessment assessment = new AssessmentDAO().findById(aid);
									if (assessment != null) {
										String notificationTitle = "An assessment with title <b>"
												+ assessment.getAssessmenttitle() + "</b> has been added to task list.";
										String notificationDescription = notificationTitle;
										String taskTitle = assessment.getAssessmenttitle();
										String taskDescription = notificationDescription;
										int taskId = taskService.createTodaysTask(taskTitle.trim().replace("'", ""),
												taskDescription.trim().replace("'", ""), 300 + "", urseId + "",
												aid + "", "ASSESSMENT");
										IstarNotification istarNotification = notificationService
												.createIstarNotification(300, urseId, notificationTitle,
														notificationDescription, "UNREAD", null,
														NotificationType.ASSESSMENT, true, taskId,
														groupNotificationCode);
									}

								}
							}
						}
					}
					if (!cluster.equalsIgnoreCase("")) {
						try {

							for (String clusterId : cluster.split(",")) {

								String getPincodes = "select DISTINCT pin from pincode where id in (SELECT pincode_id FROM cluster_pincode_mapping where cluster_id = "+clusterId+")";
								List<HashMap<String, Object>> pincodeData = db.executeQuery(getPincodes);
								if(pincodeData.size()>0)
								{
									for(HashMap<String, Object> row: pincodeData)
									{
										
										String ssql = "INSERT INTO trainer_prefred_location ( 	ID, 	trainer_id, 	marker_id, 	prefred_location , pincode)"
												+ " VALUES 	((SELECT COALESCE(max(id)+1,1) FROM trainer_prefred_location), "
												+ urseId + ", 'nn', 'jj',"+row.get("pin")+");";
										db.executeUpdate(ssql);
									}
									
									
								}
								

								
							}

						} catch (Exception e1) {

							e1.printStackTrace();
						}

					}

					if (!avaiableTime.equalsIgnoreCase("")) {
						try {
							obj = (JSONObject) parser.parse(avaiableTime);

							for (Object obja : obj.keySet()) {
								//System.out.println(obja + "--->" + obj.get(obja).toString());
								boolean t8am_9am = false;
								boolean t9am_10am = false;
								boolean t10am_11am = false;
								boolean t11am_12pm = false;
								boolean t12pm_1pm = false;
								boolean t1pm_2pm = false;
								boolean t2pm_3pm = false;
								boolean t4pm_5pm = false;
								boolean t3pm_4pm = false;
								boolean t5pm_6pm = false;

								String day = obja.toString();

								String[] times = obj.get(obja).toString().split("##");

								for (String time : times) {

									//System.err.println("day>>>> " + day + " time>>>>> " + time);

									if (time.equalsIgnoreCase("8:00 AM-9:00 AM")) {
										t8am_9am = true;
									}
									if (time.equalsIgnoreCase("9:00 AM-10:00 AM")) {
										t9am_10am = true;
									}
									if (time.equalsIgnoreCase("10:00 AM-11:00 AM")) {
										t10am_11am = true;
									}
									if (time.equalsIgnoreCase("11:00 AM-12:00 PM")) {
										t11am_12pm = true;
									}
									if (time.equalsIgnoreCase("12:00 PM-1:00 PM")) {
										t12pm_1pm = true;
									}
									if (time.equalsIgnoreCase("1:00 PM-2:00 PM")) {
										t1pm_2pm = true;
									}
									if (time.equalsIgnoreCase("2:00 PM-3:00 PM")) {
										t2pm_3pm = true;
									}
									if (time.equalsIgnoreCase("3:00 PM-4:00 PM")) {
										t3pm_4pm = true;
									}
									if (time.equalsIgnoreCase("4:00 PM-5:00 PM")) {
										t4pm_5pm = true;
									}
									if (time.equalsIgnoreCase("5:00 PM-6:00 PM")) {
										t5pm_6pm = true;
									}
								}

								String ssql = "INSERT INTO trainer_available_time_sloat ( 	ID, 	trainer_id, 	DAY, 	t8am_9am, 	t9am_10am, 	t10am_11am, 	t11am_12pm, 	t12pm_1pm, 	t1pm_2pm, 	t2pm_3pm, 	t3pm_4pm, 	t4pm_5pm, 	t5pm_6pm ) VALUES 	( 		(SELECT COALESCE(max(id)+1,1) FROM trainer_available_time_sloat), 	  "
										+ urseId + ", 		'" + day + "', 		'" + t8am_9am + "', 		'"
										+ t9am_10am + "', 		'" + t10am_11am + "', 		'" + t11am_12pm
										+ "', 		'" + t12pm_1pm + "', 		'" + t1pm_2pm + "', 		'"
										+ t2pm_3pm + "', 		'" + t3pm_4pm + "', 		'" + t4pm_5pm
										+ "', 		'" + t5pm_6pm + "' 	);";

								//System.err.println(ssql);
								db.executeUpdate(ssql);
							}

						} catch (Exception e1) {

							e1.printStackTrace();
							response.sendRedirect("/index.jsp");
						}
					}

				}
			}
			if(!userType.equalsIgnoreCase("STUDENT")){
			response.sendRedirect("/login?email=" + email + "&password=" + password + "");
			}else{
				response.getWriter().print(student_id);
			}
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

}
