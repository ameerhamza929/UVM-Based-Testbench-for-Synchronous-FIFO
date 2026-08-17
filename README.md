# UVM-Based Testbench for Synchronous FIFO

An industry-standard UVM (Universal Verification Methodology) testbench for verifying a Synchronous FIFO, featuring TLM communication and a self-checking scoreboard.

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Quickstart — Compile & Run](#quickstart--compile--run)
  - [Using Synopsys VCS (example)](#using-synopsys-vcs-example)
  - [Using Mentor QuestaSim (example)](#using-mentor-questasim-example)
- [Running Tests](#running-tests)
- [Coverage and Metrics](#coverage-and-metrics)
- [Design & Testbench Components](#design--testbench-components)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## Overview
This repository provides a reusable UVM-based verification environment for a synchronous FIFO (Device Under Test — DUT). The testbench demonstrates common UVM components (driver, monitor, sequencer, agent, environment, tests) and uses TLM for communication between components. A self-checking scoreboard compares an expected model to DUT outputs and reports mismatches.

The testbench is suitable as a learning example, a starting point for real verification projects, or a template to adapt to other FIFO designs.

## Features
- Full UVM architecture (environment, agent, driver, monitor, sequencer, sequences, tests)
- TLM-based communication between components
- Self-checking scoreboard with mismatch reporting
- Configurable stimulus: deterministic, constrained-random, and stress sequences
- Support-friendly structure for common EDA simulators (VCS, Questa, Xcelium)
- Hooks for functional coverage and assertions

## Repository Structure
(If any paths differ in your tree, tell me and I will update this section.)

- rtl/         — DUT RTL sources (SystemVerilog)
- tb/          — UVM testbench sources (packages, agents, env, tests)
- env/         — environment components (scoreboard, monitors)
- sim/         — simulation scripts and tool-specific files (filelists, Makefile)
- docs/        — design and verification notes
- scripts/     — helper scripts (run_sim.sh, build scripts)
- examples/    — example test scenarios and transcripts

## Prerequisites
- SystemVerilog simulator with UVM support (recommended):
  - Synopsys VCS, Mentor QuestaSim/ModelSim, or Cadence Xcelium
- UVM library (UVM 1.1 or newer)
- POSIX shell for provided scripts (Linux/macOS)
- make (optional) if Makefile is provided
- Optional: coverage/debug tools included with your simulator (Verdi, DVE, vcover, urg)

## Quickstart — Compile & Run
Replace filelist and top-level names with those in this repo where necessary.

### Using Synopsys VCS (example)
1. Create a filelist `filelist.f` containing RTL and TB source order.
2. Compile:

```
vcs -full64 -sverilog -f filelist.f -timescale=1ns/1ps -l compile.log
```

3. Run simulation:

```
./simv +UVM_TESTNAME=test_basic_fifo +UVM_VERBOSITY=UVM_HIGH
```

### Using Mentor QuestaSim (example)
1. Compile:

```
vlog -sv -timescale=1ns/1ps -f filelist.f
```

2. Run:

```
vsim -c work.top -do "run -all; quit"
```

Or with UVM arguments:

```
vsim -c work.top +UVM_TESTNAME=test_random_fifo +UVM_VERBOSITY=UVM_LOW -do "run -all; quit"
```

Many projects include a Makefile or `scripts/run_sim.sh` wrapper; if present, prefer those (e.g., `make sim` or `./scripts/run_sim.sh`).

## Running Tests
This repository typically contains tests such as:
- Basic write/read test
- Randomized traffic test
- Stress/high-throughput test
- Corner-case tests (full, empty, backpressure)

Select a test by passing `+UVM_TESTNAME=<test_name>` to the simulator. Example:

```
./simv +UVM_TESTNAME=test_stress_fifo +UVM_VERBOSITY=UVM_MEDIUM
```

Look for test names in `tb/tests/` or `tb/tests_pkg.sv` (or similar) and I can update this README to reference exact names.

## Coverage and Metrics
To collect coverage:
- VCS: compile/run with coverage options (e.g., `-cm line+cond+fsm+tgl`) and generate reports with `vcover`/`urg`.
- Questa: use `-coverage` and explore with `vcover`/`verdi`.

Add functional covergroups in monitors or scoreboard to track FIFO-specific metrics such as occupancy over time, read/write ordering, and overflow/underflow events.

## Design & Testbench Components
- DUT: synchronous FIFO (parameterizable depth/width)
- Sequences / Sequencer: generate write/read transactions, randomized or directed
- Driver: converts transactions to DUT signals
- Monitor: samples DUT signals and forwards transactions to scoreboard and coverage
- Scoreboard: golden-model comparison and mismatch reporting
- Environment: instantiates agent(s), scoreboard, and connects TLM ports
- Top-level testbench: instantiates DUT, clock/reset generators, and hooks up scoreboard

## Configuration
Parameters such as width, depth, FIFO thresholds, and clock/reset periods are set via:
- package parameters and `uvm_config_db` settings
- plusargs or compile-time macros

Look for configuration definitions in files like `tb/config.sv` or `tb/package.sv` and I can make this section point to exact files.

## Contributing
Contributions are welcome. Suggested workflow:
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Add/modify tests, RTL, or docs
4. Run the testbench locally
5. Open a Pull Request with a clear description and test results

Please include regression tests for any new behavior and update `docs/` as needed.

## License
No LICENSE file detected in this repository. If you want, I can add a license file (MIT, Apache-2.0, etc.). Tell me which license you prefer.

## Contact
Maintainer: Ameer Hamza (github: @ameerhamza929)

---

If you want, I can now:
- push this README directly to the repository (I will commit to the repository's default branch), or
- inspect the repo to replace placeholder paths/test names with exact ones before committing.

Tell me which you prefer or I will commit this README to `README.md` on the default branch.