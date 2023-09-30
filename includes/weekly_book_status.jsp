<%@ page import="java.util.ArrayList,java.text.SimpleDateFormat,java.util.Calendar"%>
<%
ArrayList<Integer> weekly_assigned_books = new ArrayList<Integer>();
ArrayList<Integer> weekly_submitted_books = new ArrayList<Integer>();
ps = conn.prepareStatement("select COUNT(assigned_date) as count from assigned_books where to_char(to_date(assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_assigned_books.add(rs.getInt("count"));
ps = conn.prepareStatement("select COUNT(assigned_date) as count from assigned_books where to_char(to_date(assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date - 1 ,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_assigned_books.add(rs.getInt("count"));
ps = conn.prepareStatement("select COUNT(assigned_date) as count from assigned_books where to_char(to_date(assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date - 2 ,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_assigned_books.add(rs.getInt("count"));
ps = conn.prepareStatement("select COUNT(assigned_date) as count from assigned_books where to_char(to_date(assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date - 3 ,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_assigned_books.add(rs.getInt("count"));
ps = conn.prepareStatement("select COUNT(assigned_date) as count from assigned_books where to_char(to_date(assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date - 4 ,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_assigned_books.add(rs.getInt("count"));
ps = conn.prepareStatement("select COUNT(assigned_date) as count from assigned_books where to_char(to_date(assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date - 5 ,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_assigned_books.add(rs.getInt("count"));
ps = conn.prepareStatement("select COUNT(assigned_date) as count from assigned_books where to_char(to_date(assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date - 6 ,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_assigned_books.add(rs.getInt("count"));





ps = conn.prepareStatement("select COUNT(assigned_date) as count from submitted_books where to_char(to_date(submitted_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_submitted_books.add(rs.getInt("count"));
ps = conn.prepareStatement("select COUNT(assigned_date) as count from submitted_books where to_char(to_date(submitted_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date - 1 ,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_submitted_books.add(rs.getInt("count"));
ps = conn.prepareStatement("select COUNT(assigned_date) as count from submitted_books where to_char(to_date(submitted_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date - 2 ,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_submitted_books.add(rs.getInt("count"));
ps = conn.prepareStatement("select COUNT(assigned_date) as count from submitted_books where to_char(to_date(submitted_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date - 3 ,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_submitted_books.add(rs.getInt("count"));
ps = conn.prepareStatement("select COUNT(assigned_date) as count from submitted_books where to_char(to_date(submitted_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date - 4 ,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_submitted_books.add(rs.getInt("count"));
ps = conn.prepareStatement("select COUNT(assigned_date) as count from submitted_books where to_char(to_date(submitted_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date - 5 ,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_submitted_books.add(rs.getInt("count"));
ps = conn.prepareStatement("select COUNT(assigned_date) as count from submitted_books where to_char(to_date(submitted_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') = to_char(current_date - 6 ,'YYYY-MM-DD')");
rs = ps.executeQuery();
rs.next();
weekly_submitted_books.add(rs.getInt("count"));
%>



<%-- <%
ArrayList<Integer> weekly_books_status = new ArrayList<Integer>();
ArrayList<String> date1 = new ArrayList<String>(); 
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd ");
Calendar cal = Calendar.getInstance();
cal.add(Calendar.DAY_OF_YEAR, 1);
for(int i = 0; i< 7; i++){
    cal.add(Calendar.DAY_OF_YEAR, -1);
    date1.add(sdf.format(cal.getTime()));
}
out.println(date1);
ps = conn.prepareStatement("select to_char(to_date(assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') as assigned_date , COUNT(assigned_date) as count from assigned_books where to_char(to_date(assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') > to_char(current_date - 7,'YYYY-MM-DD') and to_char(to_date(assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD') <= to_char(current_date,'YYYY-MM-DD') GROUP BY to_char(to_date(assigned_date,'YYYY-MM-DD HH24:MI:SS'),'YYYY-MM-DD')");
rs = ps.executeQuery();
while(rs.next()){
 for(int j=0;j<date1.size();j++){
     out.print("["+rs.getString("assigned_date")+"]");
     if(date1.get(j) == rs.getString("assigned_date")){
         weekly_books_status.add(rs.getInt("count"));
     }
     else{
          weekly_books_status.add(0);
     }
 }
}
out.print(weekly_books_status);
%> --%>