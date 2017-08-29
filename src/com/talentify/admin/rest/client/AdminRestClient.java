/**
 * 
 */
package com.talentify.admin.rest.client;

import java.io.BufferedReader;
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
import com.istarindia.android.pojo.ComplexObject;
import com.talentify.admin.rest.pojo.EventsCard;
import com.viksitpro.core.utilities.AppProperies;

/**
 * @author mayank
 *
 */
public class AdminRestClient {

	String viksit_user_agent = getTockent();
	public ArrayList<EventsCard> getEventsForToday(int orgId) {
		String string = ""; // The String You Need To Be Converted 
		ArrayList<EventsCard> covertedObject = new ArrayList<EventsCard>();
		try {

			URL url = new URL(AppProperies.getProperty("admin_rest_url")+"dashboard/"+orgId);
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
			
			
			covertedObject = gsonRequest.fromJson(string, ArrayList.class);
			//System.err.println(covertedObject.getId());
			conn.disconnect();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return covertedObject;

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
	
	public static void main(String args[])
	{
		AdminRestClient a = new AdminRestClient();
	    ArrayList<EventsCard> cards =	a.getEventsForToday(286);
	    System.out.println(cards.size());
	}	
}
