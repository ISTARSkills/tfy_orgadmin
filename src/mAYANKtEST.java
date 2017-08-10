import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.viksitpro.core.utilities.DBUTILS;

/**
 * 
 */

/**
 * @author ISTAR-SKILL
 *
 */
public class mAYANKtEST {
	private static final String FILENAME = "E:\\filename.txt";

	public Connection getConnection()
	{
		try{
			
			Class.forName("org.postgresql.Driver");
			Connection connection = null;
			connection = DriverManager.getConnection(
			   "jdbc:postgresql://api.talentify.in:5432/postgres","postgres", "X3m2p1z0!@#");
			return connection;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}
	
	public Connection getBetaConnection()
	{
		try{
			
			Class.forName("org.postgresql.Driver");
			Connection connection = null;
			connection = DriverManager.getConnection(
			   "jdbc:postgresql://beta.talentify.in:5432/talentify","postgres", "4a626021-e55a");
			return connection;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}
	
	public Connection getTalentifyConnection()
	{
		try{
			
			Class.forName("org.postgresql.Driver");
			Connection connection = null;
			connection = DriverManager.getConnection(
			   "jdbc:postgresql://cdn.talentify.in:5432/talentify","postgres", "4a626021-e55a");
			return connection;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}
	
	public Connection getLocalConnection()
	{
		try{
			
			Class.forName("org.postgresql.Driver");
			Connection connection = null;
			connection = DriverManager.getConnection(
			   "jdbc:postgresql://localhost:5432/talentify","postgres", "4a626021-e55a");
			return connection;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}
	public   void ImportDatafromPostgres() {
		// TODO Auto-generated method stub
		Connection con = getConnection();
		try {
			BufferedWriter bw = new BufferedWriter(new FileWriter("E:\\filename.txt"));
			

			

		
				int iiii = 7260;
				
		String getUserDetails  = "select * from student where organization_id = 259";
		
			Statement statement = con.createStatement();
			
			ResultSet rs = statement.executeQuery(getUserDetails);
			while (rs.next()) {
				
				int studentId = rs.getInt("id");
				String email = rs.getString("email");
				String gender = rs.getString("gender");
				Long mobile = rs.getLong("mobile");
				Long PriamryMob = rs.getLong("phone");
				String password  = rs.getString("password");
				String name = rs.getString("name");
				
				String ss = "NULL";
				String finalName = "";
				if (PriamryMob != null)
				{
					ss = PriamryMob+"";
				}
				else
				{
					ss= mobile+"";
				}
				
				/*Connection connection2 = getTalentifyConnection();
				Statement statement2 = connection2.createStatement();
				String selectIfExist ="select cast (count(*) as integer) as cc from istar_user where id in ("+studentId+")";
				ResultSet rs22 = statement2.executeQuery(selectIfExist);
				while (rs22.next()) {
				if(rs22.getInt("cc")!=0)
				{
					
				}*/
				
				
				/*DBUTILS util = new DBUTILS();
				Connection connection2 = getTalentifyConnection();
				Statement statement2 = connection2.createStatement();
				String selectIfExist ="select cast (count(*) as integer) as cc from istar_user where id in ("+studentId+")";
				ResultSet rs22 = statement2.executeQuery(selectIfExist);
				while (rs22.next()) {
				if(rs22.getInt("cc")!=0)
				{
					util.executeUpdate("delete from attendance where user_id in ("+studentId+");");
					bw.write("delete from attendance where user_id in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from attendance where taken_by in ("+studentId+");");
					bw.write("delete from attendance where taken_by in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from batch_students where student_id in ("+studentId+");");
					bw.write("delete from batch_students where student_id in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from user_gamification where istar_user in ("+studentId+");");
					bw.write("delete from user_gamification where istar_user in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from student_assessment where student_id in ("+studentId+");");
					bw.write("delete from student_assessment where student_id in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from report where user_id in ("+studentId+");");
					bw.write("delete from report where user_id in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from trainer_batch where trainer_id in ("+studentId+");");
					bw.write("delete from trainer_batch where trainer_id in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from trainer_feedback where user_id in ("+studentId+");");
					bw.write("delete from trainer_feedback where user_id in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from student_playlist where student_id in ("+studentId+");");
					bw.write("delete from student_playlist where student_id in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from task_log where task in (select id from task where  actor in ("+studentId+"));");
					bw.write("delete from task_log where task in (select id from task where  actor in ("+studentId+"));");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from task where actor in ("+studentId+");");
					bw.write("delete from task where actor in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from user_profile where user_id in ("+studentId+");");
					bw.write("delete from user_profile where user_id in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from user_org_mapping where user_id in ("+studentId+");");
					bw.write("delete from user_org_mapping where user_id in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from user_role where user_id in ("+studentId+");");
					bw.write("delete from user_role where user_id in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from professional_profile where user_id in ("+studentId+");");
					bw.write("delete from professional_profile where user_id in ("+studentId+");");
					bw.write(System.lineSeparator());
					util.executeUpdate("delete from istar_user where id in ("+studentId+");");
					bw.write("delete from istar_user where id in ("+studentId+");");
					bw.write(System.lineSeparator());
				}
				}*/
				studentId = iiii;
				String insertIntoIstarUser ="INSERT INTO istar_user (id, email, password, created_at, mobile, auth_token, login_type, is_verified)"
						+ " VALUES ("+iiii+", '"+email+"', '"+password+"', now(), "+ss+", '18', NULL, 't');";
				//System.out.println(insertIntoIstarUser);
				bw.write(insertIntoIstarUser);
				bw.write(System.lineSeparator());
				if(name!=null)
				{
					finalName=name;
					
					String userProfile="INSERT INTO user_profile (id,  first_name,   gender,  user_id) VALUES ((select COALESCE(max(id),0)+1 from user_profile),'"+finalName+"','"+gender+"', "+studentId+");";
					//System.out.println(userProfile);
					bw.write(userProfile);
					bw.write(System.lineSeparator());
				}
				
				
				String insertInToUserRole ="insert into user_role(user_id, id, role_id,priority) values ("+studentId+", (select COALESCE(max(id),0)+1 from user_role), 30,1);";
				//System.out.println(insertInToUserRole);
				bw.write(insertInToUserRole);
				bw.write(System.lineSeparator());
				
				String insertIntoUserOrg ="insert into user_org_mapping (id, user_id, organization_id) values((select COALESCE(max(id),0)+1 from user_org_mapping),"+studentId+",259);";
				//System.out.println(insertIntoUserOrg);
				bw.write(insertIntoUserOrg);
				bw.write(System.lineSeparator());
				iiii++;
			}
		} catch (Exception e1 ) {			
			e1.printStackTrace();
		}
	}
}
