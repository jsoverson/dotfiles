# Rust toolchain and cargo tools: rustup on latest stable, cargo-binstall, and config/cargo.nuon.

const crates = path self | path dirname | path dirname | path join config cargo.nuon

export def --env main [--headless] {
  let bin = ($env.CARGO_HOME? | default ($env.HOME | path join .cargo)) | path join bin
  # This process started before ~/.cargo/bin existed; new shells get it from config/paths.
  $env.PATH = $env.PATH | prepend $bin | uniq

  if ($bin | path join rustup | path exists) {
    ^rustup update stable
  } else {
    # Skip the check that refuses to install while another rustup (e.g. Homebrew's) is on PATH.
    with-env {RUSTUP_INIT_SKIP_PATH_CHECK: yes} {
      ^curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs
      | ^sh -s -- -y --no-modify-path --default-toolchain stable
    }
  }

  if not ($bin | path join cargo-binstall | path exists) {
    ^curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh
    | ^bash
  }
  ^cargo binstall --no-confirm ...(open $crates)

  # --no-shell: ~/.zshrc links into this repo; kache's shell setup would edit it.
  if not $headless { ^kache init --yes --no-shell }
}
