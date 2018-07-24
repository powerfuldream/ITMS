package org.south.netty;

/**
 * @author jan
 * @date 2017年11月29日 下午12:47:46
 * @version V1.0
 */
public class Ad {

	private int fileId;
	private String adName;
	private Integer freq;
	private Integer duration;

	public Ad(Ad ad) {
		this.fileId = ad.fileId;
		this.adName = ad.adName;
		this.freq = ad.freq;
		this.duration = ad.duration;
	}

	/**
	 * @param fileId
	 * @param adName
	 * @param freq
	 */
	public Ad(int fileId, String adName, Integer freq, Integer duration) {
		super();
		this.fileId = fileId;
		this.adName = adName;
		this.freq = freq;
		this.duration = duration;
	}

	/**
	 * @param fileId
	 * @param freq
	 */
	
	
	public Ad(int fileId, Integer freq) {
		super();
		this.fileId = fileId;
		this.freq = freq;
	}

	public Integer getDuration() {
		return duration;
	}

	public void setDuration(Integer duration) {
		this.duration = duration;
	}

	/**
	 * @return the adName
	 */
	public String getAdName() {
		return adName;
	}

	/**
	 * @param adName
	 *            the adName to set
	 */
	public void setAdName(String adName) {
		this.adName = adName;
	}

	/**
	 * @return the fileId
	 */
	public int getFileId() {
		return fileId;
	}

	/**
	 * @param fileId
	 *            the fileId to set
	 */
	public void setFileId(int fileId) {
		this.fileId = fileId;
	}

	/**
	 * @return the freq
	 */
	public Integer getFreq() {
		return freq;
	}

	/**
	 * @param freq
	 *            the freq to set
	 */
	public void setFreq(Integer freq) {
		this.freq = freq;
	}

//	@Override
//	public boolean equals(Object obj) {
//		if (obj == null)
//			return false;
//		if (this == obj)
//			return true;
//		if (obj instanceof Ad) {
//			Ad ad = (Ad) obj;
//			if (ad.getAdName().equals(this.adName))
//				return true;
//		}
//		return false;
//	}
//
//	@Override
//	public int hashCode() {
//		return adName.hashCode();
//	}

	/**
	 * 
	 */
	public Ad() {
		super();
	}

	@Override
	public String toString() {
		return "Ad [fileId=" + fileId + ", adName=" + adName + ", freq=" + freq + ", duration=" + duration + "]";
	}
}
