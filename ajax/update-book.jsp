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
    String book_name = capitalizeString(request.getParameter("bookName"));
    String author = capitalizeString(request.getParameter("author"));
    String date_updated = currentDateTime();
    ps = conn.prepareStatement("update books set name=?,author=?,date_updated=? where id=?");
    ps.setString(1,book_name);
    ps.setString(2,author);
    ps.setString(3,date_updated);
    ps.setString(4,book_id);
    int check = ps.executeUpdate();
    if(check != 0){
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObject.put("status",true);
        jsonObject.put("message","Book details updated successfully");
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
catch(Exception e){
    System.out.println("update-student "+e);
    JSONObject jsonObject = new JSONObject();
    JSONObject jsonObjectContainer = new JSONObject();
    jsonObject.put("status",false);
    jsonObject.put("message","Error occured! Please try again");
    jsonObjectContainer.put("data",jsonObject);
    out.print(jsonObjectContainer);
}
%>