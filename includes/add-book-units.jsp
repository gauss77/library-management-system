<%
 String book_barcode = request.getParameter("book_barcode");
 String book_edition = request.getParameter("book_edition");
 String book_price = request.getParameter("book_price");
 out.print(book_barcode + book_edition +  book_price);
%>