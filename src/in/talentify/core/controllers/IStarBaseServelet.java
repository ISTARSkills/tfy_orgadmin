/**
 * 
 */
package in.talentify.core.controllers;

import java.util.Enumeration;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;

/**
 * @author Vaibhav verma
 *
 */
public class IStarBaseServelet extends HttpServlet {

	
	public void printparams(HttpServletRequest request){
		Enumeration headerNames = request.getHeaderNames();
		while(headerNames.hasMoreElements()) {
		  String headerName = (String)headerNames.nextElement();
		  //System.out.println("Header Name - " + headerName + ", Value - " + request.getHeader(headerName));
		}
		
		Enumeration params = request.getParameterNames(); 
		while(params.hasMoreElements()){
		 String paramName = (String)params.nextElement();
		 //System.out.println("Parameter Name - "+paramName+", Value - "+request.getParameter(paramName));
		}

	}
}
