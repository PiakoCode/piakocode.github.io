Count the num of files.

```rust
use std::{
    fs,
    sync::{Arc, Mutex},
    time::Instant,
};

const PATH: &str = "./";

fn main() -> Result<(), std::io::Error> {
    // 计时
    let now = Instant::now();

    // 总数 Arc::new(i32) 为只读，所以使用Arc::new(Mutex::new(0))
    // 
    let sum = Arc::new(Mutex::new(0));
    
    // 搜索
    search(PATH, Arc::clone(&sum))?;

    let elapsed_time = now.elapsed();
    println!("{:#?}", elapsed_time);
    println!("count: {}", *sum.lock().unwrap());
    Ok(())
}

fn search(path: &str, sum: Arc<Mutex<i32>>) -> Result<(), std::io::Error> {
    let files = fs::read_dir(path)?;
    for file in files {
        match file {
            Ok(file) => {
                let name = file.file_name();
                println!("file: {}", name.clone().into_string().unwrap());
                if file.file_type().unwrap().is_dir() {
                    search(
                        &(path.to_string() + &name.into_string().unwrap() + "/"),
                        sum.clone(),// .clone() 引用计数 + 1
                    )?;
                } else {
                    *sum.lock().unwrap() += 1; // value + 1
                }
            }
            Err(e) => return Err(e),
        }
    }
    Ok(())
}

```