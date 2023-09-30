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
  JSONObject jsonObjectContainer = new JSONObject();
  JSONArray jsonArray = new JSONArray();
  
  if(request.getParameter("key") != null){
   String key = request.getParameter("key");
    ps = conn.prepareStatement("select * from students where roll_no like ? order by roll_no fetch next 10 rows only");
    ps.setString(1,key+"%");
    rs = ps.executeQuery();
    int num_rows = 0;
     //System.out.print(rs);
     
     while(rs.next()){
       JSONObject jsonObject = new JSONObject();
       jsonObject.put("q", rs.getString("roll_no"));
       jsonObject.put("user_search", key);
       jsonObject.put("search_key", rs.getString("full_name")+" ("+rs.getString("roll_no")+")");
       jsonArray.add(jsonObject);
       num_rows++;
     }

     if(num_rows > 0){
      
      jsonObjectContainer.put("data", jsonArray);
      out.print(jsonObjectContainer);
     }
     else{
       JSONObject jsonObject = new JSONObject();
        jsonObject.put("q", null);
       jsonObject.put("user_search", key);
       jsonObject.put("search_key", "Not found");
       jsonArray.add(jsonObject);
        jsonObjectContainer.put("data", jsonArray);
        out.print(jsonObjectContainer);
     }
      out.flush();
  }
%>