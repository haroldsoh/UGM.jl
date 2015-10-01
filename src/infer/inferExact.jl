
function inferExact(nodepot, edgepot, es::EdgeStruct)

  nnodes = size(nodepot,1)
  nedges = size(edgepot,3)

  nodebel = zeros(size(nodepot))
  edgebel = zeros(size(edgepot))
  y = ones(nnodes)
  Z = 0
  i = 1
  while true

      pot = configPotential(y,nodepot,edgepot,es)

      for n = 1:nnodes
          nodebel[n,y[n]] = nodebel[n,y[n]]+pot;
      end

      for e = 1:nedges
          n1 = es.edgeends[e,1]
          n2 = es.edgeends[e,2]
          edgebel[y[n1],y[n2],e] = edgebel[y[n1],y[n2],e]+pot
      end

      Z += pot

      for i = 1:nnodes
          y[i] += 1
          if y[i] <= es.nstates[i]
              break
          else
              y[i] = 1;
          end
      end

      if  i == nnodes && y[end] == 1
          break;
      end
  end

  nodebel = nodebel./Z;
  edgebel = edgebel./Z;
  logZ = log(Z);

  return nodebel, edgebel, logZ, Z
end
