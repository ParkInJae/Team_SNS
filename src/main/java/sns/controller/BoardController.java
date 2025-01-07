package sns.controller;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import sns.util.DBConn;
import sns.vo.BoardVO;
import sns.vo.CommentsVO;
import sns.vo.UserVO;


public class BoardController {
	public BoardController(HttpServletRequest request
			, HttpServletResponse response
			, String[] comments) throws ServletException, IOException {
		
		if(comments[comments.length-1].equals("write.do")) {
			if(request.getMethod().equals("GET")) {
				write(request,response);
			}else if (request.getMethod().equals("POST")) {
				writeOk(request,response);
			}
		
		}else if (comments[comments.length-1].equals("view.do")) {
			view(request,response);
		}else if (comments[comments.length-1].equals("loadReco.do")) {
			loadReco(request,response);
		}else if (comments[comments.length-1].equals("recoAdd.do")) {
			recoAdd(request,response);
		}else if (comments[comments.length-1].equals("modify.do")) {
			if(request.getMethod().equals("GET")) {
				modify(request,response);
				}else if (request.getMethod().equals("POST")) {
					modifyOk(request,response);
				}
		}else if (comments[comments.length-1].equals("delete.do")) {
			deleteOk(request, response);
		}else if (comments[comments.length-1].equals("loadMore.do")) {
			loadMore(request, response);
		}else if(comments[comments.length-1].equals("followAdd.do")) {
		followAdd(request,response);
		} 
	}

	public void followAdd(HttpServletRequest request
		, HttpServletResponse response) throws ServletException, IOException {
	
	request.setCharacterEncoding("UTF-8");
	
	HttpSession session = request.getSession();
	UserVO loginUser = (UserVO)session.getAttribute("loginUser");
	// 폼 데이터 가져오기
	String uno = loginUser.getUno();
	int tuno = Integer.parseInt(request.getParameter("tuno"));

	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	String sql = "";


	try {
	    conn = DBConn.conn();

	    sql = " SELECT count(*) as cnt FROM sns.follow where uno=? and tuno=? ";

	    psmt = conn.prepareStatement(sql);
	   
		psmt.setString(1, uno);
	    psmt.setInt(2, tuno);

	    rs = psmt.executeQuery();
	    
	    int cnt = 0;
	    if(rs.next()) cnt = rs.getInt("cnt");

	    if (cnt>0) {
	    	
		    sql = " SELECT fno FROM sns.follow where uno=? and tuno=? ";
		    psmt = conn.prepareStatement(sql);
			psmt.setString(1, uno);
		    psmt.setInt(2, tuno);
		    rs = psmt.executeQuery();
		    
		    rs.next();
		    int fno = rs.getInt("fno");
	    	
	        // 추천이 이미 존재하면 delete
	    	sql = "delete from follow where uno = ? and tuno = ?";
	        psmt = conn.prepareStatement(sql);
	        psmt.setString(1, uno);
	        psmt.setInt(2, tuno);
	        psmt.executeUpdate();
	        
	    	sql = "delete from alram where no = ?";
	        psmt = conn.prepareStatement(sql);
	        psmt.setInt(1, fno);
	        psmt.executeUpdate();
	        
	    } else {
	        // 추천이 없으면 insert
	        sql = "insert into follow (uno, tuno) values (?, ?)";
	        System.out.println(sql);
	        psmt = conn.prepareStatement(sql);
	        psmt.setString(1, uno);
	        psmt.setInt(2, tuno);
	        System.out.println(psmt.executeUpdate());

	        //팔로우테이블에 새로들어간 데이터의 pk를 가져온
	        
	        sql = " SELECT last_insert_id() as no ";

		    psmt = conn.prepareStatement(sql);

		    rs = psmt.executeQuery();
		    
		    rs.next();
		    
	        
	        sql = "insert into alram (uno, no, type) values (?, ?, ?)";
	        System.out.println(sql);
	        psmt = conn.prepareStatement(sql);
	        psmt.setInt(1, tuno);
	        psmt.setInt(2, rs.getInt("no"));
	        psmt.setString(3, "F");
	        System.out.println(psmt.executeUpdate());
	        
	    }
	    
	    response.setCharacterEncoding("utf-8");
	    response.setContentType("text/html;");
	    response.getWriter().append("success").flush();

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

	
	public void write(HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/WEB-INF/board/write.jsp").forward(request, response);
	}
	
	public void writeOk(HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		/* String uploadPath = request.getServletContext().getRealPath("/upload"); */
		/*
		  String uploadPath = "C:\\DEV\\GIT\\first-SNS\\sns\\src\\main\\webapp\\upload";
		 */
		//String uploadPath = "D:\\pij\\Team\\first-SNS\\SNS\\src\\main\\webapp\\upload";
		String uploadPath = request.getServletContext().getRealPath("/upload");
		System.out.println("서버의 업로드 폴더 경로 : " + uploadPath);
		HttpSession session = request.getSession();
		UserVO loginUser = (UserVO)session.getAttribute("loginUser");
		int uno = Integer.parseInt(loginUser.getUno()); 
		
		int size = 10 * 1024 * 1024;
		MultipartRequest multi;
		try {
		    // 파일 업로드 처리
		    multi = new MultipartRequest(request, uploadPath, size, "UTF-8", new DefaultFileRenamePolicy());
		} catch (Exception e) {
			e.getStackTrace();
		    // 파일 업로드 실패 시 처리
		    response.sendRedirect(request.getContextPath());
		    return;
		}

		// input 타입에 파일이 여러개 존재하는 경우  
		Enumeration files = multi.getFileNames();
		/*
			// 파일이 input 타입에 한 개만 존재하는 경우 
			multi.getFilesystemName("attach");
		*/
		String filename = multi.getFilesystemName("attach");  // 원본 파일 이름
		String phyname = null;   // 서버에 저장될 파일 이름
		String title = multi.getParameter("title");
		String content = multi.getParameter("content");
		
		if (files.hasMoreElements()) {
		    String fileid = (String) files.nextElement();
		    filename = multi.getFilesystemName(fileid);  // 원본 파일 이름 가져오기

		    if (filename != null) {
		        System.out.println("업로드된 파일 이름: " + filename);
		        System.out.println("title:"+title);
		        System.out.println("content:"+content);
		        
		        // 물리 파일 이름 생성 (UUID 사용)
		        phyname = UUID.randomUUID().toString();  
		        
		        // 파일 경로 설정
		        String srcName = uploadPath + "/" + filename;  
		        String targetName = uploadPath + "/" + phyname;
		        
		        // 파일 이름 변경 (UUID로 저장)
		        File srcFile = new File(srcName);
		        File targetFile = new File(targetName);

		        boolean renamed = srcFile.renameTo(targetFile);
		        if (!renamed) {
		            System.out.println("파일 이름 변경 실패");
		        } else {
		            System.out.println("파일 이름 변경 성공: " + phyname);
		        }
		    }
		}
	
		if (phyname == null) phyname = "";
		if (filename == null) filename = "";
		
		Connection conn = null;			
		PreparedStatement psmt = null;
		
		Connection connAttach = null;			
		PreparedStatement psmtAttach = null;
		int resultAttach =0;
		try {
			conn = DBConn.conn();
			String sql = " INSERT INTO board (uno,title,content)"
					+ " VALUES(?,?,?)";
			// sql을 담고, 리턴 키를 받음
			psmt =conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
			psmt.setInt(1, uno);
			psmt.setString(2, title);
			psmt.setString(3, content);
			int result = psmt.executeUpdate();
			if(result>0) {
				//업데이트가 성공하면, getGeneratedKeys()를 통해서 키를 받아옴
				ResultSet rs = psmt.getGeneratedKeys();
				// 이때 getLong은 long타입이기 때문에 long타입의 변수를 생성해줘야함
				long key = 0L;
				if (rs.next()) {
				    key = rs.getLong(1);
				    
				}
				System.out.println("key의 값 : "+key); 
				String sql1 = " SELECT LAST_INSERT_ID() as bno ";
				sql1 = " INSERT INTO attach (bno, pname, fname) VALUES (?, ?, ?)";
				// select last_insert_id()를 받아와서 , bno를 대입 
				psmtAttach =conn.prepareStatement(sql1);
				psmtAttach.setLong(1, key);  // 통해 받아온 키를 bno에 저장함,
				psmtAttach.setString(2, phyname);  // 물리파일 이름 (서버에 저장된 파일의 이름)
				psmtAttach.setString(3, filename); // 원본 파일 이름 (사용자가 업로드한 파일 이름)
				resultAttach = psmtAttach.executeUpdate();
				
				System.out.println("result::"+result);
				System.out.println("result::"+ resultAttach);
				
				/*
				 // redirect는 새로고침 하기 때문에 ,ajax의 목적인 페이지를
				    새로고침하지 않고 서버와 데이터를 주고 받는게 될 수 없음
				response.sendRedirect(request.getContextPath()+"index.jsp");*/
				response.setContentType("text/html;charset=UTF-8");
				PrintWriter out = response.getWriter();  
				out.print("{\"result\" : \"success\", \"bno\" : "+key+"}");
				//success
				out.flush();
				out.close();
				
				          
			}
			
		}catch(Exception e) {
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
	
	public void view (HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		HttpSession session = request.getSession();
		UserVO loginUser = (UserVO)session.getAttribute("loginUser");
		String uno = "";
		if(loginUser != null) {
			uno = loginUser.getUno();
		}
		
		String bno = request.getParameter("bno");
		BoardVO vo = new BoardVO();
		
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		
		PreparedStatement psmtHit = null;
		
		PreparedStatement psmtComments = null;
		ResultSet rsc = null;
		
		try {
			conn = DBConn.conn();
			String sql = " SELECT b.*,u.unick,a.pname,a.fname, "
					+"   (select count(*) from love where bno = b.bno) as cnt, "
					+"   (select pname from user where uno = b.uno) as upname ";
			
			if(loginUser != null ) { sql += ",  (select count(*) from follow f where f.uno = ? and tuno = b.uno ) as isfollow "; }
			
			sql += "   FROM board b "
					+ " inner join user u " 
					+ " on b.uno = u.uno "
					+ " inner join attach a " 
					+ " on b.bno = a.bno "
					+"  WHERE b.bno=? and state='E' ";
			
			psmt = conn.prepareStatement(sql);
			if(loginUser != null ) {
				psmt.setInt(1, Integer.parseInt(uno));
				psmt.setInt(2, Integer.parseInt(bno));
			}else {
				psmt.setInt(1, Integer.parseInt(bno));
			}

			rs = psmt.executeQuery();
			
			if(rs.next()) {
				 vo.setBno(rs.getInt("bno"));
				 vo.setUno(rs.getInt("uno"));
				 vo.setTitle(rs.getString("title"));
				 vo.setContent(rs.getString("content"));
				 vo.setRdate(rs.getString("rdate"));
				 vo.setState(rs.getString("state"));
				 vo.setUnick(rs.getString("unick"));
				 vo.setPname(rs.getString("pname"));
				 vo.setFname(rs.getString("fname"));
				 vo.setRecommend(rs.getInt("cnt"));
				 vo.setUpname(rs.getString("upname"));
				 if(loginUser != null ) {
					 vo.setIsfollow(rs.getString("isfollow"));
				 }
				 
				 //조회수 증가
				 int hit = rs.getInt("hit");
				 String sqlHit = "update board set hit = ? where bno = ?";
				 hit++;
				 psmtHit = conn.prepareStatement(sqlHit);
				 psmtHit.setInt(1, hit);
				 psmtHit.setString(2, bno);
				 psmtHit.executeUpdate();
				
				 vo.setHit(hit);
			}
			
			//댓글목록 가져오기
			String sqlComments = " SELECT c.*,u.unick,u.pname "
					  + " FROM comments c "
					  + " INNER JOIN user u "
					  + " ON c.uno = u.uno "
					  + " WHERE bno = ? "
					  + " AND c.state = 'E' "
					  + " ORDER BY c.rdate desc ";
	
			psmtComments = conn.prepareStatement(sqlComments);
			psmtComments.setInt(1,Integer.parseInt(bno));
			rsc = psmtComments.executeQuery();
			
			List<CommentsVO> clist = new ArrayList<CommentsVO>();
			
			while(rsc.next()){
				CommentsVO cvo = new CommentsVO();
				cvo.setCno(rsc.getInt("cno"));
				cvo.setBno(rsc.getInt("bno"));
				cvo.setUno(rsc.getInt("uno"));
				cvo.setContent(rsc.getString("content"));
				cvo.setRdate(rsc.getString("rdate"));
				cvo.setState(rsc.getString("state"));
				cvo.setPname(rsc.getString("pname"));
				cvo.setUnick(rsc.getString("unick"));
				clist.add(cvo);
			}
			
			//리퀘스트에 담기
			request.setAttribute("clist", clist);
			request.setAttribute("board", vo);
			request.getRequestDispatcher("/WEB-INF/board/view.jsp").forward(request, response);
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			try {
				DBConn.close(rs, psmt, conn);
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
	}

	
	public void loadReco(HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		
		String bno = request.getParameter("bno");
		String uno = "0";
		String lState = "D";
		
		HttpSession session = request.getSession();
		if(session.getAttribute("loginUser") != null){
			UserVO user = (UserVO)session.getAttribute("loginUser");
			uno = user.getUno();
		}
		System.out.println("받은 bno 값: " + bno + ", uno : " + uno);
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		
		try {
		    conn = DBConn.conn();

		    // 사용자가 이 게시물을 추천했는지 확인
		    String checkReco = "select * from love where uno = ? and bno = ?";
		    System.out.println("sql checkReco: "+checkReco);
		    psmt = conn.prepareStatement(checkReco);
		    psmt.setString(1, uno);
		    psmt.setString(2, bno);
		    
		    rs = psmt.executeQuery();
		    
		    if(rs.next()) {
		    	lState = "E";
		    }
		    
		    String countReco = "select count(*) as rCnt from love where bno = ?";
	        psmt = conn.prepareStatement(countReco);
	        psmt.setString(1, bno);
	        rs = psmt.executeQuery();
	        int rCnt = 0;
	        if (rs.next()) {
	        	rCnt = rs.getInt("rCnt");
	        }
		    
		    
		    JSONObject jsonObj = new JSONObject(); 
		    jsonObj.put("bno", bno); 
		    jsonObj.put("lState", lState);
		    jsonObj.put("rCnt", rCnt);

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
	
	public void recoAdd(HttpServletRequest request
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

		String tuno = "";
		PreparedStatement psmtT = null;
		ResultSet rsT = null;
		PreparedStatement psmtA = null;

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
		    
		    

		    sql = "select lno from love where uno = ? and bno = ?";
		    psmt = conn.prepareStatement(sql);
		    psmt.setString(1, uno);
		    psmt.setString(2, bno);

		    rs = psmt.executeQuery();

		    if (rs.next()) {
		        // 추천이 이미 존재하면 delete
		    	sql = "delete from love where uno = ? and bno = ?";
		        psmt = conn.prepareStatement(sql);
		        psmt.setString(1, uno);
		        psmt.setString(2, bno);
		        psmt.executeUpdate();
		        
		        sqlA = "delete from alram where no = ? and type=? ";
		        psmtA = conn.prepareStatement(sqlA);
		        psmtA.setString(1, rs.getString("lno"));
		        psmtA.setString(2, "L");
		        psmtA.executeUpdate();
		    } else {
		        // 추천이 없으면 insert
		        sql = "insert into love (uno, bno) values (?, ?)";
		        psmt = conn.prepareStatement(sql);
		        psmt.setString(1, uno);
		        psmt.setString(2, bno);
		        psmt.executeUpdate();
		        
		        sql = "select last_insert_id() as lno";
		        
		        psmtL = conn.prepareStatement(sql);
		        String lno = "";
			    rsL = psmtL.executeQuery();
			    if(rsL.next()) {
			    	lno = rsL.getString("lno");
			    }
		        
		        sqlA = "insert into alram (uno, no, type) values (?, ?, ?)";
		        psmtA = conn.prepareStatement(sqlA);
		        psmtA.setString(1, tuno);
		        psmtA.setString(2, lno);
		        psmtA.setString(3, "L");
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
	
	public void modify(HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		int bno =Integer.parseInt(request.getParameter("bno"));
		
		Connection conn =null;
		PreparedStatement psmt= null;
		ResultSet rs = null;
		String sql = "";
		
		try {
			conn =DBConn.conn();
			sql = " select b.*,a.* "
					+ " from board b "
					+ " INNER JOIN attach a "
					+ " ON b.bno = a.bno "
					+ " where b.bno=? ";
			psmt = conn.prepareStatement(sql);
			psmt.setInt(1, bno);
			rs = psmt.executeQuery();
			
			BoardVO vo = new BoardVO();
			if(rs.next()) {
				vo.setBno(rs.getInt("bno"));
				vo.setTitle(rs.getString("title"));
				vo.setContent(rs.getString("content"));
				vo.setPname(rs.getString("pname"));
				vo.setFname(rs.getString("fname"));
			}
			request.setAttribute("vo", vo);
			request.getRequestDispatcher("/WEB-INF/board/modify.jsp").forward(request, response);
			
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			try {
				DBConn.close(rs, psmt, conn);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	public void modifyOk(HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		// 내용 수정한 내용을 저장해야함
		/*
		 	UPDATE board set title = ? content = ? where bno = ? 
		 */
		request.setCharacterEncoding("UTF-8");
		/* String uploadPath = request.getServletContext().getRealPath("/upload"); */
		String uploadPath = request.getServletContext().getRealPath("/upload");
		
		System.out.println("서버의 업로드 폴더 경로 : " + uploadPath);
	
		
		MultipartRequest multi;
		int size = 10 * 1024 * 1024;
		try {
		    // 파일 업로드 처리
		    multi = new MultipartRequest(request, uploadPath, size, "UTF-8", new DefaultFileRenamePolicy());
		} catch (Exception e) {
			e.getStackTrace();
		    // 파일 업로드 실패 시 처리
		    response.sendRedirect(request.getContextPath());
		    return;
		}
		// 바이너리 파일 >>> request 사용 x ,multi 사용
		int bno = Integer.parseInt(multi.getParameter("bno"));
		System.out.println(bno);
		// input 타입에 파일이 여러개 존재하는 경우  
		Enumeration files = multi.getFileNames();
		/*
			// 파일이 input 타입에 한 개만 존재하는 경우 
			multi.getFilesystemName("attach");
		*/
		String filename = multi.getFilesystemName("attach");  // 원본 파일 이름
		String phyname = null;   // 서버에 저장될 파일 이름
		String title = multi.getParameter("title");
		String content = multi.getParameter("content");
		
		if (files.hasMoreElements()) {
		    String fileid = (String) files.nextElement();
		    filename = multi.getFilesystemName(fileid);  // 원본 파일 이름 가져오기

		    if (filename != null) {
		        System.out.println("업로드된 파일 이름: " + filename);
		        System.out.println("title:"+title);
		        System.out.println("content:"+content);
		        
		        // 물리 파일 이름 생성 (UUID 사용)
		        phyname = UUID.randomUUID().toString();  
		        
		        // 파일 경로 설정
		        String srcName = uploadPath + "/" + filename;  
		        String targetName = uploadPath + "/" + phyname;
		        
		        // 파일 이름 변경 (UUID로 저장)
		        File srcFile = new File(srcName);
		        File targetFile = new File(targetName);

		        boolean renamed = srcFile.renameTo(targetFile);
		        if (!renamed) {
		            System.out.println("파일 이름 변경 실패");
		        } else {
		            System.out.println("파일 이름 변경 성공: " + phyname);
		        }
		    }
		}
	
		if (phyname == null) phyname = "";
		if (filename == null) filename = "";
		
		Connection conn = null;			
		PreparedStatement psmt = null;

		String existingFilename = null;
		String existingPhyename = null;
		PreparedStatement psmtExist = null;
		ResultSet rsExist = null;  
		
		
		Connection connAttach = null;			
		PreparedStatement psmtAttach = null;
		int resultAttach =0;
		try {
			conn = DBConn.conn();
			
			String sqlExist = "select * from attach where bno =?";
			psmtExist = conn.prepareStatement(sqlExist);
			psmtExist.setInt(1,bno);
			rsExist = psmtExist.executeQuery();
			
			if(rsExist.next()) {
				existingFilename = rsExist.getString("fname");
				existingPhyename = rsExist.getString("pname");
			}
			
			if (phyname == null || phyname.isEmpty()) 
			{
				phyname =  existingPhyename ;
			} 
			if (filename == null || filename.isEmpty()){
				filename = existingFilename ;
			} 
			
			String sql = " UPDATE board SET title = ?, content = ? "
					+ " WHERE bno =?";
			// sql을 담고, 리턴 키를 받음
			psmt =conn.prepareStatement(sql/*, PreparedStatement.RETURN_GENERATED_KEYS*/);
			psmt.setString(1, title);
			psmt.setString(2, content);
			psmt.setInt(3, bno);
			int result = psmt.executeUpdate();
			if(result>0) {
				if (filename != null && phyname != null ) {
				String sql1 = " UPDATE attach SET pname = ? , fname = ? "
						+ " WHERE bno = ?";
				// select last_insert_id()를 받아와서 , bno를 대입 
				psmtAttach =conn.prepareStatement(sql1);
				psmtAttach.setString(1, phyname);  // 물리파일 이름 (서버에 저장된 파일의 이름)
				psmtAttach.setString(2, filename); // 원본 파일 이름 (사용자가 업로드한 파일 이름)
				psmtAttach.setLong(3, bno);  // 통해 받아온 키를 bno에 저장함,
				resultAttach = psmtAttach.executeUpdate();
				}
				//  board 테이블 수정 여부 확인
				System.out.println("result::"+result);
				// attach 테이블 수정 여부 확인
				System.out.println("resultAttach::"+ resultAttach);
				
				/*
				 // redirect는 새로고침 하기 때문에 ,ajax의 목적인 페이지를
				    새로고침하지 않고 서버와 데이터를 주고 받는게 될 수 없음
				response.sendRedirect(request.getContextPath()+"index.jsp");*/
				response.setContentType("text/html;charset=UTF-8");
				PrintWriter out = response.getWriter();
				
				JSONObject json = new JSONObject();
				json.put("result", "success");
				json.put("bno", bno);   //Json은 키와 값으로 이루어져 있음
				
				out.print(json.toString());
				// out에 들어있는 값을 지움
				out.flush();
				// out을 닫음				
				out.close();          
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			response.setContentType("text/html;charset=UTF-8");
	        PrintWriter out = response.getWriter();   
	        JSONObject json = new JSONObject();
			json.put("result", "error");
			json.put("bno", bno);   //Json은 키와 값으로 이루어져 있음
			
			out.print(json.toString());
			// out에 들어있는 값을 지움
			out.flush();
			// out을 닫음				
			out.close();    
            
		}finally {
			try {
				DBConn.close(psmt, conn);
		        DBConn.close(rsExist, psmtExist, conn);
		        DBConn.close(psmtAttach, connAttach);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} 
	}


	public void deleteOk(HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		int bno = Integer.parseInt(request.getParameter("bno"));
		Connection conn = null;
		PreparedStatement psmt = null;
		String sql ="";
		try {
			conn = DBConn.conn();
			sql =" UPDATE board SET state = 'D' "
					+ " WHERE bno =? ";
			psmt=conn.prepareStatement(sql);
			psmt.setInt(1, bno);
			int result = psmt.executeUpdate();
			if(result > 0 ) {
				/*
				 // redirect는 새로고침 하기 때문에 ,ajax의 목적인 페이지를
				    새로고침하지 않고 서버와 데이터를 주고 받는게 될 수 없음
				response.sendRedirect(request.getContextPath()+"index.jsp");*/
				
				/*
				 1) 아래의 방법을 통해 서버가 클라이언트에 직접 응답을 보냄
				 2) 클라이언트가 요청에 대해 응답을 받고, JavaScript에서 처리함
	  			    {자바스크립트에서 적절한 동작(예: 페이지 리디렉션, 메시지 표시 등)}을 수행
				 3) 클라이언트 측 처리
					AJAX 요청의 성공 콜백 함수(success) 내에서 
					응답을 받아서 페이지를 업데이트하거나 다른 동작을 수행할 수 있고, 이때 새로 고침 없이 응답 결과에 따라 UI변경 가능 
				 */
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

	public void loadMore(HttpServletRequest request
			, HttpServletResponse response) throws ServletException, IOException {
		Connection conn = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;

		int indexpage = request.getParameter("indexpage") != null ? Integer.parseInt(request.getParameter("indexpage")) : 1;
	    int pageSize = 24;
	    int startRow = (indexpage - 1) * pageSize;
		
		JSONArray jsonArray = new JSONArray();
		
		try {
		    conn = DBConn.conn();
		    String sql = "select b.bno, pname "
		               + "from board b "
		               + "inner join attach a on b.bno = a.bno "
		               + "where b.state='E' "
		               + "order by bno desc "
		               + "limit ? offset ?";
		    psmt = conn.prepareStatement(sql);
		    psmt.setInt(1, pageSize);
		    psmt.setInt(2, startRow);

		    rs = psmt.executeQuery();
		    while (rs.next()) {
				JSONObject jsonObj = new JSONObject(); 
				jsonObj.put("bno", rs.getString("bno")); 
				jsonObj.put("pname", rs.getString("pname"));
				jsonArray.put(jsonObj);
		    }
		    response.setContentType("application/json; charset=UTF-8");
	        response.getWriter().write(jsonArray.toString());
		    
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
}