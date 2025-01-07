package sns.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("*.do")
public class FrontController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public FrontController() {}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("frontcontroller 실행 url:"+request.getRequestURI());
		
		//1. 요청 uri 정보를 가지고 온다
		String uri = request.getRequestURI();
		
		//2. 프로젝트 경로를 가지고 온다.
		String contextPath = request.getContextPath();
		//3. 요청 uri에서 필요없는 프로젝트 경로를 제외한 uri를 가지고 온다
		String comment = uri.substring(contextPath.length()+1);
		/*
		/frontControllerPJT/sample/main.do에서
		/frontControllerPJT/ 부분이 잘림
		 */
		System.out.println(comment);
		
		//4. 3번에서 찾은 요청 경로에서 /를 기준으로 문자열을 자른다.
		String[] comments = comment.split("/");
		System.out.println("comments[0] : "+comments[0]);
		
		//5. 만들어진 문자열 배열의 첫번째 문자열이 어떤 컨트롤러로 기능을 요청해야할지 결정한다.
		if(comments[0].equals("board")) {
			BoardController board = new BoardController(request,response,comments);
		}else if(comments[0].equals("user")) {
			UserController user = new UserController(request,response,comments);
		}else if(comments[0].equals("admin")) {
			AdminController admin = new AdminController(request,response,comments);
			//SampleController 에게 처리 전달
		}else if(comments[0].equals("reply")) {
			CommentController reply = new CommentController(request,response,comments);
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("test post!!"+request.getParameter("title"));
		doGet(request, response);
	}
}