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
    String bookUnitId = request.getParameter("bookUnitId");
    String barcode = request.getParameter("barcode");
    String edition =request.getParameter("edition");
    String isbn =request.getParameter("isbn");
    String price =request.getParameter("price");
    String date_updated = currentDateTime();
    ps = conn.prepareStatement("update book_units set barcode=?,isbn=?,edition=?,price=?,date_updated=? where id=?");
    ps.setString(1,barcode);
    ps.setString(2,isbn);
    ps.setString(3,edition);
    ps.setString(4,price);
    ps.setString(5,date_updated);
    ps.setString(6,bookUnitId);
    int check = ps.executeUpdate();
    if(check != 0){
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObject.put("status",true);
        jsonObject.put("message","Book unit details updated successfully");
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