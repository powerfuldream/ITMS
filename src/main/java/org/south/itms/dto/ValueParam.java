package org.south.itms.dto;

/**
 * @author: yezilong
 */

public class ValueParam { // 拼查询sql的where字句的值

	private String symbol; // 值只能是 like 或者 =
	private String value;

	public ValueParam(String symbol, String value) {
		super();
		this.symbol = symbol;
		this.value = value;
	}

	public String getSymbol() {
		return symbol;
	}

	public void setSymbol(String symbol) {
		this.symbol = symbol;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public String toString() {
		return "ValueParam [symbol=" + symbol + ", value=" + value + "]";
	}

}
