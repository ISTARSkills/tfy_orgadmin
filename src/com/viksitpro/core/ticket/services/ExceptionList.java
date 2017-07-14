/**
 * 
 */
package com.viksitpro.core.ticket.services;

import java.util.ArrayList;


import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author mayank
 *
 */
@XmlRootElement(name = "exception_list")
public class ExceptionList {
	
	
	ArrayList<TicketException> ticketExceptions;

	@XmlElement(name = "ticket_exception", required = false)
	public ArrayList<TicketException> getTicketExceptions() {
		return ticketExceptions;
	}

	public void setTicketExceptions(ArrayList<TicketException> ticketExceptions) {
		this.ticketExceptions = ticketExceptions;
	}
	
	
	
	
	
	
}
