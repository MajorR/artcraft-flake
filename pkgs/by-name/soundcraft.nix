# Placeholder: upstream repo exists but has published no releases at all
# yet. linuxAssets = false until the first release ships.
{
  mk-craft-app,
}:
mk-craft-app {
  pname = "soundcraft";
  version = "0-unreleased";
  repo = "storytold/soundcraft";
  description = "Open-source digital audio workstation — clean-room reimplementation of Pro Tools";
  linuxAssets = false;
}
