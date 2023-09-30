<%@ include file="../includes/config.jsp"%>
<%@ page import="java.util.*"%>
<%@ page import="javax.mail.Authenticator,javax.mail.Message,javax.mail.MessagingException,javax.mail.PasswordAuthentication,javax.mail.Session,javax.mail.Transport,javax.mail.internet.AddressException,javax.mail.internet.InternetAddress,javax.mail.internet.MimeMessage"%>

<%!
public class MailScheduler extends TimerTask{
    String email = null;
    String info = null;
    int id = 0;
    public void run(){
        mailSender(this.email,"GTBPI Library",this.info);
        System.out.println("Mail send done");
        this.email = null;
        this.info = null;
        this.id = 0;
    }
    public void setEmail(String email){
         this.email = email;
    }
    public void setId(int id){
         this.id = id;
    }
    public void setInfo(String info){
         this.info = info;
    }
    public void mailSender(String to,String subject,String messg){
    //final String to = request.getParameter("to");
    //final String subject = request.getParameter("subject");
    //final String messg = request.getParameter("message");
    final String from = "ki.xisk11@gmail.com";
    final String pass = "admin_02";

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
%>
<%
    ps = conn.prepareStatement("select * from mail_send order by id");
    rs = ps.executeQuery();
    if(rs.next()){
        MailScheduler task = new MailScheduler();
        task.setEmail(rs.getString("email"));
        task.setInfo(rs.getString("info"));
        task.setId(rs.getInt("id"));
    if(task.email != null && task.info != null && task.id != 0){
        Timer timer = new Timer();
        timer.schedule(task,4000,15000);
        ps = conn.prepareStatement("delete from mail_send where id=?");
        ps.setInt(1,task.id);
        ps.executeQuery();
        System.out.println("deleted");
    }
    else{
        System.out.println("there is no task");
    }
    }
    else{
        System.out.println("there is no mail to send");
        MailScheduler task = new MailScheduler();
        Timer timer = new Timer();
        timer.schedule(task,4000,15000);
    }
%>