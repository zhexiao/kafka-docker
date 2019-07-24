#!/usr/bin/env bash

function update_config() {
    # 更新配置文件的函数
    env_name=$1
    env_val=$2
    config_file=$3

    echo "[Configuring] $env_name in $config_file"
    
    # 如果配置名在文件里面找到了，则直接替换
    if grep -E  "^#?$env_name=.*" "$config_file"
    then
    	echo "find env in file"
    fi
}

# 不允许出现的配置参数
NOT_ALLOWED_ENV="|KAFKA_VERSION|KAFKA_HOME|KAFKA_DEBUG|KAFKA_GC_LOG_OPTS|KAFKA_HEAP_OPTS|KAFKA_JMX_OPTS|KAFKA_JVM_PERFORMANCE_OPTS|KAFKA_LOG|KAFKA_OPTS|"

# 循环系统环境变量
for env_var in $(env)
do

env_name=$(echo "$env_var" | cut -d "=" -f 1)

# 使用双括号可以用正则匹配符
if [[ $NOT_ALLOWED_ENV = *"|$env_name|"* ]]
then
    echo "[Invalid Env] $env_name"
    continue
fi

if [[ $env_name =~ ^KAFKA_ ]]
then
    env_val=$(echo "$env_var" | cut -d "=" -f 2)
    update_config "$env_name" "$env_val" "server.properties.3"
fi

done
