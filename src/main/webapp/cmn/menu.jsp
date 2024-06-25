<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>SEOUL_TRAVEL</title>
    <script src="/SEOUL_TRAVEL/assets/js/jquery_3_7_1.js"></script>
    <style>
        body {
            margin: 0;
            padding: 0;
        }
        .navbar {
            display: flex;
            align-items: center;
            padding: 10px;
            background-color: #f8f9fa;
            border-bottom: 1px solid #dee2e6;
        }
        .navbar .container {
            display: flex;
            align-items: center;
            flex-grow: 1;
        }
        .navbar-brand {
            display: flex;
            align-items: center;
        }
        .navbar-brand img {
            margin-right: 20px;
        }
        .nav {
            display: flex;
            align-items: center;
            list-style: none;
            padding: 0;
            margin: 0;
            flex-grow: 1;
        }
        .nav-item {
            margin-right: 20px;
        }
        .nav-item h4 {
            font-weight: bold;
            margin: 0;
        }
        a {
            text-decoration: none;
            color: inherit;
        }
        .login {
            margin-left: auto;
            margin-right: 20px;
            color: inherit;
        }
        .user-save {
            margin-right: 20px;
            color: inherit;
        }
        .user-info {
            margin-right: 20px;
            color: inherit;
        }
        .user-info a {
            display: block;
            padding: 10px;
            border: 1px solid #007bff;
            border-radius: 5px;
            transition: background-color 0.3s ease;
            color: #007bff;
        }
        .user-info a:hover {
            background-color: #007bff;
            color: #fff;
            text-decoration: none;
        }
    </style>
<script>
document.addEventListener("DOMContentLoaded", function(){

  <% if(session.getAttribute("user")!=null){ %>
    //로그 아웃   
	  let logout = document.createTextNode('로그아웃');
	  let logoutA = document.createElement("a");
	  let hrefNode = document.createAttribute("href");
	  let h4 = document.createElement("h4");
	  
	  hrefNode.value="/SEOUL_TRAVEL/resources/pages/main/mainpage.jsp";
	  logoutA.setAttributeNode(hrefNode);
	  h4.appendChild(logout);
	  logoutA.appendChild(h4);
	  
	  document.querySelector(".login").appendChild(logoutA);
	  
	  const sessionBtn = document.querySelector(".login a");
	  console.log('sessionBtn');
	  
	  //이벤트
	  sessionBtn.addEventListener('click',function(){
	    console.log('sessionBtn click');
	    
	    if(false==confirm('로그아웃 하시겠습니까?')){
	    	return;
	    }
	    
	    $.ajax({
            type: "POST", 
            url:"/SEOUL_TRAVEL/user/login.do",
            asyn:"true",
            dataType:"html",
            data:{
                "work_div":"logout"
        },success:function(data){
            console.log("success data:"+data);
            location.reload();
        },
        error: function(data){
          console.log("error:" + data);
        }
      });
    });

  <% } else { %>
    // 회원 가입
    const userSave = document.querySelector(".user-save");
    console.log(userSave);
    userSave.innerHTML = '<a href="/SEOUL_TRAVEL/resources/pages/user/userSave.jsp"><h4>회원가입</h4></a>';

    // 로그인
    let login = document.createTextNode('로그인');
    let loginA = document.createElement("a");
    let hrefNode = document.createAttribute("href");
    let h4 = document.createElement("h4");

    hrefNode.value="/SEOUL_TRAVEL/resources/pages/user/login.jsp";
    loginA.setAttributeNode(hrefNode);
    h4.appendChild(login);
    loginA.appendChild(h4);

    document.querySelector(".login").appendChild(loginA);
  <% } %> 
});
</script>
</head>
<body>
    <nav class="navbar">
        <div class="container">
            <a class="navbar-brand" href="/SEOUL_TRAVEL/resources/pages/main/mainpage.jsp">
                <img src="/SEOUL_TRAVEL/images/logo.png" alt="Bootstrap" width="130" height="80">
            </a>
            <ul class="nav">
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="/SEOUL_TRAVEL/content/content.do?work_div=doRetrieve"><h4>관광</h4></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/SEOUL_TRAVEL/content/content.do?work_div=doRetrieve2"><h4>맛집</h4></a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/SEOUL_TRAVEL/resources/pages/review/review_list.jsp"><h4>리뷰</h4></a>
                </li>
            </ul>
            <div class="user-save"></div>
            <div class="login"></div>
        </div>
    </nav>
</body>
</html>
