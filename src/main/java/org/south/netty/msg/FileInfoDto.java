package org.south.netty.msg;

import java.io.Serializable;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

/**
 * @author jan
 * @date 2017年12月11日 下午7:39:18
 * @version V1.0 
 */
public class FileInfoDto implements Serializable {

	/** 
	 * @since JDK 1.6 
	 */ 
	private static final long serialVersionUID = -6771432074537311504L;
 
	private int flag;  //标志:从第一个素材开始播放
	
	private String start;
	
	private String end;
	
	private ArrayList<FileDto> listFile;
		
	private String periodId;  //时段id
	
	private String pname;     //该时段对应的播表名

	private String pid;        //该时段对应的播表id

	public FileInfoDto() {
		super();
	}



	@Override
	public String toString() {
		return "FileInfoDto [flag=" + flag + ", start=" + start + ", end=" + end + ", listFile=" + listFile
				+ ", periodId=" + periodId + ", pname=" + pname + ", pid=" + pid + "]";
	}



	public FileInfoDto(int flag, String start, String end, ArrayList<FileDto> listFile) {
		super();
		this.flag = flag;
		this.start = start;
		this.end = end;
		this.listFile = listFile;
	}
	
	

	public FileInfoDto(int flag, String start, String end, ArrayList<FileDto> listFile, String periodId) {
		super();
		this.flag = flag;
		this.start = start;
		this.end = end;
		this.listFile = listFile;
		this.periodId = periodId;
	}

	public int getFlag() {
		return flag;
	}

	public void setFlag(int flag) {
		this.flag = flag;
	}

	public String getStart() {
		return start;
	}

	public void setStart(String start) {
		this.start = start;
	}

	public String getEnd() {
		return end;
	}

	public void setEnd(String end) {
		this.end = end;
	}

	public List<FileDto> getListFile() {
		return listFile;
	}

	public void setListFile(ArrayList<FileDto> listFile) {
		this.listFile = listFile;
	}

	public String getPeriodId() {
		return periodId;
	}

	public void setPeriodId(String periodId) {
		this.periodId = periodId;
	}



	public String getPname() {
		return pname;
	}



	public void setPname(String pname) {
		this.pname = pname;
	}



	public String getPid() {
		return pid;
	}



	public void setPid(String pid) {
		this.pid = pid;
	}

//	public List<InsertDto> getListInsert() {
//		return listInsert;
//	}
//
//	public void setListInsert(List<InsertDto> listInsert) {
//		this.listInsert = listInsert;
//	}
	
	
	
	
	
}
