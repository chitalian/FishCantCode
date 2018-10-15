
// CS 2510, Assignment 3

import tester.*;

// to represent a list of Strings
interface ILoString {
  // combine all Strings in this list into one
  String combine();

  // sorts a list of strings in alphabetical order
  ILoString sort();

  // Finds the smallest element (by alphabetical order) in an ILoString
  // uses an accumulator to keep track of the smallest element
  String findMinimumAcc(String acc);

  // Finds the smallest element (by alphabetical order) in an ILoString
  String findMinimum();

  // Removes the first occurrence of item in an ILoString
  ILoString removeFirstOccurrence(String item);

  // checks is sorted with an accumulator
  boolean isSortedAcc(String item);

  // determines whether this list is sorted in alphabetical order, in a
  // case-insensitive way.
  boolean isSorted();

  // that takes this list of Strings and a given list of Strings, and produces
  // a list where the first, third, fifth... elements are from this list, and the
  // second, fourth, sixth... elements are from the given list. Any “leftover”
  // elements (when one list is longer than the other) should just be left at
  // the end.
  ILoString interleave(ILoString second);

  // produces a sorted list of Strings that contains all items in both original
  // lists, including duplicates
  ILoString merge(ILoString second);

  // produces a new list of Strings containing the same elements as this
  // list of Strings, but in reverse order.
  ILoString reverse();

  // Appends item to the end of a list
  ILoString appendItem(String item);

  // determines if this list contains pairs of identical strings,
  // that is, the first and second strings are the same, the third
  // and fourth are the same, the fifth and sixth are the same, etc.
  boolean isDoubledList();

  // Determines isDoubleList using an Accumulator
  boolean isDoubledListAcc(String item);

  // Determines if this is a palindrome
  boolean isPalindromeList();
}

// to represent an empty list of Strings
class MtLoString implements ILoString {
  MtLoString() {
  }

  /*
   * TEMPLATE
   * FIELDS:
   * ... this.first ... -- String
   * ... this.rest ... -- ILoString
   * 
   * METHODS
   * ... this.combine() ... -- String
   * ... this.sort() ... -- ILoString
   * ... this.findMinimumAcc(String acc) ... -- String
   * ... this.findMinimum() ... -- String
   * ... this.removeFirstOccurrence(String item) ... -- ILoString
   * ... this.isSorted() ... -- boolean
   * ... this.interleave(ILoString second) ... -- ILoString
   * ... this.merge(ILoString second) ... -- ILoString
   * ... this.reverse() ... -- ILoString
   * ... this.appendItem(String item) ... -- ILoString
   * ... this.isDoubledList() ... -- boolean
   * ... this.isPalindromeList() ... --boolean
   */

  // combine all Strings in this list into one
  public String combine() {
    return "";
  }

  public ILoString sort() {
    return this;
  }

  public String findMinimumAcc(String acc) {
    return acc;
  }

  public String findMinimum() {
    return "";
  }

  public ILoString removeFirstOccurrence(String item) {
    return this;
  }

  public boolean isSorted() {
    return true;
  }

  public ILoString interleave(ILoString second) {
    return second;
  }

  public ILoString merge(ILoString second) {
    return second.sort();
  }

  public ILoString reverse() {
    return this;
  }

  public ILoString appendItem(String item) {
    return new ConsLoString(item, this);
  }

  public boolean isDoubledList() {
    return true;
  }

  public boolean isDoubledListAcc(String item) {
    return false;
  }

  public boolean isPalindromeList() {
    return true;
  }

  public boolean isSortedAcc(String item) {
    return true;
  }

}

// to represent a nonempty list of Strings
class ConsLoString implements ILoString {
  String first;
  ILoString rest;

  ConsLoString(String first, ILoString rest) {
    this.first = first;
    this.rest = rest;
  }

  /*
   * TEMPLATE
   * FIELDS:
   * ... this.first ... -- String
   * ... this.rest ... -- ILoString
   * 
   * METHODS
   * ... this.combine() ... -- String
   * ... this.sort() ... -- ILoString
   * ... this.findMinimumAcc(String acc) ... -- String
   * ... this.findMinimum() ... -- String
   * ... this.removeFirstOccurrence(String item) ... -- ILoString
   * ... this.isSorted() ... -- boolean
   * ... this.interleave(ILoString second) ... -- ILoString
   * ... this.merge(ILoString second) ... -- ILoString
   * ... this.reverse() ... -- ILoString
   * ... this.appendItem(String item) ... -- ILoString
   * ... this.isDoubledList() ... -- boolean
   * ... this.isDoubledListAcc() ... -- boolean
   * ... this.isPalindromeList() ... -- boolean
   * 
   * METHODS FOR FIELDS
   * ... this.first.concat(String) ... -- String
   * ... this.first.compareTo(String) ... -- int
   * ... this.rest.combine() ... -- String
   * ... this.rest.sort() ... -- ILoString
   * ... this.rest.findMinimumAcc(String acc) ... String
   * ... this.rest.findMinimum() ... String
   * ... this.rest.removeFirstOccurrence(String item) ... -- ILoString
   * ... this.rest.isSorted() ... -- boolean
   * ... this.rest.interleave(ILoString second) ... -- ILoString
   * ... this.rest.merge(ILoString second) ... -- ILoString
   * ... this.rest.reverse() ... -- ILoString
   * ... this.rest.appendItem(String item) ... -- ILoString
   * ... this.rest.isDoubledList() ... -- boolean
   * ... this.rest.isDoubledListAcc() ... -- boolean
   * ... this.rest.isPalindromeList() ... -- boolean
   * 
   */

  // combine all Strings in this list into one
  public String combine() {
    return this.first.concat(this.rest.combine());
  }

  public ILoString sort() {
    return new ConsLoString(this.findMinimum(),
        this.removeFirstOccurrence(this.findMinimum()).sort());
  }

  // Removes the first occurrence of item in an ILoString
  public ILoString removeFirstOccurrence(String item) {
    if (this.first.equals(item)) {
      return this.rest;
    } else {
      return new ConsLoString(first, rest.removeFirstOccurrence(item));
    }
  }

  public String findMinimumAcc(String acc) {
    if (acc.compareToIgnoreCase(first) >= 0) {
      return rest.findMinimumAcc(first);
    } else {
      return rest.findMinimumAcc(acc);
    }
  }

  public String findMinimum() {
    return this.rest.findMinimumAcc(first);
  }

  public boolean isSortedAcc(String item) {
    return (item.compareToIgnoreCase(first) <= 0) &&
        this.rest.isSortedAcc(this.first);
  }

  public boolean isSorted() {
    return isSortedAcc(first);
  }

  public ILoString interleave(ILoString second) {
    return new ConsLoString(this.first, second.interleave(this.rest));
  }

  public ILoString merge(ILoString second) {
    return this.interleave(second).sort();
  }

  public ILoString reverse() {
    return this.rest.reverse().appendItem(this.first);
  }

  public ILoString appendItem(String item) {
    return new ConsLoString(this.first, this.rest.appendItem(item));
  }

  public boolean isDoubledListAcc(String item) {
    if (item.equals(this.first)) {
      return !(this.rest.isDoubledListAcc(this.first)) &&
          this.rest.isDoubledList();
    } else {
      return false;
    }
  }

  public boolean isDoubledList() {
    return this.rest.isDoubledListAcc(this.first);
  }

  public boolean isPalindromeList() {
    return this.reverse().combine().equals(this.combine());
  }

}

// to represent examples for lists of strings
class ExamplesStrings {

  ILoString mary = new ConsLoString("Mary ",
      new ConsLoString("had ",
          new ConsLoString("a ",
              new ConsLoString("little ",
                  new ConsLoString("lamb.", new MtLoString())))));

  ILoString abc = new ConsLoString("a",
      new ConsLoString("b",
          new ConsLoString("c",
              new ConsLoString("d",
                  new ConsLoString("e", new MtLoString())))));

  ILoString cab = new ConsLoString("c",
      new ConsLoString("a",
          new ConsLoString("b",
              new ConsLoString("d",
                  new ConsLoString("e", new MtLoString())))));

  // test the method combine for the lists of Strings
  boolean testCombine(Tester t) {
    return t.checkExpect(this.mary.combine(), "Mary had a little lamb.");
  }

  // test the method sort for the lists of Strings
  boolean testSort(Tester t) {
    return t.checkExpect(this.cab.sort(), this.abc) &&
        t.checkExpect(this.abc.sort(), this.abc) &&
        t.checkExpect(this.mary.sort(), new ConsLoString("a ",
            new ConsLoString("had ",
                new ConsLoString("lamb.",
                    new ConsLoString("little ",
                        new ConsLoString("Mary ", new MtLoString()))))));
  }

  // test the method findMinimum for the lists of Strings
  boolean testFindMin(Tester t) {
    return t.checkExpect(this.cab.findMinimum(),
        "a")
        &&
        t.checkExpect(this.abc.findMinimum(), "a") &&
        t.checkExpect(this.mary.findMinimum(), "a ");
  }

  // Test the remove first element function
  boolean testRemoveFirst(Tester t) {
    return t.checkExpect(this.cab.removeFirstOccurrence("a"),
        new ConsLoString("c",
            new ConsLoString("b",
                new ConsLoString("d",
                    new ConsLoString("e", new MtLoString())))))
        &&
        t.checkExpect(this.abc.removeFirstOccurrence("a"),
            new ConsLoString("b",
                new ConsLoString("c",
                    new ConsLoString("d",
                        new ConsLoString("e", new MtLoString())))))
        &&
        t.checkExpect(this.mary.removeFirstOccurrence("little "),
            new ConsLoString("Mary ",
                new ConsLoString("had ",
                    new ConsLoString("a ",
                        new ConsLoString("lamb.", new MtLoString())))));
  }

  // Tests for isSorted Function
  boolean testIsSorted(Tester t) {
    return t.checkExpect(this.abc.isSorted(), true) &&
        t.checkExpect(this.cab.isSorted(), false) &&
        t.checkExpect(this.mary.isSorted(), false) &&
        t.checkExpect((new MtLoString()).isSorted(), true) &&
        t.checkExpect(this.mary.sort().isSorted(), true);
  }

  // Tests for isSorted Function
  boolean testIsSortedAcc(Tester t) {
    return t.checkExpect(this.abc.isSortedAcc("a"), true) &&
        t.checkExpect(this.cab.isSortedAcc("a"), false) &&
        t.checkExpect(this.mary.isSortedAcc("a"), false) &&
        t.checkExpect((new MtLoString()).isSortedAcc("a"), true) &&
        t.checkExpect(this.mary.sort().isSortedAcc("a "), true);
  }

  // Tests for interLeave Function
  boolean testInterLeave(Tester t) {
    return t.checkExpect((new MtLoString()).interleave(new MtLoString()), new MtLoString()) &&
        t.checkExpect(this.mary.interleave(new MtLoString()), this.mary) &&
        t.checkExpect((new MtLoString()).interleave(this.mary), this.mary) &&
        t.checkExpect(
            this.mary.interleave(
                new ConsLoString("one",
                    new ConsLoString("two", new MtLoString()))),
            new ConsLoString("Mary ",
                new ConsLoString("one",
                    new ConsLoString("had ",
                        new ConsLoString("two",
                            new ConsLoString("a ",
                                new ConsLoString("little ",
                                    new ConsLoString("lamb.", new MtLoString()))))))))
        &&
        t.checkExpect(this.abc.interleave(this.cab),
            new ConsLoString("a",
                new ConsLoString("c",
                    new ConsLoString("b",
                        new ConsLoString("a",
                            new ConsLoString("c",
                                new ConsLoString("b",
                                    new ConsLoString("d",
                                        new ConsLoString("d",
                                            new ConsLoString("e",
                                                new ConsLoString("e",
                                                    new MtLoString())))))))))));
  }

  // Tests for merge Function
  boolean testMerge(Tester t) {
    return t.checkExpect(this.abc.merge(new MtLoString()), this.abc) &&
        t.checkExpect(this.cab.merge(new MtLoString()), this.abc) &&
        t.checkExpect((new MtLoString()).merge(this.abc), this.abc) &&
        t.checkExpect(this.mary.merge(
            new ConsLoString("one",
                new ConsLoString("two", new MtLoString()))),
            new ConsLoString("a ",
                new ConsLoString("had ",
                    new ConsLoString("lamb.",
                        new ConsLoString("little ",
                            new ConsLoString("Mary ",
                                new ConsLoString("one",
                                    new ConsLoString("two", new MtLoString()))))))));
  }

  // Test method for reversing a list of strings
  boolean testReverse(Tester t) {
    return t.checkExpect((new MtLoString()).reverse(), new MtLoString()) &&
        t.checkExpect(this.abc.reverse(), new ConsLoString("e",
            new ConsLoString("d",
                new ConsLoString("c",
                    new ConsLoString("b",
                        new ConsLoString("a",
                            new MtLoString()))))))
        &&
        t.checkExpect(this.mary.reverse(),
            new ConsLoString("lamb.",
                new ConsLoString("little ",
                    new ConsLoString("a ",
                        new ConsLoString("had ",
                            new ConsLoString("Mary ",
                                new MtLoString()))))));
  }

  // Test Append
  boolean testAppendItem(Tester t) {
    return t.checkExpect(
        (new MtLoString()).appendItem("Arisa"),
        new ConsLoString("Arisa",
            new MtLoString()))
        &&
        t.checkExpect(this.abc.appendItem("f"),
            new ConsLoString("a",
                new ConsLoString("b",
                    new ConsLoString("c",
                        new ConsLoString("d",
                            new ConsLoString("e",
                                new ConsLoString("f", new MtLoString())))))));

  }

  // Test isDoubled Acc
  boolean testIsDoubledAcc(Tester t) {
    return t.checkExpect((new MtLoString()).isDoubledListAcc("a"), false) &&
        t.checkExpect(
            (new ConsLoString("a",
                new ConsLoString("b",
                    new ConsLoString("b",
                        new MtLoString()))).isDoubledListAcc("a")),
            true)
        &&
        t.checkExpect(this.abc.isDoubledListAcc("a"), false) &&
        t.checkExpect(this.mary.isDoubledListAcc("asdfgfb"), false) &&
        t.checkExpect(this.mary.interleave(this.mary).isDoubledListAcc("Mary "), false);
  }

  // Test isDoubled
  boolean testIsDoubled(Tester t) {
    return t.checkExpect((new MtLoString()).isDoubledList(), true) &&
        t.checkExpect(
            (new ConsLoString("a",
                new ConsLoString("a",
                    new ConsLoString("b",
                        new ConsLoString("b",
                            new MtLoString())))).isDoubledList()),
            true)
        &&
        t.checkExpect(this.abc.isDoubledList(), false) &&
        t.checkExpect(this.mary.isDoubledList(), false) &&
        t.checkExpect(this.mary.interleave(this.mary).isDoubledList(), true);
  }

  // Test isPalindromeList
  boolean testIsPalindrome(Tester t) {
    return t.checkExpect((new MtLoString()).isPalindromeList(), true) &&
        t.checkExpect(
            (new ConsLoString("a",
                new ConsLoString("b",
                    new ConsLoString("a",
                        new MtLoString()))).isPalindromeList()),
            true)
        &&
        t.checkExpect(this.abc.isPalindromeList(), false) &&
        t.checkExpect(this.mary.isPalindromeList(), false) &&
        t.checkExpect(
            new ConsLoString("Mary ",
                new ConsLoString("had ",
                    new ConsLoString("a ",
                        new ConsLoString("little ",
                            new ConsLoString("lamb.",
                                new ConsLoString("little ",
                                    new ConsLoString("a ",
                                        new ConsLoString("had ",
                                            new ConsLoString("Mary ",
                                                new MtLoString()))))))))).isPalindromeList(),
            true)
        &&
        t.checkExpect(
            new ConsLoString("Mary ",
                new ConsLoString("had ",
                    new ConsLoString("a ",
                        new ConsLoString("little ",
                            new ConsLoString("lamb.",
                                new ConsLoString("lamb.",
                                    new ConsLoString("little ",
                                        new ConsLoString("a ",
                                            new ConsLoString("had ",
                                                new ConsLoString("Mary ",
                                                    new MtLoString())))))))))).isPalindromeList(),
            true);

  }
}
