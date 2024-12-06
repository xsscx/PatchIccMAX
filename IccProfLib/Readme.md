# IccProfLib Overview

Within the DemoIccMAX project are several libraries and tools as follows:

* Libraries that allow applications to interact with iccMAX profiles

  * IccProfLib - The DemoIccMAX IccProfLib project represents an open source &
    cross platform reference implementation of a C++ library for reading,
    writing, applying, manipulating iccMAX color profiles defined by the [iccMAX
    profile specification](http://www.color.org/iccmax.xalter). Class and object
    interaction documentation for IccProfLib can be found at ().

    * There are no intentional discrepancies between the DemoIccMAX
      implementation and the iccMAX specification. If any should occur then this
      should be brought to the attention of and resolved by the DemoIccMAX project
      team within the Architecture Working Group of the ICC organization.

      Though SampleICC provides a sample implementation, it does NOT
      represent a reference implementation of ICC.1 color management.

  * IccLibXML - The DemoIccMAX IccLibXML project contains a parallel C++
    extension library (IccLibXML) which provides the ability to interact with the
    objects defined by IccProfLib using an XML representation thus allowing iccMAX
    profiles to be expressed as or created from text based XML files. The
    IccLibXML project has a dependencies on the [libxml](http://www.xmlsoft.org/)
    project (which also has a dependency on iconv which must be separately
    installed on windows platforms).

## Contributing

Contributions are welcome. Please follow the guidelines in `CONTRIBUTING.md` (if available) and respect the existing code style.

## Acknowledgments

This application was initially developed by Max Derhak and incorporates contributions from the International Color Consortium (ICC).

For more details about ICC and color profiles, visit [www.color.org](http://www.color.org/).

LICENSE
-------

 The ICC Software License, Version 0.2


 Copyright (c) 2003-2024 The International Color Consortium. All rights 
 reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:

 1. Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer. 

 2. Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.

 3. In the absence of prior written permission, the names "ICC" and "The
    International Color Consortium" must not be used to imply that the
    ICC organization endorses or promotes products derived from this
    software.


 THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED.  IN NO EVENT SHALL THE INTERNATIONAL COLOR CONSORTIUM OR
 ITS CONTRIBUTING MEMBERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 SUCH DAMAGE.
 ====================================================================

 This software consists of voluntary contributions made by many
 individuals on behalf of the The International Color Consortium. 


 Membership in the ICC is encouraged when this software is used for
 commercial purposes. 

  
 For more information on The International Color Consortium, please
 see <http://www.color.org/>.
---
