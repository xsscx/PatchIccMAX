# NPM Install

1. Download [iccmax-npm-v2.2.61.tgz](https://github.com/InternationalColorConsortium/DemoIccMAX/releases/download/v2.2.6/iccmax-npm-2.2.61.tgz)
2. mkdir test-iccmax
3. cd test-iccmax
4. npm init -y
5. npm install ../iccmax-npm-v2.2.61.tgz
6. node node_modules/iccmax-wasm/test_iccToXml.js

#### Expected Output

```
IccToXml built with IccProfLib Version 2.2.61, IccLibXML Version 2.2.61
Usage: IccToXml src_icc_profile dest_xml_file
XML successfully created
```
