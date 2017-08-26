/**
 * 
 */
package tfy.webapp.ui;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;

import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.viksitpro.core.utilities.AppProperies;

/**
 * @author Istar
 *
 */
public class CMSRestClient {
	
	public JSONObject getCourseList() {
		String string = ""; // The String You Need To Be Converted 
		JSONObject courseList = new JSONObject();
		try {
			URL url = new URL(AppProperies.getProperty("tfy_content_rest_path")+"tfy_content_rest/course/getAll");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			System.out.println(conn.getURL().toString());
			conn.setRequestMethod("GET");
//			conn.setRequestProperty ("viksit-user-agent", viksit_user_agent);

			conn.setRequestProperty("Accept", "application/json");
			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}
			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
			String output;
			//System.out.println("Output from Server .... \n");
			while ((output = br.readLine()) != null) {
				System.out.println(output);
				string = string+ output;
			}
			
			Gson gsonRequest = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
			
			
			courseList = gsonRequest.fromJson(string, JSONObject.class);
			System.err.println(courseList.getClass());
			conn.disconnect();
			return courseList;
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
		
		
	}
	

	
	public static void main(String[] args)  {
		System.err.println("Hello WOlrd");
		CMSRestClient cr = new CMSRestClient();
		System.err.println(cr.getCourseList());
		
		
	}
	
}