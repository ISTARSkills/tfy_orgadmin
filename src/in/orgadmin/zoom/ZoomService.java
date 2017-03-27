package in.orgadmin.zoom;


import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;

import java.net.URLEncoder;
import java.util.HashMap;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class ZoomService {

	private static final String api_key= "B6alpwLITUyloK6XjT9BfQ";
	private static final String api_secret= "pr8RBuDQtzw1cksd4s76uFDVYaQ7DdBieWIT";	
	private static final String key_secret = "?api_key="+api_key+"&api_secret="+api_secret;
	private static String baseUserInfoByEmailURI = "https://api.zoom.us/v1/user/getbyemail" +key_secret;	
	private static String baseUserCreateURI = "https://api.zoom.us/v1/user/custcreate" + key_secret;
	private static String baseMeetingURI = "https://api.zoom.us/v1/meeting/create" + key_secret; 
	
	private static Client client;
	private static ClientResponse response;
	private static WebResource webResource;
	private static String output = null;
	
	public String createZoomUser(String email){
		String hostZoomID="";
		System.out.println("Creating ZOOM User");
		try{
		client = Client.create();
		webResource = client.resource(baseUserCreateURI + "&type=2&email="+URLEncoder.encode(email, "UTF-8"));
		System.out.println("URL->" + webResource.getURI().toURL().toString());
		response = webResource.accept("application/json").type("application/json").post(ClientResponse.class);
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("USER CREATION FAILED");
		}
	
		if (response.getStatus() != 200) {
            throw new RuntimeException("Failed : HTTP error code : "
                    + response.getStatus());
        }
		
		output = response.getEntity(String.class);
		System.out.println("Output from Create Server .... ");
        System.out.println(output + "\n");		
        
        JSONParser jsonParser = new JSONParser();

        try {
			JSONObject jsonObject = (JSONObject) jsonParser.parse(output);
			hostZoomID = (String) jsonObject.get("id");
		} catch (ParseException e) {
			e.printStackTrace();
		}
        return hostZoomID;
	}
	
	public HashMap<String, String> createMeeting(String hostEmail){
		
		HashMap<String, String> meetingInformation = new HashMap<String, String>();
		String hostID = "";
		String existingUserID = getUserID(hostEmail);
		
		if(!existingUserID.trim().isEmpty()){
			System.out.println("USER ALREADY EXISTS");
			hostID = existingUserID;
		}
		else{
			System.out.println("CREATING NEW USER");
			hostID = createZoomUser(hostEmail);
		}
		
		String uri = baseMeetingURI + "&type=2&host_id="+hostID+"&topic=Interview"+"&option_jbh=true&password=test123";
		String hostURL = "";
		String joinURL = "";
		String meetingID = "";
		String meetingPassword = "";
		
		try{
		client = Client.create();
		webResource = client.resource(uri);
		
		System.out.println("URL->" + webResource.getURI().toURL().toString());
		response = webResource.accept("application/json").type("application/json").post(ClientResponse.class);
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("MEETING CREATION FAILED");
		}
		if (response.getStatus() != 200) {
            throw new RuntimeException("Failed : HTTP error code : "
                    + response.getStatus());
        }

		output = response.getEntity(String.class);
		System.out.println("Output from Meeting Server .... ");
        System.out.println(output + "\n");
        
        JSONParser jsonParser = new JSONParser();

        try {
			JSONObject jsonObject = (JSONObject) jsonParser.parse(output);
			hostURL = (String) jsonObject.get("start_url");
			joinURL = (String) jsonObject.get("join_url");
			meetingID = String.valueOf(jsonObject.get("id"));
			meetingPassword = (String) jsonObject.get("password");
		} catch (ParseException e) {
			e.printStackTrace();
		}
        
        meetingInformation.put("hostURL", hostURL);
        meetingInformation.put("joinURL", joinURL);
        meetingInformation.put("meetingID", meetingID);
        meetingInformation.put("meetingPassword", meetingPassword);
        
        return meetingInformation;
	}
	
	public String getUserID(String email){
		String hostID = "";
		
		System.out.println("searching for user email:" + email);
		try{
		client = Client.create();
		webResource = client.resource(baseUserInfoByEmailURI+ "&email=" +URLEncoder.encode(email, "UTF-8") + "&login_type=99");
		System.out.println("URL->" + webResource.getURI().toURL().toString());
		response = webResource.accept("application/json").type("application/json").post(ClientResponse.class);
		}catch(Exception e){
			e.printStackTrace();
			System.out.println("Retrieving User FAILED");
		}
		
		if (response.getStatus() != 200) {
            throw new RuntimeException("Failed : HTTP error code : "
                    + response.getStatus());
        }

		output = response.getEntity(String.class);
		System.out.println("Output from Search Server .... ");
        System.out.println(output + "\n");
		

        JSONParser jsonParser = new JSONParser();

        try {
			JSONObject jsonObject = (JSONObject) jsonParser.parse(output);
			if(jsonObject.containsKey("error")){
				System.out.println("Error reteiving Data from ZOOM");
				System.out.println("Error Code:" + ((JSONObject)jsonObject.get("error")).get("code"));
				System.out.println("Error Message:" + ((JSONObject)jsonObject.get("error")).get("message"));
			}
			else{
			hostID = (String) jsonObject.get("id");
			System.out.println("Exisint USER, Host ID:" + hostID);
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}        
		return hostID;
	}	
}
