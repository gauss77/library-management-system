<%@ include file="./includes/config.jsp"%>
<%
if(session.getAttribute("isLoggedIn")== "true") {
String referrer = request.getHeader("referer");
 out.print(referrer);
 if(referrer == null){
     response.sendRedirect("./");
 }
 else{
   response.sendRedirect(referrer);
 } 
}
String error_message = null;
%>
<% 
    try{
        String username= request.getParameter("username");
        String password= request.getParameter("password");
      if(username != null & password !=null){
      ps= conn.prepareStatement("select * from users where username=? and password=? FETCH NEXT 1 ROWS ONLY ");
      ps.setString(1,username);
      ps.setString(2,password);
      rs = ps.executeQuery();
      if(rs.next()){
         session.setAttribute("id",rs.getString("id"));
         session.setAttribute("username",rs.getString("username"));
         session.setAttribute("role",rs.getString("role"));
         session.setAttribute("isLoggedIn","true");
         response.sendRedirect("./");
      }
      else{
          error_message = "login failed! Username or Password is wrong";
      }
    }
    }
    catch(Exception e){
        System.out.println(e);
    }
%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <title>Login</title>
</head>

<body>
    <nav class="navbar navbar-expand-sm bg-dark navbar-dark" id="header">
        <span class="navbar-text text-light">
            Library Management
        </span>
    </nav>
    <div class="login-container" id="body">
    <div>  
    <% if(error_message != null){ %>
    <div class="alert alert-danger alert-dismissible fade show mt-2">
    <button type="button" class="close" data-dismiss="alert">&times;</button><%= error_message %>
    </div>
    <% } %>
    <div class="login jumbotron">
            <h3>Login</h3>
            <form action="" autocomplete="off" method="post">
                <div class="input-group mb-3">
                    <input type="text" class="form-control" placeholder="Your Username" name="username">
                    <div class="input-group-append">
                        <span class="input-group-text"><i class="fa fa-user" aria-hidden="true"></i></span>
                    </div>
                </div>
                <div class="input-group mb-3">
                    <input type="password" class="form-control" placeholder="Your Password" name="password">
                    <div class="input-group-append">
                        <span class="input-group-text"><i class="fa fa-key" aria-hidden="true"></i></span>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary">Login</button>
            </form>
        </div>
    </div>
</div>
    <footer class="footer text-center" id="footer">
       <span>Copyright by &copy; Kartik Kumar</span>
    </footer>
    <script>
        $(document).ready(function () {
            console.log('page loaded');
            headerHeight = 56;
            footerHeight = 32;
            bodyHeight = $(window).height() - (headerHeight + footerHeight);
            console.log(headerHeight, bodyHeight, footerHeight, $(window).height());
            $('#body').height(bodyHeight);
        });
    </script>
</body>

</html>