from libcpp cimport bool

cdef extern from 'C:\Program Files (x86)\OptiTrack\Camera SDK\include\cameratypes.h' namespace 'CameraLibrary':
    ctypedef enum CameraState_type 'CameraLibrary::eCameraState':
        CS_UNINITIALIZED 'CameraLibrary::Uninitialized',
        CS_INITIALIZING_DEVICE 'CameraLibrary::InitializingDevice',
        CS_INITIALIZING_CAMERA 'CameraLibrary::InitializingCamera',
        CS_INITIALIZING 'CameraLibrary::Initializing',
        CS_WAITING_FOR_CHILD_DEVICES 'CameraLibrary::WaitingForChildDevices',
        CS_WAITING_FOR_DEVICE_INITIALIZATION 'CameraLibrary::WaitingForDeviceInitialization',
        CS_INITIALIZED 'CameraLibrary::Initialized',
        CS_DISCONNECTED 'CameraLibrary::Disconnected',
        CS_SHUTDOWN 'CameraLibrary::Shutdown'

    ctypedef enum VideoMode_type 'CameraLibrary::eVideoMode':
        VM_SEGMENT_MODE 'CameraLibrary::SegmentMode',
        VM_GRAYSCALE_MODE 'CameraLibrary::GrayscaleMode',
        VM_OBJECT_MODE 'CameraLibrary::ObjectMode',
        VM_INTERLEAVED_GRAYSCALE_MODE 'CameraLibrary::InterleavedGrayscaleMode',
        VM_PRECISION_MODE 'CameraLibrary::PrecisionMode',
        VM_BIT_PACKED_PRECISION_MODE 'CameraLibrary::BitPackedPrecisionMode',
        VM_MJPEG_MODE 'CameraLibrary::MJPEGMode',
        VM_MJPEG_PREVIEW_MODE 'CameraLibrary::MJPEGPreviewMode',
        VM_SYNCHRONIZATION_TELEMETRY 'CameraLibrary::SynchronizationTelemetry',
        VM_VIDEO_MODE_COUNT 'CameraLibrary::VideoModeCount',
        VM_UKNOWN_MODE 'CameraLibrary::UnknownMode'

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

