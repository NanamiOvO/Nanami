/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package eightpuzzle;

import java.util.Comparator;

/**
 *
 * @author Owner
 */
public class BoardComparator implements Comparator<Board>{
    @Override
    public int compare(Board a, Board b)
    {
        if(a.getH() < b.getH())
            return -1;
        else if(a.getH() > b.getH())
            return 1;
        return 0;
    }
}

