
<img src="img/logo.png" align="center" alt="Alt text" title="Logo">

![Static Badge](https://img.shields.io/badge/Language-Flutter(Dart)-blue)
![GitHub all releases](https://img.shields.io/github/downloads/cMardc/contactsApp/total)

<h3>A very basic mobile app that made with flutter.</h3>
<img src="img/togif.gif" align="center" alt="Alt text" title="GIF From App">



<hr>
<h2>Installation</h2>

<h3>You can easily download .apk file from our webpage.</h3>
<a href="https://cmardc.github.io/contactsApp/">Download page</a>

<hr>
<h2>Build And Run</h2>
<img src="img/BashCMD.png" alt="Alt text" title="Build And Run">
<hr>

<h2>Features</h2>
<ul>
<li>It's an app that allows you to save your contacts and their numbers.</li>
<li>You can edit names and numbers in your contact list.</li>
<li>Your data is securely stored within the app.</li>
<li>The app efficiently manages and stores your data with almost no limits.</li>
<li>The app is coded in Flutter, with every error fixed.</li>
<li>It does not connect to any external database or network.</li>
<li>It saves your data on your own device</li>


<hr>
<h2>Screenshots</h2>
<img src="img/Main_Page_Blue.png" align="center" alt="Alt text" title="Main page (Blue)">
<img src="img/Add_Page_Red.png" align="center" alt="Alt text" title="Add contact page (Red)">
<img src="img/Edit_Page_Cyan.png" align="center" alt="Alt text" title="Edit contact page (Cyan)">
<hr>

<h2>How it works</h2>
<h4>As we discussed before, this app saves user data on their local device. The data app stores are list of contacts and background color.</h4>
<h4>This is possible with <a href="https://pub.dev/packages/shared_preferences">shared preferences package</a>. This package allows developers to store data in local device.</h4>
<h4>Let's look at an example here: </h4>
<img src="img/sharedprefs.png" align="center" alt="Alt text" title="Shared Preferences Example">
<h4>But it's always better to make code better. Let's create a class that will handle these for us: </h4>
<img src="img/sharedprefsclass.png" align="center" alt="Alt text" title="Class Example">
<h4>But, this can give us error sometimes. For example, if we don't set a value for tag 'name' and try to get it, this will give us an error. So, it's preferred to use it in a try & catch block: </h4>
<img src="img/trypref.png" align="center" alt="Alt text" title="Try & Catch Example">
<h4>Other important thing that helped me build this app is <a href="https://pub.dev/packages/url_launcher"> url launcher package</a>. This package allows us to redirect user to different pages.</h4>
<h4>Now, you maybe asked that why do i need to send user to a website? Actually, i don't. This package can redirect to different apps on mobile. The One I Used is 'tel'. This tag redirects to phone app in mobile devices which user can call the number of contact.</h4>
<h4>Here's an example: </h4>
<img src="img/urlExample.png" align="center" alt="Alt text" title="URL launcher example">



<hr>
<h4>Made by ~cM</h4>
<h5>Other links : </h5>
<a href="https://discord.gg/5W4XtHkc6g">Discord</a>

![Discord](https://img.shields.io/discord/1051030547402588170)


