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
    if(request.getParameter("book_name") != null){
        String book_name = capitalizeString(request.getParameter("book_name"));
        String author_name = capitalizeString(request.getParameter("author_name"));
        String date_created = currentDateTime();
        ps = conn.prepareStatement("select count(*) as count from books where name=?");
        ps.setString(1,book_name);
        rs = ps.executeQuery();
        if(rs.next()){
            if(rs.getInt("count") == 0){
            ps = conn.prepareStatement("insert into books (name,author,date_created) values (?,?,?)");
            ps.setString(1,book_name); 
            ps.setString(2,author_name); 
            ps.setString(3,date_created);
            int check = ps.executeUpdate(); 
                if(check != 0){
                    success_message = "Book details added successfully";
                }
                else{
                error_message = "Somrthing went wrong";
                }
            } 
            else{
            error_message = "Book details already exist";
                        
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
    <title>Books</title>
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
                                <h3>Books</h3>
                            </div>
                        </div>
                        <div class="col-md-6 text-right">
                            <button class="btn btn-info btn-sm" data-toggle="modal" data-target="#addNewBookDetails">Add
                                New</button>
                        </div>
                    </div>
                     <%if(error_message != null){%>
                         <div class="alert alert-danger alert-dismissible fade show mt-2"><button type="button" class="close" data-dismiss="alert">&times;</button><%= error_message %></div>
                    <% } %>
                    <%if(success_message != null){%>
                        <div class="alert alert-success alert-dismissible fade show mt-2"><button type="button" class="close" data-dismiss="alert">&times;</button><%= success_message %></div>
                    <% } %>
                    <div class="row mt-4">
                        <div class="col-md-3">
                            <div class="form-group">
                                <Select class="form-control" id="department" name="department" onchange="booksByDept()">
                                    <option value="">Select Department</option>
                                   <%
                                            ps = conn.prepareStatement("select id,name from departments order by name");
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
                        <div class="col-md-2">
                            <div class="form-group">
                                <Select class="form-control" id="semester" name="semester"  onchange="booksBySemester(this,$('#department').val())">
                                    <option value="">Select Semester</option>
                                </Select>
                            </div>
                        </div>
                         <div class="col-md-3">
                            <div class="form-group">
                                <Select class="form-control" id="subjectList" name="subject" onchange="booksBySubject(this,$('#department').val(),$('#semester').val())">
                                    <option value="">Select Subject</option>
                                </Select>
                            </div>
                        </div>
                         <div class="col-md-4">
                                <div class="form-group">
                                <div class="input-group mb-3">
                                    <input type="search" class="form-control" placeholder="Search by book name or book unit barcode" id="ac_book">
                                    <div class="input-group-append" id="searchBook">
                                        <span style="cursor:pointer" class="input-group-text"><i class="fa fa-search"  aria-hidden="true"></i></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row custom-height">
                        <div class="col-md-12 booksBySubject" id="bookDetails">
                            <table class="table table-hover border-right border-left border-bottom text-center">
                                <thead>
                                    <tr>
                                        <th>S.No</th>
                                        <th>Book Name</th>
                                        <th class="text-center">Author Name</th>
                                        <th class="text-center">Action</th>
                                    </tr>
                                </thead>
                                <tbody>
                                  <% ps = conn.prepareStatement("select * from books order by name");
                                   rs = ps.executeQuery();
                                      int i=0;                                   
                                     while(rs.next()){ %>
                                    <tr>
                                        <td><%= i+=1 %></td>
                                        <td><%= rs.getString("name") %></td>
                                        <td><%= rs.getString("author") %></td>
                                        <td>
                                            <Button class="btn btn-success btn-sm" onclick='showBookUnitsModal("<%= rs.getString("id") %>","<%= rs.getString("name") %>")'>Show Book Units</Button>
                                            <Button class="btn btn-info btn-sm" onclick='addBookUnitsModal("<%= rs.getString("id") %>","<%= rs.getString("name") %>")'>Add Book Units</Button>
                                            <Button onclick='updateBookModal("<%= rs.getString("id") %>")' class="btn btn-warning btn-sm">Edit</Button>
                                            <% if(role.equals("admin")){ %>
                                            <Button onclick='deleteBook("<%= rs.getString("id") %>")' class="btn btn-danger btn-sm">Delete</Button>
                                            <%}%>
                                            <% if(role.equals("user")){ %>
                                            <Button class="btn btn-secondary btn-sm">Delete</Button>
                                            <%}%>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Add book units -->
    <div class="modal" id="addBookUnits" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" style="display:flex;justify-content:center;max-width:none;">
            <div class="modal-content" style="width: 70vw;">

                <!-- Modal Header -->
                <div class="modal-header">
                <h4>Add Book Units of <span class="badge badge-secondary bookName"></span></h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                        
                        <form autocomplete="off">
                        <div id="data-box0" class="" data-index="0">
                                    <div class="box main"></div>
                        </div>
                        <input type="hidden" class="bookId" value="">
                        </form>
                         
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
                  <input type="hidden" class="bookId" value="">
            </div>
        </div>
    </div>
    <!-- add book details -->
    <div class="modal" id="addNewBookDetails" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">Add new book details</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                    <div class="m-4">
                        <form action="" method="post" autocomplete="off">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="book_name">Book Name:</label>
                                        <input type="text" class="form-control" placeholder="Enter Book Name"
                                            id="book_name" name="book_name" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="author_name">Author Name:</label>
                                        <input type="text" class="form-control" placeholder="Enter Book Author Name"
                                            id="author_name" name="author_name" required>
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
    <%-- update book unit details --%>
    <div class="modal" id="updateBookUnitDetails" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">Update book unit details</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                    <div class="m-4">
                            <div class="row font-weight-bold">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="book_name">Barcode:</label>
                                        <input type="text" class="form-control" id="b_barcode" name="b_barcode">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="author_name">ISBN:</label>
                                        <input type="text" class="form-control"
                                            id="b_isbn" name="b_isbn">
                                    </div>
                                </div>
                            </div>
                            <div class="row font-weight-bold">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="book_name">Edition:</label>
                                        <input type="text" class="form-control" id="b_edition" name="b_edition">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="author_name">Price:</label>
                                        <input type="text" class="form-control"
                                            id="b_price" name="b_price">
                                    </div>
                                </div>
                            </div>
                            <input type="hidden" class="bookUnitId" value="">
                    </div>
                </div>
                  <div class="modal-footer">
                        <button onclick="updateBookUnit()" class="btn btn-primary">Update</button>
                    </div>
            </div>
        </div>
    </div>
    <!-- update book details -->
    <div class="modal" id="updateBookDetails" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">

                <!-- Modal Header -->
                <div class="modal-header">
                    <h4 class="modal-title">Update book details</h4>
                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                </div>

                <!-- Modal body -->
                <div class="modal-body">
                    <div class="m-4">
                            <div class="row font-weight-bold">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="book_name">Book Name:</label>
                                        <input type="text" class="form-control" id="b_name" name="b_name">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="author_name">Author Name:</label>
                                        <input type="text" class="form-control"
                                            id="b_author" name="b_author">
                                    </div>
                                </div>
                                <input class="bookId" type="hidden" value="">
                            </div>
                    </div>
                </div>
                  <div class="modal-footer">
                            <button onclick="updateBook()" class="btn btn-primary">Update</button>
                            </div>
            </div>
        </div>
    </div>
   <%@ include file="./includes/footer.jsp" %>
    <script>
    // search book 
     $('#searchBook').click(function(){
        //  console.log("clicked");
      const searchQuery = $('#ac_book').val();
        // console.log(searchQuery);
      $.ajax({
						type: 'post',
						data: {
							searchQuery: searchQuery
						},
						url: './ajax/search-book.jsp',
						success: function(result) {

                            // console.log(result.data.isData);
                            renderBookDetails(result, '#bookDetails');
						},
                        error: function(err){
                          console.log(err)
                        }
					})
    });

 function renderBookDetails(data1, target){
        // console.log(data1);
        if(data1.data.length > 0 && data1.isData){
                                // console.log(result);
            let bd = `<table class="table table-hover border-right border-left border-bottom text-center">
                      <thead>
                            <tr>
                                <th>S.No</th>
                                <th>Book Name</th>
                                <th class="text-center">Author Name</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                    <tbody>`
        data1.data.map((data,index) => { 
            bd+=`<tr>
                  <td>\${index+1}</td>
                    <td>\${data.name}</td>
                    <td>\${data.author}</td>
                     <td>
                        <Button class="btn btn-success btn-sm" onclick='showBookUnitsModal("\${data.id}","\${data.name}")'>Show Book Units</Button>
                        <Button class="btn btn-info btn-sm" onclick='addBookUnitsModal("\${data.id}","\${data.name}")' >Add Book Units</Button>
                        <Button class="btn btn-warning btn-sm" onclick='updateBookModal("\${data.id}")'>Edit</Button>
                        <% if(role.equals("admin")){ %>
                            <Button class="btn btn-danger btn-sm" onclick='deleteBook("\${data.id}")'>Delete</Button>
                        <% } %>
                        <% if(role.equals("user")){ %>
                           <Button class="btn btn-secondary btn-sm">Delete</Button>
                        <% } %>
                        
                    </td>
                </tr>`
        });
        bd += `</tbody>
               </table>`
    
    $(target).html(bd);
        }
    else{
        $("#bookDetails").html(`<div class="container h-100">
            <div class="row align-items-center h-100">
                <div class="col-6 mx-auto text-center">
                    <div class="jumbotron">
                         <h1> Opps! </h1>
                         <p class="text-muted">There is no books of this name or barcode</p>
                    </div>
                </div>
            </div>
         </div>`);
                            }
     
    }
    </script>
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

        function addBookUnit(el,bookId){
            let parentEl = $(el).parents('.box');
            const data =  {'barcode':$(parentEl).find('.barcode').val(),
                            'edition': $(parentEl).find('.edition').val(),
                            'price':$(parentEl).find('.price').val(),
                            'isbn':$(parentEl).find('.isbn').val(),
                            'bookId':bookId
                            }             
            let flag = true;
            $(parentEl).find('.err').empty();
            if(isEmpty(data.barcode)){
                flag = false;
                $(parentEl).find('.err_barcode').html(`Please enter barcode`).css({color: '#f00'});
                
            }
            let editionPattern = /^([1-9])([0-9]){0,1}th$/;
               if(!editionPattern.test(data.edition)){
                flag = false;
                $(parentEl).find('.err_edition').html(`please enter edition eg:1th, 10th, 15th`).css({color: '#f00'});
                
            }

             if(isEmpty(data.price)){
                flag = false;
                 $(parentEl).find('.err_price').html(`Please enter price`).css({color: '#f00'});
                
            }
            let pricePattern = /^-?\d*(\.\d+)?$/;
             if(!pricePattern.test(data.price)){
                flag = false;
                 $(parentEl).find('.err_price').html(`Please enter a valid price`).css({color: '#f00'});
                
            }
            

            if(flag == true){ 
                // console.log(searchQuery);
                $.ajax({
						type: 'post',
						data: data,
						url: './ajax/add-book-units.jsp',
						success: function(result) {
                            // console.log(result.data);
                            if(result.data.status){
                                    setTimeout(()=>{
                                             $(parentEl).find('.err_barcode').fadeOut();
                                        },5000 )
                                    $(parentEl).find('.err_barcode').html(result.data.message).css({color: 'rgb(15 178 15)'});
                                    $(parentEl).find('.price').attr('readonly',true);
                                    $(parentEl).find('.edition').attr('readonly',true);
                                    $(parentEl).find('.barcode').attr('readonly',true);
                                    $(parentEl).find('.isbn').attr('readonly',true);
                                    obj0.getBox();
                            }
                            else{
                                 $(parentEl).find('.err_barcode').html(result.data.message).css({color: '#f00'});
                            }
						},
                         error: function(err){
                              console.log(err);
                          $(parentEl).find('.err_barcode').html("something went wrong").css({color: '#f00'});
                        }
					})
                
                console.log(data);
               
            }   
        }
 
        var obj0 = new Multibox('#data-box0', function(data, source) {
              
        source({
				view: `
                 <div style="background: #eee;padding: 8px 0px;" class="row mx-3 text-center mb-2 box">
                            <div class="col-md-1 ">
                                <span style="position: absolute;top: 6px;">\${parseInt(data.box)+1}</span>
                            </div>
                            <div class="col-md-3">
                                <div class="">
                                    <input type="text" class="form-control barcode" placeholder="Barcode*"
                                        id="book_barcode" name="book_barcode">
                                        <div style="text-align: left;font-size: 0.8rem;margin-left: 11px;"><span class="err_barcode err"></span></div>
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="">
                                    <input type="text" class="form-control edition" placeholder="Edition*"
                                        id="book_edition" name="book_edition" required>
                                         <div style="text-align: left;font-size: 0.8rem;margin-left: 11px;"><span class="err_edition err"></span></div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="">
                                    <input type="text" class="form-control isbn" placeholder="ISBN"
                                        id="isbn" name="isbn">
                                </div>
                            </div>
                            <div class="col-md-2">
                                <div class="">
                                    <input type="text" class="form-control price" placeholder="Price*" id="book_price"
                                        name="book_price">
                                        <div style="text-align: left;font-size: 0.8rem;margin-left: 11px;"><span class="err_price err"></span></div>
                                </div>
                            </div>
                            <div class="col-md-1">
                                <button type="button" class="btn btn-info add-box" onclick="addBookUnit(this,$('#addBookUnits').find('.bookId').val())"><i class="fa fa-plus" aria-hidden="true"></i></button>
                                <button type="button" style="display:none"  class="btn btn-success remove-box"><i class="fa fa-check" aria-hidden="true"></i></button>
                            </div>
                        </div>
                `
			});
        });

        $(document).ready(function () {
            
			obj0.getBox();
         
		});
function addBookUnitsModal(bookId, bookName){
     obj0.reset();
    //   console.log(bookId,bookName);
    $('#addBookUnits').find('.bookId').val(bookId);
    $('#addBookUnits').find('.bookName').text(bookName);
    $('#addBookUnits').modal('show');
}
function showBookUnitsModal(bookId, bookName){
    
    // console.log(key,bookName);
    $('#showBookUnits').find('.bookId').val(bookId);
    $('#showBookUnits').find('.bookName').text(bookName);
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
	})
    $('#showBookUnits').modal('show');
    
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
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>`
        data1.data.map((data,index)=>{
           bookUnitContainer += `<tr class="bookUnit">
                                <td>\${index+1}</td>
                                <td>\${data.barcode}</td>
                                 <td>\${data.isbn}</td>
                                <td>\${data.edition}</td>
                                <td>&#8377; \${data.price.toFixed(2)}</td>
                                <td class="text-center">
                                <Button onclick='updateBookUnitModal(this,"\${data.id}")' class="btn btn-warning btn-sm">Edit</Button>
                                <% if(role.equals("admin")){ %>
                                    <Button onclick='deleteBookUnit(this,"\${data.id}")' class="btn btn-danger btn-sm">Delete</Button>
                                <%}%>
                                <% if(role.equals("user")){ %>
                                    <Button class="btn btn-secondary btn-sm">Delete</Button>
                                <%}%>
                            </tr>`
  
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
function booksByDept(){
     renderSemester()
}
function booksBySemester(el,deptId){
    const semId = el.value
     renderSubject(semId,deptId)
}
function booksBySubject(el,deptId,semId){
   const subjectId = el.value
   console.log(deptId,semId,subjectId)
   $.ajax({
      type:'post',
      data:{
          deptId:deptId,
          semId:semId,
          subjectId:subjectId
      },
      url:'./ajax/books-by-subject.jsp',
      success:function(result){
          renderBooksBySubject(result,'.booksBySubject');
      },
      error:function(err){
          console.log(err)
      }
  })
}
function renderBooksBySubject(data1,target){
   if(data1.data.length > 0 && data1.isData){
                                // console.log(result);
        let bd = `<table class="table table-hover border-right border-left border-bottom text-center">
                      <thead>
                            <tr>
                                <th>S.No</th>
                                <th>Book Name</th>
                                <th class="text-center">Author Name</th>
                                <th class="text-center">Action</th>
                                <th class="text-center">Make Default</th>
                            </tr>
                        </thead>
                    <tbody>`
        data1.data.map((data,index) => { 
            bd +=`
                    <tr>
                  <td>\${index+1}</td>
                    <td>\${data.book_name}</td>
                    <td>\${data.author}</td>
                     <td>
                        <Button class="btn btn-success btn-sm" onclick='showBookUnitsModal("\${data.book_id}","\${data.book_name}")'>Show Book Units</Button>
                        <Button class="btn btn-info btn-sm" onclick='addBookUnitsModal("\${data.book_id}","\${data.book_name}")' >Add Book Units</Button>
                        <Button class="btn btn-warning btn-sm" onclick='updateBookModal("\${data.book_id}")'>Edit</Button>
                        <% if(role.equals("admin")){ %>
                        <Button class="btn btn-danger btn-sm" onclick='deleteBook("\${data.book_id}")'>Delete</Button>
                        <% } %>
                         <% if(role.equals("user")){ %>
                        <Button class="btn btn-secondary btn-sm" >Delete</Button>
                        <% } %>
                    </td>
                    <td class="text-center"><input \${data.default_book == 1 ? 'checked':''} type="radio" name="defaultBook" onclick=setDefaultBook(this,\${data.book_id},\${data.subject_id})>
                    <div style="text-align: center;font-size: 0.8rem;margin-left: 11px;"><span class="defaultBookMessage"></span></div>
                    </td>
                </tr>`
        });
         bd+= ` </tbody>
               </table>` 
    $(target).html(bd);
        }
    else{
        $("#bookDetails").html(`<div class="container h-100">
            <div class="row align-items-center h-100">
                <div class="col-6 mx-auto text-center">
                    <div class="jumbotron">
                         <h1> Opps! </h1>
                         <p class="text-muted">There is no books in this subject</p>
                    </div>
                </div>
            </div>
         </div>`);
     }
}
function renderSemester(){
    if(!isEmpty($('#department').val())){
                                $("#semester").html(` 
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
                                  `);
    }
    else{
        $("#semesterList").html(`<option value="">Select Semester</option>`);
    }
}
function renderSubject(semId,deptId){
    if(!isEmpty($('#semester').val())){
        $.ajax({
      type:'post',
      data:{
          semId:semId,
          deptId:deptId
      },
      url:'./ajax/render-books-by-sem.jsp',
      success:function(result){
          if(result.data.length > 0 && result.isData){
              let container = `<option value="">Select Subject</option>`
            result.data.map((data)=>{
                container += `
                <option value="\${data.subject_id}">\${data.subject_name}</option>`
            })
           $('#subjectList').html(container);
          }
          else{
              $("#subjectList").html(`<option value="">No subjects</option>`);
          }
      },
      error:function(err){
          console.log(err)
      }
  })
    }
    else{
        $("#subjectList").html(`<option value="">Select Semester</option>`);
    }
}

function setDefaultBook(el,bookId,subjectId){
    $('.defaultBookMessage').empty();
  const defaultBookValue = el.value;
  console.log(defaultBookValue,bookId,subjectId);
   $.ajax({
      type:'post',
      data:{
          bookId:bookId,
          subjectId:subjectId
      },
      url:'./ajax/set-default-book.jsp',
      success:function(result){
           console.log(result.data);
           if(result.data.status){
                     $(el).parents('tr').find('.defaultBookMessage').html(result.data.message).css({color: 'rgb(15 178 15)'});
           }
           else{
            //    $('.defaultBookMessage').html(result.data.message).css({color: '#f00'});
           }

      },
      error:function(err){
          console.log(err)
      }
  })
}
function deleteBook(bookId){
   Swal.fire({
  title: 'Are you sure?',
  text: "You won't be able to revert this!",
  icon: 'warning',
  showCancelButton: true,
  confirmButtonColor: '#3085d6',
  cancelButtonColor: '#d33',
  confirmButtonText: 'Yes, delete it!'
  }).then((result) => {
  if (result.isConfirmed){
    $.ajax({
		type: 'post',
        data:{
            bookId:bookId
        },
		url: './ajax/delete-book.jsp',
		success: function(result) {
            console.log(result.data);
            if(result.data.status){
                Swal.fire(
                'Deleted!',
                 result.data.message,
                'success'
                )
                setInterval(() => {
                    window.location = './books.jsp';
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
function deleteBookUnit(el,bookUnitId){
     Swal.fire({
  title: 'Are you sure?',
  text: "You won't be able to revert this!",
  icon: 'warning',
  showCancelButton: true,
  confirmButtonColor: '#3085d6',
  cancelButtonColor: '#d33',
  confirmButtonText: 'Yes, delete it!'
  }).then((result) => {
  if (result.isConfirmed){
    $.ajax({
		type: 'post',
        data:{
            bookUnitId:bookUnitId
        },
		url: './ajax/delete-book-unit.jsp',
		success: function(result) {
            console.log(result.data);
            if(result.data.status){
                Swal.fire(
                'Deleted!',
                 result.data.message,
                'success'
                )
                $(el).parents('.bookUnit').remove();
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

function updateBookModal(bookId){
    $('#updateBookDetails').modal().show();
    $('#updateBookDetails').find('.bookId').val(bookId);
     $.ajax({
		type: 'post',
        data:{
            bookId:bookId
        },
		url: './ajax/book-details.jsp',
		success: function(result) {
            console.log(result.data)
            $('#b_name').val(result.data.book_name);
            $('#b_author').val(result.data.author);
		},
        error: function(err){
        console.log(JSON.stringify(err));
        }
	});
    
}
function updateBook(){
  const bookName = $('#b_name').val();
  const author = $('#b_author').val();
  const bookId =  $('#updateBookDetails').find('.bookId').val();
  console.log(bookId,bookName,author);
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
           bookId:bookId,
           bookName:bookName,
           author:author
        },
		url: './ajax/update-book.jsp',
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
function updateBookUnitModal(el,bookUnitId){
    console.log(bookUnitId)
   $('#updateBookUnitDetails').modal().show();
   $('#updateBookUnitDetails').find('.bookUnitId').val(bookUnitId);
         $.ajax({
		type: 'post',
        data:{
            bookUnitId:bookUnitId
        },
		url: './ajax/book-unit-details.jsp',
		success: function(result) {
            console.log(result.data);
            $('#b_barcode').val(result.data.barcode);
            $('#b_isbn').val(result.data.isbn);
            $('#b_edition').val(result.data.edition);
            $('#b_price').val(result.data.price);
		},
        error: function(err){
        console.log(JSON.stringify(err));
        }
	});
}
function updateBookUnit(){
    const bookUnitId = $('#updateBookUnitDetails').find('.bookUnitId').val();
    const barcode = $('#b_isbn').val();
    const isbn = $('#b_isbn').val();
    const edition = $('#b_edition').val();
    const price =  $('#b_price').val();
    console.log(bookUnitId,barcode,isbn,edition,price);
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
            bookUnitId:bookUnitId,
            barcode:barcode,
            isbn:isbn,
            edition:edition,
            price:price
        },
		url: './ajax/update-book-unit.jsp',
		success: function(result) {
            console.log(result.data);
            if(result.data.status){
                Swal.fire(
                'Updated!',
                 result.data.message,
                'success'
                )
                $('#updateBookUnitDetails').modal('hide');
                // showBookUnitsModal($('#showBookUnits').find('.bookId').val(),('#showBookUnits').find('.bookName').html());
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