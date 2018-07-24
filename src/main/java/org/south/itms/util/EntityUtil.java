package org.south.itms.util;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.south.itms.dto.ItemsDto;
import org.south.itms.dto.MaterialDto;
import org.south.itms.dto.PtableDto;
import org.south.itms.dto.TreeDate;
import org.south.itms.dto.UserDto;
import org.south.itms.entity.Items;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.PlayTable;
import org.south.itms.entity.Resource;
import org.south.itms.entity.Terminal;
import org.south.itms.entity.User;

/**
 * @author jan
 * @date 2018年1月13日 下午10:08:56
 * @version V1.0 
 */
public class EntityUtil {

//	public static List<MaterialDto> materialChange(List<Terminal> list, List<Material> listM, List<Period> listPeriod) {
//		List<MaterialDto> listDto = new ArrayList<MaterialDto>();
//		MaterialDto dto = null;
//		for(Material m : listM) {
//			for(int i = 0; i < list.size(); i++) {
//				if((m.getTerminalId()).equals(list.get(i).getTerminalId())) {
//					dto = new MaterialDto(m.getMid(), m.getMaterialName(), list.get(i).getTerminalName()
//							, m.getFilePath(), m.getFileType(), m.getResolution(),
//							m.getUploadName(), m.getUploadTime(), m.getDuration(), m.getMd5(), m.getStatusId()
//							, m.getInfo());
//					if(m.getFrequency() != 0) {
//						dto.setFrequency("" + m.getFrequency());
//					}else {
//						dto.setFrequency("");
//					}
//					
//					if(m.getStartTime() != null && m.getEndTime() != null) {
//						String start = new SimpleDateFormat("yyyy-MM-dd").format(m.getStartTime());
//						String end = new SimpleDateFormat("yyyy-MM-dd").format(m.getEndTime());
//						dto.setPlayDate(start + " - " + end);
//					}
//					break;
//				}
//			}
//			if(m.getPeriodId() != null) {
//				for(int j = 0; j < listPeriod.size(); j++) {
//					if((m.getPeriodId()).equals(listPeriod.get(j).getPeriodId())) {
//						String start1 = new SimpleDateFormat("HH:mm:ss").format(listPeriod.get(j).getStartInterval());
//						String end1 = new SimpleDateFormat("HH:mm:ss").format(listPeriod.get(j).getEndInterval());
//						dto.setPlayTime(start1 + " - " + end1);
//						dto.setpName(listPeriod.get(j).getPeriodName());
//						dto.setPeriodId(m.getPeriodId());
//					}
//				}
//			}
//			listDto.add(dto);
//		}
//		return listDto;
//	}
//
//	public static List<MaterialDto> materialChange(List<Terminal> list, List<Material> listM) {
//		List<MaterialDto> listDto = new ArrayList<MaterialDto>();
//		MaterialDto dto = null;
//		for(Material m : listM) {
//			for(int i = 0; i < list.size(); i++) {
//				if((m.getTerminalId()).equals(list.get(i).getTerminalId())) {
//					dto = new MaterialDto(m.getMid(), m.getMaterialName(), list.get(i).getTerminalName()
//							, m.getFilePath(), m.getFileType(), m.getResolution(),
//							m.getUploadName(), m.getUploadTime(), m.getDuration(), m.getMd5(), m.getStatusId()
//							, m.getInfo());
//					break;
//				}
//			}
//			listDto.add(dto);
//		}
//		return listDto;
//	}
	
	//7.16
	public static List<PtableDto> ptableDto(List<Terminal> list, List<Period> listPeriod, List<User> listUser,
			List<PlayTable> listPtable) {
		List<PtableDto> listDto = new ArrayList<PtableDto>();
		for(PlayTable pt : listPtable) {
			String terminalName = checkTerminal(pt.getTerminalId(), list);
			String periodName = checkPeriod(pt.getPeriodId(), listPeriod, 0);
			String periodTime = checkPeriod(pt.getPeriodId(), listPeriod, 1);
			String userName = checkName(pt.getUserId(), listUser);
			PtableDto ptd = new PtableDto(pt.getTerminalId(),pt.getPid(), pt.getStatusId(), pt.getPlayTotalTime(),
					pt.getPlayDate(), pt.getScreenRate(), pt.getAllTime(), pt.getPtableName(),
					pt.getCreateTime(), pt.getMin(), pt.getInsertFlag(), pt.getState());
			ptd.setTerminalName(terminalName);
			ptd.setPeriodName(periodName);
			ptd.setPeriodTime(periodTime);
			ptd.setCreateName(userName);
			ptd.setMark(pt.getMark());
			ptd.setStartTime(pt.getStartTime());
			ptd.setEndTime(pt.getEndTime());
			listDto.add(ptd);
		}
		return listDto;
	}

	private static String checkName(String userId, List<User> listUser) {
		String userName = "";
		for(User u : listUser) {
			if(userId.equals(u.getUserId())) {
				userName = u.getUserName();
				break;
			}
		}
		return userName;
	}

	private static String checkPeriod(String periodId, List<Period> listPeriod, int flag) {
		String returnMsg = "";
		if(periodId == null || "".equals(periodId)) {
			return returnMsg;
		}
		for(Period p : listPeriod) {
			if(periodId.equals(p.getPeriodId())) {
				if(flag == 0) {
					returnMsg = p.getPeriodName();
				}else if(flag == 1) {
					String start = new SimpleDateFormat("HH:mm:ss").format(p.getStartInterval());
					String end = new SimpleDateFormat("HH:mm:ss").format(p.getEndInterval());
					returnMsg = start + " - " + end;
				}
				break;
			}
		}
		return returnMsg;
	}

	private static String checkTerminal(String terminalId, List<Terminal> list) {
		String terminalName = "";
		for(Terminal t : list) {
			if(terminalId.equals(t.getTerminalId())) {
				terminalName = t.getTerminalName();
				break;
			}
		}
		return terminalName;
	}

	public static List<UserDto> getUserDto(List<User> listU) {
		List<UserDto> list = new ArrayList<UserDto>();
		for(User u : listU) {
			UserDto dto = new UserDto(
					u.getUserId(), u.getUserName(), u.getUserAccount(), u.getUserPassword(),
					u.getCellphone(), u.getEmail(), u.getState(), u.getDeleted(), u.getRole().getRoleName()
					);
			list.add(dto);
		}
		return list;
	}

	public static List<MaterialDto> getMaterialDtoInfo(List<Material> listM, List<Terminal> listTerminal) {
		List<MaterialDto> list = new ArrayList<MaterialDto>();
		for(Material m : listM) {
			if("0".equals(m.getTis())) {
				String name = matchName(m.getMaterialName(), listTerminal);
				MaterialDto dto = new MaterialDto(name);
				dto.setUsedNum(m.getUsedNum());
				dto.setUploadTime(m.getUploadTime());
				dto.setUploadName(m.getUploadName());
				dto.setTis(m.getTis());
				dto.setStatusId(m.getStatusId());
				dto.setSize(m.getSize());
				dto.setResolution(m.getResolution());
				dto.setMid(m.getMid());
				dto.setMaterialName(m.getMaterialName());
				dto.setInfo(m.getInfo());
				dto.setFileType(m.getFileType());
				dto.setFilePath(m.getFilePath());
				dto.setFileName(m.getFileName());
				dto.setDeleted(m.getDeleted());
				dto.setDuration(m.getDuration());
				dto.setCheckTime(m.getCheckTime());
				dto.setCheckName(m.getCheckName());
				list.add(dto);
			}else if("1".equals(m.getTis())) {
				MaterialDto dto = new MaterialDto();
				dto.setUsedNum(m.getUsedNum());
				dto.setUploadTime(m.getUploadTime());
				dto.setUploadName(m.getUploadName());
				dto.setTis(m.getTis());
				dto.setStatusId(m.getStatusId());
				dto.setSize(m.getSize());
				dto.setResolution(m.getResolution());
				dto.setMid(m.getMid());
				dto.setMaterialName(m.getMaterialName());
				dto.setInfo(m.getInfo());
				dto.setFileType(m.getFileType());
				dto.setFilePath(m.getFilePath());
				dto.setFileName(m.getFileName());
				dto.setDeleted(m.getDeleted());
				dto.setDuration(m.getDuration());
				dto.setCheckTime(m.getCheckTime());
				dto.setCheckName(m.getCheckName());
				dto.setTerminal(m.getTerminal());
				list.add(dto);
			}
		}
		return list;
	}
	
	public static int canConstruct(String ransomNote, String magazine) {
        int len1 = ransomNote.length();
        int len2 = magazine.length();
        char[] c1 = ransomNote.toCharArray();
        char[] c2 = magazine.toCharArray();
        int[][] lenLCS = new int[len2 + 1][len1 + 1];
        for(int i = 1; i <= len2; i++){
            for(int j = 1; j <= len1; j++){
                if(c1[j - 1] == c2[i - 1]){
                    lenLCS[i][j] = lenLCS[i - 1][j - 1] + 1;
                }else{
                    if(lenLCS[i - 1][j] >= lenLCS[i][j - 1]){
                        lenLCS[i][j] = lenLCS[i - 1][j];
                    }else{
                        lenLCS[i][j] = lenLCS[i][j - 1];
                    }
                }
            }
        }
        return lenLCS[len2][len1];
    }

	private static String matchName(String materialName, List<Terminal> listTerminal) {
		int offset = 0;
		//String name = listTerminal.get(0).getTerminalName();
		int length = Integer.MIN_VALUE;
		for(int i = 0; i < listTerminal.size(); i++) {
			int len = canConstruct(listTerminal.get(i).getTerminalName(), materialName);
			if(len > length) {
				offset = i;
				length = len;
			}
		}
		return listTerminal.get(offset).getTerminalName();
	}

	public static List<ItemsDto> getItemsDto(List<Items> listM, List<Period> listPeriod) {
		List<ItemsDto> list = new ArrayList<ItemsDto>();
		for(Items m : listM) {
			String periodName = getPeriodName(m.getPeriodId(), listPeriod);
			String playDate = "";
			if(m.getStartDate() != null && m.getEndDate() != null) {
			String start = new SimpleDateFormat("yyyy-MM-dd").format(m.getStartDate());
			String end = new SimpleDateFormat("yyyy-MM-dd").format(m.getEndDate());
			playDate = start + " - " + end;
		    }
			ItemsDto dto = new ItemsDto(periodName, playDate);
			dto.setCreateName(m.getCreateName());
			dto.setCreateTime(m.getCreateTime());
			dto.setDeleted(m.getDeleted());
			dto.setDuration(m.getDuration());
			dto.setEndDate(m.getEndDate());
			dto.setFrequency(m.getFrequency());
			dto.setItemId(m.getItemId());
			dto.setItemName(m.getItemName());
			dto.setMaterial(m.getMaterial());
			dto.setMaterialName(m.getMaterialName());
			dto.setPeriodId(m.getPeriodId());
			dto.setStartDate(m.getStartDate());
			dto.setTerminalId(m.getTerminalId());
			list.add(dto);
		}
		return list;
	}

	private static String getPeriodName(String periodId, List<Period> listPeriod) {
		String returnMsg = "";
		for(Period p : listPeriod) {
			if(periodId.equals(p.getPeriodId())) {
			    returnMsg = returnMsg + p.getPeriodName();
				String start = new SimpleDateFormat("HH:mm:ss").format(p.getStartInterval());
				String end = new SimpleDateFormat("HH:mm:ss").format(p.getEndInterval());
				returnMsg = returnMsg + " " + start + " - " + end;
				break;
			}
		}
		System.out.println("periodName=" + returnMsg);
		return returnMsg;
	}

	public static TreeDate getTreeData(String roleName, Map<String, List<Resource>> map) {
		TreeDate tree = new TreeDate();
		tree.setName(roleName);
		List<TreeDate> trList = new ArrayList<TreeDate>();
		
		for(String s : map.keySet()) {
			TreeDate childTree = new TreeDate();
			childTree.setName(s);
			List<Resource> list = map.get(s);
			List<TreeDate> children = new ArrayList<TreeDate>();
			for(Resource r : list) {
				TreeDate data = new TreeDate();
				data.setName(r.getResourceName());
				children.add(data);
			}
			childTree.setChildren(children);
			trList.add(childTree);
		}
		tree.setChildren(trList);
		return tree;
	}

	public static List<Items> createNewItems(List<Material> files) {
		if(files == null || files.size() == 0) {
			return null;
		}else {
			List<Items> list = new ArrayList<Items>();
			for(Material m : files) {
				Items item = new Items();
				item.setMaterial(m);
				item.setMaterialName(m.getMaterialName());
				item.setFrequency(0);
				item.setDuration(m.getDuration());
				list.add(item);
			}
			return list;
		}
	}

}
