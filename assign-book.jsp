<%@ include file="../includes/config.jsp"%>
<%@page contentType="text/html; charset=UTF-8"%>
<% 
String role = (String)session.getAttribute("role");
String isLoggedInString = (String) session.getAttribute("isLoggedIn");
Boolean isLoggedIn = Boolean.valueOf(isLoggedInString);
String error_message = null;
String success_message = null;
int dept_id = 0;
//out.print(role);
//out.print(isLoggedIn.getClass().getName()); 
if(!isLoggedIn) { 
      response.sendRedirect("./login.jsp");  
      return;
}
%>
<%
 try{
   if(request.getParameter("id") != null){
       String studnet_id = request.getParameter("id");
       ps = conn.prepareStatement("select full_name,roll_no,dept from students where id=? fetch next 1 rows only");
       ps.setString(1,studnet_id);
       rs = ps.executeQuery();
       if(rs.next()){
           success_message = "Student founded";
       }
       else{
           error_message = "Something went wrong";
       }
        dept_id = rs.getInt("dept");
   }
 }
 catch(Exception e){
     error_message = "Something went wrong";
    System.out.println(e);
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
    <link rel="stylesheet" href="./assets/css/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="./assets/js/lib.js"></script>
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
                        <div class="col-md-7">
                                <h3>Assign Books</h3>
                        </div>
                        <div class="col-md-5" id="assignInput">

                        </div>
                    </div>
                    <% if(error_message != null){ %>
                      <div class="alert alert-danger alert-dismissible fade show mt-2"><%= error_message%></div>
                    <% } %>
                     <% if(success_message != null){ %>
                    <div class="row mt-2 mx-1 bg-light py-2 rounded mb-2">
                        <div class="col-md-7">
                        <h4>Assigning to <span class="badge badge-secondary"><%= rs.getString("full_name")+" | "+rs.getString("roll_no")%></span></span></h4>
                        </div>
                         <div class="col-md-3">
                            <div class="">
                                <Select class="form-control selectable-none" tabindex="-1" id="department" name="department">
                                   <%
                                            ps = conn.prepareStatement("select id,name from departments where id=?");
                                            ps.setInt(1,dept_id);
                                            rs = ps.executeQuery();
                                            while(rs.next()){
                                            %>
                                            <option value="<%= rs.getInt("id") %>" readonly="readonly"><%= rs.getString("name")%></option>
                                            <%
                                             }
                                            %>
                                </Select>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="">
                                <Select class="form-control" id="semester" name="semester" onchange="booksOrderbySubject(this,$('#department').val())">
                                    <option value="">Select Semester</option>
                                   <%
                                            ps = conn.prepareStatement("select * from semesters order by name");
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
                    </div>
                     <input type="hidden" id="studentId" value="<%= request.getParameter("id")%>">
                    <div class="booksOrderbySubject custom-height">
                    </div>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
     <!-- show book units -->
    <div class="modal" id="showBookUnits" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg" style="display:flex;justify-content:center;max-width:none;">
            <div class="modal-content" style="width: 70vw;">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4>Book Units of <span class="badge badge-secondary bookName"></span></h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body" id="bookUnits">
                   
                </div>

            </div>
        </div>
    </div>
   <%@ include file="./includes/footer.jsp"%>
   <script>
   function booksOrderbySubject(el,deptId){
       const semId = el.value;
       console.log(deptId,semId)
       $.ajax({
          type:'post',
          data: {
             semId:semId,
             deptId:deptId
          },
          url:'./ajax/bookinfo-for-assign.jsp',
          success:function(result){
            console.log(result.data);
            renderBooksOrderbySubject(result,'.booksOrderbySubject');
            renderAssignInput();
          },
          error:function(err){
            console.log(err);
          } 
       })
   }
   function renderBooksOrderbySubject(data1,target){
    if(data1.data.length > 0 && data1.isData){
        let container = "";
    data1.data.map((data,index)=>{
        let bookList = '';
        data.book_list.map((value, i) => {
            if(i == 0){
                bookList += `<tr>
                                <td>\${1}</td>
                                <td>\${value.book_name}</td>
                                <td>\${value.author}</td>
                                <td>
                                    <Button class="btn btn-success btn-sm" onclick="BookUnitsModal('\${value.book_id}','\${value.book_name}')">Book Units</Button>    
                                </td>
                            </tr>`;
                            }
            else{
                bookList += `<tr class="collapse demo\${index}">
                                <td>\${i+1}</td>
                                <td>\${value.book_name}</td>
                                <td>\${value.author}</td>
                                <td>
                                    <Button class="btn btn-success btn-sm" onclick="BookUnitsModal('\${value.book_id}','\${value.book_name}')">Book Units</Button>
                                </td>  
                            </tr>`;
            }
          
        });

        if(isEmpty(bookList)){
            bookList += `<tr>
                                <td colspan="4">No books linked with this subject</td>
                                
                            </tr>`;
        }
        container += `<div class="row mb-2" style="background:lightcyan;margin: 0 2px;padding: 9px 0;border-radius: 8px;">
                      <div class="col-md-12" >
                           <div class="row bg-info p-2 rounded text-white border-left-4 headerTab">
                              <div class="col-md-11" style="display: flex;align-items: center;padding-left: 2px;">
                               <h4 >\${data.subject_name}</h4>
                              </div>
                              <div class="col-md-1" style="display: flex;align-items: center;">
                              <a class="text-white" href="javascript:{}" data-toggle="collapse" data-target=".demo\${index}">All Book</a>
                              </div>
                              
                           </div>
                            
                           <table class="table table-hover border-right border-left border-bottom text-center" style="background:#fff">
                                <thead>
                                    <tr>
                                        <th>S.No</th>
                                        <th>Book Name</th>
                                        <th class="text-center">Author Name</th>
                                        <th class="text-center">Action</th>
                                    
                                    </tr>
                                </thead>
                                <tbody>
                                    
                                    \${bookList}
                                </tbody>
                            </table>
                            
                        </div>
                    </div>`
     });
     $(target).html(container)
    }
    else{
         $(".booksOrderbySubject").html(`<div class="container h-100">
            <div class="row align-items-center h-100">
                <div class="col-6 mx-auto text-center">
                    <div class="jumbotron">
                         <h1> Opps! </h1>
                         <p class="text-muted">There is no subject added in this department</p>
                    </div>
                </div>
            </div>
         </div>`);
    }
   }
   function renderAssignInput(){
       $('#assignInput').html(` <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Enter barcode" id="getBarcode">
                                    <div class="input-group-append">
                                        <button class="btn btn-danger" onclick='assignBook()'>Assign</button>
                                    </div>
                                </div>
                                <span style="font-size:0.8rem" id="barcode_message"><span>
                                `);
   }
   function BookUnitsModal(bookId,bookName){
    $('#showBookUnits').find('.bookName').text(bookName);

     console.log(bookId,bookName);
      $.ajax({
		type: 'post',
        data:{
            bookId:bookId
        },
		url: './ajax/show-book-units.jsp',
		success: function(result) {
         console.log(result.data);
         renderBookUnits(result,'#bookUnits');        
		},
        error: function(err){
        console.log(err);
        }
	});
     $('#showBookUnits').modal().show();
}
function renderBookUnits(data1,target){
    //console.log(data1.data.length);
    if(data1.data.length > 0 && data1.isData){
       let bookUnitContainer = ` <table class="table table-hover border-right border-left border-bottom text-center">
                        <thead>
                            <tr>
                                <th>S.No</th>
                                <th>Barcode</th>
                                <th>ISBN</th>
                                <th>Edition</th>
                                <th>Price(Rs)</th>
                                <th>Is Assigned</th>
                            </tr>
                        </thead>
                        <tbody>`
        data1.data.map((data,index)=>{
           bookUnitContainer += `<tr>
                                <td>\${index+1}</td>
                                <td>\${data.barcode}</td>
                                 <td>\${data.isbn}</td>
                                <td>\${data.edition}</td>
                                <td>&#8377; \${data.price.toFixed(2)}</td>
                                <td>\${data.is_assigned == '1' ?'Yes':'No'}</td>

                                `
  
        });       
        bookUnitContainer += ` </tbody>
                    </table>`  
    $(target).html(bookUnitContainer);   
    }
    
    else{
        $("#bookUnits").html(`<div class="container h-100 text-center">
                         <h1> Opps! </h1>
                         <p class="text-muted">There is no units of this book</p>
         </div>`);
    }
}
function assignBook(el){
   const barcode = $('#getBarcode').val();
   const studentId = $('#studentId').val();
   const semId = $('#semester').val();
  console.log(barcode,studentId,semId);
  $.ajax({
		type: 'post',
        data:{
            barcode:barcode,
            studentId:studentId,
            semId:semId
        },
		url: './ajax/assign-book-student.jsp',
		success: function(result) {
         console.log(result);
         if(result.data.status){
             setTimeout(()=>{
                $('#barcode_message').fadeOut();
             },5000);
            $('#barcode_message').html(result.data.message).css({color: 'rgb(15, 178, 15)'}).show();
         }
         else{
            $('#barcode_message').html(result.data.message).css({color: 'rgb(255, 0, 0)'}).show();
         }

		},
        error: function(err){
        console.log(err);
        }
	});
}

</script>
</body>

</html>