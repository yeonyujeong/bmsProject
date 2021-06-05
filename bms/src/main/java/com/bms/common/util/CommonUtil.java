package com.bms.common.util;

import java.text.DecimalFormat;
import java.util.Calendar;

import org.springframework.stereotype.Component;

@Component
public class CommonUtil  {
	
	public String calcSearchPeriod(String fixedSearchPeriod) {
		
		String beginDate  = "";
		String endDate    = "";
		String endYear    = "";
		String endMonth   = "";
		String endDay     = "";
		String beginYear  = "";
		String beginMonth = "";
		String beginDay   = "";
		
		DecimalFormat df = new DecimalFormat("00");
		Calendar cal = Calendar.getInstance();
		
		endYear   = Integer.toString(cal.get(Calendar.YEAR));
		endMonth  = df.format(cal.get(Calendar.MONTH) + 1);
		endDay    = df.format(cal.get(Calendar.DATE));
		endDate   = endYear + "-" + endMonth + "-" + endDay;
		
		if 		(fixedSearchPeriod == null) 				cal.add(cal.MONTH,-4);	
		else if (fixedSearchPeriod.equals("one_week")) 		cal.add(Calendar.DAY_OF_YEAR, -7);	
		else if (fixedSearchPeriod.equals("two_week")) 		cal.add(Calendar.DAY_OF_YEAR, -14);
		else if (fixedSearchPeriod.equals("one_month")) 	cal.add(cal.MONTH,-1);
		else if (fixedSearchPeriod.equals("two_month")) 	cal.add(cal.MONTH,-2);
		else if (fixedSearchPeriod.equals("three_month")) 	cal.add(cal.MONTH,-3);
		else if (fixedSearchPeriod.equals("four_month")) 	cal.add(cal.MONTH,-4);
		
		beginYear   = Integer.toString(cal.get(Calendar.YEAR));
		beginMonth  = df.format(cal.get(Calendar.MONTH) + 1);
		beginDay    = df.format(cal.get(Calendar.DATE));
		beginDate   = beginYear + "-" + beginMonth + "-" + beginDay;
		
		return beginDate + "," + endDate;
		
	}
	
}
