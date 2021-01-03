![balena ADS-B Flight Tracker](https://raw.githubusercontent.com/ketilmo/balena-ads-b/master/docs/images/header.png)

**ADS-B Flight Tracker running on balena with support for Dump1090-fa, PiAware, Fr24Feed, PlaneFinder, and OpenSky Network.**

Contribute to the flight tracking community! Feed your local ADS-B data from an [RTL-SDR](https://www.rtl-sdr.com/) USB dongle and a supported device (see below) running balenaOS to the tracking services [FlightAware](https://flightaware.com/), [Flightradar24](https://www.flightradar24.com/), [Plane Finder](https://planefinder.net/), and [OpenSky Network](https://opensky-network.org/). In return, you will receive free premium accounts worth several hundred dollars/year!

👉🏻&nbsp;<a href="https://buttondown.email/balena-ads-b"> Subscribe to our newsletter</a> to stay updated on the latest development of balena ADS-B Flight Tracker.&nbsp;👈🏻 

**Supported devices**
<table>
<tr><td>
<img height="24px" src="https://files.balena-cloud.com/images/fincm3/2.58.3%2Brev1.prod/logo.svg" alt="fincm3" style="max-width: 100%; margin: 0px 4px;"></td><td> balenaFin</td>
</tr>
<tr><td>
<img height="24px" src="https://files.balena-cloud.com/images/intel-nuc/2.50.1%2Brev1.prod/logo.svg" alt="intel-nuc" style="max-width: 100%; margin: 0px 4px;"></td><td> Intel NUC</td>
</tr>
<tr><td>
<img height="24px" src="https://files.balena-cloud.com/images/raspberry-pi/2.54.2%2Brev1.prod/logo.svg" alt="raspberry-pi" style="max-width: 100%; margin: 0px 4px;"></td><td> Raspberry Pi Zero and Zero W</td>
</tr>
<tr><td>
<img height="24px" src="https://files.balena-cloud.com/images/raspberry-pi/2.54.2%2Brev1.prod/logo.svg" alt="raspberry-pi" style="max-width: 100%; margin: 0px 4px;"></td><td>Raspberry Pi 1 Model B+</td>
</tr>
<tr><td>
<img height="24px" src="https://files.balena-cloud.com/images/raspberrypi3/2.58.3%2Brev1.prod/logo.svg" alt="raspberrypi3" style="max-width: 100%; margin: 0px 4px;"></td><td>Raspberry Pi 3 Model B+</td>
</tr>
<tr><td>
<img height="24px" src="https://files.balena-cloud.com/images/raspberrypi4-64/2.65.0%2Brev1.prod/logo.svg" alt="raspberrypi4-64" style="max-width: 100%; margin: 0px 4px;"></td><td>Raspberry Pi 4 Model B</td>
</tr>
</table>

This project is inspired by and has borrowed code from the following repos and forum threads:  

 - https://github.com/compujuckel/adsb-docker
 - https://bitbucket.org/inodes/resin-docker-rtlsdr
 - [https://discussions.flightaware.com/](https://discussions.flightaware.com/t/howto-install-piaware-4-0-on-debian-10-amd64-ubuntu-20-amd64-kali-2020-amd64-on-pc/69753/3)

Thanks to [compujuckel](https://github.com/compujuckel/), [Glenn Stewart](https://bitbucket.org/inodes/), and [abcd567a](https://github.com/abcd567a) for sharing!

## Part 1 – Build the receiver

We'll build the receiver using the parts that are outlined on the Flightradar24, FlightAware and RadarBox websites: 
- https://www.flightradar24.com/build-your-own
- https://flightaware.com/adsb/piaware/build
- https://www.radarbox24.com/raspberry-pi

These sites suggest the Raspberry Pi 3 Model B+ as the preferred device, but this project runs on all the devices mentioned above. Still, if you plan to run a lot of services simultaneously, you should probably go for the Raspberry Pi 3 Model B+, the even more powerful Raspberry Pi 4 Model B, an Intel NUC, or the balenaFin.

Please note that the Raspberry Pi Zero comes without ethernet and WiFi, however. If you need this, you will have to buy [a breakout cable](https://shop.pimoroni.com/products/three-port-usb-hub-with-ethernet-and-microb-connector), too. The Raspberry Pi Zero comes with WiFi only.

In addition to the device, you will need an RTL-SDR compatible USB dongle. The dongles are based on a digital television tuner, and numerous types will work – both generic TV sticks and specialized ADS-B sticks (produced by FlightAware). Although both options work, the ADS-B sticks seem to perform a little better.

## Part 2 – Setup balena and configure the device

[![Deploy with button](https://www.balena.io/deploy.svg)](https://dashboard.balena-cloud.com/deploy?repoUrl=https://github.com/ketilmo/balena-ads-b&defaultDeviceType=raspberrypi3)

or

 1. [Create a free balena account](https://dashboard.balena-cloud.com/signup). During the process, you will be asked to upload your public SSH key. If you don't have a public SSH key yet, you can [create one](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
 2. Sign in to Balena and head over to the [*Applications*](https://dashboard.balena-cloud.com/apps) panel.
 3. Create an application with the name of your choice, for the device type of your choice. In the dialog that appears, make sure to pick a *Default Device Type* that matches your device. If you want to use WiFi (and your device supports it), specify the SSID and password here, too. (If your device comes up without an active connection to the Internet, the `wifi-connect` container will create a network with a captive portal to connect to a local WiFi network. The SSID for the created hotspot is `balenaWiFi`, and the password is`balenaWiFi`. When connected, visit `http://192.168.42.1:8181/` in your web browser to setup the connection.
 4. balena will create an SD card image for you, and this will start downloading automatically after a few seconds. Flash the image to an SD-card using balena's dedicated tool [balenaEtcher](https://www.balena.io/etcher/).
 5. Insert the SD card in your receiver, and connect it to your cabled network (unless you plan to use WiFi only, and configured that in step 3). 
 6. Power up the receiver.
 7. From the balena dashboard, navigate to the application you just created. Within a few minutes, a new device with an automatically generated name should appear. Click on it to open it.
 8. Rename your device to your taste by clicking on the pencil icon next to the current device name.
 9. Next, we'll configure the receive with its geographic location. Unless you happen to know this by heart, you can use [Google Maps](https://maps.google.com) to find it. When you click on your desired location on the map, the corresponding coordinates should appear. We are looking for the decimal coordinates, which should look similar to this: 60.395429, 5.325127.
 10. Back in the balena console, verify that you have opened up the view for your desired device. Click on the *Device Variables*-button – *D(x)*. Add the following two variables: `LAT` *(Receiver Latitude)*, e.g. with a value such as `60.12345` and `LON` *(Receiver Longitude)*, e.g. with a value such as `4.12345`.
 11. Now, you're going to enter the receiver's altitude in *meters* above sea level in a new variable named `ALT`. If you don't know the altitude, you can find it using [one of several online services](https://www.maps.ie/coordinates.html). If your antenna is mounted above ground level, remember to add the approximate number of corresponding meters.
 12. Almost there! Next, we are going to push this code to your device through the balena cloud. Head into your terminal and clone this repository to your local computer: `git clone git@github.com:ketilmo/balena-ads-b.git`
 13. Add a balena remote to your newly created local Git repo. You'll find the exact command you need for this at the Application page in your balena dashboard. It should look something like this: `git remote add balena your_username@git.balena-cloud.com:your_username/your_application_name.git`
 14. Push the code to Balena's servers by typing `git push balena master`. 
 15. Now, wait while the Docker containers build on balena's servers. If the process is successful, you will see a beautiful piece of ASCII art depicting a unicorn:
<pre>
			    \
			     \
			      \\
			       \\
			        >\/7
			    _.-(6'  \
			   (=___._/` \
			        )  \ |
			       /   / |
			      /    > /
			     j    < _\
			 _.-' :      ``.
			 \ r=._\        `.
			<`\\_  \         .`-.
			 \ r-7  `-. ._  ' .  `\
			  \`,      `-.`7  7)   )
			   \/         \|  \'  / `-._
			              ||    .'
			               \\  (
			                >\  >
			            ,.-' >.'
			           <.'_.''
			             <'

</pre>
 15. Wait a few moments while the Docker containers are deployed and installed on your device. The groundwork is now done – good job!


## Part 3 – Configure FlightAware
### Alternative A: Port an existing FlightAware receiver
If you have previously set up a standalone FlightAware receiver, and want to port it to balena, you only have to do the following steps:

 1. Head back to your device's page in the balena dashboard and click on the *Device Variables*-button – *D(x)*. Add the following variable: `FLIGHTAWARE_FEEDER_ID`, then paste your *Unique Identifier* key, eg. `134cdg7d-7533-5gd4-d31d-r31r52g63v12`. The ID can be found on the *My ADS-B* section at the FlightAware website.
 2. From the balena dashboard, restart the *piaware* application under *Services* by clicking the "cycle" icon next to the service name.

### Alternative B: Setup a new FlightAware receiver
If you have not previously set up a FlightAware receiver that you want to reuse, do the following steps:


 1. Register [a new account](https://flightaware.com/account/join/) at FlightAware: 
 2. Login using your newly created credentials.
 3. While being connected to the same network (either cabled or wireless) as your receiver is linked to, head to FlightAware's *[Claim Receiver](https://flightaware.com/adsb/piaware/claim)* page.
 4. Check if any receivers show up under the *Linked PiAware Receivers* heading. (If not, wait about five minutes and click the *Check Again for my PiAware*-button.) Hopefully, your receiver is now visible under the *Linked PiAware Receivers* header.
 5. In the left-hand-side menu on the top of the page, click the *My ADBS-B* menu item. Your device should be listed in an orange rectangle. Next, click the cogwheel icon on the right-hand side of the screen.
 6. Click the *Configure Location*-button, and verify that the location matches the coordinates you entered earlier. If not, correct them.
 7. Click the *Configure Height*-button, and specify the altitude of your receiver. The value should match the number you entered in the `ALT` variable in part 1.
 8. If you don't face any bandwidth constraints, enable multilateration (MLAT). Enabling MLAT lets your receiver connect to other nearby receivers to multilaterate the positions of aircraft that does not report their position through ADS-B. This option increases the bandwidth usage a bit but gives more visible aircraft positions in return. 
 9. Specify the other settings in the FlightAware lightbox according to your personal preferences.
 10. Close the lightbox. Find and copy your receiver's *Unique Identifier*. It should look something like this: `134cdg7d-7533-5gd4-d31d-r31r52g63v12`.
 11. Head back to the balena dashboard and your device's page. Click on the *Device Variables*-button – *D(x)*. Add the following variable: `FLIGHTAWARE_FEEDER_ID`, then paste your *Unique Identifier*, eg. `134cdg7d-7533-5gd4-d31d-r31r52g63v12`.

## Part 4 – Configure FlightRadar24
### Alternative A: Port an existing FlightRadar24 receiver
If you have previously set up a FlightRadar24 receiver and want to port it to balena, you only have to do the following steps:

 1. Head back to the balena dashboard and your device's page. Click on the *Device Variables*-button – *D(x)*. Add a variable named `FR24_KEY` and paste the value of your existing FlightRadar24 key, e.g. `dv4rrt2g122g7233`. The key is located in the FlightRadar24 config file, which is usually found here: `/etc/fr24feed.ini`. (If you are unable to locate your old key, retrieve or create a new one it by following the steps in alternative B.)
 2. Restart the *fr24feed* application under *Services* by clicking the "cycle" icon next to the service name.

### Alternative B: Setup a new FlightRadar24 receiver
If you have not previously set up a FlightRadar24 receiver that you want to reuse, do the following steps:

 1. Head back to your device's page on the balena dashboard.
 2. Inside the *Terminal* section, click *Select a target*, then *fr24feed*, and finally *Start terminal session*.
 3. This will open a terminal which lets you interact directly with your FlightRadar24 container.
 4. At the prompt, enter `fr24feed --signup`.
 5. When asked, enter your email address.
 6. You will be asked if you have a FlightRadar sharing key. Unless you have one from the past that you would like to reuse, press return here.
 7. If you want to activate multilateration, type `yes` at the next prompt. If you have restricted bandwidth available, consider leaving it off by typing `no`. 
 8. Enter the receiver's latitude. This should be the exact same value that you entered in the `LAT` variable in part 1.
 9. Enter the receiver's longitude. This should be the exact same value that you entered in the `LON` variable in part 1.
 10. Finally, enter the receiver's altitude in *feet*. You can calculate this by multiplying the value that you entered in the `ALT` variable in part 1 by 3.28.
 11. Now, a summary of your settings will be displayed. If you are happy with the result, type `yes` to continue.
 12. Under receiver type, choose `4` for ModeS Beast.
 13. Under connection type, choose `1` for network connection.
 14. When asked for your receiver's IP address/hostname, enter `dump1090-fa`.
 15. Next, enter the data port number: `30005`.
 16. Type `no` to disable the RAW data feed on port 30334.
 17. Type `no` to disable the Basestation data feed on port 30003.
 18. Enter `0` to disable log file writing.
 19. When asked for a log file path, just hit return.
 20. The configuration will now be submitted, and you are redirected back to the terminal.
 21. At the prompt, type `cat /etc/fr24feed.ini`. Your FlightRadar settings will be displayed. 
 22. Find the line starting with `fr24key=`, and copy the string between the quotes. It will look something like this: `dv4rrt2g122g7233`.
 23. Click on the *Device Variables*-button – *D(x)* in the left-hand menu. Add a variable named `FR24_KEY` and paste the value from the previous step, e.g. `dv4rrt2g122g7233`.
 24. Restart the *fr24feed* application under *Services* by clicking the "cycle" icon next to the service name.
 25. As soon as your receiver starts receiving data, you will receive an e-mail from FlightRadar24 containing your login credentials.

## Part 5 – Configure Plane Finder
### Alternative A: Port an existing Plane Finder receiver
If you have previously set up a Plane Finder receiver and want to port it to balena, you only have to do the following steps:

 1. Head back to the balena dashboard and your device's page. Click on the *Device Variables*-button – *D(x)*. Add a variable named `PLANEFINDER_SHARECODE` and paste the value of your existing Plane Finder key, e.g. `7e3q8n45wq369`. You can find your key at Plane Finder's *[Your Receivers](https://planefinder.net/account/receivers)* page.
 2. On your device's page in the balena dashboard, restart the *planefinder* application under *Services* by clicking the "cycle" icon next to the service name.

### Alternative B: Setup a new Plane Finder receiver
If you have not previously set up a Plane Finder receiver that you want to reuse, do the following steps:

 1. Register a new [Plane Finder account](https://planefinder.net).
 2. Locate your local clone of this git repo, `balena-ads-b`, then navigate to the folder `planefinder`.
 3. Open the file `SharecodeGenerator.html` in your web browser.
 4. Fill in the form to generate a Plane Finder share code. Use the same email address as you used when registering for the Plane Finder account. For *Receiver Lat*, use the value from the `LAT` variable in part 2. For *Receiver Lon*, use the value from the `LON` variable. Lastly, click the *Create new sharecode* button. A sharecode should appear in a few seconds, it should look similar to `6g34asr1gvvx7`. Copy it to your clipboard. Disregard the rest of the form – you don't have to fill this out.
 5. Open Plane Finder's *[Your Receivers](https://planefinder.net/account/receivers)* page. Under the *Add a Receiver* heading, locate the *Share Code* input field. Paste the sharecode from the previous step, then click the *Add Receiver*-button.
 6. Head back to the Balena dashboard and your device's page. Click on the *Device Variables*-button – *D(x)*. Add a variable named `PLANEFINDER_SHARECODE` and paste the value of the Plane Finder key you just created, e.g. `7e3q8n45wq369`.
 7. On your device's page in the Balena dashboard, restart the *planefinder* application under *Services* by clicking the "cycle" icon next to the service name.

## Part 6 – Configure OpenSky Network
### Alternative A: Port an existing OpenSky Network receiver
If you have previously set up a OpenSky Network receiver and want to port it to balena, you only have to do the following steps:

 1. Head back to the balena dashboard and your device's page. Click on the *Device Variables*-button – *D(x)*.
 2. Add a variable named `OPENSKY_USERNAME` and paste your OpenSky Network username, e.g. `JohnDoe123`. You can find your username on your OpenSky Network *[Dashboard](https://opensky-network.org/my-opensky)* page.
 3. Add a variable named `OPENSKY_SERIAL` and paste the value of your existing OpenSky Network serial number, e.g. `1663421823`. You can find your serial your OpenSky Network *[Dashboard](https://opensky-network.org/my-opensky)* page.
 4. On your device's page in the balena dashboard, restart the *opensky-network* application under *Services* by clicking the "cycle" icon next to the service name.

### Alternative B: Setup a new OpenSky Network receiver
If you have not previously set up a OpenSky Network receiver that you want to reuse, do the following steps:

 1. Register a new [OpenSky Network account](https://opensky-network.org/index.php?option=com_users&view=registration). Make sure to activate it using the email that's sent to you. Take note of your username, you will need it soon.
 2. Head back to your device's page on the balena dashboard. Click on the  _Device Variables_-button –  _D(x)_  in the left-hand menu. Add a variable named `OPENSKY_USERNAME` and populate it with your newly created OpenSky Username, e.g.  `JohnDoe123`.
 3. Head back to your device's *Summary* page. Restart the *opensky-network* application under *Services* by clicking the "cycle" icon next to the service name. Wait for the service to finish restarting.
 4. Inside the *Terminal* section, click *Select a target*, then *opensky-network*, and finally *Start terminal session*.
 5. This will open a terminal which lets you interact directly with your OpenSky Network container.
 6. Once the terminal prompt appears, enter `/getserial.sh` (including the leading slash), then press return.
 7. If everything goes according to plan, your OpenSky Network serial number will soon appear. Copy it.
 8. Click on the  _Device Variables_-button –  _D(x)_  in the left-hand menu. Add a variable named  `OPENSKY_SERIAL`  and paste the value from the previous step, e.g.  `1267385439`.
 9. Go back to your device's *Summary* page. Restart the  _opensky-network_  application under  _Services_  by clicking the “cycle” icon next to the service name.
 10. Head over to your OpenSky Network *[Dashboard](https://opensky-network.org/my-opensky)* and verify that your receiver shows up and feeds data.

## Part 7 – Configure RadarBox
### Alternative A: Port an existing RadarBox receiver
If you have previously set up a RadarBox receiver and want to port it to Balena, you only have to do the following steps:

 1. Head back to the Balena dashboard and your device's page. Click on the *Device Variables*-button – *D(x)*. Add a variable named `RB24_KEY` and paste the value of your existing RadarBox key, e.g. `546b69e69b4671a742b82b10c674cdc1` and a variable named `RB24_STN` with a similar value like this: `EXTRPI000000`. The key is located in the RadarBox config file, which is usually found here: `/etc/rbfeeder.ini`. You can find your key at AirNav RadarBox's *[Account](https://www.radarbox24.com/)*
 2. Restart the *rb24feed* application under *Services* by clicking the "cycle" icon next to the service name.

### Alternative B: Setup a new RadarBox receiver
If you have not previously set up a RadarBox receiver that you want to reuse, do the following steps:

 1. Head back to your device's page on the Balena dashboard.
 2. Inside the *Terminal* section, click *Select a target*, then *rb24feed*, and finally *Start terminal session*.
 3. This will open a terminal which lets you interact directly with your RadarBox container.
 4. At the prompt, enter `rbfeeder`.
 5. A summary of your settings will be displayed. Find the line with key like this `546b69e69b4671a742b82b10c674cdc1`
 6. Please insert your sharing key under your *[Account](https://www.radarbox24.com/raspberry-pi/claim)*
 7. Click on the *Device Variables*-button – *D(x)* in the left-hand menu. Add a variable named `RB24_KEY` and paste the value from the previous step, e.g. `546b69e69b4671a742b82b10c674cdc1` and add a variable named `RB24_STN` with a similar value like this, which is your station id: `EXTRPI000000`.
 8. Restart the *rb24feed* application under *Services* by clicking the "cycle" icon next to the service name.
 9. As soon as your receiver starts receiving data, you will receive an e-mail from RadarBox containing your login credentials. 

## Part 8 – Exploring flight traffic locally on your device
If the setup went well, you should now be feeding flight traffic data to several online services. In return for your efforts, you will receive access to the providers' premium services. But in addition to this, you can explore the data straight from your device, raw and unedited. And that's part of the magic, right?

When you have local network access to your receiver, you can explore the data straight from the source. Start by opening your device page in balena console and locate the `IP ADDRESS` field, e.g. `10.0.0.10`. Then, add the desired port numbers specified further below.

Away from your local network but still eager to know what planes are cruising over your home? Here, balena's builtin *Public Device URL* comes in handy. Open your device page in balena console and locate the `PUBLIC DEVICE URL` header, and flip the switch below to enable it. Finally, click on the arrow icon next to the button, add the desired URL postfix specified below and voila – you should see what's going on in your area.

 **Dump1090's Radar View**
This view visualizes everything that your receiver sees, including multilaterated plane positions. When you are in your local network, head to `YOURIP:8080` to check it out. When remote, open balena's *Public Device URL* and add `/dump1090-fa/` to the tail end of the URL, e.g. `https://6g31f15653bwt4y251b18c1daf4qw164.balena-devices.com/dump1090-fa/`

**Plane Finder's Radar View**
It's similar to Dump1090, but Plane Finder adds 3D visualization and other nice viewing options. Head to `YOURIP:30053` to check it out. When remote, open balena's *Public Device URL* and add `/planefinder/` to the tail end of the URL, e.g. `https://6g31f15653bwt4y251b18c1daf4qw164.balena-devices.com/planefinder/`

**Flightradar24 Status Page**
Less visual than the two other options, Flightradar24's status page gives you high level statistics and a metrics about how your feeder is doing. Head to `YOURIP:8754` to check it out. When remote, open balena's *Public Device URL* and add `/fr24feed/` to the tail end of the URL, e.g. `https://6g31f15653bwt4y251b18c1daf4qw164.balena-devices.com/fr24feed/`

## Part 9 - (Optional) Add a digital display
balena also produces a project that can be easily configured to display a webpage in kiosk mode on a digital display called balenaDash. By dropping that project into this one, we can automatically display a feeder page directly from the Pi. Ensure you have cloned this repository recursively (`git clone --recursive {{repository URL}}`). We can then set a `LAUNCH_URL` device variable configured to connect to `http://{{YOURIP or YOURSERVICENAME}}:YOURSERVICEPORT` (where the service/port are one of the frontends above, like `http://planefinder:30053`) and that will automatically be displayed on the attached display. The balenaDash service can be configured locally by accessing the webserver on port 8081.

Enjoy!
