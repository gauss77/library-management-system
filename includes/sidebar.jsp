<%
URL url = new URL(request.getRequestURL().toString());  
%>    
    <ul class="list-group">
        <a href="./index.jsp">
            <%if(url.getFile().contains("index.jsp")){%>
            <li class="list-group-item sidebar-items border-left-6" style="background:#2c2e30;font-size:1.1rem">Dashboard</li>
            <%} else{%>
            <li class="list-group-item sidebar-items" style="background: #3c4045;">Dashboard</li>
            <%}%>
        </a>

        <a href="./add-student.jsp">
            <%if(url.getFile().contains("add-student.jsp")){%>
            <li class="list-group-item sidebar-items border-left-6" style="background:#2c2e30;font-size:1.1rem">Add Student</li>
            <%} else{%>
            <li class="list-group-item sidebar-items" style="background: #3c4045;">Add Student</li>
            <%}%>
        </a>
        <a href="./search-student.jsp">
            <%if(url.getFile().contains("search-student.jsp")){%>
            <li class="list-group-item sidebar-items border-left-6" style="background:#2c2e30;font-size:1.1rem">Search Student</li>
            <%} else{%>
            <li class="list-group-item sidebar-items" style="background: #3c4045;">Search Student</li>
            <%}%>
        </a>
        <a href="./books.jsp">
             <%if(url.getFile().contains("books.jsp")){%>
            <li class="list-group-item sidebar-items border-left-6" style="background: #2c2e30;font-size:1.1rem">Books</li>
            <%} else{%>
            <li class="list-group-item sidebar-items" style="background: #3c4045;">Books</li>
            <%}%>
        </a>
        <a href="./department.jsp">
            <%if(url.getFile().contains("department.jsp")){%>
            <li class="list-group-item sidebar-items border-left-6" style="background: #2c2e30;font-size:1.1rem">Departments</li>
            <%} else{%>
            <li class="list-group-item sidebar-items" style="background: #3c4045;">Departments</li>
            <%}%>
        </a>
        <a href="./subject.jsp">
            <%if(url.getFile().contains("subject.jsp")){%>
            <li class="list-group-item sidebar-items border-left-6" style="background: #2c2e30;font-size:1.1rem">Subjects</li>
            <%} else{%>
            <li class="list-group-item sidebar-items" style="background: #3c4045;">Subjects</li>
            <%}%>
        </a>
    </ul>