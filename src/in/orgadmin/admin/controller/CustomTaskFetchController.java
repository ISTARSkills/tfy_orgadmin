package in.orgadmin.admin.controller;

import java.io.IOException;
import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import javax.xml.bind.Unmarshaller;

import com.viksitpro.core.customtask.TaskLibrary;
import com.viksitpro.core.customtask.TaskTemplate;
import com.viksitpro.core.dao.entities.Task;
import com.viksitpro.core.utilities.IStarBaseServelet;

/**
 * Servlet implementation class CustomTaskFetchController
 */
@WebServlet("/fetch_custom_task")
public class CustomTaskFetchController extends IStarBaseServelet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CustomTaskFetchController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		printParams(request);
		response.setContentType("text/xml;charset=iso-8859-1");
		response.addHeader("Content-Type", "text/xml");
		
		int task_id = Integer.parseInt(request.getParameter("task_id"));
		Task task = new TaskLibrary().getTaskTemplate(task_id);
		
		URL url = getClass().getClassLoader().getResource("task_libraray.xml");
		TaskTemplate taskTemplate=task.fetchTaskTemplate();
		try{
		
		
		
		JAXBContext jaxbContext = JAXBContext.newInstance(TaskTemplate.class);
		Marshaller jaxbMarshaller = jaxbContext.createMarshaller();
		jaxbMarshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);

		jaxbMarshaller.marshal(taskTemplate, response.getWriter());
		
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
