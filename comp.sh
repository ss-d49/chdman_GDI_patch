cmake -B build -S . -DCMAKE_INSTALL_PREFIX=bin
cmake --build build -j`nproc` --target install
rm -rf build
