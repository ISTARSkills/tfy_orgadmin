import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.istarindia.android.pojo.AssessmentReportPOJO;
import com.istarindia.android.pojo.RestClient;
import com.viksitpro.core.utilities.AppProperies;

/**
 * 
 */

/**
 * @author vaibhav
 *
 */
public class LoginThread  implements Runnable {

	Integer istarUserId;
	
	
	public LoginThread(Integer istarUserId) {
		super();
		this.istarUserId = istarUserId;
	}


	@Override
	public void run() {
		try {
			URL url = new URL("http://elt.talentify.in/t2c/user/"+istarUserId+"/complex");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			//ViksitLogger.logMSG(this.getClass().getName(),conn.getURL().toString());
			conn.setRequestMethod("GET");

			conn.setRequestProperty("Accept", "application/json");
			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}
			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
			String output;
			String string ="";
			//ViksitLogger.logMSG(this.getClass().getName(),"Output from Server .... \n");
			while ((output = br.readLine()) != null) {
				//ViksitLogger.logMSG(this.getClass().getName(),output);
				string = string+ output;
			}
			
			Gson gsonRequest = new GsonBuilder().setDateFormat("yyyy-MM-dd HH:mm:ss").create();
			
			conn.disconnect();
		
		} catch (MalformedURLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	
}
