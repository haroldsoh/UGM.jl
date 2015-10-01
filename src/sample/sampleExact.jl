function sampleExact(nodepot, edgepot, es::EdgeStruct; Z = -1, nsamples=-1)

  nnodes = size(nodepot, 1)
  nedges = size(edgepot, 3)

  if nsamples < 0
    nsamples = es.maxiter
  end

  samples = zeros(int(nsamples),int(nnodes));

  if Z < 0
    nothing, nothing, nothing, Z = inferExact(nodepot, edgepot, es)
  end

  for s = 1:nsamples
     samples[s,:] = sampleY(nodepot,edgepot,es,Z)
  end
  return samples
end

function sampleY(nodepot, edgepot, es::EdgeStruct, Z)

  nnodes = size(nodepot,1)
  nedges = size(edgepot,3)

  y = ones(1,int(nnodes));
  cumpot = 0
  U = rand()
  i = 1
  while true

      pot = configPotential(y, nodepot, edgepot, es::EdgeStruct)
      cumpot = cumpot + pot;

      if cumpot/Z >= U
          break;
      end

      # next y
      for i = 1:nnodes
          y[i] = y[i] + 1;
          if y[i] <= es.nstates[i]
              break
          else
              y[i] = 1
          end
      end
  end
  return y
end
