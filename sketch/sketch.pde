Koch f1;
Koch f2;
Koch f3;
ArrayList<Koch> snowflake;
int levels;

void setup() {
  frameRate(1);
  size(displayWidth, displayHeight);
  snowflake = new ArrayList<Koch>();
  // Line length
  float n;
  for (int i = 10; i < 301; i += 10) {
    n = i;
    // Point one
    float x0 = 0;
    float y0 = 0;
    float x1 = n;
    float y1 = 0;
    float xv = n/2;
    float yv = -sqrt(n*n-xv*xv);
    PVector e = new PVector(x0, y0);
    PVector s = new PVector(x1, y1);
    PVector s2 = new PVector(x0, y0);
    PVector e2 = new PVector(xv, yv);
    PVector e3 = new PVector(x1, y1);
    PVector s3 = new PVector(xv, yv);
    f1 = new Koch(s, e, levels);
    f2 = new Koch(s2, e2, levels);
    f3 = new Koch(s3, e3, levels);
    snowflake.add(f1);
    snowflake.add(f2);
    snowflake.add(f3);
  }

}


void draw() {
  background(255);
  for (Koch f : snowflake) {
    PVector line = PVector.sub(f.last, f.first);
    float n = line.mag();
    pushMatrix();
    stroke(0, 0, 255);
    translate(width/2-n/2, height/2+n/3);
    f.show();
    popMatrix();
    if (f.levels < 5) {
      f.addLevel();
    } else {
      f.reset();
    }
  }
}


class Koch {
  PVector first;
  PVector last;
  ArrayList<KochLine> all;
  int levels;
  
  public Koch(PVector first, PVector last) {
    this.first = first;
    this.last = last;
    this.levels = 0;
    this.all = new ArrayList<KochLine>();
    this.all.add(new KochLine(first, last));
  }

  public Koch(PVector first, PVector last, int levels) {
    this.first = first;
    this.last = last;
    this.levels = levels;
    this.all = new ArrayList<KochLine>();
    this.all.add(new KochLine(first, last));
    int i = levels;
    while (i > 1) {
      ArrayList<KochLine> next = new ArrayList<KochLine>();
      KochLine one = new KochLine();
      KochLine two = new KochLine();
      KochLine three = new KochLine();
      KochLine four = new KochLine();
      for (KochLine cl : this.all) {
        one = new KochLine(cl.start, cl.left);
        two = new KochLine(cl.left, cl.mid);
        three = new KochLine(cl.mid, cl.right);
        four = new KochLine(cl.right, cl.end);
        next.add(one);
        next.add(two);
        next.add(three);
        next.add(four);
      }
      this.all = next;
      i--;
    }
  }
  
  public void addLevel() {
    this.levels++;
    if (this.levels > 1) {
      ArrayList<KochLine> next = new ArrayList<KochLine>();
      KochLine one = new KochLine();
      KochLine two = new KochLine();
      KochLine three = new KochLine();
      KochLine four = new KochLine();
      for (KochLine cl : this.all) {
        one = new KochLine(cl.start, cl.left);
        two = new KochLine(cl.left, cl.mid);
        three = new KochLine(cl.mid, cl.right);
        four = new KochLine(cl.right, cl.end);
        next.add(one);
        next.add(two);
        next.add(three);
        next.add(four);
      }
      this.all = next;
    }
  }
  
  public void reset() {
    this.levels = 0;
    this.all = new ArrayList<KochLine>();
    this.all.add(new KochLine(first, last));
  }
  
  public void show() {
    if (this.levels == 0) {
      line(this.first.x, this.first.y, this.last.x, this.last.y);
    } else {
      for (KochLine kl : this.all) {
        kl.show();
      }
    }
  }
}


class KochLine {
  PVector start;
  PVector end;
  PVector left;
  PVector right;
  PVector mid;
  
  public KochLine(PVector start, PVector end) {
    this.start = start;
    this.end = end;
    float xl = (end.x - start.x);
    float yl = (end.y - start.y);
    float length = sqrt(xl*xl+yl*yl);
    this.left = new PVector(start.x+length/3*(xl/length), start.y+length/3*(yl/length));
    this.right = new PVector(start.x+length*2/3*(xl/length), start.y+length*2/3*(yl/length));
    this.mid = new PVector(this.left.x, this.left.y);
    PVector aux = PVector.sub(this.left, this.start);
    aux.rotate(-radians(60));
    this.mid.add(aux);
  }
  
  public KochLine() {}
  
  public void show() {
    line(this.start.x, this.start.y, this.left.x, this.left.y);
    line(this.left.x, this.left.y, this.mid.x, this.mid.y);
    line(this.mid.x, this.mid.y, this.right.x, this.right.y);
    line(this.right.x, this.right.y, this.end.x, this.end.y);
  }
}