# Placeholder: upstream publishes macOS/Windows releases only — no Linux
# assets yet. Real packaging will be a source build; linuxAssets = false
# documents this at the metadata level until then.
{
  mk-craft-app,
}:
mk-craft-app {
  pname = "artcraft";
  version = "0.41.0";
  repo = "storytold/artcraft";
  description = "Intentional crafting engine for artists, designers, and filmmakers";
  linuxAssets = false;
}
