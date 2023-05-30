<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${contextPath}/resources/js/lib/jquery-3.6.4.min.js"></script>  <!-- 이걸 제일 위에 두고 나머지 아래 배치 -->
<script>
	$(function(){
		// recordPerPage의 변경 
		$('#recordPerPage').on('change', function(){
		  location.href ='${contextPath}/employees/change/record.do?recordPerPage=' + $(this).val(); // session에 올리기 recordPerPage
		})
		// 세션에 저장된 recordPerPage 값으로 <select> 태그의 값을 세팅
		let recordPerPage = '${sessionScope.recordPerPage}' == '' ? '10' : '${sessionScope.recordPerPage}';
		$('#recordPerPage').val(recordPerPage);
		// 제목을 클릭하면 정렬 방식을 바꿈 
		$('.title').on('click', function(){
			location.href = '${contextPath}//employees/pagination.do?column='+ $(this).data('column')+'&order=' + $(this).data('order') + "&page=${page}"; /* 현재 정렬이 무엇인지 알아야 넘겨줄 수 있어야 함. 페이지 번호를 어떻게 넘길것인가도 고려해야함. 디스는 제이쿼리 객체가 아니므로 (자바스크립트거임) 제이쿼리 랩퍼로 묶어줘야함*/	
		})
	})
</script>
<style>
	.title {
		cursor: pointer;
	}
	.title:hover {
		color: gray;
	}
	.title:active {
		color: silver;
	}
	.pagination {
	
		width: 350px;
		margin: 0 auto;
		text-align: center;
	
	}
	.pagination span, .pagination a {
		display: inline-block;
		width: 50px;
	}
	.hidden{
			visibility: hidden;
	}
	.strong {
	 		font-weight: 900;
	}
	.link {
	 	color: orange;
	}
	table { /*  너비고정.  */
		width: 1500px; 
	}
	table td:nth-of-type(1) { width: 60px;  }
	table td:nth-of-type(2) { width: 100px; }
	table td:nth-of-type(3) { width: 150px; }
</style>
</head> <!-- 페이지네이션은 목록 하단에 번호 이전 이후 이런거 있는것.  -->
<body>
	<div>
	<a href="${contextPath}/employees/search.do">사원 조회화면으로 이동</a>
	<!-- 조회 화면으로 이동.  -->	
	</div>
	
	<div>
		<h1>사원 목록</h1>
		<div> <!-- 세션은 저장해두면 언제든 꺼내서 쓸 수 있음. 기본 사용시간은 30분으로 되어있지만 마음만 먹으면 바꿀 수 있음. -->
			<select id="recordPerPage"> <!-- 레코드 퍼 페이지 : 셀렉트값이 체인지되었다는 체인지이벤트가 필요함 -->
				<option value="10">10개</option> <!-- 디폴트 값이 될것. -->
				<option value="20">20개</option>
				<option value="30">30개</option>
			</select>
		</div>
		<hr> <!-- 프로젝트 할때는 hr 넣지 말고 css 진행하면 됨  -->
		<table border="1">
			<thead>
				<tr>
					<td>순번</td> <!-- 순번은 정렬대상 아님 -->
					<td><span class="title" data-column="E.EMPLOYEE_ID" data-order="${order}">사원번호</span></td> <!-- 이거 누르면 사원번호 정렬 됨  -->
					<td><span class="title" data-column="E.FIRST_NAME" data-order="${order}">사원명</span></td>
					<td><span class="title" data-column="E.EMAIL" data-order="${order}">이메일</span></td>
					<td><span class="title" data-column="E.PHONE_NUMBER" data-order="${order}">전화번호</span></td>
					<td><span class="title" data-column="E.HIRE_DATE" data-order="${order}">입사일자</span></td>
					<td><span class="title" data-column="E.JOB_ID" data-order="${order}">직업</span></td> <!-- jopId  -->
					<td><span class="title" data-column="E.SALARY" data-order="${order}">연봉</span></td>
					<td><span class="title" data-column="E.COMISSION_PCT" data-order="${order}">커미션</span></td>
					<td><span class="title" data-column="E.MANAGER_ID" data-order="${order}">매니저</span></td>
					<td><span class="title" data-column="E.DEPARTMENT_ID" data-order="${order}">부서번호</span></td>
					<td><span class="title" data-column="D.DEPARTMENT_NAME" data-order="${order}">부서명</span></td>  
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${employees}" var="emp" varStatus="vs"> <!-- 하나씩 뺐을때 emp // 인덱스 vs 변수는 내가 알아서 주면 됨 -->
					<tr>
						<td>${beginNo - vs.index}</td> 
						<td>${emp.employeeId}</td> <!-- empDTO에 있는 필드명  -->
						<td>${emp.firstName} ${emp.lastName}</td> <!-- 사원이름 퍼스트 라스트 공백사이 두고 같이 씀  -->
						<td>${emp.email}</td>
						<td>${emp.phoneNumber}</td>
						<td>${emp.hireDate}</td>
						<td>${emp.jobId}</td>
						<td>${emp.salary}</td>
						<td>${emp.commissionPct}</td>
						<td>${emp.managerId}</td>
						<td>${emp.deptDTO.departmentId}</td>
						<td>${emp.deptDTO.departmentName}</td> <!-- 부서명은 어떻게 처리할 것인가? EmpDTO에서 처리 완료. -->
					</tr>
				</c:forEach>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="12">
						<div>${pagination}</div> <!--해당 div는 css 해야할지 몰라서 일단 넣어 놓은 것. 참고하세요.  -->
					</td>
				</tr>
			</tfoot>
		</table>
	</div>
</body>
</html>