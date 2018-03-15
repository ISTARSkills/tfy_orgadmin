
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.attribute.PosixFilePermission;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.servlet.ServletRequestContext;

import com.viksitpro.cms.services.LessonServices;
import com.viksitpro.core.cms.oldcontent.CMSImage;
import com.viksitpro.core.cms.oldcontent.CMSLesson;
import com.viksitpro.core.cms.oldcontent.CMSList;
import com.viksitpro.core.cms.oldcontent.CMSSlide;
import com.viksitpro.core.cms.oldcontent.CMSTextItem;
import com.viksitpro.core.cms.oldcontent.CMSTitle;
import com.viksitpro.core.cms.oldcontent.CMSTitle2;
import com.viksitpro.core.cms.oldcontent.CMSVideo;
import com.viksitpro.core.dao.entities.Lesson;
import com.viksitpro.core.dao.entities.LessonDAO;
import com.viksitpro.core.utilities.IStarBaseServelet;
import com.viksitpro.upload.controllers.MediaUploadServices;

@WebServlet("/edit_ppt")
public class SlideEditController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SlideEditController() {
		super();
		// TODO Auto-generated constructor stub
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		

		String lesson_id = null;
		String slide_id = null;
		String element_type = null;
		String value = null;
		String upload_img_type = null;
		String BG_Image = "http://images.all-free-download.com/images/graphicthumb/blank_note_document_4179.jpg";
		int fragment_index = 0;
		int child_fragment_index = 0;
		String template_type = null;
		String color_code = "";

		if (ServletFileUpload.isMultipartContent(request)) {

			StringBuffer out = new StringBuffer();
			MediaUploadServices mediaUploadServices = new MediaUploadServices();
			out.append(mediaUploadServices.getAnyPath("media_url_path"));
			Set<PosixFilePermission> perms = mediaUploadServices.getPermissions();
			Lesson lesson = new Lesson();
			try {
				List<FileItem> items = new ServletFileUpload(new DiskFileItemFactory()).parseRequest(new ServletRequestContext(request));
				for (FileItem item : items) {
					if (item.getFieldName().equalsIgnoreCase("lesson")) {
						lesson_id = item.getString();
						System.err.println(lesson_id);
						lesson = (new LessonDAO()).findById(Integer.parseInt(lesson_id));
					}
					if (item.getFieldName().equalsIgnoreCase("slide_id")) {
						slide_id = item.getString();
						slide_id = slide_id.replaceAll("-", "");
						//System.err.println(slide_id);
					}
					if (item.getFieldName().equalsIgnoreCase("template_type")) {
						template_type = item.getString();
					System.err.println(template_type);
					}
					if (item.getFieldName().equalsIgnoreCase("element_type")) {
						element_type = item.getString();
					System.err.println(element_type);
					}
					if (item.getFieldName().equalsIgnoreCase("upload_img_type")) {
						upload_img_type = item.getString();
						System.err.println("----------------->"+upload_img_type);
					}
				}
				LessonServices services = new LessonServices();
				if (services.checkLessonFolderExists(lesson)) {

				} else {
					services.createLessonFolder(lesson);
				}
				UUID uui = UUID.randomUUID();
				boolean flag = true;
				String uuID = uui.toString();
				for (FileItem item : items) {

					if (!item.isFormField()) {
						System.err.println(item.getName());
						
						System.err.println(uuID);
						System.err.println(item.getName());
						String[] str = item.getName().split(".");
						
						if(upload_img_type.equalsIgnoreCase("background_img")) {
							uuID = uui.toString() + "_desktop";
							BG_Image = out.toString();
							
						}

						if (item.getName().toLowerCase().endsWith(".PNG".toLowerCase())) {
                             out = mediaUploadServices.writeToFileForSlide(uuID, lesson, item, perms, out, ".png");
                             System.err.println(out.toString());
                          }
						if(item.getName().toLowerCase().endsWith(".GIF".toLowerCase())) {
							out = mediaUploadServices.writeToFileForSlide(uuID, lesson, item, perms, out, ".gif");
						}
						if(item.getName().toLowerCase().endsWith(".MP4".toLowerCase())) {
							out = mediaUploadServices.writeToFileForSlide(uuID, lesson, item, perms, out, ".mp4");
						}
						if (flag) {
							flag = false;
							uuID = uui.toString() + "_desktop";
							BG_Image = out.toString();
							
						}
					}
				}
			} catch (FileUploadException e) {
				e.printStackTrace();
				// TODO: handle exception
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else {
			value = request.getParameter("value");
			lesson_id = request.getParameter("lesson_id");
			element_type = request.getParameter("element_type");
			template_type = request.getParameter("template_type");
			color_code = request.getParameter("color_code");
			slide_id = request.getParameter("slide_id");
			slide_id = slide_id.replaceAll("-", "");
			System.err.println(slide_id);
			fragment_index = 0;
			child_fragment_index = 0;
			if (request.getParameter("fragment_index") != null) {
				fragment_index = Integer.parseInt(request.getParameter("fragment_index"));
			}
			if (request.getParameter("child_fragment_index") != null) {
				child_fragment_index = Integer.parseInt(request.getParameter("child_fragment_index"));
			}
		}
		String path = "";
		try {
			Properties properties = new Properties();
			String propertyFileName = "app.properties";
			InputStream inputStream = getClass().getClassLoader().getResourceAsStream(propertyFileName);
			if (inputStream != null) {
				properties.load(inputStream);
			} else {
				throw new FileNotFoundException("property file '" + propertyFileName + "' not found in the classpath");
			}
			path = properties.getProperty("mediaLessonPath");
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		path += "" + lesson_id + "/" + lesson_id + "/" + lesson_id + ".xml";

		File file = new File(path);

		CMSLesson cmsLesson = (CMSLesson) getLessonXml(file, lesson_id, slide_id, element_type, value, fragment_index, child_fragment_index, template_type, BG_Image,upload_img_type,color_code);
		writeLessonXml(file, lesson_id, cmsLesson);
		if (value != null) {
			if (value.trim().equalsIgnoreCase("") || value.trim().equalsIgnoreCase("EMPTY_TITLE")) {

				value = "Click to edit " + element_type.toLowerCase() + "....";
				System.err.println("<<<<<---->>>>>" + value);
			}

		}

		System.err.println("---->>>>>" + value);
		response.getWriter().append(value);

	}

	private void writeLessonXml(File file, String lesson_id, CMSLesson cmsLesson) {

		try {

			JAXBContext jaxbContext = JAXBContext.newInstance(CMSLesson.class);
			Marshaller jaxbMarshaller = jaxbContext.createMarshaller();

			jaxbMarshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);

			jaxbMarshaller.marshal(cmsLesson, file);
			// jaxbMarshaller.marshal(cmsLesson, System.out);

		} catch (JAXBException e) {
			e.printStackTrace();
		}

	}

	private Object getLessonXml(File file, String lesson_id, String slide_id, String element_type, String value, int fragment_index, int child_fragment_index, String template_type, String BG_Image,String upload_img_type,String color_code) {

		try {

			JAXBContext jaxbcontext = JAXBContext.newInstance(CMSLesson.class);
			Unmarshaller unmarshaller = jaxbcontext.createUnmarshaller();
			CMSLesson cmsLesson = (CMSLesson) unmarshaller.unmarshal(file);
			boolean isNew = true;
			ArrayList<CMSSlide> cmsSlideList = new ArrayList();
			int order_id = 1;
			if (cmsLesson.getSlides() != null) {
				for (CMSSlide cmsSlide : cmsLesson.getSlides()) {

					if (cmsSlide.getId() == Integer.parseInt(slide_id)) {
						System.err.println("cmsSlide.getId()"+cmsSlide.getId());
						System.err.println("color_code"+color_code);
						if (color_code != null && !color_code.equalsIgnoreCase("")) {

							cmsSlide.setBackground(color_code);

							isNew = false;
							break;

						}
						
						if (element_type.equalsIgnoreCase("TITLE")) {

							if (value.trim().equalsIgnoreCase("")) {

							} else {
								cmsSlide.setTitle(new CMSTitle(value));

							}

							isNew = false;
							break;

						}
						if (element_type.equalsIgnoreCase("TITLE2")) {

							if (value.trim().equalsIgnoreCase("")) {

							} else {
								cmsSlide.setTitle2(new CMSTitle2(value));

							}

							isNew = false;
							break;
						}
						System.err.println("cmsSlide.getId()"+cmsSlide.getId());
						if (element_type.equalsIgnoreCase("IMAGE")) {
                               System.err.println("upload_img_typeupload_img_typeupload_img_type"+upload_img_type);
							if (template_type.equalsIgnoreCase("NO_CONTENT") || upload_img_type.equalsIgnoreCase("background_img")) {

								cmsSlide.setImage_BG(BG_Image.replaceAll("_desktop", ""));

							} else {
						   cmsSlide.getImage().setUrl(BG_Image);
						System.err.println("<><>><><><><><><"+cmsSlide.getImage().getUrl());
							}

							isNew = false;
							break;
						}
						
						if (element_type.equalsIgnoreCase("VIDEO")) {

	
							CMSVideo cmsVideo = new CMSVideo();
							cmsVideo.setUrl(BG_Image);
							cmsSlide.setVideo(cmsVideo);
					     	

							isNew = false;
							break;
						}
						if (element_type.equalsIgnoreCase("LIST")) {

							int totalSize = 0;
							if (cmsSlide.getList() != null && cmsSlide.getList().getItems() != null && cmsSlide.getList().getItems().size() != 0) {
								totalSize = cmsSlide.getList().getItems().size();

							}

							if (fragment_index < totalSize) {
								if (value.trim().equalsIgnoreCase("")) {
									if (template_type.equalsIgnoreCase("ONLY_TITLE_TREE")) {
										cmsSlide.getList().getItems().get(fragment_index).setText(value);
									}

									else {
										cmsSlide.getList().getItems().remove(fragment_index);
										
									}
									int fragmentcont = cmsSlide.getFragmentCount();
									cmsSlide.setFragmentCount(fragmentcont - 1);

								} else {
									cmsSlide.getList().getItems().get(fragment_index).setText(value);

									int fragmentcont = cmsSlide.getFragmentCount();
									if(template_type.equalsIgnoreCase("ONLY_2BOX")) {
										if(cmsSlide.getFragmentCount() < 3 ) {
											cmsSlide.setFragmentCount(fragmentcont + 1);
										}
									}else if(template_type.equalsIgnoreCase("ONLY_TITLE_TREE")) {
										if(cmsSlide.getFragmentCount() < 3 ) {
											cmsSlide.setFragmentCount(fragmentcont + 1);
										}
									}
									else {
										if(cmsSlide.getFragmentCount() < 4 ) {
											cmsSlide.setFragmentCount(fragmentcont + 1);
										}
									}
									
									

								}
							} else {
								if (!value.trim().equalsIgnoreCase("")) {

									CMSList cmsList = new CMSList();
									ArrayList<CMSTextItem> items = new ArrayList<>();
									CMSTextItem cmsTextItem = new CMSTextItem();
									cmsTextItem.setText(value);
									cmsTextItem.setDescription("NO_DESC");
									cmsTextItem.setfragmentDuration(0);
									cmsTextItem.setId(0);
									cmsTextItem.setFragmentAudioUrl("");
									if (cmsSlide.getList().getItems() != null) {
										for (CMSTextItem list : cmsSlide.getList().getItems()) {
											if (!list.getText().trim().equalsIgnoreCase("")) {
												items.add(list);
											}
										}
									}

									items.add(cmsTextItem);
									cmsList.setList_type("SIMPLE_LIST");
									cmsList.setItems(items);
									int fragmentcont = cmsSlide.getFragmentCount();
									cmsSlide.setFragmentCount(fragmentcont + 1);
									cmsSlide.setList(cmsList);
								}
							}

							isNew = false;
							break;
						}
						if (element_type.equalsIgnoreCase("SUBLIST")) {

							cmsSlide.getList().getItems().get(fragment_index).getList().getItems().get(child_fragment_index).setText(value);

							isNew = false;
							break;
						}

					} else {

						if (cmsSlide.getOrder_id() > order_id) {
							order_id = cmsSlide.getOrder_id();
						}
						cmsSlideList.add(cmsSlide);
						isNew = true;
					}
				}
			} else {
				order_id = 0;
			}
			if (isNew) {

				CMSSlide cmsSlide = new CMSSlide();
				
				
				CMSTitle cmsTitle = new CMSTitle();
				CMSTitle2 cmsTitle2 = new CMSTitle2();
				CMSImage cmsImage = new CMSImage();
				cmsTitle.setText("EMPTY_TITLE");
				// cmsImage.setUrl("http://images.all-free-download.com/images/graphicthumb/blank_note_document_4179.jpg");
				if (element_type.equalsIgnoreCase("TITLE")) {
					cmsTitle.setText(value);
					int fragmentcont = cmsSlide.getFragmentCount() != null ? cmsSlide.getFragmentCount() : -1;
					cmsSlide.setFragmentCount(fragmentcont + 1);
				}
				if (element_type.equalsIgnoreCase("TITLE2")) {
					cmsTitle2.setText(value);
					int fragmentcont = cmsSlide.getFragmentCount() != null ? cmsSlide.getFragmentCount() : -1;
					cmsSlide.setFragmentCount(fragmentcont + 1);
				}
				CMSList cmsList = new CMSList();
				if (element_type.equalsIgnoreCase("LIST")) {
					ArrayList<CMSTextItem> items = new ArrayList<>();
					CMSTextItem cmsTextItem = new CMSTextItem();
					cmsTextItem.setText(value);
					cmsTextItem.setDescription("NO_DESC");
					cmsTextItem.setfragmentDuration(0);
					cmsTextItem.setId(0);
					cmsTextItem.setFragmentAudioUrl("");
					items.add(cmsTextItem);
					cmsList.setList_type("SIMPLE_LIST");
					cmsList.setItems(items);
					cmsSlide.setList(cmsList);

				}

				if (template_type.equalsIgnoreCase("ONLY_TITLE_TREE")) {

					ArrayList<CMSTextItem> items = new ArrayList<>();
					for (int i = 0; i <= 2; i++) {
						CMSTextItem cmsTextItem = new CMSTextItem();
						if (element_type.equalsIgnoreCase("LIST") && fragment_index == i) {

							cmsTextItem.setText(value);
							System.err.println(value);

						} else {
							cmsTextItem.setText("");
						}

						cmsTextItem.setDescription("NO_DESC");
						cmsTextItem.setfragmentDuration(0);
						cmsTextItem.setId(0);
						cmsTextItem.setFragmentAudioUrl("");

						CMSList cmsSubList = new CMSList();
						ArrayList<CMSTextItem> subitems = new ArrayList<>();
						for (int j = 0; j <= 1; j++) {
							CMSTextItem cmsSubTextItem = new CMSTextItem();

							if (element_type.equalsIgnoreCase("SUBLIST") && fragment_index == i && child_fragment_index == j) {

								cmsSubTextItem.setText(value);
								System.err.println(value);
							} else {
								cmsSubTextItem.setText("");
							}

							cmsSubTextItem.setDescription("NO_DESC");
							cmsSubTextItem.setfragmentDuration(0);
							cmsSubTextItem.setId(0);
							cmsSubTextItem.setFragmentAudioUrl("");
							subitems.add(cmsSubTextItem);
						}
						cmsSubList.setItems(subitems);
						cmsTextItem.setList(cmsSubList);
						items.add(cmsTextItem);
					}
					cmsList.setItems(items);
					cmsSlide.setList(cmsList);
					cmsSlide.setFragmentCount(0);

				}
				if (template_type.equalsIgnoreCase("ONLY_VIDEO") || template_type.equalsIgnoreCase("ONLY_TITLE") || template_type.equalsIgnoreCase("ONLY_TITLE_IMAGE") || template_type.equalsIgnoreCase("ONLY_IMAGE") || template_type.equalsIgnoreCase("ONLY_2TITLE") || template_type.equalsIgnoreCase("NO_CONTENT") || template_type.equalsIgnoreCase("ONLY_2TITLE_IMAGE") || template_type.equalsIgnoreCase("ONLY_TITLE_LIST")
						|| template_type.equalsIgnoreCase("ONLY_TITLE_LIST_NUMBERED") || template_type.equalsIgnoreCase("ONLY_TITLE_IMAGE") || template_type.equalsIgnoreCase("ONLY_TITLE_PARAGRAPH_IMAGE") || template_type.equalsIgnoreCase("ONLY_PARAGRAPH_IMAGE") || template_type.equalsIgnoreCase("ONLY_PARAGRAPH_TITLE_LIST") || template_type.equalsIgnoreCase("ONLY_PARAGRAPH_IMAGE_LIST") || template_type.equalsIgnoreCase("ONLY_TITLE_PARAGRAPH_IMAGE_LIST")) {
					cmsSlide.setList(cmsList);
					cmsImage.setUrl(BG_Image);
				}

				cmsSlide.setId(Integer.parseInt(slide_id));
				cmsSlide.setFragmentCount(0);
				cmsSlide.setAudioUrl("none");
				//
				if(color_code!=null && !color_code.equalsIgnoreCase("")){
				cmsSlide.setBackground(color_code);
				}else{
					cmsSlide.setBackground("#ffffff");
				}
				cmsSlide.setBackgroundTransition("slide");
				cmsSlide.setImage_BG("none");
				cmsSlide.setTemplateName(template_type);
				cmsSlide.setTransition("slide");
				cmsSlide.setTitle(cmsTitle);
				cmsSlide.setTitle2(cmsTitle2);
				cmsSlide.setTeacherNotes("Not Available");
				cmsSlide.setStudentNotes("Not Available");
				cmsSlide.setOrder_id(++order_id);
				cmsSlide.setSlideDuration(0);

				cmsSlide.setImage(cmsImage);

				if (template_type.equalsIgnoreCase("NO_CONTENT")) {
					cmsSlide.setImage_BG(BG_Image);
					cmsImage.setUrl(null);
				}
				
				if (template_type.equalsIgnoreCase("ONLY_VIDEO")) {
					CMSVideo cmsVideo = new CMSVideo();
					cmsVideo.setUrl(BG_Image);
					cmsSlide.setVideo(cmsVideo);
					cmsImage.setUrl(null);
				}

				if (template_type.equalsIgnoreCase("ONLY_VIDEO") || template_type.equalsIgnoreCase("NO_CONTENT") || template_type.equalsIgnoreCase("ONLY_TITLE") || template_type.equalsIgnoreCase("ONLY_IMAGE")) {
					cmsSlide.setFragmentCount(0);

				}
				if (template_type.equalsIgnoreCase("ONLY_2TITLE") || template_type.equalsIgnoreCase("ONLY_2BOX") || template_type.equalsIgnoreCase("ONLY_TITLE_IMAGE")) {
					cmsSlide.setFragmentCount(1);

				}
				if (template_type.equalsIgnoreCase("ONLY_2TITLE_IMAGE")) {
					cmsSlide.setFragmentCount(2);
				}

				cmsSlideList.add(cmsSlide);

				cmsLesson.setSlides(cmsSlideList);
			}

			return cmsLesson;

		} catch (JAXBException e) {
			e.printStackTrace();
		}
		return null;
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
