package in.orgadmin.auth;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet Filter implementation class AuthenticationFilter
 */
@WebFilter("/*")
public class AuthenticationFilter implements Filter {

	/**
	 * Default constructor.
	 */
	public AuthenticationFilter() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		Boolean isStarticrequest = false;
		if (((HttpServletRequest) request).getRequestURL().toString().endsWith(".css")) {
			isStarticrequest = true;
		}
		if (((HttpServletRequest) request).getRequestURL().toString().endsWith(".js")) {
			isStarticrequest = true;
		}

		if (((HttpServletRequest) request).getRequestURL().toString().endsWith(".png")) {
			isStarticrequest = true;
		}

		if (((HttpServletRequest) request).getRequestURL().toString().endsWith(".gif")) {
			isStarticrequest = true;
		}
		if (((HttpServletRequest) request).getRequestURL().toString().endsWith(".jpg")) {
			isStarticrequest = true;
		}

		if (((HttpServletRequest) request).getRequestURL().toString().endsWith(".jpeg")) {
			isStarticrequest = true;
		}

		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("index.jsp")) {
			isStarticrequest = true;
		}
		
		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("signup.jsp")) {
			isStarticrequest = true;
		}
		
		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("user_signup")) {
			isStarticrequest = true;
		}
		
		if (((HttpServletRequest) request).getRequestURL().toString().contains("PinCodeController")) {
			isStarticrequest = true;
		}
		
		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("login.jsp")) {
			isStarticrequest = true;
		}

		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("forgot_password.jsp")) {
			isStarticrequest = true;
		}

		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("reset_password.jsp")) {
			isStarticrequest = true;
		}

		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("ttf")) {
			isStarticrequest = true;
		}

		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("woff")) {
			isStarticrequest = true;
		}

		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("woff2")) {
			isStarticrequest = true;
		}

		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("ico")) {
			isStarticrequest = true;
		}

		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("login")) {
			isStarticrequest = true;
		}

		if (((HttpServletRequest) request).getRequestURL().toString().contains("pdf")) {
			isStarticrequest = true;
		}

		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("map")) {
			isStarticrequest = true;
		}
		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("test.jsp")) {
			isStarticrequest = true;
		}
		if (((HttpServletRequest) request).getRequestURL().toString().contains("initializeInterview")) {
			//System.out.println(((HttpServletRequest) request).getRequestURL().toString());
			isStarticrequest = true;
		}
		if (((HttpServletRequest) request).getRequestURL().toString().endsWith("panelist.jsp")) {
			//System.out.println(((HttpServletRequest) request).getRequestURL().toString());
			isStarticrequest = true;
		}
		if (((HttpServletRequest) request).getRequestURL().toString().contains("sendInterviewFeedback")) {
			//System.out.println(((HttpServletRequest) request).getRequestURL().toString());
			isStarticrequest = true;
		}
		
		if (((HttpServletRequest) request).getRequestURL().toString().contains("student_signup_ui")) {
			//System.out.println(((HttpServletRequest) request).getRequestURL().toString());
			isStarticrequest = true;
		}
		
		if (((HttpServletRequest) request).getRequestURL().toString().contains("email_mobile_validator")) {
			//System.out.println(((HttpServletRequest) request).getRequestURL().toString());
			isStarticrequest = true;
		}
		if (((HttpServletRequest) request).getRequestURL().toString().contains("custom_task_factory")) {
			//System.out.println(((HttpServletRequest) request).getRequestURL().toString());
			isStarticrequest = true;
		}
		if (((HttpServletRequest) request).getRequestURL().toString().contains("fetch_custom_task")) {
			//System.out.println(((HttpServletRequest) request).getRequestURL().toString());
			isStarticrequest = true;
		}
		
		if (((HttpServletRequest) request).getRequestURL().toString().contains("get_admin_skill_graph")) {
			//System.out.println(((HttpServletRequest) request).getRequestURL().toString());
			isStarticrequest = true;
		}
		
		

		HttpSession session = ((HttpServletRequest) request).getSession(false);
		if (!isStarticrequest) {
			if ((session == null || session.getAttribute("user") == null)) {
				//System.out.println("The user is not logged in! Message from -> "
						//+ ((HttpServletRequest) request).getRequestURL().toString());
				((HttpServletResponse) response).sendRedirect("/index.jsp");
			} else {
				chain.doFilter(request, response);
			}
		} else {
			chain.doFilter(request, response);
		}
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
