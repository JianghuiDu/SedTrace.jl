# SedTrace
*A Julia package to generate and run models of marine sediment diagenesis.*

| **Documentation**                            | **Build Status**    |
|:----------------------------------------:|:-----------------------:|
| [![][docs-stable-img]][docs-stable-url]  | [![][GHA-img]][GHA-url] |

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://jianghuidu.github.io/SedTrace.jl/dev
[GHA-img]: https://github.com/JianghuiDu/SedTrace.jl/workflows/CI/badge.svg
[GHA-url]: https://github.com/JianghuiDu/SedTrace.jl/actions

## Installation
Download and install `Julia` at https://julialang.org/downloads. Julia version should be 1.7 or above to use `SedTrace`.
`SedTrace` is not registered with the Julia package manager. Install it directly from the GitHub repository. From the Julia terminal (aka the REPL), type `]` to enter the `Pkg`  mode and run

```
pkg> add https://github.com/JianghuiDu/SedTrace.jl.git
```
This will also install all the dependency packages. I also suggest installing the [`MKL`](https://github.com/JuliaLinearAlgebra/MKL.jl) package if you want to accelerate model simulation (at the moment this may not work on macOS with Apple silicon chips).

I suggest using [`Julia for Visual Studio Code`](https://www.julia-vscode.org) as the language editor. Check the link to see how to install and configure the Julia language extension in `Visual Studio Code`. After installation, make sure you tell the path of Julia executable to `Visual Studio Code`. To do so, open `Visual Studio Code`, go to `File/Preferences/Settings` and search for `Julia: Executable Path`. To find the path of Julia executable, you can enter `Sys.BINDIR` from the Julia REPL. The output is the directory containing the executable. You need to append the name of the executable when writing the path, for example `C:/Users/username/AppData/Local/Programs/julia-1.9.2/bin/julia.exe` on Windows, or `/Applications/Julia-1.9.app/Contents/Resources/julia/bin/julia` on macOS.

## First example
Now you can use the pre-included examples to see how `SedTrace` works. Go to the directory where Julia packages are installed. Normally this should be `/users/username/.julia/packages/SedTrace`. Copy the sub-directory `/SedTrace/examples` to a directory of your own choice (`/mydirector/examples`), otherwise you won't be able to execute the examples. Make sure you don't modify anything in the `/.julia` directory. 

Now use `Visual Studio Code` to open the directory containing the example that you want to check, for example, `/mydirectory/examples/SimpleFe`. Before generating the model, remove all the pre-generated files, including the `.jl` files except `main.SimpleFe.jl`, the `.xlsx` files except `model_config.SimpleFe.xlxs` file, and anything inside the `/SimpleFe/plots` sub-directory (if there is one). Those files were pre-generated by the package creator and you will be able to generate them again later. If you don't remove them you will not be able to overwrite them during code generation because of ownership issues.

Now open `main.SimpleFe.jl`, this is where you call `SedTrace` to generate code and run model simulations based on the inputs from `model_config.SimpleFe.xlxs`. Execute the code in the script line by line. Model code and output will be generated and saved in the `/mydirectory/examples/SimpleFe` directory (i.e., the same ones you just deleted).

For more information, see `Documentation` below.

## Documentation

- [**STABLE**][docs-stable-url] &mdash; **documentation of the most recent version.**

## Project Status

The manuscript describing this package is under review at [<strong>Geoscientific Model Development</strong>](https://gmd.copernicus.org/preprints/gmd-2022-281/).

The released versions with citable doi links are available at the [<strong>Zenodo repository</strong>](https://zenodo.org/record/7225861).
