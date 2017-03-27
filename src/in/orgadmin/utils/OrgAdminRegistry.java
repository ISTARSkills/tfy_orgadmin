/**
 * 
 */
package in.orgadmin.utils;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import in.orgadmin.utils.report.ReportCollection;

/**
 * @author Mayank
 *
 */
public class OrgAdminRegistry {
	public static ReportCollection reportCollection;

	static {

		try {
			// req.getServletContext().getRealPath("/WEB-INF/fileName.properties")
			URL url = (new OrgAdminRegistry()).getClass().getClassLoader().getResource("/report_list.xml");
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
	}

}
