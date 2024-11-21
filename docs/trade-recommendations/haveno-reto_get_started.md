## Get started on Haveno-reto

### 1. Launching Haveno

![Image](../resources/img/haveno-ui/startup.png)
/// caption
Nothing to do expect launching the app and waiting for all services initalized
///


![Image](../resources/img/haveno-ui/home.png)
/// caption
Once all services are ready, the market will be shown.
///

### 2. Backup your seed and setup a trading account

Go in `Account` and click on `Seed` tab to backup your main wallet.
![Image](../resources/img/haveno-ui/save_seed.png)

You also can set a wallet password for additionnal security
![Image](../resources/img/haveno-ui/password_wallet.png)

Trading needs an account for the payment method and currency used to take and publish offers, it also ensure data integrity and protects against evil actors trying to use stolen accounts.
![Image](../resources/img/haveno-ui/create_trading_account.png)

### 3. Trading
In this tutorial we simply explain how to trade on Haveno, for technical documentation of the trading protocol, see the [linked page](../the-project/trade-protocol.md)

### 3.1 Create, fund and publish your offer (maker)

Go in the market you want to trade (in our example selling Monero for Bitcoin) and click on `create offer to sell XMR`
![Image](../resources/img/haveno-ui/create_offer.png)

You can set an optional minimum of XMR to buy, if you want flexible sizes to be accessible and setting a fixed price or a % derivation (below or above the market price) before clicking on "next step".
![Image](../resources/img/haveno-ui/price_fluctuation_or_fixed_price.png)

After the offer is set, you need to fund your trade offer with a security deposit worth 15% of the trade (as shown earlier) before placing your offer.
In our case since we sell we technically need 115% of the trade.
![Image](../resources/img/haveno-ui/place_offer.png)

It is generally advised to externally fund your trade so you'll need to wait for block confirmations, balance is shown as **pending** until the external deposit reached 10 block confirmations and you will have the possibility to click on `Place offer to buy BTC` when funds will be shown in **available balance**.
![Image](../resources/img/haveno-ui/wait_for_confirm_funding.png)

Confirm placing your offer, you can take your TradeID to share it privately to someone or reviewing the summary before confirming.
![Image](../resources/img/haveno-ui/confirm:placeoffer.png)

Now the offer is published, you can disable it if you wont be available or for activating it to people you know only.
![Image](../resources/img/haveno-ui/deactivate_offer.png)

### 3.2 Find and take an offer (taker)

As a taker, go in the market you want and take an offer.
![Image](../resources/img/haveno-ui/searchoffer.png)

Or filter TradeIDs / peer hidden-service to take specific offers.
![Image](../resources/img/haveno-ui/filteroffer.png)

Set a custom amount if the maker allows or if you need it, click on next step.
![Image](../resources/img/haveno-ui/takeoffer.png)

Fund your trade with a 15% security deposit and click on next step.
![Image](../resources/img/haveno-ui/fundtookoffer.png)

Confirm taking the offer and it will initiate the trade.
![Image](../resources/img/haveno-ui/takeofferprocess.png)

### 3.3 Trading steps

Once the trade is setup, go in open offers and click on your trade. To get the trading chat for contacting your peer, click on the chat icon.
![Image](../resources/img/haveno-ui/opened_trade.png)
/// caption
Peers need to wait 10 confirmations before trading (chain re-org protection)
///

In our example the taker buy XMR so marking payment sent once BTC funds are sent to the maker.
![Image](../resources/img/haveno-ui/tradetakermarkpaymentsent.png)

The seller (maker in our case) receive the payment notification.
![Image](../resources/img/haveno-ui/makerreceivesnotificationpaymentsent.png)

The maker clicks on confirm receiving the payment after having verified it.
![Image](../resources/img/haveno-ui/makermarkconfirmation.png)

After the payment has been confirmed as received, both peers can close the trade and funds will be paid-out to their main wallets.
![Image](../resources/img/haveno-ui/makerclosetrade.png)
