
// Represents a bank account
public abstract class Account {

    int accountNum;  // Must be unique
    int balance;     // Must remain above zero (others Accts have more restrictions)
    String name;     // Name on the account

    public Account(int accountNum, int balance, String name){
        this.accountNum = accountNum;
        this.balance = balance;
        this.name = name;
    }
    
    // produc/Users/JustinTorre/Documents/School/Northeastern/Semester 4/Fundies2/Lab5/Banking/Checking.javae the amount available for withdrawal from this account
    public abstract int amtAvailable();
    
    public abstract boolean same(Account that);
    
    boolean sameChecking(Checking that) {
      return false;
    }
    boolean sameSavings(Savings that) {
      return false;
    }
}
