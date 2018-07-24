package org.south.itms.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.jdbc.Work;
import org.south.netty.msg.ClientLogMsg;
import org.south.netty.msg.ErrorLogMsg;
import org.south.netty.msg.PlayLogMsg;
import org.south.netty.msg.SysLogMsg;
import org.south.netty.msg.TransferLogMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository("logDao")
public class LogDaoImpl implements LogDao {

	@Autowired
	private SessionFactory sessionFactory;

	private Session getCurrentSession() {
		return this.sessionFactory.getCurrentSession();
	}

	private Session openSession() {
		return this.sessionFactory.openSession();
	}

	// 关闭Session
	private void closeSession(Session session) {
		if (null != session) {
			session.close();
		}
	}

	@Override  
	public void batchInsertLog(ClientLogMsg log) {
		Session sess = null;
		Transaction tx = null;
		try {
			sess = openSession();
			tx = sess.beginTransaction();
			// 执行Work对象指定的操作，即调用Work对象的execute()方法
			// Session会把当前使用的数据库连接传给execute()方法
			sess.doWork(new Work() {
				@Override
				public void execute(Connection conn) throws SQLException {// 需要注意的是，不需要调用close()方法关闭这个连接
					
					String sql = null;
					PreparedStatement ps = null;
					
					//写心跳日志
					if(log.getHeartRecordTime() != null) {
						sql = "insert into heartbeat_log(terminal_id, terminal_name, record_time, deleted) values(?,?,?,0)";
						ps = conn.prepareStatement(sql);
						ps.setString(1, log.getTerminalId());
						ps.setString(2, log.getTerminalName());
						ps.setString(3, log.getHeartRecordTime());
						ps.addBatch();
						ps.executeBatch();
					}
					
					
					
					//插入系统日志
					List<SysLogMsg> sysLogs = log.getSysLogs();
					if(sysLogs.size() > 0) {
					    sql = "insert into sys_log(terminal_id, terminal_name, log_content, record_date, locate_ip, deleted) values(?,?,?,?,?,0)";
					    ps = conn.prepareStatement(sql);
						
						for(int i = 0; i < sysLogs.size(); i++) {
							SysLogMsg sysLogMsg = sysLogs.get(i);
							ps.setString(1, log.getTerminalId());
							ps.setString(2, log.getTerminalName());
							ps.setString(3, sysLogMsg.getLogContent());
							ps.setString(4, sysLogMsg.getRecordDate());
							ps.setString(5, log.getLocateIp());
							ps.addBatch();
							if(i % 200 == 0) {
								ps.executeBatch();
								ps.clearBatch();
							}
						}
						ps.executeBatch();
					}
					
					
					//插入传输日志文件
					List<TransferLogMsg> transferLogs = log.getTransferLogs();
					if(transferLogs.size() > 0) {
					    sql = "insert into transfer_log(terminal_id, terminal_name, transfer_start_time, transfer_end_time, transfer_file_name, transfer_file_id, finished, note, pname, deleted) values(?,?,?,?,?,?,?,?,?,0)";
					    ps = conn.prepareStatement(sql);
						
						for(int i = 0; i < transferLogs.size(); i++) {
							TransferLogMsg transferLogMsg = transferLogs.get(i);
							ps.setString(1, log.getTerminalId());
							ps.setString(2, log.getTerminalName());
							ps.setString(3, transferLogMsg.getTransferStartTime());
							ps.setString(4, transferLogMsg.getTransferEndTime());
							ps.setString(5, transferLogMsg.getTransferFileName());
							ps.setString(6, transferLogMsg.getTransferFileId());
							if(transferLogMsg.getFinished() == 1) {
								ps.setString(7, "成功");
							} else {
								ps.setString(7, "失败");
							}
							ps.setString(8, transferLogMsg.getNote());
							ps.setString(9, transferLogMsg.getPname());
							
							ps.addBatch();
							if(i % 200 == 0) {
								ps.executeBatch();
								ps.clearBatch();
							}
						}
						ps.executeBatch();
					}
		
					
					//插入播放日志
					List<PlayLogMsg> playLogs = log.getPlayLogs();
					if(playLogs.size() > 0) {
					    sql = "insert into play_log(terminal_id, terminal_name, play_start_time, play_end_time, material_name, file_id, pname, pid, deleted) values(?,?,?,?,?,?,?,?,0)";
					    ps = conn.prepareStatement(sql);
						
						for(int i = 0; i < playLogs.size(); i++) {
							PlayLogMsg playLogMsg = playLogs.get(i);
							ps.setString(1, log.getTerminalId());
							ps.setString(2, log.getTerminalName());
							ps.setString(3, playLogMsg.getPlayStartTime());
							ps.setString(4, playLogMsg.getPlayEndTime());
							ps.setString(5, playLogMsg.getMaterialName());
							ps.setString(6, playLogMsg.getFileId());
							ps.setString(7, playLogMsg.getPname());
							ps.setString(8, playLogMsg.getPid());
							

							ps.addBatch();
							if(i % 200 == 0) {
								ps.executeBatch();
								ps.clearBatch();
							}
						}
						ps.executeBatch();
					}
					
					
					//插入传输错误日志
					List<ErrorLogMsg> errorLogs = log.getErrorLogs();
					if(errorLogs.size() > 0) {
					    sql = "insert into error_log(terminal_id, terminal_name, material_name, file_id, pname, pid, error_reason, record_date, deleted) values(?,?,?,?,?,?,?,?,0)";
					    ps = conn.prepareStatement(sql);
						
						for(int i = 0; i < errorLogs.size(); i++) {
							ErrorLogMsg errorLogMsg = errorLogs.get(i);
							ps.setString(1, log.getTerminalId());
							ps.setString(2, log.getTerminalName());
							ps.setString(3, errorLogMsg.getMaterialName());
							ps.setString(4, errorLogMsg.getFileId());
							ps.setString(5, errorLogMsg.getPname());
							ps.setString(6, errorLogMsg.getPid());
							ps.setString(7, errorLogMsg.getErrorReason());
							ps.setString(8, errorLogMsg.getRecordDate());

							ps.addBatch();
							if(i % 200 == 0) {
								ps.executeBatch();
								ps.clearBatch();
							}
						}
						ps.executeBatch();
					}
					
					
					
				}
			});
			tx.commit();
		} catch (Exception e) {
			if (tx != null) {
				tx.rollback();
			}
		} finally {
			sess.close();
		}
	}

	
	@Override
	public void delSysLog(String id) {
		// TODO Auto-generated method stub
		String hql = "update SysLog set deleted = 1 where sysLogId=:sysLogId";
		this.getCurrentSession().createQuery(hql).setParameter("sysLogId", id).executeUpdate();
	}  
	
	
	@Override
	public void delTransferLog(String id) {
		// TODO Auto-generated method stub
		String hql = "update TransferLog set deleted = 1 where transferLogId=:transferLogId";
		this.getCurrentSession().createQuery(hql).setParameter("transferLogId", id).executeUpdate();
	}  
	
	
	
	@Override
	public void delHeartbeatLog(String id) {
		// TODO Auto-generated method stub
		String hql = "update HeartbeatLog set deleted = 1 where heartbeatLogId=:heartbeatLogId";
		this.getCurrentSession().createQuery(hql).setParameter("heartbeatLogId", id).executeUpdate();
	}  
	
	
	@Override
	public void delPlayLog(String id) {
		// TODO Auto-generated method stub
		String hql = "update PlayLog set deleted = 1 where playLogId=:playLogId";
		this.getCurrentSession().createQuery(hql).setParameter("playLogId", id).executeUpdate();
	}  
	
	
	@Override
	public void delErrorLog(String id) {
		// TODO Auto-generated method stub
		String hql = "update ErrorLog set deleted = 1 where errorLogId=:errorLogId";
		this.getCurrentSession().createQuery(hql).setParameter("errorLogId", id).executeUpdate();
	}  
	
	
}
