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
  if(request.getParameter("subjectId") != null && request.getParameter("semId") != null && request.getParameter("deptId") != null){
      String subject_id = request.getParameter("subjectId");
      String dept_id = request.getParameter("deptId");
      String sem_id = request.getParameter("semId");
         ps = conn.prepareStatement("delete from dept_sem_sub_relation where dept_id=? and sem_id=? and subject_id=?");
         ps.setString(1,dept_id);
         ps.setString(2,sem_id);
         ps.setString(3,subject_id);
        int check = ps.executeUpdate();
        if(check != 0){
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObject.put("status",true);
        jsonObject.put("message","Subject successfully unlink from department");
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
 System.out.println("unlink-subject-from-dept "+e);
 JSONObject jsonObject = new JSONObject();
 JSONObject jsonObjectContainer = new JSONObject();
 jsonObject.put("status",false);
 jsonObject.put("message","Error occured, Please try again");
 jsonObjectContainer.put("data",jsonObject);
 out.print(jsonObjectContainer);
}
%>