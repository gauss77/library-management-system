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
   if(request.getParameter("studentRollno") != null || request.getParameter("studentId") != null){
     String roll_no = request.getParameter("studentRollno");
     String student_id = request.getParameter("studentId");
    ps = conn.prepareStatement("select t1.dob,t1.dept,t1.id,t1.full_name,t1.father_name,t1.roll_no,t1.gender,t1.mobile_no,t1.email,to_char(to_date(t1.dob,'YYYY-MM-DD'),'DD-MM-YYYY') as formatted_dob,to_char(to_date(t1.date_created,'YYYY-MM-DD HH24:MI:SS'),'DD-MM-YYYY') as date_created,t2.name as dept_name from students t1 inner join departments t2 on t2.id = t1.dept where t1.roll_no=? or t1.id=? fetch next 1 rows only");
    ps.setString(1,roll_no);
    ps.setString(2,student_id);
    rs = ps.executeQuery();
    if(rs.next()){
       JSONObject jsonObject = new JSONObject();
       jsonObject.put("student_id", rs.getInt("id"));
       jsonObject.put("full_name", rs.getString("full_name"));
       jsonObject.put("father_name", rs.getString("father_name"));
       jsonObject.put("roll_no", rs.getInt("roll_no"));
       jsonObject.put("gender", rs.getString("gender"));
       jsonObject.put("dob", rs.getString("dob"));
       jsonObject.put("formatted_dob", rs.getString("formatted_dob"));
       jsonObject.put("mobile_no", rs.getString("mobile_no"));
       jsonObject.put("email", rs.getString("email"));
       jsonObject.put("dept", rs.getString("dept_name"));
       jsonObject.put("dept_id", rs.getString("dept"));
       jsonObject.put("registration", rs.getString("date_created"));
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
    out.flush();
  }
}
catch(Exception e){
    System.out.println(e);
}
%>
