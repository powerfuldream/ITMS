package org.south.netty;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

/**
 * @author jan
 * @date 2017年11月29日 上午1:02:25
 * @version V1.0
 */

public class FileToServer {

	public static final String driver = "com.mysql.jdbc.Driver";

	public static final String url = "jdbc:mysql://127.0.0.1:3306/terminal_manage1?useUnicode=true&characterEncoding=utf-8&useSSL=false";

	public static final String user = "root";

	public static final String password = "a123456";

	private List<String> list = new ArrayList<String>();

	public FileToServer() {
		translateFile();
		copyFile();
	}

	public void copyFile() {
		Calendar ca = Calendar.getInstance();
		String year = "" + ca.get(Calendar.YEAR);
		String path = "D:/filesystem/" + year;
		String sc = "D:/apache-tomcat-8.5.15/webapps/ITMS/";
		System.out.println(sc);
		String rootPath = sc + "media/";
		System.out.println(rootPath);
//		FileUtil.fileCopy(path, rootPath);
	}

	public void translateFile() {
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
			String sql = "select * from files";
			rs = statement.executeQuery(sql);
			while (rs.next()) {
				// 输出结果
				String fileName = getFileName(rs.getString(3));
				System.out.println(fileName);
				list.add(fileName);
			}
			System.out.println(list);
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

	public String getFileName(String str) {
		String[] s = str.split("/");
		return s[s.length - 1];
	}
}
