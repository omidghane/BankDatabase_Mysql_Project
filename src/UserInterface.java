import java.util.Scanner;

public class UserInterface {
    Scanner in = new Scanner(System.in);
    Database_connection d;
    Logic l;

    public UserInterface(Database_connection d){
        this.d = d;
        l = new Logic(d);
    }

    public void first_page()
    {

        while(true) {
            System.out.println("1)register 2)login");
            int q = in.nextInt();
            if (q == 1) {
                String res = l.register();
                if(res.equals("allowed")){
                    System.out.println("registered welcome");
                }
                else {System.out.println("not successsful"); continue;}
            } else if (q == 2) {
                String res = l.login();
                if(res.equals("found")){
                    System.out.println("you are logged in");
                }
                else {System.out.println("not found"); continue;}
            }else{
                continue;
            }
            secondPage();
            break;
        }

        l.update_balances();
    }

    public void secondPage(){
        while(true) {
            System.out.println("1)deposit 2)withdraw 3)transfer 4)interest_payment 5)check_balance 6)check_recent_balance");
            int q = in.nextInt();
            if (q == 1) {
                l.deposit();
            } else if (q == 2) {
                l.withdraw();
            } else if (q == 3) {
                l.transfer();
            }
            else if (q == 4) {
                l.interest();
            }
            else if (q == 5) {
                int amount = l.check_balance();
                System.out.println("your balance: " + amount);
            }
            else if(q == 6){
                int amount = l.check_recent_balance();
                System.out.println("your recent_balance: " + amount);
            }

            System.out.print("another if yes enter (1) ");
            if (in.nextInt() == 1) {
                continue;
            }
            break;
        }
    }
}
