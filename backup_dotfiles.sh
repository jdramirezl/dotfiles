#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
printf 'This command only imports allowlisted configuration and never commits or pushes.\n'
exec "$ROOT/bin/dotfiles" sync "$@"
