# flutter_localization

here are many tutorials on **flutter localization**, but many of them just show how to implement localization in a single file. When you come to using it in a real application that has many different files thats when you may run into a few issues. 

If you have not done so already, please start by reading <a href="https://flutter.io/docs/development/accessibility-and-localization/internationalization">the official guide</a> to localization. 

There are two mistakes that can be made when implementing localization for the first time following the official flutter localization tutorials. 

1. Using the incorrect context
2. Using the incorrect imports

Get either of these wrong and when you try to get your strings you get a exception on a null object. 

We'll cover how to implement localization in five easy steps, and how to avoid / fix both the above pitfalls. 

You can get the full project and source from <a href="https://github.com/billylev/flutter_localization">github</a>

### Step one - add the localization files to assets

Create an assets folder and place your language file into a locale folder. In this example we are supporting english and spanish. 

```
+-- assets
    +-- locale
        +-- localization_en.json
        +-- localization_es.json
```

Inside the localization file put in the translations :-

```
{
  "title": "Localization Demo",
  "page_one": "Page one",
  "page_two": "Page two",
  "page_three": "Page three"
}
```

### Step two - add the flutter localization dependencies

Open pubspec.yaml file and add in the flutter_localizations, and the json assets. 

```
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # To add assets to your application, add an assets section, like this:
  # assets:
  assets:
    - assets/locale/localization_en.json
    - assets/locale/localization_es.json
```

### Step three - add a localization.dart file

```
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/services.dart';

class AppLocalizations {

  static final AppLocalizations _singleton = new AppLocalizations._internal();
  AppLocalizations._internal();
  static AppLocalizations get instance => _singleton;

  Map<dynamic, dynamic> _localisedValues;

  Future<AppLocalizations> load(Locale locale) async {
    String jsonContent =
      await rootBundle.loadString("assets/locale/localization_${locale.languageCode}.json";
    _localisedValues = json.decode(jsonContent);
    return this;
  }

  String text(String key) {
    return _localisedValues[key] ?? "$key not found";
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale)  {
    return AppLocalizations.instance.load(locale);
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => true;
}

```

This file declares two classes. AppLocalizations which differs slightly from the official tutorial. AppLocalizations is implemented as a singleton in this version. This is so we can get the strings without the need of a context. 

This avoids our first common mistake, **"Using the incorrect context"**. 

AppLocalizations also loads up the correct json file, and has a function to return the translated strings to the caller. 

AppLocalizationsDelegate, implements a delegate which is used by the flutter classes during setup to create our AppLocalizations. We cover this next. 

### Step four - update the main app to create the localizations

Where the MaterialApp (or WidgetsApp) gets created in your code, add in the extra localization related code as below. 

```
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      localizationsDelegates: [
        const AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('es', ''),
      ],
      localeResolutionCallback:
          (Locale locale, Iterable<Locale> supportedLocales) {
        for (Locale supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode ||
              supportedLocale.countryCode == locale.countryCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      debugShowCheckedModeBanner: false,
      home: Dashboard()
    );
  }
}
```

### Step five - import and fetch the translated string

Note when importing files in dart, you should either use relative paths or use package paths. If you use both you will fall into our second common mistake **"Using the incorrect Imports**. 

In dart, using a package path import

```
import 'package:flutter_localization/localizations.dart';
```

is not equal to, using a relative path import

```
import 'localizations.dart';
```

Personally I prefer the package import, which is also how android studio will import your files if you allow it to do it automatically. 

```
import 'package:flutter/material.dart';
import 'package:flutter_localization/localizations.dart';

class DashboardPage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Center(
          child: new Text(
            AppLocalizations.instance.text('page_one'),
            style: new TextStyle(
              fontSize: 22.00,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
  }
}
```



