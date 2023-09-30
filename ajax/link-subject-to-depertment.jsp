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
   if(request.getParameter("subjectId") != null && request.getParameter("deptId") != null && request.getParameter("semId") != null){
     String subject_id = request.getParameter("subjectId");
     String dept_id = request.getParameter("deptId");
     String sem_id = request.getParameter("semId");
     String date_created = DateProvider.getDate();
     ps = conn.prepareStatement("select count(*) as count from dept_sem_sub_relation where dept_id=? and sem_id=? and subject_id=?");
     ps.setString(1,dept_id);
     ps.setString(2,sem_id);
     ps.setString(3,subject_id);
     rs = ps.executeQuery();
     if(rs.next()){
       if(rs.getInt("count") == 0){
        ps = conn.prepareStatement("insert into dept_sem_sub_relation(dept_id,sem_id,subject_id,date_created) values (?,?,?,?)");
        ps.setString(1,dept_id);
        ps.setString(2,sem_id);
        ps.setString(3,subject_id);
        ps.setString(4,date_created);
        int check = ps.executeUpdate();
        if(check != 0){
          JSONObject jsonObject = new JSONObject();
          jsonObject.put("status",true);
          jsonObject.put("message","Subject links to department successfully");
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
          jsonObject.put("message","Subject already linked to department");
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