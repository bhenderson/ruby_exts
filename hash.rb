class Hash
  def assoc *keys
    self.select {|k,v| keys.include? k}
  end
end
