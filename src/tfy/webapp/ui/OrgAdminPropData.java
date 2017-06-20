/**
 * 
 */
package tfy.webapp.ui;

import java.io.FileNotFoundException;
import java.io.InputStream;
import java.util.Properties;

/**
 * @author ISTAR-SERVER-PU-1
 *
 */
public class OrgAdminPropData {
	public static String get(String prop){
		String path = "";
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = OrgAdminPropData.class.getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
			} else {
				throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
			}
			path = properties.getProperty(prop);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		return path;
		
	}
}
