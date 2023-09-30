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
  if(request.getParameter("bookUnitId") != null){
      String bookunit_id = request.getParameter("bookUnitId");
      ps = conn.prepareStatement("select * from book_units where id=?");
      ps.setString(1,bookunit_id);
      rs = ps.executeQuery();
      if(rs.next()){
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("bookunit_id", rs.getInt("id"));
        jsonObject.put("barcode", rs.getString("barcode"));
        jsonObject.put("isbn", rs.getString("isbn"));
        jsonObject.put("edition", rs.getString("edition"));
        jsonObject.put("price", rs.getString("price"));
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