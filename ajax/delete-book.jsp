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
  if(request.getParameter("bookId") != null){
      String book_id = request.getParameter("bookId");
      ps = conn.prepareStatement("delete from books where id=?");
      ps.setString(1,book_id);
      int check = ps.executeUpdate();
      if(check != 0){
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObject.put("status",true);
        jsonObject.put("message","Book successfully deleted");
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
}
catch(SQLException e){
 String message = e.getMessage();
 System.out.println("delete-book "+message);
 if(message.contains("LIBRARY.ASSIGNED_BOOKS_FK1")){
    JSONObject jsonObject = new JSONObject();
    JSONObject jsonObjectContainer = new JSONObject();
    jsonObject.put("status",false);
    jsonObject.put("message","Book unit of this book already assigned");
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
catch(Exception e){
 System.out.println("delete-book "+e);
 JSONObject jsonObject = new JSONObject();
 JSONObject jsonObjectContainer = new JSONObject();
 jsonObject.put("status",false);
 jsonObject.put("message","Error occured, Please try again");
 jsonObjectContainer.put("data",jsonObject);
 out.print(jsonObjectContainer);
}
%>