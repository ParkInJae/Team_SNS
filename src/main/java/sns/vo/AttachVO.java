package sns.vo;

public class AttachVO {
 
	private int ano; 		// 외래키
	private int bno; 		// 외래키
	private String pname;
	private String fname;
	 
	public int getAno() {return ano;}
	public int getBno() {return bno;}
	public String getPname() {return pname;}
	public String getFname() {return fname;}
	
	public void setAno(int ano) {this.ano = ano;}
	public void setBno(int bno) {this.bno = bno;}
	public void setPname(String pname) {this.pname = pname;}
	public void setFname(String fname) {this.fname = fname;}
	
	
}
