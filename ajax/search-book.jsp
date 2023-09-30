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
   if(request.getParameter("searchQuery") != null){
     String search_query = request.getParameter("searchQuery");
    ps = conn.prepareStatement("select distinct t1.* from books t1 left join book_units t2 on t2.book_id=t1.id where t1.name like ? or t2.barcode=? order by t1.name fetch next 10 rows only");
    ps.setString(1,"%"+search_query+"%");
    ps.setString(2,search_query);
    rs = ps.executeQuery();
    int num_rows = 0;
    while(rs.next()){
       JSONObject jsonObject = new JSONObject();
       jsonObject.put("id", rs.getInt("id"));
       jsonObject.put("name", rs.getString("name"));
       jsonObject.put("author", rs.getString("author"));
       jsonObject.put("date_created", rs.getString("date_created"));
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
    out.flush();
  }
}
catch(Exception e){
    System.out.println("search book "+e);
}
%>