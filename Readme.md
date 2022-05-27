
Compiling Quarkus applications to fully static binaries.

With `gcc`:

```bash
docker build -f Dockerfile.gcc . -t quarkus_static_gcc --progress=plain
docker run --rm quarkus_static_gcc
```

With `zig cc`:

```bash
docker build -f Dockerfile.zig . -t quarkus_static_zig --progress=plain
docker run --rm quarkus_static_zig
```
