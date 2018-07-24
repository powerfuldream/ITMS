package org.south.netty;

import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.TimerTask;

import com.mysql.jdbc.PreparedStatement;


/**
 * @author jan
 * @date 2017年11月23日 上午10:51:48
 * @version V1.0 
 */
public class PlayTableTask extends TimerTask {
	
	
    public static String driver;
	
	public static String url;
	
	public static String user;
	
	public static String password;
	
	List<TmpFile> listFile = new ArrayList<TmpFile>();
	Set<String> setTerminal = new HashSet<String>();
	Set<String> setPeriod = new HashSet<String>();
	List<AutoPlayTable> listTable = new ArrayList<AutoPlayTable>();
	
	public PlayTableTask() {
		try{  
		    //获得当前类的绝对路径
		    //replaceAll("%20", "")这个替换是因为据说getPath()读取时会把空格读取为“%20”
		    String webPath = this.getClass().getResource("/").getPath().replaceAll("%20", " "); 
		    //截取字符串得到WEB-INF路径然后拼接
		    String path = webPath + "config.properties";
		    
		    Properties properties = new Properties();
		    properties.load(new FileInputStream(path));
		    //properties.load(new FileInputStream("/ITMS/WEB-INF/classes/config.properties"));
		    //获得属性文件中的username,password,driver,url
		    user = properties.getProperty("jdbc.username");
		    url = properties.getProperty("jdbc.url");
		    password = properties.getProperty("jdbc.password");
		    driver = properties.getProperty("jdbc.driver");
		}catch(Exception e){  
		    e.printStackTrace();
		} 
	}
	
	public void run() {
        System.out.println("我有一头小毛驴!");
//        updatePeriodTable();
//        String sc = "D:/apache-tomcat-8.5.15/webapps/ITMS/"; 
//		System.out.println(sc);
//		String rootPath = sc + "media/";
//		System.out.println(rootPath);
//		getFileMessage();
//		try {
//			generateTable();
//		} catch (ParseException e) {
//			e.printStackTrace();
//		}
    }
	
	public void updatePeriodTable() {
		try {
			// 加载驱动程序
			Class.forName(driver);
			// 连续数据库
			Connection conn = DriverManager.getConnection(url, user, password);
			if (!conn.isClosed())
				System.out.println("Succeeded connecting to the Database!");
			// statement用来执行SQL语句
			//Statement statement = conn.createStatement();
			PreparedStatement stmt = (PreparedStatement) conn.prepareStatement(
				      "update period set status = 0 where deleted = 0");
				stmt.executeUpdate();
			conn.close();
		} catch (ClassNotFoundException e) {
			System.out.println("Sorry,can`t find the Driver!");
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void getFileMessage() {
		TmpFile file = null;
		try {
			// 加载驱动程序
			Class.forName(driver);
			// 连续数据库
			Connection conn = DriverManager.getConnection(url, user, password);
			if (!conn.isClosed())
				System.out.println("Succeeded connecting to the Database!");
			// statement用来执行SQL语句
			Statement statement = conn.createStatement();
			ResultSet rs = null;
			String sql = "select mid, period_id, terminal_id, frequency, start_time, end_time, duration from material where deleted = 0 and status_id = 3";
			rs = statement.executeQuery(sql);
			while (rs.next()) {
				// 输出结果
				if("".equals(rs.getString(4)) || rs.getString(2) == null || rs.getString(3) == null || rs.getString(4) == null || rs.getString(5) == null || rs.getString(6) == null) {
					
				}else {
					file = new TmpFile();
					file.setFileId(Integer.parseInt(rs.getString(1)));
					file.setPeriodId(Integer.parseInt(rs.getString(2)));
					file.setTerminalId(Integer.parseInt(rs.getString(3)));
					file.setFrequency(Integer.parseInt(rs.getString(4)));
					file.setStartTime(rs.getString(5));
					file.setEndTime(rs.getString(6));
					file.setDuration(Integer.parseInt(rs.getString(7)));
					listFile.add(file);
					setTerminal.add(rs.getString(3));
					setPeriod.add(rs.getString(2));
				}
			}
			rs.close();
			conn.close();
		} catch (ClassNotFoundException e) {
			System.out.println("Sorry,can`t find the Driver!");
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void getTableFileMessage(String periodId) {
		TmpFile file = null;
		try {
			// 加载驱动程序
			Class.forName(driver);
			// 连续数据库
			Connection conn = DriverManager.getConnection(url, user, password);
			if (!conn.isClosed())
				System.out.println("Succeeded connecting to the Database!");
			// statement用来执行SQL语句
			Statement statement = conn.createStatement();
			ResultSet rs = null;
			String sql = "select i.mid, i.period_id, i.terminal_id, i.frequency, i.start_date, i.end_date, i.duration from items i left join material m on i.mid = m.mid where m.deleted = 0 and i.deleted = 0 and i.period_id = " + periodId;
			rs = statement.executeQuery(sql);
			while (rs.next()) {
				// 输出结果
				if("".equals(rs.getString(4)) || rs.getString(2) == null || rs.getString(3) == null || rs.getString(4) == null || rs.getString(5) == null || rs.getString(6) == null) {
					
				}else {
					file = new TmpFile();
					file.setFileId(Integer.parseInt(rs.getString(1)));
					file.setPeriodId(Integer.parseInt(rs.getString(2)));
					file.setTerminalId(Integer.parseInt(rs.getString(3)));
					file.setFrequency(Integer.parseInt(rs.getString(4)));
					file.setStartTime(rs.getString(5));
					file.setEndTime(rs.getString(6));
					file.setDuration(Integer.parseInt(rs.getString(7)));
					listFile.add(file);
					setTerminal.add(rs.getString(3));
					setPeriod.add(rs.getString(2));
				}
			}
			rs.close();
			conn.close();
		} catch (ClassNotFoundException e) {
			System.out.println("Sorry,can`t find the Driver!");
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void generateOneTable(String terminalId, String periodId, String uid) throws ParseException {
		getTableFileMessage(periodId);
		getPlayTable(terminalId, periodId, 1);
		System.out.println(listFile);
		for(AutoPlayTable a : listTable) {
			System.out.println(a);
		}
		TableAutoGenerate tag = new TableAutoGenerate();
		tag.PlayTableGenerate(listTable, uid);
	}
	
	//一个终端时段生成多天播表
	public void generateTb(String terminalId, String periodId, String uid, int start, int length) throws ParseException {
		getTableFileMessage(periodId);
		System.out.println("listFile==" + listFile);
		if("".equals(periodId)) {
			
		}else {
			TableAutoGenerate t = new TableAutoGenerate();
			t.deleteNewPlayTb(Integer.parseInt(periodId), start, length);
		}
		for(int i = start; i <= length; i++) {
			List<AutoPlayTable> listNull = new ArrayList<AutoPlayTable>();
			listTable = listNull;
			getPlayTable(terminalId, periodId, i);
			System.out.println("listTable---" + listTable);
			TableAutoGenerate tag = new TableAutoGenerate();
			tag.PlayTableGenerate(listTable, uid, i);
		}
		System.out.println(listFile);
//		for(AutoPlayTable a : listTable) {
//			System.out.println(a);
//		}
	}
	
	//一个终端时段生成多天播表
	public void generateManyTable(String terminalId, String periodId, String uid, int length) throws ParseException {
		getTableFileMessage(periodId);
		System.out.println("listFile==" + listFile);
		if("".equals(periodId)) {
			
		}else {
			TableAutoGenerate t = new TableAutoGenerate();
			//t.deleteNewPlayTable(Integer.parseInt(periodId));
		}
		for(int i = 0; i <= length; i++) {
			List<AutoPlayTable> listNull = new ArrayList<AutoPlayTable>();
			listTable = listNull;
			getPlayTable(terminalId, periodId, i);
			System.out.println("listTable---" + listTable);
			TableAutoGenerate tag = new TableAutoGenerate();
			tag.PlayTableGenerate(listTable, uid, i);
		}
		System.out.println(listFile);
//		for(AutoPlayTable a : listTable) {
//			System.out.println(a);
//		}
	}
	
	public void generateTable() throws ParseException {
		for(String s : setTerminal) {
			for(String t : setPeriod) {
				getPlayTable(s, t, 1);
			}
		}
		System.out.println(listFile);
		for(AutoPlayTable a : listTable) {
			System.out.println(a);
		}
		TableAutoGenerate tag = new TableAutoGenerate();
		tag.PlayTableGenerate(listTable);
	}
	
	public void getPlayTable(String terminalId, String periodId, int len) throws ParseException {
		Ad ad = null;
		List<Ad> listA = new ArrayList<Ad>();
		int tId = Integer.parseInt(terminalId);
		int pId = Integer.parseInt(periodId);
		for(TmpFile f : listFile) {
			if(f.getPeriodId() == pId && f.getTerminalId() == tId) {
				if(checkDate(f.getStartTime(), f.getEndTime(), len)) {
					ad = new Ad();				
					ad.setFileId(f.getFileId());
					ad.setAdName("" + f.getFileId());
					ad.setFreq(f.getFrequency());
					ad.setDuration(f.getDuration());
					listA.add(ad);
				}
			}
		}
		AutoPlayTable table = new AutoPlayTable();
		table.setListAd(listA);
		table.setPeriodId(pId);
		table.setTerminalId(tId);
		listTable.add(table);
	}
	
	public boolean checkDate(String startTime, String endTime, int len) throws ParseException {
		java.util.Calendar cal=java.util.Calendar.getInstance();
		cal.setTime(new Date());
		cal.add(Calendar.DATE,len);
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
	
	public static void main(String[] args) throws ParseException {
		PlayTableTask ps = new PlayTableTask();
		ps.updatePeriodTable();
//		ps.getFileMessage();
//		System.out.println(ps.setPeriod.size());
//		ps.generateTable();
	}
}
