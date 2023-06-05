# chdman standalone with added support for the correct extraction of Dreamcast CHDs

Code has been modified as cleanly as possible using code contriubted by a deleted user on unmerged pull request 7717 on the official mame repo.

I hope to update this to the latest version of mame at some point to keep this version alive. I do hope that some day this may be merged in the official mame repo, but until then at least you have an easy to compile version of the code.

UPDATED TO VERSION 2.49

## Compilation

### Install dependencies

```
apt update && apt dist-upgrade -y
apt install build-essential git cmake
```

### Build chdman

```
cmake -B build -S . -DCMAKE_INSTALL_PREFIX=<install directory of your choice>
cmake --build build -j`nproc` --target install
```
