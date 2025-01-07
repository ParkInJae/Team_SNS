<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/nav.jsp" %>
<%@ page import="sns.vo.* "%>
<%@ page import="sns.util.* "%>
<%
	PagingUtil paging = (PagingUtil)request.getAttribute("paging");
	ArrayList<BoardVO> board = (ArrayList<BoardVO>)request.getAttribute("board");
%>
<script>
// post 방식으로 보내야하기 때문에 onclick 할 때 함수 안에 ajax를 사용해야함
function stateFn(bno,state){
	// 값을 가져왔나 확인 
	// 만약 가져오지 않았다면, controller에서 vo에 담겨져 있는지 확인해야함
	console.log(bno);
	console.log(state);
	$.ajax({
		url : "admin/stopBoard.do",
		type : "post",
		data : {
			// 보내야 할 데이터를 담음 
			"bno" : bno,
			"state" : state
		},
		success: function(response){
			alert("상태가 변경되었습니다.");
			// 페이지 새로 고침으로 상태 갱신
            location.reload(); 
		},
		error: function(xhr, status, error) {
            // 에러 처리
            console.error("오류 발생:", error);
            alert("상태 변경에 실패했습니다.");
        } 
	});
}

function titleViewFn(bno) {
    console.log(bno); // 확인용
    $.ajax({
    	// HTML 응답을 반환하는 Controller 경로
        url: "<%= request.getContextPath() %>/board/view.do",  
        type: "GET",
        data: { "bno": bno },
        success: function(response) {
            // 모달에 가져온 HTML을 넣음
            $('#modalBody').html(response);
            
            // 모달을 보여줌
            $('#modal').show();
            
            $('script').each(function() {
                if (this.src) {
                    $.getScript(this.src);
                } else {
                    eval($(this).text());
                }
            });
            loadReco(bno);
            loadComplain(bno);
            DarkMode();
        },
        error: function(xhr, status, error) {
            console.error("오류 발생:", error);
            alert("게시글을 불러오지 못했습니다.");
        } 
    });
}

// 모달 닫기 함수
$(window).click(function(event) {
	    if ($(event.target).is("#modal")) {
	        $("#modal").fadeOut(); // 모달 창 숨기기
	    }
	});



</script>
<!--웹페이지 본문-->
<section>
       <div class="bcSpan">
           <a href="<%= request.getContextPath() %>/admin/blackList.do" 
           style="font-size:24px; color: gray; text-decoration-line:none;">블랙리스트</a>
           &nbsp;
           <a href="<%= request.getContextPath() %>/admin/complainList.do" 
           style="font-size:24px; text-decoration: underline;  text-underline-offset: 6px; color:#333333;">신고게시글</a>
       </div>
        <% for(BoardVO vo : board){ %> 
           <input type="hidden" name="bno" id ="bno" value="<%=vo.getBno()%>">
       	   <input type="hidden" name="state" id ="state" value="<%=vo.getState()%>">  
          <%}%>
       <div class="complainTable">
         
           <table class="inner_table" style="border-collapse: collapse;">
               <thead>
               	<tr>
                   <!-- <th>신고 글 번호</th> -->
                   <th>닉네임</th>
                   <th>제목</th>
                   <th>작성일</th>
                   <th>신고 횟수</th>
                   <th>활성화 여부</th>
                 </tr>
               </thead>
              <tbody>
               <% for(BoardVO vo : board){ %>
                   <tr class="cTr">
                       	<%-- <td><%=vo.getBno() %></td> --%>
                       	<%-- <td><%= vo.getBno()%></td> --%>
                       	<td><%=vo.getUnick() %></td>
                       	<td onclick ="titleViewFn(<%=vo.getBno()%>)" style="cursor:pointer;"><%=vo.getTitle() %></td>
                       	<td><%=vo.getRdate() %></td>
                       	<td><%=vo.getDeclaration() %></td>
                       <%
                       if(vo.getState().equals("E") ){
                    	%>	   
                   	   <td>
                       		<button type="button" class="ssBtn" onclick="stateFn(<%=vo.getBno()%>,'E')">비활성화</button>
                       </td>
                     	<%
                     	}else{
                    	%> 
                   	    <td>
                       		<button type="button" class="ssBtn" 
                       		style="background-color:#767676; color:white;" onclick="stateFn(<%=vo.getBno()%>,'D')">활성화</button>
                       </td>
                       <%
                       }
                       %>
                <% } %>
                   </tr>
               </tbody>
           </table>
   
       </div>
       <%--  <%
		if(paging.getStartPage() >1){
	%>
		<a href="complainList.do?nowPage=<%=paging.getStartPage()-1%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>">&lt;</a>
	<%
		}
	%>
	
	<!-- 시작 페이지 번호(pagingUtil->startPage)부터 종료 페이지 번호(paginUtil->endPage)까지-->
	<%
		for(int i=paging.getStartPage();
				i<=paging.getEndPage();i++){
			if(i == paging.getNowPage()){ //출력하는 페이지 번호와 현재페이지 번호가 같은 경우
	%>
		<span style="text-align:center;"><strong><%=i %></strong></span>
	<%	
			}else{
	%>
		<a href="complainList.do?nowPage=<%= i %>&searchType=<%=searchType%>&searchValue=<%=searchValue%>"><%= i %></a>
	<%		
			}
		}
	%>
	<!-- 다음페이지로 이동 링크(pagingUtil->endPage lastPage보다 작으면 출력) -->
	<%
		if(paging.getEndPage() < paging.getLastPage()){
	%>
		<a href="complainList.do?nowPage=<%=paging.getEndPage()+1%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>">&gt;</a>
	<%		
		}
	%> --%>
       
</section>
<%@ include file="../include/aside.jsp" %>