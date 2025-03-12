### Summary: Include screen shots or a video of your app highlighting its features


Savr downloads a list of recipes from the internet, and displays them in a minimal, picture 
focused UI to help you decide what you want to eat. 

The design is based on a school project my wife did a few years ago - she's a UX designer, 
and when she did this project, I was one of her "users" providing feedback on the designs,
and i've been meaning to build this, but she always said no. But once it was for a interview, 
then she was wiling to let me build it. So thank you for that! 

![<# alt text #>](README/Savr%20-%20Scrolled.png "Savr - Scrolled.png")

![<# alt text #>](README/Savr%20-%20Refreshing.png "Savr - Refreshing.png")


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?


I built the UI first, because that is my weakest area of SwiftUI development and I wanted 
to give myself time to explore options and learn as I go. 

I created ViewModels with testing data so I could see the layouts and items in action, in 
both the Content Preview, and in the App, before hooking up any data or image caching. 

My first version made use of SwiftUI's AsyncImage to download a test image (whose URL is 
still used in the Unit Tests) so that I could see the UI in action without having to build everything. 


### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?


I probably spent 10 hours total - between using this project to level up my SwiftUI knowledge 
and just needing to google things like FileManager to make sure I was using it in a decent way.

It was around 3 hours doing the UI, 2 hours doing TTD on the Network implementation, 
3 hours doing TDD on the Image Caching implementation, 1 hour debugging some nasty issues I ran into,
and 1 hour doing this write-up for the README. 

I did the UI first - In my experience, the designs I receive are experimental, so the faster 
I can have something fake in the design teams hands so they can play with it, the faster they 
learn that something they designed isn't working the way they want, and they can still make 
propose and test changes while i'm working on the business logic. 


### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?


I initially wanted to use List and not LazyVGrid for the table. My assumption is that LazyVGrid 
will eventually have both memory and performance based issues if it is forced to display too 
many recipes at once, and List seems to be the SwiftUI successor to UICollectionView, with
cell reuse. But I timeboxed myself 30 minutes to figure out how to customize list cells the 
way that I wanted, and didn't come across a customization that I liked in that timeframe, 
so I dropped back to LazyVGrid. I've actually always wanted to make my own recipe app, 
I like cooking for my wife, but I have no interest in learning to cook, so I'll probably 
come back to this project and keep trying the more performant solution later, even if that means
implementing a CollectionView in Swift in using it from the SwiftUI. 


### Weakest Part of the Project: What do you think is the weakest part of your project?


The assignment asked for this project to be production level code, and I've followed that 
for the most part, but there are a few things I would do in a production app that I chose 
not to spend the time on here, yet. 

1) A font system - You'll see i've used system fonts, with hardcoded sizes and weights, and
that's a lazy approach that saved my time, but in a production application, I would want a text
styling system where things like font size, weight, text spacing, etc, are predefined by 
(preferably in concert with the design team) and where I could add them all to a Text() 
with a custom modifier. I built something like this for Miles, which is all in Swift, and 
something else in SwiftUI using a custom modifier for TwinMind, my wifes company, in SwiftUI.

2) A color system - I've also hardcoded the colors for things like backgrounds and texts in 
this app - but something I would do in a production app is define a purpose driven nomenclature
for colors. In the past, I've done things like primaryColor and borderColor and scrimColor.
Not only does this reduce mistakes (like copypasting the wrong color into a label or mistyping it)
but it makes it very easy to do sweeping design changes, if we want to rebrand or whitelabel 
the application.

3) Localization - I didn't bother localizing the couple of texts that I don't fetch from the 
provided API, but I obviously would in a production app. 

Beyond that, what I consider to be the big weakness is the aforementioned performance issue 
that I believe will happen with LazyVGrid if the recipes list becomes too long. 


### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.


I ran into some really nasty bugs that I thought were interesting to talk about:

1) Before I learned how UIRefreshControl is implemented in SwiftUI, and how hard it is to 
customize, I had built myself a loadingView that was supposed to display while the refresh 
control was refreshing, and I created a State variable on my RecipeListView.ViewModel to track
whether RecipeListView was loading or not. When I abandoned that idea for time, i forgot to
remove the State variable. 

What the app did was: it loaded the list perfectly on first launch, then went blank when it
was pulled-to-refresh, because the network requests were getting cancelled, which went into 
the do/catch case I had set up for malformed JSON UI testing. 

What I realized was, I was changing my State variable when I fetched from the network, and SwiftUI
was helpfully redrawing my view, releasing the old one, and that was why my network requests 
were getting canceled. I removed the offending state variable, and pull to refreshes stopped 
emptying my list. 

2) I encountered an issue where the LazyVGrid wouldn't scroll beyond the first offscreen row of items. 
It turned out to be because I had RecipeListView's GeometryReader as the child of the ScrollView,
because I wanted to know what space the scrollView was allotted, but since ScrollView and 
GeometryReader both rely on their parent for sizing, they weren't sizing properly in that 
configuration. I had to move GeometryReader to the top level, and change my math to accomodate
paddings being on the scrollView inside the GeometryReader, for the items to size and scroll properly.
