import tester.*;

interface IXMLFrag {
  // Which computes the length (number of characters)
  // of the content in an XML document
  int contentLength();

  // Determines if an XML document contains a Tag with the given name.
  boolean hasTag(String name);

  // Determines if an XML document contains an attribute with the given name.
  boolean hasAttribute(String name);

  // Determines if an XML document contains an attribute with the given name
  // within a given tag.
  boolean hasAttributeInTag(String tagName, String attName);

  // Converts XML to a String without tags and attributes.
  String renderAsString();

  // Updates all attributes with the given name to the given value.
  IXMLFrag updateAttribute(String attName, String value);
}

interface ILoXMLFrag {
  // Which computes the length (number of characters)
  // of the content in an XML document
  int contentLength();

  // Determines if an XML document contains a Tag with the given name.
  boolean hasTag(String name);

  // Determines if an XML document contains an attribute with the given name.
  boolean hasAttribute(String name);

  // Determines if an XML document contains an attribute with the given name
  // within a given tag.
  boolean hasAttributeInTag(String tagName, String attName);

  // Converts XML to a String without tags and attributes.
  String renderAsString();

  // Updates all attributes with the given name to the given value.
  ILoXMLFrag updateAttribute(String attName, String value);
}

class ConsLoXMLFrag implements ILoXMLFrag {
  IXMLFrag first;
  ILoXMLFrag rest;

  ConsLoXMLFrag(IXMLFrag first, ILoXMLFrag rest) {
    this.first = first;
    this.rest = rest;
  }
  /*
   * TEMPLATE:
   * ---------
   * Fields:
   * ... this.first ... IXMLFrag
   * ... this.rest ... ILoXMLFrag
   * Methods:
   * ... this.contentLength()... int
   * ... this.hasTag(String name) ... boolean
   * ... this.hasAttribute(String name) ... boolean
   * ... this.hasAttributeInTag(String tagName, String attName) ... boolean
   * ... this.renderAsString() ... String
   * ... this.updateAttribute(String attName, String value) ... ILoXMLFrag
   * Methods for Fields:
   * ... this.first.contentLength() ... int
   * ... this.first.hasTag(String name) ... boolean
   * ... this.first.hasAttribute() ... boolean
   * ... this.first.hasAttributeInTag() ... boolean
   * ... this.first.renderAsString() ... String
   * ... this.first.updateAttribute(String attName, String value) ... IXMLFrag
   * ... this.rest.contentLength() ... int
   * ... this.rest.hasTag(String name) ... boolean
   * ... this.rest.hasAttribute(String name) ... boolean
   * ... this.rest.hasAttributeInTag(String tagName, String attName) ... boolean
   * ... this.rest.renderAsString() ... String
   * ... this.rest.updateAttribute(String attName, String value) ... ILoXMLFrag
   */

  public int contentLength() {
    return this.first.contentLength() + this.rest.contentLength();
  }

  public boolean hasTag(String name) {
    return (this.first.hasTag(name) || this.rest.hasTag(name));
  }

  public boolean hasAttribute(String name) {
    return (this.first.hasAttribute(name)
        || this.rest.hasAttribute(name));
  }

  public boolean hasAttributeInTag(String tagName, String attName) {
    return (this.first.hasAttributeInTag(tagName, attName)
        || this.rest.hasAttributeInTag(tagName, attName));
  }

  public String renderAsString() {
    return this.first.renderAsString() + this.rest.renderAsString();
  }

  public ILoXMLFrag updateAttribute(String attName, String value) {
    return new ConsLoXMLFrag(this.first.updateAttribute(attName, value),
        this.rest.updateAttribute(attName, value));
  }
}

class MtLoXMLFrag implements ILoXMLFrag {
  /*
   * TEMPLATE:
   * ---------
   * Methods:
   * ... this.contentLength() ... int
   * ... this..hasTag() ... boolean
   * ... this.hasAttribute ... boolean
   * ... this.hasAttributeInTag ... boolean
   * ... this.renderAsString() ... String
   * ... this.updateAttribute(String attName, String value) ... ILoXMLFrag
   */
  public int contentLength() {
    return 0;
  }

  public boolean hasTag(String name) {
    return false;
  }

  public boolean hasAttribute(String name) {
    return false;
  }

  public boolean hasAttributeInTag(String tagName, String attName) {
    return false;
  }

  public String renderAsString() {
    return "";
  }

  public ILoXMLFrag updateAttribute(String attName, String value) {
    return this;
  }
}

class Plaintext implements IXMLFrag {
  String txt;

  Plaintext(String txt) {
    this.txt = txt;
  }

  /*
   * TEMPLATE:
   * ---------
   * Fields:
   * ... this.txt ... String
   * Methods:
   * ... this.contentLength() ... int
   * ... this.hasTag(String name) ... boolean
   * ... this.hasAttribute(String name) ... boolean
   * ... this.hasAttributeInTag(String tagName, String attName) ... boolean
   * ... this.renderAsString() ... String
   * ... this.updateAttribute(String attName, String value) ... IXMLFrag
   */
  public int contentLength() {
    return txt.length();
  }

  public boolean hasTag(String name) {
    return false;
  }

  public boolean hasAttribute(String name) {
    return false;
  }

  public boolean hasAttributeInTag(String tagName, String attName) {
    return false;
  }

  public String renderAsString() {
    return this.txt;
  }

  public IXMLFrag updateAttribute(String attName, String value) {
    return this;
  }
}

class Tagged implements IXMLFrag {
  Tag tag;
  ILoXMLFrag content;

  Tagged(Tag tag, ILoXMLFrag content) {
    this.tag = tag;
    this.content = content;
  }

  /*
   * TEMPLATE:
   * ---------
   * Fields:
   * ... this.tag ... Tag
   * ... this.content ... ILoXMLFrag
   * Methods:
   * ... this.contentLength() ... int
   * ... this.hasTag(String name) ... boolean
   * ... this.hasAttribute(String name) ... boolean
   * ... this.hasAttributeInTag(String tagName, String attName) ... boolean
   * ... this.renderAsString() ... String
   * ... this.updateAttribute(String attName, String value) ... IXMLFrag
   * Methods for Fields:
   * ... this.content.contentLength() ... int
   * ... this.content.hasTag(String name) ... boolean
   * ... this.tag.tagName() ... String
   * ... this.content.hasAttribute(String name) ... boolean
   * ... this.content.hasAttributeInTag(String tagName, String attName) ...
   * boolean
   * ... this.content.renderAsString() ... String
   * ... this.content.updateAttribute(String attName, String value) ... ILoXMLFrag
   * ... this.tag.updateAttribute(attName, value) ... Tag
   */
  public int contentLength() {
    return this.content.contentLength();
  }

  public boolean hasTag(String name) {
    return name.equals(this.tag.tagName());
  }

  public boolean hasAttribute(String name) {
    return (this.content.hasAttribute(name) ||
        this.tag.hasAttribute(name));
  }

  public boolean hasAttributeInTag(String tagName, String attName) {
    return ((tagName.equals(this.tag.tagName()))
        && (this.tag.hasAttribute(attName)))
        || this.content.hasAttributeInTag(tagName, attName);
  }

  public String renderAsString() {
    return this.content.renderAsString();
  }

  public IXMLFrag updateAttribute(String attName, String value) {
    return new Tagged(
        this.tag.updateAttribute(attName, value),
        this.content.updateAttribute(attName, value));
  }

}

class Tag {
  String name;
  ILoAtt atts;

  Tag(String name, ILoAtt atts) {
    this.name = name;
    this.atts = atts;
  }
  /*
   * TEMPLATE:
   * ---------
   * Fields:
   * ... this.name ... String
   * ... this.atts ... ILoAtt
   * Methods:
   * ... this.tagName() ... String
   * ... this.hasAttribute(String name) ... boolean
   * ... this.updateAttribute(String attName, String value) ... Tag
   * 
   * Methods for fields;
   * ... this.atts.updateAttribute(String attName, String value) ... ILoAtt
   */

  String tagName() {
    return this.name;
  }

  boolean hasAttribute(String name) {
    return this.atts.hasAttribute(name);
  }

  Tag updateAttribute(String attName, String value) {
    return new Tag(this.name, atts.updateAttribute(attName, value));
  }
}

class Att {
  String name;
  String value;

  Att(String name, String value) {
    this.name = name;
    this.value = value;
  }
  /*
   * TEMPLATE:
   * ---------
   * Fields:
   * ... this.name ... String
   * ... this.value ... String
   * Methods:
   * ... this.nameOfAtt() ... String
   * ... this.updateAttribute(String attName, String value) ... Att
   */

  String nameOfAtt() {
    return this.name;
  }

  Att updateAttribute(String attName, String value) {
    if (attName.equals(this.name)) {
      return new Att(this.name, value);
    } else {
      return this;
    }
  }
}

interface ILoAtt {
  // Determines if an XML document contains an attribute with the given name.
  boolean hasAttribute(String name);

  // Updates all attributes with the given name to the given value.
  ILoAtt updateAttribute(String attName, String value);
}

class ConsLoAtt implements ILoAtt {
  Att first;
  ILoAtt rest;

  ConsLoAtt(Att first, ILoAtt rest) {
    this.first = first;
    this.rest = rest;
  }
  /*
   * TEMPLATE:
   * ---------
   * Fields:
   * ... this.first ... Att
   * ... this.rest ... ILoAtt
   * Methods:
   * ... this.hasAttribute(String name) ... boolean
   * ... this.updateAttribute(String attName, String value) ... ILoAtt
   * Methods For Fields:
   * ... this.first.nameOfAtt() ... String
   * ... this.first.updateAttribute(String attName, String value) ... Att
   * ... this.rest.updateAttribute(String attName, String value) ... ILoAtt
   */

  public boolean hasAttribute(String name) {
    return (name.equals(this.first.nameOfAtt()) || this.rest.hasAttribute(name));
  }

  public ILoAtt updateAttribute(String attName, String value) {
    return new ConsLoAtt(this.first.updateAttribute(attName, value),
        this.rest.updateAttribute(attName, value));
  }

}

class MtLoAtt implements ILoAtt {
  /*
   * TEMPLATE:
   * ---------
   * Methods:
   * ... this.hasAttribute(String name) ... boolean
   * ... this.updateAttribute(String attName, String value) ... ILoAtt
   */

  public boolean hasAttribute(String name) {
    return false;
  }

  public ILoAtt updateAttribute(String attName, String value) {
    return this;
  }
}

class ExamplesXML {

  // I am XML!
  ConsLoXMLFrag xml1 = new ConsLoXMLFrag(
      new Plaintext("I am XML!"),
      new MtLoXMLFrag()); // XML1 DOC

  // I am <yell>XML</yell>!
  ConsLoXMLFrag xml2 = new ConsLoXMLFrag(
      new Plaintext("I am "),
      new ConsLoXMLFrag(
          new Tagged(
              new Tag(
                  "yell",
                  new MtLoAtt()),
              new ConsLoXMLFrag(
                  new Plaintext("XML"),
                  new MtLoXMLFrag())),
          new ConsLoXMLFrag(
              new Plaintext("!"),
              new MtLoXMLFrag()))); // XML2 DOC

  // I am <yell><italic>X</italic>ML</yell>!
  ConsLoXMLFrag xml3 = new ConsLoXMLFrag(new Plaintext("I am "),
      new ConsLoXMLFrag(
          new Tagged(
              new Tag(
                  "yell",
                  new MtLoAtt()),
              new ConsLoXMLFrag(
                  new Tagged(
                      new Tag(
                          "italic",
                          new MtLoAtt()),
                      new ConsLoXMLFrag(
                          new Plaintext("X"),
                          new MtLoXMLFrag())),
                  new ConsLoXMLFrag(
                      new Plaintext("ML"),
                      new MtLoXMLFrag()))),
          new ConsLoXMLFrag(
              new Plaintext("!"),
              new MtLoXMLFrag())));

  // I am <yell volume="30db"><italic>X</italic>ML</yell>!
  ConsLoXMLFrag xml4 = new ConsLoXMLFrag(new Plaintext("I am "),
      new ConsLoXMLFrag(
          new Tagged(
              new Tag(
                  "yell",
                  new ConsLoAtt(
                      new Att("volume", "30db"),
                      new MtLoAtt())),
              new ConsLoXMLFrag(
                  new Tagged(
                      new Tag(
                          "italic",
                          new MtLoAtt()),
                      new ConsLoXMLFrag(
                          new Plaintext("X"),
                          new MtLoXMLFrag())),
                  new ConsLoXMLFrag(
                      new Plaintext("ML"),
                      new MtLoXMLFrag()))),
          new ConsLoXMLFrag(
              new Plaintext("!"),
              new MtLoXMLFrag())));

  ConsLoXMLFrag xml4_2 = new ConsLoXMLFrag(new Plaintext("I am "),
      new ConsLoXMLFrag(
          new Tagged(
              new Tag(
                  "yell",
                  new ConsLoAtt(
                      new Att("volume", "dog"),
                      new MtLoAtt())),
              new ConsLoXMLFrag(
                  new Tagged(
                      new Tag(
                          "italic",
                          new MtLoAtt()),
                      new ConsLoXMLFrag(
                          new Plaintext("X"),
                          new MtLoXMLFrag())),
                  new ConsLoXMLFrag(
                      new Plaintext("ML"),
                      new MtLoXMLFrag()))),
          new ConsLoXMLFrag(
              new Plaintext("!"),
              new MtLoXMLFrag())));

  // I am <yell volume="30db" duration="5sec"><italic>X</italic>ML</yell>!
  ConsLoXMLFrag xml5 = new ConsLoXMLFrag(new Plaintext("I am "),
      new ConsLoXMLFrag(
          new Tagged(
              new Tag(
                  "yell",
                  new ConsLoAtt(
                      new Att("volume", "30db"),
                      new ConsLoAtt(
                          new Att("duration", "5sec"),
                          new MtLoAtt()))),
              new ConsLoXMLFrag(
                  new Tagged(
                      new Tag(
                          "italic",
                          new MtLoAtt()),
                      new ConsLoXMLFrag(
                          new Plaintext("X"),
                          new MtLoXMLFrag())),
                  new ConsLoXMLFrag(
                      new Plaintext("ML"),
                      new MtLoXMLFrag()))),
          new ConsLoXMLFrag(
              new Plaintext("!"),
              new MtLoXMLFrag())));
  // I am <yell volume="30db" duration="5sec"><italic>X</italic>ML</yell>!
  ConsLoXMLFrag xml5_2 = new ConsLoXMLFrag(new Plaintext("I am "),
      new ConsLoXMLFrag(
          new Tagged(
              new Tag(
                  "yell",
                  new ConsLoAtt(
                      new Att("volume", "50db"),
                      new ConsLoAtt(
                          new Att("duration", "5sec"),
                          new MtLoAtt()))),
              new ConsLoXMLFrag(
                  new Tagged(
                      new Tag(
                          "italic",
                          new MtLoAtt()),
                      new ConsLoXMLFrag(
                          new Plaintext("X"),
                          new MtLoXMLFrag())),
                  new ConsLoXMLFrag(
                      new Plaintext("ML"),
                      new MtLoXMLFrag()))),
          new ConsLoXMLFrag(
              new Plaintext("!"),
              new MtLoXMLFrag())));
  // I am <yell volume="30db" duration="5sec"><italic>X</italic>ML</yell>!
  ConsLoXMLFrag xml5_3 = new ConsLoXMLFrag(new Plaintext("I am "),
      new ConsLoXMLFrag(
          new Tagged(
              new Tag(
                  "yell",
                  new ConsLoAtt(
                      new Att("volume", "50db"),
                      new ConsLoAtt(
                          new Att("duration", "10sec"),
                          new MtLoAtt()))),
              new ConsLoXMLFrag(
                  new Tagged(
                      new Tag(
                          "italic",
                          new MtLoAtt()),
                      new ConsLoXMLFrag(
                          new Plaintext("X"),
                          new MtLoXMLFrag())),
                  new ConsLoXMLFrag(
                      new Plaintext("ML"),
                      new MtLoXMLFrag()))),
          new ConsLoXMLFrag(
              new Plaintext("!"),
              new MtLoXMLFrag())));
  
  // I am <yell volume="30db" duration="5sec"><italic>X</italic>ML</yell>!
  ConsLoXMLFrag xml5_4 = new ConsLoXMLFrag(new Plaintext("I am "),
      new ConsLoXMLFrag(
          new Tagged(
              new Tag(
                  "yell",
                  new ConsLoAtt(
                      new Att("volume", "50db"),
                      new ConsLoAtt(
                          new Att("duration", "10sec"),
                          new MtLoAtt()))),
              new ConsLoXMLFrag(
                  new Tagged(
                      new Tag(
                          "italic",
                          new ConsLoAtt(
                              new Att("dog", "pompom"),
                              new MtLoAtt())),
                      new ConsLoXMLFrag(
                          new Plaintext("X"),
                          new MtLoXMLFrag())),
                  new ConsLoXMLFrag(
                      new Plaintext("ML"),
                      new MtLoXMLFrag()))),
          new ConsLoXMLFrag(
              new Plaintext("!"),
              new MtLoXMLFrag())));

  boolean testContentCount(Tester t) {
    return t.checkExpect((new MtLoXMLFrag()).contentLength(), 0) &&
        t.checkExpect(this.xml1.contentLength(), 9) &&
        t.checkExpect(this.xml4.contentLength(), 9);
  }

  boolean testHasTag(Tester t) {
    return t.checkExpect((new MtLoXMLFrag()).hasTag("yell"), false) &&
        t.checkExpect(this.xml1.hasTag("banana"), false) &&
        t.checkExpect(this.xml1.hasTag("yell"), false) &&
        t.checkExpect(this.xml2.hasTag("yell"), true) &&
        t.checkExpect(this.xml3.hasTag("yell"), true) &&
        t.checkExpect(this.xml4.hasTag("yell"), true) &&
        t.checkExpect(this.xml4.hasTag("asdfghjkl"), false);
  }

  boolean testHasAttribute(Tester t) {
    return t.checkExpect((new MtLoXMLFrag()).hasAttribute("yell"), false) &&
        t.checkExpect(this.xml1.hasAttribute("volume"), false) &&
        t.checkExpect(this.xml1.hasAttribute("duration"), false) &&
        t.checkExpect(this.xml2.hasAttribute("volume"), false) &&
        t.checkExpect(this.xml3.hasAttribute("volume"), false) &&
        t.checkExpect(this.xml4.hasAttribute("volume"), true) &&
        t.checkExpect(this.xml4.hasAttribute("duration"), false) &&
        t.checkExpect(this.xml5.hasAttribute("volume"), true) &&
        t.checkExpect(this.xml5.hasAttribute("duration"), true);
  }

  boolean testHasAttributeInTag(Tester t) {
    return t.checkExpect((new MtLoXMLFrag()).hasAttributeInTag("yell", "volume"), false) &&
        t.checkExpect(this.xml1.hasAttributeInTag("yell", "volume"), false) &&
        t.checkExpect(this.xml5_4.hasAttributeInTag("italic", "dog"), true) &&
        t.checkExpect(this.xml2.hasAttributeInTag("yell", "volume"), false) &&
        t.checkExpect(this.xml3.hasAttributeInTag("yell", "volume"), false) &&
        t.checkExpect(this.xml4.hasAttributeInTag("yell", "volume"), true) &&
        t.checkExpect(this.xml4.hasAttributeInTag("yell", "volume"), true) &&
        t.checkExpect(this.xml4.hasAttributeInTag("yell", "duration"), false) &&
        t.checkExpect(this.xml5.hasAttributeInTag("yell", "volume"), true) &&
        t.checkExpect(this.xml5.hasAttributeInTag("yell", "duration"), true);
  }

  boolean testRenderAsString(Tester t) {
    return t.checkExpect((new MtLoXMLFrag()).renderAsString(), "") &&
        t.checkExpect(
            (new ConsLoXMLFrag(
                new Plaintext("HELLO WORLD"),
                new MtLoXMLFrag())).renderAsString(),
            "HELLO WORLD")
        &&
        t.checkExpect(this.xml1.renderAsString(), "I am XML!") &&
        t.checkExpect(this.xml2.renderAsString(), "I am XML!") &&
        t.checkExpect(this.xml3.renderAsString(), "I am XML!") &&
        t.checkExpect(this.xml4.renderAsString(), "I am XML!") &&
        t.checkExpect(this.xml5.renderAsString(), "I am XML!");
  }

  boolean testUpdateAttribute(Tester t) {
    return t.checkExpect(this.xml5.updateAttribute("volume", "50db"), this.xml5_2) &&
        t.checkExpect(this.xml1.updateAttribute("volume", "50db"), this.xml1) &&
        t.checkExpect(this.xml2.updateAttribute("volume", "50db"), this.xml2) &&
        t.checkExpect(this.xml3.updateAttribute("volume", "50db"), this.xml3) &&
        t.checkExpect((new MtLoXMLFrag()).updateAttribute("volume", "50db"),
            new MtLoXMLFrag())
        &&
        t.checkExpect(
            this.xml5.updateAttribute("volume", "50db").updateAttribute("duration", "10sec"),
            this.xml5_3)
        &&
        t.checkExpect(this.xml4.updateAttribute("volume", "dog"), this.xml4_2);
  }

}