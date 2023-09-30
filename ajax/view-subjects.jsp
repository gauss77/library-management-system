<%@ include file="../includes/config.jsp"%>
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
   JSONArray jsonArray = new JSONArray();
   if(request.getParameter("deptId") != null && request.getParameter("semId") != null){
     String dept_id = request.getParameter("deptId");
     String sem_id = request.getParameter("semId");
    ps = conn.prepareStatement("select subject_id,subject_name from dept_sem_subject where dept_id=? and sem_id=?");
    ps.setString(1,dept_id);
    ps.setString(2,sem_id);
    rs = ps.executeQuery();
    int num_rows = 0;
    while(rs.next()){
       JSONObject jsonObject = new JSONObject();
       jsonObject.put("subject_id", rs.getString("subject_id"));
       jsonObject.put("subject_name", rs.getString("subject_name"));
       jsonArray.add(jsonObject);
       num_rows++;
    }
    if(num_rows > 0){
      JSONObject jsonObjectContainer = new JSONObject();
      jsonObjectContainer.put("data", jsonArray);
      jsonObjectContainer.put("isData", true);
       out.print(jsonObjectContainer);
    }
    else{
       JSONObject jsonObjectContainer = new JSONObject();
       jsonObjectContainer.put("data", jsonArray);
       jsonObjectContainer.put("isData", false);
       out.print(jsonObjectContainer);
    }
    //out.print(num_rows);
  }
  out.flush();
}
catch(Exception e){
    System.out.println("view subjects "+e);
}
%>