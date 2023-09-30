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
   ResultSet rs1 = null;
  JSONArray jsonArray = new JSONArray();
   if(request.getParameter("semId") != null && request.getParameter("deptId") != null){
    String sem_id = request.getParameter("semId");
    String dept_id = request.getParameter("deptId");
    ps = conn.prepareStatement("select subject_name,subject_id from dept_sem_subject where dept_id=? and sem_id=? order by subject_name");
    ps.setString(1,dept_id);
    ps.setString(2,sem_id);
    rs = ps.executeQuery();
    int num_rows = 0;
    while(rs.next()){
      JSONArray jsonArray1 = new JSONArray();
       JSONObject jsonObject = new JSONObject();
       jsonObject.put("subject_id", rs.getString("subject_id"));
       jsonObject.put("subject_name", rs.getString("subject_name"));
         ps = conn.prepareStatement("select t2.book_id,t2.book_name,t3.author,t2.default_book from dept_sem_subject t1 inner join subject_book t2 on t1.subject_id=t2.subject_id inner join books t3 on t3.id=t2.book_id where t1.dept_id=? and t1.sem_id=? and t1.subject_id=? order by t2.default_book DESC,t2.book_name");
       ps.setString(1,dept_id);
       ps.setString(2,sem_id);
       ps.setString(3,rs.getString("subject_id"));
       rs1 = ps.executeQuery();
       while(rs1.next()){
         JSONObject jsonObject1 = new JSONObject();
         jsonObject1.put("book_id", rs1.getString("book_id"));
         jsonObject1.put("book_name", rs1.getString("book_name"));
         jsonObject1.put("default_book", rs1.getString("default_book"));
         jsonObject1.put("author", rs1.getString("author"));
         jsonArray1.add(jsonObject1);
       } 
          
       jsonObject.put("book_list", jsonArray1);
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
    System.out.println("books by subject"+e);
}
%>