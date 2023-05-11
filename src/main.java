import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;

public class main {

    public static void main(String[] args){
        Database_connection d = null;
        try {
            d = new Database_connection();
        }catch (Exception e){
            e.printStackTrace();
        }

        UserInterface u = new UserInterface(d);

        u.first_page();

    }

}
