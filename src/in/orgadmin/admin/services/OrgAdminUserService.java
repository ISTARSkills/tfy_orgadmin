package in.orgadmin.admin.services;



import in.recruiter.services.RecruiterServices;

import java.util.*;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.core.dao.entities.Address;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.utilities.DBUTILS;
import com.viksitpro.core.utilities.UserTypes;

public class OrgAdminUserService {

/*	public ArrayList<String> getAllUserTypes() {

		ArrayList<String> userTypesList = new ArrayList<String>();

		userTypesList.add(UserTypes.CONTENT_ADMIN);
		userTypesList.add(UserTypes.STUDENT);
		userTypesList.add(UserTypes.CONTENT_CREATOR);
		userTypesList.add(UserTypes.CONTENT_ADMIN);
		userTypesList.add(UserTypes.SUPER_ADMIN);
		userTypesList.add(UserTypes.ISTAR_COORDINATOR);
		userTypesList.add(UserTypes.CREATIVE_CREATOR);
		userTypesList.add(UserTypes.CREATIVE_ADMIN);
		userTypesList.add(UserTypes.CONTENT_REVIEWER);
		userTypesList.add(UserTypes.TRAINER);
		userTypesList.add(UserTypes.ORG_ADMIN);
		userTypesList.add(UserTypes.RECRUITER);
		userTypesList.add(UserTypes.PRESENTOR);

		return userTypesList;
	}*/

	
	
	public int CreateUsersForAdminPortal(String firstname, String lastname, String email, String password,
			String mobileNumber, String gender, String userType, int college_id) {
				
		
		List<IstarUser> istarUserList = (new IstarUserDAO()).findByEmail(email);
		DBUTILS db = new DBUTILS();
		int userID  = 0;
		 int trainerUserID = 0;
		 int presenterUserID = 0;
		if (istarUserList.size() > 0) {
			System.out.println("A user with this email address already exists of type "
					+ istarUserList.get(0).getUserRoles() + "!");
			return 0;
			
		}
		
		if(userType.equalsIgnoreCase("STUDENT")){
			
			
			// Insert new Student
			String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token ) VALUES 	( 		(SELECT MAX(id)+1 FROM istar_user), 		'"+email+"', 		'"+password+"', 		now(), 		'"+mobileNumber+"', 		NULL 	)RETURNING ID;";
			
			
			 userID  = db.executeUpdateReturn(istarStudentSql);
			 
			//Student User Role Mapping
				String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", '12', (SELECT MAX(id)+1 FROM user_role), '1');";
				db.executeUpdate(userRoleMappingSql);
			
			
		}else if(userType.equalsIgnoreCase("TRAINER")){
			
			String[] presenterEmailaddress = email.split("@");
			String presenterEmail = presenterEmailaddress[0]+"_presenter"+presenterEmailaddress[1];
			
			//Insert new Trainer
			String istarTrainerSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token ) VALUES 	( 		(SELECT MAX(id)+1 FROM istar_user), 		'"+email+"', 		'"+password+"', 		now(), 		'"+mobileNumber+"', 		NULL 	)RETURNING ID;";
		
			//Insert new Presenter 
			String istarPresenterSql =  "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token ) VALUES 	( 		(SELECT MAX(id)+1 FROM istar_user), 		'"+presenterEmail+"', 		'"+password+"', 		now(), 		'"+mobileNumber+"', 		NULL 	)RETURNING ID;";
			
			userID = db.executeUpdateReturn(istarTrainerSql);
			  presenterUserID = db.executeUpdateReturn(istarPresenterSql);
			  
			//Trainer Presenter User Role Mapping
			  String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", '14', (SELECT MAX(id)+1 FROM user_role), '1');"
			  		+ "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+presenterUserID+", '10', (SELECT MAX(id)+1 FROM user_role), '1');";
				db.executeUpdate(userRoleMappingSql);
				
				//Trainer Presenter Mapping
				String trainerPresenterSql = "INSERT INTO trainer_presentor ( 	id, 	trainer_id, 	presentor_id ) VALUES 	((SELECT MAX(id)+1 FROM trainer_presentor), "+userID+", "+presenterUserID+");";
				db.executeUpdate(trainerPresenterSql);
			
			
		}
			
			
			
			
		    //Trainer Student  User Profile
			String UserProfileSql = "INSERT INTO user_profile ( 	id, 	address_id, 	first_name, 	last_name, 	dob, 	gender, 	profile_image, 	user_id, 	aadhar_no ) VALUES 	( 		(SELECT MAX(id)+1 FROM user_profile), 		NULL, 		'"+firstname+"', 		'"+lastname+"', 	NULL,	'"+gender+"', '/video/android_images/"+firstname.toUpperCase().charAt(0)+".png',  "+userID+", 		NULL 	); ";
			System.out.println(UserProfileSql);
			db.executeUpdate(UserProfileSql);
			
			
			//Trainer Student User Org Mapping
			String userOrgMappingSql = "INSERT INTO user_org_mapping ( 	user_id, 	organization_id, 	id ) VALUES 	("+userID+", "+college_id+", (SELECT MAX(id)+1 FROM user_org_mapping));";
			db.executeUpdate(userOrgMappingSql);
			
			
			
			return userID;
		
	}
	
	
	public int UpdateUsersForAdminPortal(int userID,String firstname, String lastname, String email, String password,
			String mobileNumber, String gender, String userType, int college_id) {
				
		DBUTILS db = new DBUTILS();
		
		String updateIstarStudentSql = "UPDATE istar_user SET  'email' = '"+email+"',  'password' = '"+password+"',  'mobile' = '"+mobileNumber+"', WHERE 	('id' = "+userID+");";
		
		db.executeUpdate(updateIstarStudentSql);
		
		String updateUserProfileSql = "UPDATE user_profile SET  'first_name' = '"+firstname+"',  'last_name' = '"+lastname+"',  'gender' = '"+gender+"',  'profile_image' = '/video/android_images/"+firstname.toUpperCase().charAt(0)+".png',  'user_id' = "+userID+",  'aadhar_no' = NULL WHERE 	('id' = '0');";
		
		db.executeUpdate(updateUserProfileSql);
		
		
		return college_id;
		
		
		
	}
	
	
}
	
	
	/*public Student createStudent(String name, String email, String password, String mobileNumber, String gender,
			String userType, Address address) {

		List<IstarUser> istarUserList = (new IstarUserDAO()).findByEmail(email);
		RecruiterServices recruiterServices = new RecruiterServices();

		if (istarUserList.size() > 0) {
			System.out.println("A user with this email address already exists of type "
					+ istarUserList.get(0).getUserType() + "!");
			return null;
		}

		StudentDAO studentDAO = new StudentDAO();
		Student student = new Student();

		student.setName(name);
		student.setEmail(email);
		student.setPassword(password);
		student.setMobile(Long.valueOf(mobileNumber).longValue());
		student.setGender(gender);
		student.setUserType(userType);
		student.setAddress((new AddressDAO()).findById(2));
		student.setIstarAuthorizationToken("t");
		student.setIsVerified(true);
		student.setTokenExpired(false);
		student.setTokenVerified("true");
		student.setCollege(new CollegeDAO().findById(2));
		student.setFatherName("Not Provided");
		student.setMotherName("Not Provided");
		student.setImageUrl("/img/user_images/student.png");

		Session studentSession = studentDAO.getSession();
		Transaction studentTransaction = null;

		try {
			studentTransaction = studentSession.beginTransaction();
			studentDAO.save(student);
			studentTransaction.commit();
		} catch (HibernateException e) {
			if (studentTransaction != null)
				studentTransaction.rollback();
			e.printStackTrace();
		} finally {
			studentSession.flush();
			studentSession.close();
		}
		System.out.println(userType + " Created in Student Table");

		if (!userType.equalsIgnoreCase("PRESENTOR")) {
			StudentProfileDataDAO studentProfileDataDAO = new StudentProfileDataDAO();
			StudentProfileData studentProfileData = new StudentProfileData();

			studentProfileData.setStudent(student);
			studentProfileData.setFirstname(name);
			studentProfileData.setMobileno(Long.valueOf(mobileNumber).longValue());
			studentProfileData.setEmail(email);
			studentProfileData.setGender(gender);
			studentProfileData.setAadharno(Long.valueOf(0).longValue());
			studentProfileData.setProfileImage("/img/user_images/student.png");

			Session studentProfileDataSession = studentProfileDataDAO.getSession();
			Transaction studentProfileDataTransaction = null;

			try {
				studentProfileDataTransaction = studentProfileDataSession.beginTransaction();
				studentProfileDataDAO.save(studentProfileData);
				studentProfileDataTransaction.commit();
			} catch (HibernateException e) {
				if (studentProfileDataTransaction != null)
					studentProfileDataTransaction.rollback();
				e.printStackTrace();
			} finally {
				studentProfileDataSession.flush();
				studentProfileDataSession.close();
			}
			System.out.println(userType + " Created in StudentProfileData Table");

			recruiterServices.sendInviteMail(student.getEmail(), student.getName(), student.getPassword());
		}

		return student;
	}

	public Student CreateOnlyStudent(String firstname, String lastname, String email, String password,
			String mobileNumber, String gender, String userType, Address address, College college) {
		List<IstarUser> istarUserList = (new IstarUserDAO()).findByEmail(email);

		if (istarUserList.size() > 0) {
			System.out.println("A user with this email address already exists of type "
					+ istarUserList.get(0).getUserType() + "!");
			return null;
		}

		StudentDAO studentDAO = new StudentDAO();
		Student student = new Student();

		student.setName(firstname);
		student.setEmail(email);
		student.setPassword(password);
		student.setMobile(Long.valueOf(mobileNumber).longValue());
		student.setGender(gender);
		student.setUserType(userType);
		student.setAddress((new AddressDAO()).findById(2));
		student.setIstarAuthorizationToken("t");
		student.setIsVerified(true);
		student.setTokenExpired(false);
		student.setTokenVerified("true");
		student.setCollege(college);
		student.setFatherName("Not Provided");
		student.setMotherName("Not Provided");
		student.setImageUrl("/video/android_images/"+firstname.toUpperCase().charAt(0)+".png");

		Session studentSession = studentDAO.getSession();
		Transaction studentTransaction = null;

		try {
			studentTransaction = studentSession.beginTransaction();
			studentDAO.save(student);
			studentTransaction.commit();
		} catch (HibernateException e) {
			if (studentTransaction != null)
				studentTransaction.rollback();
			e.printStackTrace();
		} finally {
			studentSession.flush();
			studentSession.close();
		}
		System.out.println(userType + " Created in Student Table");

		if (student != null) {
			StudentProfileDataDAO studentProfileDataDAO = new StudentProfileDataDAO();
			StudentProfileData studentProfileData = new StudentProfileData();

			studentProfileData.setStudent(student);
			studentProfileData.setFirstname(firstname);
			studentProfileData.setLastname(lastname);
			studentProfileData.setMobileno(Long.valueOf(mobileNumber).longValue());
			studentProfileData.setEmail(email);
			studentProfileData.setGender(gender);
			studentProfileData.setAadharno(Long.valueOf(0).longValue());
			studentProfileData.setProfileImage("/video/android_images/"+firstname.toUpperCase().charAt(0)+".png");

			Session studentProfileDataSession = studentProfileDataDAO.getSession();
			Transaction studentProfileDataTransaction = null;

			try {
				studentProfileDataTransaction = studentProfileDataSession.beginTransaction();
				studentProfileDataDAO.save(studentProfileData);
				studentProfileDataTransaction.commit();
			} catch (HibernateException e) {
				if (studentProfileDataTransaction != null)
					studentProfileDataTransaction.rollback();
				e.printStackTrace();
			} finally {
				studentProfileDataSession.flush();
				studentProfileDataSession.close();
			}
		}

		return student;
	}

	public Student updateOnlyStudent(Integer student_id, String firstname, String lastname, String email,
			String password, String mobileNumber, String gender, String userType, Address address, College college) {

		StudentDAO studentDAO = new StudentDAO();
		Student student = studentDAO.findById(student_id);

		student.setName(firstname);
		student.setEmail(email);
		student.setPassword(password);
		student.setGender(gender);
		student.setUserType(userType);
		student.setAddress((new AddressDAO()).findById(2));
		student.setIstarAuthorizationToken("t");
		student.setIsVerified(true);
		student.setTokenExpired(false);
		student.setTokenVerified("true");
		student.setCollege(college);
		student.setFatherName("Not Provided");
		student.setMotherName("Not Provided");
		
		Session studentSession = studentDAO.getSession();
		Transaction studentTransaction = null;

		try {
			studentTransaction = studentSession.beginTransaction();
			studentDAO.merge(student);
			studentTransaction.commit();
		} catch (HibernateException e) {
			if (studentTransaction != null)
				studentTransaction.rollback();
			e.printStackTrace();
		} finally {
			studentSession.flush();
			studentSession.close();
		}
		System.out.println(userType + " Updated in Student Table");

		if (student != null) {

			String sql = "select id from student_profile_data where student_id=" + student.getId();
			DBUTILS db = new DBUTILS();
			List<HashMap<String, Object>> data = db.executeQuery(sql);

			StudentProfileDataDAO studentProfileDataDAO = new StudentProfileDataDAO();

			StudentProfileData studentProfileData = null;
			for (HashMap<String, Object> item : data) {
				studentProfileData = studentProfileDataDAO.findById((int) item.get("id"));
				break;
			}

			if (studentProfileData != null) {
				studentProfileData.setStudent(student);
				studentProfileData.setFirstname(firstname);
				studentProfileData.setLastname(lastname);
				studentProfileData.setEmail(email);
				studentProfileData.setGender(gender);
								
				Session studentProfileDataSession = studentProfileDataDAO.getSession();
				Transaction studentProfileDataTransaction = null;

				try {
					studentProfileDataTransaction = studentProfileDataSession.beginTransaction();
					studentProfileDataDAO.merge(studentProfileData);
					studentProfileDataTransaction.commit();
				} catch (HibernateException e) {
					if (studentProfileDataTransaction != null)
						studentProfileDataTransaction.rollback();
					e.printStackTrace();
				} finally {
					studentProfileDataSession.flush();
					studentProfileDataSession.close();
				}
			}
		}
		return student;
	}

	public Student updateStudent(int studentId, String name, String email, String password, String mobileNumber,
			String gender, String userType, Address address) {

		RecruiterServices recruiterServices = new RecruiterServices();

		StudentDAO studentDAO = new StudentDAO();
		Student student = studentDAO.findById(studentId);

		if (student == null) {
			System.out.println("Invalid Placement Officer ID");
			return null;
		}

		List<IstarUser> istarUserList = (new IstarUserDAO()).findByEmail(email);

		if (istarUserList.size() > 0 && student != istarUserList.get(0)) {
			System.out.println("A user with this email address already exists!");
			return null;
		}

		student.setName(name);
		student.setEmail(email);
		student.setPassword(password);
		student.setMobile(Long.valueOf(mobileNumber).longValue());
		student.setGender(gender);
		student.setUserType(userType);
		student.setAddress((new AddressDAO()).findById(2));
		student.setIstarAuthorizationToken("t");
		student.setIsVerified(true);
		student.setTokenExpired(false);
		student.setTokenVerified("true");
		student.setAddress(address);
		student.setCollege(new CollegeDAO().findById(2));

		Session studentSession = studentDAO.getSession();
		Transaction studentTransaction = null;

		try {
			studentTransaction = studentSession.beginTransaction();
			studentDAO.attachDirty(student);
			studentTransaction.commit();
		} catch (HibernateException e) {
			if (studentTransaction != null)
				studentTransaction.rollback();
			e.printStackTrace();
		} finally {
			studentSession.flush();
			studentSession.close();
		}
		System.out.println(userType + " Updated in Student Table");

		StudentProfileDataDAO studentProfileDataDAO = new StudentProfileDataDAO();
		StudentProfileData studentProfileData = studentProfileDataDAO.findById(student.getStudentProfileData().getId());

		studentProfileData.setStudent(student);
		studentProfileData.setFirstname(name);
		studentProfileData.setMobileno(Long.valueOf(mobileNumber).longValue());
		studentProfileData.setEmail(email);
		studentProfileData.setGender(gender);

		Session studentProfileDataSession = studentProfileDataDAO.getSession();
		Transaction studentProfileDataTransaction = null;

		try {
			studentProfileDataTransaction = studentProfileDataSession.beginTransaction();
			studentProfileDataDAO.attachDirty(studentProfileData);
			studentProfileDataTransaction.commit();
		} catch (HibernateException e) {
			if (studentProfileDataTransaction != null)
				studentProfileDataTransaction.rollback();
			e.printStackTrace();
		} finally {
			studentProfileDataSession.flush();
			studentProfileDataSession.close();
		}
		System.out.println(userType + " Updated in StudentProfileData Table");

		recruiterServices.sendInviteMail(student.getEmail(), student.getName(), student.getPassword());

		return student;
	}

	public void createTrainerPresentor(int studentID, int presentorId) {
		System.out.println("Creating Trainer Presentor Entry in DB");
		IstarUserDAO dao = new IstarUserDAO();
		DBUTILS dbUTILS = new DBUTILS();

		
		 * ArrayList<Integer> trs = new ArrayList<>(); List<IstarUser> trainers
		 * = dao.findAll(); for(IstarUser user : trainers) {
		 * trs.add(user.getId()); } int pres_id = Collections.max(trs)+1;
		 

		String update_TP_mapping_sql = "INSERT INTO trainer_presentor ( id, trainer_id, 	presentor_id ) VALUES 	"
				+ "((SELECT max(id) +1 FROM trainer_presentor ), " + studentID + ", " + presentorId + ")";

		dbUTILS.executeUpdate(update_TP_mapping_sql);
		System.out.println(update_TP_mapping_sql);
	}*/
