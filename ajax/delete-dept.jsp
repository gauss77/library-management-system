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
  if(request.getParameter("deptId") != null){
      String dept_id = request.getParameter("deptId");
      ps = conn.prepareStatement("delete from departments where id=?");
      ps.setString(1,dept_id);
      int check = ps.executeUpdate();
      if(check != 0){
        ps = conn.prepareStatement("update students set dept=0 where dept=?");
        ps.setString(1,dept_id);
        ps.executeQuery();
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObject.put("status",true);
        jsonObject.put("message","Depertment successfully deleted");
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
 System.out.println("delete-dept "+e);
 JSONObject jsonObject = new JSONObject();
 JSONObject jsonObjectContainer = new JSONObject();
 jsonObject.put("status",false);
 jsonObject.put("message","Error occured, Please try again");
 jsonObjectContainer.put("data",jsonObject);
 out.print(jsonObjectContainer);
}
%>