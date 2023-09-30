<%@ include file="./includes/config.jsp"%>
<%@ page import="java.lang.Math"%>
<%@ include file="./includes/weekly_book_status.jsp"%>
<% 
String role = (String)session.getAttribute("role");
String isLoggedInString = (String) session.getAttribute("isLoggedIn");
Boolean isLoggedIn = Boolean.valueOf(isLoggedInString);
String error_message = null;
String success_message = null;  
//out.print(isLoggedIn.getClass().getName()); 
if(!isLoggedIn) { 
      response.sendRedirect("./login.jsp");  
      return;
}
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Send Reminder to Students</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/css/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.1.0/chart.min.js"></script>
    <script src="//cdn.jsdelivr.net/npm/sweetalert2@10"></script>
</head>

<body>
    <%@ include file="./includes/header.jsp" %>
        <div class="container-fluid" id="body">
            <div class="row">
                <div style="background: #3c4045;" class="col-md-2 px-0 border-right sidebar" id="sidebar">
                    <%@ include file="./includes/sidebar.jsp" %>
                </div>
                <div class="col-md-10 pt-3">
                    <div style="display:flex;justify-content:space-between" class="text-secondary border-bottom mb-3 pb-2">
                        <h3 class="">Send Reminder to Students</h3>
                        <div style="display:flex;align-items:center;" class="">
                            <input id="upperDate" onchange="getStudentForReminder()" value="<%= request.getParameter("upperDate") %>" style="padding: 0.2rem 0.2rem; border-radius: 4px;width: 9rem;font-size: 1rem;" class="select-border-none bg-light" type="date">
                            <span class="mx-2">To</span>
                            <input id="lowerDate" onchange="getStudentForReminder()" value="<%= request.getParameter("lowerDate") %>" style="padding: 0.2rem 0.2rem; border-radius: 4px;width: 9rem;font-size: 1rem;" class="select-border-none bg-light" type="date">
                            <button style="float:right" class="btn btn-sm btn-danger ml-4" onclick="sendReminnderAllStudents()">Send reminder to all</button>
                        </div>
                    </div>
                    <div style="overflow-y: scroll;height: 77vh;overflow-x: hidden;">
                        <div class="row text-center font-weight-bold" style="background: aquamarine;padding: 8px 0px;margin: 0 auto;">
                            <div class="col-md-1">
                                <p class="m-0">S.No</p>
                            </div>
                            <div class="col-md-2">
                                <p class="m-0">Roll No</p>
                            </div>
                            <div class="col-md-3">
                                <p class="m-0">Student Name</p>
                            </div>
                            <div class="col-md-4">
                                <p class="m-0">Book Name</p>
                            </div>
                            <div class="col-md-2">
                                <p class="m-0">Action</p>
                            </div>
                        </div>
                    <%
                    int i=0;
                     ps = conn.prepareStatement("select t1.email,t1.full_name as student_name,t1.roll_no,t2.assigned_date,t4.name as book_name,t2.book_unit_id from students t1 inner join assigned_books t2 on t2.student_id=t1.id inner join book_units t3 on t3.id=t2.book_unit_id inner join books t4 on t4.id=t3.book_id where to_char(to_date(t2.assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') <= ? and to_char(to_date(t2.assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') >= ?");
                     ps.setString(1,request.getParameter("upperDate"));
                     ps.setString(2,request.getParameter("lowerDate"));
                     rs = ps.executeQuery();
                     while(rs.next()){
                    %>
                    <div class="row text-center bg-green">
                        <div class="col-md-1">
                                <p class="m-0 py-2"><%= i=i+1 %></p>
                        </div>
                        <div class="col-md-2">
                                <a class="text-decoration-none" href="./search-student.jsp?rollNo=<%= rs.getInt("roll_no") %>">
                                    <p class="m-0 py-2"><%= rs.getInt("roll_no") %></p>
                                </a>
                        </div>
                        <div class="col-md-3">
                                <p class="m-0 py-2"><%= rs.getString("student_name")%></p>
                        </div>
                        <div class="col-md-4">
                                <p class="text-truncate m-0 py-2" title="<%= rs.getString("book_name")%>"><%= rs.getString("book_name")%></p>
                        </div>
                        <div class="col-md-2">
                            <button class="btn btn-sm btn-info" style="margin-top: 5px;" onclick='sendReminderStudent("<%= rs.getString("email") %>","<%= rs.getString("book_unit_id") %>")'>Send Reminder</button>
                        </div>
                    </div>
                    <%}%>
                    </div>
                </div>
            </div>
        </div>
        <%@ include file="./includes/footer.jsp" %>
<script>
function getStudentForReminder(){
    const upperDate = $('#upperDate').val();
    const lowerDate = $('#lowerDate').val();
    if(upperDate != "" && lowerDate != ""){
        window.location='./send-reminder.jsp?upperDate='+upperDate+'&lowerDate='+lowerDate;
    }
    else{
        console.log("failed");
    }
}
function sendReminnderAllStudents(){
    const upperDate = $('#upperDate').val();
    const lowerDate = $('#lowerDate').val();
    let date = new Date();
    let date1 = date.getDate();
    let month = date.getMonth()+1;
    if(month < 10){
        month = "0"+month;
    }
    let year = date.getFullYear();
    const currentDate = year+"-"+month+"-"+date1;
    console.log(currentDate);
     if(upperDate != "" && lowerDate != ""){
        Swal.fire({
  title: 'Are you sure?',
  text: "You won't be able to revert this!",
  icon: 'warning',
  showCancelButton: true,
  confirmButtonColor: '#3085d6',
  cancelButtonColor: '#d33',
  confirmButtonText: 'Yes, send it!'
  }).then((result) => {
  if (result.isConfirmed){
    $.ajax({
		type: 'post',
        data:{
             upperDate:upperDate,
             lowerDate:lowerDate,
             currentDate:currentDate
        },
		url: './ajax/send-reminder-all-students.jsp',
		success: function(result) {
            console.log(result.data);
            if(result.data.status){
                Swal.fire(
                'Sent!',
                 result.data.message,
                'success'
                )
            }
            else{
              Swal.fire(
                'Error!',
                 result.data.message,
                'error'
               )
            }
		},
        error: function(err){
        console.log("error " +JSON.stringify(err));
        }
	});
  }
})
  }
  else{
      $('#studentListForReminder').html(` <div style="display:flex;justify-content:center;align-items:center;height: 50vh;">
                                                <p>Select both date to send reminder to students</p>
                                        </div>`)
  }
}
function sendReminderStudent(email,bookUnitId){
     let date = new Date();
    let date1 = date.getDate();
    let month = date.getMonth()+1;
    if(month < 10){
        month = "0"+month;
    }
    let year = date.getFullYear();
    const currentDate = year+"-"+month+"-"+date1;
    console.log(currentDate);
    console.log(email,bookUnitId);
  Swal.fire({
  title: 'Are you sure?',
  text: "You won't be able to revert this!",
  icon: 'warning',
  showCancelButton: true,
  confirmButtonColor: '#3085d6',
  cancelButtonColor: '#d33',
  confirmButtonText: 'Yes, send it!'
  }).then((result) => {
  if (result.isConfirmed){
    $.ajax({
		type: 'post',
        data:{
             email:email,
             bookUnitId:bookUnitId,
             currentDate:currentDate
        },
		url: './ajax/send-reminder-students.jsp',
		success: function(result) {
            console.log(result.data);
            if(result.data.status){
                Swal.fire(
                'Sent!',
                 result.data.message,
                'success'
                )
            }
            else{
              Swal.fire(
                'Error!',
                 result.data.message,
                'error'
               )
            }
		},
        error: function(err){
        console.log("error " +JSON.stringify(err));
        }
	});
  }
})
}
</script>
</body>

</html>