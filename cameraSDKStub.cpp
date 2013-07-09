#include "cameraSDKStub.h"

using namespace CameraLibrary;

bool WaitForInitialization()
{
    return CameraManager::X().WaitForInitialization();
}

void Shutdown()
{
    CameraManager::X().Shutdown();
}

//void setFrameRate(int serial, int rate)
//{
//	CameraManager * camera_manager = TT_GetCameraManager();
//	camera_manager->GetCameraBySerial(serial)->SetFrameRate(rate);
//}
