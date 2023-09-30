<%@ include file="./includes/config.jsp"%>
<%@page contentType="text/html; charset=UTF-8"%>
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
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Student</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
    <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    <script src="assets/js/lib.js"></script>
    <script src="//cdn.jsdelivr.net/npm/sweetalert2@10"></script>
</head>

<body onload="renderStudentdata()">
   <%@ include file="./includes/header.jsp" %>
    <div class="container-fluid" id="body">
        <div class="row">
            <div style="background: #3c4045;" class="col-md-2 px-0 border-right sidebar" id="sidebar">
           <%@ include file="./includes/sidebar.jsp" %>
           </div>
            <div class="col-md-10">
                <div class="body-container py-2">
                    <div class="row border-bottom pb-2 align-items-center">
                        <div class="col-md-12">
                            <div class="">
                                <h3>Search Student</h3>
                            </div>
                        </div>
                    </div>
                    <div class="row my-3">
                        <div class="col-md-2"></div>
                        <div class="col-md-8">
                            <div class="form-group">
                                <div class="input-group mb-3 ui-widget">
                                    <input value="<%= request.getParameter("rollNo") != null ? request.getParameter("rollNo") : "" %>" type="search" onkeyup="ac_student_list()" class="form-control" placeholder="Search student by roll no" id="ac_student">
                                    <div style="cursor:pointer" class="input-group-append" id="searchStudents">
                                        <span class="input-group-text "><i class="fa fa-search"
                                                aria-hidden="true"></i></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                   <div id="studentDetail"></div>
                </div>
            </div>
        </div>
    </div>
    <!-- assigned books -->
    <div class="modal" id="assignedBooks" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" style="display:flex;justify-content:center;max-width:none;">
            <div class="modal-content" style="width: 85vw;">

                <!-- Modal Header -->
                <div class="modal-header">
                <h4>Assigned books to<span class="badge badge-secondary studentNameRollno ml-2"></span></h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body" id="renderAssignedBooks">
                   
                </div>

            </div>
        </div>
    </div>
     <!-- submit books -->
    <div class="modal" id="submitBooks" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" style="display:flex;justify-content:center;max-width:none;">
            <div class="modal-content" style="width: 60vw;">

                <!-- Modal Header -->
                <div class="modal-header">
                <h4>Submitting books of<span class="badge badge-secondary studentNameRollno ml-2"></span></h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                   <div class="row my-3">
                    <div class="col-md-2">
                    </div>
                    <div class="col-md-8">
                       <div class="input-group">
                                    <input type="text" class="form-control getBarcode" placeholder="Enter barcode" autofocus>
                                    <div class="input-group-append">
                                        <button class="btn btn-danger" onclick='submitBooks()'>Submit</button>
                                    </div>
                                </div>
                                <span style="font-size:0.8rem" class="barcode_message"><span>
                         </div>
                    </div>
                   </div>
                </div>
        </div>
    </div>
    <!--assigned other books-->
      <div class="modal" id="assignedOtherBooks" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" style="display:flex;justify-content:center;max-width:none;">
            <div class="modal-content" style="width: 60vw;">

                <!-- Modal Header -->
                <div class="modal-header">
                <h4>Assigning other books to<span class="badge badge-secondary studentNameRollno ml-2"></span></h4>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                   <div class="row my-3">
                    <div class="col-md-2">
                    </div>
                    <div class="col-md-8">
                       <div class="input-group">
                                    <input type="text" class="form-control getBarcode" placeholder="Enter barcode" autofocus>
                                    <div class="input-group-append">
                                        <button class="btn btn-danger" onclick='assignedOtherBooks()'>Assign</button>
                                    </div>
                                </div>
                                <span style="font-size:0.8rem" class="barcode_message"><span>
                         </div>
                    </div>
                   </div>
                </div>
        </div>
    </div>
     <!-- edit student details -->
    <div class="modal" id="editStudentDetails" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">Update student details</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                     <div class="row font-weight-bold">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="full_name">Full Name:</label>
                                        <input title="Please enter student name" type="text" class="form-control"
                                            id="full_name" name="full_name" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="father_name">Father Name:</label>
                                        <input type="text" class="form-control"
                                            id="father_name" name="father_name" required>
                                    </div>
                                    <div class="form-group">
                                        <label for="mobile_no">Mobile Number:</label>
                                        <input title="Mobile number should be 10 digits" pattern="[0-9]{10}" type="text" class="form-control"
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
                                        <input pattern="[0-9]{2,38}" title="Atleast 2 digits in roll number" type="text" class="form-control" id="roll_no"
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
                                        <input pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$" title="Enter a valid email" type="email" class="form-control" id="email"
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
                   
                </div>
                            <div class="modal-footer">
                            <button class="btn btn-primary" onclick=updateStudent($('#studentId').val())>Update</button>
                            </div>
            </div>
        </div>
    </div>
   <%@ include file="./includes/footer.jsp" %>
    <script>

    function ac_student_list() {

		$("#ac_student").autocomplete({

			source: function(request, response) {

				if (request.term !== '') {
                    // console.log(request.term);
					$.ajax({
						type: 'post',
						data: {
							key: request.term
						},
						url: './ajax/student-list.jsp',
						success: function(result) {

                            // console.log(data);
							response($.map(result.data, function(item) {
								return {
									label: item.search_key,
									value: item.q,
									obj: item
								};
							}));
						}
					})
				} else {
					$('.ui-menu').hide();
					$('.result-list').show();
				}
			},
			minLength: 2,
			open: function() {

			},
			close: function() {

			},
			focus: function(event,ui) {
            },
			select: function(event, ui) {
				// console.log(ui);

			}
		});
	}
    function searchStudent(){
       const studentRollno = $('#ac_student').val();
      $.ajax({
						type: 'post',
						data: {
							studentRollno: studentRollno
						},
						url: './ajax/student-result.jsp',
						success: function(result) {
                            if(result.isData){
                              renderStudentDetails(result.data, '#studentDetail');
                              renderStudentBadge(result.data);
                            }
                            else{
                                if(!isEmpty($('#ac_student').val())){
 $("#studentDetail").html(`<div class="container h-100 mt-5 pt-5">
                                                         <div class="row align-items-center h-100">
                                                     <div class="col-6 mx-auto text-center">
                                                        <div class="jumbotron">
                                                     <h1> Opps! </h1>
                                                     <p class="text-muted">There is no student of this roll no</p>
                                                     </div>
                                                 </div>
                                                 </div>
                                                    </div>`);
                                }
                               
                            }
						}
					})
    }
    $('#searchStudents').click(function(){
        searchStudent()
        const studentRollno = $('#ac_student').val();
        console.log(studentRollno);
        if(isEmpty(studentRollno)){
 window.location='./search-student.jsp';
        }
        else{
 window.location='./search-student.jsp?rollNo='+studentRollno;
        }
       
    });

   

    function renderStudentDetails(data, target){
        // console.log(data);
    let sd = `<div class="px-5 py-2 custom-height">
                        <div class="row">
                            <div class="col-md-2">

                            </div>
                            <div class="col-md-8">
                                <div style="display:flex;align-items: center;">
                                    <h3>Student details</h3>
                                    <a href="javascript:{}" onclick=editStudentDetailsModal("\${data.student_id}") class="btn btn-warning btn-sm text-dark ml-2 mb-1">Edit</a>
                                </div>
                                <div style="background: #f7f7f7ad;" class="card">
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="mb-4">
                                                    <img width="124" height="124"
                                                        src="https://ui-avatars.com/api/?name=\${data.full_name}&color=7F9CF5&background=EBF4FF"
                                                        alt="\${data.full_name}">
                                                </div>
                                                <div>
                                                    <h5>Email:</h5>
                                                    <p id="s_email">\${data.email}</p>
                                                </div>
                                                <div>
                                                    <h5>Registration Date:</h5>
                                                    <p id="s_reg">\${data.registration}</p>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div>
                                                    <h5>Name:</h5>
                                                    <p id="s_name">\${data.full_name}</p>
                                                </div>
                                                <div>
                                                    <h5>Roll No:</h5>
                                                    <p id="s_rollno">\${data.roll_no}</p>
                                                </div>
                                                <div>
                                                    <h5>DOB:</h5>
                                                    <p id="s_dob">\${data.formatted_dob}</p>
                                                </div>
                                                 <div>
                                                    <h5>Gender:</h5>
                                                    <p id="s_gender">\${data.gender.charAt(0).toUpperCase() + data.gender.slice(1)}</p>
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div>
                                                    <h5>Father's Name:</h5>
                                                    <p id="s_fathername">\${data.father_name}</p>
                                                </div>
                                                <div>
                                                    <h5>Department:</h5>
                                                    <p id="s_dept">\${data.dept}</p>
                                                </div>
                                                <div>
                                                    <h5>Mobile Number:</h5>
                                                    <p id="s_mobile">\${data.mobile_no}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-5">
                            <div class="col-md-2">

                            </div>
                            <div class="col-md-8">
                                <div style="background: #f7f7f7ad;" class="card">
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <h6>Assigned Books</h6>
                                            </div>
                                            <div class="col-md-4">

                                            </div>
                                            <div class="col-md-4 text-right">
                                                <a href="javascript:{}" onclick="assignedBookModel(\${data.student_id})">View
                                                    Details</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-3">
                            <div class="col-md-2">

                            </div>
                            <div class="col-md-8 text-right ">
                                <a href="javascript:{}" onclick=assignedOtherBookModal("\${data.student_id}") class="btn btn-secondary">Assign Other Book</a>
                                <a href="./assign-book.jsp?id=\${data.student_id}" class="btn btn-primary">Assign Book</a>
                                <a href="javascript:{}" onclick=submitBookModal("\${data.student_id}") class="btn btn-danger">Submit Book</a>
                                <input type="hidden" id="studentId" value="\${data.student_id}">
                            </div>

                        </div>
                    </div>`;
                    $(target).html(sd);
    }
    function assignedBookModel(studentId){

        $.ajax({
		type: 'post',
        data:{
            studentId:studentId
        },
		url: './ajax/show-assigned-books.jsp',
		success: function(result) {
         console.log(result.data);
         renderAssignedBooks(result,'#renderAssignedBooks');     
		},
        error: function(err){
        console.log(err);
        }
	});
    $('#assignedBooks').modal().show();
       
       console.log(studentId)

    }
    function renderAssignedBooks(data1,target){
       if(data1.data.length > 0 && data1.isData){
           let container = ` <table class="table table-hover border-right border-left border-bottom text-center">
                        <thead>
                            <tr>
                                <th>S.No</th>
                                <th>Book Name</th>
                                <th>Subject</th>
                                <th>Semester</th>
                                 <th>Author</th>
                                <th>Edition</th>
                                 <th>Barcode</th>
                                 <th>ISBN</th>
                                  <th>Price(Rs)</th>
                                <th>Assigned Date</th>
                            </tr>
                        </thead>
                        <tbody>`
           data1.data.map((data,index)=>{
              container += `  <tr>
                                <td>\${index+1}</td>
                                <td>\${data.book_name}</td>
                                <td>\${data.subject_name == null ? 'other':data.subject_name}</td>
                                <td>\${data.sem_name == null ? 'other' : data.sem_name.replace('semester','')}</td>
                                <td>\${data.author}</td>
                                <td>\${data.edition}</td>
                                <td>\${data.barcode}</td>
                                <td>\${data.isbn}</td>
                                <td>&#8377;\${data.price.toFixed(2)}</td>
                                <td>\${data.assigned_date}</td>
                            </tr>`
           });

           container += `</tbody>
                       </table>`; 
           $(target).html(container);                    
       }
       else{
         $('#renderAssignedBooks').html(`<div class="text-center"><p>No book assigned to student</p></div>`);
       }
    }
    function renderStudentBadge(data){
        $('.studentNameRollno').html(`\${data.full_name} | \${data.roll_no}`);
    }
    function submitBookModal(studentId){
       $('#submitBooks').find('.getBarcode').val(''); 
       $('#submitBooks').find('.barcode_message').hide();
       $('#submitBooks').modal().show();
    }
    function submitBooks(){
        const studentId = $('#studentId').val();
        const barcode = $('#submitBooks').find('.getBarcode').val();
        console.log(studentId,barcode);
        $.ajax({
		type: 'post',
        data:{
            barcode:barcode,
            studentId:studentId
        },
		url: './ajax/submit-book-student.jsp',
		success: function(result) {
         console.log(result.data);
         if(result.data.status){
             setTimeout(()=>{
                $('#barcode_message').fadeOut();
             },5000);
            $('#submitBooks').find('.barcode_message').html(result.data.message).css({color: 'rgb(15, 178, 15)'}).show();
         }
         else{
            $('#submitBooks').find('.barcode_message').html(result.data.message).css({color: 'rgb(255, 0, 0)'}).show();
         }

		},
        error: function(err){
        console.log(err);
        }
	});
    }
    function renderStudentdata(){
       const student_rollno = $('#ac_student').val();
       searchStudent();
       console.log(student_rollno)
    }
    function assignedOtherBookModal(studentId){
         $('#assignedOtherBooks').modal().show();
         $('#assignedOtherBooks').find('.getBarcode').val('');
         $('#assignedOtherBooks').find('.barcode_message').hide();
    }
    function assignedOtherBooks(){
        const studentId = $('#studentId').val();
        const barcode = $('#assignedOtherBooks').find('.getBarcode').val();
        console.log(studentId,barcode);
        $.ajax({
		type: 'post',
        data:{
            barcode:barcode,
            studentId:studentId
        },
		url: './ajax/assigned-other-books-student.jsp',
		success: function(result) {
         console.log(result.data);
         if(result.data.status){
             setTimeout(()=>{
                $('#barcode_message').fadeOut();
             },5000);
            $('#assignedOtherBooks').find('.barcode_message').html(result.data.message).css({color: 'rgb(15, 178, 15)'}).show();
         }
         else{
            $('#assignedOtherBooks').find('.barcode_message').html(result.data.message).css({color: 'rgb(255, 0, 0)'}).show();
         }

		},
        error: function(err){
        console.log(JSON.stringify(err));
        }
	});
    }
    function editStudentDetailsModal(studentId){
        console.log(studentId); 
        $('#editStudentDetails').modal().show();
         $.ajax({
		type: 'post',
        data:{
            studentId:studentId
        },
		url: './ajax/student-result.jsp',
		success: function(result) {
            console.log(result.data)
            $('#full_name').val(result.data.full_name);
            $('#email').val(result.data.email);
            $('#father_name').val(result.data.father_name);
            $('#roll_no').val(result.data.roll_no);
            $('#mobile_no').val(result.data.mobile_no);
            $('#gender').val(result.data.gender);
            $('#dob').val(result.data.dob);
            $('#dept').val(result.data.dept_id);
		},
        error: function(err){
        console.log(JSON.stringify(err));
        }
	});
    }
    function updateStudent(sId){
        const sName = $('#full_name').val();
        const sEmail = $('#email').val();
        const sFathername = $('#father_name').val();
        const sRollno = $('#roll_no').val();
        const sMobileno = $('#mobile_no').val();
        const sGender = $('#gender').val();
        const sDob = $('#dob').val();
        const sDept = $('#dept').val();
        console.log(sId,sName,sEmail,sFathername,sRollno,sMobileno,sGender,sDob,sDept)
    Swal.fire({
  title: 'Are you sure?',
  text: "You won't be able to revert this!",
  icon: 'warning',
  showCancelButton: true,
  confirmButtonColor: '#3085d6',
  cancelButtonColor: '#d33',
  confirmButtonText: 'Yes, update it!'
  }).then((result) => {
  if (result.isConfirmed){
    $.ajax({
		type: 'post',
        data:{
            sId:sId,
            sName:sName,
            sEmail:sEmail,
            sFathername:sFathername,
            sRollno:sRollno,
            sMobileno:sMobileno,
            sGender:sGender,
            sDob:sDob,
            sDept:sDept
        },
		url: './ajax/update-student.jsp',
		success: function(result) {
            console.log(result.data);
            if(result.data.status){
                Swal.fire(
                'Updated!',
                 result.data.message,
                'success'
                )
                 setInterval(() => {
                    window.location.reload();
                }, 1300);
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
 