
# iccApplyProfiles

## Overview

`iccApplyProfiles` is a command-line application designed to apply ICC profiles to images. It processes TIFF images by applying color management using sequences of ICC profiles, enabling transformations like color adjustments, rendering intent modifications, and profile connections.

This application leverages the `IccProfLib` library and supports advanced features such as luminance-based PCS adjustments, custom interpolation, and BPC (Black Point Compensation).

## Features

- Supports multiple ICC profiles to transform image color spaces.
- Handles TIFF image inputs and outputs with options for compression and embedding profiles.
- Customizable rendering intents, including perceptual, saturation, relative, and absolute.
- Advanced options:
  - Black Point Compensation (BPC).
  - Profile Connection Conditions (PCC).
  - Luminance-based PCS adjustment.
  - V5 sub-profile support.

## Usage

```bash
iccApplyProfiles src_tiff_file dst_tiff_file dst_sample_encoding dst_compression dst_planar dst_embed_icc interpolation [options]
```

### Arguments

1. **`src_tiff_file`**: Path to the source TIFF file.
2. **`dst_tiff_file`**: Path to the destination TIFF file.
3. **`dst_sample_encoding`**: Specifies the encoding of the destination samples:
   - `0`: Same as source.
   - `1`: 8-bit encoding.
   - `2`: 16-bit encoding.
   - `4`: Float encoding.
4. **`dst_compression`**: Compression for the destination TIFF:
   - `0`: No compression.
   - `1`: LZW compression.
5. **`dst_planar`**: Planar configuration for the destination TIFF:
   - `0`: Contiguous.
   - `1`: Separated.
6. **`dst_embed_icc`**: Embed ICC profile in the destination TIFF:
   - `0`: Do not embed.
   - `1`: Embed the last applied ICC profile.
7. **`interpolation`**: Interpolation method for profile application:
   - `0`: Linear.
   - `1`: Tetrahedral.

### Additional Options

- **Rendering Intent**:
  - `0`: Perceptual.
  - `1`: Relative.
  - `2`: Saturation.
  - `3`: Absolute.
  - Additional options (e.g., `40` for Perceptual with BPC) are listed in the code comments.
- **Environment Variables**:
  - Use `-ENV:sig value` to set environment variables for profiles.
- **PCC**:
  - Specify a profile connection condition path using `-PCC`.

## Dependencies

- **IccProfLib**: A library for working with ICC profiles.
- **TIFF Handling**: Requires functionality for reading and writing TIFF images.

### Example Command

```bash
iccApplyProfiles input.tiff output.tiff 1 1 0 1 0 -ENV:icSigLuminance 100 profile.icc 0
```

This command applies the specified ICC profile to `input.tiff` and outputs the result to `output.tiff` with 8-bit encoding, LZW compression, contiguous planar configuration, and embedded ICC profile.

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

## License

The project is licensed under the **ICC Software License Version**.

---
