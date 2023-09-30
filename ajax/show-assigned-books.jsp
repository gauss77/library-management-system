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
   if(request.getParameter("studentId") != null){
     String student_id = request.getParameter("studentId");
     ps= conn.prepareStatement("select dept from students where id=?");
     ps.setString(1,student_id);
     rs = ps.executeQuery();
     rs.next();
     String dept_id = rs.getString("dept");
    ps = conn.prepareStatement("select t5.subject_name,t5.subject_id,t5.sem_name,t1.assigned_date,t2.barcode,t2.edition,t2.price,t2.isbn,t3.name as book_name,t3.id as book_id,t3.author from assigned_books t1 inner join book_units t2 on t2.id=t1.book_unit_id inner join books t3 on t3.id=t2.book_id inner join subject_book_rel t4 on t4.book_id=t3.id inner join dept_sem_subject t5 on (t5.subject_id=t4.subject_id and t5.sem_id=t1.sem_id) where t1.student_id=? and t5.dept_id=? union select (CASE WHEN t4.subject_id IS NULL THEN NULL ELSE (select t12.name from subjects t12 where t12.id=t4.subject_id) END) as subject_name,t4.subject_id as subject_id,(CASE WHEN t1.sem_id IS NULL THEN NULL ELSE (select t11.name from semesters t11 where t11.id=t1.sem_id) END) as sem_name,t1.assigned_date,t2.barcode,t2.edition,t2.price,t2.isbn,t3.name as book_name,t3.id as book_id,t3.author from assigned_books t1 inner join book_units t2 on t2.id=t1.book_unit_id inner join books t3 on t3.id=t2.book_id left join subject_book_rel t4 on t4.book_id=t3.id left join semesters t9 on t9.id=t1.sem_id where t2.id not in(select t2.id from assigned_books t1 inner join book_units t2 on t2.id=t1.book_unit_id inner join books t3 on t3.id=t2.book_id inner join subject_book_rel t4 on t4.book_id=t3.id inner join dept_sem_subject t5 on (t5.subject_id=t4.subject_id and t5.sem_id=t1.sem_id) where t1.student_id=? and t5.dept_id=?) and t1.student_id=?");
    ps.setString(1,student_id);
    ps.setString(2,dept_id);
    ps.setString(3,student_id);
    ps.setString(4,dept_id);
    ps.setString(5,student_id);
    rs = ps.executeQuery();
    int num_rows = 0;
    while(rs.next()){
       JSONObject jsonObject = new JSONObject();
       jsonObject.put("book_id", rs.getString("book_id"));
       jsonObject.put("book_name", rs.getString("book_name"));
       jsonObject.put("author", rs.getString("author"));
       jsonObject.put("subject_id", rs.getString("subject_id"));
       jsonObject.put("subject_name", rs.getString("subject_name"));
       jsonObject.put("sem_name", rs.getString("sem_name"));
       jsonObject.put("barcode", rs.getString("barcode"));
       jsonObject.put("isbn", rs.getString("isbn"));
       jsonObject.put("edition", rs.getString("edition"));
       jsonObject.put("price", rs.getFloat("price"));
       jsonObject.put("assigned_date", rs.getString("assigned_date"));
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
    System.out.println("show-assigned-books "+e);
}
%>