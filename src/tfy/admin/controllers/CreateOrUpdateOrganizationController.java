package tfy.admin.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.viksitpro.core.dao.entities.IstarUser;
import com.viksitpro.core.dao.entities.IstarUserDAO;
import com.viksitpro.core.dao.entities.Organization;
import com.viksitpro.core.dao.entities.OrganizationDAO;
import com.viksitpro.core.utilities.DBUTILS;

import in.orgadmin.admin.services.OrgAdminUserService;
import in.talentify.core.controllers.IStarBaseServelet;

/**
 * Servlet implementation class CreateOrUpdateOrganizationController
 */
@WebServlet("/create_or_update_organization")
public class CreateOrUpdateOrganizationController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CreateOrUpdateOrganizationController() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		printparams(request);

		boolean isCreate = true;
		int college_id = 0;
		if (request.getParameter("college_id") != null && !request.getParameter("college_id").equalsIgnoreCase("0")) {
			isCreate = false;
			college_id = Integer.parseInt(request.getParameter("college_id"));
		}

		String org_name = request.getParameter("org_name").replaceAll("'", "");
		String org_addr1 = request.getParameter("org_addr1").replaceAll("'", "");
		String org_addr2 = request.getParameter("org_addr2").replaceAll("'", "");
		String pincode = request.getParameter("pincode");
		String org_type = request.getParameter("org_type");
		String max_students = request.getParameter("max_students");
		String org_profile = request.getParameter("org_profile").replaceAll("'", "");

		String org_admin_email = request.getParameter("org_admin_email").replaceAll("'", "");
		String org_admin_first_name = request.getParameter("org_admin_first_name").replaceAll("'", "");
		String org_admin_last_name = request.getParameter("org_admin_last_name")!=null ?request.getParameter("org_admin_last_name").replaceAll("'", "") : " ";
		String org_admin_gender = request.getParameter("org_admin_gender");
		long org_admin_mobile = Long.parseLong(request.getParameter("org_admin_mobile"));
		int org_admin_id = Integer.parseInt(request.getParameter("org_admin_id"));

		if (org_profile.equalsIgnoreCase("")) {
			org_profile = "NULL";
		}

		DBUTILS db = new DBUTILS();
		OrgAdminUserService service = new OrgAdminUserService();

		String sql = "SELECT id FROM pincode WHERE pin = '" + pincode + "'";
		List<HashMap<String, Object>> data = db.executeQuery(sql);
		int pinCodeId = 1;
		for (HashMap<String, Object> item : data) {
			pinCodeId = (int) item.get("id");
		}

		// check is Exist
		boolean isexist = false;
		String checkIFExist="select cast (count(*) as integer) as count from istar_user where email ='"+org_admin_email+"'";
		List<HashMap<String, Object>> existingUsers = db.executeQuery(checkIFExist);

		if ((int)existingUsers.get(0).get("count") > 0) {
			String findAdmin ="select id from istar_user where email='"+org_admin_email+"' limit 1";
			List<HashMap<String, Object>> adminDddd = db.executeQuery(findAdmin);
			org_admin_id = (int)adminDddd.get(0).get("id");
			isexist = true;
		}

		if (isCreate) {
			sql = "INSERT INTO address ( id, addressline1, addressline2, pincode_id, address_geo_longitude, address_geo_latitude ) VALUES ( (SELECT COALESCE (MAX(ID) + 1, 1) FROM address ), '"
					+ org_addr1 + "', '" + org_addr2 + "', " + pinCodeId
					+ ", '73.8834149', '18.4866277' )RETURNING ID;";
			int addressId = db.executeUpdateReturn(sql);

			sql = "INSERT INTO organization (id, name, org_type, address_id, industry, profile,created_at, updated_at, iscompany, max_student) VALUES "
					+ "((select COALESCE(max(id),0)+1 from organization ), '"+org_name.trim()+"', 'COLLEGE', "+addressId+", 'EDUCATION', '"+org_profile+"',  now(), now(), 'f', "+max_students+") RETURNING ID;";
			college_id = db.executeUpdateReturn(sql);

			// create or update orgAdmin
			if (!isexist) {
				//service.createOrgAdmin(college_id, org_admin_email, org_admin_gender, org_admin_mobile, org_admin_name);
				// Insert new Student
				String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token ) "
						+ "VALUES ((SELECT MAX(id)+1 FROM istar_user), 		'"+org_admin_email+"', 'test123', 		now(), 		'"+org_admin_mobile+"', 		NULL 	)RETURNING ID;";
				
				System.out.println(istarStudentSql);
				int userID  = db.executeUpdateReturn(istarStudentSql);
					
				String insertIntoUserProfile ="INSERT INTO user_profile (id, first_name, last_name,  gender,  user_id) VALUES ((select COALESCE(max(id),0)+1 from user_profile), '"+org_admin_first_name+"', '"+org_admin_last_name+"', '"+org_admin_gender+"', "+userID+");";
				db.executeUpdate(insertIntoUserProfile);

				//Student User Role Mapping
					String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name='ORG_ADMIN'), (SELECT MAX(id)+1 FROM user_role), '1');";
					System.out.println(userRoleMappingSql);
					db.executeUpdate(userRoleMappingSql);
					String insertIntoOrgMapping="INSERT INTO user_org_mapping (user_id, organization_id, id) VALUES ("+userID+", "+college_id+", (select COALESCE(max(id),0)+1 from user_org_mapping));"; 
					db.executeUpdate(insertIntoOrgMapping);
					response.getWriter().print("success");
			}

		} else {
			Organization college = new OrganizationDAO().findById(college_id);

			if (college != null) {
				int addressId = (college.getAddress() != null) ? college.getAddress().getId() : 1;

				sql = "UPDATE address SET  addressline1 = '" + org_addr1 + "',  addressline2 = '" + org_addr2
						+ "',  pincode_id =" + pinCodeId
						+ ",  address_geo_longitude = '73.8834149',  address_geo_latitude = '18.4866277' WHERE (id = "
						+ addressId + ")";
				db.executeUpdate(sql);

				sql = "UPDATE organization SET  name='"+org_name+"', org_type='COLLEGE', address_id='"+addressId+"', industry='EDUCATION', profile='"+org_profile+"', updated_at=now() WHERE id="+college_id+";";
				db.executeUpdate(sql);

				
				// create or update orgAdmin
				
				if(isexist)
				{
					
					IstarUser admin = new IstarUserDAO().findById(org_admin_id);
					String updateORgadmin = "UPDATE istar_user SET email='"+org_admin_email+"', created_at=now(), mobile="+org_admin_mobile+" WHERE id="+org_admin_id+";";
					db.executeUpdate(updateORgadmin);
					if(admin.getUserProfile()!=null)
					{
						String updateOrgUSerProfile = "UPDATE user_profile SET  first_name='"+org_admin_first_name+"', last_name='"+org_admin_last_name+"', gender='"+org_admin_gender+"' where user_id="+org_admin_id+"";
						db.executeUpdate(updateOrgUSerProfile);
					}
					else
					{
						//create user profile
						String insertIntoUserProfile ="INSERT INTO user_profile (id, first_name, last_name,  gender,  user_id) VALUES ((select COALESCE(max(id),0)+1 from user_profile), '"+org_admin_first_name+"', '"+org_admin_last_name+"', '"+org_admin_gender+"', "+admin.getId()+");";
						db.executeUpdate(insertIntoUserProfile);
					}	
				}
				else
				{
					String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token ) "
							+ "VALUES ((SELECT MAX(id)+1 FROM istar_user), 		'"+org_admin_email+"', 'test123', 		now(), 		'"+org_admin_mobile+"', 		NULL 	)RETURNING ID;";
					
					System.out.println(istarStudentSql);
					int userID  = db.executeUpdateReturn(istarStudentSql);
						
					String insertIntoUserProfile ="INSERT INTO user_profile (id, first_name, last_name,  gender,  user_id) VALUES ((select COALESCE(max(id),0)+1 from user_profile), '"+org_admin_first_name+"', '"+org_admin_last_name+"', '"+org_admin_gender+"', "+userID+");";
					db.executeUpdate(insertIntoUserProfile);
					
					//Student User Role Mapping
					String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name='ORG_ADMIN'), (SELECT MAX(id)+1 FROM user_role), '1');";
						System.out.println(userRoleMappingSql);
						db.executeUpdate(userRoleMappingSql);
						
					String insertIntoOrgMapping="INSERT INTO user_org_mapping (user_id, organization_id, id) VALUES ("+userID+", "+college_id+", (select COALESCE(max(id),0)+1 from user_org_mapping));"; 
						db.executeUpdate(insertIntoOrgMapping);
						
						
				}					
					
					response.getWriter().print("success");
			}
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}