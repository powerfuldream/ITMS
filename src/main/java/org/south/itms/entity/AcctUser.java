package org.south.itms.entity;

import java.sql.Time;
import java.util.Date;  
import java.util.HashSet;  
import java.util.Set;  
import javax.persistence.Column;  
import javax.persistence.Entity;  
import javax.persistence.FetchType;  
import javax.persistence.Id;  
import javax.persistence.JoinColumn;  
import javax.persistence.JoinTable;  
import javax.persistence.ManyToMany;  
import javax.persistence.Table;  
import javax.persistence.Temporal;  
import javax.persistence.TemporalType;  
import org.hibernate.annotations.Cache;  
import org.hibernate.annotations.CacheConcurrencyStrategy;  
import com.fasterxml.jackson.annotation.JsonIgnoreProperties; 

/**
 * @author: yezilong
 */

@Entity  
@Table(name = "acct_user", catalog = "work")  
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)  
public class AcctUser implements java.io.Serializable {  
  
 
    private static final long serialVersionUID = 6980093847795726310L;  
    private String id;  
    private String nickName;  
    private Time testTime;
    private String telephone;  
  
  
    public AcctUser() {  
  
    }  
  
    public AcctUser(String id, String nickName) {  
        this.id = id;  
        this.nickName = nickName;  
    }  
  
    public AcctUser(String id, String nickName, String telephone) {  
        this.id = id;  
        this.nickName = nickName;  
        this.telephone = telephone;  
    
    }  
  
    @Id  
    @Column(name = "id", unique = true, nullable = false)  
    public String getId() {  
        return this.id;  
    }  
  
    public void setId(String id) {  
        this.id = id;  
    }  
  
    @Column(name = "nick_name", nullable = false)  
    public String getNickName() {  
        return this.nickName;  
    }  
  
    public void setNickName(String nickName) {  
        this.nickName = nickName;  
    }  
  
    @Column(name = "telephone")  
    public String getTelephone() {  
        return this.telephone;  
    }  
  
    public void setTelephone(String telephone) {  
        this.telephone = telephone;  
    }

	public Time getTestTime() {
		return testTime;
	}

	public void setTestTime(Time testTime) {
		this.testTime = testTime;
	}

	@Override
	public String toString() {
		return "AcctUser [id=" + id + ", nickName=" + nickName + ", testTime=" + testTime + ", telephone=" + telephone
				+ "]";
	}  
  
    
    
  

  
}  