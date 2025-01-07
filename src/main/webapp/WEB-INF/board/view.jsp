<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="sns.vo.*" %>
<%@ page import="java.util.*" %>
<%
BoardVO vo = (BoardVO)request.getAttribute("board");
UserVO viewUser = null;
int uno = 0;
if(session.getAttribute("loginUser") != null)
{
	viewUser = (UserVO)session.getAttribute("loginUser");
	uno = Integer.parseInt(viewUser.getUno());
}
List<CommentsVO> clist = null;
if(request.getAttribute("clist") != null && !request.getAttribute("clist").equals("")){
	clist = (List<CommentsVO>)request.getAttribute("clist");
}
%>
<script>

/* 댓글 삭제 버튼 */
function setCommentDelete(cno,obj){
	$.ajax({
		url : '<%=request.getContextPath()%>/reply/cdele.do',
		type:'post',
		data : {cno : cno},
		success : function(response){
			if(response.trim()==='success'){
				alert('댓글을 삭제했습니다.');
				$(obj).parent().parent().parent().parent().parent().remove();
				
			}	
		},
		error : function(xhr, status, error){
			alert("댓글삭제에 실패했습니다.");
		} 
	});
}

/* 댓글 수정 객체 이름 확인*/
function setModify(obj){
	console.log($(obj).parent().parent().parent().parent().prev().find(".commentContent"));
	$(obj).parent().parent().parent().parent().prev().find(".commentContent").toggle();
	$(obj).parent().parent().parent().parent().prev().find(".modifyForm").toggle();
}

/* 댓글 수정 버튼 */
function commentsModify(obj) {
	console.log($(obj));
	console.log($(obj).parent().parent().children(".commentContent"));
	
    var formData = $(obj).parent().parent().serialize();  // 폼 데이터를 직렬화 (쿼리 문자열 형태로 변환)
    console.log(formData);
    
    const beforeText = $(obj).parent().children(".commentContentInput").val();
    console.log(beforeText)

	$.ajax({
    // JSP 파일 경로 :: commentWrite.jsp / commentWrite.do
    // /WEB-INF 폴더 내부에 있는 jsp는 바로 접근이 안됩니다
    url: "<%= request.getContextPath() %>/reply/cmodi.do",  
    type: "POST",        // POST 방식으로 서버에 요청
    data: formData,      // 폼 데이터를 전송
    dataType: "json",    // JSON 형식의 응답을 기대
    success: function (response) {
      $(obj).parent().parent().children(".commentContent").text(beforeText)
      $(obj).parent().parent().children(".commentContent").toggle();
      $(obj).parent().parent().children(".modifyForm").toggle();
    },
    error: function (xhr, status, error) {
      console.error("JSP 요청 오류: ", error);  // 오류 발생 시 콘솔에 출력
    } 
  });
}

/* 댓글작성 버튼 */
function btnComment() {
  var formData = $("#commentForm").serialize();  // 폼 데이터를 직렬화 (쿼리 문자열 형태로 변환)

  $.ajax({
  // JSP 파일 경로 :: commentWrite.jsp / commentWrite.do
  // /WEB-INF 폴더 내부에 있는 jsp는 바로 접근이 안됩니다
    url: "<%= request.getContextPath() %>/reply/view.do",  
    type: "POST",        // POST 방식으로 서버에 요청
    data: formData,      // 폼 데이터를 전송
    dataType: "json",    // JSON 형식의 응답을 기대
    success: function (response) {
      displayResult(response);  // 성공 시 결과를 화면에 표시
     },
    error: function (xhr, status, error) {
      console.error("JSP 요청 오류: ", error);  // 오류 발생 시 콘솔에 출력
    }
  });
}
    
function toggleA (obj) {
  //토글할 commentMenutableA를 찾는다
  var target = $(obj).find(".commentMenutableA");
  // 표시 상태를 확인한다
  // block이면 none으로 변경해야 함
  // none이면 block으로 변경해야 함
  var state = false;
  if( target.css("display") == "none" ){
  	state = true; // 원래 none였다
  }
  // 일괄적으로 모든 commentMenutableA를 감춘다
  $(".commentMenutableA").css("display","none");
  // 토글할 commentMenutableA을 바꿔준다
  if( state == true){ // 원래 none 였으면 block으로
		target.toggle()
  }
  // else는 필요없음. 원래 block이었으면 일괄적으로 none로 변경된 상태를 바꾸지 않아도 됨
}

/* 댓글 작성 버튼 클릭 성공시 구현화면 */
// 서버에서 받은 데이터를 화면에 추가하는 함수 (역순 정렬)
function displayResult(data) {
	console.log(data.name);
	console.log(data.fname);
	console.log(data.pname);
	console.log(data.content);
	console.log(data.rdate);
	console.log(data.cno);
			
	var str = `
		<div style="display: flex; align-items: center; gap: 10px;">
		<!-- 댓글작성자 프로필이미지 -->
			<div class="view_profil">
				<img id="previewProfil" class="circular-img" 
			       style="border:none; width:50px; height:50px;" 
			       src="<%= request.getContextPath() %>/upload/\${data.pname}" alt="프로필 이미지" />
			</div>
			<!-- 댓글작성자 닉네임 -->
			<span style="font-size:18px;">\${data.name}</span>
		</div>
		<!-- 댓글작성 내용 -->
		<div style=" margin-left: 70px;" id="content">
    	<span>\${data.content}</span>
    </div>
    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 5px; margin-left: 70px; font-size: 12px; color: #999;">
		<!-- 댓글작성일 -->
			<span>\${data.rdate}</span>
	    <!-- 메뉴바 -->
			<div class="commentMenuA" style"width:30px; cursor:pointer; margin-bottom:5px;" onclick="toggleA(this);">
				<div style="display: flex; align-items: center; gap: 10px;"> 
					<span id="menuB" class="menuB" style="display: flex; align-items: center; gap: 10px;">
						<i class="fas fa-solid fa-bars"></i>
			  	</span>
		  	</div>
			  <!-- 서브메뉴바 -->
				<div class="commentMenutableA" style="display:none;">
					<!-- 댓글수정 -->
					<div class="commentMenu-container">
						<i class="fas fa-solid fa-pen-nib"></i>
						<button id="infoBtn" type="button" name="commentsModify" onclick="setModify(this)">수정</button>
					</div>
					<!-- 댓글삭제 -->
					<div class="commentMenu-container">
						<i class="fas fa-solid fa-eraser"></i>
						<button id="infoBtn" type="button" onclick="setCommentDelete(\${data.cno},this)">삭제</button>
					</div>
				</div>
			</div>
		</div>`
	$(".commentDiv").prepend(str);  // 기존 내용 위에 추가
}
	
function deleteFn(){
	const bno = $("#bno").val();
	
	$.ajax({
		url : '<%=request.getContextPath()%>/board/delete.do',
		type:'post',
		// AJAX의 data 객체에서는 키 값을 문자열로 명시할 필요가 없다.
		data : {bno : bno},
		success : function(response){
			if(response.trim()==='success'){
				location.href = '<%= request.getContextPath()%>';
			}else{
				alert('글 등록에 실패했습니다.');
			}
		},
		// ajax에서 ""와 ''를 구별하지 않으나, 통일성을 위해 둘 중 하나를 선택해서 사용해야한다.
		error : function(xhr, status, error){
			alert("서버 오류가 발생했습니다.");
		} 
	});
}
</script>    
<!--웹페이지 본문-->   
<div class="view_div">
  <div class="view_inner">
  	<div class="view_img" style="width:50%;">
			<span id="view_img_span" style="cursor: default;">
				<img src="<%= request.getContextPath() %>/upload/<%= vo.getPname() %>">
			</span>
		</div>
   	<div class="view_content">
    	<div class="icon-container">
			<!-- 추천표시되는곳 -->
				<div id="reco" style="width:30px; cursor:pointer;"></div>
				<!-- 이미지 다운로드 -->
				<a href="<%= request.getContextPath() %>/upload/<%= vo.getPname() %>" download="<%= request.getContextPath() %>/upload/<%= vo.getFname() %>">
					<img id="downIcon" style="width:30px;" src="https://img.icons8.com/?size=100&id=gElSR9wTv6aF&format=png&color=000000">
				</a>
				<!-- 메뉴바 -->
				<div id="menuA" style="width:30px; cursor:pointer; margin-bottom:5px;">
					<img style="width:30px; transform: rotate(90deg);" 
				       src="https://img.icons8.com/?size=100&id=98963&format=png&color=000000" >
				 	<!-- 서브메뉴바 -->
				  <div id="menutableA" style="display: none;">
				  <!-- 게시글신고 -->
				    <div class="menu-container" id="complainDiv" onclick="complainAdd(<%= vo.getBno() %>);"></div>
				 	<%
							if(session.getAttribute("loginUser") != null){
								if(uno == vo.getUno()){
									%>
					     		<!-- 게시글수정 -->
					    		<div class="menu-container">
					       		<i class="fas fa-solid fa-pen-nib"></i>
					       		<button id="infoBtn" onclick="location.href='<%=request.getContextPath()%>/board/modify.do?bno=<%= vo.getBno() %>'">수정</button>
					    		</div>
					    		<!-- 게시글삭제 -->
					    		<form action="">
						  			<div class="menu-container">
							       		<i class="fas fa-solid fa-eraser"></i>
							       		<button id="infoBtn" onclick="deleteFn()">삭제</button>
							       		<input type="hidden" id="bno" name="bno" value="<%=vo.getBno()%>">
						   			</div>
					    		</form>
									<%
									}else if(viewUser.getUauthor().equals("A")){
										System.out.println("writer.getUauthor() : " + viewUser.getUauthor());
									%>
										<!-- 게시글삭제 -->
								<form action="">
						        	<div class="menu-container">
							          	<i class="fas fa-solid fa-eraser"></i>
							          	<button id="infoBtn" onclick="deleteFn()">삭제</button>
							          	<input type="hidden" id="bno" name="bno" value="<%=vo.getBno()%>">
						        	</div>
					        	</form>
									<%	
										}
									%>
				        	<%
								}
									%>
				  </div>
				</div>
			</div>
      <p style="font-size:26px; margin:10px 0;"><%= vo.getTitle() %></p>
			<div style="font-size:18px; margin-top:5px;">
				<div class="view_profil" style="margin-bottom:10px;">
						<%
					if(vo.getUpname() != null && !vo.getUpname().equals("")){
						%>
		    		<!-- 프로필 이미지가 있을 경우 -->
		        <img id="previewProfil" class="circular-img" 
								 onclick="location.href='<%= request.getContextPath() %>/user/mypage.do?uno=<%= vo.getUno() %>&type=written'"
		        		 style="border:none; width:50px; height:50px; cursor:pointer; " 
		        		 src="<%= request.getContextPath() %>/upload/<%= vo.getUpname() %>" alt="프로필 이미지" />
						<%
						}else{
							String firstNick = vo.getUnick().substring(0, 1);
	        		%>
		        	<div class="icon profileicon" 
			      			 onclick="location.href='<%= request.getContextPath() %>/user/mypage.do?uno=<%= vo.getUno() %>&type=written'"
			      			 style="background-color:#EEEEEE; border-radius: 50%; cursor: pointer;
			      			 display: flex; justify-content: center; align-items: center; 
			      			 font-size: 24px; font-weight: bold; width: 50px; height: 50px;">
			      	<%= firstNick %>
	        		</div>
	        		<%
						}
							%>
			    		<span><%= vo.getUnick() %></span>
			    		<%
			    		if(viewUser != null){
			    		%>
			    	    <form id="follow_form">
			    	 <%
							if(session.getAttribute("loginUser") != null){
								if(uno != vo.getUno()){
									// 로그인 유저의 uno와 게시글 작성자의 uno로 팔로잉상태를 체크하는 sql문을 실행한다
									String isfollow = vo.getIsfollow();
							%>
				        			<input type="hidden" name="tuno" value="<%= vo.getUno() %>">
				        				<!-- 팔로잉 상태에 따라 버튼의 클래스를 바꾼다 -->
			    							<button class="<%= (isfollow.equals("0")) ? "ssBtn" : "ssFollowBtn" %>" type="button" id="followId" onclick="follow(this)"><%= (isfollow.equals("0")) ? "팔로우" : "팔로잉" %></button>
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
				&nbsp;
				<%= vo.getRdate() %>&nbsp;
				추천수&nbsp; <span id="recoCount"><%= vo.getRecommend() %></span>&nbsp;
				조회수&nbsp; <%= vo.getHit() %>
			</div><br>
			<div><%= vo.getContent() %></div>
			<!-- 댓글위치 -->
				<div class="comment_inner">
					<table>
						<tr>
							<td colspan="3">
							<form method="post" id="commentForm">
								<div class="search-wrapper">
									<div class="input-container" id="seach-container"
											style="box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
					   								 background-color: white;
					   								 border-radius: 40px;
					   								 width:100%;
					   								 display: flex;
					 									 align-items: center; 
					 									 gap: 10px;">
										<i class="fas solid fa-comment-dots" style="margin-left:10px;"></i>
										<!-- 댓글 작성자 -->
										<input type="hidden" name="bno" value="<%= vo.getBno()%>">
										<input type="hidden" name="uno" value="<%= vo.getUno()%>">
										<!-- 댓글 입력창 -->
										<input type="text" id="commentContent" name="content" placeholder="댓글"	
													 style="padding-right: 40px;	background-color: white;" size="50">
										<!-- 댓글 게시글번호 -->
										<input id="commentBno" type="hidden">
            			</div>
								</div>
							</form>
							</td>
						</tr>
					</table>
					<!-- 댓글목록 출력 -->
					<div class="commentDiv">
					<!-- 리퀘스트에서 담아온 댓글 출력하기 -->
					<% 
						System.out.println("comments:::::"+clist.size());
						for(int i =0; i< clist.size();i++){
							System.out.println("index:::::::"+i);
							CommentsVO cvo = clist.get(i);
							System.out.println(cvo.toString());
					%>
						<div>
							<div style="display: flex; align-items: center; gap: 10px;">
        			<!-- 댓글작성자 프로필이미지 -->
								<div class="view_profil">
        			<%
								if(cvo.getPname() != null && !cvo.getPname().equals("")){
							%>
									<img id="previewProfil" class="circular-img" 
												onclick="location.href='<%= request.getContextPath() %>/user/mypage.do?uno=<%= cvo.getUno() %>&type=written'"
				        				style="border:none; width:50px; height:50px; cursor:pointer;" 
				        				src="<%= request.getContextPath() %>/upload/<%=cvo.getPname() %>" alt="프로필 이미지" />
				 			<%
									}else{
										String firstCommentsNick = cvo.getUnick().substring(0, 1);
		        	%>
			        			<div class="icon profileicon" 
				       					 onclick="location.href='<%= request.getContextPath() %>/user/mypage.do?uno=<%= cvo.getUno() %>&type=written'"
				        				 style="background-color:#EEEEEE; border-radius: 50%; cursor: pointer;
				        								display: flex; justify-content: center; align-items: center; 
				        								font-size: 24px; font-weight: bold; width: 50px; height: 50px;">
				        		<%= firstCommentsNick %>
		        				</div>
		        	<%
										}
							%>
								</div>
									<!-- 댓글작성자 닉네임 -->
									<span style="font-size:18px;"><%=cvo.getUnick() %></span>
							</div>
							<!-- 댓글작성 내용 -->
			  				<div style="margin-top: 5px; margin-left: 70px; margin-bottom: -5%;"id="content">
									<form class="modiForm" style= "display: ruby-text;">
           					<span class="commentContent"><%= cvo.getContent() %></span>
           					<span style="display:none;" class="modifyForm" >
           						<input type="hidden" value="<%= cvo.getCno() %>" name="cno">
	           					<input class="commentContentInput" type="text" value="<%= cvo.getContent() %>" name="content">  <!-- 댓글입력창 -->
	           					<button class="commentModifyButton" type="button" onclick="commentsModify(this);">수정</button>  <!-- 댓글 수정버튼 -->
											<input class="commentModifyReset"type="reset" value="취소">  <!-- 댓글 수정 취소버튼 -->
           					</span>
									</form>
								</div>
         				<div style="display: flex; justify-content: space-between; align-items: center; margin-top: 5px; margin-left: 70px; font-size: 12px; color: #999;">
		     				<!-- 댓글작성일 -->
		      			<span><%= cvo.getRdate() %></span>
	    					<!-- 메뉴바 -->
								<div class="commentMenuA" style="width:30px; cursor:pointer; margin-bottom:5px;" onclick="toggleA(this);">
									<div style="display: flex; align-items: center; gap: 10px;"> 
								<%
										if(session.getAttribute("loginUser") != null){
											if(uno == cvo.getUno()){
									%>
		       							<span id="menuB" class="menuB" style="display: flex; align-items: center; gap: 10px;">
		         							<i class="fas fa-solid fa-bars"></i>
			  	 							</span>
									</div>
			    					<!-- 서브메뉴바 -->
										<div class="commentMenutableA" style="display:none;">
				        		<!-- 댓글수정 -->
											<div class="commentMenu-container">
				        				<i class="fas fa-solid fa-pen-nib"></i>
				         				<button id="infoBtn" type="button" name="commentsModify" onclick="setModify(this)">수정</button>
				        			</div>
				        			<!-- 댓글삭제 -->
				        			<div class="commentMenu-container">
				        				<i class="fas fa-solid fa-eraser"></i>
				        				<button id="infoBtn" type="button" onclick="setCommentDelete(<%=cvo.getCno() %>,this)">삭제</button>
				        			</div>
								<%
											}else if(viewUser.getUauthor().equals("A")){
												System.out.println("writer.getUauthor() : " + viewUser.getUauthor());
								%>
				        				<span id="menuB" class="menuB" style="display: flex; align-items: center; gap: 10px;">
		         							<i class="fas fa-solid fa-bars"></i>
			  	 							</span>
		  	 						</div>
			    					<!-- 서브메뉴바 -->
										<div class="commentMenutableA" style="display:none;">
					        	<!-- 댓글삭제 -->
				        			<div class="commentMenu-container">
				        				<i class="fas fa-solid fa-eraser"></i>
				        					<button id="infoBtn" type="button" onclick="setCommentDelete(<%=cvo.getCno() %>,this)">삭제</button>
				        			</div>					
				            <%	
											}
										%>
			        			<%
										}
										%>
										</div>
									</div>  
         				</div>
						</div>
									<%
								}
									%>
					</div>
				</div>
			</div>
	</div>
</div>