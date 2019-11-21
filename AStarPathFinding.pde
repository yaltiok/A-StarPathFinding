int cols;
int rows;

int cellSize = 10;

Cell start;
Cell end;
Cell current;

boolean finished = false;
boolean started = false;


Cell[][] cells;
ArrayList<Cell> openSet = new ArrayList();
ArrayList<Cell> closedSet = new ArrayList();
ArrayList<Cell> path = new ArrayList();

void setup() {
  size(600, 600);
  cols = floor(width / cellSize);
  rows = floor(height / cellSize);
  fillGrid();
  findAllNeighbors();
  start = cells[0][0];
  end = cells[cols - 1][rows - 1];
  start.wall = false;
  end.wall = false;
  openSet.add(start);
  //makeWall();
}

void mousePressed() {
  started = true;
  frameRate(1000);
}

void draw() {
  //noLoop();
  background(0);
  if (openSet.size() > 0 && !finished && started) {
    findLowest();
    calcNeighborValues(current);
    removeFromArray(openSet, current);
    closedSet.add(current);
  } else if (started) {
    println("Sonuç Yok!");
    finished = true;
  }
  show();
  showOpen();
  showClosed();
  showPath();
}

void fillGrid() {
  cells = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < cols; j++) {
      cells[i][j] = new Cell(i, j, cellSize);
    }
  }
}

void show() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < cols; j++) {
      cells[i][j].show(255, 255, 255);
      if (cells[i][j] == end) {
        cells[i][j].show(0, 0, 255);
      }
    }
  }
}

void showClosed() {
  for (int i = 0; i < closedSet.size(); i++) {
    closedSet.get(i).show(255, 0, 0);
  }
}

void findLowest() {
  int winner = 0;
  for (int i = 0; i < openSet.size(); i++) {
    if (openSet.get(i).f < openSet.get(winner).f) {
      winner = i;
    }
  }
  current = openSet.get(winner);
  if (current == end) {
    println("Bitti");
    finished = true;
    noLoop();
  }
}

void findAllNeighbors() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < cols; j++) {
      cells[i][j].findNeighbors(cells);
    }
  }
}

void showOpen() {
  for (int i = 0; i < openSet.size(); i++) {
    openSet.get(i).show(0, 255, 0);
  }
}
void showPath() {
  if (started) {
    path.clear();
    Cell temp = current;
    path.add(temp);
    while (temp.previous != null) {
      path.add(temp.previous);
      temp = temp.previous;
    }
    for (int i = 0; i < path.size(); i++) {
      path.get(i).show(0, 0, 255);
    }
  }
}

void makeWall() {
  for (int i = 2; i < cells.length - 2; i++) {
    cells[i][cols - i].wall = true;
    cells[i + 1][cols - i].wall = true;
  }
  int a = 11;
  cells[cols - 1][a].wall = true;
  cells[cols - 2][a].wall = true;
  cells[cols - 3][a].wall = true;
  cells[cols - 4][a].wall = true;
  cells[cols - 5][a].wall = true;
  cells[cols - 6][a].wall = true;
}

void removeFromArray(ArrayList<Cell> arr, Cell cell) {
  for (int i = arr.size()-1; i >= 0; i--) {
    if (arr.get(i) == cell) {
      arr.remove(i);
    }
  }
}

void calcNeighborValues(Cell current) {
  for (Cell n : current.neighbors) {
    if (!closedSet.contains(n) && !n.wall) {
      float tempG = current.g + heuristic(current, n);
      if (openSet.contains(n)) {
        if (tempG < n.g) {
          n.g = tempG;
        }
      } else {
        n.g = tempG;
        openSet.add(n);
      }
      n.h = heuristic(n, end);
      n.f = n.g + n.h;
      n.previous = current;
    }
  }
}


float heuristic(Cell n, Cell end) {
  return dist(n.x, n.y, end.x, end.y);
  //return abs(n.x - n.y) + abs(end.x - end.y);
}

class Cell {
  float f, g, h;
  int x, y, w;
  ArrayList<Cell> neighbors = new ArrayList();
  Cell previous = null;
  boolean wall = false;

  Cell(int i, int j, int w) {
    this.w = w;
    this.x = i;
    this.y = j;
    if (random(1) < 0.2) {
      this.wall = true;
    }
  }

  void show(int R, int G, int B) {
    fill(R, G, B);
    if (this.wall) {
      fill(0);
    }
    noStroke();
    rect(x*this.w, y*this.w, w-1, w-1);
  }

  void findNeighbors(Cell[][] grid) {
    if (x < cols-1) {
      neighbors.add(grid[this.x + 1][this.y]);
    }
    if (x > 0) {
      neighbors.add(grid[this.x - 1][this.y]);
    }
    if (y < rows - 1) {
      neighbors.add(grid[this.x][this.y + 1]);
    }
    if (y > 0) {
      neighbors.add(grid[this.x][this.y - 1]);
    }
    if (y > 0 && x < cols-1) {
      neighbors.add(grid[this.x + 1][this.y - 1]);
    }
    if (y < rows - 1 && x < cols-1) {
      neighbors.add(grid[this.x + 1][this.y + 1]);
    }
    if (y < rows - 1 && x > 0) {
      neighbors.add(grid[this.x - 1][this.y + 1]);
    }
    if (y > 0 && x > 0) {
      neighbors.add(grid[this.x - 1][this.y - 1]);
    }
  }
}
