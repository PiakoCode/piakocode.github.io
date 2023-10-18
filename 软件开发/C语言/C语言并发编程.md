

交替输出AB

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main() {

  int ptc[2];
  int ctp[2];

  pipe(ptc);
  pipe(ctp);
  int pid = fork();
  if (pid == 0) {
    char buf;
    for (int i = 1; i <= 1000; i++) {
      printf("A");
      fflush(stdout); // !!!
      write(ctp[1], "0", 1);
      read(ptc[0], &buf, 1);
    }

  } else if (pid > 0) {
    char buf;
    for (int i = 1; i <= 1000; i++) {
      read(ctp[0], &buf, 1);
      printf("B");
      fflush(stdout); // !!!
      write(ptc[1], "1", 1);
    }
  } else {

    printf("Error\n");
    exit(1);
  }
  close(ptc[0]);
  close(ctp[0]);
  close(ctp[1]);
  close(ptc[1]);

  return 0;
}
```

  
在这段代码中加入`fflush(stdout)`函数是为了及时将输出缓冲区的内容刷新并显示在屏幕上。在C语言中，当你使用`printf`函数输出内容时，默认情况下，输出会先暂存在输出缓冲区中，而不会立即显示在屏幕上。这是为了提高输出效率，避免频繁地写入屏幕。缓冲区会在满或在程序结束时自动刷新，或者在遇到换行符`\n`时会立即刷新。

但在某些情况下，我们希望立即将输出显示出来，而不等待缓冲区满或程序结束。这时就可以使用`fflush(stdout)`函数强制刷新输出缓冲区，使得内容立即显示在屏幕上。

在这个特定的代码中，我们希望在交替输出'A'和'B'时能够及时显示结果，而不是等待缓冲区满或程序结束才输出。因此，在每次输出'A'或'B'后，我们使用`fflush(stdout)`确保立即将其显示在屏幕上，从而实现交替输出的效果。