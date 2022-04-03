
#include <iostream>
#include <sstream>
#include <string>
#include<fstream>
using namespace std;
int main()
{
    long long int x = 0, y = 0, rowA = 0, colA = 0, rowB = 0, colB = 0, rowGR = 0, colGR = 0, rowR = 0, colR = 0, len = 0, rate = 0, res = 0;
    cout << "enter row of matrix A: ";
    cin >> rowA;
    cout << "enter column of matrix A: ";
    cin >> colA;
    cout << "enter row of matrix B: ";
    cin >> rowB;
    cout << "enter column of matrix B: ";
    cin >> colB;
    if (colA == rowB)
    {
        long long int** arrayA = new long long int* [rowA];
        long long int** arrayB = new long long int* [rowB];
        long long int** arrayR = new long long int* [100];
        long long int** arrayGR = new long long int* [rowA];
        for (int i = 0; i < rowA; i++)
        {
            arrayA[i] = new long long int[colA] {0};
            arrayGR[i] = new long long int[colB] {0};
        }
        for (int i = 0; i < rowB; i++)
        {
            arrayB[i] = new long long int[colB] {0};
        }
        for (int i = 0; i < 100; i++)
        {
            arrayR[i] = new long long int[100];

        }

        string line, temp;
        fstream fileA("A.txt", ios::in);
        while (getline(fileA, line))
        {
            y = 0;
            len = line.length();
            for (int i = 0; i < len; i++)
            {
                if (line[i] != ' ') { temp.push_back(line[i]); }
                if (line[i] == ' ' || i == line.length() - 1)
                {
                    if (temp == "") { continue; }
                    else { arrayA[x][y] = stoll(temp); }
                    y += 1;
                    temp.clear();
                }
                if (y == colA) { break; }
            }
            x++;
            if (x == rowA)
            {
                break;
            }
        }
        fileA.close();
        x = 0; y = 0;

        cout << "\nrowA is: " << rowA << " colA is: " << colA << endl;
        for (int i = 0; i < rowA; i++)
        {
            for (int j = 0; j < colA; j++)
            {
                cout << arrayA[i][j] << " ";
            }
            cout << endl;
        }

        //load arrayB
        cout << endl;
        fstream fileB("B.txt", ios::in);
        while (getline(fileB, line))
        {
            y = 0;
            len = line.length();
            for (int i = 0; i < len; i++)
            {
                if (line[i] != ' ') { temp.push_back(line[i]); }
                if (line[i] == ' ' || i == line.length() - 1)
                {
                    if (temp == "") { continue; }
                    else { arrayB[x][y] = stoll(temp); }
                    y += 1;
                    temp.clear();
                }
                if (y == colB) { break; }
            }
            x++;
            if (x == rowB)
            {
                break;
            }
        }
        fileB.close();
        x = 0; y = 0;

        cout << "\nrowB is: " << rowB << " colB is: " << colB << endl;
        for (int i = 0; i < rowB; i++)
        {
            for (int j = 0; j < colB; j++)
            {
                cout << arrayB[i][j] << " ";
            }
            cout << endl;
        }

        //load matrixR
        fstream result("result.txt", ios::in);
        while (getline(result, line))
        {
            y = 0;
            len = line.length();
            for (int i = 0; i < len; i++)
            {
                if (line[i] != ' ') { temp.push_back(line[i]); }
                if (line[i] == ' ' || i == line.length() - 1)
                {
                    if (temp == "") { continue; }
                    else { arrayR[x][y] = stoll(temp); }
                    y += 1;
                    temp.clear();
                }
            }
            colR = y;
            x++;
        }
        rowR = x;
        fileB.close();
        x = 0; y = 0;
        /*
        cout << "\nrowR is: " << rowR << " colR is: " << colR << endl;
        for (int i = 0; i < rowR; i++)
        {
            for (int j = 0; j < colR; j++)
            {
                cout << arrayR[i][j] << " ";
            }
            cout << endl;
        }
        */

        rowGR = rowA; colGR = colB;
        for (int row1 = 0; row1 < rowA; row1++)//move row 1 
        {
            for (int col2 = 0; col2 < colB; col2++)// move col 2
            {
                for (int col1 = 0; col1 < colA; col1++)//move col 1
                {
                    arrayGR[row1][col2] += arrayA[row1][col1] * arrayB[col1][col2];
                }
            }
        }
        //else { cout << "error dimension"; return 0; }
        cout << "golden result is: \n";
        for (int i = 0; i < rowGR; i++)
        {
            for (int j = 0; j < colGR; j++)
            {
                cout << arrayGR[i][j] << " ";
            }
            cout << endl;
        }
        cout << endl;
        if (rowR == rowGR && colR == colGR)
        {
            for (int i = 0; i < rowR; i++)
            {
                for (int j = 0; j < colR; j++)
                {
                    if (arrayR[i][j] != arrayGR[i][j])
                    {
                        rate += 1;
                        //cout << "result[" << i+1 << "][" << j+1 << "]=" << arrayR[i][j] << "  " << "golden result[" << i+1 << "][" << j+1 << "]=" << arrayGR[i][j] << endl;
                    }
                }
            }

        }
        res = rate / (rowR * colR);
        cout << "rate of difference between golden matrix and result matrix is: "<<res;
    }
    else { cout << "error dimension"; return 0; }
    //else cout << "different dimension\n";
    return 0;
}

