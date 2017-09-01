package com.viksitpro.user.service;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.attribute.PosixFilePermission;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.io.FileUtils;

import com.viksitpro.cms.services.LessonServices;
import com.viksitpro.upload.controllers.MediaUploadServices;

public class UserMediaUploadService {
	
	
	public UserMediaUploadService() {
		super();
	}

	public String getAnyPath(String nick)  throws IOException {
		
             String mediaUrlPath ="";
		try{
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
				if (inputStream != null) {
					properties.load(inputStream);
					mediaUrlPath =  properties.getProperty(nick);
				}
			} catch (IOException e) {
				e.printStackTrace();
			
		}
		 
		return mediaUrlPath;
	}

	public Set<PosixFilePermission> getPermissions() {
		Set<PosixFilePermission> perms = new HashSet<PosixFilePermission>();
		// add owners permission
		perms.add(PosixFilePermission.OWNER_READ);
		perms.add(PosixFilePermission.OWNER_WRITE);
		perms.add(PosixFilePermission.OWNER_EXECUTE);
		// add group permissions
		perms.add(PosixFilePermission.GROUP_READ);
		perms.add(PosixFilePermission.GROUP_WRITE);
		perms.add(PosixFilePermission.GROUP_EXECUTE);
		// add others permissions
		perms.add(PosixFilePermission.OTHERS_READ);
		perms.add(PosixFilePermission.OTHERS_WRITE);
		perms.add(PosixFilePermission.OTHERS_EXECUTE);
		return perms;
	}

	public StringBuffer writeUserProfile(FileItem item, Set<PosixFilePermission> perms, String extension,int user_id)
			throws Exception {
		StringBuffer out  = new StringBuffer();
		UserMediaUploadService mediaUploadServices = new UserMediaUploadService();
		UUID uui = UUID.randomUUID();
		File file = new File(mediaUploadServices.getAnyPath("mediaPath") + "users/" + user_id);
		
		if (!file.exists()){
			   file.mkdir();
		    }else {
		    	FileUtils.cleanDirectory(file); 
		    }
		
		 file = new File(mediaUploadServices.getAnyPath("mediaPath") + "users/" + user_id + "/" + uui.toString() + extension);
	//	System.err.println(file.getAbsolutePath());
		
		file.setExecutable(true, false);
		file.setReadable(true, false);
		file.setWritable(true, false);
		file.createNewFile();
		item.write(file);
		if (mediaUploadServices.getAnyPath("server_type").equalsIgnoreCase("linux")) {
			Files.setPosixFilePermissions(file.toPath(), perms);
		}
		//System.err.println(mediaUploadServices.getAnyPath("mediaPath") + uui.toString() + extension);
		//System.out.println("UPLOADED" + item.getContentType());
		System.err.println(file.getAbsolutePath());
		//System.err.println(mediaUploadServices.getAnyPath("media_url_path") + "users/" + file.getName());
		out.append("users/"+ user_id + "/" + file.getName());
		return out;
	}
	
	

}
