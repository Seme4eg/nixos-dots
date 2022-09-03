let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKNMu4qZ3UH/F2qH9b2dkiujAttr/IvQZVJcBtntYhJo 418@duck.com";
in
{
  "syncthing-key.age".publicKeys = [ key ];
  "syncthing-cert.age".publicKeys = [ key ];
}
