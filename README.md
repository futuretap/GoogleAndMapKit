About
-----

This is a demo project showcasing features of Google Maps SDK and MapKit. If you speak German, please check out the article:

**Landkarten in Apps**  
Vorteile und Nachteile der Karten-Frameworks von Apple und Google  
[Mac & i 4/2014, page 154](http://www.heise.de/mac-and-i/heft/2014/4/154/)  



Obtaining an API Key
--------------------

You must obtain an API key for the sample app in the [Google APIs Console](https://code.google.com/apis/console/?noredirect).

1. Create an API project in the [Google APIs Console](https://code.google.com/apis/console/?noredirect).

2. Select the **Services** pane in your API project, and enable the *Google Maps SDK for iOS*. This displays the [Google Maps Terms of Service](https://developers.google.com/maps/terms).

	![Enable the *Google Maps SDK for iOS](Screenshots/API%20Key%201.png)

3. Select the **API Access** pane in the console, and click **Create new iOS key**.

4. Enter one or more bundle identifiers as listed in the project settings, in our case `com.example.SDKDemos`.

	![Enable the *Google Maps SDK for iOS](Screenshots/API%20Key%202.png)

5. Click **Create**.

6. In the **API Access** page, locate the section **Key for iOS apps (with bundle identifiers)** and note or copy the 40-character **API key**.



Adding the Google Maps SDK for iOS to your project
--------------------------------------------------

1. Open the project in Xcode

2. [Download the GoogleMaps SDK](https://developers.google.com/maps/documentation/ios/releases) and unzip it

3. Drag the `GoogleMaps.framework` bundle to the **Frameworks** group of your project.
	
	![Add GoogleMaps Framework](Screenshots/Add%20GoogleMaps%20Framework%201.png)
	
	When prompted, select **Copy items into destination group's folder**:
	
	![Add GoogleMaps Framework 2](Screenshots/Add%20GoogleMaps%20Framework%202.png)

4. Right-click `GoogleMaps.framework` in your project, and select **Show In Finder**.

5. Drag the `GoogleMaps.bundle` from the `Resources` folder to your project. We suggest putting it in the Frameworks group.

	![Add GoogleMaps Framework 3](Screenshots/Add%20GoogleMaps%20Framework%203.png)

	When prompted, ensure *Copy items into destination group's folder* is **not selected**:

	![Add GoogleMaps Framework 4](Screenshots/Add%20GoogleMaps%20Framework%204.png)

6. Add your API key to `SDKDemoAPIKey.h`.
