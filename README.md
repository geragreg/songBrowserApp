F-Secure homework iOS application README file
Created by: Gergely Horváth
Date: 20.03.2016
All rights reserved

This README file describes high-level decisions and description of the application. The code is documented inline.

App description:

This is a basic song browser application, which fetches its data from iTunes. The current version fetches the data from the following URL: 
https://itunes.apple.com/fi/rss/topsongs/limit=100/json. This is the source for the Finnish top 100 songs according to Apple. 

I have decided to create a dynamic application rather than one with hardcoded data as it is more real-life and useful.

I have implemented a JSON parser both for getting the information for the songs and also a separate data downloader for downloading the images for the songs based on the URL I receive from the JSON. For the image downloads I have implemented a basic caching mechanism to prevent high amount of data to be downloaded multiple times. 

The application conforms to the required feature list by F-Secure, though future development plans include:
 - selecting country at the start, thus personalizing the application more
 - redirecting feature (button) at a song to iTunes, if the user would like to buy it 
 - mini song player to play the 30 second long preview of a song
 - persistent data storage of lists, and highlighting changes in the order of songs
 - exchange the randomly generated description text with actual description of the song

 Contact information: geragreg91@gmail.com