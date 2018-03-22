# Masternode Setup Guide

This guide covers installing and  settings Masternode with Sentinel onto Ubuntu 14.04 / 16.04 / 17.10. Follow the simple step-by-step guide below. 

### 1. Download and run wallet

Download and run wallet [from releases](https://github.com/CelerCoin/celer/releases).
Now you need pay 1000 CELER to yourself. Make sure you have a little more than 1000 CELER in your balance. It can just be 1001 CELER. When you make
transaction you pay a small fee, this is the reason why you need
a little more than 1000 CELER.

How to make transaction:
- Go to **File** -> **Receiving Addresses**.
- Click on **New** and give label name, something like
**MN** and click **Ok**. Select the created address and click
**Copy**.
- On main wallet window go to **Send** tab. Paste the copied
address to address box. Type **1000** for **Amount** box. **Do not select "Subtract fee from amount" checkbox!**. Send the coin.
- Now it will take some time until this transaction will receive minimum **15** confirmations.
- While the transaction will receive confirmations move to your VPS.

### 2. Masternode and Sentinel Installation

We recommend [Digitalocean](http://digitalocean.com), [Vultr](https://www.vultr.com) or [Linode](https://www.linode.com) for your VPS and Ubuntu x64 OS. Login onto your VPS server as a **root** and run following commands from console:

    $ apt-get install -y wget

    $ wget https://raw.githubusercontent.com/CelerCoin/MasterNode-Setup/master/install.sh

    $ chmod +x install.sh

    $ ./install.sh

Installation take some time, wait until you see message
>**MASTERNODE AND SENTINEL SUCCESSFULLY INSTALLED AND STARTED**.
Also masternode private key will be printed like that
>**MASTERNODE PRIVATE KEY: 462VdwnMk3EwcSxN8RoE4W8UoK0SgEtpN3KsIs6oub3W6byHLyvE1k**.
Save the **your** masternode private key, you will use it later.

### 3. Setting masternode config for local wallet

Return to your wallet in your PC. Make sure that your transction to yourself has minimum 15 confirmations. If so then
- Go to **Tools** -> **Debug console**
- In text run the following command **masternode outputs**
- It should print something like that
    >{ **"419f1abe19ck9012c41ac58g1a2eb7e903lEw860e4280f6a383bce93519368Dde": "1"** }
- The long string is **collateral_output_txid** of your payment and the number is **collateral_output_index**. You will use them shortly.
- Go to **Tools** -> **Open Masternode Configuration File**. It will open masternode.conf file.
- At the end of file add you data in the next format:
    >**alias VPS_IP:13737 masternodeprivkey collateral_output_txid collateral_output_index**
    >eg
    >**MN1 123.123.123.123:13737 462VdwnMk3EwcSxN8RoE4W8UoK0SgEtpN3KsIs6oub3W6byHLyvE1k 419f1abe19ck9012c41ac58g1a2eb7e903lEw860e4280f6a383bce93519368Dde 1**
- Each data is separated by space, so do not introduce any space yourself. Remember that **collateral_output_txid** and **collateral_output_index** do not contain any quotes.
- Save and close the config file. 
- Go to **Settings** -> **Options** (or **celer-qt** -> **Preferences** in macOS) -> **Wallet** and select checkbox **Show Masternodes Tab** and click **OK**. Then restart the wallet.
- Go to **Masternodes** tab. You should see on **My Masternodes** tab your configured masternode as missing. Click on **Start All**. Now you should see your masternode as **Pre_Enabled** or **Enabled** If so, you are all set. Masternode will start getting rewards immediatly.

