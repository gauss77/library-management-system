<%-- <%@ include file="./includes/config.jsp"%>
<%@ page import="java.util.*,java.util.Date"%>
<%!
  public class Test extends TimerTask{
      String name=null;
      public void run(){
          System.out.println(this.name);
          System.out.println(new Date()); 
      }
      public void setname(String name){
           this.name = name;
      }
      public String getname(){
          return this.name;
      }
  }
%>
<%
 ps = conn.prepareStatement("select * from students where id=?");
  ps.setString(1,"501");
  rs = ps.executeQuery();
  rs.next();
Timer timer = new Timer();
Test t1 = new Test();
t1.setname(rs.getString("full_name"));
timer.schedule(t1,0,10000); 
%> --%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>

<body>
  <div style="width:100%"><div style="height: 5rem;padding: 0.5rem;border-bottom: 1px solid #5f5f5f;display:flex"><div> <img width="72" height="72" src="http://www.gtbpi.in/img/logo-gtpbi-3.png" alt="GTBPI"></div><div style="padding: 13px 12px;"><h2 style="margin-left:0.5rem;;margin:0;">GTBPI</h2><p style="margin: 0;color: #474747;font-size: 0.9rem">Library</p></div></div><div style=" padding: 1rem;"><h2 style="color:#500050">This is reminder for submit book</h2><div style="font-weight: 600"><p>Book name: Kad dc xk xz</p><p>Author: Jsd sj sjsa adds</p><p>Barcode: 34fds23</p><p>ISBN: 34fds23</p><p>Edition: 1th</p><p>Price: 43.0&#8377; </p><p>Assigned Date: 2021-04-26</p></div><p>It has been 0 days. You didn't return this book. If you not return then it cause you to pay fine or if you lost this book then please pay book amount to Labrarian.</p></div><div style="height: 4rem;padding: 1rem;border-top: 1px solid #5f5f5f;"><p>GTBPI</p><p>Thank you</p></div></div>

</body>

</html>