from libcpp cimport bool

cimport cameratypes
cimport camera

cdef extern from 'C:\Program Files (x86)\OptiTrack\Camera SDK\include\cameramanager.h' namespace 'CameraLibrary':
    ctypedef char* const_char_ptr "const char*"

    cdef cppclass CameraManager:
        bool WaitForInitialization() except +
        bool AreCamerasInitialized() except +
        bool AreCamerasShutdown() except +
        void Shutdown() except +
        camera.Camera* GetCameraBySerial(int Serial) except +
        camera.Camera* GetCamera(int UID) except +
        camera.Camera* GetCamera() except +
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
        cameratypes.CameraState_type State()
        bool IsVirtual()

# Static method X() is a member of the Singleton class template. Calling X() returns the 
# reference to the single allowable instance of a CameraManager
cdef extern from 'C:\Program Files (x86)\OptiTrack\Camera SDK\include\cameramanager.h' namespace 'CameraLibrary::CameraManager':
    cdef CameraManager& X()
