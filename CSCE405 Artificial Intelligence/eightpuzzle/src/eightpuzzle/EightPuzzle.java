/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package eightpuzzle;


import java.util.*;

public class EightPuzzle {

    public static void main(String args[])
    { 
        while(true)
        {
            boolean set = false;            
            Scanner in = new Scanner(System.in);
            int[][] start = new int[3][3];
            int[][] goal = new int[3][3];
            System.out.println("Enter the start state");
            input:
            while(set == false)
            {
                Set<Integer> enteredNum = new HashSet<>();
                try
                {
                    outer:
                    for(int i = 0; i < 3; i++)
                    {
                        for(int j = 0; j < 3; j++)
                        {
                            start[i][j] = in.nextInt();
                            if(start[i][j] > 8 || start[i][j] < 0 || enteredNum.contains(start[i][j]))
                            {
                                System.out.println("Error: not a valid entry (no repeats, must be between 0-8)");
                                System.out.println("Please enter a valid board");
                                continue input;
                            }
                            enteredNum.add(start[i][j]);
                        }
                    }
                    set = true;
                }
                catch(InputMismatchException exception)
                {
                    System.out.println("Error: not a number");   
                    System.out.println("Please enter a valid board");
                    in.next();
                }
            }
            set = false;
            System.out.println("Enter the goal state");
            input:
            while(set == false)
            {
                Set<Integer> enteredNum = new HashSet<>();
                try
                {
                    outer:
                    for(int i = 0; i < 3; i++)
                    {
                        for(int j = 0; j < 3; j++)
                        {
                            goal[i][j] = in.nextInt();
                            if(goal[i][j] > 8 || goal[i][j] < 0 || enteredNum.contains(goal[i][j]))
                            {
                                System.out.println("Error: not a valid entry (no repeats, must be between 0-8)");
                                System.out.println("Please enter a valid board");
                                continue input;
                            }
                            enteredNum.add(goal[i][j]);
                        }
                    }
                    set = true;
                }
                catch(InputMismatchException exception)
                {
                    System.out.println("Error: not a number");
                    System.out.println("Please enter a valid board");
                    in.next();
                }
            }

            Board game = new Board(start,goal); 
            System.out.println("Start:");
            game.printBoard();
            System.out.println("Goal:");
            game.printGoal();
            algorithm:
            while(game.isSolvable())
            {
                System.out.println("Solvable board");                        
                while(true)
                {   
                    try
                    {
                        System.out.println("Choose a search algorithm:\n1: Breadth-First Search\n2: Greedy Best-First Search\n3: A* with Manhattan Distance\n4: A* with Misplaced Tiles" );
                        int n = in.nextInt();
                        switch(n){
                            case 1:
                                game.solveBFS(game);
                                break;
                            case 2:
                                game.solveGBFS(game);
                                break;
                            case 3:
                                game.solveAstar(game,0);
                                break;
                            case 4:
                                game.solveAstar(game,1);
                                break;
                        default:
                            System.out.println("Error: not a valid choice");
                            continue;  
                        }   
                    }
                    catch(InputMismatchException exception)
                    {
                        System.out.println("Error: not a valid choice");
                        in.next();
                        continue;
                    }                                     
                    while(true)
                    {
                        System.out.println("Would you like to use a different algorithm? y/n");
                        String repeat = in.next();
                        if(repeat.equals("y"))
                            continue algorithm;
                        else if(repeat.equals("n"))
                            break;
                        else
                            System.out.println("Error: not y/n");
                    }                    
                    while(true)
                    {
                        System.out.println("Would you like to enter a new game? y/n");
                        String repeat = in.next();
                        if(repeat.equals("y"))
                            break;
                        else if(repeat.equals("n"))
                            System.exit(0);
                        else
                            System.out.println("Error: not y/n");
                    }
                    break;
                }
                break;                                               
            }
            if(!game.isSolvable())
                System.out.println("Unsolvable board, please enter another");
        }
    } 
}

