function decodeExact(nodepot, edgepot, es::EdgeStruct)
  nnodes = size(nodepot, 1)
  nedges = size(edgepot,3)

  y = ones(nnodes, 1)
  maxpot = -1;
  besty = copy(y)
  i = 1
  while true
    pot = configPotential(y,nodepot,edgepot,es);

    # max comparison
    if pot > maxpot
      maxpot = pot
      besty = copy(y)
    end

    for i = 1:nnodes
        y[i] = y[i] + 1;
        if y[i] <= es.nstates[i]
            break
        else
            y[i] = 1
        end
    end

    if  i == nnodes && y[end] == 1
        break
    end
  end
  return besty
end
