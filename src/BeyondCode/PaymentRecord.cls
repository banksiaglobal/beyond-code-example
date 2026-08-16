Class BeyondCode.PaymentRecord Extends %Persistent
{

Property Order As BeyondCode.OrderRecord [ Required ];

Property Amount As %Integer [ Required ];

Property Status As %String(VALUELIST = ",accepted,succeeded") [ Required ];

Property ProviderPaymentId As %String [ Required ];

Index ProviderPaymentIdIndex On ProviderPaymentId;

}
