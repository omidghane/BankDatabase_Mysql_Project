import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.Scanner;

public class Logic {
    String username;
    String password;

    Scanner s = new Scanner(System.in);
    Database_connection d;

    public Logic(Database_connection d){
        this.d = d;
    }

    public String register(){
        System.out.print("username: ");
        String username = s.next();
        System.out.print("name: ");
        String name = s.next();
        System.out.print("lastname: ");
        String lastname = s.next();
        System.out.print("password: ");
        String pass = s.next();
        System.out.print("nationalID: ");
        int ID = s.nextInt();
        System.out.print("birthday(____-__-__): ");
        String birth = s.next();
        System.out.print("type(client,employee): ");
        String type = s.next();
        System.out.print("interest_rate: ");
        int interest = s.nextInt();

        return d.register(username,name,lastname,pass,ID,birth,type,interest);
    }

    public String login(){
        System.out.print("username: ");
        String username = s.next();
        System.out.print("password: ");
        String pass = s.next();

        return d.login(username, pass);
    }

    public void deposit(){
        System.out.println("amount: ");
        int amount = s.nextInt();

        d.deposit(amount);
    }

    public void withdraw(){
        System.out.print("amount: ");
        int amount = s.nextInt();

        d.withdraw(amount);
    }

    public void transfer(){
        System.out.print("amount: ");
        int amount = s.nextInt();
        System.out.print("destination account: ");
        BigDecimal destination = s.nextBigDecimal();


        d.transfer(amount, destination);
    }

    public void interest(){
        d.interest();
    }

    public int check_balance(){
        return d.check_balances();
    }

    public int check_recent_balance(){
        System.out.print("tell your account number: ");
        BigDecimal accNumber = s.nextBigDecimal();
        return d.check_recent_balance(accNumber);
    }

    public void update_balances(){
        d.update_balance();
    }

}
