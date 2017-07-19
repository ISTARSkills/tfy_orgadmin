/**
 * 
 */
package tfy.admin.services;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.utilities.DBUTILS;

/**
 * @author mayank
 *
 */
public class SMSServices {

	public void sendTicketAsSMSToUsers(ArrayList<String> mobiles , int ticketId)
	{
		DBUTILS util = new DBUTILS();
		String sql = "select role.role_name, ticket_type, organization.name from ticket , user_org_mapping,organization, user_role, role where ticket.creator_id = user_role.user_id and user_role.role_id = role.id and user_role.user_id = user_org_mapping.user_id and user_org_mapping.organization_id = organization.id and ticket.id ="+ticketId+ "limit 1";
		//System.out.println(sql);
		List<HashMap<String, Object>> ticketData = util.executeQuery(sql);
		for(HashMap<String, Object> row: ticketData)
		{
			String ticketType = row.get("ticket_type").toString().toLowerCase().replaceAll("_", " ");
			String roleName = row.get("role_name").toString().toLowerCase().replaceAll("_", " ");
			String orgName = row.get("name").toString();
			String mobTextingURLBase = "https://mobtexting.com/app/index.php/api?method=sms.normal"
					+ "&api_key=0c9ee1130f2a27302bbef3f39360a9eba5f7e48a&sender=TLNTFY";				
			
			String message = "A ticket has been raised by "+roleName+" of organization "+orgName+" regarding "+ticketType+". Ticket number is "+ticketId;
			//System.out.println(message);
			for(String mobile : mobiles)
			{
				String smsURL;
				try {
					smsURL = mobTextingURLBase + "&to="+URLEncoder.encode(mobile, "UTF-8")+"&message="+URLEncoder.encode(message, "UTF-8");
					//System.out.println(smsURL);
					URL urlObject = new URL(smsURL);
					InputStream inputStream = urlObject.openConnection().getInputStream();
					BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));

					String line = null;
					while ((line = bufferedReader.readLine()) != null) {
						//System.out.println(line);
					}
					bufferedReader.close();
				} catch (UnsupportedEncodingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (MalformedURLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
			

		}
	}
	
	public void sendTicketStatusChangeAsSMSToUsers(ArrayList<String> mobiles , int ticketId, String newStatus)
	{
		DBUTILS util = new DBUTILS();
		String sql = "select role.role_name, ticket_type, organization.name from ticket , user_org_mapping,organization, user_role, role where ticket.creator_id = user_role.user_id and user_role.role_id = role.id and user_role.user_id = user_org_mapping.user_id and user_org_mapping.organization_id = organization.id and ticket.id ="+ticketId+ "limit 1";
		//System.out.println(sql);
		List<HashMap<String, Object>> ticketData = util.executeQuery(sql);
		for(HashMap<String, Object> row: ticketData)
		{
			String ticketType = row.get("ticket_type").toString().toLowerCase().replaceAll("_", " ");
			String roleName = row.get("role_name").toString().toLowerCase().replaceAll("_", " ");
			String orgName = row.get("name").toString();
			String mobTextingURLBase = "https://mobtexting.com/app/index.php/api?method=sms.normal"
					+ "&api_key=0c9ee1130f2a27302bbef3f39360a9eba5f7e48a&sender=TLNTFY";				
			
			String message = "Ticket number "+ticketId+" has been "+newStatus.replace("_", " ") +" which was  raised by "+roleName+" of organization "+orgName+" regarding "+ticketType;
			//System.out.println(message);
			for(String mobile : mobiles)
			{
				String smsURL;
				try {
					smsURL = mobTextingURLBase + "&to="+URLEncoder.encode(mobile, "UTF-8")+"&message="+URLEncoder.encode(message, "UTF-8");
					//System.out.println(smsURL);
					URL urlObject = new URL(smsURL);
					InputStream inputStream = urlObject.openConnection().getInputStream();
					BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream));

					String line = null;
					while ((line = bufferedReader.readLine()) != null) {
						//System.out.println(line);
					}
					bufferedReader.close();
				} catch (UnsupportedEncodingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (MalformedURLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
			

		}
	}
	
}
