# SedTrace
*A Julia code generator for marine sediment diagenetic models.*

| **Documentation**                            | **Build Status**                                                                                |
|:----------------------------------------:|:-----------------------:|
| [![][docs-stable-img]][docs-stable-url]  | [![][GHA-img]][GHA-url] |

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://jianghuidu.github.io/SedTrace.jl/dev
[GHA-img]: https://github.com/JianghuiDu/SedTrace.jl/workflows/CI/badge.svg
[GHA-url]: https://github.com/JianghuiDu/SedTrace.jl/actions

## Installation
Download and install `Julia` first: https://julialang.org/downloads. Julia version should be 1.7 or above to use `SedTrace`.
SedTrace is not registered with the Julia package manager. Install it directly from the GitHub repository. From the Julia REPL, type `]` to enter the `Pkg` REPL mode and run

```
pkg> add https://github.com/JianghuiDu/SedTrace.jl.git
```
This will also install all the dependency packages. I recommend using `Julia for Visual Studio Code` as the language editor. Relevent information can be found at https://www.julia-vscode.org. I also suggest install the [`MKL.jl`](https://github.com/JuliaLinearAlgebra/MKL.jl) package if you want to accelarate model simulation.

## First example
Now you can use the preincluded examples to see how `SedTrace` works. Go to the directory where Julia packages are installed. Normally this should be `/users/username/.julia/packages/SedTrace`. Copy the sub-directory `/SedTrace/examples` to a directory of your own choice (`/mydirector/examples`), otherwise you won't be able to execute the examples. Now use `Visual Studio Code` to open the directory containing the example that you want to check, for example, `/mydirectory/examples/SimpleFe`. Before generating the model, remove all the pre-generated files, including the `.jl` files except `main.SimpleFe.jl`, the `.xlsx` files except `model_config.SimpleFe.xlxs` file, and anything inside the `/SimpleFe/plots` sub-directory (if there is one). Those files were pre-generated by the package creator and you will be able to generate them again later. If you don't remove them you will not be able to overwrite them during code generation.

Now open `main.SimpleFe.jl`, there is where you call `SedTrace` to generate code and run model simulation based on the inputs from `model_config.SimpleFe.xlxs`. Excute the code in the script line by line. New Julia code and Excel files will be generated and saved in the `/mydirectory/examples/SimpleFe` directory (i.e., the same ones you just deleted).


## Documentation

- [**STABLE**][docs-stable-url] &mdash; **documentation of the most recent version.**

## Project Status

The manuscript describing this package is under review at [<strong>Geoscientific Model Development</strong>](https://gmd.copernicus.org/preprints/gmd-2022-281/).

The released versions with citable doi links are available at the [<strong>Zenodo repository</strong>](https://zenodo.org/record/7225861).
