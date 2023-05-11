import java.math.BigDecimal;
import java.math.BigInteger;
import java.sql.*;

public class Database_connection {
    String url = "jdbc:mysql://localhost:3307/Bankdb";
    String username = "omidghane";
    String password = "13812015Omid";
    Connection con = DriverManager.getConnection(url, username, password);

    public Database_connection() throws SQLException {
    }

    public String register(String username, String name, String lastname, String pass,
                         int nationalID, String birthDay, String type, double interestRate){
        try{
            // Prepare a statement to call the stored procedure
            CallableStatement stmt = con.prepareCall("{CALL register_user(?,?,?,?,?,?,?,?,?)}");

            // Set the input parameters
            stmt.setString(1, username);
            stmt.setString(2, name);
            stmt.setString(3, lastname);
            stmt.setString(4, pass);
            stmt.setInt(5, nationalID);
            stmt.setString(6, birthDay);
            stmt.setString(7, type);
            stmt.setDouble(8, interestRate);
            // Register the output parameter
            stmt.registerOutParameter(9, java.sql.Types.VARCHAR);

            // Execute the stored procedure
            stmt.execute();

            // Retrieve the output parameter
            String res = stmt.getString(9);

            // Close the statement
            stmt.close();

            // 'under13' , 'allowed'
            return res;
        }catch (Exception e){
            e.printStackTrace();
        }
        return "error";
    }

    public String login(String username, String pass){
        try {
            String res = "";

            CallableStatement stmt = con.prepareCall("{CALL login_user(?,?,?)}");
            stmt.setString(1, username);
            stmt.setString(2, pass);
            stmt.registerOutParameter(3, java.sql.Types.VARCHAR);
            stmt.execute();
            res = stmt.getString(3);
//            System.out.println(res);

            stmt.close();

            // 'notFound' , 'found'
            return res;
        }catch(Exception e){
            e.printStackTrace();
        }
        return "error";
    }

    public void deposit(int amount){
        try {

//            // Check if the connection is valid
//            if (con.isValid(5)) { // Timeout in seconds
//                System.out.println("Connection is valid!");
//            } else {
//                System.out.println("Connection is not valid!");
//            }
            CallableStatement stmt = con.prepareCall("{CALL deposit(?)}");
            stmt.setInt(1, amount);
            stmt.execute();
            stmt.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public void withdraw(int amount){
        try {
            CallableStatement stmt = con.prepareCall("{CALL withdraw(?)}");
            stmt.setInt(1, amount);
            stmt.execute();
            stmt.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public void transfer(int amount, BigDecimal to){
        try {
            CallableStatement stmt = con.prepareCall("{CALL transfer(?,?)}");
            stmt.setInt(1, amount);
            stmt.setBigDecimal(2, to);
            stmt.execute();
            stmt.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public void interest(){
        try {
            CallableStatement stmt = con.prepareCall("{CALL interest_payment()}");
            stmt.execute();
            stmt.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public int check_balances(){
        try {
            CallableStatement stmt = con.prepareCall("{CALL check_balances(?)}");
            stmt.registerOutParameter(1, Types.INTEGER);
            stmt.execute();
            int res = stmt.getInt(1);
            stmt.close();

            return res;
        }catch(Exception e){
            e.printStackTrace();
        }
        return 0;
    }

    public int check_recent_balance(BigDecimal accNumber){
        try {
            CallableStatement stmt = con.prepareCall("{CALL update_balances_specific(?)}");
            stmt.setBigDecimal(1, accNumber);
            stmt.execute();
            stmt.close();
            stmt = con.prepareCall("{CALL check_balances(?)}");
            stmt.registerOutParameter(1, Types.INTEGER);
            stmt.execute();
            int res = stmt.getInt(1);
            stmt.close();

            return res;
        }catch(Exception e){
            e.printStackTrace();
        }
        return 0;
    }

    public void update_balance(){
        try {
            CallableStatement stmt = con.prepareCall("{CALL update_balances()}");
            stmt.execute();
            stmt.close();
        }catch(Exception e){
            e.printStackTrace();
        }
    }



}
