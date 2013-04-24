
FlickrRocket is an App developed by Rahul for the Bottle Rocket Apps Internship screening.

About the app :
  The app connects to the Flickr Web service and downloads images using the information from it and displays them in an UIImageView.

Distinguished Feature:
  The normal approach would make the user wait until the Images are downloaded. This could take a long time when the network connectivity is poor. In order to address this issue, my application loads the Image to the ImageView when the first image is downloaded. In the mean while the background thread downloads the remaining images. By the time he views the first image and swipes it away, atleast a couple of other images would have been downloaded and would be viewable without waiting any longer. Thus the user's waiting time is negligible when compared to the normal approach.


Normal Features :
	1.Multi-threaded image downloading.
	2.Progress bar to indicate the download progress.
	3.Swipe Gestures included. The images wrap around when the end is reached.
	4.Supports Device Rotation.
	5.Could be run in Ipad/Iphone using the same code base.
	6.Developed without using XIBS.
	7.Cross-fade between the images displayed in the UIImageView.

Additional Features added by me:
	1.Negligible Waiting time.
	2.Proper Error Handling using Alert message when no network is available.
	3.Images wrap at both ends.
	4.UIActivity Indicator along with the UIProgressView.


How to Run the Application:
Approach 1:
	Clone the GitHub repository of this project.
	https://github.com/rahulratthen/FlickrRocket

Approach 2:
	I have attached a zip version of my XCode project. (XCode version 4.3.2). Extract that XCode project and import it in to XCode and run it.


