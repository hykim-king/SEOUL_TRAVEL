<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/cmn/common.jsp" %>    
<%@page import="java.util.List"%>
<%@page import="com.pcwk.tvl.user.UserDao"%>
<%@page import="com.pcwk.tvl.user.UserDTO"%>
<%@page import="com.pcwk.ehr.cmn.SearchDTO"%>
<%@page import="com.pcwk.ehr.cmn.StringUtil"%>

<%
    List<UserDTO> userList = (List<UserDTO>)request.getAttribute("userList");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="/SEOUL_TRAVEL/assets/css/bootstrap.css">
<title>✈︎관리자_회원 목록✈︎</title>
<link rel="stylesheet" href="/SEOUL_TRAVEL/assets/css/poster.css">
<script src="/SEOUL_TRAVEL/assets/js/jquery_3_7_1.js"></script>
<script>
document.addEventListener("DOMContentLoaded",function(){
    console.log("reviewtUploaded");
    // 페이지 로드 후 자동으로 회원 목록을 불러오는 함수 호출
    ajaxdoRetrieve();
});

function ajaxdoRetrieve() {
    $.ajax({
        type: "POST",
        url: "/SEOUL_TRAVEL/admin/admin.do", // 올바른 URL 사용
        async: true,
        dataType: "json",
        data: {
            "work_div": "doRetrieve",
            "ajax": true
        },
        success: function(response) { // 통신 성공
            console.log("success response:", response);            
                var uList = $('#userTable tbody');
                uList.empty(); // 테이블 내용 초기화
                
                // response에서 댓글 목록 배열(uList) 추출
                var userList = response;

                if (userList.length > 0) {
                    userList.forEach(function(user) {
                        // 각 회원 정보를 테이블에 추가합니다.
                    var userRow = $("<tr></tr>");
                    userRow.addClass("user-row");

                    // 작성자 정보 영역 생성
                    var userWriter = $("<td></td>");
                    userWriter.addClass("user-writer");
                    userWriter.text(user.userName);

                    // 작성일 정보 생성
                    var userEmail = $("<td></td>");
                    userEmail.addClass("user-email");
                    userEmail.text(user.userEmail); // 리뷰 작성일 추가

                    // 회원 내용 정보 생성
                    var userId = $("<td></td>");
                    userId.addClass("user-Id");
                    userId.html(user.userId); // HTML 태그 인식을 위해 html() 사용

                    // 작성자 정보, 리뷰 내용, 작성일(수정일)을 댓글 행에 추가
                    userRow.append(userWriter);
                    userRow.append(userEmail);
                    userRow.append(userId);

                    // 리뷰 행을 리뷰 목록에 추가
                    uList.append(userRow);
                    });
                } else {
                    // 회원이 없을 경우 메시지를 표시합니다.
                    var row = '<tr><td colspan="4">회원이 없습니다.</td></tr>';
                    uList.append(row);
                }

        },
        error: function(data) { // 실패 시 처리
            console.error("error:", data);
            var tbody = $('#userTable tbody');
            var row = '<tr><td colspan="4">회원 목록을 불러오는 데 실패했습니다.</td></tr>';
            tbody.append(row);
        }
    });
}



// 회원 상세 정보 페이지로 이동하는 함수
function viewUser(userId) {
    let frm = document.getElementById("userForm");
    frm.action = "<%=request.getContextPath()%>/admin/admin_detail.jsp"; // 상세 정보 페이지로 이동할 경로 지정
    frm.userId.value = userId; // 폼 데이터 설정
    frm.submit(); // 폼 전송
} 

</script>
</head>
<body>
<div class="container">
    <div class="page-header mb-4">
        <h2>🜸회원 목록</h2>
    </div>   
   <!-- 회원 목록을 표시할 테이블 -->
    <table id="user-list" class="user-table">
        <thead>
            <tr>
                <th>아이디</th>
                <th>이메일</th>
                <th>이름</th>
 
            </tr>
        </thead>
        <tbody>

        </tbody>
    </table>
</div>
    
    <!-- 페이징 기능을 추가할 예정입니다. -->

</div>

<!-- 회원 상세 정보를 전달할 폼 -->
<form id="userForm" method="post" style="display:none;">
    <input type="hidden" name="userId" id="userId">
</form>

<script src="/SEOUL_TRAVEL/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
