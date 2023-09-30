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
            $('#sidebar').height(bodyHeight);
        });
    </script>