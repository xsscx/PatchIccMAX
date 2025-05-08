# Latest Release of iccMAX

Built from [PR152](https://github.com/InternationalColorConsortium/DemoIccMAX/pull/152)

### NPM Install

1. Download [iccmax-npm-v2.2.61.tgz](https://github.com/InternationalColorConsortium/DemoIccMAX/releases/download/v2.2.6/iccmax-npm-2.2.61.tgz)
2. mkdir test-iccmax
3. cd test-iccmax
4. npm init -y
5. npm install ../iccmax-npm-2.2.61.tgz
6. cd node_modules/iccmax-wasm/
7. node test_iccToXml.js

#### Expected Output

```
node node_modules/iccmax-wasm/test_iccRoundTrip.js
Usage: node iccRoundTrip.js <profile.icc> [rendering_intent=1] [use_mpe=0]

node node_modules/iccmax-wasm/test_iccFromXml.js
IccFromXml built with IccProfLib Version 2.2.61, IccLibXML Version 2.2.61

Usage: IccFromXml xml_file saved_profile_file {-noid -v{=[relax_ng_schema_file - optional]}}
Profile parsed and saved correctly

Wrote output.icc: 2420 bytes

node node_modules/iccmax-wasm/test_iccToXml.js
IccToXml built with IccProfLib Version 2.2.61, IccLibXML Version 2.2.61

Usage: IccToXml src_icc_profile dest_xml_file
XML successfully created
```