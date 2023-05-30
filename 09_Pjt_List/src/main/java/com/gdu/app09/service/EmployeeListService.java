package com.gdu.app09.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.ui.Model;

public interface EmployeeListService {
	
	public void getEmployeeListUsingPagination(HttpServletRequest request, Model model);
	public Map<String, Object> getEmployeeListUsingScroll(HttpServletRequest request);
	public void getEmployeeListUsingSearch(HttpServletRequest request, Model model);
	//에이작 사용하는 서비스 - 에이작은 반환하는게 화면? 가지고온 목록을 그대로 페이지변화 없이 반환하는 것. 리스펀스엔티티쓸게아니면 맵을 사용하는게 좋고 리스펀스엔티티쓸거면 만들어서 맵을 안에 넣어주면 됨 
	public Map<String, Object> getAutoComplete(HttpServletRequest request);
}
