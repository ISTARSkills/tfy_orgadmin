/**
 * 
 */
package in.talentify.core.utils;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import com.viksitpro.core.ticket.services.ExceptionList;

import in.orgadmin.utils.report.CustomReportList;
import in.orgadmin.utils.report.FilterCollection;
import in.orgadmin.utils.report.ReportCollection;

/**
 * @author verma6uc
 *
 */
public class CMSRegistry {

	public static ReportCollection reportCollection;
	public static FilterCollection filterCollection;
	public static CustomReportList customReportList;
	public static ExceptionList exceptionList;
	static{
		
		
		try {
			// req.getServletContext().getRealPath("/WEB-INF/fileName.properties")
			URL url = (new CMSRegistry()).getClass().getClassLoader().getResource("report_list.xml");
			File file = new File(url.toURI());
			JAXBContext jaxbContext = JAXBContext.newInstance(ReportCollection.class);

			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			reportCollection = (ReportCollection) jaxbUnmarshaller.unmarshal(file);
			

		} catch (JAXBException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			// req.getServletContext().getRealPath("/WEB-INF/fileName.properties")
			URL url = (new CMSRegistry()).getClass().getClassLoader().getResource("filter_list.xml");
			File file = new File(url.toURI());
			JAXBContext jaxbContext = JAXBContext.newInstance(FilterCollection.class);

			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			filterCollection = (FilterCollection) jaxbUnmarshaller.unmarshal(file);
			

		} catch (JAXBException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		try {
			// req.getServletContext().getRealPath("/WEB-INF/fileName.properties")
			URL url = (new CMSRegistry()).getClass().getClassLoader().getResource("custom_report_list.xml");
			File file = new File(url.toURI());
			JAXBContext jaxbContext = JAXBContext.newInstance(CustomReportList.class);
			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			customReportList = (CustomReportList) jaxbUnmarshaller.unmarshal(file);
			

		} catch (JAXBException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		try {
			// req.getServletContext().getRealPath("/WEB-INF/fileName.properties")
			URL url = (new CMSRegistry()).getClass().getClassLoader().getResource("exeception_notice_list.xml");
			File file = new File(url.toURI());
			JAXBContext jaxbContext = JAXBContext.newInstance(ExceptionList.class);

			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			exceptionList = (ExceptionList) jaxbUnmarshaller.unmarshal(file);
			

		} catch (JAXBException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	}
}
