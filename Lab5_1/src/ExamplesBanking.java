import tester.*;

// Bank Account Examples and Tests
public class ExamplesBanking {
	
    public ExamplesBanking(){}
    
    Account check1 = new Checking(1, 100, "First Checking Account", 20);
    Account check2 = new Checking(2, 2000, "Second Savings Account",100);
    Account savings1 = new Savings(4, 200, "First Savings Account", 2.5);
    Account savings2 = new Savings(5, 100000, "First Savings Account", .023);  
      
    
    // Tests the exceptions we expect to be thrown when
    //   performing an "illegal" action.
    public boolean testAmtAvailable(Tester t){
    	  return
      t.checkExpect(this.check1.amtAvailable(), 80) &&
      t.checkExpect(this.savings1.amtAvailable(), 200) &&
      t.checkExpect(this.check2.amtAvailable(), 1900) &&
      t.checkExpect(this.savings2.amtAvailable(), 100000);
    	  
    }
}
