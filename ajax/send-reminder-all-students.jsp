<%@ include file="../includes/config.jsp"%>
<%@ include file="../includes/lib.jsp"%>
<%@page contentType="application/json; charset=UTF-8"%>
<%@page import="org.json.simple.*"%>
<% 
String isLoggedInString = (String) session.getAttribute("isLoggedIn");
Boolean isLoggedIn = Boolean.valueOf(isLoggedInString);
if(!isLoggedIn) { 
      response.sendRedirect("../login.jsp");  
      return;
}
%>
<%
try{
  if(request.getParameter("upperDate") != null && request.getParameter("lowerDate") != null ){
      String upper_date = request.getParameter("upperDate");
      String lower_date = request.getParameter("lowerDate");
      String current_date = request.getParameter("currentDate");
      ps = conn.prepareStatement("select to_date(?,'YYYY-MM-DD')-to_date(assigned_date,'YYYY-MM-DD HH24:MI:SS') as assigned_days,t1.email,t1.full_name as student_name,t1.roll_no,to_char(to_date(t2.assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') as assigned_date,t4.name as book_name,t3.barcode,t3.isbn,t3.edition,t4.author,t3.price from students t1 inner join assigned_books t2 on t2.student_id=t1.id inner join book_units t3 on t3.id=t2.book_unit_id inner join books t4 on t4.id=t3.book_id where to_char(to_date(t2.assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') <= ? and to_char(to_date(t2.assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') >= ?");
      ps.setString(1,current_date);
      ps.setString(2,upper_date);
      ps.setString(3,lower_date);
      rs = ps.executeQuery();
      int num_rows=0;
      while(rs.next()){
          String email= rs.getString("email");
          String book_name= rs.getString("book_name");
          String barcode= rs.getString("barcode");
          String edition = rs.getString("edition");
          String isbn= rs.getString("isbn");
          String author= rs.getString("author");
          Float price= rs.getFloat("price");
          String assigned_date= rs.getString("assigned_date");
          int assigned_days= rs.getInt("assigned_days");
          String formatted_message = bookReminderMailinfo(book_name,barcode,isbn,edition,author,price,assigned_date,assigned_days);
          PreparedStatement ps1 = conn.prepareStatement("insert into mail_send(email,info)values(?,?)");
          ps1.setString(1,email);
          ps1.setString(2,formatted_message);
          ps1.executeQuery();
          num_rows++;
      }
      if(num_rows > 0){
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObject.put("status",true);
        jsonObject.put("message","Email send successfully to all students");
        jsonObjectContainer.put("data",jsonObject);
        out.print(jsonObjectContainer);
      }
      else{
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObject.put("status",false);
        jsonObject.put("message","something went wrong");
        jsonObjectContainer.put("data",jsonObject);
        out.print(jsonObjectContainer);
      }
  }
}
catch(Exception e){
  System.out.println("send-reminder-all-students"+e);
}
%>