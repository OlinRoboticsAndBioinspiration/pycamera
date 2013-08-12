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

2) run `python setup.py build _ ext --inplace`

3) OPTIONAL - Add the directory where you ran `setup.py` to your PYTHONPATH environment variable (to enable you to load the 
ycamera
 module without having to run the Python shell from that directory every time)


Example Usage
-----------
The sample code below creates a `CameraList` and  
gets a reference to the `CameraManager`. Calling  
`get _ camera _ list()` initializes the `CameraList`.  
It then gets a camera, sets the video type and  
framerate. Once the camera is started,  
`get _ latest _ frame()` gets the most recent frame.
A Numpy array is used to store the image and 
matplotlib functions `imshow()` and `show()` are used
to visualize the image. 

```python
import pycamera as p  
import numpy as np  
import ctypes  
from pylab import imshow, show

IMG _ WIDTH = 832 # Use S250e camera
IMG _ HEIGHT = 832 

pcl = p.PyCameraList()  
cm = p.CameraManager()  
cm.get _ camera _ list()  
cam = cm.get _ camera _ by _ serial(<sn>)  
cam.set _ video _ type(p.VideoMode.VM _ MJPEG _ MODE)  
cam.set _ framerate(250) #Framerate must be supported by camera hardware  
cam.start()  
f = cam.get _ latest _ frame()  
my _ buffer = np.ones((IMG _ WIDTH, IMG _ HEIGHT), dtype=ctypes.c _ ubyte)  
f.rasterize(IMG _ WIDTH, IMG _ HEIGHT, 0, 8, my _ buffer)  
imshow(my _ buffer)  
show()
```



_The order of operations in the above code is very important. Alternative
approaches (such as instantiating the CameraManager before the CameraList)
have crashed the Python runtime (likely due to a null pointer error)._

