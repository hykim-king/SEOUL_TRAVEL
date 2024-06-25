<%@page import="com.pcwk.tvl.user.UserDTO"%>
<%@page import="com.pcwk.tvl.comment.CommentDTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "/cmn/common.jsp" %>
<%
    // Dummy data for demonstration. Replace with actual data from your servlet/controller.
    String reviewTitle = "Sample Review Title";
    String reviewContent = "This is the content of the sample review. It has some details about the review.";
    String reviewAuthor = "Author Name";
    String reviewDate = "2024-06-18";
    String message = (String) request.getAttribute("message");

    List<CommentDTO> comments = (List<CommentDTO>) request.getAttribute("comments");
    
    
    
    String userId = null;
    if(session.getAttribute("user")!=null){
        UserDTO outVO = (UserDTO) session.getAttribute("user");
        userId = outVO.getUserId();
    }
    
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="/SEOUL_TRAVEL/assets/css/bootstrap.css">
<title>Seoul Travel - Review Detail</title>
<script src="/SEOUL_TRAVEL/assets/js/jquery_3_7_1.js"></script>
<script>
	document.addEventListener("DOMContentLoaded",function(){
		const urlParams = new URLSearchParams(window.location.search);
		const aboardSeq = urlParams.get('aboardSeq');
		const workDiv = document.querySelector("#work_div");//작업구분
		const saveCommentBtn = document.querySelector("#saveComment");
		const getCommentsBtn = document.querySelector("#getComments");
		const comments = document.querySelector("#comments");
		/* const userId = document.querySelector("#userId"); */
		const comSeq = document.querySelector("#comSeq");
		ajaxdoSelectOne();
		ajaxGetComments(aboardSeq);
		// 추천 버튼 클릭 시
        
        
   	 
	        saveCommentBtn.addEventListener("click", function() {
	            const commentContent = document.querySelector("#commentContent").value;
	            ajaxCommentSave(userId, aboardSeq, commentContent);
	        });
	    

	        ajaxGetLikeCount();
	        var userId = "<%= userId %>";
	        var liked = false; // 추천 상태를 저장하는 변수
	        updateLikeButton();
	        
		    // 추천 버튼 클릭 시 동작
		    $("#likeBtn").click(function() {
		    <% if(userId != null) { %>
		        if (!liked) {
		            ajaxDoLike(); // 추천 추가
		        } else {
		            ajaxDoLikeDelete(); // 추천 취소
		        }
		    <% } else { %>
		        alert("로그인 후 가능합니다.");
		    <% } %>
			});

		 // 추천 상태에 따라 버튼을 업데이트하는 함수
		    function updateLikeButton() {
		        ajaxGetLikeStatus(); // 추천 상태 확인 Ajax 호출
		    }

		    // 추천 상태를 가져오는 Ajax 함수
		    function ajaxGetLikeStatus() {
		        $.ajax({
		            type: "POST",
		            url: "/SEOUL_TRAVEL/review/review.do",
		            dataType: "json",
		            data: {
		                "work_div": "getLikeStatus",
		                "aboardSeq": aboardSeq,
		                "userId": userId,
		                "ajax": true
		            },
		            success: function(response) {
		                liked = response.liked; // 서버에서 받아온 추천 상태 업데이트
		                updateLikeButtonUI(); // 버튼 UI 업데이트
		                
		            },
		            error: function(error) {
		                console.log("Error:", error);
		            }
		        });
		    }

		    // 추천 버튼 UI 업데이트 함수
		    function updateLikeButtonUI() {
		        var likeBtn = $("#likeBtn");
		        if (liked) {
		            likeBtn.text("추천 취소"); // 추천 취소 상태로 변경
		            likeBtn.addClass("btn-danger"); // 추천 취소 스타일
		        } else {
		            likeBtn.text("추천"); // 추천 가능한 상태로 변경
		            likeBtn.removeClass("btn-danger"); // 추천 취소 스타일 제거
		        }
		    }

		    // 추천 추가 Ajax 함수
		    function ajaxDoLike() {
		        $.ajax({
		            type: "POST",
		            url: "/SEOUL_TRAVEL/review/review.do",
		            dataType: "html",
		            data: {
		                "userId": userId,
		                "aboardSeq": aboardSeq,
		                "work_div": "doLikeSave",
		                "ajax": true
		            },
		            success: function(response) {
		                liked = true; // 추천 추가 성공 시 추천 상태 업데이트
		                updateLikeButtonUI(); // 버튼 UI 업데이트
		                alert('추천하였습니다.');
		                ajaxGetLikeCount();
		                
		            },
		            error: function(error) {
		                console.log("Error:", error);
		            }
		        });
		    }

		    // 추천 취소 Ajax 함수
		    function ajaxDoLikeDelete() {
		        $.ajax({
		            type: "POST",
		            url: "/SEOUL_TRAVEL/review/review.do",
		            dataType: "html",
		            data: {
		                "userId": userId,
		                "aboardSeq": aboardSeq,
		                "work_div": "doLikeDelete",
		                "ajax": true
		            },
		            success: function(response) {
		                liked = false; // 추천 취소 성공 시 추천 상태 업데이트
		                updateLikeButtonUI(); // 버튼 UI 업데이트
		                alert('추천을 취소하였습니다.');
		                ajaxGetLikeCount();
		            },
		            error: function(error) {
		                console.log("Error:", error);
		            }
		        });
		    }
		    function ajaxGetLikeCount() {
		        $.ajax({
		            type: "POST",
		            url: "/SEOUL_TRAVEL/review/review.do",
		            dataType: "html",
		            data: {
		                "work_div": "doLikeCount",
		                "aboardSeq": aboardSeq,
		                "ajax": true
		            },
		            success: function(response) {
		                console.log("success:", response);
		                $("#likeCount").text(response);
		            },
		            error: function(error) {
		                console.log("Error:", error);
		            }
		        });
		    }
		});
	
	function ajaxGetComments(aboardSeq) {
	    const data = {
	        "work_div": "getComments",
	        "aboardSeq": aboardSeq,
	        "ajax": true
	    };

	    if (!validateData(data)) {
	        alert("댓글 불러오기에 실패했습니다.");
	        return;
	    }

	    $.ajax({
	        type: "POST",
	        url: "/SEOUL_TRAVEL/comment/comment.do",
	        dataType: "json",
	        data: data,
	        success: function(response) {
	            console.log("Success response", response);
	            var replyList = $("#reply-list");
	            replyList.empty();
	            var rList = response;

	            if (rList.length > 0) {
	                rList.forEach(function(reply) {
	                    var replyRow = $("<li></li>");
	                    replyRow.addClass("reply-row");

	                    var replyWriter = $("<p></p>");
	                    replyWriter.addClass("reply-writer");
	                    replyWriter.text(reply.userId);

	                    var replyDate = $("<p></p>");
	                    replyDate.addClass("reply-date");
	                    var dateLabel = reply.modDt ? "수정 " : "";
	                    var dateValue = reply.modDt ? reply.modDt : reply.regDt;
	                    replyDate.text(dateLabel + dateValue);

	                    var replyContent = $("<p></p>");
	                    replyContent.addClass("reply-content");
	                    replyContent.html(reply.content);

	                    replyRow.append(replyWriter);
	                    replyRow.append(replyContent);
	                    replyRow.append(replyDate);

	                    var updateButton = $("<button></button>");
	                    updateButton.text("수정");
	                    updateButton.addClass("btn btn-primary update-comment");
	                    updateButton.on("click", function() {
	                        if (reply.userId !== "<%= userId %>") {
	                            alert("작성자가 아닙니다.");
	                            return;
	                        }
	                        var newContent = prompt("수정할 내용을 입력하세요:", reply.content);
	                        if (newContent !== null) {
	                            ajaxUpdateComment(reply.comSeq, newContent, aboardSeq);
	                        } else {
	                            alert("취소하였습니다.");
	                        }
	                    });

	                    var deleteButton = $("<button></button>");
	                    deleteButton.text("삭제");
	                    deleteButton.addClass("btn btn-danger delete-comment");
	                    deleteButton.on("click", function() {
	                        if (reply.userId !== "<%= userId %>") {
	                            alert("작성자가 아닙니다.");
	                            return;
	                        }
	                        ajaxDeleteComment(reply.comSeq, aboardSeq);
	                    });

	                    replyRow.append(updateButton);
	                    replyRow.append(deleteButton);
	                    replyList.append(replyRow);
	                });
	            } else {
	                replyList.append("<p>댓글이 없습니다. 첫 번째 댓글을 달아보세요!</p>");
	            }
	        },
	        error: function(error) {
	            console.log("Error:", error);
	        }
	    });
	}

	function ajaxCommentSave(userId, aboardSeq, content) {
		if (isEmpty(content)) {
	        alert('댓글을 입력하세요.');
	        return;
	    }

	    if (!confirm('등록 하시겠습니까?')) {
	        alert("취소하였습니다.");
	        return;
	    }

	    const data = {
	        "work_div": "saveComment",
	        "userId": "<%= userId %>",
	        "aboardSeq": aboardSeq,
	        "content": content
	    };

	    if (!validateData(data)) {
	        alert("댓글 저장에 실패했습니다.");
	        return;
	    }

	    $.ajax({
	        type: "POST",
	        url: "/SEOUL_TRAVEL/comment/comment.do",
	        dataType: "json",
	        data: data,
	        success: function(response) {
	            alert('댓글이 등록되었습니다.');
	            location.reload();
	        },
	        error: function(error) {
	            console.log("error:", error);
	            alert("댓글 저장에 실패했습니다.");
	        }
	    });
	}
	

	function ajaxUpdateComment(comSeq, newContent, aboardSeq) {
        const data = {
            "work_div": "updateComment",
            "comSeq": comSeq,
            "aboardSeq": aboardSeq,
            "userId": "<%= userId %>",
            "content": newContent,
            "ajax": true
        };
        if (!validateData(data)) {
            alert("댓글 수정에 실패했습니다.");
            return;
        }
        $.ajax({
            type: "POST",
            url: "/SEOUL_TRAVEL/comment/comment.do",
            data: data,
            success: function(response) {
            	
                alert('수정하였습니다.');
                location.reload();
            },
            error: function(error) {
                console.log("Error:", error);
                alert("댓글 수정에 실패했습니다.");
            }
        });
    }
    function ajaxDeleteComment(comSeq, aboardSeq) {
        const data = {
            "work_div": "deleteComment",
            "comSeq": comSeq,
            "userId": "<%= userId %>",
            "aboardSeq": aboardSeq,
            "ajax": true
        };
        if (!validateData(data)) {
            alert("댓글 삭제에 실패했습니다.");
            return;
        }
        $.ajax({
            type: "POST",
            url: "/SEOUL_TRAVEL/comment/comment.do",
            dataType: "text",
            data: data,
            success: function(response) {
                alert('삭제하였습니다.');
                location.reload();
            },
            error: function(error) {
                console.log("error:", error);
                alert("댓글 삭제에 실패했습니다.");
            }
        });
    }

	function validateData(data) {
	    try {
	        JSON.stringify(data);
	        return true;
	    } catch (e) {
	        console.error("Data structure issue:", e);
	        return false;
	    }
	}

	function isEmpty(str) {
	    return (!str || str.length === 0);
	}
	
	 function ajaxdoSelectOne(aboardSeq) {
         $.ajax({
             type: "POST",
             url: "/SEOUL_TRAVEL/review/review.do",
             dataType: "json",
             data: {
                 "work_div": "doSelectOne",
                 "aboardSeq": aboardSeq,
                 "ajax": true
             },
             success: function(response) {
                 console.log("success response: ", response);
                 if (response.review) {
                     var review = response.review;

                     // 폼에 데이터 채우기
                     $("#userId").val(review.userId);
                     $("#regDt").val(review.regDt);
                     $("#title").val(review.title);
                     $("#comments").val(review.comments);
                 } else {
                     console.log("리뷰 데이터를 불러오지 못했습니다.");
                 }
             },
             error: function(error) {
                 console.log("Error:", error);
             }
         });
     }
	
		function updateLikeButton() {
		    var likeBtn = $("#likeBtn");
		    if (liked) {
		        likeBtn.text("추천 취소"); // 버튼 텍스트 변경
		        likeBtn.removeClass("btn-primary").addClass("btn-danger"); // 추천 취소 버튼 스타일 적용
		    } else {
		        likeBtn.text("추천"); // 버튼 텍스트 변경
		        likeBtn.removeClass("btn-danger").addClass("btn-primary"); // 추천 버튼 스타일 적용
		    }
		}
	
	
	
	
		
</script>
</head>
<body>
    <header>
        <jsp:include page="/cmn/menu.jsp"></jsp:include>
    </header>

   <!-- container -->
<div class="container">
  
  <!-- 제목 -->
  <div class="page-header  mb-4">
    <h2>게시-관리</h2>
  </div>
  <!--// 제목 end ------------------------------------------------------------->
  <!-- 버튼 -->
  <div class="mb-2 d-grid gap-2 d-md-flex justify-content-md-end">
      <input type="button" value="목록" class="btn btn-primary" onclick="location.href='review_list.jsp'">
      <input type="button" value="수정" class="btn btn-primary" onclick="location.href='review_write.jsp?userId=${review.userId}'">
      <input type="button" value="삭제" class="btn btn-primary" onclick="deleteReview(${review.userId})">
  </div>
  <!--// 버튼 ----------------------------------------------------------------->
  
  <!-- form -->
  <form action="#" class="form-horizontal">

    <div class="row mb-3">
        <label for="userId" class="col-sm-2 col-form-label">등록자</label>
        <div class="col-sm-10">
          <input type="text" disabled="disabled" class="form-control" name="userId" id="userId" value="${review.getUserId}">        
        </div>      
    </div>    
    <div class="row mb-3">
        <label for="regDt" class="col-sm-2 col-form-label">등록일</label>
        <div class="col-sm-10">
          <input type="text" disabled="disabled" class="form-control" name="regDt" id="regDt" value="${review.getRegDt}">        
        </div>      
    </div>        
   
    <div class="row mb-3">
        <label for="title" class="col-sm-2 col-form-label">제목</label>
        <div class="col-sm-10">
          <input type="text" class="form-control" name="title" id="title" maxlength="75" required="required" value="${review.getTitle}">
        </div>      
    </div>     
    <div class="row mb-3">
        <label for="comments" class="col-sm-2 col-form-label">내용</label>
        <div class="col-sm-10">    
         <textarea style="height: 200px" class="form-control" id="comments" name="comments">${review.getComments}</textarea>
        </div> 
    </div>    
  </form>
  <!--// form end -->
  	<div>
		 <button type="button" id="likeBtn" class="btn btn-primary">추천</button>
		 <span> <span id="likeCount"></span></span>
    </div>

         <!-- 댓글 시작 -->
        <div class="comment-section mt-5">
            <%
                if (message != null) {
            %>
                <div class="alert alert-info" role="alert">
                    <%= message %>
                </div>
            <%
                }
            %>
            <div class="comment-form mb-4">
                <form id="comment_frm" method="post">
                    <div class="form-group">
                        <label for="commentContent">댓글</label>
                        <textarea id="commentContent" name="content" class="form-control" rows="3"></textarea>
                    </div>
                    <input type="button" value="댓글 달기" class="btn btn-primary mt-2" id="saveComment">>
                </form>
                
            </div>
	        <!-- 댓글 목록 -->
	             <ul id="reply-list" class="list-unstyled">
	                <!-- AJAX를 통해 동적으로 댓글이 추가될 영역 -->
	            </ul>
	        </div>
	        <!-- //댓글 끝 -------------------------------------------->
    <jsp:include page="/cmn/footer.jsp"></jsp:include>
    </div>
    <!-- //리뷰 내용 끝 -->

    <script src="/SEOUL_TRAVEL/assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
