package sns.util;

public class PagingUtil {
	// (o) -> 외부에서 받아올 연산에 필요한 데이터를 담을 필도 
	// (o) 없는 데이터 : o데이터들을 활용하여 연산된 결과를 담을 필드
	private int nowPage; // 현제페이지 번호 (o)
	private int startPage; // 시작 페이지 번호 
	private int endPage; // 종료 페이지 번호		
	private int total ; // 전체 게시글 수 (o)
	private int perPage ; // 한 페이지당 게시글 갯수(o)
	private int lastPage ; // 최종페이지 번호
	private int start ; // 시작 게시글 번호
	private int end ; // 시작 게시글 번호
	private int cntPage=5; // 한 페이지에서 보여지는 페이징 번호의 개수(o)

	public PagingUtil(){}
	public PagingUtil(int nowPage, int total, int perPage) {
		setNowPage(nowPage);
		setTotal(total);
		setPerPage(perPage);
		
		calcStartEnd(nowPage, perPage); // 시작번호 종료번호 연산기능 호출
		calcLastPage(total, perPage); // 시작번호 종료번호 연산기능 호출
		calcStarEndPage(nowPage, cntPage); // 시작번호 종료번호 연산기능 호출
	}
	
	
	public void calcStartEnd(int nowPage, int perPage) {
		int end = nowPage * perPage; // 게시글 종료번호(oracle에서 사용함)
		
		/*
		 현재 페이지 : 1 / 게시글 노출 개수 : 5
		  종료 번호 :1*5 = 5
		  시작번호  : 종료번호 - 게시글 노출개수 
		 */
		// 게시글 시작번호(oracle에서는 +1을 해야함)
		int start = end - perPage; // 종료 변호 - 게시글 노출 개수
		setEnd(end);
		setStart(start);
	}
	public void calcLastPage(int total, int perPage) {
		// 전체 게시글에서 페이지당 게시글 수를 나눈 실수를 올림처리 한 값을 반환
		int lastPage = (int)Math.ceil((double)total/perPage);
		setLastPage(lastPage);
	}
	public void calcStarEndPage(int nowPage, int cntPage) {
		
		// 현재페이지의 10의 자리를 구해와 +1한 후 페이지당 노출 페이지 개수를 구하기 
		int endPage = (int)Math.ceil((double)nowPage/cntPage)*cntPage;
		
		int StartPage = endPage - cntPage + 1;
		
		if(endPage > lastPage) {
			endPage=lastPage;
		}
		setEndPage(endPage);
		setStartPage(StartPage);
	}
	
	
	public int getNowPage() {return nowPage;}
	public int getStartPage() {return startPage;}
	public int getEndPage() {return endPage;}
	public int getTotal() {return total;}
	public int getPerPage() {return perPage;}
	public int getLastPage() {return lastPage;}
	public int getStart() {return start;}
	public int getEnd() {return end;}
	public int getCntPage() {return cntPage;}
	
	public void setNowPage(int nowPage) {this.nowPage = nowPage;}
	public void setStartPage(int startPage) {this.startPage = startPage;}
	public void setEndPage(int endPage) {this.endPage = endPage;}
	public void setTotal(int total) {this.total = total;}
	public void setPerPage(int perPage) {this.perPage = perPage;}
	public void setLastPage(int lastPage) {this.lastPage = lastPage;}
	public void setStart(int start) {this.start = start;}
	public void setEnd(int end) {this.end = end;}
	public void setCntPage(int cntPage) {this.cntPage = cntPage;}
	
	
	
}
