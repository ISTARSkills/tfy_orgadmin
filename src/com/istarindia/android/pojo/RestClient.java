/**
 * 
 */
package com.istarindia.android.pojo;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Random;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.viksitpro.core.utilities.AppProperies;

/**
 * @author Istar
 *
 */
public class RestClient {
	
	String viksit_user_agent = getTockent();
	
	public CourseContent getCourseContentForStudent(int taskId)
	{
		String string = ""; // The String You Need To Be Converted 
		CourseContent courseContent = new CourseContent();
		try {
			URL url = new URL(AppProperies.getProperty("t2c_path")+"/t2c/trainerworkflow/"+taskId+"/get_course_contents_student");
		   //System.out.println("url in getCourseContentForStudent"+url.toString());
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			//System.out.println(conn.getURL().toString());
			conn.setRequestMethod("GET");
			conn.setRequestProperty ("viksit-user-agent", viksit_user_agent);

			conn.setRequestProperty("Accept", "application/json");
			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}
			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
			String output;
			//System.out.println("Output from Server .... \n");
			while ((output = br.readLine()) != null) {
				//System.out.println(output);
				string = string+ output;
			}
			
			Gson gsonRequest = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
			
			
			courseContent = gsonRequest.fromJson(string, CourseContent.class);
			
			conn.disconnect();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return courseContent;
	}
	
	public ComplexObject getComplexObject(int userID) {
		String string = ""; // The String You Need To Be Converted 
		ComplexObject covertedObject = new ComplexObject();
		try {

			URL url = new URL(AppProperies.getProperty("t2c_path")+"/t2c/user/"+userID+"/complex");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			//System.out.println(conn.getURL().toString());
			conn.setRequestMethod("GET");		
			conn.setRequestProperty ("viksit-user-agent", viksit_user_agent);
			conn.setRequestProperty("Accept", "application/json");
			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}
			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
			String output;
			//System.out.println("Output from Server .... \n");
			while ((output = br.readLine()) != null) {
				////System.out.println(output);
				string = string+ output;
			}
			
			Gson gsonRequest = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
			
			
			covertedObject = gsonRequest.fromJson(string, ComplexObject.class);
			//System.err.println(covertedObject.getId());
			conn.disconnect();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return covertedObject;

	}
	
	
	public AssessmentPOJO getAssessment(int assessmentId, int userId)
	{
		String string = ""; // The String You Need To Be Converted 
		AssessmentPOJO assessment = new AssessmentPOJO();
		try {
			URL url = new URL(AppProperies.getProperty("t2c_path")+"/t2c/assessments/user/"+userId+"/"+assessmentId);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			//System.out.println(conn.getURL().toString());
			conn.setRequestMethod("GET");
			//conn.setRequestProperty ("viksit-user-agent", viksit_user_agent);
			conn.setRequestProperty("Accept", "application/json");
			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}
			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
			String output;
			//System.out.println("Output from Server .... \n");
			while ((output = br.readLine()) != null) {
				//System.out.println(output);
				string = string+ output;
			}
			
			Gson gsonRequest = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
			
			
			assessment = gsonRequest.fromJson(string, AssessmentPOJO.class);
			
			conn.disconnect();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		return assessment;
		
	}
	
	public void SubmitAssessment(int taskId, int userId, ArrayList<QuestionResponsePOJO> assessmentResponse, int assessmentId) throws IOException
	{
		
		
		String url = AppProperies.getProperty("t2c_path")+"/t2c/assessments/user/"+userId+"/"+assessmentId+"/"+taskId+"";
		URL obj = new URL(url);
		HttpURLConnection con =  (HttpURLConnection) obj.openConnection();
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		String params = "response="+ gson.toJson(assessmentResponse).toString();
		//add reuqest header
		
		con.setRequestMethod("POST");
		con.setRequestProperty ("viksit-user-agent", viksit_user_agent);
		String urlParameters = params;

		// Send post request
		con.setDoOutput(true);
		DataOutputStream wr = new DataOutputStream(con.getOutputStream());
		wr.writeBytes(urlParameters);
		wr.flush();
		wr.close();

		int responseCode = con.getResponseCode();
		//System.out.println("\nSending 'POST' request to URL : " + url);
		//System.out.println("Post parameters : " + urlParameters);
		//System.out.println("Response Code : " + responseCode);

		BufferedReader in = new BufferedReader(
		        new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();

		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		in.close();

		//print result
		//System.out.println(response.toString());
		
	}
	
	public static void main(String[] args) {
		RestClient rc = new RestClient();
		//rc.getComplexObject(16);
		//System.out.println(rc.getAssessment(10039, 449).getQuestions().size());
	}
	
	public String getTockent() {

		DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm");
		Date date = new Date();
		String timeNow = dateFormat.format(date).toString();
		timeNow = timeNow.replaceAll("/", "").replaceAll(":", "").replaceAll(" ", "");
		System.err.println(timeNow);

		Random r = new Random();
		int Low = 1;
		int High = 24;
		int Result = r.nextInt(High - Low) + Low;

		for (int j = 0; j < 3; j++) {

			StringBuffer randStr = new StringBuffer();
			char ch;
			Result = r.nextInt(High - Low) + Low;
			for (int i = 0; i < 3; i++) {
				Result = r.nextInt(High - Low) + Low;
				// Result = r.nextInt(High-Low) + Low;
				String CHAR_LIST = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
				ch = CHAR_LIST.charAt(Result);
				randStr.append(ch);
			}

			if (j == 0) {
				timeNow = new StringBuffer(timeNow).insert(timeNow.length() - 10, randStr).toString();
			}
			if (j == 1) {
				timeNow = new StringBuffer(timeNow).insert(timeNow.length() - 3, randStr).toString();
			}
			if (j == 2) {
				timeNow = new StringBuffer(timeNow).insert(timeNow.length() - 7, randStr).toString();
			}

		}
		return "viksit-"+timeNow;
	}

	
}