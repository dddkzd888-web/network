#!/bin/sh
set -e
UUID=${UUID:-6bc83822-b06d-4e3c-aa89-71a034918750}
WS_PATH=${WS_PATH:-/102203a7de27}
PORT=${PORT:-8080}

mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [{ "id": "$UUID", "level": 0 }],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "$WS_PATH" }
      }
    }
  ],
  "outbounds": [{ "protocol": "freedom" }]
}
EOF

echo "xray listening on port $PORT, ws path $WS_PATH"
exec /usr/bin/xray run -c /etc/xray/config.json
