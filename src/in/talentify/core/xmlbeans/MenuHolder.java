/**
 * 
 */
package in.talentify.core.xmlbeans;

import java.io.File;
import java.net.URISyntaxException;
import java.net.URL;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

/**
 * @author Vaibhav verma
 *
 */
public class MenuHolder {
	private static Menu menu;

	public static Menu getMenu() {
		return menu;
	}

	public static void setMenu(Menu menu) {
		MenuHolder.menu = menu;
	}

	public static Menu generateMenu() {

		try {

			URL url = (new MenuHolder()).getClass().getClassLoader().getResource("menu.xml");
			File file = new File(url.toURI());
			JAXBContext jaxbContext = JAXBContext.newInstance(Menu.class);

			Unmarshaller jaxbUnmarshaller = jaxbContext.createUnmarshaller();
			MenuHolder.menu = (Menu) jaxbUnmarshaller.unmarshal(file);
			//System.out.println(menu);

		} catch (JAXBException e) {
			e.printStackTrace();
		} catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return menu;

	}
}
