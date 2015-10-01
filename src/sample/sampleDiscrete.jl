function sampleDiscrete(p)
  # Returns a sample from a discrete probability mass function indexed by p
  # (assumes that p is already normalized)
  r = rand()
  pcum = 0;
  for i = 1:length(p)
    pcum += p[i]
    if r <= pcum
      return i
    end
  end
  return length(p)
end
