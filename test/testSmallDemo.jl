# Testing the Small Demo
# Copyright (c) 2015 Harold Soh

# based on MATLAB code by Mark Schmidt
# For more details, see: http://www.cs.ubc.ca/~schmidtm/Software/UGM/small.html

include("../src/UGM.jl")

using UGM
using Base.Test

include("testUtils.jl")

# ======================================
# Simple Independent Node Test
# ======================================
srand(0)
nodepot = [ 1 3;
            9 1;
            1 3;
            9 1 ]

nsamples = 100;
samples = zeros(4, nsamples)
for i = 1:4
  for s = 1:nsamples
    samples[i,s] = sampleDiscrete(nodepot[i,:]/sum(nodepot[i,:]));
  end
end

sum_samples = sum(samples,2)
println("Sum Samples: ", sum_samples')
gold_result = [172; 107; 168; 110] # at seed 0
@test all(sum_samples .== gold_result)
print("Independent Nodes Test: ")
printPassed()

# ======================================
# Set up Dependent Nodes
# ======================================
nnodes = 4
nstates = 2

edgelist =  [ 1 2;
              2 1;
              2 3;
              3 2;
              3 4;
              4 3]

# Make Edge Structure
es = EdgeStruct(edgelist = edgelist, nstates = nstates, maxiter = 25)

# edgestruct tests
@test es.edgeends == [1 2; 2 3; 3 4]
@test es.edgedict[1] == Set([2])
@test es.edgedict[2] == Set([1,3])
@test es.edgedict[3] == Set([2,4])
@test es.edgedict[4] == Set([3])
@test es.nnodes == 4
@test es.nedges == 3
@test all(es.nstates .== [2.0; 2.0; 2.0; 2.0])
@test es.maxiter == 25
print("Edge Structure Test: ")
printPassed()

# Node potentials
nodepot = [1 3;
          9 1;
          1 3;
          9 1]

# Edge potentials
maxstate = maximum(es.nstates);
edgepot = zeros( int(maxstate), int(maxstate), int(es.nedges));
for e = 1:es.nedges
   edgepot[:,:,e] = [2 1 ; 1 2];
end

# ======================================
# Decoding
# ======================================
optdecoding = decodeExact(nodepot,edgepot,es)
println("Optimal Decoding: ", optdecoding')
@test all(optdecoding .== [2.0; 1.0; 1.0; 1.0])
print("Exact Decoding Test: ")
printPassed()

# ======================================
# Inference
# ======================================
nodebel,edgebel,logZ,Z = inferExact(nodepot,edgepot,es)

@test nodebel == [0.3596306068601583 0.6403693931398416
                   0.8430079155672823 0.15699208443271767
                   0.4862796833773087 0.5137203166226912
                   0.8810026385224274 0.11899736147757256]

@test edgebel[:,:,1] == [0.33720316622691293 0.022427440633245383
                         0.5058047493403693 0.1345646437994723]

@test edgebel[:,:,2] ==  [0.45118733509234826 0.391820580474934
                          0.03509234828496042 0.12189973614775726]

@test edgebel[:,:,3] == [0.46068601583113455 0.02559366754617414
                         0.4203166226912929 0.09340369393139841]

@test_approx_eq_eps(logZ, 8.240121298, 1e-8)
print("Exact Inference Test: ")
printPassed()

# ======================================
# Sampling Test
# ======================================
es.maxiter = 100
samples = sampleExact(nodepot,edgepot,es)
@test all(samples[1,:] .== [2.0 1.0 2.0 2.0])
@test all(samples[4,:] .== [2.0 2.0 2.0 1.0])
@test all(samples[100,:] .== [2.0 1.0 2.0 1.0])
print("Exact Sampling Test: ")
printPassed()

# println(samples)
# using Gadfly
# spy(samples)
