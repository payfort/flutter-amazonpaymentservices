# flutter_amazonpaymentservices

Amazon Payment Service Sdk Flutter package

## Installation

Add below lines to your package’s pubspec.yaml file:

```
dependencies: flutter_amazonpaymentservices: 0.0.7
```
<br>

#### Android

No additional steps required

#### IOS

The SDK build for >= iOS 10.0, so you need to set the platform version in the Podfile to iOS 10 or above.

```
platform: :ios, '10.0'
```
<br>

## Usage

### Standard Checkout

<br>

```
var requestParam = {
	"amount": 100,
	"command": "AUTHORIZATION",
	"currency": "USD",
	"customer_email": "test@gmail.com",
	"language": "en",
	"merchant_reference": "your merchant reference",
	"sdk_token": "sdk token generated per transaction"
}; 

try {
	result = await FlutterAmazonpaymentservices.normalPay( requestParam, EnvironmentType.production, isShowResponsePage: true);
} on PlatformException catch (e) 
{
	print("Error ${e.message} details:${e.details}"); return;
}

print("Success ${ result}");
```
<br>

### Validate

```
Future<void> validateApi() async { 
	var requestParam = {
		"amount": 100,
		"command": "AUTHORIZATION",
		"currency": "USD",
		"customer_email": "test@gmail.com",
		"language": "en",
		"merchant_reference": "your merchant reference",
		"sdk_token": "sdk token generated per transaction"
	}; 
	try {
		result = await FlutterAmazonpaymentservices.validateApi(
			requestParam,
			EnvironmentType.production, 
			);
	} on PlatformException catch (e) {
		print("Error ${e.message} details:${e.details}"); return;
	}
	print("Success ${result}"); 
}
```

<br>
<hr/>


### Request Parameters (FortRequestObject)

| Attribute            | Type         | Description                                                                                                                                                                                                                                                                        | Mandatory | Maximum | Example                                                               |
|----------------------|--------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|---------|-----------------------------------------------------------------------|
| command              | Alpha        | Command.<br>Possible/ expected values: AUTHORIZATION, PURCHASE                                                                                                                                                                                                                     | Yes       | 20      | PURCHASE                                                              |
| merchant_reference   | Alphanumeric | The Merchant’s unique order number.                                                                                                                                                                                                                                                | Yes       | 40      | XYZ9239-yu898                                                         |
| amount               | Numeric      | The transaction’s amount. *Each currency has predefined allowed decimal points that should be taken into consideration when sending the amount                                                                                                                                     | Yes       | 10      | 10000                                                                 |
| currency             | Alpha        | The currency of the transaction’s amount in ISO code 3.                                                                                                                                                                                                                            | Yes       | 3       | AED                                                                   |
| language             | Alpha        | The checkout page and messages language.<br>Possible/ expected values: en/ ar                                                                                                                                                                                                      | Yes       | 2       | en                                                                    |
| customer_email       | Alphanumeric | The customer’s email.<br>Special characters: _ - . @ +                                                                                                                                                                                                                             | Yes       | 254     | customer@domain.com                                                   |
| sdk_token            | Alphanumeric | An SDK Token to enable using the Amazon Payment Services Mobile SDK.                                                                                                                                                                                                               | Yes       | 100     | Dwp78q3                                                               |
| token_name           | Alphanumeric | The Token received from the Tokenization process.<br>Special characters: . @ - _                                                                                                                                                                                                   | No        | 100     | Op9Vmp                                                                |
| payment_option       | Alpha        | Payment option.<br>Possible/ expected values:<br>- MASTERCARD<br>- VISA<br>- AMEX<br>- MADA (for Purchase operations and eci Ecommerce only) Click here to download [MADA Branding Document](https://paymentservices-reference.payfort.com/pdf/mada%20branding%20-%20ecommerce%20merchant%20-%20payment%20providers.pdf)  <br>- MEEZA (for Purchase operations and ECOMMERCE eci only) | No        | 10      | VISA                                                                  |
| eci                  | Alpha        | Ecommerce indicator.<br>Possible/ expected values: ECOMMERCE                                                                                                                                                                                                                       | No        | 150     | ECOMMERCE                                                             |
| order_description    | Alphanumeric | A description of the order.<br>Special characters:'/ . _ - # : $ Space                                                                                                                                                                                                             | No        | 150     | iPhone 6-S                                                            |
| customer_ip          | Alphanumeric | It holds the customer’s IP address. *It’s Mandatory, if the fraud service is active. *We support IPv4 and IPv6 as shown in the example below.                                                                                                                                      | No        | 45      | IPv4 → 192.178.1.10<br>IPv6 → 2001:0db8:3042:0002:5a55:caff:fef6:bdbf |
| customer_name        | Alpha        | The customer’s name.<br>Special characters: _ \ / - .'                                                                                                                                                                                                                             | No        | 40      | John Smith                                                            |
| phone_number         | Alphanumeric | The customer’s phone number.<br>Special characters: + - ( ) Space                                                                                                                                                                                                                  | No        | 19      | 00962797219966                                                        |
| settlement_reference | Alphanumeric | The Merchant submits unique value to Amazon Payment Services. The value is then passed to the Acquiring bank and displayed to the merchant in the Acquirer settlement file.                                                                                                        | No        | 34      | XYZ9239-yu898                                                         |
| merchant_extra1      | Alphanumeric | Extra data sent by merchant. Will be received and sent back as received. Will not be displayed in any report.                                                                                                                                                                      | No        | 250     | JohnSmith                                                             |
| merchant_extra2      | Alphanumeric | Extra data sent by merchant. Will be received and sent back as received. Will not be displayed in any report.                                                                                                                                                                      | No        | 250     | JohnSmith                                                             |
| merchant_extra3      | Alphanumeric | Extra data sent by merchant. Will be received and sent back as received. Will not be displayed in any report.                                                                                                                                                                      | No        | 250     | JohnSmith                                                             |
| merchant_extra4      | Alphanumeric | Extra data sent by merchant. Will be received and sent back as received. Will not be displayed in any report.                                                                                                                                                                      | No        | 250     | JohnSmith                                                             |
| merchant_extra5      | Alphanumeric | Extra data sent by merchant. Will be received and sent back as received. Will not be displayed in any report.                                                                                                                                                                      | No        | 250     | JohnSmith                                                             |



## License

MIT

