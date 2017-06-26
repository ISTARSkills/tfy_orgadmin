/**
 * 
 */
package com.istarindia.android.pojo;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.helpers.QuietWriter;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;

/**
 * @author Istar
 *
 */
public class RestClient {
	
	
	public CourseContent getCourseContentForStudent(int taskId)
	{
		String string = ""; // The String You Need To Be Converted 
		CourseContent courseContent = new CourseContent();
		try {
			URL url = new URL("http://localhost:8080/t2c/trainerworkflow/"+taskId+"/get_course_contents_student");
		System.out.println("url in getCourseContentForStudent"+url.toString());
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			System.out.println(conn.getURL().toString());
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/json");
			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}
			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
			String output;
			System.out.println("Output from Server .... \n");
			while ((output = br.readLine()) != null) {
				System.out.println(output);
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

			URL url = new URL("http://localhost:8080/t2c/user/"+userID+"/complex");

			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			System.out.println(conn.getURL().toString());
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/json");
			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}
			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
			String output;
			System.out.println("Output from Server .... \n");
			while ((output = br.readLine()) != null) {
				System.out.println(output);
				string = string+ output;
			}
			
			Gson gsonRequest = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
			
			
			covertedObject = gsonRequest.fromJson(string, ComplexObject.class);
			System.err.println(covertedObject.getId());
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
			URL url = new URL("http://localhost:8080/t2c/assessments/user/"+userId+"/"+assessmentId);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			System.out.println(conn.getURL().toString());
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/json");
			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}
			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
			String output;
			System.out.println("Output from Server .... \n");
			while ((output = br.readLine()) != null) {
				System.out.println(output);
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
		
		
		String url = "http://localhost:8080/t2c/assessments/user/"+userId+"/"+assessmentId+"/"+taskId+"";
		URL obj = new URL(url);
		HttpURLConnection con =  (HttpURLConnection) obj.openConnection();
		Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
		String params = "response="+ gson.toJson(assessmentResponse).toString();
		//add reuqest header
		con.setRequestMethod("POST");

		String urlParameters = params;

		// Send post request
		con.setDoOutput(true);
		DataOutputStream wr = new DataOutputStream(con.getOutputStream());
		wr.writeBytes(urlParameters);
		wr.flush();
		wr.close();

		int responseCode = con.getResponseCode();
		System.out.println("\nSending 'POST' request to URL : " + url);
		System.out.println("Post parameters : " + urlParameters);
		System.out.println("Response Code : " + responseCode);

		BufferedReader in = new BufferedReader(
		        new InputStreamReader(con.getInputStream()));
		String inputLine;
		StringBuffer response = new StringBuffer();

		while ((inputLine = in.readLine()) != null) {
			response.append(inputLine);
		}
		in.close();

		//print result
		System.out.println(response.toString());
		
	}
	
	public static void main(String[] args) {
		RestClient rc = new RestClient();
		//rc.getComplexObject(16);
		System.out.println(rc.getAssessment(10039, 449).getQuestions().size());
	}
}