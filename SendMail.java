import java.util.*;
import java.sql.*;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.concurrent.TimeUnit;
class DBConnection{
    final String username = "library";
    final String password = "library123";
    final String url = "jdbc:oracle:thin:@//localhost:1521/orcl";
    Connection conn = null;
    DBConnection(){
        try{
            conn = DriverManager.getConnection(url,username,password);     
        }
        catch(Exception e){
            System.out.println(e); 
        }
      
    }
}
class MailScheduler{
    String email = null;
    String info = null;
    int id = 0;
    public void getDataFromDB(){
        DBConnection DB = new DBConnection();
        try{
            PreparedStatement ps = DB.conn.prepareStatement("select * from mail_send");
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                this.email = rs.getString("email");
                this.info = rs.getString("info");
                this.id = rs.getInt("id");
            }
            
        }
        catch(Exception e){
            System.out.println(e);  
        }
    }
    public void deleteRow(int id){
        DBConnection DB1 = new DBConnection();
        try{
            PreparedStatement ps = DB1.conn.prepareStatement("delete from mail_send where id=?");
            ps.setInt(1,id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                System.out.println("Email sent");
                this.email = null;
                this.info = null;
                this.id = 0;
            }
        }
        catch(Exception e){
            System.out.println(e);  
        }
    }
    public void mailSender(String to,String subject,String messg){
        final String from = "ki.xisk11@gmail.com";
        final String pass = "13572468@xisk";
    
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.user", from);
        props.put("mail.password", pass);
        props.put("mail.port", "465");
    
        Session mailSession = Session.getInstance(props, new Authenticator() {
            @Override
            public PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, pass);
            }
        });
        try {
            MimeMessage message = new MimeMessage(mailSession);
            message.setFrom(new InternetAddress(from));
            message.addRecipient(Message.RecipientType.TO,new InternetAddress(to));
            message.setSubject(subject);
            message.setContent(messg,"text/html");
            Transport.send(message);
        } catch (MessagingException mex) {
            mex.printStackTrace();
            System.out.println("mail-sender"+mex);

        }
    }
}
public class SendMail{
    public static void main(String[] args){
     
        while(true){
           
            try{
                // System.out.println("1");
                MailScheduler ms = new MailScheduler();
                ms.getDataFromDB();
                if(ms.email!=null){
                    System.out.println("Sending email to "+ms.email+"...");
                    // System.out.println(ms.info);
                    String email= ms.email;
                    String info = ms.info;
                    int id = ms.id;
                    ms.mailSender(email,"GTBPI Library",info);
                    ms.deleteRow(id);
                }
                else{
                    System.out.println("There is no task");
                }
                TimeUnit.SECONDS.sleep(1);
            }
            catch(Exception e){
                System.out.println(e);
            }
           
        }
    }
}