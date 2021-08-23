# ML Application Deveploment with GNN

## Clienttools
HPCC Systems Clienttools is required to development ECL and GNN application with VSCode or ECLIDE.
ECLIDE comes with Clienttools but VSCode doesn't so you need install it on your local environment

For detail reference https://cdn.hpccsystems.com/releases/CE-Candidate-8.2.10/docs/EN_US/HPCCClientTools_EN_US-8.2.10-1.pdf

Genrally you need download Clienttools from https://hpccsystems.com/download#HPCC-Platform and install it.

- On Windows it should be installed to C:\\Program Files\\HPCCSystems\\<version> for 64bit
- On Unix it should be installed to /opt/HPCCSystems/


## Install ML Bundles
Make sure "ecl" on environment variable PATH or you need full path of ecl
```code
ecl bundle install http://github.com/hpcc-systems/ML_Core.git
ecl bundle install http://github.com/hpcc-systems/PBblas.git
ecl bundle install http://github.com/hpcc-systems/GNN.git
```

[GNN Bundle Update](./bundle/README.md)

