{self, ...} @ inputs: {
  # for now only one host
  nohomehost = self.lib.mkHost "nohomehost";
}
