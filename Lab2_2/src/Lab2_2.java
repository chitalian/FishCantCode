// to represent a pet owner
class Person {
    String name;
    IPet pet;
    int age;
 
    Person(String name, IPet pet, int age) {
        this.name = name;
        this.pet = pet;
        this.age = age;
    }
    /*
    TEMPLATE:
    ---------
    Fields:
    ... this.name ... - String
    ... this.pet ... IPet
    ... this.age ... int
    Methods:
    ... this.isOlder(Person) ... boolean
    ... this.sameNamePet(String) ... boolean
    Methods of Fields:
    ... this.pet.petsName() ... String
    */

    
    
    // is this Person older than the given Person?
    boolean isOlder(Person other) {
      return (this.age > other.age);
    }
    // Does the owner have the same name as the pet
    boolean sameNamePet() {
      return this.name.equals(this.pet.petsName());    
    }
}
// to represent a pet
interface IPet { 
  // What is the name of the pet
  String petsName();
}
 
// to represent a pet cat
class Cat implements IPet {
    String name;
    String kind;
    boolean longhaired;
 
    Cat(String name, String kind, boolean longhaired) {
        this.name = name;
        this.kind = kind;
        this.longhaired = longhaired;
    }
    
    public String petsName() {
      return this.name;
    }
    
}
 
// to represent a pet dog
class Dog implements IPet {
    String name;
    String kind;
    boolean male;
 
    Dog(String name, String kind, boolean male) {
        this.name = name;
        this.kind = kind;
        this.male = male;
    }
    
    public String petsName() {
      return this.name;
    }
}

class ExamplesPet{
  Person arisa = new Person("Arisa", new Dog("Moko","Palmaranian", true), 20);
  Person justin = new Person("Justin", new Dog("Shit-zu","Toby", true), 21);
  Person frank = new Person("Frank", new Cat("Puffle","bald-cat", false),92);
  Person jessie = new Person("Jessica", new Cat("Frankie","tiny-cat", true),22);
  
  
  
}