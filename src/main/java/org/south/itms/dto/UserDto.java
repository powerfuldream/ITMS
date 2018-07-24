package org.south.itms.dto;
/**
 * @author jan
 * @date 2018年1月16日 上午11:26:34
 * @version V1.0 
 */
public class UserDto {

	private String userId;
	private String userName;
	private String userAccount;
	private String userPassword;
	private String cellphone;
	private String email;
	private String state;
	private int deleted;
	
	private String roleName;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserAccount() {
		return userAccount;
	}

	public void setUserAccount(String userAccount) {
		this.userAccount = userAccount;
	}

	public String getUserPassword() {
		return userPassword;
	}

	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}

	public String getCellphone() {
		return cellphone;
	}

	public void setCellphone(String cellphone) {
		this.cellphone = cellphone;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public int getDeleted() {
		return deleted;
	}

	public void setDeleted(int deleted) {
		this.deleted = deleted;
	}

	public String getRoleName() {
		return roleName;
	}

	public void setRoleName(String roleName) {
		this.roleName = roleName;
	}

	public UserDto(String userId, String userName, String userAccount, String userPassword, String cellphone,
			String email, String state, int deleted, String roleName) {
		super();
		this.userId = userId;
		this.userName = userName;
		this.userAccount = userAccount;
		this.userPassword = userPassword;
		this.cellphone = cellphone;
		this.email = email;
		this.state = state;
		this.deleted = deleted;
		this.roleName = roleName;
	}

	public UserDto() {
		super();
	}

	@Override
	public String toString() {
		return "UserDto [userId=" + userId + ", userName=" + userName + ", userAccount=" + userAccount
				+ ", userPassword=" + userPassword + ", cellphone=" + cellphone + ", email=" + email + ", state="
				+ state + ", deleted=" + deleted + ", roleName=" + roleName + "]";
	}
	
	
}
