
public class CapitalizeString{
    public static String setString(String string) {

        if (string == null || string.trim().isEmpty()) {
            return string;
        }
        char c[] = string.trim().toLowerCase().toCharArray();
        c[0] = Character.toUpperCase(c[0]);
    
        return new String(c);
    }
}
