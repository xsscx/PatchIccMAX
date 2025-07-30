# Latest Release of iccDEV

Built from [PR152](https://github.com/InternationalColorConsortium/DemoIccdev/pull/152)

### NPM Install

1. Download [iccdev-npm-v2.2.61.tgz](https://github.com/InternationalColorConsortium/DemoIccdev/releases/download/v2.2.6/iccdev-npm-2.2.61.tgz)
2. mkdir test-iccdev
3. cd test-iccdev
4. npm init -y
5. npm install ../iccdev-npm-2.2.61.tgz
6. cd node_modules/iccdev-wasm/
7. node test_iccToXml.js

#### Expected Output

```
node node_modules/iccdev-wasm/test_iccRoundTrip.js
Usage: node iccRoundTrip.js <profile.icc> [rendering_intent=1] [use_mpe=0]

node node_modules/iccdev-wasm/test_iccFromXml.js
IccFromXml built with IccProfLib Version 2.2.61, IccLibXML Version 2.2.61

Usage: IccFromXml xml_file saved_profile_file {-noid -v{=[relax_ng_schema_file - optional]}}
Profile parsed and saved correctly

Wrote output.icc: 2420 bytes

node node_modules/iccdev-wasm/test_iccToXml.js
IccToXml built with IccProfLib Version 2.2.61, IccLibXML Version 2.2.61

Usage: IccToXml src_icc_profile dest_xml_file
XML successfully created
```