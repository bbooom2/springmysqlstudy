package com.gdu.app09.domain;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EmpDTO {
	
	private int employeeId;
	private String firstName;
	private String lastName;
	private String email;
	private String phoneNumber;
	private Date hireDate;
	private String jobId;
	private double commissionPct;
	private double salary; //소수점은 없으나 강사가 그냥 이대로 한다함.
	private int managerId;
	//private int departmentId; // 원래 부서번호가 맞는데 FK여서 참조시킬것. 
	private DeptDTO deptDTO; // 이렇게 하면 DeptDTO에서의 departmentName 가져올수있음.
	// 오늘 수업의 목표 : 조인, 셀렉트 

}
