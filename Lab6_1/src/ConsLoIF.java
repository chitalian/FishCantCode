
// Represents a nonempty list of ImageFiles
public class ConsLoIF implements ILoIF {

  public ImageFile first;
  public ILoIF rest;

  public ConsLoIF(ImageFile first, ILoIF rest) {
    this.first = first;
    this.rest = rest;
  }

  // Does this nonempty list contain that ImageFile
  public boolean contains(ImageFile that) {
    return (this.first.sameImageFile(that) ||
        this.rest.contains(that));
  }

  @Override
  public ILoIF filter(ISelectIF pred) {
    if (!(pred.apply(this.first))) {
      return rest.filter(pred);
    } else {
      return new ConsLoIF(this.first, this.rest.filter(pred));
    }
  }

  @Override
  public int count(ISelectIF pred) {
    if (!(pred.apply(this.first))) {
      return rest.count(pred);
    } else {
      return 1 + rest.count(pred);
    }
  }
}
