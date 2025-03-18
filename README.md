This repository contains the source code to build my PhD dissertation:

<div align="center">
<h3>
“Applications of novel programming languages and compilation<br/>
techniques to accelerating quantum many-body science”
</h3>
<p>Tom Westerhout</p>

[![CI](https://github.com/twesterhout/phd-thesis/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/twesterhout/phd-thesis/actions/workflows/ci.yml)

</div>

---

#### Building the thesis

If you have [Nix](https://nixos.org/) installed, it's just one command:

```sh
nix build github:twesterhout/phd-thesis
```

#### Licenses

- The LaTeX sources for all earlier published works are under the CC-BY-4.0 license.
- All remaining source code in this repository is published under the [BSD 3-Clause License](./LICENSE).
- The Neacademia font files in `./assets/fonts` are not my creation and should not be copied or otherwise distributed. See https://rosettatype.com/Neacademia if you would like to use this font in your work.
