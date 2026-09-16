# Migration notes for the proposed SedTrace 2.0 release

These changes are being developed separately from the stable `master` branch.
The package version is left at 1.3.3 until release preparation; this document
does not announce or publish a new release.

## Requirements and dependencies

- Julia 1.10 or a later Julia 1.x release is required.
- Dependency bounds target the updated SciML ecosystem. Existing environments
  may need to be resolved again; keep a separate environment for stable SedTrace.
- SymPyPythonCall replaces SymPy/PyCall. Internal symbolic calls retain the
  `SymPy` alias, but Python objects now belong to PythonCall, not PyCall.
  CondaPkg manages the Python environment; system `pip install sympy` is no
  longer part of CI setup.
- LSODA and the unused direct Conda dependency are removed.
- SparseDiffTools is replaced by DifferentiationInterface, ADTypes, and
  SparseMatrixColorings. Do not rely on SedTrace reexporting SparseDiffTools
  APIs; import that package directly in applications that still use it.
- The existing `matrix_colors` and three-argument-residual `JacVec` helpers
  remain available. No new ODEInterfaceDiffEq/radau support is introduced.

## Derivative callbacks

Call `SedTrace.generate_jacobian(f, prototype, u0, p0, t0)` instead of the old
three-argument constructor. Preparation is eager and buffers are reused by
that callback. Runtime `p` and `t` are passed in a call-local wrapper; Jacobian,
finite-difference, and solver JVP callbacks honor both values.

The finite-difference constructor also accepts `(f, prototype, u0, p0, t0)`;
its legacy `(f, prototype, p0)` form remains supported.

A callback is not reentrant. Concurrent solves must each own their callback,
mutable model workspace, and writable output/prototype. Mutable parameter
contents are not copied. Rebuild preparation if input types, dimensions, or
the sparsity pattern change. `modelrun` prepares derivative callbacks per solve;
callers are responsible for supplying independent mutable model workspaces.

## Solvers and preconditioners

The existing `SolverConfig` choices for Sundials and OrdinaryDiffEq remain.
OrdinaryDiffEq preconditioners now use LinearSolve's `(A, p) -> (Pl, Pr)` builder
interface. Custom integrations with the old nine-argument callback must adapt.
ILU0 refreshes its index maps when the stored sparse matrix pattern changes.
GMRES uses cold starts, and left-preconditioned solves use relative residual
stopping to avoid accepting inaccurate Newton corrections.

The selected `Rodas5P` method is now also used when preconditioning is enabled;
it previously selected `Rodas5` in that case.

## Scope

This branch starts from stable master commit `9d99b93`, not PR #95. It preserves
the existing world-age fixes, chemistry expressions, generated example/test
fixtures, notebooks, GR dependency, and current GitHub Actions versions.
Only the selected dependency and derivative/solver updates are carried forward.
Additional dependency-audit candidates are not removed in this change.
