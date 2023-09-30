package custom;
import java.text.SimpleDateFormat;
import java.util.Date;
public class DateProvider{  
    static String strDate = null;
    public static String getDate(){
        Date date = new Date();  
        SimpleDateFormat formatter = new SimpleDateFormat("YYYY-MM-DD HH:mm:ss");  
        strDate= formatter.format(date); 
    return strDate;
    }
} 
