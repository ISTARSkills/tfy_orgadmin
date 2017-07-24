package in.orgadmin.admin.services;




import java.util.*;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.core.dao.entities.Address;
import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.utilities.DBUTILS;

public class OrgAdminUserService {



	
	
	public int CreateUsersForAdminPortal(String firstname, String lastname, String email, String password,
			String mobileNumber, String gender, String userType, int college_id) {
				
		
		List<IstarUser> istarUserList = (new IstarUserDAO()).findByEmail(email);
		DBUTILS db = new DBUTILS();
		int userID  = 0;
		 int trainerUserID = 0;
		 int presenterUserID = 0;
		if (istarUserList.size() > 0) {
			//System.out.println("A user with this email address already exists of type "
				//	+ istarUserList.get(0).getUserRoles() + "!");
			return 0;
			
		}
		
		if(userType.equalsIgnoreCase("STUDENT")){
			
			
			// Insert new Student
			String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) VALUES 	( 		(SELECT MAX(id)+1 FROM istar_user), 		'"+email+"', 		'"+password+"', 		now(), 		'"+mobileNumber+"', 		NULL,    'f' 	)RETURNING ID;";
			
			
			 userID  = db.executeUpdateReturn(istarStudentSql);
				//System.out.println(istarStudentSql);

			//Student User Role Mapping
				String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name = 'STUDENT'), (SELECT MAX(id)+1 FROM user_role), '1');";
				db.executeUpdate(userRoleMappingSql);
				//System.out.println(userRoleMappingSql);

			
		}else if(userType.equalsIgnoreCase("TRAINER")){
			
			String[] presenterEmailaddress = email.split("@");
			String presenterEmail = presenterEmailaddress[0]+"_presenter@"+presenterEmailaddress[1];
			
			//Insert new Trainer
			String istarTrainerSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) VALUES 	( 		(SELECT MAX(id)+1 FROM istar_user), 		'"+email+"', 		'"+password+"', 		now(), 		'"+mobileNumber+"', 		NULL,    'f' 	)RETURNING ID;";
		
			//Insert new Presenter 
			String istarPresenterSql =  "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) VALUES 	( 		(SELECT MAX(id)+1 FROM istar_user), 		'"+presenterEmail+"', 		'"+password+"', 		now(), 		'"+mobileNumber+"', 		NULL,    'f' 	)RETURNING ID;";
			
			userID = db.executeUpdateReturn(istarTrainerSql);
		   presenterUserID = db.executeUpdateReturn(istarPresenterSql);
		  
			  
			//Trainer Presenter User Role Mapping
			  String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name = 'TRAINER'), (SELECT MAX(id)+1 FROM user_role), '1');"
			  		+ "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+presenterUserID+", (select id from role where role_name = 'PRESENTOR'), (SELECT MAX(id)+1 FROM user_role), '1');";
				db.executeUpdate(userRoleMappingSql);
			
				//Trainer Presenter Mapping
				String trainerPresenterSql = "INSERT INTO trainer_presentor ( 	id, 	trainer_id, 	presentor_id ) VALUES 	((SELECT MAX(id)+1 FROM trainer_presentor), "+userID+", "+presenterUserID+");";
				db.executeUpdate(trainerPresenterSql);
			
		}
			
			
			
			
		    //Trainer Student  User Profile
			String UserProfileSql = "INSERT INTO user_profile ( 	id, 	address_id, 	first_name, 	last_name, 	dob, 	gender, 	user_id, 	aadhar_no ) VALUES 	( 		(SELECT MAX(id)+1 FROM user_profile), 		NULL, 		'"+firstname+"', 		'"+lastname+"', 	NULL,	'"+gender+"',   "+userID+", 		NULL 	); ";
		
			db.executeUpdate(UserProfileSql);
			//System.out.println(UserProfileSql);

			//Trainer Student User Org Mapping
			String userOrgMappingSql = "INSERT INTO user_org_mapping ( 	user_id, 	organization_id, 	id ) VALUES 	("+userID+", "+college_id+", (SELECT MAX(id)+1 FROM user_org_mapping));";
			db.executeUpdate(userOrgMappingSql);
			//System.out.println(userOrgMappingSql);
			//new EmailService().sendInviteMail(email, firstname,"test123");
			
			return userID;
		
	}
	
	
	public int UpdateUsersForAdminPortal(int userID,String firstname, String lastname, String email, String password,
			String mobileNumber, String gender, String userType, int college_id) {
				
		DBUTILS db = new DBUTILS();
		
		String updateIstarStudentSql = "UPDATE istar_user SET  email = '"+email+"',  password = '"+password+"',  mobile = '"+mobileNumber+"' WHERE 	id = "+userID+";";
		//System.out.println("updateIstarStudentSql>>>"+updateIstarStudentSql);
		db.executeUpdate(updateIstarStudentSql);
		
		String updateUserProfileSql = "UPDATE user_profile SET  first_name = '"+firstname+"',  last_name = '"+lastname+"',  gender = '"+gender+"' WHERE   user_id = "+userID+" ;";
		
		db.executeUpdate(updateUserProfileSql);
		
		String updateUserOrgMapping = "UPDATE user_org_mapping SET organization_id='"+college_id+"' WHERE (user_id='"+userID+"');";
		  
		db.executeUpdate(updateUserOrgMapping);
		
		return userID;
		
		
		
	}
	
	
}
	
	
	