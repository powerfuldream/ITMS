package org.south.itms.controller;

import java.util.ArrayList;
import java.util.List;

import org.south.itms.dao.impl.AreaDao;
import org.south.itms.dto.Result;
import org.south.itms.entity.Area;
import org.south.itms.util.TreeNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


/**
 * @author: yezilong
 */

@Controller  
@RequestMapping("/area")  
public class AreaController {  

  @Autowired  
  private AreaDao areaDao;
  
  @RequestMapping("/buildTree")
  @ResponseBody
  public TreeNode<Area> buildTree(){   //根据地区表来建树
	  List<Area> areas = areaDao.findAll();
	  return wrapTreeNode(areas);
  } 
  
  
  //根据终端表有哪些地区，建立对应的地区树
  @RequestMapping("/buildTreeByTerminalTable")
  public @ResponseBody TreeNode<Area> buildTreeByTerminalTable() {   //根据地区表来建树
	  List<Area> areas = areaDao.findInTerminalTable();
	  return wrapTreeNode(areas);
  }  
  
  private TreeNode<Area> wrapTreeNode(List<Area> areas) {  //把List<Area> areas  包装成ztree的json格式
      List<TreeNode<Area>> nodes = new ArrayList<TreeNode<Area>>();  
      
      //把行政区类转为树节点  
      for(Area area : areas){  
          TreeNode<Area> node = new TreeNode<Area>();  
            
          //节点id  
          node.setId(area.getCode());  
            
          //节点上级id  
          node.setParentId(area.getParentCode());  
            
          node.setText(area.getName());  
            
          //把行政区类放到节点数据中，以备使用  
          node.setNodeData(area);  
            
          nodes.add(node);  
      }  
        
      return TreeNode.buildTree(nodes);  
  }
  
  
  @RequestMapping(value="/findAll")  
  public @ResponseBody Result findAll() {
	  List<Area> areas = areaDao.findAll();
	  return new Result(true, areas); 
  }
  
  
  
  
  
  
}  
