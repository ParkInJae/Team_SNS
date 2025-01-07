<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../include/header.jsp" %>
<%@ include file="../include/nav.jsp" %>
<!--웹페이지 본문-->
<section>
	<div class="div_inner">
		<div class="view_div">
	 	   <div class="view_inner">
	 	   		<div class="view_img">
					<label>
						<span class="imgSpan">
							<img id="wPreview" style="width: 100%;	max-height: 100%; border-radius: 40px;">
						</span>
						<input type="file" style="display: none;" name="attach" id="attach" onchange="readURL(this);">
					</label>
				</div>
				<div class="view_content" style="width: 50%; margin-left:40px; overflow: hidden; ">
					<input type="text" class="titleInput" placeholder="글제목" id="title" name="title">
					<textarea class="contentInput" placeholder="글내용" id="content"name="content"></textarea>
					<div class="btnDiv">
						<form name="write" method="post" action="">
						<!-- type을 버튼으로 설정해야함 : 버튼으로 설정하지 않은경우 받아올 수 없음-->
							<input class="userBtn" style="cursor:pointer; width: 95%;" type="button" onclick="submitPost();" value="등록">
							<input class="userBtn" style="cursor:pointer; width: 95%;" type="reset" value="취소">
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</section>
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

	function submitPost(){
		const attach = $('#attach').val();
		// 제이쿼리 기본 문법 >> $(선택자).동작함수1().동작함수2()
		const title = $('#title').val();
		const content = $('#content').val();
		
		if(!attach) {
	        alert('첨부파일을 선택해주세요.');
	        return false;
	    }
	    
	    if(!title.trim()) {
	        alert('제목을 입력해주세요.');
	        return false;
	    }
		
		// form에 담는 이유는 , attach같은 첨부파일은 바이너리 파일이므로 , String으로 보낼 수 없음 따라서 , 
		// 새로운 form에 appand를 사용해서 담아야함
		 var form = new FormData();
	     form.append( "attach", $("#attach")[0].files[0] );
	     form.append( "title", $("#title").val() );
	     form.append( "content", $("#content").val() );
	     
	     //console.log($(form).serializeArray());
		
		$.ajax({
			// 방법 
			type : 'post',
			//매개변수 는 컨트롤러에 매핑된 URL과 일치해야 하는 것을 url가리킵니다 
			url : '<%=request.getContextPath()%>/board/write.do',
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
                    alert('글 등록에 실패했습니다. 다시 시도해주세요.');
                }
            },
            error: function() {
                alert('서버 오류가 발생했습니다.');
            }
		});
	} 
</script>
<%@ include file="../include/aside.jsp" %> 