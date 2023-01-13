set -e

if [[ ! -d metacall-tarball-linux-amd64 ]]; then
    if [[ ! -f metacall-tarball-linux-amd64.tar.gz ]]; then
        # Update this url and remove the metacall-tarball-linux-amd64 folder
        # when a new version gets released.
        # Also check build.zig
        curl -OL https://github.com/metacall/distributable-linux/releases/download/v0.6.0/metacall-tarball-linux-amd64.tar.gz
    fi
    tar xzf metacall-tarball-linux-amd64.tar.gz --one-top-level
    rm metacall-tarball-linux-amd64.tar.gz
fi
