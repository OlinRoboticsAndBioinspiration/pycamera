pycamera
===========

Overview (08/12/2013)
-----------

This is a pre-alpha version a Python wrapper for the C++ Camera SDK developed 
by Natural Point for OptiTrack motion capture systems 
(http://www.naturalpoint.com/optitrack/products/camera-sdk/). 
Only the most basic functionality has been implemented so far.

The wrapper uses a programming language called Cython. You will need to have a
version of Microsoft's Visual Studio with a C++ compiler installed compilation 
has only been tested with Visual Studio 2010 to date. 

Compilation and Module Installation
-----------
1) Change to the directory containing all the files you downloaded (the one
that contains `camera.pxd`, `frame.px`d, etc.)

2) run `python setup.py build_ext --inplace`

3) OPTIONAL - Add the directory where you ran `setup.py` to your PYTHONPATH environment variable (to enable you to load the 
ycamera
 module without having to run the Python shell from that directory every time)


Example Usage
-----------
The sample code below creates a `CameraList` and  
gets a reference to the `CameraManager`. Calling  
`get_camera_list()` initializes the `CameraList`.  
It then gets a camera, sets the video type and  
framerate. Once the camera is started,  
`get_latest_frame()` gets the most recent frame.
A Numpy array is used to store the image and 
matplotlib functions `imshow()` and `show()` are used
to visualize the image. 

```python
import pycamera as p  
import numpy as np  
import ctypes  
from pylab import imshow, show

IMG_WIDTH = 832 # Use S250e camera
IMG_HEIGHT = 832 

pcl = p.PyCameraList()  
cm = p.CameraManager()  
cm.get_camera_list()  
cam = cm.get_camera_by_serial(<sn>)  
cam.set_video_type(p.VideoMode.VM_MJPEG_MODE)  
cam.set_framerate(250) #Framerate must be supported by camera hardware  
cam.start()  
f = cam.get_latest_frame()  
my_buffer = np.ones((IMG_WIDTH, IMG_HEIGHT), dtype=ctypes.c_ubyte)  
f.rasterize(IMG_WIDTH, IMG_HEIGHT, 0, 8, my_buffer)  
imshow(my_buffer)  
show()
```



_The order of operations in the above code is very important. Alternative
approaches (such as instantiating the CameraManager before the CameraList)
have crashed the Python runtime (likely due to a null pointer error)._

