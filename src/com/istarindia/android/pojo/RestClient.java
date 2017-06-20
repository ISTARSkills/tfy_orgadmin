/**
 * 
 */
package com.istarindia.android.pojo;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonObject;

/**
 * @author Istar
 *
 */
public class RestClient {
	public ComplexObject getComplexObject(int userID) {
		String string = ""; // The String You Need To Be Converted 
		ComplexObject covertedObject = new ComplexObject();
		try {
			URL url = new URL("http://elt.talentify.in:8080/t2c/user/"+userID+"/complex");
			System.err.println("http://elt.talentify.in:8080/t2c/user/"+userID+"/complex");
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
	
	public static void main(String[] args) {
		RestClient rc = new RestClient();
		rc.getComplexObject(16);
	}
}