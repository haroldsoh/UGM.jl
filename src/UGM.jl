module UGM
  # exports
  export EdgeStruct

  export configPotential

  export sampleDiscrete
  export sampleExact

  export decodeExact

  export inferExact


  # includes

  include("misc/edgeStruct.jl")
  include("misc/configPotential.jl")
  
  include("sample/sampleDiscrete.jl")
  include("sample/sampleExact.jl")

  include("decode/decodeExact.jl")

  include("infer/inferExact.jl")

end
