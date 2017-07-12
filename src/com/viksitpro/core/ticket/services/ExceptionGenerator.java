/**
 * 
 */
package com.viksitpro.core.ticket.services;

import java.util.HashMap;
import java.util.List;

import com.viksitpro.core.utilities.DBUTILS;

import in.talentify.core.utils.CMSRegistry;

/**
 * @author ISTAR-SKILL
 *
 */
public class ExceptionGenerator {

	public void generateExceptions()
	{
		for(TicketException ticketException : CMSRegistry.exceptionList.getTicketExceptions())
		{
			switch(ticketException.getType())
			{
				case "ATTENDANCE":
				raiseAttenndaceException(ticketException);
				break;
				default :
					break;
			}
		}
	}

	private void raiseAttenndaceException(TicketException ticketException) {
		DBUTILS utils = new DBUTILS();
	
		String defaulterQuery = ticketException.getDefaulterItemQuery();
		List<HashMap<String, Object>> defaulterItems = utils.executeQuery(defaulterQuery);
		
		for(HashMap<String, Object> defaulterRow : defaulterItems)
		{
			for(ExceptionParam param :ticketException.getParams())
			{
				String paramName = param.getName();
				String paramtype = param.getType();
				String expectation = param.getExpectation();
				
				if(paramtype.equalsIgnoreCase("integer"))
				{
					int ouputFromQuery = (int)defaulterRow.get(paramName);
					if(ouputFromQuery<Integer.parseInt(expectation))
					{
						int defaulterItemId = (int)defaulterRow.get("item_id");
						
						String getPrimaryReceiver = ticketException.getPrimaryReceiverQuery();
						
					}
				}
				
			}
			
			
		}
	}
}
