
// Represents a savings account
public class Savings extends Account{

    double interest; // The interest rate

    public Savings(int accountNum, int balance, String name, 
    		           double interest){
        super(accountNum, balance, name);
        this.interest = interest;
    }

    /* TEMPLATE:
     Fields:
     ... this.accountNum ...     -- int
     ... this.balance ...        -- int
     ... this.name ...           -- String
     ... this.interest ...       -- double
     
     Methods:
     ... this.amtAvailable() ...  -- int
     
     */
    
    // produce the amount available for withdrawal from this account
    public int amtAvailable(){
    	  return this.balance;
    }
    
    public boolean same(Account that) {
      return that.sameSavings(this);
    }
    
    public boolean sameSavings(Savings that) {
      return this.accountNum == that.accountNum &&
          this.balance == that.balance &&
          this.interest == that.interest &&
          this.name == that.name;
    }
}
