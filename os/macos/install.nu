# macOS packages via Homebrew bundles.

const here = path self | path dirname

# Install one Brewfile (also used for the overlay's Brewfile).
export def bundle [file: string] {
  ^brew bundle install --no-upgrade --file $file
}

# Install packages for the given profile.
export def main [profile: string, --headless] {
  bundle ($here | path join Brewfile)
  if not $headless {
    # Only mas entries are expected to fail (no App Store sign-in); everything else still installs.
    try { bundle ($here | path join Brewfile.apps) } catch {
      print "warning: Brewfile.apps had failures; sign into the App Store and re-run for mas apps"
    }
  }
  if $profile == "personal" { bundle ($here | path join Brewfile.personal) }
}
