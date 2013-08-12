pycamerasdk
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
that contains camera.pxd, frame.pxd, etc.)

2) run 'python setup.py build _ ext --inplace'

3) OPTIONAL - Add the directory where you ran setup.py to your PYTHONPATH environment variable (to enable you to load the 
ycamera
 module without having to run the Python shell from that directory every time)


Example Usage
-----------

import pycamera as p
pcl = p.PyCameraList()
cm = p.CameraManager()
cm.get _ camera _ list()

_The order of operations in the above code is very important. Alternative
approaches (such as instantiating the CmameraManager before the CameraList)
have crashed the Python runtime (likely due to a null pointer error)._

