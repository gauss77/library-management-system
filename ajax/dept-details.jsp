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
      ps = conn.prepareStatement("select * from departments where id=?");
      ps.setString(1,dept_id);
      rs = ps.executeQuery();
      if(rs.next()){
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("dept_id", rs.getInt("id"));
        jsonObject.put("dept_name", rs.getString("name"));
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObjectContainer.put("data", jsonObject);
        jsonObjectContainer.put("isData", true);
        out.print(jsonObjectContainer);
      }
      else{
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObjectContainer.put("data", jsonObject);
        jsonObjectContainer.put("isData", false);
        out.print(jsonObjectContainer);
      }
  }
}
catch(Exception e){
  System.out.println("book-details"+e);
}
%>