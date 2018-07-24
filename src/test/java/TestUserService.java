
  
import java.util.Date;  
import java.util.List;  
import java.util.UUID;    
import org.apache.log4j.Logger;  
import org.junit.Test;  
import org.junit.runner.RunWith;
import org.south.itms.dao.impl.AreaDao;
import org.south.itms.dao.impl.TerminalDao;
import org.south.itms.dto.EasyuiDatagrid;
import org.south.itms.entity.AcctUser;
import org.south.itms.entity.Area;
import org.south.itms.entity.Terminal;
import org.south.itms.service.impl.TerminalService;
import org.south.itms.service.impl.AcctUserService;
import org.south.itms.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;  
import org.springframework.test.context.ContextConfiguration;  
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.transaction.annotation.Transactional;

import com.alibaba.fastjson.JSON;  
  
/** 
 * 创建时间：2015-2-6 下午3:31:07 
 *  
 * @author andy 
 * @version 2.2 
 */  
@RunWith(SpringJUnit4ClassRunner.class)  
@ContextConfiguration(locations = { "classpath:spring.xml",  
        "classpath:spring-hibernate.xml" })  
@Transactional
public class TestUserService {  
  
    private static final Logger LOGGER = Logger  
            .getLogger(TestUserService.class);  
  
    @Autowired  
    private AcctUserService userService;  
    
    @Autowired  
    private AreaDao areaDao;
    
    @Autowired  
    private TerminalService terminalService;  
    
    
    public void saveAcctUser() {  
        AcctUser acctUser = new AcctUser();  
        acctUser.setId(UUID.randomUUID().toString());  
        acctUser.setNickName("andy");  
//        acctUser.setRegisterTime(new Date());  
        acctUser.setTelephone("13022221111");  
        String id = userService.save(acctUser);  
        LOGGER.info(JSON.toJSONString(id));  
    }  
    
    
    
    
 
    public void save() {  
        Terminal terminal = new Terminal();
        terminal.setTerminalId(UUID.randomUUID().toString());
        terminal.setAreaCode("110000");
        terminal.setAreaName("ff");
     
        //terminal.setRunEndTime(new Date());
        String id = terminalService.save(terminal);  
        LOGGER.info(JSON.toJSONString(id));  
    }  
    
    
    
    
    @Autowired 
    private TerminalDao terminalDao;
    
    
  
}  