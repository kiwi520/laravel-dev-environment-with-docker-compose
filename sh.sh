#!/bin/bash

# 绿色文本的ANSI转义码
GREEN='\033[32m'
# 重置颜色的ANSI转义码
RESET='\033[0m'

# 定义项目目录
PROJECT_DIR="/var/www/html/blog"

# 确保脚本出错时停止执行
set -e

# 检查是否传入参数
if [ -z "$1" ]; then
    echo "请提供一个操作参数！"
    echo "可用的操作: update, migrate, cache"
    exit 1
fi

# 根据传入的参数执行不同的操作
case "$1" in
    install)
        echo -e "执行 Composer install 拉取项目依赖包"
        docker-compose run -w ${PROJECT_DIR} --rm composer install
        ;;
    remove)
        echo -e "执行 Composer remove 删除依赖包: ${GREEN}$2${RESET}"
        docker-compose run -w ${PROJECT_DIR} --rm composer remove "$2" $3
        ;;
    require)
        echo -e "执行 Composer require 拉取依赖: ${GREEN}$2${RESET}"
        docker-compose run -w ${PROJECT_DIR} --rm composer require "$2"
        ;;

    update)
        echo "执行 Composer 更新..."
        docker-compose run -w ${PROJECT_DIR} --rm composer update
        ;;
    art-migrate)
        echo "执行数据库迁移..."
        docker-compose exec php php ${PROJECT_DIR}/artisan migrate --force
        ;;
    art-cache)
        echo "清理缓存..."
        docker-compose run -w ${PROJECT_DIR} --rm artisan cache:clear
        docker-compose run -w ${PROJECT_DIR} --rm artisan config:clear
        docker-compose run -w ${PROJECT_DIR} --rm artisan route:clear
        docker-compose run -w ${PROJECT_DIR} --rm artisan view:clear
        ;;
    artisan-optimize)
        echo "执行优化命令..."
        docker-compose run -w ${PROJECT_DIR} --rm artisan optimize
        ;;
    *)
        echo "未知操作: $1"
        echo "可用的操作: artisan-update, artisan-migrate, artisan-cache, artisan-optimize"
        exit 1
        ;;
esac

echo "操作完成！"