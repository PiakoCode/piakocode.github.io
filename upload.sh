#!/usr/bin/bash

BLUE='\033[1;34m'  # 蓝色
GREEN='\033[0;32m' # 绿色
NC='\033[0m'       # 恢复默认颜色

cd /home/Piako/Documents/markdown笔记

echo -e "\n${BLUE}--------Start--------\n${NC}"
git status

git add .
echo -e "\n${GREEN}Add all complete.\n${NC}"

LANG=zh_CN.UTF-8 git commit -m "$(date)"
echo -e "${GREEN}Commit complete.\n${NC}"

git push origin main
git push github main
echo -e "${GREEN}-----Push complete!-----\n${NC}"
