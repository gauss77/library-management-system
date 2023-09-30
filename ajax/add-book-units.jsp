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
   if(request.getParameter("barcode") != null && request.getParameter("bookId") != null){
     String barcode = request.getParameter("barcode");
     String edition = request.getParameter("edition");
     String price = request.getParameter("price");
     String book_id = request.getParameter("bookId");
     String isbn = request.getParameter("isbn");
     String date_created = DateProvider.getDate();
     ps = conn.prepareStatement("select count(*) as count from book_units where barcode=?");
     ps.setString(1,barcode);
     rs = ps.executeQuery();
     if(rs.next()){
       if(rs.getInt("count") == 0){
        ps = conn.prepareStatement("insert into book_units(barcode,edition,price,book_id,date_created,isbn) values (?,?,?,?,?,?)");
        ps.setString(1,barcode);
        ps.setString(2,edition);
        ps.setString(3,price);
        ps.setString(4,book_id);
        ps.setString(5,date_created);
        ps.setString(6,isbn);
        int check = ps.executeUpdate();
        if(check != 0){
          JSONObject jsonObject = new JSONObject();
          jsonObject.put("status",true);
          jsonObject.put("message","Book unit added successfully");
          jsonObjectContainer.put("data",jsonObject);
          out.print(jsonObjectContainer);
        }
        else{
          JSONObject jsonObject = new JSONObject();
          jsonObject.put("status",false);
          jsonObject.put("message","something went wrong");
          jsonObjectContainer.put("data",jsonObject);
          out.print(jsonObjectContainer);
        }
     }
     else{
         JSONObject jsonObject = new JSONObject();
          jsonObject.put("status",false);
          jsonObject.put("message","data already exist");
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