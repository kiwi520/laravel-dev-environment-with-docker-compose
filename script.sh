#!/bin/bash

# 绿色文本的ANSI转义码
GREEN='\033[32m'
# 重置颜色的ANSI转义码
RESET='\033[0m'

# 保存当前目录
CURRENT_DIR=$(pwd)

#进入docker执行目录
cd ${CURRENT_DIR}/docker

# 定义项目目录
PROJECT_DIR="/var/www/html/blog"

# 确保脚本出错时停止执行
set -e

# 检查是否有两个及以上参数
if [ $# -lt 2 ]; then
    echo "错误: 请提供两个命令行参数."
    echo "用法: ./script.sh <操作类型> <目标>"
    exit 1
fi

# 获取命令行参数
operation=$1
target=$2


# 根据操作类型和目标执行不同的命令
case $operation in
    composer)
        case $target in
            create)
                echo -e "执行 Composer create 创建项目并拉取项目依赖包"
                docker-compose run -w ${PROJECT_DIR} --rm composer create-project laravel/laravel $3 $4
                ;;
            install)
                echo -e "执行 Composer install 拉取项目依赖包"
                docker-compose run -w ${PROJECT_DIR} --rm composer install
                ;;
            remove)
                echo -e "执行 Composer remove 删除依赖包: ${GREEN}$3${RESET}"
                docker-compose run -w ${PROJECT_DIR} --rm composer remove "$3"
                ;;
            require)
                echo -e "执行 Composer require 拉取依赖: ${GREEN}$3${RESET}"
                docker-compose run -w ${PROJECT_DIR} --rm composer require "$3"
                ;;

            update)
                echo "执行 Composer 更新..."
                docker-compose run -w ${PROJECT_DIR} --rm composer update
                ;;
            *)
                echo "无效的目标: $target"
                ;;
        esac
        ;;

    artisan)
        case $target in
              migrate)
                  echo "执行数据库迁移..."
                  docker-compose exec php php ${PROJECT_DIR}/artisan migrate --force
                  ;;
              cache)
                  echo "清理缓存..."
                  docker-compose run -w ${PROJECT_DIR} --rm artisan cache:clear
                  docker-compose run -w ${PROJECT_DIR} --rm artisan config:clear
                  docker-compose run -w ${PROJECT_DIR} --rm artisan route:clear
                  docker-compose run -w ${PROJECT_DIR} --rm artisan view:clear
                  ;;
              optimize)
                  echo "执行优化命令..."
                  docker-compose run -w ${PROJECT_DIR} --rm artisan optimize
                  ;;
            *)
                echo "无效的目标: $target"
                ;;
        esac
        ;;

    *)
        echo "无效的操作类型: $operation"
        ;;
esac
# 输出操作完成的消息
echo "操作完成！"

# 返回到原来的目录
cd "$CURRENT_DIR"