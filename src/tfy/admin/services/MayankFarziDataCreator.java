package tfy.admin.services;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Random;

import javax.persistence.criteria.CriteriaBuilder.In;
import javax.ws.rs.core.Response;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.github.javafaker.Faker;
import com.istarindia.android.pojo.GroupPojo;
import com.istarindia.android.pojo.GroupStudentPojo;
import com.viksitpro.core.utilities.AppProperies;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.TaskItemCategory;
import com.viksitpro.core.utilities.TrainerWorkflowStages;

/**
 * 
 */

/**
 * @author mayank
 *
 */
public class MayankFarziDataCreator {

	/**
	 * @param args
	 */
	public  void main() {
		// TODO Auto-generated method stub
		/* String csvFile = "C:\\Users\\mayank\\Documents\\it.csv";
	        BufferedReader br = null;
	        String line = "";
	        String cvsSplitBy = ",";
	        int college_id = 0;
	        try {
                DBUTILS db = new DBUTILS();
	            br = new BufferedReader(new FileReader(csvFile));
	            while ((line = br.readLine()) != null) {
	                String[] country = line.split(cvsSplitBy);
	                String orgName = country[0];
	                if(college_id==0){
	                String sql = "INSERT INTO address ( id, addressline1, addressline2, pincode_id, address_geo_longitude, address_geo_latitude ) VALUES ( (SELECT COALESCE (MAX(ID) + 1, 1) FROM address ), 'Phase 2', 'Manyata Tech Park', 154819, '73.8834149', '18.4866277' )RETURNING ID;";
	    			int addressId = db.executeUpdateReturn(sql);

	    			sql = "INSERT INTO organization (id, name, org_type, address_id, industry, profile,created_at, updated_at, iscompany, max_student) VALUES "
	    					+ "((select COALESCE(max(id),0)+1 from organization ), '"+orgName+"', 'COLLEGE', "+addressId+", 'EDUCATION', 'NA',  now(), now(), 'f',1000) RETURNING ID;";
	    			college_id = db.executeUpdateReturn(sql);
	    			String  adminEmail= country[1];
	    			
	    			String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) "
							+ "VALUES ((SELECT MAX(id)+1 FROM istar_user), 		'"+adminEmail+"', 'test123', 		now(), 		'9856321474', 		NULL,    'f' 	)RETURNING ID;";
					
					//System.out.println(istarStudentSql);
					int userID  = db.executeUpdateReturn(istarStudentSql);
						
					String insertIntoUserProfile ="INSERT INTO user_profile (id, first_name, last_name,  gender,  user_id) VALUES ((select COALESCE(max(id),0)+1 from user_profile), 'Abhinav', 'Singh', 'MALE', "+userID+");";
					db.executeUpdate(insertIntoUserProfile);

					//Student User Role Mapping
						String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name='ORG_ADMIN'), (SELECT MAX(id)+1 FROM user_role), '1');";
						//System.out.println(userRoleMappingSql);
						db.executeUpdate(userRoleMappingSql);
						String insertIntoOrgMapping="INSERT INTO user_org_mapping (user_id, organization_id, id) VALUES ("+userID+", "+college_id+", (select COALESCE(max(id),0)+1 from user_org_mapping));"; 
						db.executeUpdate(insertIntoOrgMapping);					
	                }
	                else
	                {
	                	String roleName = country[2];
	                	String checkIfRoleExist ="select id from batch_group where name='"+roleName+"' and college_id="+college_id;
	                	List<HashMap<String, Object>> existingRoleData = db.executeQuery(checkIfRoleExist);
	                	int roleId =0;
	                	if(existingRoleData.size()>0 && existingRoleData.get(0).get("id")!=null)
	                	{
	                		 roleId = (int)existingRoleData.get(0).get("id");
	                	}
	                	else
	                	{
	                		//createROle
	                		String createRole ="INSERT INTO batch_group (id, created_at, name, updated_at, college_id, batch_code, assessment_id, bg_desc, year, parent_group_id, type, is_primary, is_historical_group, mode_type, start_date, enrolled_students)  "
	                				+ "VALUES ((select COALESCE(max(id),0)+1 from batch_group), now(), '"+roleName+"', now(), "+college_id+", "+getRandomInteger(100000, 999999)+", '10195', '"+roleName+"', '2017', '1', 'ROLE', 't', 'f','BLENDED', '2017-06-12', 1000) returning id;";
	                		roleId = db.executeUpdateReturn(createRole);	                			                		
	                	}
	                	
	                	String sectionName = country[4];
	                	String checkIFSEctionExist ="select id from batch_group where name='"+sectionName+"' and parent_group_id="+roleId;
	                	List<HashMap<String, Object>> existingSectionData = db.executeQuery(checkIFSEctionExist);
	                	int sectionId=0;
	                	if(existingSectionData.size()>0 && existingSectionData.get(0).get("id")!=null)
	                	{
	                		sectionId = (int)existingSectionData.get(0).get("id");
	                	}
	                	else
	                	{
	                		String createSection ="INSERT INTO batch_group (id, created_at, name, updated_at, college_id, batch_code, assessment_id, bg_desc, year, parent_group_id, type, is_primary, is_historical_group, mode_type, start_date, enrolled_students)  "
	                				+ "VALUES ((select COALESCE(max(id),0)+1 from batch_group), now(), '"+sectionName+"', now(), "+college_id+", "+getRandomInteger(100000, 999999)+", '10195', '"+sectionName+"', '2017', '1', 'SECTION', 'f', 'f','BLENDED', '2017-06-12', 1000) returning id;";
	                		sectionId = db.executeUpdateReturn(createSection);	                		
	                	}
	                	
	                }	
	                
	            }

	        } catch (FileNotFoundException e) {
	            e.printStackTrace();
	        } catch (IOException e) {
	            e.printStackTrace();
	        } finally {
	            if (br != null) {
	                try {
	                    br.close();
	                } catch (IOException e) {
	                    e.printStackTrace();
	                }
	            }
	        }*/
	    System.out.println("start");
		//addStudentInBGOFCollege(272);
		//addStudentInBGOFCollege(273);
		createEventsForGroup(272);
	    
	    //markEventAsCompleteInOrg(272);
		//markEventAsCompleteInOrg(273);
		System.out.println("end");
		System.exit(0);
		
		
	}

	private void createEventsForGroup(int i) {
			
		int trainerID = 0;
		int hours = 0;
		int minute = 0;
		int batchID = 0;
		String eventType = "";
		String eventDate = "";
		String startTime = "";
		int classroomID = 0;
		int AdminUserID = 0;
		
		String eventID = null;
		String associateTrainerID = "";
			insertUpdateData(trainerID, hours, minute, batchID, eventType, eventDate, startTime,
				classroomID, AdminUserID, sessionID, eventID, associateTrainerID);
	}

	private void markEventAsCompleteInOrg(int orgId) {
		
			attendaceCreator(orgId);
	}

	private void attendaceCreator(int orgId) {
		// TODO Auto-generated method stub
		DBUTILS util = new DBUTILS();
		String getTaskBeforeToday ="select * from task where item_id in (select id from batch_schedule_event where type = 'BATCH_SCHEDULE_EVENT_TRAINER' and batch_group_id in (select id from batch_group where college_id = "+orgId+") and eventdate <  '2017-07-28 09:32:00' ) and item_type = 'CLASSROOM_SESSION'";
		List<HashMap<String, Object>> events = util.executeQuery(getTaskBeforeToday);
		for(HashMap<String, Object> row: events)
		{
			int id = (int)row.get("id");
			int actor = (int)row.get("actor");
			com.istarindia.android.pojo.GroupPojo group = new com.istarindia.android.pojo.GroupPojo();
			String getGroupId ="select batch_group_id, batch_group.name from task,batch_schedule_event, batch_group where batch_group.id = batch_schedule_event.batch_group_id and batch_schedule_event.id = task.item_id and task.id ="+id+" and item_type in ('"+TaskItemCategory.CLASSROOM_SESSION+"') ";
			//System.out.println("getGroupId>>>"+getGroupId);
			List<HashMap<String, Object>> groupData = util.executeQuery(getGroupId);
			
			if(groupData.size()>0)
			{
				Random r = new Random();
				int Low = 85;
				int High = 100;
				int Result = r.nextInt(High-Low) + Low;
				
				
				ArrayList<com.istarindia.android.pojo.GroupStudentPojo> students = new ArrayList<>();
				int groupId = (int)groupData.get(0).get("batch_group_id");
				String groupName = groupData.get(0).get("name").toString();
				students = studentsInGroup(groupId,id);				
				int totalStu = students.size();
				int homnayToMarkASPResent = (Result*totalStu)/100;  //60
				ArrayList<GroupStudentPojo> updateList = new ArrayList<>();
				int i= 0;
				for(GroupStudentPojo st :students)
				{
					if(i< homnayToMarkASPResent)
					{
						st.setStatus(true);
					}					
					i++;
					updateList.add(st);
				}								
				
				group.setGroupId(groupId);
				group.setGroupName(groupName);
				group.setStudents(updateList);
				group.setStuCount(students.size());	
				
				submitAttendance(id,actor , group);	
				updateState(id, actor,TrainerWorkflowStages.ATTENDANCE);
			}
			
		}
	}

	public void updateState(int taskId, int istarUserId, String state) {
		
		DBUTILS util = new DBUTILS();
		String fineCourseBGeventId ="select batch_group_id, course_id, id from batch_schedule_event where id = (select item_id from task where id ="+taskId+")";
		List<HashMap<String, Object>> detail = util.executeQuery(fineCourseBGeventId);		
		if(detail.size()>0)
		{
			
			String bgId = detail.get(0).get("batch_group_id").toString();
			String courseId = detail.get(0).get("course_id").toString();
			String id = detail.get(0).get("id").toString();			
			String insertIntoLog="INSERT INTO status_change_log (id, trainer_id, course_id,  created_at, updated_at,  event_type, event_status, event_id, batch_group_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from status_change_log), "+istarUserId+", "+courseId+", now(),now(), 'STATUS_CHANGED', '"+state+"', "+id+",  "+bgId+");";
			util.executeUpdate(insertIntoLog);
			
			String updateBSE="update batch_schedule_event set status ='"+state+"' where id=(select item_id from task where id ="+taskId+")";
			util.executeUpdate(updateBSE);
			
		}	
		
		
	}

	public void submitAttendance(int taskId, int istarUserId, GroupPojo attendanceResponse) {
		
		DBUTILS util = new DBUTILS();
		
		String deleteOldEntry = "delete from attendance where event_id = (select item_id from task where id = "+taskId+")";
		util.executeUpdate(deleteOldEntry);
		for(GroupStudentPojo stu :attendanceResponse.getStudents())
		{
			String status ="ABSENT";
			if(stu.getStatus()!=null && stu.getStatus() )
			{
				status="PRESENT";
			}
			else
			{
				status="ABSENT";
			}	
			String insertIntoAttendance ="INSERT INTO attendance (id, taken_by, user_id, status, created_at, updated_at, event_id) "
					+ "VALUES ((select COALESCE(max(id),0)+1 from attendance), '"+istarUserId+"', '"+stu.getStudentId()+"', '"+status+"', (select start_date from task where id ="+taskId+"), (select start_date from task where id ="+taskId+"), (select item_id from task where id="+taskId+"));";
			util.executeUpdate(insertIntoAttendance);
		}
		
	}

	public ArrayList<com.istarindia.android.pojo.GroupStudentPojo> studentsInGroup(int groupId, int taskID)
	{
		String mediaUrlPath =AppProperies.getProperty("media_url_path");
		ArrayList<com.istarindia.android.pojo.GroupStudentPojo> students = new ArrayList<>();
		DBUTILS utils = new DBUTILS();
		String sql="SELECT 	distinct istar_user. ID, 	CASE WHEN ( 	user_profile.first_name IS NULL ) THEN 	istar_user.email ELSE 	user_profile.first_name END,  user_profile.profile_image,  CASE WHEN (attendance.status IS NULL) THEN 	'ABSENT' ELSE 	attendance.status END FROM "
				+ "	task LEFT JOIN batch_schedule_event ON ( 	task.item_id = batch_schedule_event. ID ) "
				+ "LEFT JOIN batch_students ON ( 	batch_students.batch_group_id = "+groupId+" ) "
				+ "LEFT JOIN istar_user ON ( 	batch_students.student_id = istar_user. ID )"
				+ " LEFT JOIN user_profile ON ( 	istar_user. ID = user_profile.user_id ) "
				+ "LEFT JOIN attendance ON ( 	attendance.event_id = batch_schedule_event. ID 	AND istar_user. ID = attendance.user_id )"
				+ " WHERE 	task. ID = "+taskID+" AND istar_user. ID NOTNULL";
		
		//System.err.println(sql);
		List<HashMap<String, Object>> studentData = utils.executeQuery(sql);
		for(HashMap<String, Object> row : studentData)
		{
			int studentId = (int)row.get("id");
			String name = row.get("first_name").toString();
			String profileImage = "/users/"+name.charAt(0)+".png";
			if(row.get("profile_image")!=null)
			{
				profileImage = row.get("profile_image").toString();
			}
			String status = row.get("status").toString();
			com.istarindia.android.pojo.GroupStudentPojo stu = new com.istarindia.android.pojo.GroupStudentPojo();
			stu.setImageUrl(mediaUrlPath+profileImage);
			stu.setStudentId(studentId);
			stu.setStudentName(name);
			if(status.equalsIgnoreCase("PRESENT")) {
				stu.setStatus(true);
			}else{
				stu.setStatus(false);
			}
			
			
			students.add(stu);
		}
		
		return students;
	}
	private static void addStudentInBGOFCollege(int orgId) {
		String  findBGOfOrg="select * from  batch_group where college_id="+orgId+" and type='ROLE'";
		DBUTILS util = new DBUTILS();
		List<HashMap<String, Object>> bgs = util.executeQuery(findBGOfOrg);
		for(HashMap<String, Object> bg:bgs)
		{
			int bgId = (int)bg.get("id");
			short enrolledStudents = (short)bg.get("enrolled_students");
			ArrayList<Integer> studs = cerateStudentAndAddInRole(bgId, enrolledStudents, orgId);
			int studCountter =0;
			String findSectionsUnderRole = "select * from  batch_group where parent_group_id="+bgId;
			List<HashMap<String, Object>> sections = util.executeQuery(findSectionsUnderRole);
			ArrayList<Integer>addeddInSection = new ArrayList<>();
			for(HashMap<String, Object> section : sections)
			{
				int sectionID = (int)section.get("id");
				
				
				ArrayList<Integer>addeddInSubsection = new ArrayList<>();
				String findSubsection ="select * from  batch_group where parent_group_id="+sectionID;
				List<HashMap<String, Object>> subSections = util.executeQuery(findSubsection);
				for(HashMap<String, Object> subSection : subSections)
				{
					int subSectionID = (int)subSection.get("id");
					short enrolledInSubSEction = (short)subSection.get("enrolled_students");
					for(int i = studCountter; i<enrolledInSubSEction; i++,studCountter++)
					{
						//insertinSubsection;
						
						String insert_into_bg = "insert into batch_students (id, batch_group_id, student_id, user_type) values(((select COALESCE(max(id),0)+1 from batch_students)),"
								+ subSectionID + "," + studs.get(i) + ",'STUDENT')";
						System.out.println(insert_into_bg);
						util.executeUpdate(insert_into_bg);
						addeddInSubsection.add(studs.get(i));
						
					}	
				}
				for(int j : addeddInSubsection)
				{
					//add in section
					String insert_into_bg = "insert into batch_students (id, batch_group_id, student_id, user_type) values(((select COALESCE(max(id),0)+1 from batch_students)),"
							+ sectionID + "," + j + ",'STUDENT')";
					System.out.println(insert_into_bg);
					util.executeUpdate(insert_into_bg);
					addeddInSection.add(j);
				}	
			}
			
		}
	}

	private static ArrayList<Integer> cerateStudentAndAddInRole(int bgId, int enrolledStudents, int orgId) {
		ArrayList<Integer> studs = new ArrayList<>();
		DBUTILS db = new DBUTILS();
		for(int i=0;i<enrolledStudents;i++)
		{
			Faker faker = new Faker();

			String name = faker.name().fullName();
			String firstName = faker.name().firstName().replace("'", "");
			String lastName = faker.name().lastName().replace("'", "");
			String email = faker.name().firstName().toLowerCase()+"@istarindia.com".replace("'", "");
			String mobile = faker.number().digits(10);
			
			// Insert new Student
			
			String sql = "INSERT INTO address ( id, addressline1, addressline2, pincode_id, address_geo_longitude, address_geo_latitude ) VALUES ( (SELECT COALESCE (MAX(ID) + 1, 1) FROM address ), 'Phase 2', 'Manyata Tech Park', 154819, '73.8834149', '18.4866277' )RETURNING ID;";
			int addressId = db.executeUpdateReturn(sql);

			
						String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) VALUES 	( 		(SELECT MAX(id)+1 FROM istar_user), 		'"+email.replace("'", "")+"', 		'test123', 		now(), 		'"+mobile+"', 		NULL,    'f' 	)RETURNING ID;";
						System.out.println(istarStudentSql);
						
						 int userID  = db.executeUpdateReturn(istarStudentSql);
							

						//Student User Role Mapping
							String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name = 'STUDENT'), (SELECT MAX(id)+1 FROM user_role), '1');";
							System.out.println(userRoleMappingSql);
							db.executeUpdate(userRoleMappingSql);
							
							//Trainer Student  User Profile
							String UserProfileSql = "INSERT INTO user_profile ( 	id, 	address_id, 	first_name, 	last_name, 	dob, 	gender, 	user_id, 	aadhar_no ) VALUES 	( 		(SELECT MAX(id)+1 FROM user_profile), 		"+addressId+", 		'"+firstName+"', 		'"+lastName+"', 	NULL,	'MALE',   "+userID+", 		NULL 	); ";
							System.out.println(UserProfileSql);
							db.executeUpdate(UserProfileSql);
							

							//Trainer Student User Org Mapping
							String userOrgMappingSql = "INSERT INTO user_org_mapping ( 	user_id, 	organization_id, 	id ) VALUES 	("+userID+", "+orgId+", (SELECT MAX(id)+1 FROM user_org_mapping));";
							System.out.println(userOrgMappingSql);
							db.executeUpdate(userOrgMappingSql);
							
							String insert_into_bg = "insert into batch_students (id, batch_group_id, student_id, user_type) values(((select COALESCE(max(id),0)+1 from batch_students)),"
									+ bgId + "," + userID + ",'STUDENT')";
							System.out.println(insert_into_bg);
							db.executeUpdate(insert_into_bg);
							studs.add(userID);
							
		}
		return studs;
	}

	public static int getRandomInteger(int maximum, int minimum) {
		return ((int) (Math.random() * (maximum - minimum))) + minimum;
	}
}
