<%@ page contentType="application/json; charset=UTF-8" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="sns.util.DBConn" %>

<%
    // 현재 시간 생성
    //SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    //String timestamp = formatter.format(new Date());

    // 폼 데이터 가져오기
    request.setCharacterEncoding("UTF-8");
    
    int bno = Integer.parseInt(request.getParameter("bno"));
    int uno = Integer.parseInt(request.getParameter("uno"));
    String content = request.getParameter("content");

    Connection conn = null;			
		PreparedStatement psmt = null;
    
	try {
		
		conn = DBConn.conn();
		
			String sql = " insert into comments (bno,uno,content)value(?,?,?); " ;
		
			psmt = conn.prepareStatement(sql);
			psmt.setInt(1, bno);
			psmt.setInt(2, uno);
			psmt.setString(3, content);
 		
 			int result = psmt.executeUpdate();
	}catch(Exception e){
		e.printStackTrace();
		out.print(e.getMessage());
	}finally{
		DBConn.close(psmt,conn);
	}

// 댓글이 등록이 잘 되었는지 확인	
	// DB에게 방금 insert한 데이터의 pk를 요청 -> 새로 등록한 댓글의 번호
	// DB에서 댓글 번호로 댓글 내용을 읽어옴 -> select
// 등록이 안되었으면 예외처리

// 댓글 내용중에, 댓글 작성일자가 필요
// 댓글 번호도 가져옴
// 댓글 작성자의 프로필 사진 주소는 유저 테이블에서 가져옴
		int cno = 2;
		String rdate = "2024-10-25 12:00:00";
		String filename = "image.jpg";
		String name = "고양이";

//	response.sendRedirect("commentWrite.jsp?cno="+cno);

 // JSON 객체 생성
    JSONObject json = new JSONObject();
    json.put("cno", cno);
    json.put("content", content);
    json.put("rdate", rdate);
    json.put("filename", filename);
    json.put("name", name);

    // JSON 응답 전송
    out.print(json.toString());
%>