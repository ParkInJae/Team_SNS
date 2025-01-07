<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/nav.jsp" %>
<%@ page import="sns.vo.* "%>
<%
UserVO login = null;
if(session.getAttribute("loginUser") != null){
	login = (UserVO)session.getAttribute("loginUser");
}
UserVO pageUser = null;
if(request.getAttribute("user") != null){
	pageUser = (UserVO)request.getAttribute("user");
}
System.out.println("pageUser=================================" +pageUser );
String pUno = "";
String pPname = "";
if(pageUser != null){
	pUno = pageUser.getUno();
	pPname = pageUser.getPname();
}
// 현재 보고있는 섹션을 페이지가 알 수 있도록 표시하기 위해 type 변수 선언 
String type = "bookmark";
if (request.getParameter("type") != null && !request.getParameter("type").equals("")) {
    type = request.getParameter("type");
}
ArrayList<BoardVO> board = null;
if(request.getAttribute("board") != null ){
	board = (ArrayList)request.getAttribute("board");
}
FollowVO vo = null;
if(request.getAttribute("follow") != null ){
	vo = (FollowVO)request.getAttribute("follow");
}
int cnt = 0;
if(request.getAttribute("fcnt") != null ){
	cnt = (Integer)request.getAttribute("fcnt");
}
%>
<!--웹페이지 본문-->
<section>
	<div class="mypage_inner">
		<div id="mypage_top">
			<!-- 프로필이미지 -->
			<%
	        if(pPname != null && !pPname.equals("")){
        	%>
        	<img id="previewProfil" class="circular-img" 
	            style="border:none; width:300px; height:300px;" 
	            src="<%= request.getContextPath()+"/upload/" + pPname %>" 
           		alt="첨부된 이미지" style="max-width: 100%; height: auto;" />
         	<%
	        }else{
	        	String firstNick = pageUser.getUnick().substring(0, 1);
        	%>
	        <div class="icon profileicon"
	        style="background-color:#EEEEEE; border-radius: 50%; cursor: pointer;
	        display: flex; justify-content: center; align-items: center;
	         font-size: 100px; font-weight: bold; width: 300px; height: 300px;">
		        <%= firstNick %>
        	</div>
        	<%
	        }
	        %>
	    	<div><%= pageUser.getUnick() %></div>
	    	<div id="followResult">팔로워 수 : <span id="followcnt"><%= cnt %></span></div>
	    	<div id= "followModifyMessegeBtn" style="width: 100%; display: flex; justify-content: center">
	    		<%
	    		if(loginUser != null && pUno.equals(loginUser.getUno())){
    			%>
	    		<!-- 로그인한 회원의 마이페이지인 경우 -->
	    		<button class="ssBtn" onclick="location.href='profileModify.do'">프로필 수정</button>
    			<%
	    		}else{
    			%>
	    		<!-- 내가 아닌 다른 회원페이지인 경우 -->
	    		<button class="ssBtn">메시지</button>&nbsp;&nbsp;
	    		<form id="follow_form">
			    	 <%
					if(session.getAttribute("loginUser") != null){
						if(pUno != login.getUno()){
							// 로그인 유저의 uno와 게시글 작성자의 uno로 팔로잉상태를 체크하는 sql문을 실행한다
							String isfollow = "0";
							if (request.getAttribute("isfollow") != null) isfollow = (String)request.getAttribute("isfollow");
						%>
				        <input type="hidden" name="tuno" value="<%= pageUser.getUno() %>">
				        <!-- 팔로잉 상태에 따라 버튼의 클래스를 바꾼다 -->
			    	<button class="<%= (isfollow.equals("0")) ? "ssBtn" : "ssFollowBtn" %>" type="button" id="followId" onclick="followPage(this)"><%= (isfollow.equals("0")) ? "팔로우" : "팔로잉" %></button>
						<%
						}
					%>
			        <%
					}
					%>
			    </form>
    			<%	
	    		}
	    		%>
			</div>
			<div class="mypage_page">
				<%
	    		if(loginUser != null && pUno.equals(loginUser.getUno())){
    			%>
					<!-- 로그인한 회원의 마이페이지인 경우 -->
					<!-- 북마크를 클릭했을 때 해당 링크로 uno와 type 파라미터를 전송  -->
					<!-- 응답받은 타입이 문자열과 일치할 때 스타일을 적용  -->
					<a href="mypage.do?uno=<%= loginUser.getUno() %>&type=bookmark"
	   				style="<%= "bookmark".equals(type) ? "text-decoration: underline; text-underline-offset: 6px;" : "color:gray;" %>">북마크</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="mypage.do?uno=<%= loginUser.getUno() %>&type=written" 
					style="<%= "written".equals(type) ? "text-decoration: underline; text-underline-offset: 6px;" : "color:gray;" %>">내가쓴글</a>
				<%
	    		}else{
    			%>
				<!-- 내가 아닌 다른 회원페이지인 경우 -->
				<a style="text-decoration: underline; text-underline-offset: 6px;">작성글</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<%	
	    		}
	    		%>
            </div>
		</div>
		<!-- 게시글출력되는곳 -->
		<div id="indexDiv" class="scrollable">
            <!-- 1번째 줄 -->
            <%
            if(board != null){
	            for (BoardVO bvo : board){ %>
	            <!-- 게시글을 클릭할 때 해당하는 bno를 가진 게시글을 모달창에 띄우기 위해 id를 줌  -->
	            <div class="listDiv" id="<%= bvo.getBno()%>">
	            <%System.out.println("vo.getBno=================================" +bvo.getBno() ); %>
	                <!-- 이미지 -->
	                <img src="<%= request.getContextPath() %>/upload/<%= bvo.getPname() %>" onclick="mypageViewFn(<%=bvo.getBno()%>)">
	            </div>	
	            <% 
	            }
            }
            %>
        </div> 
    </div>
</section>
<%@ include file="../include/aside.jsp" %>
<script>
function mypageViewFn(bno) {
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
        },
        error: function(xhr, status, error) {
            console.error("오류 발생:", error);
            alert("게시글을 불러오지 못했습니다.");
        } 
    });
}

//모달 닫기 함수
$(window).click(function(event) {
	    if ($(event.target).is("#modal")) {
	        $("#modal").fadeOut(); // 모달 창 숨기기
	    }
	});


</script>