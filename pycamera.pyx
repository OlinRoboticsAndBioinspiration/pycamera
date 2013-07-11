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
 * Cython wrapper of OptiTrack Camera SDK
 *
 * by Aaron M. Hoover
 *
 * v. 0.01
 *
 * Revisions:
 *  AMH         2013-07-09      Created
 """

from libcpp cimport bool
from libcpp cimport float
import numpy as np
cimport numpy as np
import cython
import time

cdef extern from 'C:\Program Files (x86)\OptiTrack\Camera SDK\include\camera.h' namespace 'CameraLibrary':
    cdef cppclass Camera:
        int Serial()

cdef extern from 'C:\Program Files (x86)\OptiTrack\Camera SDK\include\cameramanager.h' namespace 'CameraLibrary':
    cdef cppclass CameraManager:
        bool WaitForInitialization()
        bool AreCamerasInitialized()
        bool AreCamerasShutdown()
        Camera* GetCamera()
        void Shutdown()

        double TimeStamp()

    cdef cppclass CameraList:
        int Count()
        void Refresh()


cdef extern from 'C:\Program Files (x86)\OptiTrack\Camera SDK\include\cameramanager.h' namespace 'CameraLibrary::CameraManager':
    cdef CameraManager& X()
    cdef void DestroyInstance()
    cdef void DeleteAll()


#cdef class PyCamera:
#    cdef Camera *thisptr
#
#    def __cinit__(self):
#        self.thisptr = 

cdef class PyCameraManager:
    cdef CameraManager *thisptr
    cdef CameraList *cl

    def __cinit__(self):
        self.thisptr = &X()
        self.cl = new CameraList()
    def __dealloc__(self):
        DestroyInstance()
    def wait_for_initialization(self):
        return self.thisptr.WaitForInitialization()
    def are_cameras_initialized(self):
        return self.thisptr.AreCamerasInitialized()
    def are_cameras_shutdown(self):
        return self.thisptr.AreCamerasShutdown()
    def shutdown(self):
        self.thisptr.Shutdown()
    def count_cameras(self):
        self.cl.Refresh()
        return self.cl.Count()
    def get_timestamp(self):
        return self.thisptr.TimeStamp()
    def get_cam_serial(self):
        cdef Camera *c
        c = self.thisptr.GetCamera()
        print(c)
        return c.Serial()





#cdef extern from 'cameraSDKStub.h':
#    bool WaitForInitialization()
#    void Shutdown()
#
#def py_wait_for_initialization():
#    return WaitForInitialization()
#
#def shutdown():
#    Shutdown()
