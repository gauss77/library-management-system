<%@ include file="../includes/config.jsp"%>
<%@page contentType="application/json; charset=UTF-8"%>
<%@ page import="custom.DateProvider"%>
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
//out.print(request.getParameter("bookId"));
  try{
    JSONObject jsonObjectContainer = new JSONObject();
   if(request.getParameter("subjectId") != null && request.getParameter("bookId") != null){
     String subject_id = request.getParameter("subjectId");
     String book_id = request.getParameter("bookId");
     String date_created = DateProvider.getDate();
     ps = conn.prepareStatement("select count(*) as count from subject_book_rel where subject_id=? and book_id=?");
     ps.setString(1,subject_id);
     ps.setString(2,book_id);
     rs = ps.executeQuery();
     if(rs.next()){
       if(rs.getInt("count") == 0){
        ps = conn.prepareStatement("insert into subject_book_rel(subject_id,book_id,date_created) values (?,?,?)");
        ps.setString(1,subject_id);
        ps.setString(2,book_id);
        ps.setString(3,date_created);
        int check = ps.executeUpdate();
        if(check != 0){
          JSONObject jsonObject = new JSONObject();
          jsonObject.put("status",true);
          jsonObject.put("message","Book links to subject successfully");
          jsonObjectContainer.put("data",jsonObject);
          out.print(jsonObjectContainer);
        }
        else{
          JSONObject jsonObject = new JSONObject();
          jsonObject.put("status",false);
          jsonObject.put("message","Something went wrong");
          jsonObjectContainer.put("data",jsonObject);
          out.print(jsonObjectContainer);
        }
     }
     else{
         JSONObject jsonObject = new JSONObject();
          jsonObject.put("status",false);
          jsonObject.put("message","book already linked to subject");
          jsonObjectContainer.put("data",jsonObject);
          out.print(jsonObjectContainer);
     }
     }
   }
  }
  catch(Exception e){
    System.out.println(e);
    JSONObject jsonObjectContainer = new JSONObject();
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("status",false);
    jsonObject.put("message","Error occured, Please try again");
    jsonObjectContainer.put("data",jsonObject);
    out.print(jsonObjectContainer);
  }
  out.flush();
%>