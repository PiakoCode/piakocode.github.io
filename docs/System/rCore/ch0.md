# ch0


丢弃内核可执行文件中的元数据得到内核镜像
```shell
rust-objcopy --strip-all target/riscv64gc-unknown-none-elf/release/os -O binary target/riscv64gc-unknown-none-elf/release/os.bin
```

在 `os` 目录下通过以下命令启动 Qemu 并加载 RustSBI 和内核镜像：
```shell
qemu-system-riscv64 \
    -machine virt \
    -nographic \
    -bios ../bootloader/rustsbi-qemu.bin \
    -device loader,file=target/riscv64gc-unknown-none-elf/release/os.bin,addr=0x80200000 \
    -s -S
```

使用gdb监听1234端口
```shell
riscv64-unknown-elf-gdb \
    -ex 'file target/riscv64gc-unknown-none-elf/release/os' \
    -ex 'set arch riscv:rv64' \
    -ex 'target remote localhost:1234'
```


安装辅助工具
```shell
wget https://static.dev.sifive.com/dev-tools/riscv64-unknown-elf-gcc-8.3.0-2020.04.1-x86_64-linux-ubuntu14.tar.gz
tar xvf riscv64-unknown-elf-gcc-8.3.0-2020.04.1-x86_64-linux-ubuntu14.tar.gz
mv riscv64-unknown-elf-gcc-8.3.0-2020.04.1-x86_64-linux-ubuntu14 riscv64-utils
rm riscv64-unknown-elf-gcc-8.3.0-2020.04.1-x86_64-linux-ubuntu14.tar.gz

```


快速打开docker环境
```shell
docker restart rCore && docker exec -it rCore /bin/bash -c "cd /mnt/os; bash"
```