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
   if(request.getParameter("semId") != null && request.getParameter("deptId") != null && request.getParameter("subjectId") != null){
    String sem_id = request.getParameter("semId");
    String dept_id = request.getParameter("deptId");
    String subject_id = request.getParameter("subjectId");
    ps = conn.prepareStatement("select t1.subject_id,t2.default_book ,t2.book_id, t2.book_name , t3.author from dept_sem_subject t1 inner join subject_book t2 on t1.subject_id = t2.subject_id inner join books t3 on t3.id = t2.book_id where t1.dept_id = ? and t1.sem_id =? and t1.subject_id=? order by t2.book_name");
    ps.setString(1,dept_id);
    ps.setString(2,sem_id);
    ps.setString(3,subject_id);
    rs = ps.executeQuery();
    int num_rows = 0;
    while(rs.next()){
       JSONObject jsonObject = new JSONObject();
       jsonObject.put("book_id", rs.getString("book_id"));
       jsonObject.put("book_name", rs.getString("book_name"));
       jsonObject.put("author", rs.getString("author"));
       jsonObject.put("subject_id", rs.getString("subject_id"));
       jsonObject.put("default_book", rs.getString("default_book"));
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