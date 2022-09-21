{self, ...} @ inputs: {
  # for now only one host
  # XXX: duplicate username setting (how to get access to config.username here?)
  nohomehost = self.lib.mkHost "nohomehost" "nohome" self.system;
}
