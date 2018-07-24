package org.south.itms.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.south.itms.dto.TreeDate;
import org.south.itms.entity.Resource;
import org.south.itms.entity.Terminal;

/**
 * @author jan
 * @date 2017年12月18日 下午10:43:23
 * @version V1.0 
 */
public class TreeUtil {

	public static List<TreeDate> getTreeDate(List<Terminal> list) {
		System.out.println("terminal=" + list);
		List<TreeDate> listTree = new ArrayList<TreeDate>();
		for(Terminal t : list) {
			if(!checkAreaCode(t, listTree)) {
				String pid = "p" + t.getAreaCode();
				String[] s = t.getAreaName().split("省");
		    	String[] s1 = s[1].split("市");
		    	//System.out.println(s1[0]);
		    	List<TreeDate> children = new ArrayList<TreeDate>();
				TreeDate td = new TreeDate(pid, s1[0], children);
				td.setSpread(true);
				listTree.add(td);
			}
		}
		
		for(Terminal t : list) {
			String tid = "t" + t.getTerminalId();
			String name = t.getTerminalName();
			TreeDate td1 = new TreeDate(tid, name);
			String pid = "p" + t.getAreaCode();
			int index = getListTreeIndex(pid, listTree);
			listTree.get(index).getChildren().add(td1);
		}
		return listTree;
	}
	
	private static int getListTreeIndex(String pid, List<TreeDate> listTree) {
		int index = 0;
		for(int i = 0; i < listTree.size(); i++) {
			if(pid.equals(listTree.get(i).getId())) {
				index = i;
				break;
			}
		}
		return index;
	}

	public static boolean checkAreaCode(Terminal terminal, List<TreeDate> list) {
		if(list.size() == 0) return false;
		boolean flag = false;
		String id = "p" + terminal.getAreaCode();
		for(int i = 0; i < list.size(); i++) {
			String areaId = list.get(i).getId();
			if(id.equals(areaId)) {
				flag = true;
				break;
			}
		}
		return flag;
	}

	public static Map<String, List<Resource>> getAllMap(List<Resource> list) {
		Map<String, List<Resource>> map = new HashMap<String, List<Resource>>();
		Set<String> set = new HashSet<String>();
		for(Resource r : list) {
			if(!StringUtil.isEmpty(r.getParentName())) set.add(r.getParentName());
		}
		for(String s : set) {
			List<Resource> listRe = new ArrayList<Resource>();
			for(Resource r : list) {
				if(s.equals(r.getParentName())) {
					listRe.add(r);
				}
			}
			map.put(s, listRe);
		}
		return map;
	}
	
	@SuppressWarnings("unused")
	private static boolean checkMap(Resource r, Map<String, List<Resource>> map) {
		if(map.size() == 0) {
			return false;
		}
		if(map.containsKey(r.getParentName())) {
			return true;
		}else {
			return false;
		}
	}

}
