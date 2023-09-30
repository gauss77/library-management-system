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
//out.print(request.getParameter("bookId"));
  try{
    JSONObject jsonObjectContainer = new JSONObject();
   if(request.getParameter("subjectId") != null && request.getParameter("bookId") != null){
     String subject_id = request.getParameter("subjectId");
     String book_id = request.getParameter("bookId");
     ps = conn.prepareStatement("update subject_book_rel set default_book=0 where subject_id=?");
     ps.setString(1,subject_id);
     ps.executeQuery();
     ps = conn.prepareStatement("update subject_book_rel set default_book=1 where subject_id=? and book_id=?");
     ps.setString(1,subject_id);
     ps.setString(2,book_id);
     int check = ps.executeUpdate();
     if(check != 0){
      JSONObject jsonObject = new JSONObject();
      jsonObject.put("status",true);
      jsonObject.put("message","marked as a default book");
      jsonObjectContainer.put("data",jsonObject);
      out.print(jsonObjectContainer);
     }
     else{
       JSONObject jsonObject = new JSONObject();
      jsonObject.put("status",false);
      jsonObject.put("message","something went wrong");
      jsonObjectContainer.put("data",jsonObject);
      out.print(jsonObjectContainer);
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