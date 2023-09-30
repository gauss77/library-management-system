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
    <title>Dashboard</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
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
                <div class="col-md-10 pt-3" style="height: 88vh;overflow-y: scroll;">
                    <div class="row">
                        <div class="col-md-3">
                            <div style="background:aquamarine;" class="custom-card p-3">
                                <p class="text-secondary m-0">Total Registered Students</p>
                                <%
                                  ps = conn.prepareStatement("select count(*) as count from students where not dept=0");
                                  rs = ps.executeQuery();
                                  rs.next();
                                %>
                                <h1><%= rs.getInt("count") %></h1>
                                
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div style="background:lightgreen;" class="custom-card p-3">
                                <p class="text-secondary m-0">Total Books</p>
                                 <%
                                  ps = conn.prepareStatement("select count(*) as count from Books");
                                  rs = ps.executeQuery();
                                  rs.next();
                                %>
                                <h1><%= rs.getInt("count") %></h1>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div style="background:lightblue;" class="custom-card p-3">
                                <p class="text-secondary m-0">Total Books Units</p>
                                 <%
                                  ps = conn.prepareStatement("select count(*) as count from book_units");
                                  rs = ps.executeQuery();
                                  rs.next();
                                %>
                                <h1><%= rs.getInt("count") %></h1>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div style="background:#e5e5a8;" class="custom-card p-3">
                                <p class="text-secondary m-0">Assigned Books</p>
                                 <%
                                  ps = conn.prepareStatement("select count(*) as count from assigned_books");
                                  rs = ps.executeQuery();
                                  rs.next();
                                %>
                                <h1><%= rs.getInt("count") %></h1>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-12">
                            <div class="custom-card p-4 mt-3">
                                 <canvas id="barChart" width="400" height="120"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="row mt-3">
                        <div class="col-md-6">
                            <div class="custom-card px-3 pt-3 min-height-31">
                                <p class="text-secondary border-bottom pb-2">Recent Assigned Books</p>
                                <div class="row text-center font-weight-bold">
                                    <div class="col-md-1">
                                        <p>S.No</p>
                                    </div>
                                    <div class="col-md-3">
                                        <p>Roll No</p>
                                    </div>
                                    <div class="col-md-3">
                                        <p>Student Name</p>
                                    </div>
                                    <div class="col-md-5">
                                        <p>Book Name</p>
                                    </div>
                                </div>
                                <%
                                 int i = 0;  
                                  ps = conn.prepareStatement("select t2.full_name as student_name,t2.roll_no,t4.name as book_name from assigned_books t1 inner join students t2 on t2.id=t1.student_id inner join book_units t3 on t3.id=t1.book_unit_id inner join books t4 on t4.id=t3.book_id order by t1.assigned_date desc fetch next 10 rows only");
                                  rs = ps.executeQuery();
                                  while(rs.next()){
                                 %>
                                <div class="row text-center ">
                                    <div class="col-md-1">
                                        <p><%= i+=1 %></p>
                                    </div>
                                    <div class="col-md-3">
                                        <a class="text-decoration-none" href="./search-student.jsp?rollNo=<%= rs.getInt("roll_no") %>">
                                            <p><%= rs.getInt("roll_no")%></p>
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <p><%= rs.getString("student_name")%></p>
                                    </div>
                                    <div class="col-md-5">
                                        <p class="text-truncate" title="<%= rs.getString("book_name")%>"><%= rs.getString("book_name")%></p>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="custom-card px-3 pt-3 min-height-31">
                                <p class="text-secondary border-bottom pb-2">Recent Submitted Books</p>
                                <div class="row text-center font-weight-bold">
                                    <div class="col-md-1">
                                        <p>S.No</p>
                                    </div>
                                    <div class="col-md-3">
                                        <p>Roll No</p>
                                    </div>
                                    <div class="col-md-3">
                                        <p>Student Name</p>
                                    </div>
                                    <div class="col-md-5">
                                        <p>Book Name</p>
                                    </div>
                                </div>
                                <%
                                 int j = 0;  
                                  ps = conn.prepareStatement("select t2.full_name as student_name,t2.roll_no,t4.name as book_name from submitted_books t1 inner join students t2 on t2.id=t1.student_id left join book_units t3 on t3.id=t1.book_unit_id left join books t4 on t4.id=t3.book_id order by t1.submitted_date desc fetch next 10 rows only");
                                  rs = ps.executeQuery();
                                  while(rs.next()){
                                 %>
                                <div class="row text-center ">
                                    <div class="col-md-1">
                                        <p><%= j+=1 %></p>
                                    </div>
                                    <div class="col-md-3">
                                         <a class="text-decoration-none" href="./search-student.jsp?rollNo=<%= rs.getInt("roll_no") %>">
                                            <p><%= rs.getInt("roll_no")%></p>
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <p><%= rs.getString("student_name")%></p>
                                    </div>
                                    <div class="col-md-5">
                                        <p class="text-truncate" title="<%= rs.getString("book_name") != null ? rs.getString("book_name") : "Book not exist" %>"><%= rs.getString("book_name") != null ? rs.getString("book_name") : "Book not exist" %></p>
                                    </div>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                     <div class="row mt-3 mb-3">
                        <div class="col-md-6">
                            <div class="custom-card px-3 pt-3 pb-4 min-height-31">
                                <div style="display:flex;justify-content:space-between" class="text-secondary border-bottom mb-2 pb-2">
                                    <p class="m-0">Send Reminder to Students</p>
                                    <div style="display:flex;" class="">
                                        <input id="upperDate" onchange="getStudentForReminder()" style="padding: 0.2rem 0.2rem; border-radius: 4px;" class="select-border-none bg-light" type="date">
                                        <span class="mx-2">To</span>
                                        <input id="lowerDate" onchange="getStudentForReminder()" style="padding: 0.2rem 0.2rem; border-radius: 4px;" class="select-border-none bg-light" type="date">
                                    </div>
                                </div>
                                <div id="studentListForReminder">
                                    <div style="display:flex;justify-content:center;align-items:center;height: 50vh;">
                                                <p>Select both date to retrive student data for reminder</p>
                                        </div>
                                </div>
                                 
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="custom-card px-3 pt-3 min-height-31">
                                <canvas id="pieChart" width="50" height="50"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%@ include file="./includes/footer.jsp" %>
<script>
function formatDate(date){
    let dd = date.getDate();
    let month = new Array();
    month[0] = "January";
    month[1] = "February";
    month[2] = "March";
    month[3] = "April";
    month[4] = "May";
    month[5] = "June";
    month[6] = "July";
    month[7] = "August";
    month[8] = "September";
    month[9] = "October";
    month[10] = "November";
    month[11] = "December";
    let mm = month[date.getMonth()];
    let yyyy = date.getFullYear();
    if(dd<10) {dd='0'+dd}
    if(mm<10) {mm='0'+mm}
    date = dd+' '+mm+' '+yyyy;
    return date
 }

function Last7Days () {
    let result = [];
    for (let i=0; i<7; i++) {
        let d = new Date();
        d.setDate(d.getDate() - i);
        result.push( formatDate(d) )
    }

    return(result);
}
let date = new Array();
date = Last7Days();
date[0]="Today";
date[1]="Yesterday";
const labels = date;
const data = {
  labels: labels,
  datasets: [
    {
      label: 'Assigned Books',
      data: <%= weekly_assigned_books %>,
      backgroundColor: '#ed6b6b',
    },
    {
      label: 'Submitted Books',
      data: <%= weekly_submitted_books %>,
      backgroundColor: '#82c9f5',
    }
  ]
};
const config = {
  type: 'bar',
  data: data,
  options: {
    responsive: true,
    plugins: {
      legend: {
        position: 'top',
      },
      title: {
        display: true,
        text: 'Weekly Report of Books'
      }
    },
    //  scales: {
    //     y: {
    //         ticks: {
    //             stepSize: 0.5
    //         }
    //     }
    // }
  },
}
let ctx = document.getElementById('barChart').getContext('2d');
let myChart = new Chart(ctx, config);
// pie chart
<%
ps = conn.prepareStatement("select count(*) as count from assigned_books");
rs = ps.executeQuery();
rs.next();
PreparedStatement ps1=null; 
ResultSet rs1 = null;
ps1 = conn.prepareStatement("select count(*) as count from book_units");
rs1 = ps1.executeQuery();
rs1.next();
int assigned_books = rs.getInt("count");
int book_units = rs1.getInt("count");
float assigned_books_pct = ((float)assigned_books / (float)book_units)*100;
float available_book_pct = 100 - assigned_books_pct;
%>
const data1 = {
  labels: ['Assigned Books', 'Available Books'],
  datasets: [
    {
      data: [<%= Math.round(assigned_books_pct) %>,<%= Math.round(available_book_pct) %>],
      backgroundColor: ["#f06e6e","#74e8f2"]
    }
  ]
};
const config1 = {
  type: 'pie',
  data: data1,
  options: {
      aspectRatio:1.2,
    layout: {
      padding:20
    },
    responsive: true,
    plugins: {
      legend: {
        position: 'top',
      },
      title: {
        display: true,
        text: 'Books Status (In percentage %)'
      },
    }
  },
};
let ctx1 = document.getElementById('pieChart').getContext('2d');
let myChart1 = new Chart(ctx1, config1);

function getStudentForReminder(){
  const upperDate = $('#upperDate').val();
  const lowerDate = $('#lowerDate').val();
  console.log(upperDate+" "+lowerDate);
  if(upperDate != "" && lowerDate != ""){
      $.ajax({
          type:'post',
          data:{
              upperDate:upperDate,
              lowerDate:lowerDate
          },
          url:'./ajax/get-student-for-reminder.jsp',
          success:function(result){
              console.log(result);
              renderGetStudentForReminder(result,'#studentListForReminder');
          },
          error:function(err){
              console.log("error " +JSON.stringify(err));
          }
      })
  }
  else{
      $('#studentListForReminder').html(` <div style="display:flex;justify-content:center;align-items:center;height: 50vh;">
                                                <p>Select both date to retrive student data for reminder</p>
                                        </div>`)
  }
}   
function renderGetStudentForReminder(data1,target){
    let container ="";
    if(data1.data.length > 0){
        container = `  <div class="row text-center font-weight-bold">
                                    <div class="col-md-1">
                                        <p>S.No</p>
                                    </div>
                                    <div class="col-md-3">
                                        <p>Roll No</p>
                                    </div>
                                    <div class="col-md-3">
                                        <p>Student Name</p>
                                    </div>
                                    <div class="col-md-5">
                                        <p>Book Name</p>
                                    </div>
                                </div>`;
        data1.data.map((data,index)=>{
         container += `  <div class="row text-center" >
                                <div class="col-md-1">
                                        <p>\${index+1}</p>
                                    </div>
                                    <div class="col-md-3">
                                        <a class="text-decoration-none" href="./search-student.jsp?rollNo=\${data.roll_no}">
                                            <p>\${data.roll_no}</p>
                                        </a>
                                    </div>
                                    <div class="col-md-3">
                                        <p>\${data.student_name}</p>
                                    </div>
                                    <div class="col-md-5">
                                        <p class="text-truncate" title="\${data.book_name}">\${data.book_name}</p>
                                    </div>
                                </div>`
        })
        let subConatiner = "";
        if(data1.data.length < 9){
            subConatiner = ``;
        }
        else{
            subConatiner = `<a style="text-decoration:none" href="./send-reminder.jsp?upperDate=\${$('#upperDate').val()}&lowerDate=\${$('#lowerDate').val()}">Show all students</a>`;
        }
        
        container += `<div class="send-reminder-footer">
                                  \${subConatiner}
                                    <button onclick="sendReminnderAllStudents()" style="float:right;zoom: 0.9;" class="btn btn-sm btn-danger">Send Reminder to all</button>
                                </div>`
        $(target).html(container);
    }
    else{
        $(studentListForReminder).html(` <div style="display:flex;justify-content:center;align-items:center;height: 50vh;">
                                                <p>There are no data between select dates</p>
                                        </div>`);
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
</script>
</body>

</html>

