<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="/SEOUL_TRAVEL/assets/css/bootstrap.css">
<title>Seoul Travel - Review Detail</title>
<script src="/SEOUL_TRAVEL/assets/js/jquery_3_7_1.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const urlParams = new URLSearchParams(window.location.search);
        const aboardSeq = urlParams.get('aboardSeq');
        const userId = "<%= userId %>";

        document.querySelector("#updateBtn").addEventListener("click", function() {
            ajaxDoUpdate(aboardSeq);
        });

        document.querySelector("#deleteBtn").addEventListener("click", function() {
            ajaxDoDelete(aboardSeq);
        });

        document.querySelector("#saveComment").addEventListener("click", function() {
            const commentContent = document.querySelector("#commentContent").value;
            ajaxCommentSave(userId, aboardSeq, commentContent);
        });

        $("#likeBtn").click(function() {
            if (userId) {
                if (!liked) {
                    ajaxDoLike();
                } else {
                    ajaxDoLikeDelete();
                }
            } else {
                alert("로그인 후 가능합니다.");
            }
        });

        ajaxdoSelectOne(aboardSeq);
        ajaxGetComments(aboardSeq);
        ajaxGetLikeCount();
        updateLikeButton();
    });

    function ajaxDoUpdate(aboardSeq) {
        if (!confirm('수정 하시겠습니까?')) {
            return;
        }
        const title = $("#title").val();
        const comments = $("#comments").val();
        $.ajax({
            type: "POST",
            url: "/SEOUL_TRAVEL/review/review.do",
            data: {
                "work_div": "doUpdate",
                "aboardSeq": aboardSeq,
                "title": title,
                "comments": comments
            },
            success: function(response) {
                if (response == "success") {
                    alert("리뷰가 성공적으로 수정되었습니다.");
                    location.reload();
                } else {
                    alert("리뷰 수정에 실패했습니다.");
                }
            },
            error: function() {
                alert("에러가 발생했습니다.");
            }
        });
    }

    function ajaxDoDelete(aboardSeq) {
        if (!confirm('삭제 하시겠습니까?')) {
            return;
        }
        $.ajax({
            type: "POST",
            url: "/SEOUL_TRAVEL/review/review.do",
            data: {
                "work_div": "doDelete",
                "aboardSeq": aboardSeq
            },
            success: function(response) {
                if (response == "success") {
                    alert("리뷰가 성공적으로 삭제되었습니다.");
                    window.location.href = "review_list.jsp";
                } else {
                    alert("리뷰 삭제에 실패했습니다.");
                }
            },
            error: function() {
                alert("에러가 발생했습니다.");
            }
        });
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
                if (response.review) {
                    var review = response.review;
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

    function ajaxGetComments(aboardSeq) {
        const data = {
            "work_div": "getComments",
            "aboardSeq": aboardSeq,
            "ajax": true
        };

        $.ajax({
            type: "POST",
            url: "/SEOUL_TRAVEL/comment/comment.do",
            dataType: "json",
            data: data,
            success: function(response) {
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
                            if (reply.userId !== userId) {
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
                            if (reply.userId !== userId) {
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
            "userId": userId,
            "aboardSeq": aboardSeq,
            "content": content
        };

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
            "userId": userId,
            "content": newContent,
            "ajax": true
        };

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
            "userId": userId,
            "aboardSeq": aboardSeq,
            "ajax": true
        };

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

    function isEmpty(str) {
        return (!str || str.length === 0);
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
      <input type="button" value="수정" class="btn btn-primary" id="updateBtn">
      <input type="button" value="삭제" class="btn btn-primary" id="deleteBtn">
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
            <% if (message != null) { %>
                <div class="alert alert-info" role="alert">
                    <%= message %>
                </div>
            <% } %>
            <div class="comment-form mb-4">
                <form id="comment_frm" method="post">
                    <div class="form-group">
                        <label for="commentContent">댓글</label>
                        <textarea id="commentContent" name="content" class="form-control" rows="3"></textarea>
                    </div>
                    <input type="button" value="댓글 달기" class="btn btn-primary mt-2" id="saveComment">
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
