<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <link rel="stylesheet" href="assets/css/style.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>

<body>
    <nav class="navbar navbar-expand-sm bg-dark navbar-dark" id="header">

        <!-- Links -->


        <!-- Navbar text-->
        <span class="navbar-text">
            Library Management
        </span>

    </nav>
    <div class="container-fluid" id="body">
        <div class="row">
           <%@ include file="header.jsp" %>
            <div class="col-md-10">
                <div class="body-container py-2">
                    <div class="border-bottom pb-2">
                        <h3>Book Details</h3>
                    </div>
                    <div class="m-4">
                        <form action="#">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="book_name">Book Name:</label>
                                        <input type="text" class="form-control" placeholder="Enter Book Name"
                                            id="book_name" name="book_name">
                                    </div>
                                    <div class="form-group">
                                        <label for="author_name">Author Name:</label>
                                        <input type="text" class="form-control" placeholder="Enter Book Author Name"
                                            id="author_name" name="author_name">
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-group">
                                        <label for="isbn">ISBN Number:</label>
                                        <input type="text" class="form-control" placeholder="Enter ISBN Number"
                                            id="isbn" name="isbn">
                                    </div>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">Submit</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer class="footer" id="footer">
        footer
    </footer>
    <script>
        $(document).ready(function () {
            console.log('page loaded');
            headerHeight = 56;
            footerHeight = 32;
            bodyHeight = $(window).height() - (headerHeight + footerHeight);
            console.log(headerHeight, bodyHeight, footerHeight, $(window).height());
            $('#sidebar').height(bodyHeight);
        });
    </script>
</body>

</html>