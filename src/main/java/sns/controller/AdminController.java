package sns.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import sns.util.DBConn;
import sns.util.PagingUtil;
import sns.vo.BoardVO;
import sns.vo.UserVO;

public class AdminController {
	public AdminController(HttpServletRequest request
			, HttpServletResponse response
			, String[] comments) throws ServletException, IOException {
		
		if(comments[comments.length-1].equals("blackList.do")) {
			blackList(request,response);
		}else if(comments[comments.length-1].equals("complainList.do")) {
			complainList(request,response);
		}else if (comments[comments.length-1].equals("loadComplain.do")) {
			loadComplain(request,response);
		}else if (comments[comments.length-1].equals("complainAdd.do")) {
			complainAdd(request,response);
		}else if (comments[comments.length-1].equals("stopUser.do")) {
			if(request.getMethod().equals("POST")) {
				stopUser(request,response);
			}
		}else if (comments[comments.length-1].equals("stopBoard.do")) {
			if(request.getMethod().equals("POST")) {
				stopBoard(request,response);
			}
		}
	}
		
	public void blackList (HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		// controller ���� 
		PreparedStatement psmtTotal = null;
		ResultSet rsTotal = null;

		int nowPage = 1;
		
		if(request.getParameter("nowPage") != null)
		{
			nowPage = Integer.parseInt(request.getParameter("nowPage"));
			System.out.println("nowPage========================== " + nowPage);
		}	
		

		try{
			
			conn = DBConn.conn();
			// ����¡
			String sqlTotal =" SELECT COUNT(DISTINCT b.uno) as total "
					+"   FROM complaint_board c  "
					+"         LEFT JOIN board b ON c.bno = b.bno  "
					+"         GROUP BY b.uno  "
					+"         HAVING COUNT(b.uno) > 0; ";
		
			psmtTotal=conn.prepareStatement(sqlTotal);
			rsTotal = psmtTotal.executeQuery();
			
			//��ü �Խñ� ���� ���� ����
			int total = 0; 
			
			if(rsTotal.next())
			{
				total = rsTotal.getInt("total");
			}
			PagingUtil paging = new PagingUtil(nowPage, total, 10);
			
			//������ ��¿� �ʿ��� �Խñ� ������ ��ȸ ���� ����
			
			/*
			 	�������� �� �� �����ؾ��� >> complaint_board c�� �ۼ��ϸ� sql���� ������ �߻���
			 	(���������� ��Ī�� ���������� ��Ī���� ����� �� ���� )
			 	�������� ���� >> ���� ������ ���� ���� �ǰ� �ڿ� ���� ������ ������ ������ ��
			 	�������� > ���� ���̺��� �����ϰ� ��Ī�� ���� 
			 	���� ���� > ���� ���������� �� �࿡ ���� ������ ����,
			 	b.bno�� �� �࿡ ���� ���� >>> ���� ������������ ����� �� ����
			 	�׷��� ��Ī c �� �� ���� �ƴ� ���̺� ��ü�� ���� �����̱� ������ ���������� ����� �� ���� 
			 */
			
			String sql = "";
			sql = " select "
			+ "    b.uno, "
			+ "    (select unick from user where uno = b.uno) as nick,  "
			+ "    (select uemail from user where uno = b.uno) as email, "
			+ "    (select urdate from user where uno = b.uno) as rdate, "
			+ "    count(b.uno) as report_count,  "
			+ "    (select ustate from user where uno = b.uno) as state "
			+ " from complaint_board c left join board b on c.bno = b.bno group by b.uno having count(b.uno) > 0 ";
			 sql += " LIMIT ? , ?"; //limit ���۰Խñ۹�ȣ(pagingUtil->start�ʵ�), ���
			 /* ����(pagingUtil->perPage�ʵ�)*/	
			 System.out.println("sql" + sql);
			 
			 
			 System.out.println("paging.getStartPage()::::"+paging.getStart());
			 System.out.println("paging.getPerPage()::::"+paging.getPerPage());
			
			psmt = conn.prepareStatement(sql);
			psmt.setInt(1, paging.getStart());
			psmt.setInt(2, paging.getPerPage());
			rs = psmt.executeQuery();
			
			ArrayList <UserVO> list = new ArrayList<>();
			
			while(rs.next()){
				UserVO vo = new UserVO();
				vo.setUnick(rs.getString("nick"));
				vo.setUemail(rs.getString("email"));
				vo.setUrdate(rs.getString("rdate"));
				vo.setDeclaration(rs.getInt("report_count"));
				vo.setUstate(rs.getString("state"));
				vo.setUno(rs.getString("uno"));
				list.add(vo);
				}
			request.setAttribute("list", list);
			request.setAttribute("paging", paging);
			// board �ۼ��� 
			request.getRequestDispatcher("/WEB-INF/admin/blackList.jsp").forward(request, response);
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			try {
				DBConn.close(rs,psmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	public void complainList (HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		
		// controller ���� 
		PreparedStatement psmtTotal = null;
		ResultSet rsTotal = null;

		int nowPage = 1;
		
		if(request.getParameter("nowPage") != null)
		{
			nowPage = Integer.parseInt(request.getParameter("nowPage"));
			System.out.println("nowPage========================== " + nowPage);
		}	
		
		try {
			conn = DBConn.conn();
			// ����¡
			String sqlTotal = " select count(*) as total"
					+"  from complaint_board c "
					+"  inner join board b "
					+"  on c.bno = b.bno "
					+"  inner join user u "
					+"  on c.uno = u.uno "
					+"  where b.state = 'E' ";
		
			psmtTotal=conn.prepareStatement(sqlTotal);
			rsTotal = psmtTotal.executeQuery();
			
			//��ü �Խñ� ���� ���� ����
			int total = 0; 
			
			if(rsTotal.next())
			{
				total = rsTotal.getInt("total");
			}
			PagingUtil paging = new PagingUtil(nowPage, total, 10);
			
						
			String sql ="";
			// sql ���� 
			sql = " select "
			+" c.bno, b.uno as uno, "
			+" count(c.bno) as cnt, "
			+" b.state, "
			+" (select title from board where bno = c.bno) as title, "
			+" (select rdate from board b where b.bno = c.bno) as rdate, "
			+" (select unick from user where uno = b.uno) as unick "
			+" from complaint_board c "
			+" left join board b on c.bno = b.bno "
			+" group by c.bno ";
			
			 sql += " LIMIT ? , ?"; //limit ���۰Խñ۹�ȣ(pagingUtil->start�ʵ�), ���
			 /* ����(pagingUtil->perPage�ʵ�)*/	
			 System.out.println("sql" + sql);
			
			psmt = conn.prepareStatement(sql);
			psmt.setInt(1,paging.getStart()); 
			psmt.setInt(2,paging.getPerPage());
			
			System.out.println("paging.getStartPage()::::"+paging.getStart());
			System.out.println("paging.getPerPage()::::"+paging.getPerPage());
			
			rs = psmt.executeQuery();
			
			ArrayList<BoardVO> board = new ArrayList<>();
			while(rs.next()){
				BoardVO vo = new BoardVO();
				vo.setDeclaration(rs.getInt("cnt"));
				vo.setUnick(rs.getString("unick"));
				vo.setTitle(rs.getString("title"));
				vo.setRdate(rs.getString("rdate"));
				vo.setState(rs.getString("state"));
				vo.setBno(rs.getInt("Bno"));
				board.add(vo);
				}
			
			request.setAttribute("board", board);
			request.setAttribute("paging", paging);
			// board �ۼ��� 
			request.getRequestDispatcher("/WEB-INF/admin/complainList.jsp").forward(request, response);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			try {
				DBConn.close(rs, psmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
		
		
	public void loadComplain(HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		String bno = request.getParameter("bno");
		String uno = "0";
		String state = "D";
		
		HttpSession session = request.getSession();
		if(session.getAttribute("loginUser") != null){
			UserVO user = (UserVO)session.getAttribute("loginUser");
			uno = user.getUno();
		}
		System.out.println("loadComplain ���� bno ��: " + bno + ", uno : " + uno);
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		
		try {
		    conn = DBConn.conn();

		    // ����ڰ� �� �Խù��� ��õ�ߴ��� Ȯ��
		    String sql = "select * from COMPLAINT_BOARD where uno = ? and bno = ?";
		    System.out.println("sql checkComplain: "+sql);
		    psmt = conn.prepareStatement(sql);
		    psmt.setString(1, uno);
		    psmt.setString(2, bno);
		    
		    rs = psmt.executeQuery();
		    
		    if(rs.next()) {
		    	state = "E";
		    }
		    
		    JSONObject jsonObj = new JSONObject(); 
		    jsonObj.put("bno", bno); 
		    jsonObj.put("state", state);

		    response.setContentType("application/json; charset=UTF-8");
		    response.getWriter().write(jsonObj.toString());
		} catch (Exception e) {
		    e.printStackTrace();
		} finally {
		    try {
				DBConn.close(rs, psmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	public void complainAdd(HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		HttpSession session = request.getSession();
		UserVO user = (UserVO)session.getAttribute("loginUser");
		String uno = user.getUno();
		String bno = request.getParameter("bno"); 

		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		String sql = "";
		String sqlA = "";
		PreparedStatement psmtA = null;

		String tuno = "";
		PreparedStatement psmtT = null;
		ResultSet rsT = null;
		
		PreparedStatement psmtL = null;
		ResultSet rsL = null;
		
		try {
		    conn = DBConn.conn();
		    
		    String sqlT = "select * from board where bno=?";
		    psmtT = conn.prepareStatement(sqlT);
		    psmtT.setString(1, bno);

		    rsT = psmtT.executeQuery();

		    if (rsT.next()) {
		    	tuno = rsT.getString("uno");
		    }

		    sql = "select * from COMPLAINT_BOARD where uno = ? and bno = ?";
		    psmt = conn.prepareStatement(sql);
		    psmt.setString(1, uno);
		    psmt.setString(2, bno);

		    rs = psmt.executeQuery();

		    if (rs.next()) {
		        // �Ű��� �̹� �����ϸ� delete
		    	sql = "delete from COMPLAINT_BOARD where uno = ? and bno = ?";
		        psmt = conn.prepareStatement(sql);
		        psmt.setString(1, uno);
		        psmt.setString(2, bno);
		        psmt.executeUpdate();
		        
		        sqlA = "delete from alram where no = ? and type=? ";
		        psmtA = conn.prepareStatement(sqlA);
		        psmtA.setString(1, rs.getString("cpno"));
		        psmtA.setString(2, "C");
		        psmtA.executeUpdate();
		    } else {
		        // �Ű��� ������ insert
		        sql = "insert into COMPLAINT_BOARD (uno, bno) values (?, ?)";
		        psmt = conn.prepareStatement(sql);
		        psmt.setString(1, uno);
		        psmt.setString(2, bno);
		        psmt.executeUpdate();
		        
	        	sql = "select last_insert_id() as cpno";
		        
		        psmtL = conn.prepareStatement(sql);
		        String cpno = "";
			    rsL = psmtL.executeQuery();
			    if(rsL.next()) {
			    	cpno = rsL.getString("cpno");
			    }
		        
		        sqlA = "insert into alram (uno, no, type) values (?, ?, ?)";
		        psmtA = conn.prepareStatement(sqlA);
		        psmtA.setString(1, tuno);
		        psmtA.setString(2, cpno);
		        psmtA.setString(3, "C");
		        psmtA.executeUpdate();
		    }
		    

		} catch (Exception e) {
		    e.printStackTrace();
		} finally {
		    try {
				DBConn.close(rs, psmt, conn);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	public void stopUser (HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		// ���ڵ� 
		request.setCharacterEncoding("UTF-8");
		
		//uno�� vo ��ü���� String���� ���� �Ǿ��ֱ� ������ 
		String uno = request.getParameter("uno");
		String ustate = request.getParameter("ustate");
		PrintWriter out = response.getWriter();
		// �ʿ��� ���� uno�� ustate �� �� �ϳ��� null�ΰ�� error�� �˷��ְ� return���� ���� ���� ��Ŵ
		if(uno == null || ustate == null) {
			out.print("error");
			return;
		}
		int unoInt = Integer.parseInt(uno);
		System.out.println(uno);
		
		Connection conn =null;
		PreparedStatement psmt = null;
		
		try {
			conn = DBConn.conn();
			String sql = "";
			// ajax���� ���ΰ�ħ ����� ������, �׿� ���� if���� �־�, ���ǿ� �°� ȸ���� ���¸� ������ �� ����
			if(ustate.equals("E")) {
				sql += "UPDATE user set ustate = 'D' WHERE uno = ?";
			}else {
				sql += "UPDATE user set ustate = 'E' WHERE uno = ?";
			}
			psmt = conn.prepareStatement(sql);
			psmt.setInt(1,unoInt);
			psmt.executeUpdate();
		
			response.setContentType("text/html;charset=UTF-8");
			out.print("success");  
			out.flush();
			out.close();   
			
		}catch(Exception e){
			e.printStackTrace();
			response.setContentType("text/html;charset=UTF-8");
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

	public void stopBoard (HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		// ���ڵ� 
		request.setCharacterEncoding("UTF-8");
		
		//uno�� vo ��ü���� String���� ���� �Ǿ��ֱ� ������ 
		String Strbno   = request.getParameter("bno");
		String state = request.getParameter("state");
		PrintWriter out = response.getWriter();
		// �ʿ��� ���� bno�� state �� �� �ϳ��� null�ΰ�� error�� �˷��ְ� return���� ���� ���� ��Ŵ
		if(Strbno == null || state == null) {
			out.print("error");
			return;
		}
		int bno = Integer.parseInt(Strbno);
		System.out.println("bno ===================================="+ bno);
		
		Connection conn =null;
		PreparedStatement psmt = null;
		
		try {
			conn = DBConn.conn();
			String sql = "";
			// ajax���� ���ΰ�ħ ����� ������, �׿� ���� if���� �־�, ���ǿ� �°� ȸ���� ���¸� ������ �� ����
			if(state.equals("E")) {
				sql += "UPDATE board set state = 'D' WHERE bno = ?";
			}else {
				sql += "UPDATE board set state = 'E' WHERE bno = ?";
			}
			psmt = conn.prepareStatement(sql);
			psmt.setInt(1,bno);
			psmt.executeUpdate();
		
			response.setContentType("text/html;charset=UTF-8");
			out.print("success");  
			out.flush();
			out.close();   
			
		}catch(Exception e){
			e.printStackTrace();
			response.setContentType("text/html;charset=UTF-8");
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
	
	
	

}