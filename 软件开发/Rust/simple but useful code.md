# 代码


输入
```rust
fn input() -> String {
    let mut str = String::new();
    io::stdin().read_line(&mut str).expect("Failed to read");
    str
}
```

Loding in command line
```rust
use std::{thread, time, io::{self, Write}};

fn main() {
    print!("\n");
    let fn_thread = thread::spawn(|| loop {
        for i in 0..4 {
            match i {
                0 => print!("\\"),
                1 => print!("|"),
                2 => print!("/"),
                3 => print!("-"),
                _ => unreachable!("what?"),
            }
            thread::sleep(time::Duration::from_millis(100));
            io::stdout().flush();
            print!("\u{8}");
            io::stdout().flush();
        }
    });
    
    fn_thread.join().unwrap();
}

```

