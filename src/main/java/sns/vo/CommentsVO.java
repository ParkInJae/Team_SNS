package sns.vo;

public class CommentsVO {

	private int cno;
	private int bno;
	private int uno;
	private int ano;
	private String content;
	private String rdate;
	private String state;
	private String unick;
	private String pname;
	 
	public CommentsVO(int cno, int bno, int uno, int ano, String content, String rdate, String state, String unick, String pname) {
		this.cno = cno;
		this.bno = bno;
		this.uno = uno;
		this.ano = ano;
		this.content = content;
		this.rdate = rdate;
		this.state = state;
		this.unick = unick;
		this.pname = pname;
	}
	
	
	public CommentsVO() {
		// TODO Auto-generated constructor stub
	}


	public int getCno() {return cno;}
	public int getBno() {return bno;}
	public int getUno() {return uno;}
	public int getAno() {return ano;}
	public String getContent() {return content;}
	public String getRdate() {return rdate;}
	public String getState() {return state;}
	public String getUnick() {return unick;}
	public String getPname() {return pname;}
	
	public void setCno(int cno) {this.cno = cno;}
	public void setBno(int bno) {this.bno = bno;}
	public void setUno(int uno) {this.uno = uno;}
	public void setAno(int ano) {this.ano = ano;}
	public void setContent(String content) {this.content = content;}
	public void setRdate(String rdate) {this.rdate = rdate;}
	public void setState(String state) {this.state = state;}
	public void setUnick(String unick) {this.unick = unick;}
	public void setPname(String pname) {this.pname = pname;}


	@Override
	public String toString() {
		return "CommentsVO [cno=" + cno + ", bno=" + bno + ", uno=" + uno + ", ano=" + ano + ", content=" + content
				+ ", rdate=" + rdate + ", state=" + state + ", unick=" + unick + ", pname=" + pname + "]";
	}
	
	
	

}
