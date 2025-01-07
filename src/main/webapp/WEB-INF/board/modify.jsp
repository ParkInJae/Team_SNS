<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/nav.jsp" %>
<%
	BoardVO vo = (BoardVO)request.getAttribute("vo");
	request.setCharacterEncoding("UTF-8");
%>
<script>
function readURL(input) {
	if (input.files && input.files[0]) {
		var reader = new FileReader();
		reader.onload = function(e) {
			document.getElementById('wPreview').src = e.target.result;
		};
		reader.readAsDataURL(input.files[0]);
	}else {
		document.getElementById('wPreview').src = "";
	}
}

function modifyFn(){
	// 제이쿼리 기본 문법 >> $(선택자).함수();
	
	const attach = $('#attach').val();
	const title = $('#title').val();
	const content = $('#content').val();
	const bno = $('#bno').val();
	
	// 첨부파일 넣지 않았을 때 
	/* if(!attach){
		alert('첨부파일을 선택해주세요');
		return flase;
	} */
	
	// 제목 입력하지 않았을 때
	if(!title) {
		alert('제목을 입력하지 않았습니다.');
		return flase;
	}
	// form에 담는 이유는 , attach같은 첨부파일은 바이너리 파일이므로, String으로 보낼 수 없음
	// 따라서 새로운 form에 appand를 사용해서 담아야함 
	var form = new FormData();
	form.append( "attach",$("#attach")[0].files[0]);
	form.append( "title",$("#title").val());
	form.append( "content",$("#content").val());
	form.append("bno", $("#bno").val());
	
	/* 
	   	로컬 스토리지 함수
	  	로컬스토리지의 'id' 키에 response.bno의 값을 담음, 또한, 로컬스토리지는 브라우저의 
	  	로컬 저장소에 저장되기 때문에 동일한 도메인 안에서 페이지가 달라도 접근이 가능함.
    */ 
	$.ajax({
		// 방법 
		type : 'post',
		//매개변수 는 컨트롤러에 매핑된 URL과 일치해야 하는 것을 url가리킵니다 
		url : '<%=request.getContextPath()%>/board/modify.do',
		processData : false,
        contentType : false,
		data: form,
		dataType: "json",
        success: function(response) {
          	console.log(response)
        	console.log(response.result);
          	console.log(response.bno);
        	
            if (response.result === 'success') {
            	// 수정해야할 부분 >>> 로컬스토리지 사용 
            	   localStorage.setItem('bno', response.bno);  //로컬스토리지의 키에 response.bno의 값을 담음
                  location.href = '<%=request.getContextPath()%>';
                  
            } else {
                alert('글 수정 실패했습니다. 다시 시도해주세요.');
            }
        },
        error: function() {
            alert('서버 오류가 발생했습니다.');
        }
	});
} 
</script>
<!--웹페이지 본문-->
<section>
<form name="modify" method="post"  action=""> 
	<div class="div_inner">
			<div class="view_div">
		 	   <div class="view_inner">
		 	   		<div class="view_img">
						<label>
							<span class="imgSpan">
								<img  id="wPreview" src="<%=request.getContextPath() %>/upload/<%=vo.getPname()%>" alt="고양이" 
								  style="width: 100%;height: 100%; border-radius: 40px;">
							</span>
							<input type="file" style="display: none;" name="attach" id="attach" onchange="readURL(this);">
						</label>
					</div>
					<div class="view_content" style="width: 50%; margin-left:40px; overflow: hidden;">
						<input type="text" class="titleInput" placeholder="글제목" id="title" value="<%=vo.getTitle()%>">
						<textarea class="contentInput" placeholder="글내용" id="content"name="content"><%=vo.getContent()%></textarea>
						<div class="btnDiv">
							<input type="hidden" name ="bno" value="<%=vo.getBno()%>" id="bno">
							<input class="userBtn" type="button" style="width: 95%;" value="수정" onclick="modifyFn()">
							<input class="userBtn" type="button" style="width: 95%;" value="취소" 
							onclick="location.href='<%= request.getContextPath() %>'">
						</div>
					</div>
				</div>
			</div>
		</div>
	</form>
</section>
<%@ include file="../include/aside.jsp" %>
