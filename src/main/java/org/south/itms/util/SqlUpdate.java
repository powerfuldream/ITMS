package org.south.itms.util;

import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import org.south.itms.entity.IPTable;
import org.south.itms.entity.Material;
import org.south.itms.entity.PlayTable;
import org.south.netty.NettyChannelMap;
import org.south.netty.msg.DataKey;
import org.south.netty.msg.InsertDto;
import org.south.netty.msg.MsgType;
import org.south.netty.msg.ResultMsg;

import com.mysql.jdbc.PreparedStatement;

/**
 * @author jan
 * @date 2017年12月5日 下午3:33:00
 * @version V1.0 
 */
public class SqlUpdate {
	
	private static String driver;
	
	private static String url;
	
	private static String user;
	
	private static String password;
	
	public SqlUpdate() {
		try{  
		    //获得当前类的绝对路径
		    //replaceAll("%20", "")这个替换是因为据说getPath()读取时会把空格读取为“%20”
		    String webPath = this.getClass().getResource("/").getPath()
		                                                 .replaceAll("%20", ""); 
		    //截取字符串得到WEB-INF路径然后拼接
		    System.out.println("webPath=" + webPath);
		    //webPath = webPath.substring(0, webPath.indexOf("WEB-INF"));
		    String path = webPath + "config.properties";
		    System.out.println(path);
		    Properties properties = new Properties();  
		    properties.load(new FileInputStream(path));  
		    //获得属性文件中的username,password,driver,url
		    user = properties.getProperty("jdbc.username");
		    url = properties.getProperty("jdbc.url");
		    password = properties.getProperty("jdbc.password");
		    driver = properties.getProperty("jdbc.driver");
		    System.out.println(user);
		    System.out.println(url);
		    System.out.println(password);
		    System.out.println(driver);
		}catch(Exception e){  
		    e.printStackTrace();
		} 
	}
	
	public void updateFile(String pid, String[] nums) {
		try {
			// 加载驱动程序
			Class.forName(driver);
			// 连续数据库
			Connection conn = DriverManager.getConnection(url, user, password);
			if (!conn.isClosed())
				System.out.println("Succeeded connecting to the Database!");
			
			for(int i = 1; i <= nums.length; i++) {
				String hql = "update ptable_file set mid=" + nums[i - 1] +  " where pid=" + pid + " and num=" + i + " and deleted=0";
				Statement statement = conn.createStatement();
				statement.executeUpdate(hql);
			}
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
	
	public void saveInsertTable(IPTable insert) {
		System.out.println(insert);
		try {
			// 加载驱动程序
			Class.forName(driver);
			// 连续数据库
			Connection conn = DriverManager.getConnection(url, user, password);
			if (!conn.isClosed())
				System.out.println("Succeeded connecting to the Database!");
			
			String sql = "insert into ps_table (insert_date, start_time, end_time, min, mid, terminal_id, create_name, create_time, deleted, material_name, status) values (?,?,?,?,?,?,?,?,?,?,?)";
			PreparedStatement statement = (PreparedStatement) conn.prepareStatement(sql);
			java.sql.Date d = new java.sql.Date(insert.getInsertDate().getTime());
			statement.setDate(1, d);
			statement.setTime(2, insert.getStartTime());
			statement.setTime(3, insert.getEndTime());
			statement.setInt(4, insert.getMin());
			statement.setString(5, insert.getMid());
			statement.setString(6, insert.getTerminalId());
			statement.setString(7, insert.getCreateName());
			statement.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
			statement.setInt(9, 0);
			statement.setString(10, insert.getMaterialName());
			statement.setInt(11, insert.getStatus());
			statement.executeUpdate();
			
			System.out.println("channel=" + NettyChannelMap.get(insert.getTerminalId()));
			System.out.println("=" + (new Date()).equals(insert.getInsertDate()));
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			String now = df.format(new Date());
			String setDate = df.format(insert.getInsertDate());
			System.out.println(now + "=" + setDate);
			boolean dateCheck = now.equals(setDate);
			if(dateCheck && NettyChannelMap.get(insert.getTerminalId()) != null) {
				//插播到客户端
				System.out.println(111);
				ResultMsg resultMsg = new ResultMsg(true, MsgType.InsertMaterial);
				Map<String, Object> data = new HashMap<String, Object>();
				List<InsertDto> insertDto = new ArrayList<InsertDto>();
				int mid1 = Integer.parseInt(insert.getMid());
				String sql1 = "select file_path, md5, duration from material where mid = " + mid1 + " and deleted = 0";
				Statement statement1 = conn.createStatement();
				ResultSet rs = statement1.executeQuery(sql1);
				String filePath = "";
				if(rs.next()) {
					filePath = rs.getString(1);
					String[] insertFileName = filePath.split("/");
		        	InsertDto dto = new InsertDto();
		        	SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");
		        	dto.setEnd(format.format(insert.getEndTime()));
		        	dto.setStart(format.format(insert.getStartTime()));
		        	dto.setStatus("" + insert.getStatus());
		        	dto.setMin("" + insert.getMin());
		        	//dto.setMid(insert.getMid());
		        	//dto.setFileName(insertFileName[insertFileName.length - 1]);
//		        	dto.setLogicName(insert.getMaterialName());
//		        	dto.setMd5(rs.getString("md5"));
		        	dto.setDuration(rs.getString("duration"));
		        	insertDto.add(dto);
		        	data.put(DataKey.insertfiles, insertDto);
		        	resultMsg.setData(data);
		        	System.out.println("resultMsg=" + resultMsg);
					NettyChannelMap.get(insert.getTerminalId()).writeAndFlush(resultMsg);
				}
			}
			
			conn.close();
		} catch (ClassNotFoundException e) {
			System.out.println("Sorry,can`t find the Driver!");
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			
		}
	}
	
	public static void main(String[] args) throws ParseException {
		SqlUpdate su = new SqlUpdate();
		IPTable insert = new IPTable();
		insert.setCreateName("admin");
		insert.setDeleted(0);
		insert.setMid("101");
		insert.setMin(2);
		insert.setTerminalId("5");
		String start = "00:00:00";
		String end = "00:00:00";
		java.sql.Time startTime = TimeUtil.translateTime(start);
		java.sql.Time endTime = TimeUtil.translateTime(end);
		insert.setEndTime(endTime);
		insert.setStartTime(startTime);
		System.out.println(insert);
		su.saveInsertTable(insert);
	}

	public Set<String> getMidById(String pid) {
		Set<String> set = new HashSet<String>();
		try {
			// 加载驱动程序
			Class.forName(driver);
			// 连续数据库
			Connection conn = DriverManager.getConnection(url, user, password);
			if (!conn.isClosed())
				System.out.println("Succeeded connecting to the Database!");
			String sql = "select mid from ptable_file where pid = " + pid + " and deleted = 0";
			Statement statement1 = conn.createStatement();
			ResultSet rs = statement1.executeQuery(sql);
			while(rs.next()) {
				set.add(rs.getString(1));
			}
			conn.close();
		} catch (ClassNotFoundException e) {
			System.out.println("Sorry,can`t find the Driver!");
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return set;
	}

	public void updateResource(String roleId, String authorityList) {
		int id = Integer.parseInt(roleId);
		try {
			// 加载驱动程序
			Class.forName(driver);
			// 连续数据库
			Connection conn = DriverManager.getConnection(url, user, password);
			if (!conn.isClosed())
				System.out.println("Succeeded connecting to the Database!");
			String sql = "delete from role_resource where role_id = " + roleId + " and deleted = 0";
			Statement statement = conn.createStatement();
			statement.executeUpdate(sql);
			
			String[] resourceIds = authorityList.split(",");
			for(int i = 0 ; i < resourceIds.length; i++) {
				String sqlTmp = "insert into role_resource (resource_id, role_id, deleted) values (?,?,?)";
				PreparedStatement statementTmp = (PreparedStatement) conn.prepareStatement(sqlTmp);
				statementTmp.setInt(1, Integer.parseInt(resourceIds[i]));
				statementTmp.setInt(2, Integer.parseInt(roleId));
				statementTmp.setInt(3, 0);
				statementTmp.executeUpdate();
			}
			
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

	public void savePtableFile(PlayTable ptable, String mid, List<Material> listM) {
		try {
			// 加载驱动程序
			Class.forName(driver);
			// 连续数据库
			Connection conn = DriverManager.getConnection(url, user, password);
			if (!conn.isClosed())
				System.out.println("Succeeded connecting to the Database!");
//			String sql = "delete from role_resource where role_id = " + roleId + " and deleted = 0";
//			Statement statement = conn.createStatement();
//			statement.executeUpdate(sql);
			
			String insertSql = "INSERT INTO play_table"+
                    "(user_id, terminal_id, status_id, play_date, ptable_name, start_time, end_time, min, insert_flag, state, create_time, deleted)"+
                    "values(?,?,?,?,?,?,?,?,?,?,?,?)";
			PreparedStatement statement = (PreparedStatement) conn.prepareStatement(insertSql);
			statement.setInt(1, Integer.parseInt(ptable.getUserId()));
			statement.setInt(2, Integer.parseInt(ptable.getTerminalId()));
			statement.setInt(3, Integer.parseInt(ptable.getStatusId()));
			statement.setDate(4, new java.sql.Date(ptable.getPlayDate().getTime()));
			statement.setString(5, ptable.getPtableName());
			statement.setTime(6, ptable.getStartTime());
			statement.setTime(7, ptable.getEndTime());
			statement.setInt(8, ptable.getMin());
			statement.setInt(9, ptable.getInsertFlag());
			statement.setInt(10, ptable.getState());
			statement.setTimestamp(11, new Timestamp(System.currentTimeMillis()));
			statement.setInt(12, 0);
			int count = statement.executeUpdate();
			
			/*
			//因为插播也要二次审核
			System.out.println("channel=" + NettyChannelMap.get(ptable.getTerminalId()));
			System.out.println("=" + (new Date()).equals(ptable.getPlayDate()));
			SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
			SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");
			String now = df.format(new Date());
			String setDate = df.format(ptable.getPlayDate());
			System.out.println(now + "=" + setDate);
			boolean dateCheck = now.equals(setDate);
			if(dateCheck && NettyChannelMap.get(ptable.getTerminalId()) != null) {
				ResultMsg resultMsg = new ResultMsg(true, MsgType.InsertMaterial);
				Map<String, Object> data = new HashMap<String, Object>();
				List<InsertDto> insertDto = new ArrayList<InsertDto>();
				List<String> midds = new ArrayList<String>();
				int sum = 0;
				List<String> fileName = new ArrayList<String>();
				for(Material m : listM) {
					midds.add(m.getMid());
        			String[] insertFileName = m.getFilePath().split("/");
        			fileName.add(insertFileName[insertFileName.length - 1]);
        			sum = sum + m.getDuration();
				}
				InsertDto dto = new InsertDto();
				dto.setEnd(format.format(ptable.getEndTime()));
            	dto.setStart(format.format(ptable.getStartTime()));
            	dto.setStatus("" + ptable.getState());
            	dto.setMin("" + ptable.getMin());
            	dto.setDuration("" + sum);
            	dto.setMid(midds);
            	dto.setFileName(fileName);
            	insertDto.add(dto);
            	data.put(DataKey.insertfiles, insertDto);
	        	resultMsg.setData(data);
	        	System.out.println("resultMsg=" + resultMsg);
				NettyChannelMap.get(ptable.getTerminalId()).writeAndFlush(resultMsg);
			}
			*/
			
			int pid = 0;
			Statement statement2 = conn.createStatement();
			ResultSet rs = null;
			String sql = "select pid from play_table where deleted = 0 and terminal_id = "
					+ Integer.parseInt(ptable.getTerminalId()) + " and  insert_flag = " + 1
					+ " and ptable_name = " + "\"" + ptable.getPtableName() + "\"";
			System.out.println(sql);
			rs = statement2.executeQuery(sql);
			while (rs.next()) {
				pid = Integer.parseInt(rs.getString(1));
			}
			
			String[] mids = mid.split(",");
			List<Integer> list = new ArrayList<Integer>();
			for(String s : mids) {
				String[] str = s.split("-");
				int len = Integer.parseInt(str[1]);
				if(len > 0) {
					for(int i = 0; i < len; i++) {
						list.add(Integer.parseInt(str[0]));
					}
				}
			}
			
			for(int i = 1; i <= list.size(); i++) {				
				// statement用来执行SQL语句
				String insertSql1 = "INSERT INTO ptable_file"+
						"(mid, pid, num, deleted)"+
						"values(?,?,?,?)";
				PreparedStatement statement1 = (PreparedStatement) conn.prepareStatement(insertSql1);
				System.out.println(insertSql1);
				statement1.setInt(1, list.get(i - 1));
				statement1.setInt(2, pid);
				statement1.setInt(3, i);
				statement1.setInt(4, 0);
				statement1.executeUpdate();
			
			}
			
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
	
	//7.15
	public void updateFilebydelAll(String pid, String[] nums) {
		try {
			// 加载驱动程序
			Class.forName(driver);
			// 连续数据库
			Connection conn = DriverManager.getConnection(url, user, password);
			if (!conn.isClosed())
				System.out.println("Succeeded connecting to the Database!");
			
			for(int i = 0; i < nums.length; i++) {
				int num=i+1;
				// statement用来执行SQL语句
				String insertSql = "INSERT INTO ptable_file"+
						"(mid, pid, num, deleted)"+
						"values(?,?,?,?)";
				PreparedStatement statement = (PreparedStatement) conn.prepareStatement(insertSql);
				System.out.println(insertSql);
				statement.setInt(1, Integer.parseInt(nums[i]));
				statement.setInt(2, Integer.parseInt(pid));
				statement.setInt(3, num);
				statement.setInt(4, 0);
				statement.executeUpdate();
			}
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
}
