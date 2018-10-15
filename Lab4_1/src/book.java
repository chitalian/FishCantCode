import tester.*;

interface IBook {
  // Produces the number of days this book is overdue. 
  int daysOverdue(int today);
  
  // Informs us whether the book is overdue on the given day.
  boolean isOverdue(int today);
  
  // Computes the fine for this book
  double computeFine(int today);
}

abstract class ABook implements IBook {
  String title;
  int dayTaken;
  double overdueFee = .20;
  
  int daysOfTwoWeeks = 14;
  ABook(String title, int dayTaken) {
    this.title = title;
    this.dayTaken = dayTaken;
  }

  public int daysOverdue(int today) {
    return this.dayTaken + daysOfTwoWeeks - today;
  }
  
  public boolean isOverdue(int today) {
    return (this.daysOverdue(today) > 0);
  }
  
  public double computeFine(int today) {
    return (this.isOverdue(today) ? this.daysOverdue(today) * overdueFee : 0);
  }
  
  

}

class Book extends ABook {
  String author;
  double overdueFee = .10;
  Book(String title, String author, int dayTaken) {
    super(title, dayTaken);
    this.author = author;
  }
  @Override
  public double computeFine(int today) {
    return (this.isOverdue(today) ? this.daysOverdue(today) * overdueFee : 0);
  }
  

}

class RefBook extends ABook {
  RefBook(String title, int dayTaken) {
    super(title, dayTaken);
  }
  @Override
  public int daysOverdue(int today) {
    return this.dayTaken + 2 - today;
  }
}

class AudioBook extends ABook {
  String author;

  AudioBook(String title, String author, int dayTaken) {
    super(title, dayTaken);
    this.author = author;
  }

}

class ExmaplesBooks {
  
  
  boolean tester(Tester t) {
    return t.checkExpect(2, 3);
  }
}
