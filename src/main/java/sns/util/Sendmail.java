package sns.util;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class Sendmail {
    private String from;  //보내는 사람 메일주소
    private String to;    //받는 사람 메일주소
    private String title; //메일 제목
    private String body;  //메일 내용
    private String id;    //계정 아이디
    private String pw;    //계정 비밀번호

    public void setTo(String to)     { this.to = to;     }
    public void setFrom(String from) { this.from = from; }
    public void setMail(String title, String body) {
        this.title = title;
        this.body  = body;
    }
    public void setAccount(String id, String pw) {
        this.id = id;
        this.pw = pw;
    }

    // max 자리의 인증코드를 생성한다.
    public String AuthCode(int max) {
        String datas = "01234567890abcdefghijklmnopqrstuvwxyz";
        String code = "";
        for (int i = 0; i < max; i++) {
            int rand = (int)(Math.random() * datas.length());
            code += datas.charAt(rand);
        }
        return code;
    }

    // 메일을 발송한다.
    public boolean sendMail() {
        try {
            System.out.println("메일 발송을 시작합니다.");

            Properties clsProp = new Properties();
            clsProp.put("mail.smtp.host", "smtp.naver.com");
            clsProp.put("mail.smtp.port", "465");
            clsProp.put("mail.smtp.auth", "true");
            clsProp.put("mail.smtp.ssl.enable", "true"); 
            // TLS 활성화
            clsProp.put("mail.smtp.starttls.enable", "true");
            // SSL 프로토콜 명시
            clsProp.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            clsProp.put("mail.smtp.ssl.trust", "smtp.naver.com");
            
            Session clsSession = Session.getInstance(clsProp, new Authenticator() {
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(id, pw);
                }
            });

            Message clsMessage = new MimeMessage(clsSession);
            clsMessage.setFrom(new InternetAddress(from));
            clsMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
            clsMessage.setSubject(title);
            clsMessage.setContent(body, "text/html;charset=UTF-8");

            Transport.send(clsMessage);
            System.out.println("메일 발송이 성공적으로 완료되었습니다.");

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("메일 발송에 실패하였습니다: " + e.getMessage());
            return false;
        }
    }
}
