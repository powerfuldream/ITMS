package org.south.itms.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.south.itms.dao.impl.FileDao;
import org.south.itms.dao.impl.PtableDao;
import org.south.itms.dao.impl.TerminalDao;
import org.south.itms.dto.Result;
import org.south.itms.entity.IPTable;
import org.south.itms.entity.Material;
import org.south.itms.entity.Period;
import org.south.itms.entity.PlayTable;
import org.south.itms.entity.Terminal;
import org.south.itms.service.impl.CommonService;
import org.south.itms.service.impl.PlayControlService;
import org.south.itms.util.Constant;
import org.south.itms.util.SqlUtil;
import org.south.itms.util.StringUtil;
import org.south.netty.NettyChannelMap;
import org.south.netty.msg.DataKey;
import org.south.netty.msg.FileDto;
import org.south.netty.msg.FileInfoDto;
import org.south.netty.msg.InsertDto;
import org.south.netty.msg.MsgType;
import org.south.netty.msg.ResultMsg;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

/**
 * @author: yezilong
 */

@Controller  
@RequestMapping("/playerController")
public class PlayerController {

	@Autowired
	private PlayControlService playControlService;
	
	
	 @Autowired
	 private CommonService commonService;
	
	@Autowired
	private PtableDao ptableDao;
	
	@Autowired
	private TerminalDao terminalDao;
	
	@Autowired
	private FileDao fileDao;
	
	
	@RequestMapping("/playCenter")
	public String playCenter(HttpServletRequest request) {
		String rid = (String) request.getSession().getAttribute("rId");
		if(rid != null && rid.equals(Constant.adminValue)) {  //是系统管理员的话
			return "play/playCenterAdmin";
		} else {
			return "play/playCenter";
		}
	}
	
	@RequestMapping("/stopTerminal")
	public void stopTerminal(String terminalId, HttpServletResponse response) throws IOException {
		if(terminalId == null || "".equals(terminalId)) {
			PrintWriter out = response.getWriter();
			out.print("false");
			out.flush();
			out.close();
		}
		if(NettyChannelMap.get(terminalId) != null) {
			ResultMsg resultMsg = new ResultMsg(true, MsgType.stopTerminal);
			Map<String, Object> data = new HashMap<String, Object>();
			data.put(DataKey.stopTerminal, "1");
			resultMsg.setData(data);
			System.out.println("resultMsg=" + resultMsg);
			NettyChannelMap.get(terminalId).writeAndFlush(resultMsg);
			PrintWriter out = response.getWriter();
			out.print("true");
			out.flush();
			out.close();
		}else {
			PrintWriter out = response.getWriter();
			out.print("false");
			out.flush();
			out.close();
		}
	}
	
	@RequestMapping("/restartTerminal")
	public void restartTerminal(String terminalId, HttpServletResponse response) throws IOException {
		if(NettyChannelMap.get(terminalId) != null) {
			Terminal termianlRs = terminalDao.findById(terminalId);
			//重启终端
			SimpleDateFormat format1 = new SimpleDateFormat("HH:mm:ss");
			
            System.out.println("channel server Rs=" + NettyChannelMap.get(termianlRs.getTerminalId()));
			System.out.println("channel length Rs= " + NettyChannelMap.getMap().size());
            //重启客户端
			ResultMsg resultMsgRs = new ResultMsg(true, MsgType.restartTerminal);
			//返回播放端的主键
			Map<String, Object> dataRs = new HashMap<String, Object>();
			dataRs.put(DataKey.TerminalId, termianlRs.getTerminalId());
			dataRs.put(DataKey.TerminalName, termianlRs.getTerminalName());
			dataRs.put(DataKey.startSpotTop, termianlRs.getStartSpotTop());
			dataRs.put(DataKey.startSpotLeft, termianlRs.getStartSpotLeft());
			dataRs.put(DataKey.ledWidth, termianlRs.getLedWidth());
			dataRs.put(DataKey.ledLength, termianlRs.getLedLength());
			//返回播放端的播放表有哪些视频列表
			//List<FileDto> vediofiles = new ArrayList<FileDto>();
			List<FileInfoDto> vediofilesRs = new ArrayList<FileInfoDto>();
			//List<File> files = fileDao.findByPtable(termianl.getTerminalId());
			System.out.println(dataRs);
			System.out.println("success!!!!!!!Rs");
			//List<PlayTable> plays = fileDao.findByTerminalId(termianl.getTerminalId());
			List<PlayTable> playsRs = terminalDao.findByTerminalId(termianlRs.getTerminalId());
			//System.out.println(plays.get(0));
			
			if(playsRs.size() != 0) {
				for(PlayTable pt : playsRs) {
					if(pt.getInsertFlag() == 1) continue; //是插播的话直接跳过
					List<Material> fs = fileDao.findByPtable(pt.getPid());
					for(Material f:fs) {
						System.out.println(f);
					}
					Period period = fileDao.findByPeriod(pt.getPeriodId());
					FileInfoDto fileInfo = new FileInfoDto();
					fileInfo.setFlag(0);
					fileInfo.setPeriodId(pt.getPeriodId());
					fileInfo.setPname(pt.getPtableName());
					fileInfo.setPid(pt.getPid());
					//System.out.println("start=" + format.format(period.getStartInterval()));
					//System.out.println("start1=" + period.getStartInterval().toString());
					fileInfo.setStart(format1.format(period.getStartInterval()));
					fileInfo.setEnd(format1.format(period.getEndInterval()));
					//fileInfo.setEnd(period.getEndInterval());
					//fileInfo.setStart(period.getStartInterval());
					ArrayList<FileDto> fileDto = new ArrayList<FileDto>();
					for(Material file : fs) {
						fileDto.add(new FileDto(file.getMid(), StringUtil.getFileName(file.getFilePath()), file.getFileName(), file.getMd5()));
					}
					fileInfo.setListFile(fileDto);
					vediofilesRs.add(fileInfo);
				}
				System.out.println("Rs=" + vediofilesRs.size());
				System.out.println("Rs=" + vediofilesRs);
				SimpleDateFormat format = new SimpleDateFormat("HH:mm:ss");
				
				//插播
				List<InsertDto> insertDtoRs = new ArrayList<InsertDto>();
				List<PlayTable> ipTableRs = terminalDao.findInsertByTerminalId(termianlRs.getTerminalId());
                if(ipTableRs.size() == 0 || ipTableRs == null) {
                	System.out.println("插播为空");
                }else {
                	for(PlayTable ip : ipTableRs) {
                		List<Material> listMaterial = terminalDao.findAllMaterial(ip.getPid());
                		InsertDto dto = new InsertDto();
                		int sum = 0;
                		List<String> mid = new ArrayList<String>();
                		List<String> fileName = new ArrayList<String>();
                		List<String> logicName = new ArrayList<String>();
                		List<String> md5 = new ArrayList<String>();
                		for(Material m : listMaterial) {
                			mid.add(m.getMid());
                			String[] insertFileName = m.getFilePath().split("/");
                			fileName.add(insertFileName[insertFileName.length - 1]);
                			logicName.add(m.getMaterialName());
                			md5.add(m.getMd5());
                			sum = sum + m.getDuration();
                		}
                		dto.setEnd(format.format(ip.getEndTime()));
	                	dto.setStart(format.format(ip.getStartTime()));
	                	dto.setStatus("" + ip.getState());
	                	dto.setMin("" + ip.getMin());
	                	dto.setDuration("" + sum);
	                	dto.setMid(mid);
	                	dto.setFileName(fileName);
	                	dto.setLogicName(logicName);
	                	dto.setMd5(md5);
	                	insertDtoRs.add(dto);
                	}
	                System.out.println("insertDataRs=" + insertDtoRs);
                }
				//System.out.println(vediofiles.get(0));
				//System.out.println(vediofiles.get(1));
				//System.out.println(vediofiles.get(2));
				dataRs.put(DataKey.vediofiles, vediofilesRs);
				dataRs.put(DataKey.insertfiles, insertDtoRs);
				resultMsgRs.setData(dataRs);
				NettyChannelMap.get(terminalId).writeAndFlush(resultMsgRs);
			}
			PrintWriter out = response.getWriter();
			out.print("true");
			out.flush();
			out.close();
		}else {
			PrintWriter out = response.getWriter();
			out.print("false");
			out.flush();
			out.close();
		}
	}
	
    @RequestMapping(value="/findAllPlayTable")  
    public @ResponseBody Result findAllPlayTable() {
	 List<PlayTable> playTables = playControlService.findAllPlayTable();
	 return new Result(true, playTables);
    }
	
    
    
    
    @RequestMapping(value="/setPlayForTerminal")  
    public @ResponseBody Result setPlayForTerminal(String[] terminalIds, String pid) {
	   try {
		   if(terminalIds == null || terminalIds.length < 1 || StringUtil.isEmpty(pid))  return new Result("设置播表失败, 没有传入参数!");
		   
		   PlayTable playTable = new PlayTable();
		   if("-1".equals(pid)) {
			   playTable.setPid("-1");
		   } else {
			   playTable = playTable = ptableDao.load(pid);
		   }
		   
		   playControlService.setPlayForTerminal(terminalIds, playTable);

		   return new Result(true, "");
	   } catch(Exception e) {
		   e.printStackTrace();
		   return new Result("设置播表失败");
	   }
	
    }
	
    
    @RequestMapping(value="/editConnectPassword")  
	public @ResponseBody Result editConnectPassword(Terminal terminal) {
		  if(terminal == null || StringUtil.isEmpty(terminal.getTerminalId()) || StringUtil.isEmpty(terminal.getConnectPassword())) {
			  return new Result("修改错误");
		  }
		  
		  //更新的参数
		  Map<String, String> paramMap = new HashMap<String, String>();
		  paramMap.put("connectPassword", terminal.getConnectPassword());
		  //更新的where条件
		  Map<String, String> whereMap = new HashMap<String, String>();
		  whereMap.put("terminalId", terminal.getTerminalId());
		  //开始更新数据
		  try {
			  commonService.updateByTemplateHQL(SqlUtil.growUpdateHqlTemplate("Terminal", paramMap, whereMap), paramMap, whereMap);
			  return new Result(true, "");
		  } catch(Exception e) {
			  e.printStackTrace();
			  return new Result("修改错误");
		  }
		
	 }
    
	
}
