#PrinAPicture print's your picture (in 3D)
##This program will create a STL file from your picture!

**How to use:**
* Download the program and extract the it
* Put a JPG picture in the program folder `PrintAPicture-master/PrintAPicture` and name it `input.jpg`
* Run it in [Processing](http://processing.org)
* Decrease or increase the resolution with the left and right mouse buttons
* Save the STL file with the 's' key
* Print the thing.stl file!

The TestImage program makes the image that is the default `input.jpg`, it looks like this:

<img src="TestImage/input.jpg" Alt="TestImage" width=300> <img src="Images/Test2.0.jpg" Alt="Printed TestImage" width=300>

I've done some tests with a picture of me, so far these are the results:

<img src="Images/Test1.1.jpg" Alt="Test1.1" width=300> <img src="Images/Test1.0.jpg" Alt="Test1.0" width=300>

The reason part of the image is missing is because I had to scale the model *way* down. Right now the program makes a huge model (I had to use an ASCII to binary converter to get it to load), so when you scale it down part of the model gets to thin to print. Of course you can fix this by scaling it up in the z-axis, so that's what I did for the second test.

<img src="Images/Test1.2.jpg" Alt="Test1.2" width=300> <img src="Images/Test1.3.jpg" Alt="Test1.3" height=300>

This looks better I think, but with the backlight it would work better if the z-axis was inverted.
