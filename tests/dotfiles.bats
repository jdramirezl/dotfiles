#!/usr/bin/env bats

setup() {
  export TEST_HOME="$BATS_TEST_TMPDIR/home"
  export TEST_CONFIG="$TEST_HOME/.config"
  export TEST_STATE="$BATS_TEST_TMPDIR/state"
  export CLI="$BATS_TEST_DIRNAME/../bin/dotfiles"
  mkdir -p "$TEST_HOME" "$TEST_CONFIG" "$TEST_STATE"
}

run_cli() {
  run env HOME="$TEST_HOME" XDG_CONFIG_HOME="$TEST_CONFIG" XDG_STATE_HOME="$TEST_STATE" "$CLI" "$@"
}

@test "install is dry-run by default" {
  run_cli install
  [ "$status" -eq 0 ]
  [ ! -e "$TEST_HOME/.zshrc" ]
  [[ "$output" == *"dry run only"* ]]
}

@test "install creates only manifest links" {
  run_cli install --apply
  [ "$status" -eq 0 ]
  [ -L "$TEST_HOME/.zshrc" ]
  [ -L "$TEST_HOME/.zsh" ]
  [ -L "$TEST_CONFIG/nvim" ]
  [ -L "$TEST_CONFIG/wezterm" ]
  [ -L "$TEST_CONFIG/starship.toml" ]
  [ -L "$TEST_CONFIG/mise" ]
  [ -L "$TEST_HOME/.wezterm.lua" ]
}

@test "install is idempotent" {
  run_cli install --apply
  [ "$status" -eq 0 ]
  first_count="$(find "$TEST_STATE/dotfiles/backups" -type f | wc -l | tr -d ' ')"
  run_cli install --apply
  [ "$status" -eq 0 ]
  second_count="$(find "$TEST_STATE/dotfiles/backups" -type f | wc -l | tr -d ' ')"
  [ "$first_count" = "$second_count" ]
}

@test "install backs up a conflicting target" {
  printf 'old config\n' > "$TEST_HOME/.zshrc"
  run_cli install --apply
  [ "$status" -eq 0 ]
  [ -L "$TEST_HOME/.zshrc" ]
  run grep -RIl 'old config' "$TEST_STATE/dotfiles/backups"
  [ "$status" -eq 0 ]
}

@test "uninstall removes only owned links" {
  run_cli install --apply
  [ "$status" -eq 0 ]
  rm "$TEST_HOME/.zshrc"
  ln -s "$BATS_TEST_TMPDIR/foreign" "$TEST_HOME/.zshrc"
  run_cli uninstall --apply
  [ "$status" -eq 0 ]
  [ -L "$TEST_HOME/.zshrc" ]
  [ ! -e "$TEST_CONFIG/nvim" ]
}

@test "secret checker rejects private keys without printing values" {
  fixture="$BATS_TEST_TMPDIR/id_rsa"
  printf '%s\n' '-----BEGIN OPENSSH PRIVATE KEY-----' 'redacted-test-value' > "$fixture"
  run "$BATS_TEST_DIRNAME/../scripts/secret-check" "$fixture"
  [ "$status" -ne 0 ]
  [[ "$output" == *"sensitive filename"* ]]
  [[ "$output" != *"redacted-test-value"* ]]
}

@test "backup snapshots are private" {
  run_cli install --apply
  [ "$status" -eq 0 ]
  snapshot="$BATS_TEST_TMPDIR/snapshot"
  run_cli backup --output "$snapshot"
  [ "$status" -eq 0 ]
  [ "$(stat -f '%Lp' "$snapshot")" = "700" ]
  [ -e "$snapshot/config/.zshrc" ]
}

@test "sync and update are dry-run by default" {
  printf 'legacy local value\n' > "$TEST_HOME/.zshrc"
  before="$(shasum "$BATS_TEST_DIRNAME/../config/.zshrc" | cut -d' ' -f1)"
  run_cli sync
  [ "$status" -eq 0 ]
  run_cli update
  [ "$status" -eq 0 ]
  after="$(shasum "$BATS_TEST_DIRNAME/../config/.zshrc" | cut -d' ' -f1)"
  [ "$before" = "$after" ]
}

@test "dependency profiles exclude hardware unless explicitly selected" {
  fake_bin="$BATS_TEST_TMPDIR/bin"
  log="$BATS_TEST_TMPDIR/brew.log"
  mkdir -p "$fake_bin"
  cat > "$fake_bin/brew" <<'EOF'
#!/usr/bin/env bash
printf '%s\n' "$*" >> "$BREW_TEST_LOG"
exit 0
EOF
  chmod +x "$fake_bin/brew"

  run env HOME="$TEST_HOME" PATH="$fake_bin:/usr/bin:/bin" BREW_TEST_LOG="$log" "$CLI" deps check --profile all
  [ "$status" -eq 0 ]
  grep -q 'Brewfile.desktop' "$log"
  ! grep -q 'Brewfile.hardware' "$log"

  run env HOME="$TEST_HOME" PATH="$fake_bin:/usr/bin:/bin" BREW_TEST_LOG="$log" "$CLI" deps install --profile hardware
  [ "$status" -ne 0 ]

  run env HOME="$TEST_HOME" PATH="$fake_bin:/usr/bin:/bin" BREW_TEST_LOG="$log" "$CLI" deps install --profile hardware --confirm-hardware
  [ "$status" -eq 0 ]
  grep -q 'Brewfile.hardware' "$log"
}
