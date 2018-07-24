package org.south.netty.msg;

public class TransferLogMsg implements java.io.Serializable {

	private static final long serialVersionUID = 7394077382075375228L;

	private String transferStartTime;
	private String transferEndTime;
	private String transferFileName;
	private String transferFileId;
	private int finished;
	private String note;
	private String pname;

	public String getTransferStartTime() {
		return transferStartTime;
	}

	public void setTransferStartTime(String transferStartTime) {
		this.transferStartTime = transferStartTime;
	}

	public String getTransferEndTime() {
		return transferEndTime;
	}

	public void setTransferEndTime(String transferEndTime) {
		this.transferEndTime = transferEndTime;
	}

	public String getTransferFileName() {
		return transferFileName;
	}

	public void setTransferFileName(String transferFileName) {
		this.transferFileName = transferFileName;
	}

	public String getTransferFileId() {
		return transferFileId;
	}

	public void setTransferFileId(String transferFileId) {
		this.transferFileId = transferFileId;
	}

	public int getFinished() {
		return finished;
	}

	public void setFinished(int finished) {
		this.finished = finished;
	}

	public String getNote() {
		return note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	public String getPname() {
		return pname;
	}

	public void setPname(String pname) {
		this.pname = pname;
	}

	
	
	@Override
	public String toString() {
		return "TransferLogMsg [transferStartTime=" + transferStartTime + ", transferEndTime=" + transferEndTime
				+ ", transferFileName=" + transferFileName + ", transferFileId=" + transferFileId + ", finished="
				+ finished + ", note=" + note + ", pname=" + pname + "]";
	}

}
