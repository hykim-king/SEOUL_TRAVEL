<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file = "/cmn/common.jsp" %>
<%@page import="java.util.List"%>
<%@page import="com.pcwk.tvl.review.ReviewDTO"%>
<%@page import="com.pcwk.tvl.review.ReviewDao"%>
<%@page import="com.pcwk.tvl.review.ReviewService" %>
<%
    // Dummy data for demonstration. Replace with actual data from your servlet/controller.
    List<ReviewDTO> list = (List<ReviewDTO>) request.getAttribute("list");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>리뷰 목록</title>
<link rel="stylesheet" href="/SEOUL_TRAVEL/assets/css/bootstrap.css">
<script src="/SEOUL_TRAVEL/assets/js/jquery_3_7_1.js"></script>
<script src="/SEOUL_TRAVEL/assets/js/bootstrap.bundle.min.js"></script>
<style>
    .review-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
    }
    .review-table th, .review-table td {
        border: 1px solid #ddd;
        padding: 8px;
    }
    .review-table th {
        background-color: #f2f2f2;
        text-align: left;
    }
    .pagination {
        display: flex;
        justify-content: center;
        margin-top: 20px;
    }
    .pagination a {
        margin: 0 5px;
        padding: 10px 15px;
        border: 1px solid #ddd;
        text-decoration: none;
        color: #007bff;
    }
    .pagination a.active {
        background-color: #007bff;
        color: white;
        border-color: #007bff;
    }
</style>
<script>
    document.addEventListener("DOMContentLoaded", function(){
        ajaxdoRetrieve(1); // 첫 페이지 로드
    });

    function ajaxdoRetrieve(pageNumber) {
        $.ajax({
            type: "POST",
            url: "/SEOUL_TRAVEL/review/review.do",
            dataType: "json",
            data: {
                "work_div": "getReviews",
                "aboardSeq": 1,
                "ajax": true,
                "pageNumber": pageNumber,
                "pageSize": 10 // 한 페이지에 표시할 리뷰 수
            },
            success: function(response) {
                console.log("success response: ", response);
                var reviewList = $("#review-list tbody");
                reviewList.empty(); // 기존 리뷰 목록 초기화

                var rList = response.reviews;
                var totalReviews = response.totalReviews;
                var pageSize = 10;

                if (rList.length > 0) {
                    rList.forEach(function(review) {
                        var reviewRow = $("<tr></tr>");
                        reviewRow.addClass("review-row");
                        
                        var reviewSeq = $("<td></td>");
                        reviewSeq.addClass("review-seq");
                        reviewSeq.text(review.aboardSeq);

                        var reviewTitle = $("<td></td>");
                        reviewTitle.addClass("review-comments");
                        var reviewLink = $("<a></a>");
                        reviewLink.attr("href", "review_detail.jsp?aboardSeq=" + review.aboardSeq);
                        reviewLink.text(review.title);
                        reviewTitle.append(reviewLink);

                        var reviewWriter = $("<td></td>");
                        reviewWriter.addClass("review-writer");
                        reviewWriter.text(review.userId);

                        var reviewDate = $("<td></td>");
                        reviewDate.addClass("review-regDt");
                        reviewDate.text(review.regDt);
                        var reviewLikes = $("<td></td>");
                        reviewLikes.addClass("review-likes");
                        reviewLikes.text(review.likeCount || 0); // 추천 수 표시

                        reviewRow.append(reviewSeq);
                        reviewRow.append(reviewTitle);
                        reviewRow.append(reviewWriter);
                        reviewRow.append(reviewDate);
                        reviewRow.append(reviewLikes); // 추천 수 추가


                        reviewList.append(reviewRow);
                    });
                }

                var totalPages = Math.ceil(totalReviews / pageSize);
                var pagination = $(".pagination");
                pagination.empty();

                for (var i = 1; i <= totalPages; i++) {
                    var pageLink = $("<a></a>");
                    pageLink.text(i);
                    pageLink.attr("href", "#");
                    if (i == pageNumber) {
                        pageLink.addClass("active");
                    }
                    pageLink.on("click", function(e) {
                        e.preventDefault();
                        ajaxdoRetrieve($(this).text());
                    });
                    pagination.append(pageLink);
                }
            },
            error: function(error) {
                console.log("Error:", error);
            }
        });
    }
    function ajaxGetLikeCount(aboardSeq) {
        return $.ajax({
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
                return response;
            },
            error: function(error) {
                console.log("Error:", error);
                return 0;
            }
        });
    }
</script>
</head>
<body>
    <header>
        <jsp:include page="/cmn/menu.jsp"></jsp:include>
    </header>

    <main>
        <div class="container">
            <h2>리뷰 목록</h2>
            <input type="button" value="등록" class="btn btn-primary" onclick="location.href='/SEOUL_TRAVEL/resources/pages/review/review_write.jsp'">
             <%
        ReviewService reviewService = new ReviewService();
        List<ReviewDTO> reviewList = reviewService.getAllReviews();
    		%>
            <table id="review-list" class="review-table">
                <thead>
                    <tr>
                    	<th>번호</th>
                        <th>제목</th>
                        <th>작성자</th>
                        <th>작성일</th>
                        <th>추천수</th>
                    </tr>
                </thead>
                <tbody>
                
                </tbody>
            </table>
            <div class="pagination">
                <!-- 페이징 링크가 동적으로 추가될 영역 -->
            </div>
        </div>
    </main>

    <jsp:include page="/cmn/footer.jsp"></jsp:include>

    <script>
        let slideIndex = 0;
        const slides = document.querySelectorAll('.slide');
        const totalSlides = slides.length;

        function showSlides() {
            slides.forEach((slide, index) => {
                slide.style.transform = `translateX(${(index - slideIndex) * 100}%)`;
            });
        }

        function nextSlide() {
            slideIndex = (slideIndex + 1) % totalSlides;
            showSlides();
        }

        setInterval(nextSlide, 3000); // 3초마다 슬라이드 넘김

        document.addEventListener('DOMContentLoaded', showSlides);
    </script>
</body>
</html>
