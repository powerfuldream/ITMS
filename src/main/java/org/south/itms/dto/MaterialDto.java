package org.south.itms.dto;

import java.util.Date;

import org.south.itms.entity.Material;

/**
 * @author jan
 * @date 2018年1月13日 下午9:06:43
 * @version V1.0 
 */
public class MaterialDto extends Material{

	private String terminalName;

	public String getTerminalName() {
		return terminalName;
	}

	public void setTerminalName(String terminalName) {
		this.terminalName = terminalName;
	}

	public MaterialDto(String terminalName) {
		super();
		this.terminalName = terminalName;
	}

	
	public MaterialDto() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public String toString() {
		return "MaterialDto [terminalName=" + terminalName + ", toString()=" + super.toString() + "]";
	}

	public static void main(String[] args) {
		MaterialDto dto = new MaterialDto("南都");
		dto.setCheckName("222");
		dto.setTerminalName("南都");
		System.out.println(dto);
	}
}
