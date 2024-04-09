# C语言

## 线程

### pthread_create

头文件: `pthread.h`

`pthread_create`函数的作用是创建一个新的线程，并让这个线程开始执行`start_routine`函数。新线程与调用`pthread_create`的线程（通常称为主线程）并行执行，它们拥有相同的进程空间，但有各自独立的线程栈。

```c
int pthread_create(pthread_t *thread, const pthread_attr_t *attr,
                   void *(*start_routine) (void *), void *arg);
```

参数说明：

- `thread`：是一个指向`pthread_t`类型的指针，用于存储新创建线程的标识符。通过这个标识符，您可以在以后对线程进行操作，如等待线程的结束、终止线程等。

- `attr`：是一个指向`pthread_attr_t`类型的指针，用于指定线程的属性。如果传递NULL，则使用默认线程属性。

- `start_routine`：是一个指向函数的指针，这个函数将作为新线程的入口点。新线程将从这个函数开始执行，并在函数返回时终止。

- `arg`：是传递给`start_routine`函数的参数，可以是一个指针，它将被传递给`start_routine`函数。


以下是一个简单的示例，演示如何使用`pthread_create`创建一个新线程：

```c
#include <stdio.h>
#include <pthread.h>

void* thread_function(void* arg) {
    int thread_id = *(int*)arg;
    printf("Hello from thread %d\n", thread_id);
    pthread_exit(NULL);
}

int main() {
    pthread_t thread_id;
    int arg = 1;

    // 创建线程
    if (pthread_create(&thread_id, NULL, thread_function, &arg) != 0) {
        fprintf(stderr, "Error creating thread.\n");
        return 1;
    }

    // 等待线程结束
    pthread_join(thread_id, NULL);

    printf("Main thread exiting.\n");
    return 0;
}
```

在这个例子中，`pthread_create`创建了一个新线程，并执行`thread_function`函数。主线程使用`pthread_join`函数等待新线程的结束，以确保新线程的执行完成后再继续执行主线程。


### pthread_join

`pthread_join`是C语言中`pthread`库中的一个函数，用于等待一个线程的结束并收集其返回值（如果有）。它的原型如下：

```c
int pthread_join(pthread_t thread, void **retval);
```

- `thread`：是要等待的线程的标识符。这是在调用`pthread_create`创建线程时返回的值。
- `retval`：是一个指向指针的指针，用于存储线程的返回值。线程的返回值是一个`void*`类型，因此需要使用指针的指针来接收它。

`pthread_join`函数的作用是阻塞当前线程，直到指定的线程（通过`thread`参数传递）执行结束。一旦线程执行结束，`pthread_join`会返回，并将线程的返回值存储在`retval`指向的内存位置。

```c
pthread_join(p1, NULL);
```


请注意，在使用`pthread_join`时，确保目标线程确实是可连接的。如果线程是分离状态（通过`pthread_detach`函数设置），或者已经被其他线程连接，那么`pthread_join`会返回错误。因此，在使用`pthread_join`之前，请确保目标线程处于适当的状态。


## 锁

### 自旋锁

### 互斥锁

使用互斥锁需要包含头文件`<pthread.h>`，并使用以下函数来初始化、加锁和解锁互斥锁：

1. `pthread_mutex_init`: 用于初始化互斥锁。
2. `pthread_mutex_lock`: 用于加锁互斥锁。如果锁已被其他线程占用，则当前线程会阻塞，直到锁可用。
3. `pthread_mutex_trylock`: 尝试加锁互斥锁，如果锁已被其他线程占用，该函数会立即返回，并不会阻塞线程。
4. `pthread_mutex_unlock`: 用于解锁互斥锁。
5. `pthread_mutex_destroy`: 销毁互斥锁。

以下是一个使用互斥锁的简单示例：

```c
#include <stdio.h>
#include <pthread.h>

pthread_mutex_t my_mutex;

void* thread_function(void* arg) {
    int thread_id = *((int*)arg);

    // 加锁
    pthread_mutex_lock(&my_mutex);

    // 临界区代码
    printf("Thread %d is in critical section.\n", thread_id);
    // 执行一些需要保护的操作

    // 解锁
    pthread_mutex_unlock(&my_mutex);

    pthread_exit(NULL);
}

int main() {
    pthread_t threads[2];
    int thread_args[2] = {1, 2};

    // 初始化互斥锁
    pthread_mutex_init(&my_mutex, NULL);

    for (int i = 0; i < 2; ++i) {
        pthread_create(&threads[i], NULL, thread_function, (void*)&thread_args[i]);
    }

    for (int i = 0; i < 2; ++i) {
        pthread_join(threads[i], NULL);
    }

    // 销毁互斥锁
    pthread_mutex_destroy(&my_mutex);

    printf("All threads have finished.\n");
    return 0;
}
```

在上述示例中，我们使用`pthread_mutex_init`初始化互斥锁，然后在每个线程的临界区使用`pthread_mutex_lock`加锁，临界区结束后使用`pthread_mutex_unlock`解锁。

互斥锁适用于临界区较长或者线程竞争较激烈的情况，因为它可以阻塞等待锁的释放，从而避免了忙等带来的资源浪费。

## 条件变量

在C语言中，`pthread`库提供了条件变量（`pthread_cond_t`）用于多线程编程中的线程同步。条件变量通常用于实现线程之间的等待/通知机制，用于解决某些特定问题，如生产者-消费者问题、读写锁等。条件变量需要与互斥锁（`pthread_mutex_t`）一起使用，以确保线程安全。

条件变量有三个主要操作：

1. `pthread_cond_init`：用于初始化条件变量。
2. `pthread_cond_wait`：线程调用该函数进入等待状态，等待条件变量满足特定条件。
3. `pthread_cond_signal`：用于通知等待在条件变量上的一个线程，使其从等待状态返回（并继续执行）。
4. `pthread_cond_broadcast`：用于通知所有等待在条件变量上的线程。

以下是条件变量的基本使用示例：

```c
#include <stdio.h>
#include <pthread.h>

pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t cond = PTHREAD_COND_INITIALIZER;

int shared_data = 0;

void* thread_func(void* arg) {
    pthread_mutex_lock(&mutex);

    // 等待条件变量满足特定条件
    while (shared_data < 10) {
        pthread_cond_wait(&cond, &mutex);
    }

    printf("Thread received the signal. Shared data: %d\n", shared_data);

    pthread_mutex_unlock(&mutex);

    return NULL;
}

int main() {
    pthread_t tid;
    pthread_create(&tid, NULL, thread_func, NULL);

    pthread_mutex_lock(&mutex);
    // 模拟一些处理，此处可以是生产者-消费者模式中的生产数据过程
    shared_data = 10;

    // 发送信号通知等待的线程
    pthread_cond_signal(&cond);
    pthread_mutex_unlock(&mutex);

    pthread_join(tid, NULL);

    pthread_cond_destroy(&cond);
    pthread_mutex_destroy(&mutex);

    return 0;
}
```

在这个例子中，主线程创建了一个新的线程，新线程在条件变量`cond`上等待。主线程修改了`shared_data`的值，并通过调用`pthread_cond_signal`发送信号通知等待的线程。等待的线程在接收到信号后继续执行。

需要注意的是，条件变量应该与互斥锁一起使用。等待条件时，线程会释放互斥锁，当收到信号时，再重新获得互斥锁。这样做是为了防止出现竞态条件（race condition）。

使用条件变量时，需要仔细设计等待条件和发送信号的逻辑，以免出现线程死锁或条件不满足等问题。

## 信号量

在 C 语言中，信号量（Semaphore）是一种用于线程同步和互斥的同步原语。它是一个计数器，用于控制多个线程对共享资源的访问。信号量允许线程在执行临界区代码之前先获取一个信号量资源，如果信号量资源不可用，则线程可能会被阻塞等待直到资源可用。

常见的信号量类型包括二进制信号量和计数信号量：

1. 二进制信号量：也称为互斥锁（Mutex），它只有两个状态：0 和 1。用于实现互斥，确保在任何时刻只有一个线程可以访问共享资源。

2. 计数信号量：允许一定数量的线程同时访问共享资源。计数信号量的初始值表示可同时访问该资源的线程数目。

C 语言中，信号量的操作通常由标准库或系统调用提供。在 POSIX 环境下，可以使用 POSIX Threads (pthread) 库中的信号量相关函数。

常见的信号量相关函数包括：

1. `sem_init`：用于初始化一个信号量。
2. `sem_destroy`：用于销毁一个信号量。
3. `sem_wait`函数用于尝试获取一个信号量，并阻塞当前线程（或者将当前线程置于睡眠状态），直到信号量可用（非零）。一般用于线程在访问共享资源之前获取一个信号量（值减少1），以确保资源的独占性。
4. `sem_post`函数用于释放一个信号量，使得其值增加1。当有其他线程在调用`sem_wait`等待这个信号量时，调用`sem_post`会唤醒其中一个等待的线程，使其能够继续执行。
5. `sem_trywait`：类似于`sem_wait`，但是在资源不可用时立即返回，而不是阻塞线程。
6. `sem_timedwait`：类似于`sem_wait`，但是可以设置一个超时时间，在超时后返回。

以下是一个简单的示例代码，展示了如何使用 POSIX Threads 库中的信号量来实现线程同步和互斥：

```c
#include <stdio.h>
#include <pthread.h>
#include <semaphore.h>

#define NUM_THREADS 5

int shared_resource = 0;
sem_t semaphore;

void* thread_function(void* arg) {
    int thread_id = *(int*)arg;
    
    sem_wait(&semaphore); // 等待信号量 P
    printf("线程 %d 正在临界区内。\n", thread_id);
    
    // 访问共享资源
    shared_resource++;
    printf("共享资源值：%d\n", shared_resource);
    
    sem_post(&semaphore); // 释放信号量 V
    
    pthread_exit(NULL);
}

int main() {
    pthread_t threads[NUM_THREADS];
    int thread_ids[NUM_THREADS];
    sem_init(&semaphore, 0, 1); // 初始化信号量，初始值为1（二进制信号量）

    for (int i = 0; i < NUM_THREADS; i++) {
        thread_ids[i] = i;
        pthread_create(&threads[i], NULL, thread_function, &thread_ids[i]);
    }

    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    sem_destroy(&semaphore); // 销毁信号量

    return 0;
}

```

在这个例子中，我们创建了5个线程，它们共享一个整数变量 `shared_resource`。通过信号量 `semaphore` 来实现对 `shared_resource` 的互斥访问，确保在任意时刻只有一个线程可以进入临界区执行代码，从而避免了竞态条件（Race Condition）。

P失败时立即睡眠等待

执行V时，唤醒任意等待的线程

所以信号量的初始化值为1时，信号量实际就成为了互斥锁
