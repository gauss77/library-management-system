<nav class="navbar navbar-dark bg-dark justify-content-between">
        <a class="navbar-brand">Library Management</a>
        <div class="btn-group">
  <button type="button" class="btn btn-sm btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
     <img class="rounded-circle mr-2" width="32" height="32"
                    src="https://ui-avatars.com/api/?name=<%= session.getAttribute("username")%>&color=7F9CF5&background=EBF4FF"
                    alt="admin"><span><%= role.substring(0, 1).toUpperCase() + role.substring(1) %></span>
  </button>
  <div class="dropdown-menu dropdown-menu-right">
      <a href="logout.jsp" class="dropdown-item btn-danger" href="#">log out</a>
  
  </div>
    </div> 
 </nav>