package com.viksitpro.upload.controllers;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.attribute.PosixFilePermission;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;

import org.apache.commons.fileupload.FileItem;

import com.viksitpro.cms.services.LessonServices;
import com.viksitpro.core.dao.entities.Lesson;

public class MediaUploadServices {

	public MediaUploadServices() {
		super();
	}

	public String getAnyPath(String nick) throws IOException {
		Properties properties = new Properties();
		properties.load(LessonServices.class.getClassLoader().getResourceAsStream("app.properties"));
		String lessonXMLPath = properties.getProperty(nick);
		return lessonXMLPath;
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

	public PrintWriter writeToFile(FileItem item, Set<PosixFilePermission> perms, PrintWriter out, String extension)
			throws Exception {
		MediaUploadServices mediaUploadServices = new MediaUploadServices();
		UUID uui = UUID.randomUUID();
		File file = new File(mediaUploadServices.getAnyPath("imagePath"), uui.toString() + extension);
		System.err.println(file.getAbsolutePath());
		// Files.setPosixFilePermissions(Paths.get(prop.getProperty("imagePath")),
		// perms);
		// Files.setPosixFilePermissions(Paths.get(prop.getProperty("imagePath")),
		// perms);
		// set application user permissions to 455
		file.setExecutable(true, false);
		file.setReadable(true, false);
		file.setWritable(true, false);
		file.createNewFile();
		item.write(file);
		if (mediaUploadServices.getAnyPath("server_type").equalsIgnoreCase("linux")) {
			Files.setPosixFilePermissions(file.toPath(), perms);
		}
		System.err.println(mediaUploadServices.getAnyPath("imagePath") + uui.toString() + extension);
		System.out.println("UPLOADED" + item.getContentType());
		System.err.println(file.getAbsolutePath());
		out.print(mediaUploadServices.getAnyPath("media_url_path") + "course_images/" + file.getName());
		return out;
	}

	public StringBuffer writeToFileForSlide(String uuID, Lesson lesson, FileItem item, Set<PosixFilePermission> perms,
			StringBuffer out, String extension) throws Exception {
		MediaUploadServices mediaUploadServices = new MediaUploadServices();

		File file = new File(mediaUploadServices.getAnyPath("mediaLessonPath") + lesson.getId() + "/" + lesson.getId(),
				uuID + extension);
		System.err.println(file.getAbsolutePath());
		// Files.setPosixFilePermissions(Paths.get(prop.getProperty("imagePath")),
		// perms);
		// Files.setPosixFilePermissions(Paths.get(prop.getProperty("imagePath")),
		// perms);
		// set application user permissions to 455
		file.setExecutable(true, false);
		file.setReadable(true, false);
		file.setWritable(true, false);
		file.createNewFile();
		item.write(file);
		if (mediaUploadServices.getAnyPath("server_type").equalsIgnoreCase("linux")) {
			Files.setPosixFilePermissions(file.toPath(), perms);
		}
		System.err.println(mediaUploadServices.getAnyPath("media_url_path") + "lessonXMLs/" + lesson.getId() + "/"
				+ lesson.getId() + uuID + extension);
		System.out.println("UPLOADED" + item.getContentType());
		System.err.println(file.getAbsolutePath());
		out.append("/lessonXMLs/" + lesson.getId() + "/" + lesson.getId() + "/" + file.getName());
		System.out.println("inside>>>>>>>>> " + out.toString());
		return out;
	}
}
