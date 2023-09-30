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
PreparedStatement ps1 = null;
ResultSet rs1 = null;
try{
  if(request.getParameter("barcode") != null && request.getParameter("studentId") != null){
    String barcode = request.getParameter("barcode");
    String student_id = request.getParameter("studentId");
    String submitted_date = currentDateTime();
    ps = conn.prepareStatement("select t1.is_assigned,t1.id as book_unit_id from book_units t1 inner join assigned_books t2 on t2.book_unit_id=t1.id where t2.student_id=? and t1.barcode=?");
    ps.setString(1,student_id);
    ps.setString(2,barcode);
    rs = ps.executeQuery();
    if(rs.next()){
          if(rs.getInt("is_assigned") == 1){
           ps1 = conn.prepareStatement("select assigned_date from assigned_books where book_unit_id=?");
           ps1.setString(1,rs.getString("book_unit_id"));
           rs1 = ps1.executeQuery();
           rs1.next();   
           ps = conn.prepareStatement("insert into submitted_books(student_id,book_unit_id,submitted_date,assigned_date) values(?,?,?,?)");
           ps.setString(1,student_id);
           ps.setString(2,rs.getString("book_unit_id"));
           ps.setString(3,submitted_date);
           ps.setString(4,rs1.getString("assigned_date"));
           ps.executeQuery();
           ps = conn.prepareStatement("delete from assigned_books where book_unit_id=?");
           ps.setString(1,rs.getString("book_unit_id"));
           ps.executeQuery();
           ps = conn.prepareStatement("update book_units set is_assigned=0 where id=?");
           ps.setString(1,rs.getString("book_unit_id"));
           int check = ps.executeUpdate();
           if(check != 0){
            JSONObject jsonObject = new JSONObject();
            JSONObject jsonObjectContainer = new JSONObject();
            jsonObject.put("status",true);
            jsonObject.put("message","Book unit successfully submitted");
            jsonObjectContainer.put("data",jsonObject);
            out.print(jsonObjectContainer);
            PreparedStatement ps3 = conn.prepareStatement("select t2.name as book_name,t2.author,t1.barcode,t1.edition,t1.isbn from book_units t1 inner join books t2 on t2.id=t1.book_id where t1.id=?");
            ps3.setString(1,rs.getString("book_unit_id"));
            ResultSet rs3 = ps3.executeQuery();
            rs3.next();
            String book_name = rs3.getString("book_name");
            String edition = rs3.getString("edition");
            String isbn = rs3.getString("isbn");
            String author = rs3.getString("author");
            PreparedStatement ps2 = conn.prepareStatement("select email from students where id=?");
            ps2.setString(1,student_id);
            ResultSet rs2 = ps2.executeQuery();
            rs2.next();
            String formatted_message = submitBookMailInfo(book_name,barcode,isbn,edition,author);
            ps = conn.prepareStatement("insert into mail_send(email,info) values (?,?)");
            ps.setString(1,rs2.getString("email"));
            ps.setString(2,formatted_message);
            ps.executeQuery();
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
        else{
          JSONObject jsonObject = new JSONObject();
          JSONObject jsonObjectContainer = new JSONObject();
          jsonObject.put("status",false);
          jsonObject.put("message","book unit not assigned yet, Try again");
          jsonObjectContainer.put("data",jsonObject);
          out.print(jsonObjectContainer);
        }
    } 
    else{
          ps = conn.prepareStatement("select is_assigned from book_units where barcode=?");
          ps.setString(1,barcode);
          rs = ps.executeQuery();
          if(rs.next()){
             if(rs.getInt("is_assigned") == 1){
            JSONObject jsonObject = new JSONObject();
            JSONObject jsonObjectContainer = new JSONObject();
            jsonObject.put("status",false);
            jsonObject.put("message","Book unit assigned to other student, Try again");
            jsonObjectContainer.put("data",jsonObject);
            out.print(jsonObjectContainer);
          }
          else{
            JSONObject jsonObject = new JSONObject();
            JSONObject jsonObjectContainer = new JSONObject();
            jsonObject.put("status",false);
            jsonObject.put("message","book unit not assigned yet, Try again");
            jsonObjectContainer.put("data",jsonObject);
            out.print(jsonObjectContainer);
          }
          }
          else{
            JSONObject jsonObject = new JSONObject();
            JSONObject jsonObjectContainer = new JSONObject();
            jsonObject.put("status",false);
            jsonObject.put("message","Book unit not found, Try again");
            jsonObjectContainer.put("data",jsonObject);
            out.print(jsonObjectContainer);
          }
        }   
  }
}
catch(Exception e){
    System.out.println("ajax submit book "+e);
    JSONObject jsonObject = new JSONObject();
    JSONObject jsonObjectContainer = new JSONObject();
    jsonObject.put("status",false);
    jsonObject.put("message","Error occured, Please try again");
    jsonObjectContainer.put("data",jsonObject);
    out.print(jsonObjectContainer);
}
%>