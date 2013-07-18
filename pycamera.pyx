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

cimport cameratypes as ct
cimport cameramanager
cimport camera
cimport frame

@cython.internal
cdef class _CameraState:
    cdef:
        readonly int UNINITIALIZED
        readonly int INITIALIZING_DEVICE
        readonly int INITIALIZING_CAMERA
        readonly int INITIALIZING
        readonly int WAITING_FOR_CHILD_DEVICES
        readonly int WAITING_FOR_DEVICE_INITIALIZATION
        readonly int INITIALIZED
        readonly int DISCONNECTED
        readonly int SHUTDOWN

    def __cinit__(self):
        self.UNINITIALIZED = ct.CS_UNINITIALIZED
        self.INITIALIZING_DEVICE = ct.CS_INITIALIZING_DEVICE
        self.INITIALIZING_CAMERA = ct.CS_INITIALIZING_CAMERA
        self.INITIALIZING = ct.CS_INITIALIZING
        self.WAITING_FOR_CHILD_DEVICES = ct.CS_WAITING_FOR_CHILD_DEVICES
        self.WAITING_FOR_DEVICE_INITIALIZATION = ct.CS_WAITING_FOR_DEVICE_INITIALIZATION
        self.INITIALIZED = ct.CS_INITIALIZED
        self.DISCONNECTED = ct.CS_DISCONNECTED
        self.SHUTDOWN = ct.CS_SHUTDOWN

    def __dict__(self):
        attr_dict = {self.UNINITIALIZED : 'UNINITIALIZED',
                     self.INITIALIZING_DEVICE : 'INITIALIZING_DEVICE',
                     self.INITIALIZING_CAMERA : 'INITIALIZING_CAMERA',
                     self.INITIALIZING : 'INITIALIZING',
                     self.WAITING_FOR_CHILD_DEVICES : 'WAITING_FOR_CHILD_DEVICES',
                     self.WAITING_FOR_DEVICE_INITIALIZATION : 'WAITING_FOR_DEVICE_INITIALIZATION',
                     self.INITIALIZED : 'INITIALIZED',
                     self.DISCONNECTED : 'DISCONNECTED',
                     self.SHUTDOWN : 'SHUTDOWN'}
        return attr_dict

CameraState = _CameraState()

@cython.internal
cdef class _VideoMode:
    cdef:
        readonly int VM_SEGMENT_MODE
        readonly int VM_GRAYSCALE_MODE
        readonly int VM_OBJECT_MODE
        readonly int VM_INTERLEAVED_GRAYSCALE_MODE
        readonly int VM_PRECISION_MODE
        readonly int VM_BIT_PACKED_PRECISION_MODE
        readonly int VM_MJPEG_MODE
        readonly int VM_MJPEG_PREVIEW_MODE
        readonly int VM_SYNCHRONIZATION_TELEMETRY
        readonly int VM_VIDEO_MODE_COUNT
        readonly int VM_UKNOWN_MODE


    def __cinit__(self):
        self.VM_SEGMENT_MODE = ct.VM_SEGMENT_MODE
        self.VM_GRAYSCALE_MODE = ct.VM_GRAYSCALE_MODE
        self.VM_OBJECT_MODE = ct.VM_OBJECT_MODE
        self.VM_INTERLEAVED_GRAYSCALE_MODE = ct.VM_INTERLEAVED_GRAYSCALE_MODE
        self.VM_PRECISION_MODE = ct.VM_PRECISION_MODE
        self.VM_BIT_PACKED_PRECISION_MODE = ct.VM_BIT_PACKED_PRECISION_MODE
        self.VM_MJPEG_MODE = ct.VM_MJPEG_MODE
        self.VM_MJPEG_PREVIEW_MODE = ct.VM_MJPEG_PREVIEW_MODE
        self.VM_SYNCHRONIZATION_TELEMETRY = ct.VM_SYNCHRONIZATION_TELEMETRY
        self.VM_VIDEO_MODE_COUNT = ct.VM_VIDEO_MODE_COUNT
        self.VM_UKNOWN_MODE = ct.VM_UKNOWN_MODE

    def __dict__(self):
        attr_dict = {self.VM_SEGMENT_MODE : 'VM_SEGMENT_MODE',
                     self.VM_GRAYSCALE_MODE : 'VM_GRAYSCALE_MODE',
                     self.VM_OBJECT_MODE : 'VM_OBJECT_MODE',
                     self.VM_INTERLEAVED_GRAYSCALE_MODE : 'VM_INTERLEAVED_GRAYSCALE_MODE',
                     self.VM_PRECISION_MODE : 'VM_PRECISION_MODE',
                     self.VM_BIT_PACKED_PRECISION_MODE : 'VM_BIT_PACKED_PRECISION_MODE',
                     self.VM_MJPEG_MODE : 'VM_MJPEG_MODE',
                     self.VM_MJPEG_PREVIEW_MODE : 'VM_MJPEG_PREVIEW_MODE',
                     self.VM_SYNCHRONIZATION_TELEMETRY : 'VM_SYNCHRONIZATION_TELEMETRY',
                     self.VM_VIDEO_MODE_COUNT : 'VM_VIDEO_MODE_COUNT',
                     self.VM_UKNOWN_MODE : 'VM_UKNOWN_MODE'}
        return attr_dict

VideoMode = _VideoMode()

cdef class PyTimeCode:
    cdef ct.sTimeCode time

    def get_hours(self):
        return self.time.Hours()
    def get_seconds(self):
        return self.time.Seconds()
    def get_minutes(self):
        return self.time.Minutes()
    def get_frame(self):
        return self.time.Frame()
    def get_subframe(self):
        return self.time.SubFrame()

    # TODO
    # Uncommenting the following code yields "unresolved externals" error
    # Apparently this method isn't in the dll?

    #def is_drop_frame(self):
    #    return self.time.IsDropFrame()

    # TODO
    # declaration of char* is throwing an error from the compiler
    # related to post parsing

    #cdef char* string_rep = NULL
    #cdef Py_ssize_t length = 0
    #cdef bytes result

    #def stringify(self, string_rep, length):
    #    self.thisptr.Stringify(&string_rep, &length)
    #    result = string_rep
    #    return result

cdef PyCameraEntry Pce_Factory(cameramanager.CameraEntry *ce):
    cdef PyCameraEntry pce = PyCameraEntry.__new__(PyCameraEntry)
    pce.thisptr = ce
    return pce

cdef PyCamera PyCameraFactory(camera.Camera *cam):
    cdef PyCamera pycam = PyCamera.__new__(PyCamera)
    pycam.thisptr = cam
    return pycam

cdef PyFrame PyFrameFactory(frame.Frame *frame):
    cdef PyFrame pyframe = PyFrame.__new__(PyFrame)
    pyframe.thisptr = frame
    return pyframe


@cython.final
@cython.internal
cdef class PyFrame:
    cdef frame.Frame *thisptr

    def __dealloc__(self):
        self.thisptr.Release()

    def get_object_count(self):
        return self.thisptr.ObjectCount()
    def get_frame_id(self):
        return self.thisptr.FrameID()
    def get_frame_type(self):
        return self.thisptr.FrameType()
    def get_mjpeg_quality(self):
        return self.thisptr.MJPEGQuality()

    # TODO 
    # Figure out how to deal with returning the camera reference
    #def get_camera(self):
    #   return self.GetCamera()

    def is_invalid(self):
        return self.thisptr.IsInvalid()
    def is_empty(self):
        return self.thisptr.IsEmpty()
    def is_grayscale(self):
        return self.thisptr.IsGrayscale()

    def get_height(self):
        return self.thisptr.Height()
    def get_width(self):
        return self.thisptr.Width()

    def get_timestamp(self):
        return self.thisptr.TimeStamp()

    def is_synch_info_valid(self):
        return self.thisptr.IsSynchInfoValid()

    # TODO
    # TimeCode is coming back with all zeros. 
    def is_time_code_valid(self):
        return self.thisptr.IsTimeCodeValid()
    def is_external_locked(self):
        return self.thisptr.IsExternalLocked()
    def is_recording(self):
        return self.thisptr.IsRecording()

    def get_timecode(self):
        tc = PyTimeCode()
        tc.time = self.thisptr.TimeCode()
        return tc

    def get_hardware_timestamp(self):
        return self.thisptr.HardwareTimeStamp()
    def is_hardware_timestamp(self):
        return self.thisptr.IsHardwareTimeStamp()
    def get_hardware_time_freq(self):
        return self.thisptr.HardwareTimeFreq()
    def is_master_timing_device(self):
        return self.thisptr.MasterTimingDevice()

    def release(self):
        self.thisptr.Release()

    def get_ref_count(self):
        return self.thisptr.RefCount()
    def add_ref(self):
        self.thisptr.AddRef()

    def rasterize(self, width, height, span, bits_per_pixel,
                  np.ndarray[dtype=cython.uchar, ndim=2, mode='c'] _buffer):
        self.thisptr.Rasterize(width, height, span, bits_per_pixel,
                               &_buffer[0,0])

@cython.final
@cython.internal
cdef class PyCamera:
    cdef camera.Camera *thisptr

    def __dealloc__(self):
        self.thisptr.Stop()
        self.thisptr.Release()

    def get_frame(self):
        return PyFrameFactory(self.thisptr.GetFrame())
    def get_latest_frame(self):
        return PyFrameFactory(self.thisptr.GetLatestFrame())

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
        self.thisptr.SetVideoType(value)
    def get_video_type(self):
        return self.thisptr.VideoType()

@cython.final
@cython.internal
cdef class PyCameraEntry:
    cdef cameramanager.CameraEntry *thisptr

    def get_uid(self):
        return self.thisptr.UID()
    def get_serial(self):
        return self.thisptr.Serial()
    def get_revision(self):
        return self.thisptr.Revision()
    def get_name(self):
        return self.thisptr.Name()
    def get_state(self):
        return CameraState[self.thisptr.State()]
    def is_virtual(self):
        return self.thisptr.IsVirtual()

cdef class PyCameraList:
    cdef cameramanager.CameraList *thisptr

    def __cinit__(self):
        self.thisptr = new cameramanager.CameraList()
    def __dealloc__(self):
        del self.thisptr
    def __getitem__(self, index):
        return Pce_Factory(&self.thisptr[0][index])
    def get_count(self):
        return self.thisptr.Count()
    def refresh(self):
        self.thisptr.Refresh()


cdef class PyCameraManager:
    cdef cameramanager.CameraManager *thisptr

    def __cinit__(self):
        self.thisptr = &cameramanager.X()
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


