# Ansa SDK
## Installation

Open the Podfile file and add ```pod 'AnsaCore'``` line of code under use_frameworks!

## Manually build xcframework

Open the terminal in project folder and run following commands:

###### xcodebuild archive -scheme core -destination="iOS" -archivePath /tmp/xcf/ios.xcarchive -derivedDataPath /tmp/iphoneos -sdk iphoneos SKIP_INSTALL=NO

###### xcodebuild archive -scheme core -destination="iOS Simulator" -archivePath /tmp/xcf/iossimulator.xcarchive -derivedDataPath /tmp/iphoneos -sdk iphonesimulator SKIP_INSTALL=NO

###### xcodebuild -create-xcframework -framework /tmp/xcf/ios.xcarchive/Products/Library/Frameworks/core.framework -framework /tmp/xcf/iossimulator.xcarchive/Products/Library/Frameworks/core.framework -output AnsaCore.xcframework -allow-internal-distribution

## How to use 

First, initialize the new payment session which will create a temporary client secret (expires after 24 hours) to communicate with the Ansa API.

After the initializing payment session and obtaining the client secret key, initialize the AnsaCore SDK with the following:

```sh
AnsaCore.initialize(clientSecretKey: "CLIENT_SECRET_KEY") {
        let paymentRequest = PaymentRequest()
        paymentRequest.customerId = "CUSTOMER_ID"
        paymentRequest.totalAmount = TOTAL_AMOUNT_IN_CENTS
        
        navigationController?.pushViewController(CardBalanceViewController(paymentRequest: paymentRequest), animated: true)
}
```

As seen, the AnsaCore struct takes two parameters - ```CLIENT_SECRET_KEY``` (which will be used as an authorization for the API calls) and the ```completion handler``` executed after everything necessary is initialized inside the SDK.

Use the ```PaymentRequest``` and its parameters to build the object needed for the running AnsaCore SDK. ```customerId``` and ```totalAmount``` are the only two parameters that are not optional.

If you want to open just the screen for adding new credit card, push the `AddPaymentMethodViewController` which takes `paymentRequest` and `delegate` as parameters.

Implement ```AddPaymentMethodViewControllerDelegate``` will expose one method:
1. ```onNewCreditCardAdded``` (triggered after new credit card has been added successfully) 

Implement ```CardBalanceViewControllerDelegate``` will expose two methods:
1. ```onPaymentCompleted``` (triggered after successful payment. Don't forget to pop the VC from stack) 
2. ```onPayWithApplePay``` (triggered if purchase will be completed with ApplePay. Don't forget to pop the VC from stack)

If chosen to complete the payment with the ApplePay, you will need to add ApplePay capability to your project.

After completing the payment and obtaining the ApplePay token, create new ```ApplePaymentToken``` object and make a call to the Ansa API using ```makePayment``` method:

```swift
AnsaCore.makePayment(forCustomerId customerId: String, amount: Int, applePayToken: ApplePaymentToken, _ handler: @escaping (Result<Void, AnsaNetworkError>) -> Void)
```
`customerId` - id of the customer
`amount` - amount to pay
`applePayToken` - newly created ApplePaymentToken object
`handler` - callback triggered after success/failure response from Ansa API

## Exposed SDK methods

```swift
AnsaCore.getCustomer(id: String) async -> Result<Customer, AnsaNetworkError>
```
`customerId` - id of the customer
`Customer` - object returned in case of successful API call
`AnsaNetworkError` - object returned in case of failed API call

```swift
AnsaCore.addFunds(_ funds: AddFundsDto, forCustomerId id: String) async -> Result<Funds, AnsaNetworkError>
```
`funds` - object for creating API call body
`id` - id of the customer
`Funds` - object returned in case of successful API call
`AnsaNetworkError` - object returned in case of failed API call

```swift
AnsaCore.useFunds(_ funds: UseFundsDto, forCustomerId id: String) async -> Result<Funds, AnsaNetworkError>
```
`funds` - object for creating API call body. For triggering reloadAndUseFunds API, just populate the `reloadInfo` parameter in `UseFundsDto` object.
`id` - id of the customer
`Funds` - object returned in case of successful API call
`AnsaNetworkError` - object returned in case of failed API call

```swift
AnsaCore.getPaymentMethods(forCustomerId id: String) async -> Result<PaymentMethodResponse, AnsaNetworkError>
```
`id` - id of the customer
`PaymentMethodResponse` - object returned in case of successful API call
`AnsaNetworkError` - object returned in case of failed API call

Customization of the SDK is available and you can use following parameters for that:
1. ```buttonColorEnabled``` - color of enabled button
2. ```buttonColorDisabled``` - color of enabled button 
3. ```cardBackgroundColor``` - background color of credit score card
4. ```buttonTitleColorEnabled``` - color of button's title when button is enabled
5. ```buttonTitleColorDisabled``` - color of button's title when button is disabled
6. ```errorLabelColor``` - color of error label (if credit card input parameter is invalid)
7. ```hintLabelColor``` - color of TextField hint
8. ```addNewCardText``` - default is "Add new card"