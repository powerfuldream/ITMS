package org.south.itms.service.impl;


import java.util.List;

import org.south.itms.entity.Terminal;  
 
 
 
public interface TerminalService {  
   Terminal load(String id);  
 
   Terminal get(String id);  
 
   List<Terminal> findAll();  
 
   void persist(Terminal entity);  
 
   String save(Terminal entity);  
 
   void saveOrUpdate(Terminal entity);  
 
   void delete(String id);  
 
   void flush();

   void updateByHQL(String hql);

   void deleteByHQL(String[] terminalIds);

   void updateTerminalState(String[] terminalIds, boolean state);

   int countBySerialNumber(Terminal entity);

   void resetTerminalPtable(String pid);  
}  