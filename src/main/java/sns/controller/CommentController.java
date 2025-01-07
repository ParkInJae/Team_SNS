package sns.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import sns.util.DBConn;
import sns.vo.UserVO;

public class CommentController {
	public CommentController(HttpServletRequest request, HttpServletResponse response, String[] comments)
			throws ServletException, IOException {

		if (comments[comments.length - 1].equals("view.do")) {
			commentWrite(request, response);
		}else if (comments[comments.length - 1].equals("cmodi.do")) {
			commentModify(request, response);
		}else if (comments[comments.length - 1].equals("cdele.do")) {
			commentDelete(request, response);
		}
	}

	public void commentDelete(HttpServletRequest request, HttpServletResponse response) 
		throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		
		int cno = Integer.parseInt(request.getParameter("cno"));
		
		Connection conn = null;
		PreparedStatement psmt = null;
		
		String sql ="";
		
		try {
			conn = DBConn.conn();
			sql =" UPDATE comments SET state = 'D' "
					+ " WHERE cno =? ";
			psmt=conn.prepareStatement(sql);
			psmt.setInt(1, cno);
			int result = psmt.executeUpdate();
			if(result > 0 ) {
				
				response.setContentType("text/html;charset=UTF-8");
				PrintWriter out = response.getWriter();  
				out.print("success");  
				out.flush();
				out.close();   
			}
		}
		catch(Exception e){
			e.printStackTrace();
			response.setContentType("text/html;charset=UTF-8");
	        PrintWriter out = response.getWriter();   
            out.print("error");  
	        out.flush();
	        out.close();	
		}finally {
			try {
				DBConn.close(psmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
	}

	public void commentModify(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		
		System.out.println("commentsModify 호출");
		
		request.setCharacterEncoding("UTF-8");
		
		// 폼 데이터 가져오기
		int cno = Integer.parseInt(request.getParameter("cno"));
		String content = request.getParameter("content");
		
		// DB연결
				Connection conn = null;
				PreparedStatement psmt = null;
				ResultSet rs = null;
				
				try{
					conn = DBConn.conn();
					String sql = " UPDATE comments SET content = ? WHERE cno= ? ";
					
					psmt = conn.prepareStatement(sql);
					psmt.setString(1,content);
			 		psmt.setInt(2,cno);
			 		psmt.executeUpdate();
			 		
			 		JSONObject json = new JSONObject();

					try {
						sql = " select c.cno, c.rdate, u.unick, u.fname, u.pname from comments as c join user as u on c.uno = u.uno where cno = ?; ";

						psmt = conn.prepareStatement(sql);
						psmt.setInt(1, cno);

						rs = psmt.executeQuery();

						if (rs.next()) {
							// JSON 객체 생성
							json.put("cno", cno);
							json.put("name", rs.getString("unick"));
							json.put("content", content);
							json.put("rdate", rs.getString("rdate"));
							json.put("fname", rs.getString("fname"));
							json.put("pname", rs.getString("pname"));
						}

					} catch (Exception e) {
						e.printStackTrace();
					}

					// JSON 응답 전송
					PrintWriter out = response.getWriter();
					out.print(json.toString());
					out.flush();
				} catch (Exception e) {
					e.printStackTrace();
				}
	}
	
	public void commentWrite(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("commentWrite 호출");

		// 응답의 Content-Type을 JSON으로 설정
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		HttpSession session = request.getSession();
		UserVO loginUser = (UserVO)session.getAttribute("loginUser");
		// 폼 데이터 가져오기
		int bno = Integer.parseInt(request.getParameter("bno"));
		int uno = Integer.parseInt(loginUser.getUno());
		String content = request.getParameter("content");

		// DB연결
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		try {

			conn = DBConn.conn();

			String sql = " insert into comments (bno,uno,content)value(?,?,?); ";

			psmt = conn.prepareStatement(sql);
			psmt.setInt(1, bno);
			psmt.setInt(2, uno);
			psmt.setString(3, content);

			psmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}

		// 방금등록된 댓글 번호를 db에서 받아온다
		int cno = 0;

		try {
			String sql = " select last_insert_id() as cno; ";

			psmt = conn.prepareStatement(sql);

			rs = psmt.executeQuery();

			if (rs.next()) {
				cno = rs.getInt("cno");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		System.out.println("cno : " + cno);
		
		
		// 댓글이 등록되면, 댓글 알림을 알람 테이블에 작성합니다
		try {

			conn = DBConn.conn();
			// uno는 알림을 받을 사람
			// no는 댓글번호
			// bno는 알람 목록 가져오는 sql에서 cno롤 찾음
			String sql = " insert into alram ( uno, type, no ) value ((select uno from board where bno = ?), 'R', ?); ";

			psmt = conn.prepareStatement(sql);
			psmt.setInt(1, bno);
			psmt.setInt(2, cno);

			psmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}

		// 댓글번호로 댓글 정보를 db에서 받아온다
		// 댓글을 쓴 사람 번호로 프로필 이미지 파일명과 유저네임을 가져온다

		JSONObject json = new JSONObject();

		try {
			String sql = " select c.cno, c.rdate, u.unick, u.fname, u.pname from comments as c join user as u on c.uno = u.uno where cno = ?; ";

			psmt = conn.prepareStatement(sql);
			psmt.setInt(1, cno);

			rs = psmt.executeQuery();

			if (rs.next()) {
				// JSON 객체 생성
				json.put("cno", cno);
				json.put("name", rs.getString("unick"));
				json.put("content", content);
				json.put("rdate", rs.getString("rdate"));
				json.put("fname", rs.getString("fname"));
				json.put("pname", rs.getString("pname"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		// JSON 응답 전송
		PrintWriter out = response.getWriter();
		out.print(json.toString());
		out.flush();
	}
}