
type EdgeStruct
  edgeends::Matrix
  edgedict::Dict
  nnodes::Int
  nedges::Int
  nstates::Array
  maxiter::Int
end

function updateGraphDict!(nodes::Set, edges::Dict, e)
  for k=1:2
    i = e[k]
    j = e[k%2+1]

    @assert i != j

    push!(nodes, i)
    if haskey(edges, i)
      push!(edges[i], j)
    else
      edges[i] = Set(j)
    end
  end
end

# edge list is a mx2 matrix containing a list of edges
# e.g., [1 2; 2 3] means node 1 is connected to 2 (and 2 to 1 since undirected)
#                  and 2 is connected to 3 (and 3 to 2)
function EdgeStruct(;edgelist = zeros(), nstates = 0, maxiter=100)

  nodes = Set()
  edges = Dict{Int, Set}()
  for i = 1:size(edgelist,1)
    updateGraphDict!(nodes, edges, edgelist[i,:])
  end
  nnodes = length(nodes)

  # this section just makes sure we don't include duplicates
  # and nodes are ordered
  edgeends = nothing
  for i=1:nnodes
    for j in edges[i]
      if i < j
        edgeends = edgeends == nothing? [i j] : [ edgeends; i j ]
      end
    end
  end

  # make sure we have the right number of states
  if typeof(nstates) == Int
    nstates = zeros(nnodes, 1) + nstates
  end
  @assert size(nstates,1) == nnodes

  # return a new edge structure
  return EdgeStruct(edgeends, edges,
                    nnodes, size(edgeends,1),
                    nstates, maxiter)
end
