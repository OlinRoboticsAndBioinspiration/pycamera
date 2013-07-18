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

cdef extern from 'C:\Program Files (x86)\OptiTrack\Camera SDK\include\cameratypes.h' namespace 'CameraLibrary':
#    ctypedef enum eCameraState:
#        Unitialized = 0,
#        InitializingDevice,
#        InitializingCamera,
#        Initializing,
#        WaitingForChildDevices,
#        WaitingForDeviceInitialization,
#        Initialized,
#        Disconnected,
#        Shutdown

    ctypedef enum eVideoMode:
        SegmentMode              = 0,
        GrayscaleMode            = 1,
        ObjectMode               = 2,
        InterleavedGrayscaleMode = 3,
        PrecisionMode            = 4,
        BitPackedPrecisionMode   = 5,
        MJPEGMode                = 6,
        MJPEGPreviewMode         = 7,
        SynchronizationTelemetry = 99,
        VideoModeCount               ,
        UnknownMode

    ctypedef struct sTimeCode:
        sTimeCode()

        unsigned int TimeCode
        unsigned int TimeCodeSubFrame
        unsigned int TimeCodeDropFrame
        bool Valid

        int Hours()
        int Minutes()
        int Seconds()
        int Frame()
        int SubFrame()
        bool IsDropFrame()

        void Stringify(char *Buffer, int BufferSize)

cdef extern from 'C:\Program Files (x86)\OptiTrack\Camera SDK\include\cameramanager.h' namespace 'CameraLibrary':
    ctypedef char* const_char_ptr "const char*"

    cdef cppclass CameraManager:
        bool WaitForInitialization() except +
        bool AreCamerasInitialized() except +
        bool AreCamerasShutdown() except +
        void Shutdown() except +
        Camera* GetCameraBySerial(int Serial) except +
        Camera* GetCamera(int UID) except +
        Camera* GetCamera() except +
        void GetCameraList(CameraList &List) except +

        double TimeStamp() except +
        void ResetTimeStamp() except +

    cdef cppclass CameraList:
        CameraEntry& operator[](int index)
        int Count()
        void Refresh()

    cdef cppclass CameraEntry:
        int UID()
        int Serial()
        int Revision()
        const char* Name()
        eCameraState State()
        bool IsVirtual()

# Static method X() is a member of the Singleton class template. Calling X() returns the 
# reference to the single allowable instance of a CameraManager
cdef extern from 'C:\Program Files (x86)\OptiTrack\Camera SDK\include\cameramanager.h' namespace 'CameraLibrary::CameraManager':
    cdef CameraManager& X()

cdef extern from 'C:\Program Files (x86)\OptiTrack\Camera SDK\include\camera.h' namespace 'CameraLibrary':
    cdef cppclass Camera:
        Camera()

        void PacketTest(int PacketCount)

        Frame* GetFrame() except +
        Frame* GetLatestFrame() except +

        const char* Name() except +

        void Start() except +
        void Stop(bool TurnNumericOff = true) except +

        bool IsCameraRunning() except +

        void Release() except +

        void SetNumeric(bool Enabled, int Value) except +
        void SetExposure(int Value) except +
        int Exposure()
        void SetThreshold(int Value) except +
        int Threshold()
        void SetIntensity(int Value) except +
        int Intensity()
        void SetPrecisionCap(int Value) except +
        int PrecisionCap()
        void SetShutterDelay(int Value) except +
        int ShutterDelay()

        void SetFrameRate(int value) except +
        int FrameRate() except +

        void SetVideoType(eVideoMode Value)
        eVideoMode VideoType()

cdef extern from 'C:\Program Files (x86)\OptiTrack\Camera SDK\include\\frame.h' namespace 'CameraLibrary':
    cdef cppclass Frame:
        Frame()

        int ObjectCount()
        int FrameID()
        eVideoMode FrameType()
        int MJPEGQuality()

        #cObject* Object(int index)
        #ObjectLink* GetLink(int index)
        Camera* GetCamera()

        bool IsInvalid()
        bool IsEmpty()
        bool Grayscale()

        int Width()
        int Height()

        double Timestamp()

        bool IsSynchInfoValid()

        bool IsTimeCodeValid()
        bool IsExternalLocked()
        bool IsRecording()

        sTimeCode TimeCode()

        unsigned long long HardwareTimeStamp()
        bool IsHardwareTimeStamp()
        unsigned int HardwareTimeFreq()
        bool MasterTimingDevice()

        void Release()

        int RefCount()
        void AddRef()

        void Rasterize(unsigned int Width, unsigned int Height, unsigned int Span,
                unsigned int BitsPerPixel, void *Buffer)
        #void Rasterize(Bitmap *BitmapRef)

        int JPEGImageSize()
        int JPEGImage(unsigned char *Buffer, int BufferSize)

        #void PopulateFrom(CompressedFrame *Frame)

        unsigned char* GetGrayscaleData()
        int GetGrayscaleDataSize()

        void SetObjectCount(int Count)
        void RemoveObject(int Index)

        bool HardwareRecording()

cdef PyCameraEntry Pce_Factory(CameraEntry *ce):
    cdef PyCameraEntry pce = PyCameraEntry.__new__(PyCameraEntry)
    pce.thisptr = ce
    return pce

cdef PyCamera PyCameraFactory(Camera *cam):
    cdef PyCamera pycam = PyCamera.__new__(PyCamera)
    pycam.thisptr = cam
    return pycam

@cython.final
@cython.internal
cdef class PyCamera:
    cdef Camera *thisptr

    py_video_mode = ['Unitialized',
        'SegmentMode',
        'GrayscaleMode',
        'ObjectMode',
        'InterleavedGrayscaleMode ',
        'PrecisionMode',
        'BitPackedPrecisionMode ',
        'MJPEGMode',
        'MJPEGPreviewMode',
        'SynchronizationTelemetry',
        'VideoModeCount',
        'UnknownMode']

    def __dealloc__(self):
        self.thisptr.Stop()
        self.thisptr.Release()

    def get_name(self):
        return self.thisptr.Name()

    def start(self):
        self.thisptr.Start()
    def stop(self):
        self.thisptr.Stop()

    def is_camera_running(self):
        return self.thisptr.IsCameraRunning()

    def release(self):
        self.thisptr.Release()

    def set_numeric(self, enabled, value):
        self.thisptr.SetNumeric(enabled, value)
    def set_exposure(self, value):
        self.thisptr.SetExposure(value)
    def get_exposure(self):
        return self.thisptr.Exposure()
    def set_threshold(self, value):
        self.thisptr.SetThreshold(value)
    def get_threshold(self):
        return self.thisptr.Threshold()
    def set_intensity(self, value):
        self.thisptr.SetIntensity(value)
    def get_intensity(self):
        return self.thisptr.Intensity()
    def set_precision_cap(self, value):
        self.thisptr.SetPrecisionCap(value)
    def get_precision_cap(self):
        return self.thisptr.PrecisionCap()
    def set_shutter_delay(self, value):
        self.thisptr.SetShutterDelay(value)
    def get_shutter_delay(self):
        return self.thisptr.ShutterDelay()

    def set_framerate(self, value):
        self.thisptr.SetFrameRate(value)
    def get_framerate(self):
        return self.thisptr.FrameRate()

    def set_video_type(self, value):
        self.thisptr.SetVideoType(

@cython.final
@cython.internal
cdef class PyCameraEntry:
    cdef CameraEntry *thisptr

#    cdef:
#        readonly int UNINITIALIZED
#        readonly int INITIALIZING_DEVICE
#        readonly int INITIALIZING_CAMERA
#        readonly int INITIALIZING
#        readonly int WAITING_FOR_CHILD_DEVICES
#        readonly int WAIITING_FOR_DEVICE_INITIALIZATION
#        readonly int INITIALIZED
#        readonly int DISCONNECTED
#        readonly int SHUTDOWN

    py_cam_state = ['Unitialized',
        'InitializingDevice',
        'InitializingCamera',
        'Initializing',
        'WaitingForChildDevices',
        'WaitingForDeviceInitialization',
        'Initialized',
        'Disconnected',
        'Shutdown']


    def get_uid(self):
        return self.thisptr.UID()
    def get_serial(self):
        return self.thisptr.Serial()
    def get_revision(self):
        return self.thisptr.Revision()
    def get_name(self):
        return self.thisptr.Name()
    def get_state(self):
        state = self.thisptr.State()
        return self.py_cam_state[state]
    def is_virtual(self):
        return self.thisptr.IsVirtual()

cdef class PyCameraList:
    cdef CameraList *thisptr

    def __cinit__(self):
        self.thisptr = new CameraList()
    def __dealloc__(self):
        del self.thisptr
    def __getitem__(self, index):
        return Pce_Factory(&self.thisptr[0][index])
    def get_count(self):
        return self.thisptr.Count()
    def refresh(self):
        self.thisptr.Refresh()


cdef class PyCameraManager:
    cdef CameraManager *thisptr

    def __cinit__(self):
        self.thisptr = &X()
    def __dealloc__(self):
        self.thisptr.Shutdown()
    def wait_for_initialization(self):
        return self.thisptr.WaitForInitialization()
    def are_cameras_initialized(self):
        return self.thisptr.AreCamerasInitialized()
    def are_cameras_shutdown(self):
        return self.thisptr.AreCamerasShutdown()
    def shutdown(self):
        self.thisptr.Shutdown()
    def get_camera_by_serial(self, serial):
        return PyCameraFactory(self.thisptr.GetCameraBySerial(serial))
    def get_camera_by_uid(self, uid):
        return PyCameraFactory(self.thisptr.GetCamera(uid))
    def get_camera(self):
        return PyCameraFactory(self.thisptr.GetCamera())
    def get_camera_list(self, PyCameraList pcl):
        self.thisptr.GetCameraList(cython.operator.dereference(pcl.thisptr))
    def get_timestamp(self):
        return self.thisptr.TimeStamp()
    def reset_timestamp(self):
        self.thisptr.ResetTimeStamp()
