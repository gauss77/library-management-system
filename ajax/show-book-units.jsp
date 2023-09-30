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
   if(request.getParameter("bookId") != null){
     String bookId = request.getParameter("bookId");
    ps = conn.prepareStatement("select * from book_units where book_id=? order by barcode");
    ps.setString(1,bookId);
    rs = ps.executeQuery();
    int num_rows = 0;
    while(rs.next()){
       JSONObject jsonObject = new JSONObject();
       jsonObject.put("id", rs.getInt("id"));
       jsonObject.put("barcode", rs.getString("barcode"));
       jsonObject.put("edition", rs.getString("edition"));
       jsonObject.put("price", rs.getFloat("price"));
       jsonObject.put("isbn", rs.getString("isbn"));
       jsonObject.put("is_assigned", rs.getString("is_assigned"));
       jsonObject.put("registration", rs.getString("date_created"));
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
    out.flush();
  }
}
catch(Exception e){
    System.out.println("show book details "+e);
}
%>