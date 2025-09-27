#include <bits/stdc++.h>
using namespace std;
class Table{
    int q, x,y, r, s1, s2, s,t1, t2, t, xinit, yinit;
    public:
    Table(int xin, int yin){
        xinit = xin;
        yinit = yin;
        x = xin;
        y = yin;
        s1 = 1;
        s2 = 0;
        t1 = 0;
        t2 = 1;
        cout<<"Q\t"<<"X\t"<<"Y\t"<<"R\t"<<"S1\t"<<"S2\t"<<"S\t"<<"T1\t"<<"T2\t"<<"T\n";
        
    }
    int Compute(){
        if(y == 0){
            printAns();
            return 0;
        }

        q = x/y;
        r = x%y;
        t = t1 - q*t2;
        s = s1 - q*s2;
        int r;
        printTable();
        r = nextStage();
        return r; 
    }
    int nextStage() {
        if(r == 0){
            printAns();
            return 0;
        }
        x=y;
        y=r;
        t1=t2;
        t2=t;
        s1=s2;
        s2=s;
        int r;
        r = Compute();
        return 1;
    }

    void printAns(){
        int gcd = s2*xinit+t2*yinit;
        cout<<"a = "<<s2<<" b= "<<t2;
        cout<<" \n"<<s2<<" * "<<xinit<<"  + " <<t2<<" * "<<yinit<<" = "<<gcd<<endl;
        cout<<"GCD = "<<gcd<<"\n";
    }
    void printTable(){
        if(r == 0)
            cout<<q<<"\t"<<x<<"\t"<<y<<"\t|"<<r<<"|\t"<<s1<<"\t|"<<s2<<"|\t"<<s<<"\t"<<t1<<"\t|"<<t2<<"|\t"<<t<<"\n";

        else cout<<q<<"\t"<<x<<"\t"<<y<<"\t"<<r<<"\t"<<s1<<"\t"<<s2<<"\t"<<s<<"\t"<<t1<<"\t"<<t2<<"\t"<<t<<"\n";
    }
};




int main(){
    int x, y;
    cout<<"Enter x, y \n";
    cin>>x>>y;
    int xp = max(x,y), yp=min(x,y);

    Table T(xp,yp);
    int r = T.Compute();

return 0;

}