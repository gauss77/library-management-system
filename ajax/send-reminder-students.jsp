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
  if(request.getParameter("email") != null && request.getParameter("bookUnitId") != null ){
      String email = request.getParameter("email");
      String book_unit_id = request.getParameter("bookUnitId");
      String current_date = request.getParameter("currentDate");
      ps = conn.prepareStatement("select t2.name as book_name,t1.barcode,t1.edition,t1.isbn,t2.author,t1.price,to_date(?,'YYYY-MM-DD')-to_date(t3.assigned_date,'YYYY-MM-DD HH24:MI:SS') as assigned_days,to_char(to_date(t3.assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') as assigned_date from book_units t1 inner join books t2 on t2.id=t1.book_id inner join assigned_books t3 on t3.book_unit_id=t1.id where t3.book_unit_id=?");
      ps.setString(1,current_date);
      ps.setString(2,book_unit_id);
      rs = ps.executeQuery();
      if(rs.next()){
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
          JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObject.put("status",true);
        jsonObject.put("message","Email send successfully to student");
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