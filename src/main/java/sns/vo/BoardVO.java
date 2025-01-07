package sns.vo;

public class BoardVO {
	private int bno;
	private String title;
	private int hit;
	private String state;
	private String rdate;
	private String content;
	private int uno;
	private String unick;
	private String pname;
	private String fname;
	private int recommend;
	private String upname;
	private String uemail;
	private int declaration; // ½Å°í
	private String urdate;
	private int cpno;
	private String isfollow;
	
	
	
	
	
	public BoardVO() {}

	public BoardVO(int bno, int uno, String title, String content, String rdate, int hit, String state,String unick) {
		
		this.bno = bno;
		this.uno = uno;
		this.title = title;
		this.content = content;
		this.rdate = rdate;
		this.hit = hit;
		this.state = state;
		this.unick = unick;
	}

	
	
	
	public String getUemail() {return uemail;}
	public String getUnick() {return unick;}
	public int getBno() {return bno;}
	public String getTitle() {return title;}
	public int getHit() {return hit;}
	public String getState() {return state;}
	public String getRdate() {return rdate;}
	public String getContent() {return content;}
	public int getUno() {return uno;}
	public String getPname() {return pname;}
	public String getFname() {return fname;}
	public int getRecommend() {return recommend;}
	public String getUpname() {return upname;}
	public int getDeclaration() {return declaration;}
	public String getUrdate() {return urdate;}
	public int getCpno() {return cpno;}
	
	
	
	public void setUemail(String uemail) {this.uemail = uemail;}
	public void setUnick(String unick) {this.unick = unick;}
	public void setBno(int bno) {this.bno = bno;}
	public void setTitle(String title) {this.title = title;}
	public void setHit(int hit) {this.hit = hit;}
	public void setState(String state) {this.state = state;}
	public void setRdate(String rdate) {this.rdate = rdate;}
	public void setContent(String content) {this.content = content;}
	public void setUno(int uno) {this.uno = uno;}
	public void setPname(String pname) {this.pname = pname;}
	public void setFname(String fname) {this.fname = fname;}
	public void setRecommend(int recommend) {this.recommend = recommend;}
	public void setUpname(String upname) {this.upname = upname;}
	public void setDeclaration(int declaration) {this.declaration = declaration;}
	public void setUrdate(String urdate) {this.urdate = urdate;}
	public void setCpno(int cpno) {this.cpno = cpno;}

	public String getIsfollow() {
		return isfollow;
	}

	public void setIsfollow(String isfollow) {
		this.isfollow = isfollow;
	}
	
	
	
}