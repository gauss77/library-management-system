<%@ page import="java.text.SimpleDateFormat,java.util.Date"%>
<%!
public String assignBookMailInfo(String book_name,String barcode,String isbn,String edition,String author){
   String formatted_message = "<div style=\"width:100%\"><div style=\"height: 5rem;padding: 0.5rem;border-bottom: 1px solid #5f5f5f;display:flex\"><div> <img width=\"72\" height=\"72\" src=\"http://www.gtbpi.in/img/logo-gtpbi-3.png\" alt=\"GTBPI\"></div><div style=\"padding: 13px 12px;\"><h2 style=\"margin-left:0.5rem;;margin:0;\">GTBPI</h2><p style=\"margin: 0;color: #474747;font-size: 0.9rem\">Library</p></div></div><div style=\" padding: 1rem;\"><h2 style=\"color:#500050\">You have assigned new book</h2><div style=\"font-weight: 600\"><p>Book name: "+ book_name +"</p><p>Author: "+ author +"</p><p>Barcode: "+ barcode +"</p><p>ISBN: "+ isbn +"</p><p>Edition: "+ edition +"</p></div></div><div style=\"height: 4rem;padding: 1rem;border-top: 1px solid #5f5f5f;\"><p>GTBPI</p><p>Thank you</p></div></div>";
   return formatted_message;
}
public String submitBookMailInfo(String book_name,String barcode,String isbn,String edition,String author){
   String formatted_message = "<div style=\"width:100%\"><div style=\"height: 5rem;padding: 0.5rem;border-bottom: 1px solid #5f5f5f;display:flex\"><div> <img width=\"72\" height=\"72\" src=\"http://www.gtbpi.in/img/logo-gtpbi-3.png\" alt=\"GTBPI\"></div><div style=\"padding: 13px 12px;\"><h2 style=\"margin-left:0.5rem;;margin:0;\">GTBPI</h2><p style=\"margin: 0;color: #474747;font-size: 0.9rem\">Library</p></div></div><div style=\" padding: 1rem;\"><h2 style=\"color:#500050\">You have submiited book</h2><div style=\"font-weight: 600\"><p>Book name: "+ book_name +"</p><p>Author: "+ author +"</p><p>Barcode: "+ barcode +"</p><p>ISBN: "+ isbn +"</p><p>Edition: "+ edition +"</p></div></div><div style=\"height: 4rem;padding: 1rem;border-top: 1px solid #5f5f5f;\"><p>GTBPI</p><p>Thank you</p></div></div>";
   return formatted_message;
}
public String bookReminderMailinfo(String book_name,String barcode,String isbn,String edition,String author,float price,String assigned_date,int assigned_days){
   String formatted_message = "<div style=\"width:100%\"><div style=\"height: 5rem;padding: 0.5rem;border-bottom: 1px solid #5f5f5f;display:flex\"><div> <img width=\"72\" height=\"72\" src=\"http://www.gtbpi.in/img/logo-gtpbi-3.png\" alt=\"GTBPI\"></div><div style=\"padding: 13px 12px;\"><h2 style=\"margin-left:0.5rem;;margin:0;\">GTBPI</h2><p style=\"margin: 0;color: #474747;font-size: 0.9rem\">Library</p></div></div><div style=\" padding: 1rem;\"><h2 style=\"color:#500050\">This is reminder for submit book</h2><div style=\"font-weight: 600\"><p>Book name: "+ book_name +"</p><p>Author: "+ author +"</p><p>Barcode: "+ barcode +"</p><p>ISBN: "+ isbn +"</p><p>Edition: "+ edition +"</p><p>Price: "+ price +"&#8377; </p><p>Assigned Date: "+ assigned_date +"</p></div><p>It has been "+ assigned_days +" days. You didn't return this book. If you not return then it cause you to pay fine or if you lost this book then please pay book amount to Labrarian.</p></div><div style=\"height: 4rem;padding: 1rem;border-top: 1px solid #5f5f5f;\"><p>GTBPI</p><p>Thank you</p></div></div>";
   return formatted_message;
}

public String capitalizeString(String string){
    if (string == null || string.trim().isEmpty()) {
            return string;
        }
        char c[] = string.trim().toLowerCase().toCharArray();
        c[0] = Character.toUpperCase(c[0]);
    
        return new String(c);
    
}
public String currentDateTime(){
    String strDate = null;
    Date date = new Date();  
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
    strDate= formatter.format(date); 
    return strDate;
}
%>