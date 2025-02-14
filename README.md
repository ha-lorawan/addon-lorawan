# Home Assistant LoRaWAN Add-on

> [!WARNING]  
> This add-on is a work in progress and is not yet ready for general use.

## Requirements
- [RAK WisGate Developer Base - RAK7271 or RAK7371](https://store.rakwireless.com/products/wisgate-developer-base?srsltid=AfmBOopXkQDyqq3tEIFsuDUnioYvLEW8XTG2Pn1TgxHLK3eiVgRcaFjX&variant=39942858703046)

## Installing
1. Click the link below to open up the add-on store in your Home Assistant dashboard.  
[![Open your Home Assistant instance and show the add-on store.](https://my.home-assistant.io/badges/supervisor_store.svg)](https://my.home-assistant.io/redirect/supervisor_store/)  
2. Click the menu icon ![menu](image.png) in the top right corner and select "Repositories". 
3. Add the following URL: `https://github.com/ha-lorawan/addon-lorawan` and click "Add".  
4. Click "Close" and then refresh the page.
5. Find the `Home Assistant LoRaWAN Add-on` section in click on the `LoRaWAN Add-on`.
6. Click on the "INSTALL" button.
7. Make sure your `RAK WisGate Developer Base` is connected to your Home Assistant computer via USB.  
    - Make sure you have the correct region selected in the Configuration tab.  
    - If you change the region, make sure to restart the add-on.  
8. Click on the "START" button.
9. Navigate to `http://homeassistant.local:8080/` in your browser to access the add-on.  
    a. The default login is `admin` and the default password is `admin`.