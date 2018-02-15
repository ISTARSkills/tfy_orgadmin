package com.viksitpro.cms.utilities;

import java.io.IOException;
import java.util.Properties;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletResponse;

import com.viksitpro.upload.controllers.MediaUploadController;

public class ImageFilter implements Filter {
	public void init(FilterConfig arg0) throws ServletException {
	}

	public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {

		/*
		 * ViksitLogger.logMSG(this.getClass().getName(),(((HttpServletRequest)req).getRequestURL().toString
		 * ()); String url =
		 * ((HttpServletRequest)req).getRequestURL().toString();
		 * ViksitLogger.logMSG(this.getClass().getName(),(url.lastIndexOf("/")); String url2 =
		 * url.substring(url.lastIndexOf("/")+1); ViksitLogger.logMSG(this.getClass().getName(),(url2);
		 * ((HttpServletResponse)resp).sendRedirect(
		 * "http://cdn.talentify.in/course_images/"+url2);
		 */

		HttpServletResponse response = (HttpServletResponse) resp;
		JSPResponseWrapper jspResponseWrapper = new JSPResponseWrapper(response);
		chain.doFilter(req, jspResponseWrapper);
		if (resp.getContentType() != null && resp.getContentType().contains("text/html")) {
			String content = jspResponseWrapper.getCaptureAsString();
			Properties prop = new Properties();
			String path = "";
			try {
				prop.load(MediaUploadController.class.getClassLoader().getResourceAsStream("app.properties"));
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			path = prop.getProperty("media_url_path");
			// replace stuff here
			/*
			 * String replacedContent = "";
			 * 
			 * replacedContent = content.replaceAll( "/course_images", path +
			 * "course_images").replaceAll("http://cdn.talentify.in:9999//",
			 * "/"); if(content.contains("lessonXMLs") &&
			 * !content.contains("http")) { replacedContent =
			 * content.replaceAll( "/lessonXMLs", path + "lessonXMLs"); }
			 */

			String replacedContent = content.replaceAll("/course_images", path + "course_images").replaceAll("http://192.168.1.12:8080//", "/").replaceAll("http://cdn.talentify.in:9999//", "/").replaceAll("/lessonXMLs", path + "lessonXMLs");

			// ViksitLogger.logMSG(this.getClass().getName(),replacedContent);

			response.getWriter().write(replacedContent);
		}

	}

	public void destroy() {
	}
}
