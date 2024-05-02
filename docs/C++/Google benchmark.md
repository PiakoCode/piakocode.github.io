# Google benchmark

样例代码

测试冒泡排序和选择排序的速度

```cpp

#include "benchmark/benchmark.h"
#include "sort.h"

// 冒泡排序
static void bubble(benchmark::State &state) {
    std::vector<int> v;
    srand(time(NULL));
    for (int i = 1; i <= 50000; ++i) {
        v.emplace_back(rand() % 10000);
    }
    for (auto _ : state) {
        bubble_sort(v);
    }
}
BENCHMARK(bubble);

// 选择排序
static void select(benchmark::State &state) {
    std::vector<int> v;
    srand(time(NULL));
    for (int i = 1; i <= 50000; ++i) {
        v.emplace_back(rand() % 10000);
    }
    for (auto _ : state) {
        select_sort(v);
    }
}
BENCHMARK(select);

BENCHMARK_MAIN();
```


output

```
Run on (16 X 2900 MHz CPU s)
CPU Caches:
  L1 Data 32 KiB (x8)
  L1 Instruction 32 KiB (x8)
  L2 Unified 512 KiB (x8)
  L3 Unified 4096 KiB (x2)
Load Average: 1.73, 1.62, 1.37
***WARNING*** CPU scaling is enabled, the benchmark real time measurements may be noisy and will incur extra overhead.
-----------------------------------------------------
Benchmark           Time             CPU   Iterations
-----------------------------------------------------
bubble     3879170822 ns   3878109577 ns            1
select     1461544666 ns   1461428968 ns            1
```