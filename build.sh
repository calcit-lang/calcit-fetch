
cargo build --release
rm -rfv dylibs && mkdir dylibs/ && ls target/release/ && cp -v target/release/*.* dylibs/
