# 2-Dec-2024

* I'll use ChatGPT to create a simple Flutter Spielwiesn App

## Initial Prompt

> I am a volunteer helper at the Spielwiesn, south Germany's biggest board game convention. I want to create a flutter app to help both visitors browse our selection, as well as assist helpers in recommending games to visitors. Use cases for this app might be:
>
> * A group of four friends want to find a game that does not last too long
> * Someone wants to know if a game of a certain name is available
> * A visitor asks for a recent game that can be played with 6 people
>
> For that, I want to create a simple app that lets users filter the list of games that we have. The app should be all on one screen, with the top half containing the filter options, and the bottom half containing the results.
>
> First, my data source is an XML file that looks like this:
> ```
> <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
> <items totalitems="1029" termsofuse="https://boardgamegeek.com/xmlapi/termsofuse" pubdate="Mon, 02 Dec 2024 13:36:41 +0000">
> 	<item objecttype="thing" objectid="344114" subtype="boardgame" collid="125721855">
> 		<name sortindex="1">'ne Tüte Chips</name>
> 		<originalname>Bag of Chips</originalname>
> 		<yearpublished>2023</yearpublished>
> 		<image>https://cf.geekdo-images.com/zGSJMUFKDl-SCT5gh7yJwg__original/img/-oG0QmSl28LqoRAsnzwJ-W9o4b0=/0x0/filters:format(png)/pic7737582.png</image>
> 		<thumbnail>https://cf.geekdo-images.com/zGSJMUFKDl-SCT5gh7yJwg__thumb/img/7peOUJSm0Jhu4GYR74o2K78vQ8s=/fit-in/200x150/filters:strip_icc()/pic7737582.png</thumbnail>
> 		<stats minplayers="2" maxplayers="5" minplaytime="15" maxplaytime="20" playingtime="20" numowned="3355">
> 			<rating value="N/A">
> 				<usersrated value="1805"/>
> 				<average value="6.47092"/>
> 				<bayesaverage value="5.93373"/>
> 				<stddev value="1.32773"/>
> 				<median value="0"/>
> 			</rating>
> 		</stats>
> 		<status own="1" prevowned="0" fortrade="0" want="0" wanttoplay="0" wanttobuy="0" wishlist="0" preordered="0" lastmodified="2024-11-30 10:11:40"/>
> 		<numplays>0</numplays>
> 	</item>
> 	<item objecttype="thing" objectid="286535" subtype="boardgame" collid="125972663">
> 		<name sortindex="1">#mylife</name>
> 		<yearpublished>2019</yearpublished>
> 		<image>https://cf.geekdo-images.com/EPnRNQChUiAjtzqo9uvXCw__original/img/Rn3rkdYZXJACnNFAUsVmUVVAeCU=/0x0/filters:format(jpeg)/pic4894341.jpg</image>
> 		<thumbnail>https://cf.geekdo-images.com/EPnRNQChUiAjtzqo9uvXCw__thumb/img/q7o1sGf65oueVajkwTj2bXSq5gE=/fit-in/200x150/filters:strip_icc()/pic4894341.jpg</thumbnail>
> 		<stats minplayers="2" maxplayers="6" minplaytime="30" maxplaytime="30" playingtime="30" numowned="144">
> 			<rating value="N/A">
> 				<usersrated value="74"/>
> 				<average value="5.78311"/>
> 				<bayesaverage value="5.50927"/>
> 				<stddev value="1.51444"/>
> 				<median value="0"/>
> 			</rating>
> 		</stats>
> 		<status own="1" prevowned="0" fortrade="0" want="0" wanttoplay="0" wanttobuy="0" wishlist="0" preordered="0" lastmodified="2024-11-29 10:29:02"/>
> 		<numplays>0</numplays>
> 	</item>
> 	<item objecttype="thing" objectid="12920" subtype="boardgame" collid="126014992">
> 		<name sortindex="1">10 Tension</name>
> 		<originalname>Tension: The Crazy Naming Game</originalname>
> 		<yearpublished>2023</yearpublished>
> 		<image>https://cf.geekdo-images.com/DDtwpXblIkOi1ycQTYNabg__original/img/3RrWxmQH8do9rA-zz0VqOgZuNKM=/0x0/filters:format(jpeg)/pic7761232.jpg</image>
> 		<thumbnail>https://cf.geekdo-images.com/DDtwpXblIkOi1ycQTYNabg__thumb/img/HaKSHLEF7RAbUncWEEH3X4egdhE=/fit-in/200x150/filters:strip_icc()/pic7761232.jpg</thumbnail>
> 		<stats minplayers="4" maxplayers="4" minplaytime="40" maxplaytime="40" playingtime="40" numowned="527">
> 			<rating value="N/A">
> 				<usersrated value="213"/>
> 				<average value="5.77512"/>
> 				<bayesaverage value="5.51589"/>
> 				<stddev value="1.51083"/>
> 				<median value="0"/>
> 			</rating>
> 		</stats>
> 		<status own="1" prevowned="0" fortrade="0" want="0" wanttoplay="0" wanttobuy="0" wishlist="0" preordered="0" lastmodified="2024-11-30 10:33:30"/>
> 		<numplays>0</numplays>
> 	</item>
> </items>
> ```
>
> The file that should be imported is located in my project under `assets/Spieleliste.xml`.
>
> Each <item> tag in the XML represents one game, and should be mapped to a Game object as follows:
> * string name = <name>
> * int yearPublished = <yearpublished>
> * int minPlayers = <stats minplayers>
> * int maxPlayers = <stats maxplayers>
> * int minPlayTime = <stats minplaytime>
> * int maxPlayTime = <stats maxplaytime>
> * double rating = <average>
>
> If an <item> does not have all of these required fields, it should be skipped, and an error message should be logged to the console.
>
> The filter half should include filters for:
> * Name (should match all games where the typed name matches the game's name)
> * Number of players (should match all games where the typed number falls inside the inclusive interval of minplayers and maxplayers)
> * Duration (should match all games where the typed number falls inside the inclusive interval of minplaytime and maxplaytime)
> * Year (should be a year selector, and match all games where the provided year matches the yearPublished exactly)
> * Rating (should match all games where the provided rating is lower or equal than the game's rating)
> The result list should be updated whenever a change is made to any of the fields. Specifically, the result list should update its result even while you type the name.
> If one of the filter fields is empty, the respective filter should not be applied.
> Also, each filled field should have a button to clear that filter.
>
>
> The result half should display the results in a vertically scrolling list of cards, which each card containing the following information:
> * Name
> * Year
> * Rating (rounded to one decimal)
> * Minimum and maximum number of players
> * Minimum and maximum duration
>
> For example, for the first item in above list, the card should read something like:
> ```
> 'ne Tüte Chips (2023) 6.5
> 2-5 players
> 15-20 minutes
> ```
>
> Please write me a flutter application for that. The color scheme of the application should be orange. Also, I might want to witch out the data source later one, so please write it in a way that enables me to easily change the XML source to, say, a CSV source later on.

* It took me about 45 minutes to engineer that prompt
* It took chatty about 5 minutes to generate a response for that
* The result of that was already pretty good, and with some minor adjustments I had a working app after another 30 minutes

* [Time elapsed thus far: 2.5h]

# 31-May-2025

* Now continuing with this
* First, I spent some time refactoring this app into a view-controller architecture that I want to work with
* The main issue of the app as it is is, that the filter fields take up half of the screen, which leaves little room for the search results
  * Furthermore, when the keyboard is expanded, the search results can't be seen at all
  * I addressed that by combining two filter fields into one row, removing other filter fields entirely, and reducing the vertical size of the filter fields slightly
* Now, I have an app that while still unpolished, is actually useable
* [Time elapsed thus far: 4h]

# 2-Jun-2025

* Now continuing with this

* By now, the app looks pretty good already

  * You can search games by name, player count, and duration, and get a list of games displayed, updated in real time

* An essential thing that is still missing, however, is the sticker letter and type, which are important for the helpers to be able to quickly find the game

  * I'd say that's the one thing I still need for an MVP version

  * However, regrettably, that poses a challenge:

    * The XML file exported from boardgamegeek does not feature the necessary information for that
    * However, I have that information in my https://docs.google.com/spreadsheets/d/1vETdMkNoRvzOU21tow2dnDRHD3p6d52HKt4zOfi5Uw8/edit?gid=0#gid=0
    * But that means I'll have to export that, probably as a CSV, and then implement a CSV importer instead of the XML importer I currently use

  * Well, let's try it!

  * I used this prompt as a basis:

    * ````
      In the Spielwiesn app, I now want the games list to be imported from a CSV instead of an XML. A sample CSV looks like this:
      ```
      13,1,D,Karten,Familie,Karten,6.7,2005,3,6,30,30,8,1.19,,,,https://boardgamegeek.com/boardgame/17025/poison
      #mylife (My Life),2,M,Karten,Familie,Karten,5.8,2019,2,6,30,30,10,1.67,,,,https://boardgamegeek.com/boardgame/286535/mylife
      10 Tension,2,T,Normal,Party,Karten,5.8,1992,2,99,40,40,9,1,,,,https://boardgamegeek.com/boardgame/12920/tension-the-crazy-naming-game
      12 Thieves,1,T,Normal,Familie,Brett,6.4,2006,2,4,45,45,8,1.87,,,,https://boardgamegeek.com/boardgame/22278/12-thieves
      13 Minuten: Die Kubakrise 1961 (Dreizehn),1,D,Zwei,Strategie,Karten,6.4,2017,2,2,13,13,10,2.06,,,,https://boardgamegeek.com/boardgame/203828/13-minutes-the-cuban-missile-crisis-1962
      13 Tage: Die Kubakrise 1962 (Dreizehn),1,D,Zwei,Strategie,Karten,7.2,2016,2,2,45,45,12,2.33,,,,https://boardgamegeek.com/boardgame/177590/13-days-the-cuban-missile-crisis-1962
      3 Chapters,12,C,Karten,Familie,Karten,7.2,2024,2,6,30,30,10,1.75,,,,https://boardgamegeek.com/boardgame/423517/3-chapters
      3 Minute Crazy Cafe (three drei),2,T,Kind,Party,Karten,5.8,2023,2,6,9,9,7,1,x,,,https://boardgamegeek.com/boardgame/394751/3-minute-crazy-cafe
      3 sind eine zu viel!,1,D,Karten,Familie,Karten,6.5,2015,2,4,25,25,8,1.41,,x,,https://boardgamegeek.com/boardgame/181867/3-sind-eine-zu-viel
      4 Seasons (Four),1,S,Zwei,Strategie,Karten,6.2,2010,2,2,15,15,10,1.82,,,x,https://boardgamegeek.com/boardgame/73312/4-seasons
      ```
      The 18 columns in this CSV represent the following attributes of a game:
      1: Name
      2: Copies owned
      3: Inventory letter
      4: Inventory type
      5: Category
      6: Material type
      7: Rating
      8: Year published
      9: Min players
      10: Max players
      11: Min playing time
      12: Max playing time
      13: Min age
      14: Complexity
      15: Cooperative flag
      16: Novelty flag
      17: Premium flag
      18: Link
      
      For the record, currently, the Game class looks like this: 
      ```
      class Game {
        final String name;
        final int yearPublished;
        final int minPlayers;
        final int maxPlayers;
        final int minPlayTime;
        final int maxPlayTime;
        final double rating;
      
        Game({
          required this.name,
          required this.yearPublished,
          required this.minPlayers,
          required this.maxPlayers,
          required this.minPlayTime,
          required this.maxPlayTime,
          required this.rating,
        });
      }
      ```
      Please generate me an CSV Game Repository class that can import the games from the new CSV source file, and maps the columns like follows:
      1: Name => name
      2: Copies owned => copiesOwned (new int field)
      3: Inventory letter => inventoryLetter (new string field)
      4: Inventory type => inventoryType (new enum field with the following possible values: Unknown, Karten, Kind, Normal, Zwei; should default to Unknown if the CSV has no value in that column)
      5: Category => category (new enum field with the following possible values: Unknown, Familie, Geschick, Party, Quiz, Rätsel, Strategie; should default to Unknown if the CSV has no value in that column)
      6: Material type => materialType (new enum field with the following possible values: Unknown, App, Brett, Karten, Material, Plättchen, Storybook, Tableau, Würfel; should default to Unknown if the CSV has no value in that column)
      7: Rating => rating
      8: Year published => yearPublished
      9: Min players => minPlayers
      10: Max players => maxPlayers
      11: Min playing time => minPlayTime
      12: Max playing time => maxPlayTime
      13: Min age => minAge (new int field)
      14: Complexity => complexity (new double field)
      15: Cooperative flag => cooperative (new boolean field, that should be true if there's any value in that column, and false if the column is empty)
      16: Novelty flag => novelty (new boolean field, that should be true if there's any value in that column, and false if the column is empty)
      17: Premium flag => premium (new boolean field, that should be true if there's any value in that column, and false if the column is empty)
      18: Link => link (new string field)
      ````

  * From that, ChatGPT again generated me something that almost worked, and served as a great basis to work from

  * With a little extra work, I then managed to get it to function, and now I can successfully import the games from my CSV file

  * On a pleasant note, the CSV that contains MORE data is also just 10% of the size of the XML

* [Time elapsed thus far: 5.75h] 

* Okay, I now did some more minor refinements here, and am now ready for the next step

* That is, making it so that the sticker letter and type are displayed in the search results

  * The first attempt already looked pretty good, but the result that Chatty gave me had the sticker type displayed below the sticker, and not inside
  * Asking chatty to refine this while giving him clear instructions on what I want resulted in him giving me a version that now looks really great!
  * I now did some additional refinement of this, and I think it looks great now!

* With that, I think this is now MVP-complete!

* [Time elapsed thus far: 7h] 

* I still got several hours of time to spend on this today, so let's add a couple of nice to have features

* For starters, it would be nice to have Spielwiesn-colors on this

  * I now did this

* Next, it would be great to have a "smart search" that covers for numbers written out (or not) in game names and other common situations that make searching difficult

  * Examples would be:
    * King of 12 (twelve)
    * Ierusalem: Anno Domini (Jerusalem)
    * Set³ (hoch drei)
    * Krazy Wordz (Crazy Words)
  * I now managed to do that by adding an "Additional Search Anchors" column to the G-Drive spreadsheet, which contains words that the search will target, but which won't be displayed in the game's name
  * That works pretty well!

* Okay, what next?

* How about adding complexity and rating as display and search fields?

  * The downside is that this would take up more space again
  * But let's try it out and see how it looks
  * I now ended up adding complexity, category and co-op, since I figured the rating would not be intuitive
  * The search for those is not implemented yet

* Because I found a bug: Games with commas in their names are broken

  * I was now able to fix that by using a proper CSV parser instead of blindly separating by commas

* Now back to the filters for complexity, category and co-op

  * Here, chatty wasn't able to help me because the `DropdownButtonFormField` in Flutter isn't really that good
  * Maybe I can make it work with this?
    * https://pub.dev/packages/multi_dropdown/example 
  * While that works nicely, it has the problem that it overflows
  * So maybe another approach is needed
  * I now managed to get something to work using popups
    * While the filtering works, the state in the popups is not updated
    * Let's see if I can fix that
    * Alright, thanks to Chatty, I was able to fix that really quickly
  * Now this basically works, but I see some potential for polishing, so let me get to that
  * Alright, now I also added additional functionality, such as highlighting the filter buttons if filters are active, and an "Alle" option that can be used to select or deselect all filters simultaneously

# ⚓