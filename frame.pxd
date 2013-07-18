from libcpp cimport bool

cimport cameratypes
cimport camera


cdef extern from 'C:\Program Files (x86)\OptiTrack\Camera SDK\include\\frame.h' namespace 'CameraLibrary':
    cdef cppclass Frame:
        Frame()

        int ObjectCount()
        int FrameID()
        cameratypes.VideoMode_type FrameType()
        int MJPEGQuality()

        # TODO
        # Implement wrapper for Object and ObjectLing
        #cObject* Object(int index)
        #ObjectLink* GetLink(int index)

        camera.Camera* GetCamera()

        bool IsInvalid()
        bool IsEmpty()
        bool IsGrayscale()

        int Width()
        int Height()

        double TimeStamp()

        bool IsSynchInfoValid()

        bool IsTimeCodeValid()
        bool IsExternalLocked()
        bool IsRecording()

        cameratypes.sTimeCode TimeCode()

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


