#include<bits/stdc++.h>
#include<fstream>
using namespace std;
int func(string s)
{
	int l=s.length();
	int a=0;int ans=0;
	for(int i=2;i<l;i++)
	{
		if(s[i]=='H')ans=ans+a*3600,a=0;
		else if(s[i]=='M')ans=ans+a*60,a=0;
		else if(s[i]=='S')ans=ans+a,a=0;
		else a=a*10+((int)s[i]-48);
	}
	return ans;
}
int main()
{
	string s;
  	ifstream inp("ad_org_test1.csv");
  	ofstream op ("output_test.csv");
  	if(inp.is_open())
  	{
    	while(getline(inp,s))
    	{
      		int ans=func(s);
      		op<<ans;
      		op<<"\n";
    	}
    	inp.close();
    	op.close();
    }
}
