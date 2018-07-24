package org.south.itms.util;

import java.util.List;
import java.util.Map;

import org.hibernate.query.Query;
import org.south.itms.dto.ValueParam;

/**
 * @author: yezilong
 */

public class SqlUtil {
   
	public static String growUpdateHql(String entityClass, Map<String, String> paramMap, Map<String, String> whereMap) { //paramMap和whereMap的key不能有相同的
		if(StringUtil.isEmpty(entityClass) || paramMap.isEmpty()) {
			return "";
		}
		
		StringBuilder hql = new StringBuilder("");
		//拼表名
		hql.append("update ");
		hql.append(entityClass);
		
		//拼更新的参数字段
		hql.append(" set ");
		for(Map.Entry<String, String> entry : paramMap.entrySet()) {
			 hql.append(entry.getKey());
			 hql.append("=\'");
			 hql.append(entry.getValue());
			 hql.append("\',");
		}
		hql.setLength(hql.length() - 1);
		
		//拼where参数
		if(!whereMap.isEmpty()) {
			hql.append(" where ");
			for(Map.Entry<String, String> entry : whereMap.entrySet()) {
				 hql.append(entry.getKey());
				 hql.append("=\'");
				 hql.append(entry.getValue());
				 hql.append("\' and ");
			}
			hql.setLength(hql.length() - 4);
		}
		String HqlStr = hql.toString();
		System.out.println("生成的update HQL:" + HqlStr);
		return HqlStr;
	}
	
	
	
	public static String growUpdateHqlTemplate(String entityClass, Map<String, String> paramMap, Map<String, String> whereMap) { //paramMap和whereMap的key不能有相同的
		if(StringUtil.isEmpty(entityClass) || paramMap.isEmpty()) {
			return "";
		}
		
		StringBuilder hql = new StringBuilder("");
		//拼表名
		hql.append("update ");
		hql.append(entityClass);
		
		//拼更新的参数字段
		hql.append(" set ");
		for(Map.Entry<String, String> entry : paramMap.entrySet()) {
			 hql.append(entry.getKey());
			 hql.append("=:");
			 hql.append(entry.getKey());
			 hql.append(",");
		}
		hql.setLength(hql.length() - 1);
		
		//拼where参数
		if(!whereMap.isEmpty()) {
			hql.append(" where ");
			for(Map.Entry<String, String> entry : whereMap.entrySet()) {
				 hql.append(entry.getKey());
				 hql.append("=:");
				 hql.append(entry.getKey());
				 hql.append(" and ");
			}
			hql.setLength(hql.length() - 4);
		}
		String HqlStr = hql.toString();
		System.out.println("生成的update Template HQL:" + HqlStr);
		return HqlStr;
	}
	
	
	
	
	
	
	
	public static String growSelectHqlTemplate(String entityClass, List<String> selectParams, Map<String, String> whereMap) {
		if(StringUtil.isEmpty(entityClass) || selectParams.size() < 1) {
			return "";
		}
		
		StringBuilder hql = new StringBuilder("");
		//拼select的参数
		hql.append("select ");
		for(String selectParam : selectParams) {
			hql.append(selectParam);
			hql.append(",");
		}
		hql.setLength(hql.length() - 1);
		
	
		//拼类名
		hql.append(" from ");
		hql.append(entityClass);
		
		//拼where的参数字段
		if(!whereMap.isEmpty()) {
			hql.append(" where ");
			for(Map.Entry<String, String> entry : whereMap.entrySet()) {
				 hql.append(entry.getKey());
				 hql.append("=:");
				 hql.append(entry.getKey());
				 hql.append(" and ");
			}
			hql.setLength(hql.length() - 4);
		}
		String HqlStr = hql.toString();
		System.out.println("生成的select HQL:" + HqlStr);
		return HqlStr;
	}
	
	
	
	public static String growOrFinalStr(Map<String, ValueParam> whereMap) { //生成or子句
		if(whereMap == null || whereMap.isEmpty()) {
			return "";
		}
		
		StringBuilder hql = new StringBuilder(" ( ");
		for(Map.Entry<String, ValueParam> entry : whereMap.entrySet()) {
			 hql.append(entry.getKey());
			 hql.append(" ");
			 hql.append(entry.getValue().getSymbol());  //查询要用 =号还是like符号
			 hql.append(" \'");
			 if("like".contentEquals(entry.getValue().getSymbol())) {
				 hql.append("%");
				 hql.append(entry.getValue().getValue());
				 hql.append("%");
			 } else {
				 hql.append(entry.getValue().getValue());
			 }
			 hql.append("\'");
			 hql.append(" or ");
		}
		hql.setLength(hql.length() - 4);
		hql.append(" ) ");
		
		String HqlStr = hql.toString();
		System.out.println("生成的or子句:" + HqlStr);
		return HqlStr;
	}

	
	
	
	
	
	public static String growSearchHqlTemplate(String entityClass, Map<String, ValueParam> whereMap, String orderBy) {
		if(StringUtil.isEmpty(entityClass) || whereMap == null) {
			return "";
		}
		
		StringBuilder hql = new StringBuilder("");
		//拼类名
		hql.append(" from ");
		hql.append(entityClass);
		hql.append(" where deleted = 0 ");
		//拼where的参数字段
		if(!whereMap.isEmpty()) {
			for(Map.Entry<String, ValueParam> entry : whereMap.entrySet()) {
				 hql.append(" and ");
				 hql.append(entry.getKey());
				 hql.append(" ");
				 hql.append(entry.getValue().getSymbol());  //查询要用 =号还是like符号
				 hql.append(" :");
				 hql.append(entry.getKey());
			}
		}
		
		if(orderBy != null && !"".equals(orderBy)) {
			 hql.append(" order by ");
			 hql.append(orderBy);
		}
		
		String HqlStr = hql.toString();
		System.out.println("生成的search HQL:" + HqlStr);
		return HqlStr;
	}
	
	//排除已有的Mid
	public static String growSearchHqlTemplate(String entityClass, Map<String, ValueParam> whereMap, String alreadymid,String orderBy) {
		if(StringUtil.isEmpty(entityClass) || whereMap == null) {
			return "";
		}
		
		StringBuilder hql = new StringBuilder("");
		//拼类名
		hql.append(" from ");
		hql.append(entityClass);
		hql.append(" where deleted = 0 ");
		//拼where的参数字段
		if(!whereMap.isEmpty()) {
			for(Map.Entry<String, ValueParam> entry : whereMap.entrySet()) {
				 hql.append(" and ");
				 hql.append(entry.getKey());
				 hql.append(" ");
				 hql.append(entry.getValue().getSymbol());  //查询要用 =号还是like符号
				 hql.append(" :");
				 hql.append(entry.getKey());
			}
		}
		if(!StringUtil.isEmpty(alreadymid))
		{
			String notmids=" ( "+alreadymid+" ) ";
			hql.append(" and ");
			hql.append("mid not in ");
			hql.append(notmids);
		}
		
		
		
		
		if(orderBy != null && !"".equals(orderBy)) {
			 hql.append(" order by ");
			 hql.append(orderBy);
		}
		
		String HqlStr = hql.toString();
		System.out.println("生成的search HQL:" + HqlStr);
		return HqlStr;
	}
	
	//添加日期范围
	public static String growSearchHqlTemplate(String start, String end, String entityClass, Map<String, ValueParam> whereMap, String orderBy) {
		if(StringUtil.isEmpty(entityClass) || whereMap == null) {
			return "";
		}
		
		StringBuilder hql = new StringBuilder("");
		//拼类名
		hql.append(" from ");
		hql.append(entityClass);
		hql.append(" where deleted = 0 ");
		//拼where的参数字段
		if(!whereMap.isEmpty()) {
			for(Map.Entry<String, ValueParam> entry : whereMap.entrySet()) {
				 hql.append(" and ");
				 hql.append(entry.getKey());
				 hql.append(" ");
				 hql.append(entry.getValue().getSymbol());  //查询要用 =号还是like符号
				 hql.append(" :");
				 hql.append(entry.getKey());
			}
		}
		
		
		
		if(orderBy != null && !"".equals(orderBy)) {
			 hql.append(" order by ");
			 hql.append(orderBy);
		}
		
		String HqlStr = hql.toString();
		System.out.println("生成的search HQL:" + HqlStr);
		return HqlStr;
	}
	
	
	public static String modifyToCountSql(String sql) { //将sql变成计算总数的sql语句
		if(StringUtil.isEmpty(sql)) {
			return "";
		}

		StringBuilder sb = new StringBuilder("select count(1) ");
		sb.append(sql.substring(sql.indexOf("from")));
		return sb.toString();
	}
	
	
	
	
	
	public static void setQueryParam(Query query, Map<String, String> map) {  //hibernate为Query赋值
		if(!map.isEmpty()) {
			for(Map.Entry<String, String> entry : map.entrySet()) {
				query.setParameter(entry.getKey(), entry.getValue());
			}
		}
	}
	
	
	public static void setQueryParamForSearch(Query query, Map<String, ValueParam> map) {  //hibernate为Query赋值
		if(!map.isEmpty()) {
			for(Map.Entry<String, ValueParam> entry : map.entrySet()) {
				query.setParameter(entry.getKey(), entry.getValue().getValue());
			}
		}
	}	
	
}
