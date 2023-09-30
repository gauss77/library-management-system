<%@page language="java" pageEncoding="utf-8" %>
<%@ page import="java.sql.*, java.util.*, java.net.*, oracle.jdbc.*, oracle.sql.*, oracle.jsp.dbutil.*" %>

<%
// Change these details to suit your database and user details
 
final String connStr = "jdbc:oracle:thin:@//localhost:1521/orcl";
final String dbUser  = "library";
final String dbPass  = "library123";

request.setCharacterEncoding("UTF-8");
java.util.Properties info=new java.util.Properties();

Connection conn  = null;
PreparedStatement ps=null; 
ResultSet rs = null;
try{
    DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
    info.put("user", dbUser);
    info.put("password", dbPass);
    conn = DriverManager.getConnection(connStr,info);
}
catch(SQLException e){
    System.out.print(e);
}
%>

