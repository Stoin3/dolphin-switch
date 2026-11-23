# Building dolphin.nro on Windows

This fork of [dolphin-nx](https://github.com/NaGaa95/dolphin-nx) adds:

- **Joy-Con motion buffering** (`Source/Core/InputCommon/ControllerInterface/Switch/Switch.cpp`).
  Joy-Cons send several IMU samples per Bluetooth packet. The input backend used to read only the
  newest sample per poll, which dropped the short acceleration peaks Wii Remote swing detection
  depends on. Every sample is now queued and handed out one per Wii Remote update (200 Hz).
- **Mesa SDK index fix** (`Tools/Switch/prepare_mesa_sdk.sh`). Some SDK zips ship `libvulkan.a`
  with an incomplete symbol index, which leaves NAK's Rust `core::` symbols unresolved at link
  time. The script now rebuilds every archive index before merging.

## Requirements

1. [MSYS2](https://www.msys2.org/) installed at `C:\msys64`.
2. devkitPro pacman repositories added to MSYS2
   ([instructions](https://devkitpro.org/wiki/devkitPro_pacman#Customising_Existing_Pacman_Install)).
3. Packages, from the MSYS2 shell:

   ```sh
   pacman -S switch-dev switch-cmake switch-pkg-config dkp-toolchain-vars \
     switch-sdl2 switch-sdl2_ttf switch-sdl2_image switch-curl switch-mbedtls \
     switch-libexpat switch-libzstd switch-libdrm_nouveau switch-ntfs-3g \
     switch-freetype switch-harfbuzz switch-libpng switch-libjpeg-turbo switch-libwebp \
     switch-bzip2 switch-zlib \
     cmake ninja git python python-mako bison flex bsdtar
   ```

4. `libelf.a` is referenced by the link but not used. devkitPro has no package for it, so create
   an empty one:

   ```sh
   /opt/devkitpro/devkitA64/bin/aarch64-none-elf-ar rcs /opt/devkitpro/portlibs/switch/lib/libelf.a
   ```

5. The unified Mesa Horizon SDK zip, a GitHub Actions artifact of
   [danfromtico/mesa-switch](https://github.com/danfromtico/mesa-switch/actions)
   (for example `mesa-26.2.4-switch-unified-horizon-sdk`). Downloading it requires a GitHub login.

## Build

Clone with submodules, then from the MSYS2 shell:

```sh
git clone --recurse-submodules https://github.com/Stoin3/dolphin-switch.git
cd dolphin-switch
Tools/Switch/build-msys2.sh /path/to/mesa-26.2.4-switch-unified-horizon-sdk.zip
```

The result is `C:\dolphin-nx-build\Binaries\dolphin.nro`. Copy it to `/switch/dolphin/dolphin.nro`
on the SD card and launch it through title override (hold R while opening a game).

Later builds only recompile what changed.
