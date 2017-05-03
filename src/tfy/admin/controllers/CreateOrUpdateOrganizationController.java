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
		String org_admin_name = request.getParameter("org_admin_name").replaceAll("'", "");
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
		List<IstarUser> istarUserList = (new IstarUserDAO()).findByEmail(org_admin_email);

		if (istarUserList.size() > 0) {
			
			isexist = true;
		}

		if (isCreate) {
			sql = "INSERT INTO address ( id, addressline1, addressline2, pincode_id, address_geo_longitude, address_geo_latitude ) VALUES ( (SELECT COALESCE (MAX(ID) + 1, 1) FROM address ), '"
					+ org_addr1 + "', '" + org_addr2 + "', " + pinCodeId
					+ ", '73.8834149', '18.4866277' )RETURNING ID;";
			int addressId = db.executeUpdateReturn(sql);

			sql = "INSERT INTO organization (id, name, org_type, address_id, industry, profile,created_at, updated_at, iscompany) VALUES "
					+ "((select COALESCE(max(id),0)+1 from organization ), '"+org_name.trim()+"', 'COLLEGE', "+addressId+", 'EDUCATION', '"+org_profile+"',  now(), now(), 'f') RETURNING ID;";
			college_id = db.executeUpdateReturn(sql);

			// create or update orgAdmin
			if (!isexist) {
				//service.createOrgAdmin(college_id, org_admin_email, org_admin_gender, org_admin_mobile, org_admin_name);
				// Insert new Student
				String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token ) "
						+ "VALUES ((SELECT MAX(id)+1 FROM istar_user), 		'"+org_admin_email+"', 'test123', 		now(), 		'"+org_admin_mobile+"', 		NULL 	)RETURNING ID;";
				
				System.out.println(istarStudentSql);
				int userID  = db.executeUpdateReturn(istarStudentSql);
					

				//Student User Role Mapping
					String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name='ORG_ADMIN'), (SELECT MAX(id)+1 FROM user_role), '1');";
					System.out.println(userRoleMappingSql);
					db.executeUpdate(userRoleMappingSql);
					
				
				
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
				
				IstarUser admin = new IstarUserDAO().findById(org_admin_id);
				if(admin!=null)
				{
					String updateORgadmin = "UPDATE istar_user SET email='"+org_admin_email+"', updated_at=now(), mobile="+org_admin_mobile+" WHERE id="+org_admin_id+";";
					db.executeUpdate(updateORgadmin);
				}
				else
				{
					String istarStudentSql = "INSERT INTO istar_user ( 	id, 	email, 	password, 	created_at, 	mobile, 	auth_token ) "
							+ "VALUES ((SELECT MAX(id)+1 FROM istar_user), 		'"+org_admin_email+"', 'test123', 		now(), 		'"+org_admin_mobile+"', 		NULL 	)RETURNING ID;";
					
					System.out.println(istarStudentSql);
					int userID  = db.executeUpdateReturn(istarStudentSql);
						

					//Student User Role Mapping
						String userRoleMappingSql = "INSERT INTO user_role ( 	user_id, 	role_id, 	id, 	priority ) VALUES 	("+userID+", (select id from role where role_name='ORG_ADMIN'), (SELECT MAX(id)+1 FROM user_role), '1');";
						System.out.println(userRoleMappingSql);
						db.executeUpdate(userRoleMappingSql);
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