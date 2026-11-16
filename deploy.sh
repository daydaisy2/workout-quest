#!/bin/sh
# 운동 퀘스트 PWA → GitHub Pages 배포 (저장소가 이미 존재한다는 전제)
# 사용: sh deploy.sh
set -e
export HTTPS_PROXY="$GIT_CONFIG_VALUE_0"
export HTTP_PROXY="$GIT_CONFIG_VALUE_0"
export SSL_CERT_FILE=/etc/pickle/forward-proxy-ca.pem

cd "$(dirname "$0")"

echo "== 1) 원격 확인 =="
git remote get-url origin 2>/dev/null || git remote add origin https://github.com/daydaisy2/workout-quest.git

echo "== 2) 푸시 =="
git push -u origin main --force

echo "== 3) Pages 활성화 =="
gh api -X POST repos/daydaisy2/workout-quest/pages \
  -f build_type=legacy -f 'source[branch]=main' -f 'source[path]=/' 2>&1 || \
gh api -X PUT repos/daydaisy2/workout-quest/pages \
  -f build_type=legacy -f 'source[branch]=main' -f 'source[path]=/' 2>&1 || true

echo "== 4) 상태 =="
gh api repos/daydaisy2/workout-quest/pages 2>&1 || true
