<%@ include file="./includes/config.jsp"%>
<%@ include file="./includes/lib.jsp"%>
<%@ page import="custom.DateProvider"%>
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
   if(request.getParameter("subject") != null){
   String subject_name = capitalizeString(request.getParameter("subject"));
   String date_created = currentDateTime();
   ps = conn.prepareStatement("select count(*) as count from subjects where name=?");
   ps.setString(1,subject_name);
   rs = ps.executeQuery();
   if(rs.next()){
       //out.print("count"+rs.getString("count"));
     if(rs.getInt("count")==0){
       //out.print(roll_no);
   ps = conn.prepareStatement("insert into subjects(name,date_created) values(?,?)");
   ps.setString(1,subject_name);
   ps.setString(2,date_created);
   int check=ps.executeUpdate();
   if(check!=0){
       success_message ="Subject added successfully";
        //out.print("query success");
   }
   else{
        error_message ="Something went wrong";
       // out.print("query failed");
   }
}
else{
    error_message ="Subject already exist";
     }
}
} 
}
 
catch(SQLException e){
    System.out.print("SQLException: "+e);
    error_message ="Error ocurred! Please try again";
}
catch(Exception e){
    System.out.print("Exception: "+e);
    error_message ="Error ocurred! Please try again";
}
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Subject</title>
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
                                <h3>Subjects</h3>
                            </div>
                        </div>
                        <div class="col-md-6 text-right">
                            <button class="btn btn-info btn-sm" data-toggle="modal" data-target="#addSubject">Add
                                Subject</button>
                        </div>
                    </div>
                     <%if(error_message != null){%>
                         <div class="alert alert-danger alert-dismissible fade show mt-2"><button type="button" class="close" data-dismiss="alert">&times;</button><%= error_message %></div>
                    <% } %>
                    <%if(success_message != null){%>
                        <div class="alert alert-success alert-dismissible fade show mt-2"><button type="button" class="close" data-dismiss="alert">&times;</button><%= success_message %></div>
                    <% } %>
                    <div class="row my-3">
                        <div class="col-md-3">
                            <div class="form-group">
                                <Select class="form-control" id="department" name="department" onchange="subjectsByDepartment(this)">
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
                        <div class="col-md-3">
                            <div class="form-group">
                                <Select class="form-control" id="semesterList" name="semester" onchange="subjectsBySemester(this,$('#department').val())">
                                    <option value="">Select Semester</option>
                                   
                                </Select>
                            </div>
                        </div>
                        <div class="col-md-6">
                                <div class="form-group">
                                    <div class="input-group mb-3">
                                        <input type="search" class="form-control" placeholder="Search by subject name" id="searchQuery">
                                        <div class="input-group-append" onclick="searchSubject()">
                                            <span style="cursor:pointer" class="input-group-text"><i class="fa fa-search"  aria-hidden="true"></i></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                    </div>
                    <div class="row custom-height">
                        <div class="col-md-12 " id="subjectsByDepartment">
                           
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- add subject -->
    <div class="modal" id="addSubject" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">Add Subject</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <form action="" method="post">
                    <div class="modal-body">
                        <div class="mt-2">
                            <div class="col-md-12">
                                <div class="form-group">
                                    <input type="text" class="form-control" placeholder="Enter New Subject" id="subject_name" name="subject" required>
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
     <!-- edit subject detail-->
    <div class="modal" id="editSubject" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">Update subject details</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                    <div class="mt-2">
                                <div class="col-md-12">
                                    <div class="form-group">
                                     <label class="font-weight-bold">Subject Name:</label>
                                        <input type="text" class="form-control" id="sub_name">
                                    </div>
                                </div>
                            </div>
                           <div class="modal-footer">
                                <button onclick="updateSubject()"class="btn btn-primary">Update</button>
                          </div>
                    </div>
                    <input type="hidden" class="subjectId" value="">
            </div>
        </div>
    </div>
     <!-- link subject to department -->
    <div class="modal" id="linkBooks" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                  <h4>Linking books in <span class="badge badge-secondary subjectName"></span></h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                        <div id="data-box0" data-index="0">
                                    <div class="box main"></div>
                        </div>
                        <input type="hidden" class="subjectId" value="">
                </div>
            </div>
        </div>
    </div>
     <%-- view Books --%>
    <div class="modal" id="viewBooks" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                  <h4>Books in <span class="badge badge-secondary subjectName"></span></h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                   <input type="hidden" class="subjectId" value="">
                    <div id="bookList"></div>
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

        function linkBooks(el,subjectId){
            let parentEl = $(el).parents('.box');
            const data =  {'subjectId':subjectId,
                            'bookId':$(parentEl).find('.book').val()
                            }             
            let flag = true;
            $(parentEl).find('.err').empty();
            if(isEmpty(data.bookId)){
                flag = false;
                $(parentEl).find('.err_book').html(`Please select book`).css({color: '#f00'});
            }
            if(flag == true){ 
                // console.log(searchQuery);
                $.ajax({
						type: 'post',
						data: data,
						url: './ajax/link-books-to-subject.jsp',
						success: function(result) {
                            console.log(result.data);
                            if(result.data.status){
                                    setTimeout(()=>{
                                             $(parentEl).find('.err_book').fadeOut();
                                        },5000 )
                                  
                                    $(parentEl).find('.err_book').html(result.data.message).css({color: 'rgb(15 178 15)'});
                                    $(parentEl).find('.book').attr('disabled',true);
                                     obj0.getBox();   
                            }
                            else{
                                 $(parentEl).find('.err_book').html(result.data.message).css({color: '#f00'});
                            }
						},
                         error: function(err){
                              console.log(err);
                          $(parentEl).find('.err_book').html("something went wrong").css({color: '#f00'});
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
                                    <Select class="form-control book" id="subject" name="subject">
                                        <option value="">Books*</option>
                                    <%
                                         ps = conn.prepareStatement("Select id,name from books order by name");
                                            rs = ps.executeQuery();
                                            while(rs.next()){
                                            %>
                                            <option value="<%= rs.getInt("id") %>"><%= rs.getString("name")%></option>
                                            <%
                                             }
                                            %>
                                    </Select>
                                    <div style="text-align: left;font-size: 0.8rem;margin-left: 11px;"><span class="err_book err"></span></div>
                                </div>
                            </div>
                            <div class="col-md-1">
                                 <button type="button" class="btn btn-info add-box" onclick="linkBooks(this,$('#linkBooks').find('.subjectId').val())"><i class="fa fa-plus" aria-hidden="true"></i></button>
                                <button type="button" style="display:none"  class="btn btn-success remove-box"><i class="fa fa-check" aria-hidden="true"></i></button>
                            </div>
                        </div>
                `
			});
        });

        $(document).ready(function () {
            
			obj0.getBox();
            subjectsByDepartment('');
		});

function linkBooksModal(subjectId,subjectName){
    console.log(subjectId,subjectName);
    $('#linkBooks').find('.subjectName').text(subjectName);
    $('#linkBooks').find('.subjectId').val(subjectId);
    $('#linkBooks').modal().show();
    obj0.reset();
}
function viewBooksModal(subjectId,subjectName){
    console.log(subjectId,subjectName);
    $('#viewBooks').find('.subjectName').text(subjectName);
    $('#viewBooks').find('.subjectId').val(subjectId);
    $('#viewBooks').modal().show();

     $.ajax({
		type: 'post',
        data:{
            subjectId:subjectId
        },
		url: './ajax/subjects-book-list.jsp',
		success: function(result) {
         console.log(result.data);
         renderBookList(result,'#bookList');        
		},
        error: function(err){
        console.log(err);
        }
	})
}
function renderBookList(data1,target){
 if(data1.data.length > 0 && data1.isData){
       let bl = ` <table class="table table-hover border-right border-left border-bottom">
                        <thead>
                            <tr>
                                <th class="text-center">S.No</th>
                                <th>Book Name</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>`
        data1.data.map((data,index)=>{
           bl += `<tr class="books">
                                <td class="text-center">\${index+1}</td>
                                <td>\${data.book_name}</td>
                                <td class="text-center">
                                <% if(role.equals("admin")){ %>
                                    <Button onclick='unlinkBook(this,"\${data.book_id}")' class="btn btn-danger btn-sm mr-2">Unlink</Button>
                                <%}%>
                                <% if(role.equals("user")){ %>
                                    <Button class="btn btn-secondary btn-sm mr-2">Unlink</Button>
                                <%}%>
                            </tr>`
  
        });       
        bl += ` </tbody>
                    </table>`  
    $(target).html(bl);   
    }
    
    else{
        $("#bookList").html(`<div class="container h-100 text-center">
                         <h1> Opps! </h1>
                         <p class="text-muted">There is no books added in this subject</p>
         </div>`);
    }
}

function subjectsByDepartment(el){
  const deptId = el.value

  $.ajax({
      type:'post',
      data:{
          deptId:deptId
      },
      url:'./ajax/subjects-by-department.jsp',
      success:function(result){
          renderSemseters();
          renderSubjectsByDepartment(result,'#subjectsByDepartment');  
      },
      error:function(err){
          console.log(err)
      }
  })
}
function renderSubjectsByDepartment(data1,target){
   if(data1.data.length > 0 && data1.isData){
       let container = ` <table class="table table-hover border-right border-left border-bottom">
                        <thead>
                            <tr>
                                <th class="text-center">S.No</th>
                                <th>Subject Name</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>`
        data1.data.map((data,index)=>{
           container += `<tr>
                                <td class="text-center">\${index+1}</td>
                                <td>\${data.subject_name}</td>
                                <td class="text-center">
                                             <Button class="btn btn-success btn-sm" onclick='viewBooksModal("\${data.subject_id}","\${data.subject_name}")'>View Books</Button>
                                             <Button class="btn btn-info btn-sm" onclick='linkBooksModal("\${data.subject_id}","\${data.subject_name}")'>Link Books</Button>
                                             <Button onclick='updateSubjectModal("\${data.subject_id}")' class="btn btn-warning btn-sm">Edit</Button>
                                              <% if(role.equals("admin")){ %>
                                            <Button onclick='deleteSubject("\${data.subject_id}")' class="btn btn-danger btn-sm">Delete</Button>
                                            <%}%>
                                              <% if(role.equals("user")){ %>
                                            <Button class="btn btn-secondary btn-sm">Delete</Button>
                                            <%}%>
                            </tr>`
  
        });       
        container += ` </tbody>
                    </table>`  
    $(target).html(container);   
    }
    
    else{
        $("#subjectsByDepartment").html(`<div class="container jumbotron w-50 text-center mt-5">
                         <h1> Opps! </h1>
                         <p class="text-muted">There is no subject added in this department</p>
         </div>`);
    }
}
function subjectsBySemester(el,deptId){
  const semId = el.value
  console.log(deptId,semId)
  $.ajax({
      type:'post',
      data:{
          semId:semId,
          deptId:deptId
      },
      url:'./ajax/subjects-by-semester.jsp',
      success:function(result){
          renderSubjectsBySemester(result,'#subjectsByDepartment');
      },
      error:function(err){
          console.log(err)
      }
  })
}
function renderSemseters(){
    if(!isEmpty($('#department').val())){
                                $("#semesterList").html(` 
                                   <option value="">Select Semester</option>
                                  <% 
                                  ps = conn.prepareStatement("Select id,name from semesters order by name");
                                  rs = ps.executeQuery();
                                  while(rs.next()){
                                  %>
                                 <option value="<%= rs.getInt("id") %>"><%= rs.getString("name")%></option>
                                 <%
                                 }
                                %>`);
    }
    else{
        $("#semesterList").html(`<option value="">Select Semester</option>`);
    }
    
}
function renderSubjectsBySemester(data1,target){
  if(data1.data.length > 0 && data1.isData){
       let container = ` <table class="table table-hover border-right border-left border-bottom">
                        <thead>
                            <tr>
                                <th class="text-center">S.No</th>
                                <th>Subject Name</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>`
        data1.data.map((data,index)=>{
           container += `<tr>
                                <td class="text-center">\${index+1}</td>
                                <td>\${data.subject_name}</td>
                                <td class="text-center">
                                             <Button class="btn btn-success btn-sm" onclick='viewBooksModal("\${data.subject_id}","\${data.subject_name}")'>View Books</Button>
                                             <Button class="btn btn-info btn-sm" onclick='linkBooksModal("\${data.subject_id}","\${data.subject_name}")'>Link Books</Button>
                                              <Button onclick='updateSubjectModal("\${data.subject_id}")' class="btn btn-warning btn-sm">Edit</Button>
                                             <% if(role.equals("admin")){ %>
                                            <Button onclick='deleteSubject("\${data.subject_id}")' class="btn btn-danger btn-sm">Delete</Button>
                                            <%}%>
                                            <% if(role.equals("user")){ %>
                                            <Button class="btn btn-secondary btn-sm">Delete</Button>
                                            <%}%>
                            </tr>`
  
        });       
        container += ` </tbody>
                    </table>`  
    $(target).html(container);   
    }
    
    else{
        $("#subjectsByDepartment").html(`<div class="container jumbotron w-50 text-center mt-5">
                         <h1> Opps! </h1>
                         <p class="text-muted">There is no subject added in this semester</p>
         </div>`);
    }
}
function deleteSubject(subjectId){
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
            subjectId:subjectId
        },
		url: './ajax/delete-subject.jsp',
		success: function(result) {
            console.log(result.data);
            if(result.data.status){
                Swal.fire(
                'Deleted!',
                 result.data.message,
                'success'
                )
                setInterval(() => {
                    window.location = './subject.jsp';
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
function unlinkBook(el,bookId){
   const subjectId = $('#viewBooks').find('.subjectId').val();
   console.log(subjectId,bookId);
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
            bookId:bookId,
            subjectId:subjectId
        },
		url: './ajax/unlink-book-from-subject.jsp',
		success: function(result) {
            console.log(result.data);
            if(result.data.status){
                Swal.fire(
                'Unlinked!',
                 result.data.message,
                'success'
                )
                $(el).parents('.books').remove();
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
function updateSubjectModal(subjectId){
  $('#editSubject').modal().show();
  $('#editSubject').find('.subjectId').val(subjectId);
    $.ajax({
		type: 'post',
        data:{
            subjectId:subjectId
        },
		url: './ajax/subject-details.jsp',
		success: function(result) {
            $('#sub_name').val(result.data.subject_name);
		},
        error: function(err){
        console.log(JSON.stringify(err));
        }
	});
}
function updateSubject(){
    const subjectId =  $('#editSubject').find('.subjectId').val();
    const subjectName =  $('#editSubject').find('#sub_name').val();
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
            subjectId:subjectId,
            subjectName:subjectName
        },
		url: './ajax/update-subject.jsp',
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
function searchSubject(el){
    const searchQuery = $('#searchQuery').val();
     $.ajax({
		type: 'post',
        data:{
            searchQuery:searchQuery
        },
		url: './ajax/search-subject.jsp',
		success: function(result) {
             renderSubjectDetails(result, '#subjectsByDepartment');
		},
        error: function(err){
        console.log(JSON.stringify(err));
        }
	});
}
function renderSubjectDetails(data1,target){
    if(data1.data.length > 0 && data1.isData){
       let container = ` <table class="table table-hover border-right border-left border-bottom">
                        <thead>
                            <tr>
                                <th class="text-center">S.No</th>
                                <th>Subject Name</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>`
        data1.data.map((data,index)=>{
           container += `<tr>
                                <td class="text-center">\${index+1}</td>
                                <td>\${data.subject_name}</td>
                                <td class="text-center">
                                             <Button class="btn btn-success btn-sm" onclick='viewBooksModal("\${data.subject_id}","\${data.subject_name}")'>View Books</Button>
                                             <Button class="btn btn-info btn-sm" onclick='linkBooksModal("\${data.subject_id}","\${data.subject_name}")'>Link Books</Button>
                                              <Button onclick='updateSubjectModal("\${data.subject_id}")' class="btn btn-warning btn-sm">Edit</Button>
                                             <% if(role.equals("admin")){ %>
                                            <Button onclick='deleteSubject("\${data.subject_id}")' class="btn btn-danger btn-sm">Delete</Button>
                                            <%}%>
                                            <% if(role.equals("user")){ %>
                                            <Button class="btn btn-secondary btn-sm">Delete</Button>
                                            <%}%>
                            </tr>`
  
        });       
        container += ` </tbody>
                    </table>`  
    $(target).html(container);   
    }
    
    else{
        $("#subjectsByDepartment").html(`<div class="container jumbotron w-50 text-center mt-5">
                         <h1> Opps! </h1>
                         <p class="text-muted">There is no such subject</p>
         </div>`);
    }
}
</script>
</body>

</html>