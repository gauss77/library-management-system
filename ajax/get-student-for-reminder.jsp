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
  if(request.getParameter("upperDate") != null && request.getParameter("lowerDate") != null ){
      JSONArray jsonArray = new JSONArray();
      String upper_date = request.getParameter("upperDate");
      String lower_date = request.getParameter("lowerDate");
      ps = conn.prepareStatement("select t1.email,t1.full_name as student_name,t1.roll_no,t2.assigned_date,t4.name as book_name,t2.book_unit_id from students t1 inner join assigned_books t2 on t2.student_id=t1.id inner join book_units t3 on t3.id=t2.book_unit_id inner join books t4 on t4.id=t3.book_id where to_char(to_date(t2.assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') <= ? and to_char(to_date(t2.assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') >= ? fetch next 9 rows only");
      ps.setString(1,upper_date);
      ps.setString(2,lower_date);
      rs = ps.executeQuery();
      int num_rows=0;
      while(rs.next()){
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("roll_no", rs.getInt("roll_no"));
        jsonObject.put("student_name", rs.getString("student_name"));
        jsonObject.put("book_name", rs.getString("book_name"));
        jsonObject.put("book_unit_id", rs.getString("book_unit_id"));
        jsonObject.put("email", rs.getString("email"));
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
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObjectContainer.put("data", jsonObject);
        jsonObjectContainer.put("isData", false);
        out.print(jsonObjectContainer);
      }
  }
}
catch(Exception e){
  System.out.println("get-student-for-reminder"+e);
}
%>