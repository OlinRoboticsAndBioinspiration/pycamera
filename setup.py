"""
 * Copyright (c) 2012-2013, Franklin W. Olin College of Engineering
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice,
 *   this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 * - Neither the name of Franklin W. Olin College of Engineering nor the names
 *   of its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 *
 *
 * Setup for cython wrapper of Tracking Tools API
 *
 * by Asa Eckert-Erdheim
 *
 * v. 0.01
 *
 * Revisions:
 *  Asa EE     yyyy-mm-dd      blah blah blah
 * ... etc.
 """


from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext
#import numpy

sources = ["pycamera.pyx", "cameraSDKStub.cpp"]
include_dirs = ["C:\Program Files (x86)\OptiTrack\Camera SDK\include",
                r"C:\Python27\Lib\site-packages\numpy\core\include"]
library_dirs = ["C:\Program Files (x86)\OptiTrack\Camera SDK\lib"]
libraries = ["CameraLibrary2010x64S"]

setup(
    name='pycamera',
    version=".1",
    cmdclass={'build_ext': build_ext},
    ext_modules=[Extension("pycamera", sources=sources,
                 include_dirs=include_dirs, library_dirs=library_dirs,
                 libraries=libraries, language="c++")]
)
