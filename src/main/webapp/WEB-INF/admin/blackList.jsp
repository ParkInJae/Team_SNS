<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/nav.jsp" %>
<%@ page import="sns.vo.* "%>
<%@ page import="sns.util.* "%>
<%
	PagingUtil paging = (PagingUtil)request.getAttribute("paging");
	ArrayList<UserVO> list = (ArrayList<UserVO>)request.getAttribute("list");
%>
<script>
// post 방식으로 보내야하기 때문에 onclick 할 때 함수 안에 ajax를 사용해야함
function stopFn(uno,ustate){
	// 값을 가져왔나 확인 
	// 만약 가져오지 않았다면, controller에서 vo에 담겨져 있는지 확인해야함
	console.log(uno);
	console.log(ustate);
	$.ajax({
		url : "admin/stopUser.do",
		type : "post",
		data : {
			// 보내야 할 데이터를 담음 
			"uno" : uno,
			"ustate" : ustate
		},
		success: function(response){
			alert("상태가 변경되었습니다.");
            location.reload(); // 페이지 새로 고침으로 상태 갱신
		},
		error: function(xhr, status, error) {
            // 에러 처리
            console.error("오류 발생:", error);
            alert("상태 변경에 실패했습니다.");
        } 
	});
}

</script>
<!--웹페이지 본문-->
<section>
       <div class="bcSpan">
           <a href="<%= request.getContextPath() %>/admin/blackList.do" 
           style="font-size:24px; text-decoration: underline;  text-underline-offset: 6px; color:#333333;">블랙리스트</a>
           &nbsp;
           <a href="<%= request.getContextPath() %>/admin/complainList.do" 
           style="font-size:24px; color: gray; text-decoration-line:none;">신고게시글</a>
       </div>
       <div class="complainTable">
          <% for(UserVO vo : list){ %> 
           <input type="hidden" name="uno" id ="uno" value="<%=vo.getUno()%>">
       	   <input type="hidden" name="ustate" id ="ustate" value="<%=vo.getUstate()%>">  
          <%}%>
           <table class="inner_table" style="border-collapse: collapse;">
               <thead>
               	<tr>
                    <!-- <th>신고당한 회원 번호</th> -->
                    <th>닉네임</th>
                    <th>이메일</th>
                    <th>가입일</th>
                    <th>신고 횟수</th>
                    <th>정지</th>
                   </tr>
               </thead>
               <tbody>
               <% for(UserVO vo : list){ %>
                   <tr class="cTr">
                       	<%-- <td><%=vo.getUno() %></td> --%>
                       	<td><%=vo.getUnick() %></td>
                       	<td><%=vo.getUemail() %></td>
                       	<td><%=vo.getUrdate() %></td>
                       	<td><%=vo.getDeclaration() %></td>
                       <%
                       if(vo.getUstate().equals("E")){
                    	%>	   
                   	   <td>
                       		<button type="button" class="ssBtn" onclick="stopFn(<%=vo.getUno()%>,'E')">정지</button>
                       </td>
                     	<%
                     	}else{
                    	%> 
                   	    <td>
                       		<button type="button" class="ssBtn" 
                       		style="background-color:#767676; color:white;" onclick="stopFn(<%=vo.getUno()%>,'D')">정지해제</button>
                       </td>
                       <%
                       }
                       %>
                <% } %>
                   </tr>
               </tbody>
           </table>
       </div>
       <%--      <%
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
		<strong><%=i %></strong>
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
