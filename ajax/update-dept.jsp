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
    String dept_name = capitalizeString(request.getParameter("deptName"));
    String date_updated = currentDateTime();
    ps = conn.prepareStatement("update departments set name=?,date_updated=? where id=?");
    ps.setString(1,dept_name);
    ps.setString(2,date_updated);
    ps.setString(3,dept_id);
    int check = ps.executeUpdate();
    if(check != 0){
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObject.put("status",true);
        jsonObject.put("message","Department details updated successfully");
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