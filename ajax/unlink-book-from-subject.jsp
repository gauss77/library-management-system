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
  if(request.getParameter("subjectId") != null && request.getParameter("bookId") != null){
      String subject_id = request.getParameter("subjectId");
      String book_id = request.getParameter("bookId");
      ps = conn.prepareStatement("select count(t2.is_assigned) as count from assigned_books t1 inner join book_units t2 on t2.id=t1.book_unit_id inner join books t3 on t3.id=t2.book_id inner join subject_book_rel t4 on t4.book_id=t3.id where t4.subject_id=? and t4.book_id=?");
      ps.setString(1,subject_id);
      ps.setString(2,book_id);
      rs = ps.executeQuery();
      rs.next();
      if(rs.getInt("count") == 0){
         ps = conn.prepareStatement("delete from subject_book_rel where subject_id=? and book_id=?");
        ps.setString(1,subject_id);
         ps.setString(2,book_id);
        int check = ps.executeUpdate();
        if(check != 0){
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObject.put("status",true);
        jsonObject.put("message","Book successfully unlink from subject");
        jsonObjectContainer.put("data",jsonObject);
        out.print(jsonObjectContainer);
      }
      else{
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObject.put("status",false);
        jsonObject.put("message","Something went wrong");
        jsonObjectContainer.put("data",jsonObject);
        out.print(jsonObjectContainer);
      }
      }
      else{
          JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObject.put("status",false);
        jsonObject.put("message","Book unit of this book already assigned, please submit first then unlink");
        jsonObjectContainer.put("data",jsonObject);
        out.print(jsonObjectContainer);
      }
     
  }
}
/**
catch(SQLException e){
 String message = e.getMessage();
 System.out.println("delete-book "+message);
 if(message.contains("LIBRARY.SUBJECT_BOOK_REL_FK2")){
    JSONObject jsonObject = new JSONObject();
    JSONObject jsonObjectContainer = new JSONObject();
    jsonObject.put("status",false);
    jsonObject.put("message","Please unlink books first, then delete subject");
    jsonObjectContainer.put("data",jsonObject);
    out.print(jsonObjectContainer);
 }
 else{
    JSONObject jsonObject = new JSONObject();
    JSONObject jsonObjectContainer = new JSONObject();
    jsonObject.put("status",false);
    jsonObject.put("message","Unknown SQL Error");
    jsonObjectContainer.put("data",jsonObject);
    out.print(jsonObjectContainer);
}
}
**/
catch(Exception e){
 System.out.println("unlink-book-from-subject "+e);
 JSONObject jsonObject = new JSONObject();
 JSONObject jsonObjectContainer = new JSONObject();
 jsonObject.put("status",false);
 jsonObject.put("message","Error occured, Please try again");
 jsonObjectContainer.put("data",jsonObject);
 out.print(jsonObjectContainer);
}
%>