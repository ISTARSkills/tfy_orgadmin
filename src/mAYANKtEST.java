import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.attribute.PosixFilePermission;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Properties;
import java.util.Set;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;

import com.viksitpro.core.cms.oldcontent.CMSImage;
import com.viksitpro.core.cms.oldcontent.CMSLesson;
import com.viksitpro.core.cms.oldcontent.CMSList;
import com.viksitpro.core.cms.oldcontent.CMSParagraph;
import com.viksitpro.core.cms.oldcontent.CMSSlide;
import com.viksitpro.core.cms.oldcontent.CMSTextItem;
import com.viksitpro.core.cms.oldcontent.CMSVideo;
import com.viksitpro.core.cms.oldcontent.services.ZipFiles;
import com.viksitpro.core.utilities.DBUTILS;

/**
 * 
 */

/**
 * @author ISTAR-SKILL
 *
 */
public class mAYANKtEST {
	
	
	public Connection getEltConnection()
	{
		try{
			
			Class.forName("org.postgresql.Driver");
			Connection connection = null;
			connection = DriverManager.getConnection(
			   "jdbc:postgresql://localhost:5432/elt","postgres", "4a626021-e55a");
			return connection;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}
	
	public Connection getApiConnection()
	{
		try{
			
			Class.forName("org.postgresql.Driver");
			Connection connection = null;
			connection = DriverManager.getConnection(
			   "jdbc:postgresql://localhost:5432/google_api","postgres", "4a626021-e55a");
			return connection;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}
	
	public static void main(String args[])
	{
		mAYANKtEST m = new mAYANKtEST();
		System.out.println("starretd");
		try {
			m.importAllLessonFromApi();
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
		System.out.println("finished");
	}

	private void importAllLessonFromApi() throws SQLException {
		
		HashSet<Integer> lessonIdsalreadyInElt = new HashSet<>();
		String getExistingLessonInElt ="select * from lesson ";
		Connection elt = getEltConnection();
		Statement eltstatement =  elt.createStatement();
		ResultSet eltRs = eltstatement.executeQuery(getExistingLessonInElt);
		if(eltRs.next())
		{
			while(eltRs.next())
			{
				lessonIdsalreadyInElt.add(eltRs.getInt("id"));
			}
		}
		
		
		HashMap<Integer, Integer> lessonIdsToBeImported = new HashMap();
		StringBuffer sb = new StringBuffer();
		String findLessonInApi ="select lesson.*, presentaion.id  as ppt_id from lesson, presentaion where lesson.id = presentaion.lesson_id and dtype='sds';";
		Connection api = getApiConnection();
		Statement apiStatement = api.createStatement();		
		ResultSet apiRs = apiStatement.executeQuery(findLessonInApi);
		if(apiRs.next())
		{
			while(apiRs.next())
			{
				Integer lessonId = apiRs.getInt("id");
				Integer duration = apiRs.getInt("duration");
				Integer pptId = apiRs.getInt("ppt_id");
				String tags ="";
				if(apiRs.getString("tags")!=null)
				{
					tags =  apiRs.getString("tags");
				}
				String title = apiRs.getString("title");
				title = title.replaceAll("'", "");
				
				
				if(!lessonIdsalreadyInElt.contains(lessonId))
				{
					lessonIdsToBeImported.put(lessonId, pptId);
					String insertSql = "INSERT INTO lesson (id, type, duration, tags, title, subject, order_id, created_at, is_deleted, description, image_url, lesson_xml, category, is_published, reference_ppt_id) "
							+ "VALUES ("+lessonId+", 'PRESENTATION', "+duration+",'"+tags+"', '"+title+"', NULL, NULL, now(), 'f', '"+title+"', '/', NULL, 'BOTH', 'f', "+pptId+");"+System.lineSeparator();
					sb.append(insertSql);
					System.out.println(insertSql);
				}					
			}
		}
		
		String FILENAME ="C:\\Users\\vaibhav\\Documents\\lesson_script.sql";
		try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILENAME ))) {
			String content = sb.toString();
			bw.write(content);
			System.out.println("Done");
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		for(Integer lessonId : lessonIdsToBeImported.keySet())
		{
			String cmsLessonInString = getLessonXMl(lessonId,lessonIdsToBeImported.get(lessonId));
			try {
				createlessonXMLFile(cmsLessonInString, lessonId);
			} catch (IOException e) {
			
				e.printStackTrace();
			}
		}
		
	}

	public boolean createlessonXMLFile(String cmsLessonInString, int lessonID) throws IOException{
		boolean success = false;
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
		
		if(!cmsLessonInString.trim().equalsIgnoreCase("")){
			String mediaPath ="";
			String serverType = "windows";
			try {
				Properties properties = new Properties();
				String propertyFileName = "app.properties";
				InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
				if (inputStream != null) {
					properties.load(inputStream);
				} else {
					throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
				}
				mediaPath = properties.getProperty("mediaPath");
				serverType = properties.getProperty("server_type");
			} catch (Exception e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
			
		
		//create structure like below
		//lessonXMLs//lessonId//lessonId//lessonId.xml
			File outerLessonFolder = new File(mediaPath + "lessonXMLs/" + lessonID);			
			//System.out.println(outerLessonFolder.getAbsolutePath());
			if (!outerLessonFolder.exists()) {
				//System.out.println("Folder does not exists");
				outerLessonFolder.mkdir();
				if(serverType.equalsIgnoreCase("linux"))
				{	
					Files.setPosixFilePermissions(Paths.get(outerLessonFolder.getAbsolutePath()), perms);
				}	
			}	
			
			
			File innerLessonFolder = new File(mediaPath + "lessonXMLs/" + lessonID+"/"+lessonID);			
			//System.out.println(innerLessonFolder.getAbsolutePath());
			if (!innerLessonFolder.exists()) {
				//System.out.println("Folder does not exists");
				innerLessonFolder.mkdir();
				if(serverType.equalsIgnoreCase("linux"))
				{	
					Files.setPosixFilePermissions(Paths.get(innerLessonFolder.getAbsolutePath()), perms);
				}	
			}	
			

			String lessonXMLPath=mediaPath + "lessonXMLs/" + lessonID+"/"+lessonID+"/"+lessonID+".xml";
			Writer out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(lessonXMLPath), "UTF-8"));
			try {				
					//////System.err.println(lessonXML);
			    out.write(cmsLessonInString.replaceAll("[^\\x00-\\x7F]",""));				
			} finally {
			    out.close();
			}
			String SOURCE_FOLDER =outerLessonFolder.getAbsolutePath();
			File sourceFile = new File(SOURCE_FOLDER);

			String zipName = outerLessonFolder.getAbsolutePath()+ ".zip";

			ZipFiles zipFiles = new ZipFiles();
			zipFiles.zipDirectory(sourceFile, zipName);
	}	
		return success;
	}
	private String getLessonXMl(Integer lessonId, Integer pptID) {

		StringWriter buffer = new StringWriter();
		Connection con = getApiConnection();
		CMSLesson cmsLesson = new CMSLesson();
		ArrayList<CMSSlide> cmSslides = new ArrayList<>();
		String sql = "select * from slide where presentation_id=" + pptID + " order by order_id";
		
		Statement statement = null;
		try {
			statement = con.createStatement();
			ResultSet rs = statement.executeQuery(sql);
			if(rs.next()){
				while (rs.next()) {
					CMSSlide cmsSlide = new CMSSlide();
					String slide_xml = (String) rs.getString("slide_text");
					try {
						JAXBContext context = JAXBContext.newInstance(CMSSlide.class);
						String slide_text = slide_xml.replaceAll("<br />", " ").replaceAll("<br>", " ")
								.replaceAll("&nbsp;", " ").replaceAll("&lt;br&gt;", " ").replaceAll("&lt;br /&gt;", " ")
								.replaceAll("[^\\x00-\\x7F]", "");						
						InputStream in = IOUtils.toInputStream(slide_text, "UTF-8");
						Unmarshaller jaxbUnmarshaller = context.createUnmarshaller();
						cmsSlide = (CMSSlide) jaxbUnmarshaller.unmarshal(in);
						cmsSlide.setId(rs.getInt("id"));
						cmsSlide.setOrder_id(rs.getInt("order_id"));
						cmsSlide = convertParaToList(cmsSlide, cmsSlide.getTemplateName());						
						cmsSlide = cleanListSlide(cmsSlide);
						cmsSlide = massageCMSLIDE(cmsSlide);
						cmsSlide = saveMediaRelatedToLesson(cmsSlide, lessonId);
						cmsSlide.setTeacherNotes(rs.getString("teacher_notes").toString());

					} catch (JAXBException e) {
						
					} catch (IOException e) {
						
					}
					cmSslides.add(cmsSlide);
				}
				
				cmsLesson.setSlides(cmSslides);
			}
			
			
			sql = "select * from lesson where id = (select p.lesson_id from presentaion  as p where p.id = " + pptID + ")";
			Statement statement2 = con.createStatement();
			ResultSet rs2 = statement2.executeQuery(sql);
			while (rs2.next()){
				cmsLesson.setLessonTitle(rs2.getString("title"));
				cmsLesson.setLessonDescription("NA");
				cmsLesson.setStudentNotes("NA");
				cmsLesson.setTeacherNotes("NA");
				cmsLesson.setType("PRESENTATION");
				try {
					JAXBContext context = JAXBContext.newInstance(CMSLesson.class);
					javax.xml.bind.Marshaller marshaller = context.createMarshaller();
					marshaller.setProperty(javax.xml.bind.Marshaller.JAXB_FORMATTED_OUTPUT, true);
					marshaller.marshal(cmsLesson, buffer);
				} catch (JAXBException e) {
					
				}
			}
			
		} catch (SQLException e1) {
			
			e1.printStackTrace();
		}
	
	
		return buffer.toString();
		
	}
	private CMSSlide convertParaToList(CMSSlide cmsSlide, String templateVMFileName) {
		if (templateVMFileName.equalsIgnoreCase("ONLY_TITLE_PARAGRAPH")) {

			CMSParagraph cmsphara = new CMSParagraph();

			if (!cmsSlide.getParagraph().getText().contains("<table")) {

				cmsSlide.setTemplateName("ONLY_TITLE_LIST");
				CMSList list = new CMSList();
				list.setList_type("SIMPLE_LIST_NO_BULLETS");
				
				ArrayList<CMSTextItem> textitemArray = new ArrayList();
				String[] words = cmsSlide.getParagraph().getText().split("\\<p.*?>");

				for (String w : words) {

					String[] result1 = w.split("\\<li.*?>");
					for (String w1 : result1) {

						CMSTextItem textitem = new CMSTextItem();
						textitem.setText(
								w1.replaceAll("</p>", "").replaceAll("&nbsp;", " ").replaceAll("</ul>", " ")
										.replaceAll("<ul>", " ").replaceAll("</li>", " ").trim());
						textitemArray.add(textitem);
					}

				}
				list.setItems(textitemArray);
				cmsSlide.setList(list);

				cmsphara.setText("");
				cmsSlide.setParagraph(cmsphara);

			} else {
				//System.err.println("has table");
			}

		}

		if (templateVMFileName.equalsIgnoreCase("ONLY_TITLE_PARAGRAPH_IMAGE")) {

			CMSParagraph cmsphara = new CMSParagraph();

			if (!cmsSlide.getParagraph().getText().contains("<table")) {

				cmsSlide.setTemplateName("ONLY_TITLE_PARAGRAPH_IMAGE_LIST");
				CMSList list = new CMSList();
				list.setList_type("SIMPLE_LIST_NO_BULLETS");
				ArrayList<CMSTextItem> textitemArray = new ArrayList();
				String[] words = cmsSlide.getParagraph().getText().split("\\<p.*?>");
				for (String w : words) {

					String[] result1 = w.split("\\<li.*?>");
					for (String w1 : result1) {

						CMSTextItem textitem = new CMSTextItem();
						textitem.setText(
								w1.replaceAll("</p>", "").replaceAll("&nbsp;", " ").replaceAll("</ul>", " ")
										.replaceAll("<ul>", " ").replaceAll("</li>", " ").trim());
						textitemArray.add(textitem);
					}

				}
				list.setItems(textitemArray);
				cmsSlide.setList(list);

				cmsphara.setText("");
				cmsSlide.setParagraph(cmsphara);

			} else {
				//System.err.println("has table");
			}

		}

		if (templateVMFileName.equalsIgnoreCase("ONLY_PARAGRAPH")) {

			CMSParagraph cmsphara = new CMSParagraph();

			if (!cmsSlide.getParagraph().getText().contains("<table")) {

				cmsSlide.setTemplateName("ONLY_LIST");
				CMSList list = new CMSList();
				list.setList_type("SIMPLE_LIST_NO_BULLETS");
				ArrayList<CMSTextItem> textitemArray = new ArrayList();
				String[] words = cmsSlide.getParagraph().getText().split("\\<p.*?>");
				for (String w : words) {

					String[] result1 = w.split("\\<li.*?>");
					for (String w1 : result1) {

						CMSTextItem textitem = new CMSTextItem();
						textitem.setText(
								w1.replaceAll("</p>", "").replaceAll("&nbsp;", " ").replaceAll("</ul>", " ")
										.replaceAll("<ul>", " ").replaceAll("</li>", " ").trim());
						textitemArray.add(textitem);
					}

				}
				list.setItems(textitemArray);
				cmsSlide.setList(list);

				cmsphara.setText("");
				cmsSlide.setParagraph(cmsphara);

			} else {
				//System.err.println("has table");
			}

		}

		if (templateVMFileName.equalsIgnoreCase("ONLY_PARAGRAPH_IMAGE")) {

			CMSParagraph cmsphara = new CMSParagraph();

			if (!cmsSlide.getParagraph().getText().contains("<table")) {

				cmsSlide.setTemplateName("ONLY_PARAGRAPH_IMAGE_LIST");
				CMSList list = new CMSList();
				list.setList_type("SIMPLE_LIST_NO_BULLETS");
				ArrayList<CMSTextItem> textitemArray = new ArrayList();
				String[] words = cmsSlide.getParagraph().getText().split("\\<p.*?>");
				for (String w : words) {

					String[] result1 = w.split("\\<li.*?>");
					for (String w1 : result1) {

						CMSTextItem textitem = new CMSTextItem();
						textitem.setText(
								w1.replaceAll("</p>", "").replaceAll("&nbsp;", " ").replaceAll("</ul>", " ")
										.replaceAll("<ul>", " ").replaceAll("</li>", " ").trim());
						textitemArray.add(textitem);
					}

				}
				list.setItems(textitemArray);
				cmsSlide.setList(list);

				cmsphara.setText("");
				cmsSlide.setParagraph(cmsphara);

			} else {
				//System.err.println("has table");
			}

		}

		if (templateVMFileName.equalsIgnoreCase("ONLY_PARAGRAPH_TITLE")) {

			CMSParagraph cmsphara = new CMSParagraph();

			if (!cmsSlide.getParagraph().getText().contains("<table")) {

				cmsSlide.setTemplateName("ONLY_PARAGRAPH_TITLE_LIST");
				CMSList list = new CMSList();
				list.setList_type("SIMPLE_LIST_NO_BULLETS");
				ArrayList<CMSTextItem> textitemArray = new ArrayList();
				String[] words = cmsSlide.getParagraph().getText().split("\\<p.*?>");
				for (String w : words) {

					String[] result1 = w.split("\\<li.*?>");
					for (String w1 : result1) {

						CMSTextItem textitem = new CMSTextItem();
						textitem.setText(
								w1.replaceAll("</p>", "").replaceAll("&nbsp;", " ").replaceAll("</ul>", " ")
										.replaceAll("<ul>", " ").replaceAll("</li>", " ").trim());
						textitemArray.add(textitem);
					}

				}
				
				list.setItems(textitemArray);
				cmsSlide.setList(list);

				cmsphara.setText("");
				cmsSlide.setParagraph(cmsphara);

			} else {
				//System.err.println("has table");
			}

		}
		return cmsSlide;
	}
	private CMSSlide cleanListSlide(CMSSlide cmsSlide) {
		
		//	if(cmsSlide.getTemplateName().toUpperCase().contains("LIST")){
			
			CMSList list = new CMSList();
			ArrayList<CMSTextItem> items = new ArrayList<>();
			if(cmsSlide.getList()!=null && cmsSlide.getList().getItems()!=null)
			{
				for (CMSTextItem item : cmsSlide.getList().getItems()) {
					if(item!=null && !item.getText().equalsIgnoreCase(""))
					{
						items.add(item);
					}
				}
				list.setList_type(cmsSlide.getList().getList_type());
				list.setItems(items);
				cmsSlide.setList(list);
			}	
			return cmsSlide;
		}
	private CMSSlide massageCMSLIDE(CMSSlide cmsSlide) {
		try
		{
		switch (cmsSlide.getTemplateName()) {
		case "ONLY_TITLE":
			cmsSlide.setFragmentCount(0);
			
			break;
		case "NO_CONTENT":
			cmsSlide.setFragmentCount(0);
			break;
		case "ONLY_TITLE_IMAGE":
			cmsSlide.setFragmentCount(1);
			break;
		case "ONLY_IMAGE":
			cmsSlide.setFragmentCount(0);
			break;
		case "ONLY_VIDEO":
			cmsSlide.setFragmentCount(0);
			break;
		case "ONLY_2TITLE":
			cmsSlide.setFragmentCount(1);
			break;
		case "ONLY_2TITLE_IMAGE":
			cmsSlide.setFragmentCount(2);
			break;

		case "ONLY_LIST":
			cmsSlide.setFragmentCount(cmsSlide.getList().getItems().size() - 1);
			break;
		case "ONLY_TITLE_LIST":
			cmsSlide.setFragmentCount(cmsSlide.getList().getItems().size());
			break;
		case "ONLY_TITLE_LIST_NUMBERED":
			cmsSlide.setFragmentCount(cmsSlide.getList().getItems().size());
			break;
		case "ONLY_LIST_NUMBERED":
			cmsSlide.setFragmentCount(cmsSlide.getList().getItems().size() - 1);
			break;

		case "ONLY_PARAGRAPH":

			ArrayList<String> arrayList = new ArrayList<>();
			if (cmsSlide.getParagraph().getText().contains("<table")) {

				if (cmsSlide.getParagraph().getText().contains("<p")) {

					for (String retval : cmsSlide.getParagraph().getText().split("<p")) {
						arrayList.add(retval);
					}

				} else {
					arrayList.add(cmsSlide.getParagraph().getText());
				}

			} else {
				for (CMSTextItem ss : cmsSlide.getList().getItems()) {
					if (!ss.getText().isEmpty()) {

						arrayList.add(ss.getText());
					}

				}
			}

			cmsSlide.setFragmentCount(arrayList.size() - 1);
			break;
		case "ONLY_PARAGRAPH_LIST":

			arrayList = new ArrayList<>();

			for (CMSTextItem ss : cmsSlide.getList().getItems()) {
				if (!ss.getText().isEmpty()) {

					arrayList.add(ss.getText());
				}

			}

			cmsSlide.setFragmentCount(arrayList.size() - 1);
			break;

		case "ONLY_PARAGRAPH_IMAGE":

			arrayList = new ArrayList<>();
			if (cmsSlide.getParagraph().getText().contains("<table")) {

				if (cmsSlide.getParagraph().getText().contains("<p")) {

					for (String retval : cmsSlide.getParagraph().getText().split("<p")) {
						arrayList.add(retval);
					}

				} else {
					arrayList.add(cmsSlide.getParagraph().getText());
				}

			} else {
				for (CMSTextItem ss : cmsSlide.getList().getItems()) {
					if (!ss.getText().isEmpty()) {

						arrayList.add(ss.getText());
					}

				}
			}
			cmsSlide.setFragmentCount(arrayList.size());

			break;

		case "ONLY_PARAGRAPH_IMAGE_LIST":
			arrayList = new ArrayList<>();

			for (CMSTextItem ss : cmsSlide.getList().getItems()) {
				if (!ss.getText().isEmpty()) {

					arrayList.add(ss.getText());
				}

			}

			cmsSlide.setFragmentCount(arrayList.size());
			break;
		case "ONLY_TITLE_PARAGRAPH_LIST":
			arrayList = new ArrayList<>();

			for (CMSTextItem ss : cmsSlide.getList().getItems()) {
				if (!ss.getText().isEmpty()) {

					arrayList.add(ss.getText());
				}

			}

			cmsSlide.setFragmentCount(arrayList.size());
			break;

		case "ONLY_TITLE_PARAGRAPH":
			arrayList = new ArrayList<>();

			if (cmsSlide.getParagraph().getText().contains("<table")) {

				if (cmsSlide.getParagraph().getText().contains("<p")) {

					for (String retval : cmsSlide.getParagraph().getText().split("<p")) {
						arrayList.add(retval);
					}

				} else {
					arrayList.add(cmsSlide.getParagraph().getText());
				}

			} else {
				for (CMSTextItem ss : cmsSlide.getList().getItems()) {
					if (!ss.getText().isEmpty()) {

						arrayList.add(ss.getText());
					}

				}
			}

			cmsSlide.setFragmentCount(arrayList.size());
			break;

		case "ONLY_PARAGRAPH_TITLE_LIST":
			arrayList = new ArrayList<>();

			for (CMSTextItem ss : cmsSlide.getList().getItems()) {
				if (!ss.getText().isEmpty()) {

					arrayList.add(ss.getText());
				}

			}

			cmsSlide.setFragmentCount(arrayList.size());
			break;

		case "ONLY_PARAGRAPH_TITLE":
			arrayList = new ArrayList<>();
			if (cmsSlide.getParagraph().getText().contains("<table")) {

				if (cmsSlide.getParagraph().getText().contains("<p")) {

					for (String retval : cmsSlide.getParagraph().getText().split("<p")) {
						arrayList.add(retval);
					}

				} else {
					arrayList.add(cmsSlide.getParagraph().getText());
				}

			} else {
				for (CMSTextItem ss : cmsSlide.getList().getItems()) {
					if (!ss.getText().isEmpty()) {

						arrayList.add(ss.getText());
					}

				}
			}
			cmsSlide.setFragmentCount(arrayList.size());
			break;
		case "ONLY_TITLE_PARAGRAPH_IMAGE":

			arrayList = new ArrayList<>();
			if (cmsSlide.getParagraph().getText().contains("<table")) {

				if (cmsSlide.getParagraph().getText().contains("<p")) {

					for (String retval : cmsSlide.getParagraph().getText().split("<p")) {
						arrayList.add(retval);
					}

				} else {
					arrayList.add(cmsSlide.getParagraph().getText());
				}

			} else {
				for (CMSTextItem ss : cmsSlide.getList().getItems()) {
					if (!ss.getText().isEmpty()) {

						arrayList.add(ss.getText());
					}

				}
			}
			cmsSlide.setFragmentCount(arrayList.size() + 1);

			break;

		case "ONLY_TITLE_PARAGRAPH_IMAGE_LIST":

			arrayList = new ArrayList<>();

			for (CMSTextItem ss : cmsSlide.getList().getItems()) {
				if (!ss.getText().isEmpty()) {

					arrayList.add(ss.getText());
				}

			}

			cmsSlide.setFragmentCount(arrayList.size() + 1);

			break;

		case "ONLY_TITLE_TREE":

			arrayList = new ArrayList<>();

			for (CMSTextItem ss : cmsSlide.getList().getItems()) {
				if (!ss.getText().isEmpty()) {

					arrayList.add(ss.getText());

					for (CMSTextItem sl : ss.getList().getItems()) {

						arrayList.add(sl.getText());
					}

				}

			}

			cmsSlide.setFragmentCount(arrayList.size());

			break;

		default:
			break;

		case "ONLY_2BOX":

			arrayList = new ArrayList<>();

			for (CMSTextItem ss : cmsSlide.getList().getItems()) {
				if (!ss.getText().isEmpty()) {

					arrayList.add(ss.getText());
				}

			}

			cmsSlide.setFragmentCount(arrayList.size() + 1);

			break;
		}

		}catch(Exception ex)
		{
			
		}
		// TODO Auto-generated method stub
		return cmsSlide;
		
	}
	private String getMediaPath() {
		String mediaPath = null;
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
				mediaPath = properties.getProperty("mediaPath");
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return mediaPath;
	}

	private String getMediaUrl() {
		String mediaPath = null;
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
				mediaPath = properties.getProperty("media_url_path");
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return mediaPath;
	}
	private String getOldMediaPath() {
		String mediaPath = null;
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
				mediaPath = properties.getProperty("old_media_path");
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return mediaPath;
	}
	private CMSSlide saveMediaRelatedToLesson(CMSSlide cmsSlide, int lessonId) {
		String oldMediaPath = getOldMediaPath();
		String mediaUrlPath = getMediaUrl();
		mediaUrlPath = mediaUrlPath+"/lessonXMLs/"+lessonId+"/"+lessonId+"/";
		Set<String> allUrls = new HashSet<String>();
		try {
			allUrls.add(oldMediaPath + cmsSlide.getImage_BG());
			try {
				allUrls.add(oldMediaPath + cmsSlide.getImage_BG().replaceAll(".png", "_desktop.png"));
			} catch (Exception e) {
				
				//e.printStackTrace();
			}
			
			if (cmsSlide.getImage_BG() != null && !cmsSlide.getImage_BG().contains("http")
					&& !cmsSlide.getImage_BG().contains("none") && !cmsSlide.getImage_BG().contains("null")) {
				cmsSlide.setImage_BG(mediaUrlPath + cmsSlide.getImage_BG().replace("/video/backgrounds/", ""));
			}
			allUrls.add(oldMediaPath + cmsSlide.getAudioUrl());
			if (cmsSlide.getAudioUrl() != null && !cmsSlide.getAudioUrl().equalsIgnoreCase("none")) {
				cmsSlide.setAudioUrl(mediaUrlPath + cmsSlide.getAudioUrl().replace("/video/", ""));
			}
			if (cmsSlide.getTitle() != null) {
				allUrls.add(oldMediaPath + cmsSlide.getTitle().getFragmentAudioUrl());
				if (cmsSlide.getTitle().getFragmentAudioUrl() != null) {
					cmsSlide.getTitle().setFragmentAudioUrl(
							mediaUrlPath + cmsSlide.getTitle().getFragmentAudioUrl().replace("/video/", ""));
				}
			}
			if (cmsSlide.getTitle2() != null) {
				allUrls.add(oldMediaPath + cmsSlide.getTitle2().getFragmentAudioUrl());
				if (cmsSlide.getTitle2().getFragmentAudioUrl() != null) {
					cmsSlide.getTitle2().setFragmentAudioUrl(
							mediaUrlPath + cmsSlide.getTitle2().getFragmentAudioUrl().replace("/video/", ""));
				}
			}
			if (cmsSlide.getParagraph() != null) {
				allUrls.add(oldMediaPath + cmsSlide.getParagraph().getFragmentAudioUrl());
				if (cmsSlide.getParagraph().getFragmentAudioUrl() != null) {
					cmsSlide.getParagraph().setFragmentAudioUrl(mediaUrlPath
							+ cmsSlide.getParagraph().getFragmentAudioUrl().replace("/video/", ""));
				}

			}
			if (cmsSlide.getList() != null) {
				ArrayList<CMSTextItem> newItems = new ArrayList<>();
				allUrls.add(oldMediaPath + cmsSlide.getList().getMergedAudioURL());
				if(cmsSlide.getList().getItems()!=null)
				{
					for (CMSTextItem item : cmsSlide.getList().getItems()) {
						allUrls.add(oldMediaPath + item.getFragmentAudioUrl());
						if (item.getFragmentAudioUrl() != null
								&& !item.getFragmentAudioUrl().equalsIgnoreCase("") && !item.getFragmentAudioUrl().contains("none")) {
							item.setFragmentAudioUrl(
									mediaUrlPath + item.getFragmentAudioUrl().replace("/video/", ""));

						}
						newItems.add(item);
					}
				}
				cmsSlide.getList().setItems(newItems);

				if (cmsSlide.getList().getMergedAudioURL() != null
						&& !cmsSlide.getList().getMergedAudioURL().equalsIgnoreCase("none")
						&& !cmsSlide.getList().getMergedAudioURL().equalsIgnoreCase("null")) {
					cmsSlide.getList().setMergedAudioURL(
							mediaUrlPath + cmsSlide.getList().getMergedAudioURL().replace("/video/", ""));
				}

			}
			if (cmsSlide.getImage() != null) {

				allUrls.add(oldMediaPath + cmsSlide.getImage().getUrl());
				/////System.out.println("uodated image url " + cmsSlide.getImage().getUrl()
					//	.replace("/content/media_upload?getfile=", "").replace("/video/", ""));
				if (cmsSlide.getImage().getUrl() != null && !cmsSlide.getImage().getUrl().contains("http")) {

					CMSImage im = cmsSlide.getImage();
					String updateImageUrl = mediaUrlPath + cmsSlide.getImage().getUrl()
							.replace("/content/media_upload?getfile=", "").replace("/video/", "");
					im.setUrl(updateImageUrl);
					cmsSlide.setImage(im);
				} else {

				}
				
				allUrls.add(oldMediaPath + cmsSlide.getImage().getFragmentAudioUrl());
				if (cmsSlide.getImage().getFragmentAudioUrl() != null) {
					cmsSlide.getImage().setFragmentAudioUrl(
							mediaUrlPath + cmsSlide.getImage().getFragmentAudioUrl().replace("/video/", ""));
				}

				////System.err.println(">>>>>>>>>>>>>>>" + cmsSlide.getImage().getUrl());

			} else {
				////System.err.println("cmsSlide.getImage() is null");
			}
			if (cmsSlide.getVideo() != null) {
				allUrls.add(oldMediaPath + cmsSlide.getVideo().getUrl());
				if (cmsSlide.getVideo().getUrl() != null && !cmsSlide.getVideo().getUrl().contains("http")) {
					CMSVideo vid = new CMSVideo();
					////System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>video"+oldMediaPath + cmsSlide.getVideo().getUrl());
					String updatedUrl = mediaUrlPath + cmsSlide.getVideo().getUrl().replace("/content/media_upload?getfile=", "").replace("/video/", "").replaceAll(" ", "_");
					vid.setUrl(updatedUrl);
					
					cmsSlide.setVideo(vid);
				}
			}
		} catch (NullPointerException eeee) {
			eeee.printStackTrace();
		}
		

		
		savecollectedMediaInLessonFolder(allUrls, lessonId);
		
		
		
		
		return cmsSlide;
	}
	private String getServerType() {
		String mediaPath = null;
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
				mediaPath = properties.getProperty("server_type");
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return mediaPath;
	}
	private void savecollectedMediaInLessonFolder(Set<String> allUrls, int lessonID) {
		
		String mediaPath = getMediaPath();
		String oldMediaPath = getOldMediaPath();
		String mediaUrlPath = getMediaUrl();
		String serverType = getServerType();
		
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
		
		//create structure like below
				//lessonXMLs//lessonId//lessonId//lessonId.xml
					File outerLessonFolder = new File(mediaPath + "lessonXMLs/" + lessonID);			
					////System.out.println(outerLessonFolder.getAbsolutePath());
					if (!outerLessonFolder.exists()) {
						////System.out.println("Folder does not exists");
						outerLessonFolder.mkdir();
						if(serverType.equalsIgnoreCase("linux"))
						{	
							try {
								Files.setPosixFilePermissions(Paths.get(outerLessonFolder.getAbsolutePath()), perms);
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}	
					}	
					
					
					File innerLessonFolder = new File(mediaPath + "lessonXMLs/" + lessonID+"/"+lessonID);			
					////System.out.println(innerLessonFolder.getAbsolutePath());
					if (!innerLessonFolder.exists()) {
						////System.out.println("Folder does not exists");
						innerLessonFolder.mkdir();
						if(serverType.equalsIgnoreCase("linux"))
						{	
							try {
								Files.setPosixFilePermissions(Paths.get(innerLessonFolder.getAbsolutePath()), perms);
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}	
					}	
					
		
		
		for (String str : allUrls) {
		//	//System.out.println("iterating strsss!!!!!!!!!!!!" + str);
			if (str != null && !str.contains("null") && !str.contains("none")
					&& !str.equalsIgnoreCase(oldMediaPath)) {
				str = str.replace("/content/media_upload?getfile=", "").replaceAll("/video/", "");
				String fileName = str.replace("backgrounds/", "");
				fileName = fileName.replace(getOldMediaPath(), "");
				File src = new File(str);
				////System.err.println("src file name ->"+ src.getAbsolutePath());
				
				File fileInLessonXMLFolder = new File(mediaPath + "lessonXMLs/" + lessonID + "/" +lessonID+"/"+fileName);
				try {
					////System.err.println("src file "+src.getAbsolutePath());
					FileUtils.copyFile(src, fileInLessonXMLFolder);
					if(serverType.equalsIgnoreCase("linux")){
						Files.setPosixFilePermissions(Paths.get(fileInLessonXMLFolder.getAbsolutePath()), perms);
					}
				} catch (IOException e) {

				}
			}

		}
		
		
		
		
	}
}
