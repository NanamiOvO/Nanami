/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package eightpuzzle;
import java.util.*;

public class Board {
    private final int SIZE = 3;
    private int[][] board;
    private int[][] goal;
    private int cost = 0;
    private int h = 0; // heuristic
    private int mDist = 0;
    private int misTiles = 0;
    private Board parent = null;
    private Queue<Board> children = new LinkedList<>();
    private int blankX = 0;
    private int blankY = 0;
    
    public Board(int[][] state, int[][] end)
    {
        board = new int[SIZE][SIZE];
        goal = new int[SIZE][SIZE];
        for(int i = 0; i < SIZE; i++)
        {
            System.arraycopy(state[i], 0, board[i], 0, SIZE);      
            System.arraycopy(end[i], 0, goal[i], 0, SIZE );
        }
        for (int x = 0; x < SIZE; x++)
        {
            for (int y = 0; y < SIZE; y++)
            {
                if (board[x][y] == 0)
                {
                    blankX = x;
                    blankY = y;
                }
            }
        }
        mDist = mDistance();
        misTiles = findMisTiles();
    }
    public void printBoard()
    {
        for (int i = 0; i < SIZE; i++)
        {
            for (int j = 0; j < SIZE; j++)
            {
                System.out.print(board[i][j]);
            }
            System.out.println();
        }
        System.out.println();
    }
    public void printGoal()
    {
        for (int i = 0; i < SIZE; i++)
        {
            for (int j = 0; j < SIZE; j++)
            {
                System.out.print(goal[i][j]);
            }
            System.out.println();
        }
        System.out.println();
    }
  /*  public void copyBoard(int[][] src, int[][] dest)
    {
        
        for(int i = 0; i < SIZE; i++)
        {
            System.arraycopy(src[i], 0, dest[i], 0, SIZE);            
        }
    }*/
    public boolean isEqual(int[][] s1, int[][] s2)
    {
        for(int i = 0; i < SIZE; i++)
        {
            for(int j = 0; j < SIZE; j++)
            {
                if (s1[i][j] == s2[i][j])
                    continue;
                else
                    return false;
            }
        }
        return true;
    }
    public boolean isSolvable()
    {
        if (parity(board) != parity(goal))
            return false;
        return true;
    }
    public int parity(int[][] state) // returns 0 if even, 1 if odd, tested, works correctly
    {
        int parity = 0;
        int i = 0;
        int[] board1D = new int[SIZE * SIZE];
        for (int j = 0; j < state.length; j++)
        {
            System.arraycopy(state[j], 0, board1D, i, board[j].length);
            i += board[j].length;
        }
        
            for (int x = 0; x < (SIZE * SIZE) - 1; x++)
            {
                if (board1D[x] == 0) // skip blank space
                    continue;
                for (int y = x + 1; y < SIZE * SIZE; y++)
                {
                    if (board1D[y] == 0) // skip blank space
                        continue;
                    else if (board1D[x] > board1D[y])
                        parity += 1;
                }
            }
            return parity % 2;
        }
        public void moveUp()
        {
            if (!(board[0][0] == 0 || board[0][1] == 0 || board[0][2] == 0))
            {
                int[][] bcopy = new int[SIZE][SIZE];
                for(int i = 0; i < SIZE; i++)
                {
                    System.arraycopy(board[i], 0, bcopy[i], 0, SIZE);
                }  
                bcopy[blankX][blankY] = bcopy[blankX - 1][blankY];
                bcopy[blankX - 1][blankY] = 0;
                Board child = new Board(bcopy, goal);
                children.add(child);
                child.parent = this;
                child.cost = this.cost+1;
            }
        }
        public void moveDown()
        {
            if (!(board[2][0] == 0 || board[2][1] == 0 || board[2][2] == 0))
            {
                int[][] bcopy = new int[SIZE][SIZE];
                for(int i = 0; i < SIZE; i++)
                {
                    System.arraycopy(board[i], 0, bcopy[i], 0, SIZE);
                }  
                bcopy[blankX][blankY] = bcopy[blankX + 1][blankY];
                bcopy[blankX + 1][blankY] = 0;
                Board child = new Board(bcopy, goal);
                children.add(child);
                child.parent = this;
                child.cost = this.cost+1;
            }
        }
        public void moveLeft()
        {
            if (!(board[0][0] == 0 || board[1][0] == 0 || board[2][0] == 0))
            {
                int[][] bcopy = new int[SIZE][SIZE];
                for(int i = 0; i < SIZE; i++)
                {
                    System.arraycopy(board[i], 0, bcopy[i], 0, SIZE);
                }  
                bcopy[blankX][blankY] = bcopy[blankX][blankY - 1];
                bcopy[blankX][blankY - 1] = 0;
                Board child = new Board(bcopy, goal);
                children.add(child);
                child.parent = this;
                child.cost = this.cost+1;
            }
        }
        public void moveRight()
        {
            if (!(board[0][2] == 0 || board[1][2] == 0 || board[2][2] == 0))
            {
                int[][] bcopy = new int[SIZE][SIZE];
                for(int i = 0; i < SIZE; i++)
                {
                    System.arraycopy(board[i], 0, bcopy[i], 0, SIZE);
                }  
                bcopy[blankX][blankY] = bcopy[blankX][blankY + 1];
                bcopy[blankX][blankY + 1] = 0;
                Board child = new Board(bcopy, goal);
                children.add(child);
                child.parent = this;
                child.cost = this.cost+1;
            }
        }
        public void expand()
        {
            moveUp();
            moveDown();
            moveLeft();
            moveRight();
        }
        public void solveBFS(Board start)
        {
            int numExpanded = 0;
            Stack<Board> path = new Stack<>();
            Queue<Board> open = new LinkedList<>();
            Set<String> closed = new HashSet<>();
            Board currentState = start;
            while(!currentState.isEqual(currentState.board, goal))
            {
                closed.add(Arrays.deepToString(currentState.board));
                currentState.expand();
                numExpanded++;
                while(!currentState.children.isEmpty())
                {   
                    Board child = currentState.children.poll();
                    if(!closed.contains(Arrays.deepToString(child.board)))
                    {
                        closed.add(Arrays.deepToString(child.board));
                        open.add(child);
                    }
                }
                currentState = open.poll();
            }
             System.out.println("Solution path found"); 
             findPath(path, currentState); 
             while(!path.isEmpty())
                 path.pop().printBoard();
             System.out.println("Number of nodes expanded: " + numExpanded);
             System.out.println("Depth of final node: " + currentState.cost);
        }
        
        public void solveGBFS(Board start)
        {
            int numExpanded = 0;
            start.h = start.mDist;
            BoardComparator comp = new BoardComparator();
            Stack<Board> path = new Stack<>();
            Queue<Board> open = new PriorityQueue<>(200, comp);
            Set<String> closed = new HashSet<>();
            Board currentState = start;
            while(!currentState.isEqual(currentState.board, goal))
            {
                currentState.h = currentState.mDist;
                closed.add(Arrays.deepToString(currentState.board));
                currentState.expand();
                numExpanded++;
                while(!currentState.children.isEmpty())
                {   
                    Board child = currentState.children.poll();
                    child.h = child.mDist;
                    if(!closed.contains(Arrays.deepToString(child.board)))
                    {
                        closed.add(Arrays.deepToString(child.board));
                        open.add(child);
                        if(child.h < currentState.h) // Greedy BFS, if child's heuristic is lower value than parent, queue child then requeue parent and ignore rest of child nodes
                        {
                            open.add(currentState);
                            break;
                        }
                    }
                }
                currentState = open.poll();
            }
             System.out.println("Solution path found");
             findPath(path, currentState); 
             while(!path.isEmpty())
                 path.pop().printBoard();
             System.out.println("Number of nodes expanded: " + numExpanded);
             System.out.println("Depth of final node: " + currentState.cost);
        }
        
        public void solveAstar(Board start, int choice) // if choice = 0 use mDist, if choice = 1 use mTiles
        {
            int numExpanded = 0;
            switch (choice) {
                case 0:
                    start.h = start.mDist + start.cost;
                    break;     
                case 1:
                    start.h = start.misTiles + start.cost;
                    break;
                default:
                    System.out.println("Error, invalid choice");
                    return;
        }
            BoardComparator comp = new BoardComparator();
            Stack<Board> path = new Stack<>();
            Queue<Board> open = new PriorityQueue<>(200, comp);
            Set<String> closed = new HashSet<>();
            Board currentState = start;
            while(!currentState.isEqual(currentState.board, goal))
            {
                if (choice == 0)
                    currentState.h = currentState.mDist + currentState.cost;
                else
                    currentState.h = currentState.misTiles + currentState.cost; 
                closed.add(Arrays.deepToString(currentState.board));
                currentState.expand();
                numExpanded++;
                while(!currentState.children.isEmpty())
                {   
                    Board child = currentState.children.poll();
                    if (choice == 0)
                        child.h = child.mDist + child.cost;
                    else
                        child.h = child.misTiles + child.cost; 
                    if(!closed.contains(Arrays.deepToString(child.board)))
                    {
                        closed.add(Arrays.deepToString(child.board));
                        open.add(child);
                    }
                }
                currentState = open.poll();
            }
             System.out.println("Solution path found");
             findPath(path, currentState); 
             while(!path.isEmpty())
                 path.pop().printBoard();
             System.out.println("Number of nodes expanded: " + numExpanded);
             System.out.println("Depth of final node: " + currentState.cost);           
        }
        public void findPath(Stack<Board> path, Board state)
        {
            System.out.println("Printing path:");
            Board current = state;
            path.push(current);
            while(current.parent != null)
            {
                current = current.parent;
                path.push(current);
            } 
        }
        
        public int findMisTiles()
        {
            int total = 0;
            int[] coor = new int[2];
            for(int i = 0; i < SIZE; i++)
            {
                for(int j = 0; j < SIZE; j++)
                {
                    if(board[i][j] != 0)
                    {
                        if (board[i][j] != goal[i][j])
                            total++;
                    }
                }
            }
            return total;
        }
        public int mDistance()
        {
            int total = 0;
            int[] coor = new int[2];

            for (int i = 0; i < SIZE; i++)
            {
                for (int j = 0; j < SIZE; j++)
                {
                    if (board[i][j] != 0)
                    {
                        coor = goalCoor(board[i][j]);
                        total += Math.abs(i - coor[0]);
                        total += Math.abs(j - coor[1]);
                    }
                }
            }
            return total;
        }
        public int [] goalCoor(int num)
        {
            int[] coor = new int[2];
            for (int i = 0; i < SIZE; i++)
            {
                for (int j = 0; j < SIZE; j++)
                {
                    if (goal[i][j] == num)
                    {
                        coor[0] = i;
                        coor[1] = j;
                    }
                }
            }
            return coor;
        }        
        public int getH()
        {
            return h;
        }
}


