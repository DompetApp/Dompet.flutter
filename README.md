# Dompet

<p align="center">
  <img 
    style="width: 99%; margin: 0 auto;" 
    src="https://linpengteng.github.io/resource/dompet-app/design.png" 
    alt="Dompet App"
  >
</p>

- Thanks to the Pixso community for providing the design draft ([しょうた](https://pixso.cn/community/file/OKp9_CF9BjALdzxa2W-3UA)).
- A Digital Wallet App implemented by Flutter.

<br/>

## Please note

- Since Firebase authentication is used, VPN is required in China to log in
- But now we have a guest mode that allows you to log in without VPN

<br/>

## Features

- Support logging in as guest mode without using VPN in China
- Support sign-on with github or google via firebase authentication
- Support App to record and view running logs (based on logger extension)
- Support App to simulate payment, transfer, recharge and message by sqlite
- Support App to access Web pages, and provide device interaction and debugging
- Support App to implement simple chart interaction (line chart) by fl_chart
- Support adapt to date formats in different regions (eg. US: October 3, 2024)
- Support display different formats of amount (eg. USD 200,100、 $200,100.00)
- Support adapt to different device screens (eg. vw、 vh、 wmax、wdp、 sr)

<br/>

## Packages

- flutter_ringtone_player
- flutter_inappwebview
- permission_handler
- auto_size_text
- google_sign_in
- firebase_core
- firebase_auth
- path_provider
- synchronized
- fluttertoast
- image_picker
- get_storage
- share_plus
- fl_chart
- sqflite
- convert
- crypto
- logger
- intl
- path
- dio
- get (^5.x)

<br/>

## Renderings

- https://linpengteng.github.io/resource/dompet-app/app.gif

<br/>

## License

- Apache-2.0 license

<br/>
