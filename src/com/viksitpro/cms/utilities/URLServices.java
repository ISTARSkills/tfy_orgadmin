package com.viksitpro.cms.utilities;

import java.io.IOException;
import java.util.Properties;

import com.viksitpro.upload.controllers.MediaUploadController;

public class URLServices {
	
	public URLServices() {
		super();
		// TODO Auto-generated constructor stub
	}

	public String getBaseUrl() {
		String path = "";
		Properties prop = new Properties();
		try {
			prop.load(MediaUploadController.class.getClassLoader().getResourceAsStream("app.properties"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		path = prop.getProperty("media_url_path");
		return path;
	}
}
