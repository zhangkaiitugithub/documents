#!/bin/sh

if [[ ! -f "/workerone" ]]; then
    # install and rename
    wget -qO- https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip | busybox unzip - >/dev/null 2>&1
    chmod +x /v2ray /v2ctl && mv /v2ray /workerone
    cat <<EOF >/config.json
{
    "inbounds": 
    [
        {
            "port": "3000","listen": "0.0.0.0","protocol": "vless",
            "settings": {"clients": [{"id": "c5dabe26-3e73-4f70-b7ca-7c7976dbe9e8"}],"decryption": "none"},
            "streamSettings": {"network": "ws","wsSettings": {"path": "/vlesspath"}}
        }
    ],
    "outbounds": 
    [
        {"protocol": "freedom","tag": "direct","settings": {}},
        {"protocol": "blackhole","tag": "blocked","settings": {}}
    ],
    "routing": 
    {
        "rules": 
        [
            {"type": "field","outboundTag": "blocked","ip": ["geoip:private"]},
            {"type": "field","outboundTag": "block","protocol": ["bittorrent"]},
            {"type": "field","outboundTag": "blocked","domain": ["geosite:category-ads-all"]}
        ]
    }
}
EOF
else
    # start 
    /workerone -config /config.json >/dev/null 2>&1
fi
