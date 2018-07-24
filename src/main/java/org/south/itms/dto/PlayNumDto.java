package org.south.itms.dto;

public class PlayNumDto {

	private String materialName;
	private int playNum;
	private String startPlayTime;
	private String endPlayTime;

	
	public PlayNumDto() {
	
	}
	


	public PlayNumDto(String materialName, int playNum, String startPlayTime, String endPlayTime) {
		super();
		this.materialName = materialName;
		this.playNum = playNum;
		this.startPlayTime = startPlayTime;
		this.endPlayTime = endPlayTime;
	}

	public String getMaterialName() {
		return materialName;
	}

	public void setMaterialName(String materialName) {
		this.materialName = materialName;
	}


	public int getPlayNum() {
		return playNum;
	}

	public void setPlayNum(int playNum) {
		this.playNum = playNum;
	}

	
	public String getStartPlayTime() {
		return startPlayTime;
	}

	public void setStartPlayTime(String startPlayTime) {
		this.startPlayTime = startPlayTime;
	}


	public String getEndPlayTime() {
		return endPlayTime;
	}

	public void setEndPlayTime(String endPlayTime) {
		this.endPlayTime = endPlayTime;
	}

	@Override
	public String toString() {
		return "PlayNumDto [materialName=" + materialName + ", playNum=" + playNum + ", startPlayTime=" + startPlayTime
				+ ", endPlayTime=" + endPlayTime + "]";
	}

}
