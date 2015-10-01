function configPotential(y, nodepot, edgepot, es::EdgeStruct)
  nnodes = size(nodepot, 1)
  nedges = size(es.edgeends,1)
  pot = 1
  for n = 1:nnodes
    pot = pot*nodepot[n, y[n]]
  end

  for e = 1:nedges
    i = es.edgeends[e,1]
    j = es.edgeends[e,2]
    pot = pot*edgepot[y[i],y[j],e];
  end
  return pot
end
