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
	
	// 전역 변수 
	var page = 1; // 현재페이지
	var totalpage =0; //의미없는 초기화이지만 하도록 함 // 전체 페이지 개수 
	var timerId;  // 의미없는 초기화 // setTimeout() 타이머 함수의 반환값
	
	// DB에서 목록을 가져오는 함수 
	function fnGetEmployees() {
		// 목록 숨기기 
		$('.employees').hide(); 
		// 로딩 보여주기 
		$('.loading_wrap').show();
		// 목록을 가져오는 ajax 처리 
		$.ajax({
			// 요청
			type: 'get',
			url: '${contextPath}/employees/scroll.do',
			data: 'page=' + page, // page=1, page=2, page=3, ...으로 동작 
			
			//응답 
			dataType: 'json', //맵을 잭슨라이브러리를 통해서 제이슨으로 바꿀 수 있음. 우리는 라이브러리를 항상 가지고 있음.
			success: function(resData) { // 에러없이 진행하겠음. // resData={"employees": [{}, {}, {}, ...], "totalPage": 12} 한사람당 객체 하나씩 가지고 있음.
				//전체 페이지 개수를 전역 변수 totalPage에 저장
				totalPage = resData.totalPage;
				// 한번 스크롤을 통해서 목록을 9개씩 가져올때마다 페이지가 증가해야한다. 
				page++;
				 // 화면에 뿌리기 
				//$.each(배열, function(인덱스,요소){}) //제이쿼리 반복문이 each
				$.each(resData.employees, function(i, employee){
					let str = '<div class="employee">';
					str += '<div>사원번호: ' + employee.employeeId + '</div>';
					str += '<div>사원명:' + employee.firstName + ' ' + employee.lastName + '</div>';
					str += '<div>부서명: ' + employee.deptDTO.departmentName + '</div>';
					str +='</div>'; //스크립트는 닫는거 안해도 됨. 그렇지만 정확하게 하기위해 닫았음. 
					$('.employees').append(str);
				})
				// 목록 보여주기 
				$('.employees').show();
				//로딩 숨기기 
				$('.loading_wrap').hide();
			}
		})
	} // fnGetEmployees 

		//함수 호출(스크롤 이벤트 이전 첫 목록을 가져온다)
		fnGetEmployees();
	
		/*

		$(window).on('scroll', function({
			let scrollTop = $(this).scrollTop(); // this가 스크롤? // 스크롤 된 길이 
			let windowHeight = $(this).height(); // 화면 높이(브라우저의 크기)
			let documentHeight = $(document).height(); // 문서 높이 -> 이때 스크롤이 바닥을 찍음. 
			if((scrollTop + windowHeight + 50) >= documentHeight) { // 스크롤이 바닥에 닿기 전 50px 정도 위치 (스크롤이 충분히 바닥까지 내려왔음)
				fnGetEmployees();
			}
		})
		*/
		// 스크롤 이벤트 
	  $(window).on('scroll', function(){
		  
		  if(timerId) { // 언디파인드에서if를만나면 false로 인식. 동일한 요청을 방지함. 이게 없으면 동일한 요청이 두번이상 발생하게 됨. 
			  
			  clearTimeout(timerId); // setTimeout()이 동작했다면(목록을 가져왔다면) setTimeout()의 재동작을 취소한다. (동일 목록을 가져오는 것을 방지한다.)
			  
		  }
		  
		 // 200밀리초(0.2초) 후에 function()을 수행한다. 
		  timerId = setTimeout(function(){
		      let scrollTop = $(this).scrollTop();    // 스크롤 된 길이 // this = 화면 전체
		      let windowHeight = $(this).height();   // 화면 높이(브라우저의 크기)
		      let documentHeight = $(document).height();   // 문서 높이
		      if((scrollTop + windowHeight + 50) >= documentHeight) {      // 스크롤이 바닥에 닿기 전 50px 정도 위치(스크롤이 충분히 바닥까지 내려왔음.)
		      	if(page <= totalPage) { // 마지막 페이지를 보여준 상태에서는 스크롤이 이동해도 더이상 요청하지 않는다. 
		      		//최종로딩숨기기 
		      		fnGetEmployees();
		      	}   
	     	 }
	  }, 200); // 시간 결정을 각자 알아서 임의로 조정해도 된다. 
   })
   
</script>
<style>

	div {
		box-sizing: border-box; /* 여백이 많아도 여백이 영향을 받지 않음. */
		
	}
	.employees {
		width: 1000px;
		margin: 0 auto;
		display: flex;
		flex-wrap: wrap;
	}
	.employee{
		width: 300px;
		height: 300px;
		border: 1px solid gray;
		margin: 10px;
		text-align: center;
		padding-top: 120px; /* 세로가운데 효과 */
		
	}
	
	.loading_wrap {
		display: flex;            /* justify-content, align-items 속성 사용을 위해 설정 */
		justify-content: center;  /* class="loading"의 가로 가운데 정렬 */
		align-items: center;      /* class="loading"의 세로 가운데 정렬 */
		min-height: 80vh;         /* 최소 높이를 화면 높이의 80%로 설정 */
	}
	.loading {
		width: 300px;
		height: 300px;
		background-image: url('../resources/images/loading.gif');
		background-size: 300px 300px;
		background-repeat: no-repeat;
	}
	.blind2 { /* 반드시 .loading_wrap 이후에 작성 */
		display: none;
	
	}
	
</style>

</head>
<body>
	<!-- 에이작특징 : 만들어서 보여주는 것. -->
	<div>
	<a href="${contextPath}/employees/search.do">사원 조회화면으로 이동</a>
	<!-- 조회 화면으로 이동.  -->	
	</div>
		
	<h1>사원 목록</h1>
	
	<!-- 사원 목록 보여주는 곳 모델을 이용해서 포워드 하는 방식이 아님 값을 전달해줘야 함 에이작들은 화면으로 넘길때 값을 넘긴다. 객체를 넘길수도 있고 맵을 넘길수도 있고 우리는 여기서 어레이리스트를 보내고 싶다. --> 
	<div class="employees">
		
	</div>
	
	<!-- loading.gif 보여주는 곳  -->
	<div class="loading_wrap">
		<div class="loading"></div>
	</div>
</body>
</html>