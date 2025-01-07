<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/include/header.jsp" %>
<%@ include file="/WEB-INF/include/nav.jsp" %>
<%@ page import="sns.util.*" %>
<%
Connection conn = null;			//DB 연결
PreparedStatement psmt = null;	//SQL 등록 및 실행. 보안이 더 좋음!
ResultSet rs = null;			//조회 결과를 담음

List<BoardVO> bList = new ArrayList<>();

//try 영역
try{
	conn = DBConn.conn();
	
	int indexpage = request.getParameter("indexpage") != null ? Integer.parseInt(request.getParameter("indexpage")) : 1;
	int pageSize = 24;
	int startRow = (indexpage - 1) * pageSize;
	
	String keyword = request.getParameter("searchValue");
	if(keyword == null){
		keyword = "";
	}

	String sql = "select b.bno, pname "
	           + "from board b "
	           + "inner join attach a on b.bno = a.bno "
	           + "where b.state='E' " ;
	if(!keyword.equals("")){
			sql += " and title like ('%"+ keyword + "%')";
	}
	   		sql +=  "order by bno desc ";
	   		sql +=  "limit ? offset ?";
	psmt = conn.prepareStatement(sql);
	psmt.setInt(1, pageSize);
	psmt.setInt(2, startRow);
	
	rs = psmt.executeQuery();
%>
<script>
let indexpage = 1; // 현재 페이지 초기화
let isLoading = false; // 추가 로드 상태 확인 변수

window.onload = function(){
	window.addEventListener('scroll', () => {
        const { scrollTop, scrollHeight, clientHeight } = document.documentElement;

        // 스크롤이 바닥에 도달했을 때
        if (scrollTop + clientHeight >= scrollHeight - 5 && !isLoading) {
            isLoading = true; // 로딩 중 상태로 변경
            loadMore();
        }
    });
	
	/* $(".listDiv").click(function() { */
	$(document).on('click', '.listDiv', function() {
	    $("#modal").fadeIn(); // 모달 창 보이게 하기
	    
	    let bno = $(this).attr('id');
	    console.log(bno);
	    
	    $.ajax({
	        url: "<%= request.getContextPath() %>/board/view.do",
	        data : {bno:bno},
	        type: "get",
	        success: function(data) {
	            $("#modalBody").html(data);
				
	            // 동적으로 로드된 스크립트 실행
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
	        }
	    });
	});
	
	$(window).click(function(event) {
	    if ($(event.target).is("#modal")) {
	        $("#modal").fadeOut(); // 모달 창 숨기기
	    }
	});
}

//추가 데이터를 불러오는 함수
function loadMore() {
    indexpage++; // 페이지 번호 증가
    $.ajax({
        url: `<%= request.getContextPath() %>/board/loadMore.do`,
        method: 'GET',
        data: { indexpage: indexpage },
        success: function(data) {
            let html = '';
            data.forEach(item => {
                html += `<div class='listDiv' id='\${item.bno}'>
                            <img src='<%= request.getContextPath() %>/upload/\${item.pname}' alt='Image \${item.bno}'>
                         </div>`;
            });
            
            $('#indexDiv').append(html);
            isLoading = false;
            
            // 추가된 게시글에 CSS 스타일 적용
            /* $('#modalBody .view_div').css({
                'width': '100%',
                'height': '100%',
                'padding': '0',
                'margin': '0',
                'box-sizing': 'border-box',
                'display': 'flex',
                'overflow': 'hidden'
            });
            
            $('#modalBody .view_inner').css({
                'width': '100%',
                'height': '100%',
                'display': 'flex',
                'justify-content': 'space-between'
            });

            $('#modalBody .view_img').css({
                'width': '50%',
                'position': 'relative'
            });

            $('#postContainer .view_img span img').css({
                'width': '100%',
                'height': '100%',
                'border-radius': '40px'
            });

            $('#modalBody .view_content').css({
                'width': '50%',
                'padding': '20px',
                'max-height': '600px',
                'overflow-y': 'auto'
            }); */
        },
        error: function() {
            console.error("더 많은 게시물을 로드하는 중 오류가 발생했습니다.");
            isLoading = false;
        }
    });
}


function DarkMode() {
    const currentMode = localStorage.getItem('mode') || 'light';
    const modeText = document.getElementById('modeText');
    if (currentMode === 'dark') {
        document.body.classList.add('dark-mode');
        modeText.textContent = '라이트모드';
    } else {
        document.body.classList.remove('dark-mode');
        modeText.textContent = '다크모드';
    }

    // 다크모드 토글 버튼 클릭 이벤트
    document.getElementById('modeToggle').addEventListener('click', function() {
        document.body.classList.toggle('dark-mode');
        const newMode = document.body.classList.contains('dark-mode') ? 'dark' : 'light';
        localStorage.setItem('mode', newMode);
        modeText.textContent = newMode === 'dark' ? '라이트모드' : '다크모드';
    });
}
</script>
<!--웹페이지 본문-->
<section class="scrollable">
	<div id="indexDiv">
<%	
	while(rs.next()){
	%>
		<div class="listDiv" id="<%= rs.getString("bno") %>">
            <img src="<%= request.getContextPath() %>/upload/<%= rs.getString("pname") %>">
        </div>
	<%
	}
%>
	</div> 
</section>
<%
}catch(Exception e){
	e.printStackTrace();
}finally{
	try {
		DBConn.close(rs, psmt, conn);
	}catch(Exception e) {
		e.printStackTrace();
	}
}
%>
<%@ include file="/WEB-INF/include/aside.jsp" %>