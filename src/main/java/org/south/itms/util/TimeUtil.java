package org.south.itms.util;

import java.sql.Time;
import java.text.ParseException;
import java.text.*;
import java.util.Date;
import java.util.Calendar;


/**
 * @author jan
 * @date 2017年11月23日 下午3:15:12
 * @version V1.0 
 */
public class TimeUtil {

	public static Date translateDate(String dataStr) throws ParseException {
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		return df.parse(dataStr);
	}
	
	public static Time translateTime(String timeStr) throws ParseException {
		SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");
		Date date = format.parse(timeStr);
		return new Time(date.getTime());
	}
	
	public static boolean timeValidate(Time start, Time end) {
		if(start.before(end)) {
			return true;
		}else {
			return false;
		}
	}
	
	public static boolean dateValidate(Date start, Date end) throws ParseException {
		String s = new SimpleDateFormat("yyyy-MM-dd").format(start);
		String e = new SimpleDateFormat("yyyy-MM-dd").format(end);
		if(s.equals(e)) {
			return true;
		}
		if(start.before(end)) {
			return true;
		}else {
			return false;
		}
	}
	
	public static String getPastDate(int past) {
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) + past);
		Date today = calendar.getTime();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		String result = format.format(today);
		return result;
	}
	
	public boolean checkDate(String startTime, String endTime) throws ParseException {
		java.util.Calendar cal=java.util.Calendar.getInstance();
		cal.setTime(new Date());
		cal.add(Calendar.DATE,1);
		Date nextDate=cal.getTime();
		String nextDateStr = new SimpleDateFormat("yyyy-MM-dd").format(nextDate);
		Date d1 = new SimpleDateFormat("yyyy-MM-dd").parse(startTime);
		Date d2 = new SimpleDateFormat("yyyy-MM-dd").parse(endTime);
//		Calendar c1 = Calendar.getInstance();
//		Calendar c2 = Calendar.getInstance();
//		Calendar c3 = Calendar.getInstance();
//		c1.setTime(nextDate);
//		c2.setTime(d1);
//		c3.setTime(d2);
//		int result1 = c1.compareTo(c2);
//		int result2 = c1.compareTo(c3);
		if(nextDateStr.equals(startTime) || nextDateStr.equals(endTime)) {
			return true;
		}
		if (nextDate.after(d1) && nextDate.before(d2)) {
			return true;
		}
		return false;
	}
	
	public static boolean checkTime(String startDate, String endDate) {
		if(startDate.equals(endDate)) {
			return true;
		}
		Date d1 = null;
		try {
			d1 = new SimpleDateFormat("yyyy-MM-dd").parse(startDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		Date d2 = null;
		try {
			d2 = new SimpleDateFormat("yyyy-MM-dd").parse(endDate);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		if(d1.before(d2)) {
			return true;
		}else {
			return false;
		}
	}
	
	public static boolean checkDate(int i, Date startTime, Date endTime) throws ParseException {
		SimpleDateFormat f = new SimpleDateFormat("yyyy-MM-dd");
		//System.out.println(startTime + " =" + endTime);
		String start = f.format(startTime);
		//System.out.println("start=" + start);
		String end = f.format(endTime);
		String time = TimeUtil.getPastDate(i);
		//System.out.println("time=" + time);
		Date timeDate = f.parse(time);
		if(time.equals(start) || time.equals(end)) {
			return true;
		}
		if(timeDate.after(startTime) && timeDate.before(endTime)) {
			return true;
		}
		return false;
	}
	
	public static void main(String[] args) throws ParseException {
		//System.out.println(TimeUtil.translateDate(""));
		String startTime = "2017-11-25";
		String endTime = "2017-11-25";
		Date d1 = TimeUtil.translateDate(startTime);
		Date d2 = TimeUtil.translateDate(endTime);
		System.out.println(d1 + "=" + d2);
		System.out.println(TimeUtil.dateValidate(d1,d2));
		String time = TimeUtil.getPastDate(10);
		System.out.println(time);
	}

}
