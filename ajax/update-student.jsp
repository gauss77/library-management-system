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
  if(request.getParameter("sId") != null){
    String id = request.getParameter("sId");
    String full_name=capitalizeString(request.getParameter("sName"));
    String roll_no =request.getParameter("sRollno");
    String father_name =capitalizeString(request.getParameter("sFathername"));
    String gender =request.getParameter("sGender");
    String email =request.getParameter("sEmail");
    String mobile_no =request.getParameter("sMobileno");
    String dob =request.getParameter("sDob");
    String dept =request.getParameter("sDept");
    String date_updated = currentDateTime();
    ps = conn.prepareStatement("update students set full_name=?,roll_no=?,father_name=?,gender=?,email=?,mobile_no=?,dob=?,dept=?,date_updated=? where id=?");
    ps.setString(1,full_name);
    ps.setString(2,roll_no);
    ps.setString(3,father_name);
    ps.setString(4,gender);
    ps.setString(5,email);
    ps.setString(6,mobile_no);
    ps.setString(7,dob);
    ps.setString(8,dept);
    ps.setString(9,date_updated);
    ps.setString(10,id);
    int check = ps.executeUpdate();
    if(check != 0){
        JSONObject jsonObject = new JSONObject();
        JSONObject jsonObjectContainer = new JSONObject();
        jsonObject.put("status",true);
        jsonObject.put("message","Student details updated successfully");
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