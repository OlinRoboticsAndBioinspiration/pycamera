from libcpp cimport bool

cimport cameratypes
cimport frame

cdef extern from 'C:\Program Files (x86)\OptiTrack\Camera SDK\include\camera.h' namespace 'CameraLibrary':
    cdef cppclass Camera:
        Camera()

        void PacketTest(int PacketCount)

        frame.Frame* GetFrame() except +
        frame.Frame* GetLatestFrame() except +

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

        void SetVideoType(cameratypes.VideoMode_type Value)
        cameratypes.VideoMode_type VideoType()


