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
    if(request.getParameter("department") != null){
        String dept_name = capitalizeString(request.getParameter("department"));
        String date_created = currentDateTime();
        ps = conn.prepareStatement("select count(*) as count from departments where name=?");
        ps.setString(1,dept_name);
        rs = ps.executeQuery();
        if(rs.next()){
            if(rs.getInt("count") == 0){
            ps = conn.prepareStatement("insert into departments (name,date_created) values (?,?)");
            ps.setString(1,dept_name); 
            ps.setString(2,date_created); 
            int check = ps.executeUpdate(); 
                if(check != 0){
                    success_message = "Department added successfully";
                }
                else{
                error_message = "Somrthing went wrong";
                }
            } 
            else{
            error_message = "Department already exist";
                        
           }
        }                      
    }                       
}
catch(Exception e){
    System.out.println(e);
    error_message = "Error ocurred! Please try again";  
}
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Department</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="./assets/js/lib.js"></script>
    <script src="./assets/js/multibox.js"></script>
    <script src="//cdn.jsdelivr.net/npm/sweetalert2@10"></script>
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
                    <div class="row border-bottom pb-2 align-items-center">
                        <div class="col-md-6">
                            <div class="">
                                <h3>Department</h3>
                            </div>
                        </div>
                        <div class="col-md-6 text-right">
                            <button class="btn btn-info btn-sm" data-toggle="modal" data-target="#addDepartment">Add
                                Department</button>
                        </div>
                    </div>
                    <%if(error_message != null){%>
                         <div class="alert alert-danger alert-dismissible fade show mt-2"><button type="button" class="close" data-dismiss="alert">&times;</button><%= error_message %></div>
                    <% } %>
                    <%if(success_message != null){%>
                        <div class="alert alert-success alert-dismissible fade show mt-2"><button type="button" class="close" data-dismiss="alert">&times;</button><%= success_message %></div>
                    <% } %>
                    <div class="row custom-height">
                        <div class="col-md-12 mt-4">
                            <table class="table table-hover border-right border-left border-bottom text-center">
                                <thead>
                                    <tr>
                                        <th>S.No</th>
                                        <th class="text-left">Department</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% ps = conn.prepareStatement("select * from departments order by name");
                                   rs = ps.executeQuery();
                                      int i=0;                                   
                                     while(rs.next()){ %>
                                    <tr>
                                        <td><%= i+=1  %></td>
                                        <td class="text-left"><%= rs.getString("name") %></td>
                                        <td>
                                            <Button class="btn btn-success btn-sm" onclick='viewsubjectModal("<%= rs.getString("id") %>","<%= rs.getString("name") %>")'>View Subjects</Button>
                                            <Button class="btn btn-info btn-sm" onclick='addsubjectModal("<%= rs.getString("id") %>","<%= rs.getString("name") %>")'>Link Subjects</Button>
                                             <Button class="btn btn-warning btn-sm" onclick='updateDepartmentModal("<%= rs.getString("id") %>")'>Edit</Button>
                                            <% if(role.equals("admin")){ %>
                                            <Button class="btn btn-danger btn-sm" onclick='deleteDepartment("<%= rs.getString("id") %>")'>Delete</Button>
                                            <%}%>
                                            <% if(role.equals("user")){ %>
                                            <Button class="btn btn-secondary btn-sm">Delete</Button>
                                            <%}%>
                                        </td>
                                    </tr>
                                    <%
                                     }
                                    %>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- add department -->
    <div class="modal" id="addDepartment" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">Add Department</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                    <div class="mt-2 mx-4">
                        <form action="" method="post">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <input type="text" class="form-control" placeholder="Enter New Department"
                                            id="department" name="department" required>
                                    </div>
                                </div>
                            </div>
                            
                    </div>
                   
                </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Submit</button>
                    </div>
                 </form>
            </div>
        </div>
    </div>
     <!-- edit department -->
    <div class="modal" id="editDepartment" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">Update department details</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                    <div class="mt-2 mx-4">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="form-group">
                                        <label class="font-weight-bold">Department Name:</label>
                                        <input type="text" class="form-control" placeholder="Enter New Department"
                                            id="dept_name" name="department">
                                    </div>
                                </div>
                            </div>
                            
                    </div>
                   <input type="hidden" class="deptId" value="">
                </div>
                    <div class="modal-footer">
                        <button class="btn btn-primary" onclick="updateDepartment()">Update</button>
                    </div>
            </div>
        </div>
    </div>
    <!-- link subject to department -->
    <div class="modal" id="addSubjects" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                  <h4>Add Subject in <span class="badge badge-secondary deptName"></span></h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                        <div class="form-group bg-light p-2 mx-1 row">
                            <h6 class="float-left mr-2 mt-2 font-weight-bold">Semester:</h6>
                                    <Select class="semId form-control col-md-4" id="semseter" name="semseter" onchange="subjectValidation(this)" required>
                                        <option value="">Select Semester</option>
                                    <%
                                            ps = conn.prepareStatement("Select id,name from semesters order by name");
                                            rs = ps.executeQuery();
                                            while(rs.next()){
                                            %>
                                            <option value="<%= rs.getInt("id") %>"><%= rs.getString("name")%></option>
                                            <%
                                             }
                                            %>
                                    </Select>
                            <h6 class="text-danger ml-3 mt-2 selectSubject" >*Please select semester before subject link to dept</h6>
                        </div>
                        <div id="data-box0" data-index="0">
                                    <div class="box main"></div>
                        </div>
                        <input type="hidden" class="deptId" value="">
                </div>
            </div>
        </div>
    </div>
    <%-- view subjects --%>
    <div class="modal" id="viewSubjects" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                  <h4>Subject in <span class="badge badge-secondary deptName"></span></h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                        <div class="form-group bg-light p-2 mx-1 row">
                            <h6 class="float-left mr-2 mt-2 font-weight-bold">Semester:</h6>
                                    <Select class="semId form-control col-md-4" id="semseter" name="semseter" onchange="getSubjectList(this)" required>
                                        <option value="">Select Semester</option>
                                    <%
                                            ps = conn.prepareStatement("Select id,name from semesters order by name");
                                            rs = ps.executeQuery();
                                            while(rs.next()){
                                            %>
                                            <option value="<%= rs.getInt("id") %>"><%= rs.getString("name")%></option>
                                            <%
                                             }
                                            %>
                                    </Select>
                            <h6 class="text-danger ml-3 mt-2 selectSubject">*Please select semester</h6>
                        </div>
                        <input type="hidden" class="deptId" value="">
                        <div id="subjectList"></div>
                </div>
            </div>
        </div>
    </div>
    <%@ include file="./includes/footer.jsp" %>
    <script>
    function boxDelete(el, id) {
            // alert('Are you sure!');
            // $(el).remove();
            $(el).remove();
           console.log('boxDelete', el, id);
        }

        function rowDelete(el, id) {
            console.log('callback function rowDelete() called');
            $(el).remove();
        }

        function scrollChatDown() {
            // var objDiv = document.getElementById("data-box0");
            // objDiv.scrollTop = objDiv.scrollHeight;
            window.scrollTo(0, document.body.scrollHeight);
        }

        function addSubjects(el,deptId, semId){
            console.log("deptid"+deptId,"semId"+semId);
            let parentEl = $(el).parents('.box');
            const data =  {'subjectId':$(parentEl).find('.subject').val(),
                            'deptId':deptId,
                            'semId':semId
                            }             
            let flag = true;
            $(parentEl).find('.err').empty();
            if(isEmpty(data.subjectId)){
                flag = false;
                $(parentEl).find('.err_subject').html(`Please select subject`).css({color: '#f00'});
            }
            if(flag == true){ 
                // console.log(searchQuery);
                $.ajax({
						type: 'post',
						data: data,
						url: './ajax/link-subject-to-depertment.jsp',
						success: function(result) {
                            console.log(result.data);
                            if(result.data.status){
                                    setTimeout(()=>{
                                             $(parentEl).find('.err_subject').fadeOut();
                                        },5000 )
                                  
                                    $(parentEl).find('.err_subject').html(result.data.message).css({color: 'rgb(15 178 15)'});
                                    $(parentEl).find('.subject').attr('disabled',true);
                                    obj0.getBox();
                                    
                            }
                            else{
                                 $(parentEl).find('.err_subject').html(result.data.message).css({color: '#f00'});
                            }
						},
                         error: function(err){
                              console.log(err);
                          $(parentEl).find('.err_subject').html("something went wrong").css({color: '#f00'});
                        }
					})
                console.log(data);
            }   
        }

        var obj0 = new Multibox('#data-box0', function(data, source) {
              
        source({
				view: `
                        <div style="background: #eee" class="row text-center mb-2 box py-2 mx-1">
                            <div class="col-md-1">
                                <span style="position: absolute;top: 6px;">\${parseInt(data.box)+1}</span>
                            </div>
                            <div class="col-md-10">
                                <div class="">
                                    <Select class="form-control subject" id="department" name="department">
                                        <option value="">Subject*</option>
                                    <%
                                         ps = conn.prepareStatement("Select id,name from subjects order by name");
                                            rs = ps.executeQuery();
                                            while(rs.next()){
                                            %>
                                            <option value="<%= rs.getInt("id") %>"><%= rs.getString("name")%></option>
                                            <%
                                             }
                                            %>
                                    </Select>
                                    <div style="text-align: left;font-size: 0.8rem;margin-left: 11px;"><span class="err_subject err"></span></div>
                                </div>
                            </div>
                            <div class="col-md-1">
                                 <button type="button" class="btn btn-info add-box" onclick="addSubjects(this,$('#addSubjects').find('.deptId').val(),$('#addSubjects').find('.semId').val())"><i class="fa fa-plus" aria-hidden="true"></i></button>
                                <button type="button" style="display:none"  class="btn btn-success remove-box"><i class="fa fa-check" aria-hidden="true"></i></button>
                            </div>
                        </div>
                `
			});
        });

        $(document).ready(function () {
            
			obj0.getBox();
         
		});
function addsubjectModal(deptId, deptName){
    obj0.reset();
    console.log(deptId,deptName);
    $('#addSubjects').find('.deptId').val(deptId);
    $('#addSubjects').find('.deptName').text(deptName);
    $('#addSubjects').modal('show');
}

function subjectValidation(el){
    if(el.value != ""){
      $('#addSubjects').find('.selectSubject').hide();
    }
    else{
       $('#addSubjects').find('.selectSubject').show();
    }
}
function viewsubjectModal(deptId, deptName){
    console.log(deptId,deptName);
    $('#viewSubjects').find('.deptName').text(deptName);
    $('#viewSubjects').find('.deptId').val(deptId);
    $('#viewSubjects').modal('show');
    $('#viewSubjects').find('.semId').val('');
    $('#viewSubjects').find('.selectSubject').show();
    renderSubjectList(null,'#subjectList') 
}

function getSubjectList(el){
  if(el.value != ""){
      $('#viewSubjects').find('.selectSubject').hide();
    }
    else{
      $('#viewSubjects').find('.selectSubject').show();
      return
    }
    const deptId = $('#viewSubjects').find('.deptId').val();
    const semId = el.value;
    $.ajax({
		type: 'post',
        data:{
            deptId:deptId,
            semId:semId
        },
		url: './ajax/view-subjects.jsp',
		success: function(result) {
         console.log(result);  
           renderSubjectList(result,'#subjectList');  
		},
        error: function(err){
        console.log("error " +err);
        }
	})
}
function renderSubjectList(data1,target){
    if(data1 != null){
 if(data1.data.length > 0 && data1.isData){
       let sl = ` <table class="table table-hover border-right border-left border-bottom">
                        <thead>
                            <tr>
                                <th class="text-center">S.No</th>
                                <th>Subject Name</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>`
        data1.data.map((data,index)=>{
           sl += `<tr class="subjects">
                                <td class="text-center">\${index+1}</td>
                                <td>\${data.subject_name}</td>
                                <td class="text-center">
                                <% if(role.equals("admin")){ %>
                                    <Button onclick='unlinkSubjectFromDept(this,"\${data.subject_id}")' class="btn btn-danger btn-sm mr-2">Unlink</Button>
                                <%}%>
                                <% if(role.equals("user")){ %>
                                    <Button class="btn btn-secondary btn-sm mr-2">Unlink</Button>
                                <%}%>   
                            </tr>`
  
        });       
        sl += ` </tbody>
                    </table>`  
    $(target).html(sl);   
    }
    
    else{
        $("#subjectList").html(`<div class="container h-100 text-center">
                         <h1> Opps! </h1>
                         <p class="text-muted">There is no subject in this semester</p>
         </div>`);
    }
    }
    else{
        $("#subjectList").html('');
    }
}
function deleteDepartment(deptId){
  Swal.fire({
  title: 'Are you sure?',
  text: "You won't be able to revert this!",
  icon: 'warning',
  showCancelButton: true,
  confirmButtonColor: '#3085d6',
  cancelButtonColor: '#d33',
  confirmButtonText: 'Yes, delete it!'
  }).then((result) => {
  if (result.isConfirmed) {
    $.ajax({
		type: 'post',
        data:{
            deptId:deptId
        },
		url: './ajax/delete-dept.jsp',
		success: function(result) {
            console.log(result.data);
            if(result.data.status){
                Swal.fire(
                'Deleted!',
                 result.data.message,
                'success'
                )
                setInterval(() => {
                    window.location = './department.jsp';
                }, 2000);
                
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
function unlinkSubjectFromDept(el,subjectId){
    const deptId = $('#viewSubjects').find('.deptId').val();
    const semId = $('#viewSubjects').find('.semId').val();
    console.log(deptId,semId,subjectId);
  Swal.fire({
  title: 'Are you sure?',
  text: "You won't be able to revert this!",
  icon: 'warning',
  showCancelButton: true,
  confirmButtonColor: '#3085d6',
  cancelButtonColor: '#d33',
  confirmButtonText: 'Yes, unlink it!'
  }).then((result) => {
  if (result.isConfirmed){
    $.ajax({
		type: 'post',
        data:{
            deptId:deptId,
            semId:semId,
            subjectId:subjectId
        },
		url: './ajax/unlink-subject-from-dept.jsp',
		success: function(result) {
            console.log(result.data);
            if(result.data.status){
                Swal.fire(
                'Unlinked!',
                 result.data.message,
                'success'
                )
                $(el).parents('.subjects').remove();
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
function updateDepartmentModal(deptId){
  $('#editDepartment').modal().show();
  $('#editDepartment').find('.deptId').val(deptId);
  $.ajax({
		type: 'post',
        data:{
            deptId:deptId
        },
		url: './ajax/dept-details.jsp',
		success: function(result) {
            $('#dept_name').val(result.data.dept_name);
		},
        error: function(err){
        console.log(JSON.stringify(err));
        }
	});
}
function updateDepartment(){
    const deptId = $('#editDepartment').find('.deptId').val();
    const deptName = $('#editDepartment').find('#dept_name').val();
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
            deptId:deptId,
            deptName:deptName
        },
		url: './ajax/update-dept.jsp',
		success: function(result) {
            console.log(result.data);
            if(result.data.status){
                Swal.fire(
                'Updated!',
                 result.data.message,
                'success'
                )
                setInterval(()=>{
                   window.location.reload();
                },1000)
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