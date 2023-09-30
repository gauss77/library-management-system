<%@ include file="./includes/config.jsp"%>
<%@ include file="./includes/lib.jsp"%>
<% 
String role = (String)session.getAttribute("role");
String isLoggedInString = (String) session.getAttribute("isLoggedIn");
Boolean isLoggedIn = Boolean.valueOf(isLoggedInString);
String error_message = null;
String success_message = null;
//out.print(role);
//out.print(isLoggedIn.getClass().getName()); 
if(!isLoggedIn) { 
      response.sendRedirect("./login.jsp");  
      return;
}
%>
 <%
  try{
  if(request.getParameter("roll_no") != null){
    String full_name=capitalizeString(request.getParameter("full_name"));
    String roll_no =request.getParameter("roll_no");
    String father_name =capitalizeString(request.getParameter("father_name"));
    String gender =request.getParameter("gender");
    String email =request.getParameter("email");
    String mobile_no =request.getParameter("mobile_no");
    String dob =request.getParameter("dob");
    String dept =request.getParameter("dept");
    String date_created = currentDateTime();
    ps = conn.prepareStatement("select count(*) as count from students where roll_no=?");
    ps.setString(1,roll_no);
    rs = ps.executeQuery();
    if(rs.next()){
       //out.print("count"+rs.getString("count"));
     if(rs.getInt("count")==0){
       //out.print(roll_no);
   ps = conn.prepareStatement("insert into students(full_name,roll_no,father_name,gender,email,mobile_no,dob,dept,date_created) values(?,?,?,?,?,?,?,?,?)");
   ps.setString(1,full_name);
   ps.setString(2,roll_no);
   ps.setString(3,father_name);
   ps.setString(4,gender);
   ps.setString(5,email);
   ps.setString(6,mobile_no);
   ps.setString(7,dob);
   ps.setString(8,dept);
   ps.setString(9,date_created);
   int check=ps.executeUpdate();
   if(check!=0){
       success_message ="Student registration done";
        //out.print("query success");
   }
   else{
        error_message ="Something went wrong";
       // out.print("query failed");
   }
}
else{
    error_message ="Student already registrated";
     }
}
} 
}
 
catch(SQLException e){
    System.out.print("SQLException: "+e);
    error_message ="Critical Error! Contact to Developer";
}
catch(Exception e){
    System.out.print("Exception: "+e);
}
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Student</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>

<body>
    <%@ include file="./includes/header.jsp" %>
    <div class="container-fluid" id="body">
        <div class="row">
           <div style="background: #3c4045;" class="col-md-2 px-0 border-right sidebar" id="sidebar">
           <%@ include file="./includes/sidebar.jsp" %>
           </div>
            <div class="col-md-10">
                <div class="body-container py-2">
                    <div class="border-bottom pb-2">
                        <h3>Student Registration</h3>
                    </div>
                    <%if(error_message != null){%>
                         <div class="alert alert-danger alert-dismissible fade show mt-2"><button type="button" class="close" data-dismiss="alert">&times;</button><%= error_message %></div>
                    <% } %>
                    <%if(success_message != null){%>
                        <div class="alert alert-success alert-dismissible fade show mt-2"><button type="button" class="close" data-dismiss="alert">&times;</button><%= success_message %></div>
                    <% } %>
                    <div class="m-4">
                        <form action="" method="post">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="full_name">Full Name:</label>
                                        <input title="Please enter student name" type="text" class="form-control" placeholder="Enter Full Name"
                                            id="full_name" name="full_name" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="father_name">Father Name:</label>
                                        <input type="text" class="form-control" placeholder="Enter Father Name"
                                            id="father_name" name="father_name" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="mobile_no">Mobile Number:</label>
                                        <input title="Mobile number should be 10 digits" pattern="[0-9]{10}" type="text" class="form-control" placeholder="Enter Mobile Number"
                                            id="mobile_no" name="mobile_no" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="department">Department:</label>
                                        <Select class="form-control" id="dept" name="dept" required>
                                            <option value="">Select Department</option>
                                            <%
                                            ps = conn.prepareStatement("Select id,name from departments order by name");
                                            rs = ps.executeQuery();
                                            while(rs.next()){
                                            %>
                                            <option value="<%= rs.getInt("id") %>"><%= rs.getString("name")%></option>
                                            <%
                                             }
                                            %>
                                        </Select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="roll_no">Roll No:</label>
                                        <input pattern="[0-9]{2,38}" title="Atleast 2 digits in roll number" type="text" class="form-control" placeholder="Enter Roll No" id="roll_no"
                                            name="roll_no" required>
                                    </div>
                                     <div class="form-group">
                                        <label for="gender">Gender:</label>
                                        <Select class="form-control" id="gender" name="gender" required>
                                            <option value="">Select Gender</option>
                                            <option value="male">Male</option>
                                            <option value="female">Female</option>
                                            <option value="other">Other</option>
                                        </Select>
                                    </div>
                                    <div class="form-group">
                                        <label for="email">Email:</label>
                                        <input pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" title="Enter a valid email" type="email" class="form-control" placeholder="Enter email" id="email"
                                            name="email" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="dob">DOB:</label>
                                        <input type="date" class="form-control" id="dob"
                                            name="dob" required>
                                    </div>
                                    <!-- <div class="form-group">
                                        <label for="dob">Upload Student Photo:</label>
                                        <input type="file" class="form-control" placeholder="Enter DOB" id="dob"
                                            name="dob">
                                    </div> -->
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="./includes/footer.jsp" %>
</body>

</html>