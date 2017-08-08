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
			String mobileNumber, String gender, List<String> userType, int college_id) {

		List<IstarUser> istarUserList = (new IstarUserDAO()).findByEmail(email);
		DBUTILS db = new DBUTILS();
		int userID = 0;
		int trainerUserID = 0;
		int presenterUserID = 0;
		if (istarUserList.size() > 0) {
			// System.out.println("A user with this email address already exists
			// of type "
			// + istarUserList.get(0).getUserRoles() + "!");
			return 0;

		}

		// Insert new users
		String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) VALUES 	( 		(SELECT MAX(id)+1 FROM istar_user), 		'"
				+ email + "', 		'" + password + "', 		now(), 		'" + mobileNumber
				+ "', 		NULL,    'f' 	)RETURNING ID;";
		System.out.println(istarStudentSql);

		userID = db.executeUpdateReturn(istarStudentSql);

		// Student User Role Mapping
		if(userType != null && !userType.isEmpty() && !userType.toString().equalsIgnoreCase("")) {
			
			for(String uType:userType) {
				
				String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("
						+ userID + ", (select id from role where role_name = '" + uType
						+ "'), (SELECT MAX(id)+1 FROM user_role), '1');";
				System.out.println(userRoleMappingSql);
				db.executeUpdate(userRoleMappingSql);
			}
			
		}
		

		if (userType.contains("TRAINER") || userType.contains("MASTER_TRAINER")) {

			String[] presenterEmailaddress = email.split("@");
			String presenterEmail = presenterEmailaddress[0] + "_presenter@" + presenterEmailaddress[1];

			// Insert new Presenter
			String istarPresenterSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token, is_verified ) VALUES 	( 		(SELECT MAX(id)+1 FROM istar_user), 		'"
					+ presenterEmail + "', 		'" + password + "', 		now(), 		'" + mobileNumber
					+ "', 		NULL,    'f' 	)RETURNING ID;";

			presenterUserID = db.executeUpdateReturn(istarPresenterSql);
			 System.out.println(istarPresenterSql);
			// Trainer Presenter User Role Mapping
			String presentorRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("
					+ presenterUserID
					+ ", (select id from role where role_name = 'PRESENTOR'), (SELECT MAX(id)+1 FROM user_role), '1');";
			db.executeUpdate(presentorRoleMappingSql);
			 System.out.println(presentorRoleMappingSql);
			// Trainer Presenter Mapping
			String trainerPresenterSql = "INSERT INTO trainer_presentor ( 	id, 	trainer_id, 	presentor_id ) VALUES 	((SELECT MAX(id)+1 FROM trainer_presentor), "
					+ userID + ", " + presenterUserID + ");";
			db.executeUpdate(trainerPresenterSql);
			 System.out.println(trainerPresenterSql);
		}

		// Trainer Student User Profile
		String UserProfileSql = "INSERT INTO user_profile ( 	id, 	address_id, 	first_name, 	last_name, 	dob, 	gender, 	user_id, 	aadhar_no ) VALUES 	( 		(SELECT MAX(id)+1 FROM user_profile), 		NULL, 		'"
				+ firstname + "', 		'" + lastname + "', 	NULL,	'" + gender + "',   " + userID
				+ ", 		NULL 	); ";
		
		System.out.println(UserProfileSql);
		db.executeUpdate(UserProfileSql);
		

		// Trainer Student User Org Mapping
		String userOrgMappingSql = "INSERT INTO user_org_mapping ( 	user_id, 	organization_id, 	id ) VALUES ("
				+ userID + ", " + college_id + ", (SELECT MAX(id)+1 FROM user_org_mapping));";
		db.executeUpdate(userOrgMappingSql);
		 System.out.println(userOrgMappingSql);
		// new EmailService().sendInviteMail(email, firstname,"test123");

		return userID;

	}

	public int UpdateUsersForAdminPortal(int userID, String firstname, String lastname, String email, String password,
			String mobileNumber, String gender, List<String> userType, int college_id) {

		DBUTILS db = new DBUTILS();

		String updateIstarStudentSql = "UPDATE istar_user SET  email = '" + email + "',  password = '" + password
				+ "',  mobile = '" + mobileNumber + "' WHERE 	id = " + userID + ";";
		// System.out.println("updateIstarStudentSql>>>"+updateIstarStudentSql);
		db.executeUpdate(updateIstarStudentSql);

		String updateUserProfileSql = "UPDATE user_profile SET  first_name = '" + firstname + "',  last_name = '"
				+ lastname + "',  gender = '" + gender + "' WHERE   user_id = " + userID + " ;";

		db.executeUpdate(updateUserProfileSql);

		String updateUserOrgMapping = "UPDATE user_org_mapping SET organization_id='" + college_id
				+ "' WHERE (user_id='" + userID + "');";

		db.executeUpdate(updateUserOrgMapping);
		
		// Student User Role Mapping
		if(userType != null && !userType.isEmpty() && !userType.toString().equalsIgnoreCase("")) {
			
			for(String uType:userType) {
				
				String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("
						+ userID + ", (select id from role where role_name = '" + uType
						+ "'), (SELECT MAX(id)+1 FROM user_role), '1');";
				System.out.println(userRoleMappingSql);
				db.executeUpdate(userRoleMappingSql);
			}
			
		}

		return userID;

	}

}
