#!/bin/bash
# 网络守护脚本（独立于原始登录脚本）


LOG_FILE="/var/log/BITsrun.log"
ORIGINAL_SCRIPT="/home/netlogin/bitsrun.sh"  # 原始脚本绝对路径
PING_TARGETS=("www.baidu.com")            # 双目标检测[2,5](@ref)
RETRY_THRESHOLD=30                                   # 失败重试次数
CHECK_INTERVAL=600                                   # 常规检测间隔
RELOGIN_INTERVAL=60				#relogin
CMD="login"
ACCOUNT="*****"
PASSWORD="******"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

network_available() {
    for target in "${PING_TARGETS[@]}"; do
        if ping -c 1 -W 3 "$target" >/dev/null 2>&1; then
            log "网络连通性验证成功：$target"
            return 0
        fi
    done
    log "所有检测目标均无法访问"
    return 1
}


execute_login() {
    log "触发原始登录脚本：$ORIGINAL_SCRIPT"
    bash "$ORIGINAL_SCRIPT logout"
    if ! bash "$ORIGINAL_SCRIPT" "$CMD" "$ACCOUNT" "$PASSWORD"; then
        log "原始脚本执行失败"

    fi
}

main_loop() {
    while true; do
        if network_available; then
            sleep "$CHECK_INTERVAL"
        else
            for ((i=1; i<=RETRY_THRESHOLD; i++)); do
                execute_login
                if network_available; then
                    log "网络恢复成功，共尝试 $i 次"
                    break
		 else
		    sleep "$RELOGIN_INTERVAL"
                fi
            done
        fi
    done
}

main_loop
