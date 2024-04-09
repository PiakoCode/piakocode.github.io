# ICPC 模板



**快读**(read)

```cpp
long long quick_read()
{
    int x=0,t=1;
    char ch=getchar();
    while(ch<'0'||ch>'9')
    {
        if(ch=='-')
        t=-1;
        ch=getchar();
    }
    while(ch>='0'&&ch<='9')
    {
        x=(x<<1)+(x<<3)+(ch^48);
        ch=getchar();
    }
    return x*t;
}
```

**KMP**

```cpp
#include <cstring>
#include <iostream>
#include <algorithm>
using namespace std;
const int N = 1000010;
int n, m;
int ne[N];
int ne2[N];
int main()
{
    string s1, s2;
    int a, b;
    cin >> s1 >> s2;
    a = s1.length();
    b = s2.length();

    if (a > b)
    {
        swap(s1, s2);
        swap(a, b);
    }

    int flag = 0;
    ne[0] = -1;
    for (int i = 1, j = -1; i < a; i++)
    {
        while (j >= 0 && s1[j + 1] != s1[i])
            j = ne[j];
        if (s1[j + 1] == s1[i])
            j++;
        ne[i] = j;
    }

    for (int i = 0, j = -1; i < b; i++)
    {
        while (j != -1 && s2[i] != s1[j + 1])
            j = ne[j];
        if (s2[i] == s1[j + 1])
            j++;
        if (j == a - 1)
        {
            flag = 1;
            break;
        }
    }

    if (flag == 0)
        printf("NO\n");
    else
        printf("YES\n");
    return 0;
}
```

**高精度加法**

```cpp
vector<int> add(vector<int> &A, vector<int> &B)
{
    if (A.size() < B.size())
        return add(B, A);
    vector<int> C;
    int t = 0;
    for (int i = 0; i < A.size(); i++)
    {
        t += A[i];
        if (i < B.size())
            t += B[i];
        C.push_back(t % 10);
        t /= 10;
    }
    if (t)
        C.push_back(t);
    return C;
}
int main()
{
    string a, b;
    vector<int> A;
    vector<int> B;
    cin >> a >> b;
    for (int i = a.size() - 1; i >= 0; i--)
    {
        A.push_back(a[i] - '0');
    }
    for (int i = b.size() - 1; i >= 0; i--)
    {
        B.push_back(b[i] - '0');
    }
    vector<int> C = add(A, B);
    for (int i = C.size() - 1; i >= 0; i--)
    {
        printf("%d", C[i]);
    }
    return 0;
}
```

